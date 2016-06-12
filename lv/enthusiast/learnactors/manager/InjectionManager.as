package lv.enthusiast.learnactors.manager {
	
	import lv.enthusiast.learnactors.finishScreen.FinishScreenController;
	import lv.enthusiast.learnactors.finishScreen.FinishScreenModel;
	import lv.enthusiast.learnactors.gameScreen.GameScreenController;
	import lv.enthusiast.learnactors.gameScreen.GameScreenModel;
	import lv.enthusiast.learnactors.packSelector.PackSelectorController;
	import lv.enthusiast.learnactors.textureAtlas.FinishScreenTextureAtlas;
	import lv.enthusiast.learnactors.textureAtlas.GameScreenTextureAtlas;
	import lv.enthusiast.learnactors.textureAtlas.LandingTextureAtlas;
	import lv.enthusiast.learnactors.textureAtlas.PacksScreenTextureAtlas;
	import org.swiftsuspenders.Injector;
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
	import lv.enthusiast.learnactors.manager.StarlingManager;
	import org.swiftsuspenders.Injector;
	import lv.enthusiast.learnactors.manager.InjectionManager
	import flash.events.EventDispatcher;
	import lv.enthusiast.learnactors.landingScreen.LandingScreenView;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.landingScreen.LandingScreenController;
	import lv.enthusiast.learnactors.ApplicationModel;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class InjectionManager {
		
		// [ Constants ]
		public static const injector:Injector = new Injector();
		
		public function InjectionManager() {
			
		}
		
		public static function init(stage:Stage, displayRoot:DisplayRoot):void {
			injector.map(ApplicationModel).asSingleton();
			injector.map(EventDispatcher, "eventBus").asSingleton();
			injector.map(Stage).toValue(stage);
			injector.map(LandingScreenController).asSingleton();
			injector.map(PackSelectorController).asSingleton();
			injector.map(DisplayRoot).toValue(displayRoot);
			injector.map(LandingTextureAtlas).asSingleton();
			injector.map(GameScreenTextureAtlas).asSingleton();
			injector.map(PacksScreenTextureAtlas).asSingleton();
			injector.map(GameScreenModel).asSingleton();
			injector.map(GameScreenController).asSingleton();
			injector.map(DataBaseConnection).asSingleton();
			injector.map(ActorPhotoUrlManager).asSingleton();
			injector.map(FinishScreenController).asSingleton();
			injector.map(FinishScreenModel).asSingleton();
			injector.map(PopupHandler).asSingleton();
			injector.map(FinishScreenTextureAtlas).asSingleton();
			injector.map(PlayStoreStub).toSingleton(PlayStoreStub);
			injector.map(LevelLockManager).asSingleton();
		}
	
	}

}