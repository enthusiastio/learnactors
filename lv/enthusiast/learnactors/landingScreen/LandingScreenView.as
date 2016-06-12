package lv.enthusiast.learnactors.landingScreen {
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.display.GameButton;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlasItem;
	import lv.enthusiast.learnactors.textureAtlas.LandingTextureAtlas;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import com.greensock.TweenMax;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import com.greensock.easing.Expo
	import starling.events.TouchEvent;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class LandingScreenView extends Screen {
		private var filmFrame:int;
		
		// [ Constants ]
		
		// [ Class variables ]
		[Inject]
		public var stageReference:Stage;
		[Inject]
		public var controller:LandingScreenController;
		[Inject]
		public var textureAtlas:LandingTextureAtlas;
		
		// [ Items on stage]
		public var play:GameButton;
		public var progress:GameButton;
		public var packs:GameButton;
		public var exit:GameButton;
		
		public var slogan:Image;
		
		public var _topTitle:TopTitle;
		public var _footer:Footer;
		
		
		public function LandingScreenView() {
			InjectionManager.injector.injectInto(this);
			
			play = createButton(0, "Play", Styles.BUTTON_DEFAULT_COLOR, controller.onPlayClicked);
			//progress = createButton(1, "Progress", 0xE5005B, controller.onProgressClicked);
			//packs = createButton(2, "Packs", 0xCB0050, null);
			exit = createButton(1, "Exit", Styles.BUTTON_DEFAULT_COLOR, controller.onExitClicked);
			
			
			_topTitle = new TopTitle();
			_topTitle.alpha = 0;
			_topTitle.resize(stageReference.fullScreenWidth, stageReference.fullScreenHeight * 0.2);
			addChild(_topTitle);
			
			
			_footer = new Footer();
			_footer.alpha = 0;
			_footer.y = stageReference.fullScreenHeight * 0.92;
			_footer.resize(stageReference.fullScreenWidth, stageReference.fullScreenHeight * 0.08);
			addChild(_footer);
			
			showIntroAnim();
		}
		
		private function showIntroAnim():void {
			animateButtons(Vector.<GameButton>([play, exit]));
			animateTitle();
		}
		
		private function animateTitle():void {
			TweenMax.to(_topTitle, 1, { alpha: 1 } );
			TweenMax.to(_footer, 1, {alpha: 1});
		}
		
		private function placeObject(swfItem:SwfAtlasItem):Image {
			var image:Image = new Image(swfItem.texture);
			image.x = swfItem.x;
			image.y = swfItem.y;
			addChild(image);
			return image;
		}
		
		private function createButton(idx:int, name:String, color:int, callBack:Function):GameButton {
			var buttonWidth:int = stageReference.fullScreenWidth * .55;
			var buttonHeight:int = buttonWidth * .24;
			var newButton:GameButton = new GameButton(name, color, buttonWidth * .07 );
			newButton.x = (stageReference.fullScreenWidth - buttonWidth) / 2;
			newButton.y = (stageReference.fullScreenHeight * .3) + (idx * buttonHeight * 1.5);
			newButton.touchable = true;
			
			newButton.addEventListener(Event.TRIGGERED, callBack);
			newButton.visible = false;
			newButton.resize(buttonWidth, buttonHeight);
			addChild(newButton);
			
			return newButton;
		}
		
		private function animateButtons(buttons:Vector.<GameButton>):void {
			
			for (var i:int = 0; i < buttons.length; i++) {
				TweenMax.to(buttons[i], .65, {y: buttons[i].y, delay: 1+i * .1, ease: Back.easeOut})
				buttons[i].y = stageReference.fullScreenHeight;
				buttons[i].visible = true;
			}
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}