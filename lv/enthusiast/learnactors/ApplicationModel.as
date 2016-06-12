package lv.enthusiast.learnactors {
	import flash.data.SQLResult;
	import flash.events.EventDispatcher;
	import lv.enthusiast.learnactors.manager.DataBaseConnection;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.model.dto.Actor;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	
	public class ApplicationModel extends EventDispatcher {
		
		// [ Class variables ]
		public var packs:Vector.<ActorPack> = Vector.<ActorPack>([]);
		
		[Inject]
		public var dbconn:DataBaseConnection;
		
		public function ApplicationModel() {
			InjectionManager.injector.injectInto(this);
			
			var result:SQLResult = dbconn.executeQuery("SELECT * FROM tbl_packs");
			var object:Object;
			for (var i:int = 0; i < result.data.length; i++) {
				object = result.data[i];
				addPack(object.id, object.title, object.isUnlocked);
			}
		}
		
		public function addPack(packId:int, name:String, isUnlocked:Boolean):void {
			var newPack:ActorPack = new ActorPack();
			newPack.packId = packId;
			newPack.packName = name;
			newPack.isUnlocked = isUnlocked;
			packs.push(newPack);
		}
		
		public function getActorPackById(packId:int):ActorPack {
			for (var i:int = 0; i < packs.length; i++) {
				if (packs[i].packId == packId) {
					return packs[i];
				}
			}
			return null;
		}
	
	}

}