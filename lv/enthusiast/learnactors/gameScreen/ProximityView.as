package lv.enthusiast.learnactors.gameScreen {
	
	import flash.display.*;
	import flash.events.*;
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class ProximityView extends AbstractSprite {
		
		// [ Constants ]
		
		// [ Class variables ]
		private var _currentPrc:Number = 0;
		
		// [ Items on stage]
		private var _bg:Quad;
		private var _progress:Quad;
		
		public function ProximityView() {
			_bg = new Quad(1, 1, 0x000000);
			_progress = new Quad(1, 1, 0xFFFFFF);
			addChild(_bg);
			addChild(_progress);
		}
		
		public function setPercent(value:Number):void {
			_currentPrc = value;
			_progress.width = _availableWidth * value;
			_progress.color = getColorFromPrc(value);
		}
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			_bg.width = _availableWidth;
			_bg.height = _availableHeight;
			_progress.width = _currentPrc * _availableWidth;
			_progress.height = _availableHeight;
		}
		
		private function getColorFromPrc(prc:Number):uint {
			if (prc < 0.5) {
				return 0xFF0000;
			}
			prc = (prc - 0.5) * 2;
			var r:int = 0xFF * (1-prc);
			var g:int = 0xFF * prc;
			var c:uint = r;
			c = c << 8;
			c = c + g;
			c = c << 8;
			return c;
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}