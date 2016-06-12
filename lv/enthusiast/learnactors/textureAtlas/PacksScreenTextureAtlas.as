package lv.enthusiast.learnactors.textureAtlas {
	import flash.display.Stage;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlas;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlasItem;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class PacksScreenTextureAtlas {
		[Embed(source="/assets/textures/LearnActorsAssets.swf",symbol="PacksScreen")]
		private static const VectorGraphics:Class;
		
		// [ Class variables ]
		[Inject]
		public var stage:Stage;
		
		private var atlas:SwfAtlas;
		private var atlas2:SwfAtlas;
		
		public function PacksScreenTextureAtlas() {
			InjectionManager.injector.injectInto(this);
			
			atlas = new SwfAtlas();
			atlas.fromMovieClipContainer(new VectorGraphics(), Vector.<String>(["top25", "top50", "top100", "download_btn"]), stage.fullScreenWidth / 440);
			atlas2 = new SwfAtlas();
			atlas2.fromMovieClipContainer(new VectorGraphics(), Vector.<String>(["topNew", "topOld", "extra", "purchase_btn", "lock_btn", "checkbox"]), stage.fullScreenWidth / 440);
		}
		
		public function getSwfAtlasItem(name:String, frame:int = 1):SwfAtlasItem {
			var texture:SwfAtlasItem = atlas.getSwfAtlasItem(name, frame)
			if (texture != null) {
				return texture;
			} 
			else {
				return atlas2.getSwfAtlasItem(name, frame);
			}
			
			return null;
		}
		
		public function getSwfAtlasItemForPack(actorPackId:int):SwfAtlasItem {
			var itemAtlasName:String;
			switch (actorPackId) 
			{
				case ActorPack.PACK_025:
					itemAtlasName = "top25"
					break;
				case ActorPack.PACK_050:
					itemAtlasName = "top50"
					break;
				case ActorPack.PACK_075:
					itemAtlasName = "top100"
					break;
				case ActorPack.PACK_NEW:
					itemAtlasName = "topNew"
					break;
				case ActorPack.PACK_OLD:
					itemAtlasName = "topOld"
					break;
				case ActorPack.PACK_ACTION	:
					itemAtlasName = "extra"
					break;
			}
			return getSwfAtlasItem(itemAtlasName);
		}
	
	}

}