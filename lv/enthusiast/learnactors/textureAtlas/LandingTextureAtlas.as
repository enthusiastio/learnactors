package lv.enthusiast.learnactors.textureAtlas {
	import flash.display.Sprite;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.dynamicAtlas.DynamicAtlas;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlas;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlasItem;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class LandingTextureAtlas {
		
		[Inject] public var stage:Stage;
		
		[Embed(source="/assets/textures/LearnActorsAssets.swf", symbol="LandingScreen")]
		private static const VectorGraphics:Class;
		
		private var atlas:SwfAtlas;
		private var atlas2:SwfAtlas;
		
		public function LandingTextureAtlas() {
			InjectionManager.injector.injectInto(this);
			
			var mc:Sprite = new VectorGraphics();

			atlas = new SwfAtlas();
			atlas.fromMovieClipContainer(mc, Vector.<String>(["slogan_mc"]), stage.fullScreenWidth / 440);
		}
		
		public function getSwfAtlasItem(name:String, frame:int=1):SwfAtlasItem {
			return atlas.getSwfAtlasItem(name, frame);
			
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}