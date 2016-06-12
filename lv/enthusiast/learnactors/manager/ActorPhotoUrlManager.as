package lv.enthusiast.learnactors.manager {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import lv.enthusiast.learnactors.model.dto.Actor;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class ActorPhotoUrlManager {
		
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		
		public function ActorPhotoUrlManager() {
		
		}
		
		public function getRandomImageForActor(packId:int, actor:Actor):File {
			var allImages:Array = getImagesForActor(packId, actor);
			return allImages[Math.floor(Math.random() * allImages.length)];
		}
		
		public function getImagesForActor(packId:int, actor:Actor):Array {
			var dir:File = File.applicationStorageDirectory.resolvePath("imgs").resolvePath(packId.toString());
			var actorDir:File = dir.resolvePath(actor.actorName.toLocaleLowerCase());
			//var actorDir:File = dir.resolvePath("sean connery");
			return actorDir.getDirectoryListing();
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}