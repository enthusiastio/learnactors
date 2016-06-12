package lv.enthusiast.learnactors.manager {
	import lv.enthusiast.learnactors.ApplicationModel;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class LevelLockManager {
		
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		[Inject]
		public var applicationModel:ApplicationModel;
		[Inject]
		public var dbConnection:DataBaseConnection;
		
		public function LevelLockManager() {
			InjectionManager.injector.injectInto(this);
		}
		
		public function unlockPack(packId:int):void {
			var pack:ActorPack = applicationModel.getActorPackById(packId);
			pack.isUnlocked = true;
			
			dbConnection.executeQuery("Update tbl_packs SET isUnlocked = 1 Where id=" + packId);
		}
		
		public function isUnlocked(packId:int):Boolean {
			var pack:ActorPack = applicationModel.getActorPackById(packId);
			if (pack) {
				return applicationModel.getActorPackById(packId).isUnlocked;
			}
			else {
				return false;
			}
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}