package lv.enthusiast.learnactors.gameScreen 
{
	
  import com.greensock.TweenLite;
  import feathers.display.TiledImage;
  import flash.display.*;
	import flash.events.*;
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.textureAtlas.GameScreenTextureAtlas;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class ProgressBar extends AbstractSprite
	{
		
		// [ Constants ]
		
		
		// [ Class variables ]
		[Inject]
		public var atlas:GameScreenTextureAtlas;
		private var _texture:Texture;
		
		// [ Items on stage]
		private var _background:Quad;
		private var _foreground:TiledImage;
		
		
		public function ProgressBar() 
		{
			InjectionManager.injector.injectInto(this);
			
			_texture = atlas.getSwfAtlasItem("progressBar").texture;
			_background = new Quad(10, 10, Styles.PROGRESS_BAR_1);
			_foreground = new TiledImage(_texture);
			_foreground.smoothing = TextureSmoothing.NONE;
		}
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			_foreground.width = 0;
			_foreground.height = _availableHeight;
			
			_foreground.textureScale = _availableHeight / _texture.height;
			
			_background.width = _availableWidth;
			_background.height = _availableHeight;
			
			addChild(_background);
			addChild(_foreground);
		}
		
		public function set progress(value:Number):void 
		{
			TweenLite.to(_foreground, .5, {width:_availableWidth * value});
		}
		
		// [ Setters & getters ]
		
		
		// [ Event handlers ]
		
		
		
	}

}