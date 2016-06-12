package lv.enthusiast.learnactors.packSelector {
	
	import flash.events.Event;
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import lv.enthusiast.learnactors.display.GameButton;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.display.Styles;
	import starling.core.Starling;
	import starling.display.graphics.RoundedRectangle;
	import starling.display.materials.StandardMaterial;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class DownloadProgess extends AbstractSprite {
		// [ Class variables ]
		private var _progressBarMaxWidth:int;
		
		// [ Items on stage]
		private var _titleTxt:TextField;
		private var _background:RoundedRectangle;
		private var _progress:Quad;
		private var _cancel:GameButton;
		private var _onCancelClick:Function;
		
		public function DownloadProgess(onCancelClick:Function) {
			_onCancelClick = onCancelClick;
			this.resize(Starling.current.stage.width * .9, Starling.current.stage.width * .5);
		}
		
		override protected function resizeLayout():void {
			super.resizeLayout();
			
			var borderRadius:int = _availableWidth / 40;
			_background = new RoundedRectangle(_availableWidth, _availableHeight, borderRadius, borderRadius, borderRadius, borderRadius);
			var bgMat:StandardMaterial = new StandardMaterial();
			bgMat.color = Styles.PROGRESS_BG_COLOR_1;
			_background.material = bgMat;
			
			_progress = new Quad(1, 1, Styles.PROGRESS_PROG_COLOR);
			var padding:int = _availableWidth * 0.04;
			_progress.height = _availableHeight * .1;
			_progress.width = 1;
			_progress.x = padding;
			_progress.y = (_availableHeight - _progress.height) / 2;
			_progressBarMaxWidth = _availableWidth - (padding * 2);
			
			_cancel = new GameButton("Cancel", Styles.BUTTON_DEFAULT_COLOR, _availableWidth / 40);
			_cancel.resize(_availableWidth / 2.5, _availableWidth / 10);
			ScalingUtil.floatRelativeTo(_cancel, _background, "horizontalCenter", 0);
			ScalingUtil.floatRelativeTo(_cancel, _background, "bottom", padding);
			_cancel.addEventListener(TouchEvent.TOUCH, onCancelTouch);
			
			var titleHeight:int = _availableHeight * .25;
			_titleTxt = new TextField(_availableWidth - (padding * 2), titleHeight, "Downloading...", "Berliner Grotesk", titleHeight * 0.7, Styles.TEXT_DEFAULT_COLOR, false);
			_titleTxt.hAlign = "center";
			_titleTxt.y = padding;
			_titleTxt.x = padding;
			
			addChild(_background);
			addChild(_titleTxt);
			addChild(_progress);
			addChild(_cancel);
		}
		
		public function update(prc:Number):void {
			_progress.width = _progressBarMaxWidth * prc;
		}
		
		public function destroy():void {
			if (_cancel) {
				_cancel.removeEventListener(TouchEvent.TOUCH, onCancelTouch);
			}
			_onCancelClick = null;
			removeChildren();
		}
		
		private function onCancelTouch(e:TouchEvent):void {
			if (e.getTouch(_cancel) && e.getTouch(_cancel).phase == TouchPhase.ENDED) {
				if (_onCancelClick != null) {
					_onCancelClick();
				}
			}
		}
	
	}

}