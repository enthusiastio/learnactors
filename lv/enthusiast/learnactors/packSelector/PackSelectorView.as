package lv.enthusiast.learnactors.packSelector {
	
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import lv.enthusiast.learnactors.ApplicationModel;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import lv.enthusiast.learnactors.textureAtlas.PacksScreenTextureAtlas;
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class PackSelectorView extends Screen {
		public var troubleSomeActorsChk:Check;
		private var xPosition:int = 0;
		private var blackQuad:Quad;
		private var title:TextField;
		private var container:ScrollContainer;
		private var checkCountainer:Sprite;
		private var troublesome_lbl:TextField;
		
		// [ Constants ]
		
		// [ Class variables ]
		[Inject]
		public var textureAtlas:PacksScreenTextureAtlas;
		[Inject]
		public var model:ApplicationModel;
		[Inject]
		public var controller:PackSelectorController;
		[Inject]
		public var stageReference:Stage;
		
		// [ Items on stage]
		
		public function PackSelectorView() {
			
		}
		
		override protected function initialize():void {
			super.initialize();
			this.owner.addEventListener( FeathersEventType.TRANSITION_COMPLETE, transitionComplete );
			
		}
		
		private function transitionComplete(e:Event):void 
		{
			InjectionManager.injector.injectInto(this);
			controller.registerView(this);
			this.owner.removeEventListener( FeathersEventType.TRANSITION_COMPLETE, transitionComplete );
			
			title = new TextField(stage.stageWidth, stage.stageHeight * .15, "Select a pack", "Berliner Grotesk", stage.stageHeight * .07, Styles.TEXT_DEFAULT_COLOR, true);
			addChild(title);
			
			
		}
		
		public function setupView():void {
			var padding:int = stage.stageHeight*0.01;
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paddingTop = 5;
			layout.paddingRight = 15;
			layout.paddingBottom = 5;
			layout.paddingLeft = 15;
			layout.gap = stage.stageHeight*0.02;
			
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			
			if(!container) {
				container = new ScrollContainer();
				container.layout = layout;
				container.setSize(stage.stageWidth, stage.stageHeight * .85);
				container.y = stage.stageHeight * .15;
			}
			else {
				container.removeChildren();
				removeChild(container);
			}
			
			var itemWidth:int = stage.stageWidth * .32;
			for (var i:int = 0; i < model.packs.length; i++) {
				var pack:ActorPack = model.packs[i];
				var item:PackItemRenderer = new PackItemRenderer();
				item.data = pack;
				item.x = xPosition;
				container.addChild(item);
				xPosition += item.width + 20;
				item.addEventListener(TouchEvent.TOUCH, onClick);
			}
			
			checkCountainer = new Sprite();
			
			troubleSomeActorsChk = new Check();
			troubleSomeActorsChk.defaultSkin = new Image(textureAtlas.getSwfAtlasItem("checkbox",1).texture);
			troubleSomeActorsChk.defaultSelectedSkin = new Image(textureAtlas.getSwfAtlasItem("checkbox", 2).texture);
			troubleSomeActorsChk.setSize(stageReference.fullScreenHeight * 0.05, stageReference.fullScreenHeight * 0.05);
			checkCountainer.addChild(troubleSomeActorsChk);
			
			troublesome_lbl = new TextField(stageReference.fullScreenWidth * 0.55, troubleSomeActorsChk.height, "Only actors I have trouble remembering", "Berliner Grotesk", stage.stageHeight * .02, Styles.TEXT_DEFAULT_COLOR, false);
			troublesome_lbl.hAlign = "left";
			troublesome_lbl.y = troubleSomeActorsChk.y;
			troublesome_lbl.x = troubleSomeActorsChk.x + troubleSomeActorsChk.width + padding;
			checkCountainer.addChild(troublesome_lbl);
			
			checkCountainer.y = stageReference.fullScreenHeight - troubleSomeActorsChk.height - stage.stageHeight * 0.05;
			checkCountainer.x = (stageReference.fullScreenWidth - checkCountainer.width) / 2;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			addChild(container);
			addChild(checkCountainer);
		}
		
		
		private function onClick(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch.phase == TouchPhase.ENDED) {
				var target:PackItemRenderer = e.currentTarget as PackItemRenderer;
				controller.handeItemPicked(target);
			}
		}
		
		private function addQuad(color:int, x:int, y:int, width:int, height:int):Quad {
			var quad:Quad = new Quad(width, height, color);
			quad.x = x;
			quad.y = y;
			addChild(quad);
			return quad;
		}
	
	}

}