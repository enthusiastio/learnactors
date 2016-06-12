package lv.enthusiast.learnactors.display {
	import flash.display.Stage;
	import flash.events.Event;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import starling.display.graphics.RoundedRectangle;
	import starling.display.materials.StandardMaterial;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class Alert extends AbstractSprite {
		
		[Inject] public var stageRef:Stage;
		
		// [ Class variables ]
		private var _text:String;
		private var _title:String;
		private var _bgColor:uint;
		private var _titleBgColor:uint;
		private var _okButtonLabel:String;
		private var _okButtonColor:uint;
		private var _onClose:Function;
		
		// [ Items on stage]
		private var _background:RoundedRectangle;
		private var _titleBackground:RoundedRectangle;
		private var _messageTxt:TextField;
		private var _titleTxt:TextField;
		private var _okBtn:GameButton;
		

		
		public function Alert(text:String, title:String, bgColor:uint, titleBgColor:uint, okButtonLabel:String, okButtonColor:uint, onClose:Function) {
			InjectionManager.injector.injectInto(this);
			
			_text = text;
			_title = title;
			_bgColor = bgColor;
			_titleBgColor = titleBgColor;
			_okButtonLabel = okButtonLabel;
			_okButtonColor = okButtonColor;
			_onClose = onClose;
			
			resize(stageRef.fullScreenWidth * .95, stageRef.fullScreenWidth * .45);
		}
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			var borderRadius:int = _availableWidth / 25;
			var titleHeight:int = _availableHeight * 0.18;
			var buttonHeight:int = _availableHeight / 5;
			var padding:int = _availableWidth * .05;
			
			_background = new RoundedRectangle(_availableWidth,_availableHeight, borderRadius, borderRadius, borderRadius, borderRadius);
			var bgMat:StandardMaterial = new StandardMaterial();
			bgMat.color = _bgColor;
			_background.material = bgMat;
			
			_titleBackground = new RoundedRectangle(_availableWidth, titleHeight, borderRadius, borderRadius, 0, 0);
			var titleBgMat:StandardMaterial = new StandardMaterial();
			titleBgMat.color = _titleBgColor;
			_titleBackground.material = titleBgMat;
			
			_titleTxt = new TextField(_availableWidth - (padding*2), titleHeight, _title, "Berliner Grotesk", titleHeight * 0.7, Styles.TEXT_DEFAULT_COLOR, false);
			_titleTxt.hAlign = "center";
			_titleTxt.x = padding;
			
			_messageTxt = new TextField(_availableWidth - (padding*2), _availableHeight - titleHeight - buttonHeight - (padding*2), _text, "Berliner Grotesk", titleHeight * 0.8, Styles.TEXT_DEFAULT_COLOR, false);
			_messageTxt.x = padding;
			_messageTxt.y = titleHeight + (padding/2);
			
			_okBtn = new GameButton(_okButtonLabel, _okButtonColor, borderRadius / 2);
			_okBtn.addEventListener(TouchEvent.TOUCH, onCloseTouch);
			_okBtn.resize(_availableWidth / 2.2, buttonHeight);
			ScalingUtil.floatRelativeTo(_okBtn, _background, "bottom", padding);
			ScalingUtil.floatRelativeTo(_okBtn, _background, "horizontalCenter", 0);
			
			addChild(_background);
			addChild(_titleBackground);
			addChild(_messageTxt);
			addChild(_titleTxt);
			addChild(_okBtn);
		}
		
		private function onCloseTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch && touch.phase == TouchPhase.ENDED) {
				if(_onClose != null) {
					_onClose();
				}
			}
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}