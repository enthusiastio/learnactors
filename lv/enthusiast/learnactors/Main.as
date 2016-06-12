package lv.enthusiast.learnactors {
	import feathers.controls.ScreenNavigatorItem;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import lv.enthusiast.learnactors.display.DisplayRoot;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.manager.DataBaseConnection;
	import lv.enthusiast.learnactors.manager.SoundBox;
	import lv.enthusiast.learnactors.manager.StarlingManager;
	import org.swiftsuspenders.Injector;
	import lv.enthusiast.learnactors.manager.InjectionManager
	import flash.events.EventDispatcher;
	import lv.enthusiast.learnactors.landingScreen.LandingScreenView;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.landingScreen.LandingScreenController;
	import lv.enthusiast.learnactors.constants.Screens;
	import starling.core.Starling;
	
	/**
	 * When releasing remember to 
	 * add extension ID to the descriptor
	 * set config parameters in additional compiler arduments to release mode
	 * export swf in release mode by selecting Release in drop down
	 * @author Cyberprodigy
	 */
	public class Main extends Sprite  {
		[Embed(source="/assets/fonts/Berliner Grotesk Medium.ttf", embedAsCFF="false", fontFamily="Berliner Grotesk")]
		private static const BuxtonSketch:Class;

		private var starlingManager:StarlingManager;
		[Inject]
		public var dbCon:DataBaseConnection;
		
		public function Main():void {
			stage.color = Styles.BACKGROUND_DEFAULT_COLOR;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			CONFIG::IS_RELEASE {
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			}
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			starlingManager = new StarlingManager(stage, onRootLoaded);
		}
		
		private function onRootLoaded():void {
			var displayRoot:DisplayRoot = starlingManager.loadStarlingContents(DisplayRoot, null, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight)) as DisplayRoot;
			InjectionManager.init(stage, displayRoot);
			InjectionManager.injector.injectInto(this);
			displayRoot.init();
			dbCon.initialize();
		}
		
		private function deactivate(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}
	
	}

}