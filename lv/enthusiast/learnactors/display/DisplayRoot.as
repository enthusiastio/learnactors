package lv.enthusiast.learnactors.display {
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.constants.Screens;
	import lv.enthusiast.learnactors.finishScreen.FinishScreenView;
	import lv.enthusiast.learnactors.landingScreen.LandingScreenView;
	import lv.enthusiast.learnactors.gameScreen.GameScreenView;
	import lv.enthusiast.learnactors.packSelector.PackSelectorView;
	import lv.enthusiast.learnactors.progressScreen.ProgressScreenView;
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.display.Sprite;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class DisplayRoot extends ScreenNavigator {
		// [ Constants ]
		
		// [ Class variables ]
		private var landingScreen:ScreenNavigatorItem = new ScreenNavigatorItem(LandingScreenView);
		private var progressScreen:ScreenNavigatorItem = new ScreenNavigatorItem(ProgressScreenView);
		private var gameScreen:ScreenNavigatorItem = new ScreenNavigatorItem(GameScreenView);
		private var packsScreen:ScreenNavigatorItem = new ScreenNavigatorItem(PackSelectorView);
		private var finishScreen:ScreenNavigatorItem = new ScreenNavigatorItem(FinishScreenView);
		
		// [ Items on stage]
		
		public function DisplayRoot() {
			
		}
		
		public function init():void {
			var transitionManager:ScreenSlidingStackTransitionManager=new ScreenSlidingStackTransitionManager(this);
			transitionManager.duration=.4;
			transitionManager.ease=Transitions.EASE_OUT;
			addScreen(Screens.LANDING_PAGE, landingScreen);
			addScreen(Screens.PROGRESS_SCREEN, progressScreen);
			addScreen(Screens.GAME_SCREEN, gameScreen);
			addScreen(Screens.PACKS_SCREEN, packsScreen);
			addScreen(Screens.FINISH_SCREEN, finishScreen);
			showScreen(Screens.LANDING_PAGE);
		}
		
		public function showScreenWithData(screenId:String , data:Object):void {
			var screen:ScreenNavigatorItem = getScreen(screenId);
			screen.properties = {data:data};
			showScreen(screenId);
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}