package lv.enthusiast.learnactors.display  {
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	/**
	 * ...
	 * @author CyberProdigy
	 */
	public class AbstractSprite extends Sprite {
		
		// [ Class variables ]
		protected var _availableWidth:Number = 0;
		protected var _availableHeight:Number = 0;

		public function AbstractSprite() {
			_availableWidth = actualWidth;
			_availableHeight = actualHeight;
		}
		
		public function removeChildCheck(child:DisplayObject):Boolean {
			if(child != null && child.parent == this)
			{
				this.removeChild(child);
				return true;
			}
			return false;
		}	
		
		
		protected function resizeLayout():void {
			/*try {
				graphics.clear();
				graphics.beginFill(Math.round(Math.random() * 0xFFFFFF), .2);
				graphics.drawRect(0, 0, _availableWidth, _availableHeight);
				//graphics.drawRect(5, 5, _availableWidth - 10, _availableHeight - 10);
				graphics.endFill();
			}
			catch (e:Object) {
				
			}*/
			
			// to be overriden
		}

		
		/**
		 * Call this function better if you need to set botth - width and height, rather than doing two calls for width and height seperately,
		 * because each call might cause layout to resize if they are when render frame happens in between. Calling resize(), will resize layout once, nice and smooth, the way it is supposed to be.
		 */
		public function resize(w:Number, h:Number):void {
			_availableWidth = w;
			_availableHeight = h;
			resizeLayout();
		}
		
		// [ Setters & getters ]
		override public function set height(value:Number):void {
			if(_availableHeight != value) {
				_availableHeight = value;
				resizeLayout();
			}
		}
		
		override public function set width(value:Number):void {
			if(_availableWidth != value) {
				_availableWidth = value;
				resizeLayout();
			}
		}
		
		override public function get height():Number { 
			return _availableHeight; 
		}
		
		override public function get width():Number{
			return _availableWidth;
		}
		
		public function get availableWidth():Number { 
			return _availableWidth; 
		}
		
		public function get availableHeight():Number { 
			return _availableHeight; 
		}
		
		public function get actualWidth():Number {
			return super.width;
		}
		
		public function get actualHeight():Number {
			return super.height;
		}
		
		
	}

}