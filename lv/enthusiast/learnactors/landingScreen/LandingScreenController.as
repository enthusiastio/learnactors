package lv.enthusiast.learnactors.landingScreen {
	import lv.enthusiast.learnactors.display.DisplayRoot;
	import starling.events.Event;
	import flash.desktop.NativeApplication
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.constants.Screens;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class LandingScreenController {
		
		[Inject] public var displayRoot:DisplayRoot;
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		
		public function LandingScreenController() {
			InjectionManager.injector.injectInto(this);
		}
		
		
		// [ Setters & getters ]
		
		// [ Event handlers ]
		public function onExitClicked(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}
		
		public function onProgressClicked(e:Event):void {
			displayRoot.showScreen(Screens.PROGRESS_SCREEN);
		}
		
		public function onPlayClicked(e:Event):void {
			displayRoot.showScreen(Screens.PACKS_SCREEN);
		}
	
	}

}