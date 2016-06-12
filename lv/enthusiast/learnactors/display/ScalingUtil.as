package lv.enthusiast.learnactors.display {
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	
	public class ScalingUtil {
		
		
		/**
		 * Target will be scaled proportionally to occupy as much space from area as possible. If target is an asset with masks, you can pass in targetVisiblebounds, you can obtain from DisplayObjectUtils.getVisibleBounds()
		 * @param	target the object that needs to be scaled and moved to the center of area
		 * @param	area the rectangle against which positioning and scaling is calculated
		 * @param	targetVisibleBounds, optional parameter, if target is bigger than visible area. Could be caused if there are masks inside the asset
		 */
		private static var rct:Rectangle = new Rectangle(); // reusing rectangle. No need to create new one everytime
		public static function occupyArea(target:DisplayObject, area:Rectangle, targetVisibleBounds:Rectangle = null):void {
			if (targetVisibleBounds == null) {
				rct.x = 0;
				rct.y = 0;
				rct.width = target.width;
				rct.height = target.height;
				
				targetVisibleBounds = rct;
			}
			
			var availableAreaRatio:Number = area.width / area.height;
			var mcRatio:Number = targetVisibleBounds.width / targetVisibleBounds.height;
			
			var targetScale:Number
			if (mcRatio > availableAreaRatio) {
				targetScale = area.width / targetVisibleBounds.width;
			} else {
				targetScale = area.height / targetVisibleBounds.height;
			}
			
			target.x = ((area.width - (targetVisibleBounds.width * targetScale)) / 2) - (targetVisibleBounds.left * targetScale) + area.left;
			target.y = ((area.height - (targetVisibleBounds.height * targetScale)) / 2) - (targetVisibleBounds.top * targetScale) + area.top;
			target.scaleY = target.scaleX = targetScale;
		}
		
		public static function stretchToArea(target:DisplayObject, area:Rectangle, padding:* = null):void {
			if (padding is Array) {
				area.y += padding[0];
				area.width -= padding[1] + padding[3];
				area.height -= padding[0] + padding[2];
				area.x += padding[3];
			}
			else {
				var padNumber:Number = padding as Number;
				area.x += padding;
				area.y += padding;
				area.width -= padding*2;
				area.height -= padding*2;
			}
			
			target.x = area.x;
			target.y = area.y;
			target.width = area.width;
			target.height = area.height;
		}
		
		public static function proportionalScaleUp(displayObject:*, maxWidth:Number, maxHeight:Number):void {
			if (!displayObject) {
				return; // nothing to do here
			}
			
			var sc:Number =  calculateScaleupScale(displayObject, maxWidth, maxHeight);
			if(sc == 0) { 
				return; // avoiding extremes. Display object is empty
			}
			
			displayObject.scaleX = displayObject.scaleY = sc;
		}
		
		public static function calculateScaleupScale(displayObject:*, maxWidth:Number, maxHeight:Number):Number {
			var dobUnscaledWidth:Number = displayObject.width / displayObject.scaleX;
			var dobUnscaledHeight:Number = displayObject.height / displayObject.scaleY;
			if (dobUnscaledWidth == 0 || dobUnscaledHeight == 0 || maxWidth <= 0 || maxHeight <= 0)
				return 0; // avoiding extremes.
				
			return calculateMaxScale(dobUnscaledWidth, dobUnscaledHeight, maxWidth, maxHeight);
			
		}
		
		public static function calculateMaxScale(w:Number, h:Number, maxWidth:Number, maxHeight:Number):Number {
			var dobRatio:Number = w / h;
			var maxRatio:Number = maxWidth / maxHeight;
			var sc:Number = 1;
			if (dobRatio > maxRatio) {
				sc = maxWidth / w;
			} else {
				sc = maxHeight / h;
			}
			
			return sc;

		}
		

		/**
		 * Consider using floatInContainer
		 */
		public static function floatRelativeTo(target:DisplayObject, relativeTo:DisplayObject, direction:String, padding:int):void {
			switch (direction) {
				case "left": 
					target.x = relativeTo.x + padding;
					break;
				case "right": 
					target.x = relativeTo.x + relativeTo.width - target.width - padding;
					break;
				case "bottom": 
					target.y = relativeTo.y + relativeTo.height - target.height - padding;
					break;
				case "top": 
					target.y = relativeTo.y + padding;
					break;
				case "horizontalCenter":
					target.x = relativeTo.x + ((relativeTo.width - target.width)/2);
					break;
				case "verticalCenter":
					target.y = relativeTo.y + ((relativeTo.height- target.height)/2);
					break;
				default:
					throw(new Error( direction + " not implemented"));
			}
		}
		
		/**
		 * Consider using this function if you have to stack more than 3 elements.
		 * @param	targets Array of targets to position
		 * @param	alignTo
		 * @param	direction
		 * @param	padding
		 */
		public static function alignAll(targets:Array, alignTo:DisplayObject, direction:String, padding:int):void {
			var property:String;
			var value:Number;
			
			switch (direction) {
				case "top":
					property = "y";
					value = alignTo.y + padding;
					break;
				case "left":
					property = "x";
					value = alignTo.x + padding;
					break;	
				case "middle":
					property = "y";
					value = (alignTo.y + alignTo.height/2) - targets[i].height/2;
					break;
				case "bottomCenter":
					property = "x";
					value = (alignTo.x + alignTo.width/2) - targets[i].width/2;
					break;
				default:
					throw(new Error( direction + " not implemented"));
			}
			
			for (var i:int = 0; i < targets.length; i++) 
			{
				targets[i][property] = value;
			}
		}
		
		
		
		/**
		 * Positions target Object in a container Object
		 */
		public static function floatInContainer(target:Object, container:Object, direction:String, padding:int):void {
			switch (direction) {
				case "left": 
					target.x = 0 + padding;
					break;
				case "bottom": 
					target.y = container.height - target.height - padding;
					break;
				case "top": 
					target.y = padding;
					break;
				case "right": 
					 target.x = container.width - target.width - padding;
					break;
				case "horizontalCenter":
					target.x = (container.width - target.width) / 2;
					break;
				case "verticalCenter":
					target.y = (container.height - target.height) / 2;
					break;
				default:
					throw(new Error( direction + " not implemened"));
			}
		}
		
		public static function matchPosition(target:DisplayObject, matchTo:DisplayObject):void {
			target.x = matchTo.x;
			target.y = matchTo.y;
		}
		
		public static function matchSize(target:DisplayObject, matchTo:DisplayObject):void {
			target.width = matchTo.width;
			target.height = matchTo.height;
		}
		
		
		
		// modify this function if you need to position movieclips with different registration points
		public static function positionInCenter(parentContainer:DisplayObjectContainer, child:DisplayObject, adjustHoizontal:Boolean = true, adjustVertical:Boolean = true, paddings:Array = null):void {
			if (!parentContainer || !child)
				return; // nothimg to do
			
			var finalXOffset:Number = 0
			var finalYOffset:Number = 0
			if (paddings != null && paddings.length == 4) {
				finalXOffset = paddings[3] - paddings[1];
				finalYOffset = paddings[0] - paddings[2];
			}
			if (adjustHoizontal)
				child.x = finalXOffset + (parentContainer.width - child.width) / 2;
			if (adjustVertical)
				child.y = finalYOffset + (parentContainer.height - child.height) / 2;
		}
		
		
		/**
		 * Positions a target DisplayObject on specified side of alignTo DisplayObject 
		 */
		public static function stack(target:DisplayObject, alignTo:DisplayObject, direction:String, padding:int):void {
			if (!target || !alignTo) {
				return;
			}
			
			switch (direction) {
				case "top":
					target.y = alignTo.y - target.height - padding;
					break;
				case "right":
					target.x = alignTo.x + alignTo.width + padding;
					break;
				case "bottom":
					target.y = alignTo.y + alignTo.height + padding;
					break;
				case "left":
					target.x = alignTo.x - target.width - padding;
					break;
				default:
					throw(new Error( direction + " not implemented"));
			}
		}
	}
}