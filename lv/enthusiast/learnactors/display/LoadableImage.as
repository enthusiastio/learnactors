package lv.enthusiast.learnactors.display {
	import com.moviestarplanet.mobile.ui.ScalingUtil;
	import com.moviestarplanet.starlingControlUtils.StarlingScalingUtil;
	import com.moviestarplanet.utils.bitmap.BitmapProducer;
	import com.moviestarplanet.loader.ILoaderUrl;
	import com.moviestarplanet.utils.loader.IMSP_Loader;
	import com.moviestarplanet.utils.loader.RawUrl;
	import flash.display.Loader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	
	public class LoadableImage extends AbstractSprite{
		
		// [ Inject ]
		
		// [ Constants ]
		
		// [ Class variables ]
		public var getVisibleBounds:Boolean;
		public var horizontalContentPosition:int;
		public var contenPosition:String = "left"; // position found in Direction.
		
		private var _bitmapProducer:BitmapProducer;
		private var _onComplete:Function;
		private var _onFail:Function;
		private var _loader:IMSP_Loader;
		private var _renderFrame:int;
		
		
		// [ Items on stage]
		private var _image:Image;
		
		
		public function LoadableImage() {
			getVisibleBounds = false;
		}
		
		public function load(url:String, onComplete:Function, onFail:Function, renderFrame:int=1):void {
			_onComplete = onComplete;
			_onFail = onFail;
			_renderFrame = renderFrame;
			
			_loader = new Loader();
			
			loader.LoadCallBack = onLoaded;
			loader.LoadFailCallBack = onLoadFail;
			loader.LoadUrl(url);
		}
		
		public function destroy():void 
		{
			removeChildren();
			if(_bitmapProducer)
				_bitmapProducer.destroy();
			_bitmapProducer = null;
			_image = null;
		}
		
		/**
		 * This function is expensive. Try not calling it too often.
		 */
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			if (!flashDisplayObject || _availableHeight == 0 || _availableHeight == 0) {
				return;
			}
			
			var sc:Number = ScalingUtil.calculateScaleupScale(flashDisplayObject, _availableWidth, _availableHeight);
			var textureForImage:Texture = Texture.fromBitmapData(_bitmapProducer.getBitmapData(sc));
			if (!_image) {
				_image = new Image(textureForImage);
			}
			else {
				_image.texture = textureForImage;
				_image.width = textureForImage.width;
				_image.height = textureForImage.height;
			}
			switch(contenPosition){
				case "left":
					_image.x = _image.y = 0;
					break;
				case "middleCenter":
					StarlingScalingUtil.floatInContainer(_image, this, "horizontalCenter",0);
					StarlingScalingUtil.floatInContainer(_image, this, "verticalCenter",0);
					break;
				default:
				throw(new Error("Direction not implemented: " + contenPosition));
			}
			addChild(_image);
		}
		
		
		
		private function cleanUp():void {
			_onComplete = null;
			_onFail = null;
		}
	
		// [ Setters & getters ]
		private function onLoaded(ldr:IMSP_Loader):void {
			if (_loader.loadedContents is MovieClip) {
				MovieClip(_loader.loadedContents).gotoAndStop(_renderFrame);
			}
			flashDisplayObject = _loader.loadedContents;
			if (_onComplete != null) {
				_onComplete();
			}
			
			cleanUp();
		}
		
		private function onLoadFail(ldr:IMSP_Loader):void {
			if (_onFail != null) {
				_onFail();
			}
			
			cleanUp();
		}
		
		public function set flashDisplayObject(value:DisplayObject):void 
		{
			if (!_bitmapProducer) {
				_bitmapProducer = new BitmapProducer();
				_bitmapProducer.useGetColorBoundsRect = getVisibleBounds;
			}
			_bitmapProducer.flashDisplayObject = value;
			resizeLayout();
		}
		public function get flashDisplayObject():DisplayObject
		{ 
			if (_bitmapProducer) {
				return _bitmapProducer.flashDisplayObject;
			}
			
			return null;
		}
		
		public function get image():Image {
			return _image; 
		}
		
		// [ Event handlers ]
	
	}

}