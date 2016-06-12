package lv.enthusiast.learnactors.dynamicAtlas {
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;



	/**
	 * This atlas can be used if you have a composition made in swf, and you want to use it in the starling, then
	 * use this class to specify which instances you want to use from the movieclip and this class wil generate
	 * texture atlas and give you item positioning in the composition
	 * 
	 * Example usage
	 * [Embed(source="assets.swf#atlas")]
		public var AtlasGraphic:Class;

		public function someFunctionName():void {
			var atlas:SwfAtlas = new SwfAtlas();
			atlas.fromMovieClipContainer(new AtlasGraphic(), Vector.<String>(["first_mc", "second_mc"]), .2);
			
			var item:SwfAtlasItem = atlas.getSwfAtlasItem("first_mc");
			var image:Image = new Image(item.texture);
			image.x = item.x;
			image.y = item.y;
			addChild(image);
			
			item = atlas.getSwfAtlasItem("second_mc");
			image = new Image(item.texture);
			image.x = item.x;
			image.y = item.y;
			addChild(image);
			
		}
	 * 
	 * @author JK
	 */
	public class SwfAtlas {
		private const DEFAULT_CANVAS_WIDTH:Number = 640;

		private var _items:Array;
		private var _canvas:Sprite;

		private var _currentLab:String;

		private var _x:Number;
		private var _y:Number;

		private var _bData:BitmapData;
		private var _mat:Matrix;
		private var _margin:Number;
		private var _preserveColor:Boolean;

		private var _positions:Dictionary;
		private var _atlas:TextureAtlas;
		private var _scaleFactor:Number;

		/**
		 * 
		 */
		public function SwfAtlas() {
			_positions = new Dictionary(false);
		}

		// Private methods

		private function appendIntToString(num:int, numOfPlaces:int):String {
			var numString:String = num.toString();
			var outString:String = "";
			for (var i:int = 0; i < numOfPlaces - numString.length; i++) {
				outString += "0";
			}
			return outString + numString;
		}

		private function layoutChildren():void {
			var xPos:Number = 0;
			var yPos:Number = 0;
			var maxY:Number = 0;
			var len:int = _items.length;

			var itm:BitmapItem;

			for (var i:uint = 0; i < len; i++) {
				itm = _items[i];
				if ((xPos + itm.width) > DEFAULT_CANVAS_WIDTH) {
					xPos = 0;
					yPos += maxY;
					maxY = 0;
				}
				if (itm.height + 1 > maxY) {
					maxY = itm.height + 1;
				}
				itm.x = xPos;
				itm.y = yPos;
				xPos += itm.width + 1;
			}
		}

		private function getRealBounds(clip:DisplayObject):Rectangle {
			var bounds:Rectangle = clip.getBounds(clip.parent);
			bounds.x = Math.floor(bounds.x);
			bounds.y = Math.floor(bounds.y);
			bounds.height = Math.ceil(bounds.height);
			bounds.width = Math.ceil(bounds.width);

			var realBounds:Rectangle = new Rectangle(0, 0, bounds.width + _margin * 2, bounds.height + _margin * 2);

			// Checking filters in case we need to expand the outer bounds
			if (clip.filters.length > 0) {
				// filters
				var j:int = 0;
				//var clipFilters:Array = clipChild.filters.concat();
				var clipFilters:Array = clip.filters;
				var clipFiltersLength:int = clipFilters.length;
				var tmpBData:BitmapData;
				var filterRect:Rectangle;

				tmpBData = new BitmapData(realBounds.width, realBounds.height, false);
				filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
				realBounds = realBounds.union(filterRect);
				tmpBData.dispose();

				while (++j < clipFiltersLength) {
					tmpBData = new BitmapData(filterRect.width, filterRect.height, true, 0);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					tmpBData.dispose();
				}
			}

			realBounds.offset(bounds.x, bounds.y);
			realBounds.width = Math.max(realBounds.width, 1);
			realBounds.height = Math.max(realBounds.height, 1);

			tmpBData = null;
			return realBounds;
		}

		/**
		 * drawItem - This will actually rasterize the display object passed as a parameter
		 * @param	clip
		 * @param	name
		 * @param	baseName
		 * @param	clipColorTransform
		 * @param	frameBounds
		 * @return TextureItem
		 */
		private function drawItem(clip:DisplayObject, name:String = "", clipColorTransform:ColorTransform = null, frameBounds:Rectangle = null):BitmapItem {
			var realBounds:Rectangle = getRealBounds(clip);

			_bData = new BitmapData(realBounds.width, realBounds.height, true, 0);
			_mat = clip.transform.matrix;
			_mat.translate(-realBounds.x + _margin, -realBounds.y + _margin);

			_bData.draw(clip, _mat, _preserveColor ? clipColorTransform : null);

			var label:String = "";
			if (clip is MovieClip) {
				if (clip["currentLabel"] != _currentLab && clip["currentLabel"] != null) {
					_currentLab = clip["currentLabel"];
					label = _currentLab;
				}
			}

			if (frameBounds) {
				realBounds.x = frameBounds.x - realBounds.x;
				realBounds.y = frameBounds.y - realBounds.y;
				realBounds.width = frameBounds.width;
				realBounds.height = frameBounds.height;
			}

			var item:BitmapItem = new BitmapItem(_bData, name, label, realBounds.x, realBounds.y, realBounds.width, realBounds.height);

			_items.push(item);
			_canvas.addChild(item);


			_bData = null;

			return item;
		}

		/**
		 * This method will take a MovieClip sprite sheet (containing other display objects) and convert it into a Texture Atlas.
		 *
		 * @param	swf:MovieClip - The MovieClip sprite sheet you wish to convert into a TextureAtlas. I must contain named instances of every display object that will be rasterized and become the subtextures of your Atlas.
		 * @param	isntanceNames:Vector<String> - list of instance names that will be converted to textures
		 * @param	scaleFactor:Number - The scaling factor to apply to every object. Default value is 1 (no scaling).
		 * @param	margin:uint - The amount of pixels that should be used as the resulting image margin (for each side of the image). Default value is 0 (no margin).
		 * @param	preserveColor:Boolean - A Flag which indicates if the color transforms should be captured or not. Default value is true (capture color transform).
		 * @param 	checkBounds:Boolean - A Flag used to scan the clip prior the rasterization in order to get the bounds of the entire MovieClip. By default is false because it adds overhead to the process.
		 */
		public function fromMovieClipContainer(swf:Sprite, instanceNames:Vector.<String>, scaleFactor:Number = 1, margin:uint = 0, preserveColor:Boolean = true, checkBounds:Boolean = false):void {
			_scaleFactor = scaleFactor;
			var selected:DisplayObject;
			var selectedColorTransform:ColorTransform;
			var frameBounds:Rectangle = new Rectangle(0, 0, 0, 0);

			var numInstances:uint = instanceNames.length;

			var canvasData:BitmapData;

			var texture:Texture;
			var xml:XML;
			var subText:XML;

			var itemsLen:int;
			var itm:BitmapItem;

			var m:uint;

			_margin = margin;
			_preserveColor = preserveColor;

			_items = [];

			if (!_canvas)
				_canvas = new Sprite();

			if (swf is MovieClip)
				MovieClip(swf).gotoAndStop(1);

			for (var i:uint = 0; i < numInstances; i++) {
				selected = swf.getChildByName(instanceNames[i]);
				if (!selected) {
					continue;
				}
				selectedColorTransform = selected.transform.colorTransform;
				_x = selected.x;
				_y = selected.y;

				var bounds:Rectangle = selected.getBounds(swf);
				_positions[instanceNames[i]] = {x: bounds.x * scaleFactor, y: bounds.y * scaleFactor};

				// Scaling if needed (including filters)
				if (_scaleFactor != 1) {
					selected.scaleX *= _scaleFactor;
					selected.scaleY *= _scaleFactor;

					if (selected.filters.length > 0) {
						var filters:Array = selected.filters;
						var filtersLen:int = selected.filters.length;
						var filter:Object;
						for (var j:uint = 0; j < filtersLen; j++) {
							filter = filters[j];

							if (filter.hasOwnProperty("blurX")) {
								filter.blurX *= _scaleFactor;
								filter.blurY *= _scaleFactor;
							}
							if (filter.hasOwnProperty("distance")) {
								filter.distance *= _scaleFactor;
							}
						}
						selected.filters = filters;
					}
				}
				
				
				if (selected is MovieClip)
				{
					var selectedTotalFrames:int;
					selectedTotalFrames = MovieClip(selected).totalFrames;
					// Gets the frame bounds by performing a frame-by-frame check
					if (checkBounds) {
						MovieClip(selected).gotoAndStop(1);
						frameBounds = getRealBounds(selected);
						m = 1;
						while (++m <= selectedTotalFrames)
						{
							MovieClip(selected).gotoAndStop(m);
							frameBounds = frameBounds.union(getRealBounds(selected));
						}
					}
				}
				else {
					selectedTotalFrames = 1;
				}
				
				m = 1;
				// Draw every frame (if MC - else will just be one)
				while (m <= selectedTotalFrames)
				{
					if (selected is MovieClip)
						MovieClip(selected).gotoAndStop(m);
					drawItem(selected, selected.name + "_" + appendIntToString(m, 5), selectedColorTransform, frameBounds);
					m++;
				}
				

				//drawItem(selected, selected.name, selectedColorTransform, frameBounds);
			}

			_currentLab = "";

			layoutChildren();

			for (var l:uint = 0; l < numInstances; l++) {
				selected = swf.getChildByName(instanceNames[l]);
				selected.scaleX /= _scaleFactor;
				selected.scaleY /= _scaleFactor;
			}

			canvasData = new BitmapData(_canvas.width, _canvas.height, true, 0x000000);
			canvasData.draw(_canvas);

			xml = new XML(<TextureAtlas></TextureAtlas>);
			xml.@imagePath = "atlas.png";

			itemsLen = _items.length;

			for (var k:uint = 0; k < itemsLen; k++) {
				itm = _items[k];

				itm.graphic.dispose();

				// xml
				subText = new XML(<SubTexture />);
				subText.@name = itm.textureName;
				subText.@x = itm.x;
				subText.@y = itm.y;
				subText.@width = itm.width;
				subText.@height = itm.height;
				subText.@frameX = itm.frameX;
				subText.@frameY = itm.frameY;
				subText.@frameWidth = itm.frameWidth;
				subText.@frameHeight = itm.frameHeight;

				if (itm.frameName != "")
					subText.@frameLabel = itm.frameName;
				xml.appendChild(subText);
			}
			texture = Texture.fromBitmapData(canvasData);
			_atlas = new TextureAtlas(texture, xml);

			_items.length = 0;
			_canvas.removeChildren();

			_items = null;
			xml = null;
			_canvas = null;
			_currentLab = null;
		}

		/**
		 * Returns starling TextureAtlas used by SwfAtlas
		 * @return 
		 */
		public function get atlas():TextureAtlas {
			return _atlas;
		}

		/**
		 * Returns SwfAtlasItem which contains texture and position of an element on the stage
		 * @param name Name of swf instance that was specified in fromMovieClipContainer() instanceNames parameter
		 * @return SwfAtlasItem with requested details or null if atlas has not been initialized or texture does not exist
		 */
		public function getSwfAtlasItem(name:String, frame:int = 1):SwfAtlasItem {
			if (atlas == null) {
				trace("SwfAtlas::getSwfAtlasItem atlas is not initizlied yet. Probably an error.");
				return null; // not imitalized
			}

			var texture:Texture = _atlas.getTexture(name + "_" + appendIntToString(frame, 5));
			if (texture == null) {
				trace("SwfAtlas::getSwfAtlasItem can not find such texture " + name + ". Probably an error.");
				return null; // no such texture
			}

			var swfAtlasItem:SwfAtlasItem = new SwfAtlasItem();
			swfAtlasItem.texture = texture;
			swfAtlasItem.x = _positions[name].x;
			swfAtlasItem.y = _positions[name].y;
			swfAtlasItem.frame = frame;

			return swfAtlasItem;
		}

		/**
		 * Returns scale factor which was set while fromMovieClipContainer() was called
		 * @return 
		 */
		public function get scaleFactor():Number {
			return _scaleFactor;
		}
	}
}
