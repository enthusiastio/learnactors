package lv.enthusiast.learnactors.gameScreen {
	import feathers.controls.IScreen;
	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.display.GameButton;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlasItem;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.model.dto.Actor;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import lv.enthusiast.learnactors.textureAtlas.GameScreenTextureAtlas;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class GameScreenView extends Screen {
		
		[Embed(source="/assets/particles/particle.pex",mimeType="application/octet-stream")]
		private static const ParticleConfig:Class;
		
		// embed particle texture
		[Embed(source="/assets/particles/texture.png")]
		private static const ParticleGraphics:Class;
		
		// [ Constants ]
		
		// [ Class variables ]
		[Inject]
		public var textureAtlas:GameScreenTextureAtlas;
		
		[Inject]
		public var controller:GameScreenController;
		
		[Inject]
		public var stageReference:Stage;
		
		// [ Items on stage]
		public var bg_mc:Sprite;
		public var input_mc:AnswerInput;
		public var getHintBtn:GameButton;
		public var skipBtn:GameButton;
		private var _currentActor:Actor;
		private var ps:PDParticleSystem;
		public var progress:ProgressBar;
		
		public var photo:PhotoDisplay;
		public var proximityView:ProximityView;
		
		public function GameScreenView() {
		
		}
		
		override protected function initialize():void {
			super.initialize();
			this.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, transitionComplete);
		}
		
		public function showCongratulationsEffect():void {
			initEmitor();
			ps.start(0.3);
		}
		
		private function initEmitor():void {
			if (ps == null) {
				var psConfig:XML = XML(new ParticleConfig());
				var psTexture:Texture = Texture.fromBitmap(new ParticleGraphics());
				
				ps = new PDParticleSystem(psConfig, psTexture);
				ps.x = 0;
				ps.y = 0;
				
				addChild(ps);
				Starling.juggler.add(ps);
				
				ps.emitterX = width / 2;
				ps.emitterY = height / 2;
			}
		}
		
		private function transitionComplete(e:Event):void {
			this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, transitionComplete);
			
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
			
			progress = new ProgressBar();
			progress.width = stageReference.fullScreenWidth - (padding * 2);
			progress.height = stageReference.fullScreenWidth * .04;
			progress.x = padding;
			progress.y = padding;
			ScalingUtil.floatInContainer(progress, this, "top", padding);
			addChild(progress);
			
			input_mc = new AnswerInput();
			ScalingUtil.stack(input_mc, progress, "bottom", padding);
			input_mc.x = padding;
			input_mc.addEventListener(AnswerInput.INPUT_CHANGED, onInputChanged);
			addChild(input_mc);
			
			proximityView = new ProximityView();
			proximityView.resize(stageReference.fullScreenWidth - (padding * 2), stageReference.fullScreenWidth * 0.015);
			proximityView.x = padding;
			ScalingUtil.stack(proximityView, input_mc, "bottom", padding/2);
			addChild(proximityView);
			
			
			var butttonWidth:int = (stageReference.fullScreenWidth - (padding * 3)) / 2;
			var butttonHeight:int = butttonWidth * .28;
			
			getHintBtn = createButton("Get hint", Styles.BUTTON_DEFAULT_COLOR, butttonWidth, butttonHeight, onGetHintClicked);
			skipBtn = createButton("Skip", Styles.BUTTON_DEFAULT_COLOR, butttonWidth, butttonHeight, onSkipClicked);
			
			ScalingUtil.floatInContainer(getHintBtn, this, "left", padding);
			ScalingUtil.stack(skipBtn, getHintBtn, "right", padding);
			ScalingUtil.stack(getHintBtn, proximityView, "bottom", padding / 2);
			ScalingUtil.stack(skipBtn, proximityView, "bottom", padding / 2);
			
			photo = new PhotoDisplay();
			photo.resize(stageReference.fullScreenWidth * .9, stageReference.fullScreenHeight * .7)
			ScalingUtil.floatRelativeTo(photo, bg_mc, "horizontalCenter", 0);
			ScalingUtil.stack(photo, getHintBtn, "bottom", padding);
			addChild(photo);
			
			getHintBtn.addEventListener(Event.TRIGGERED, onGetHintClicked);
			skipBtn.addEventListener(Event.TRIGGERED, onSkipClicked);
			
			controller.registerView(this);
		}
		
		private function createButton(name:String, color:uint, buttonWidth:int, buttonHeight:int, callBack:Function):GameButton {
			var newButton:GameButton = new GameButton(name, color, buttonWidth * .07);
			newButton.touchable = true;
			
			newButton.addEventListener(Event.TRIGGERED, callBack);
			newButton.resize(buttonWidth, buttonHeight);
			addChild(newButton);
			
			return newButton;
		}
		
		private function onInputChanged(e:Event):void {
			controller.handleInputChanged(e.data as String)
		}
		
		private function onSkipClicked(e:Event):void {
			controller.handleSkipClicked();
		}
		
		public function setActor(actor:Actor, imageUrl:String):void {
			_currentActor = actor;
			
			input_mc.text = "";
			input_mc.hint = "";
			
			photo.showImage(imageUrl);
		}
		
		private function onGetHintClicked(e:Event):void {
			var oldHint:String = input_mc.hint;
			var newHint:String = _currentActor.actorName.substr(0, oldHint.length + 1);
			input_mc.hint = newHint.toUpperCase();
		}
		
		private function placeObject(swfItem:SwfAtlasItem):Image {
			var image:Image = new Image(swfItem.texture);
			image.x = swfItem.x;
			image.y = swfItem.y;
			addChild(image);
			return image;
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}