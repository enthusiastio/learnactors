package lv.enthusiast.learnactors.finishScreen {
	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.ApplicationModel;
	import lv.enthusiast.learnactors.display.GameButton;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.manager.SoundBox;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import lv.enthusiast.learnactors.model.dto.Game;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class FinishScreenView extends Screen {
		
		// [ Constants ]
		
		// [ Class variables ]
		[Inject] public var controller:FinishScreenController;
		[Inject] public var stageReference:Stage;
		
		
		// [ Items on stage]
		public var topTitle:TextField;
		public var stars:Stars;
		public var textEvaluation:TextField;
		public var moreInfo:TextField;
		public var score:TextField;
		private var bg_mc:Sprite;
		private var returnButton:GameButton;
		
		
		
		public function FinishScreenView() {
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			this.owner.addEventListener( FeathersEventType.TRANSITION_COMPLETE, transitionComplete );
		}
		
		private function transitionComplete(e:Event):void 
		{
			this.owner.removeEventListener( FeathersEventType.TRANSITION_COMPLETE, transitionComplete );
			
			InjectionManager.injector.injectInto(this);
			
			bg_mc = new Sprite();
			var bgQuad:Quad = new Quad(stageReference.fullScreenWidth, stageReference.fullScreenHeight);
			bgQuad.setVertexColor(0, Styles.BACKGROUND_GRADIENT_TOP);
			bgQuad.setVertexColor(1, Styles.BACKGROUND_GRADIENT_TOP);
			bgQuad.setVertexColor(2, Styles.BACKGROUND_GRADIENT_BOTTOM);
			bgQuad.setVertexColor(3, Styles.BACKGROUND_GRADIENT_BOTTOM);
			bg_mc.addChild(bgQuad);
			addChild(bg_mc);
			
			var padding:int = stageReference.fullScreenWidth * .045;
			var titleFontSize:int = stageReference.fullScreenHeight * .07;
			var subtitleFontSize:int = stageReference.fullScreenHeight * .05;
			var moreInfoFontsize:int = stageReference.fullScreenHeight * .04;
			

			topTitle = new TextField(stageReference.stageWidth, titleFontSize*1.5, "", "Berliner Grotesk", titleFontSize, Styles.TEXT_DEFAULT_COLOR, true);
			topTitle.hAlign = "center";
			
			score = new TextField(stageReference.stageWidth - (padding*2), subtitleFontSize * 1.5, "", "Berliner Grotesk", subtitleFontSize, Styles.TEXT_DEFAULT_COLOR, true);
			score.hAlign = "center";
			
			stars = new Stars();
			stars.resize(stageReference.stageWidth - (padding*2), titleFontSize);
			
			textEvaluation = new TextField(stageReference.stageWidth - (padding*2), subtitleFontSize * 1.5, "", "Berliner Grotesk", subtitleFontSize, Styles.TEXT_DEFAULT_COLOR);
			textEvaluation.hAlign = "center";
			
			moreInfo = new TextField(stageReference.stageWidth - (padding*2), subtitleFontSize * 4, "", "Berliner Grotesk", moreInfoFontsize, Styles.TEXT_DEFAULT_COLOR);
			
			returnButton = new GameButton("Return to menu", Styles.BUTTON_DEFAULT_COLOR, stageReference.fullScreenWidth * .03);
			returnButton.resize(stageReference.fullScreenWidth * .8, stageReference.fullScreenWidth * .16);
			returnButton.addEventListener(TouchEvent.TOUCH, onReturnButtonTouch);
			
			addChild(topTitle);
			addChild(score);
			addChild(stars);
			addChild(textEvaluation);
			addChild(moreInfo);
			addChild(returnButton);
			
			controller.registerView(this);
			
			ScalingUtil.stack(score, topTitle, "bottom", padding);
			ScalingUtil.stack(stars, score, "bottom", padding);
			ScalingUtil.stack(textEvaluation, stars, "bottom", padding);
			ScalingUtil.stack(moreInfo, textEvaluation, "bottom", padding);
			ScalingUtil.stack(returnButton, moreInfo, "bottom", padding);
			
			ScalingUtil.floatInContainer(topTitle, this, "horizontalCenter", 0);
			ScalingUtil.floatInContainer(score, this, "horizontalCenter", 0);
			ScalingUtil.floatInContainer(stars, this, "horizontalCenter", 0);
			ScalingUtil.floatInContainer(textEvaluation, this, "horizontalCenter", 0);
			ScalingUtil.floatInContainer(moreInfo, this, "horizontalCenter", 0);
			ScalingUtil.floatInContainer(returnButton, this, "horizontalCenter", 0);
		}
		
		private function onReturnButtonTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch && touch.phase == TouchPhase.BEGAN) {
				controller.returnToMenuClicked();
			}
		}
		
		public function setMoreInfoText(text:String):void {
			moreInfo.text = text;
		}
		
		public function showUnlockLevelCongrats():void 
		{
			trace("Puff puff")
		}
		
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}