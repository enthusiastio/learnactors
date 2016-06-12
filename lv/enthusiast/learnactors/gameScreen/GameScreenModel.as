package lv.enthusiast.learnactors.gameScreen {
	
	import flash.data.SQLResult;
	import lv.enthusiast.learnactors.manager.DataBaseConnection;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.model.dto.Actor;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import lv.enthusiast.learnactors.model.dto.Game;
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class GameScreenModel extends EventDispatcher {
		
		public static const ACTOR_CHANGED:String = "ACTOR_CHANGED.GameScreenModel";
		[Inject]
		public var dbConn:DataBaseConnection;
		
		private const QUESTIONS_PER_ROUND:int = 12;
		
		private var _currentActor:Actor;
		private var _currentPack:ActorPack;
		private var _actorsInDeck:Vector.<Actor>;
		private var _actorsComplete:Vector.<Actor>;
		public var game:Game;
		public var playOnlyTroublesome:Boolean;
		
		public function GameScreenModel() {
			InjectionManager.injector.injectInto(this);
		}
		
		public function get currentActor():Actor 
		{
			return _currentActor;
		}
		
		public function set currentActor(value:Actor):void 
		{
			_currentActor = value;
			dispatchEventWith(ACTOR_CHANGED, false, _currentActor);
		}
		
		private function popRandomActorFromDect():Actor {
			return _actorsInDeck.splice(Math.random() * _actorsInDeck.length - 1, 1)[0];
		}
		
		public function nextActor():void 
		{
			currentActor = popRandomActorFromDect();
			actorsComplete.push(currentActor);
		}
		
		public function set selectedPack(value:ActorPack):void 
		{
			_currentPack = value;
			var actor:Actor;
			var currentRow:Object;
			_actorsInDeck =  Vector.<Actor>([]);
			_actorsComplete = Vector.<Actor>([]);
			game = new Game();
			game.packId = _currentPack.packId;
			game.startTime = new Date().time;
			
			var result:SQLResult;
			if (playOnlyTroublesome == true) {
				result = dbConn.executeQuery("Select *, (correct - wrong) AS NetCorrectness From tbl_actors WHERE packId=" + _currentPack.packId + " ORDER BY NetCorrectness LIMIT " + QUESTIONS_PER_ROUND);
			}
			else {
				result = dbConn.executeQuery("Select * From tbl_actors WHERE packId=" + _currentPack.packId);
			}
			
			var randomIndexes:Array = getRandomIndexes(result.data.length, QUESTIONS_PER_ROUND);
			for (var i:int = 0; i <QUESTIONS_PER_ROUND ; i++) 
			{
				currentRow = result.data[randomIndexes.pop()];
				actor = new Actor();
				actor.id = currentRow.id;
				actor.actorName = currentRow.name;
				actor.currectGuess = currentRow.currectGuess;
				actor.wrongGuess = currentRow.wrongGuess;
				_actorsInDeck.push(actor);
			}
		}
		
		private function getRandomIndexes(maxIndex:int, length:int):Array {
			var returnArray:Array = new Array();
			for (var i:int = 0; i < maxIndex; i++) 
			{
				returnArray[i] = i;
			}
			returnArray.sort(randomize);
			returnArray.length = length;
			
			return returnArray;
		}
		
		private function randomize ( a : *, b : * ) : int {
			return ( Math.random() > .5 ) ? 1 : -1;
		}
		
		public function get selectedPack():ActorPack {
			return _currentPack;
		}
		
		public function get actorsInDeck():Vector.<Actor> 
		{
			return _actorsInDeck;
		}
		
		public function get actorsComplete():Vector.<Actor> 
		{
			return _actorsComplete;
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}