package lv.enthusiast.learnactors.display {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * makes bitmap from flash displayobjects
	 * @author jk
	 */
	public class BitmapProducer {
		
		// [ Constants ]
		
		// [ Class variables ]
		private var _flashDisplayObject:DisplayObject;
		private var _bitmapData:BitmapData;
		private var _isFlipped:Boolean;
		private static var _mtx:Matrix = new Matrix();
		
		public var trimContents:Boolean = true;
		public var useGetColorBoundsRect:Boolean = false;
		
		// [ Items on stage]
		
		public function BitmapProducer() {
		
		}
		
		public function set flashDisplayObject(value:DisplayObject):void {
			_flashDisplayObject = value;
		}
		
		public function get flashDisplayObject():DisplayObject {
			return _flashDisplayObject;
		}
		
		public function getBitmapData(scale:Number):BitmapData {
			if (_bitmapData) {
				_bitmapData.dispose();
			}
			_mtx.identity();
			_mtx.scale(scale, scale);
			_bitmapData = new BitmapData(_flashDisplayObject.width * scale, _flashDisplayObject.height * scale, false);
			_bitmapData.draw(_flashDisplayObject, _mtx);
			return _bitmapData;
		}
		
		public function getExactDimensionsBitmapData(w:int, h:int):BitmapData {
			if (_bitmapData)
				_bitmapData.dispose();
				
			var bounds:Rectangle;
			if (useGetColorBoundsRect ) {
				bounds = DisplayConverter.getVisibleBounds(_flashDisplayObject);
			}
			else {
				bounds = _flashDisplayObject.getBounds(_flashDisplayObject);
			}
			
			if (trimContents) {
				_mtx.translate(-bounds.x, -bounds.y);
			} else {
				bounds.x = 0;
				bounds.y = 0;
			}
			
			_bitmapData = new BitmapData(w, h, false, 0xffffff);
			_mtx.identity();
			_mtx.scale(w / bounds.width, h / bounds.height);
			_bitmapData.draw(_flashDisplayObject, _mtx);
			return _bitmapData;
		}
		
		
		public function get isFlipped():Boolean
		{
			return _isFlipped;
		}

		public function set isFlipped(value:Boolean):void
		{
			_isFlipped = value;
		}

		
		public function destroy():void {
			_flashDisplayObject = null;
			if(_bitmapData != null)
				_bitmapData.dispose();
			_bitmapData = null;
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}