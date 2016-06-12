package lv.enthusiast.learnactors.textureAtlas {
	import flash.display.Stage;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlas;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlasItem;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class FinishScreenTextureAtlas {
		[Embed(source="/assets/textures/LearnActorsAssets.swf",symbol="FinishScreenTextureAtlas")]
		private static const VectorGraphics:Class;
		
		// [ Class variables ]
		[Inject]
		public var stage:Stage;
		private var atlas:SwfAtlas;
		private var atlas2:SwfAtlas;
		private var atlas3:SwfAtlas;
		
		public function FinishScreenTextureAtlas() {
			InjectionManager.injector.injectInto(this);
			
			atlas = new SwfAtlas();
			atlas.fromMovieClipContainer(new VectorGraphics(), Vector.<String>(["starEmpty_mc", "starFull_mc"]), stage.fullScreenWidth / 440);

		}
		
		public function getSwfAtlasItem(name:String, frame:int = 1):SwfAtlasItem {
			return atlas.getSwfAtlasItem(name, frame)
		}
	
	}

}