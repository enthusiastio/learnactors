package lv.enthusiast.learnactors.gameScreen {
	import flash.filesystem.File;
	import lv.enthusiast.learnactors.ApplicationModel;
	import lv.enthusiast.learnactors.constants.Screens;
	import lv.enthusiast.learnactors.display.DisplayRoot;
	import lv.enthusiast.learnactors.finishScreen.FinishScreenModel;
	import lv.enthusiast.learnactors.manager.ActorPhotoUrlManager;
	import lv.enthusiast.learnactors.manager.DataBaseConnection;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.manager.SoundBox;
	import lv.enthusiast.learnactors.model.dto.Actor;
	import lv.enthusiast.learnactors.model.dto.Game;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class GameScreenController {
		[Inject]
		public var model:GameScreenModel;
		
		[Inject]
		public var appModel:ApplicationModel;
		
		[Inject]
		public var displayRoot:DisplayRoot;
		
		[Inject]
		public var photoUrlManager:ActorPhotoUrlManager;
		
		[Inject]
		public var dbconn:DataBaseConnection;
		
		[Inject]
		public var finishModel:FinishScreenModel;
		
		private var _view:GameScreenView;
		private var _nameComparer:NameComparer;
		
		public function GameScreenController() {
			
		}
		
		public function registerView(view:GameScreenView):void {
			InjectionManager.injector.injectInto(this);
			_view = view;
			_nameComparer = new NameComparer();
			
			model.addEventListener(GameScreenModel.ACTOR_CHANGED, onActorChanged);
			model.nextActor();
		}
		
		public function handleSkipClicked():void 
		{
			model.currentActor.wrongGuess++;
			model.game.wrong++;
			tryShowNewActor();
			SoundBox.play(SoundBox.SKIP);
		}
		
		public function handleInputChanged(input:String):void 
		{
			var result:Number = _nameComparer.compare(input);
			
					
			if (result == 1) {
				if (_view.input_mc.hint == "") {
					SoundBox.play(SoundBox.CORRECT_SOUND);
					_view.showCongratulationsEffect();
					model.currentActor.currectGuess++;
					model.game.correct += 1;
				}
				else {
					var pointsToAward:Number = 1 - (_view.input_mc.hint.length / model.currentActor.actorName.length);
					if (pointsToAward > 0) {
						SoundBox.play(SoundBox.CORRECT_SOUND);
						_view.showCongratulationsEffect();
						model.game.partialCorrect += Math.round(pointsToAward * 100) / 100;
						model.currentActor.wrongGuess++;
						model.game.wrong++;
					}
					else {
						model.currentActor.wrongGuess++;
						model.game.wrong++;
					}
				}
				// calculate points to award
				
				tryShowNewActor();
			}
			else {
				_view.proximityView.setPercent(result);
			}
			
		}
		
		private function tryShowNewActor():void {
			_view.progress.progress = model.actorsComplete.length / (model.actorsInDeck.length + model.actorsComplete.length);
			if (model.actorsInDeck.length > 0) {
				model.nextActor();
				if (model.actorsInDeck.length == 0) {
					_view.skipBtn.label = "Skip/Finish";
				}
			}
			else {
				model.game.playMiliSeconds = new Date().time -model.game.startTime;
				updateDataBase();
				finishModel.game = model.game;
				displayRoot.showScreen(Screens.FINISH_SCREEN);
			}
		}
		
		private function updateDataBase():void 
		{
			var actors:Vector.<Actor> = model.actorsComplete;
			var arrLen:int = actors.length
			for (var i:int = 0; i < arrLen; i++) 
			{
				dbconn.executeQuery("UPDATE tbl_actors set correct=" + actors[i].currectGuess+ ", wrong=" + actors[i].wrongGuess+ " WHERE id=" + actors[i].id);
			}
			dbconn.executeQuery("INSERT INTO tbl_games(playSeconds, packId, correct, wrong, points) VALUES(" + model.game.playMiliSeconds + "," + model.selectedPack.packId + "," + model.game.correct + "," + model.game.wrong + "," + model.game.points +")");
		}
		
		private function onActorChanged(e:Event):void 
		{
			var actor:Actor = e.data as Actor;
			_view.setActor(actor, photoUrlManager.getRandomImageForActor(model.selectedPack.packId, actor).url);
			_nameComparer.correctWord = actor.actorName;
		}
		
	
	}

}