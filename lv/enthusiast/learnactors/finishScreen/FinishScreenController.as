package lv.enthusiast.learnactors.finishScreen {
	
	import flash.display.*;
	import flash.events.*;
	import lv.enthusiast.learnactors.ApplicationModel;
	import lv.enthusiast.learnactors.constants.Screens;
	import lv.enthusiast.learnactors.display.Alert;
	import lv.enthusiast.learnactors.display.DisplayRoot;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.manager.LevelLockManager;
	import lv.enthusiast.learnactors.manager.PopupHandler;
	import lv.enthusiast.learnactors.manager.SoundBox;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import lv.enthusiast.learnactors.model.dto.Game;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class FinishScreenController {
		[Inject]
		public var model:FinishScreenModel;
		[Inject]
		public var displayRoot:DisplayRoot;
		[Inject]
		public var appModel:ApplicationModel;
		[Inject]
		public var levelLockManager:LevelLockManager;
		[Inject]
		private var _currentAlert:Alert;
		[Inject]
		public var popupHandler:PopupHandler;
		
		private var _view:FinishScreenView;
		
		public function FinishScreenController() {
			InjectionManager.injector.injectInto(this);
		}
		
		public function registerView(view:FinishScreenView):void {
			_view = view;
			var gameDto:Game = model.game;
			var actorPack:ActorPack = appModel.getActorPackById(gameDto.packId);
			var numberOfQuestions:int = gameDto.correct + gameDto.wrong;
			var prcCorrect:int = Math.round(((gameDto.correct + gameDto.partialCorrect) / numberOfQuestions) * 100);
			var starsForGame:int = Math.round(4 * (prcCorrect / 100));
			
			if (starsForGame >= 3) {
				var packToUnlock:ActorPack = appModel.getActorPackById(gameDto.packId + 1);
				if (packToUnlock != null && !packToUnlock.isUnlocked) {
					levelLockManager.unlockPack(gameDto.packId + 1);
					SoundBox.play(SoundBox.DOWNLOAD_COMPLETE);
					_currentAlert = new Alert("You just unlocked " + packToUnlock.packName, "New pack unlocked", Styles.INFO_BG, Styles.INFO_TITLE_BG, "Close", Styles.INFO_BUTTON_BG, onAlertCloseClicked);
					popupHandler.show(_currentAlert);
				}
			}
			
			view.score.text = "Score: " + (gameDto.correct + gameDto.partialCorrect) + "/" + numberOfQuestions + " (" + prcCorrect + "%)";
			view.textEvaluation.text = getTextEvaluationFromPrc(prcCorrect);
			view.topTitle.text = actorPack.packName;
			
			view.stars.showStars(starsForGame);
		}
		
		public function returnToMenuClicked():void {
			displayRoot.showScreen(Screens.LANDING_PAGE);
		}
		
		private function getTextEvaluationFromPrc(prc:int):String {
			if (prc < 20) {
				return "Keep practicing";
			} else if (prc < 40) {
				return "Not bad";
			} else if (prc < 60) {
				return "Good";
			} else if (prc < 80) {
				return "Very good";
			} else if (prc < 100) {
				return "Excelent";
			} else if (prc == 100) {
				return "You know them all";
			}
			return null;
		}
		
		private function onAlertCloseClicked():void {
			popupHandler.removeScreen(_currentAlert);
		}
	}

}