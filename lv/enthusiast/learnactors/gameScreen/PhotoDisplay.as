package lv.enthusiast.learnactors.gameScreen {
	
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import lv.enthusiast.learnactors.display.BitmapProducer;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.dynamicAtlas.SwfAtlasItem;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.textureAtlas.GameScreenTextureAtlas;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class PhotoDisplay extends AbstractSprite {
		
		// [ Constants ]
		
		// [ Class variables ]
		[Inject] public var atlas:GameScreenTextureAtlas;
		private var _bitmapProducter:BitmapProducer;
		private var img:Image;
		private var bg:Quad;
		
		// [ Items on stage]
		
		public function PhotoDisplay() {
			InjectionManager.injector.injectInto(this);
			_bitmapProducter = new BitmapProducer();
			bg = new Quad(1, 1, 0xFFFFFF);
			bg.alpha = .9;
			bg.filter = BlurFilter.createDropShadow();
			
			
		}
		
		override protected function resizeLayout():void 
		{
			bg.width = _availableWidth;
			bg.height = _availableHeight;
			addChild(bg);
			if(img) {
				addChild(img);
			}
		}
		
		public function showImage(imgUrl:String):void {
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest(imgUrl));
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function onLoaded(e:Event):void 
		{
			var ldr:Loader = LoaderInfo(e.target).loader;
			var perfectScale:Number = ScalingUtil.calculateMaxScale(ldr.width, ldr.height, _availableWidth * .97, _availableHeight * .97);
			_bitmapProducter.flashDisplayObject = ldr;

			if(img) {
				removeChild(img);
			}
			
			img = new Image(Texture.fromBitmapData(_bitmapProducter.getBitmapData(perfectScale * .5), false));
			
			ScalingUtil.proportionalScaleUp(img, _availableWidth * .97, _availableHeight * .97);
			ScalingUtil.floatInContainer(img, this, "horizontalCenter", 0);
			ScalingUtil.floatInContainer(img, this, "verticalCenter", 0);
			img.alpha = 0;
			addChild(img);
			TweenLite.to(img, .5, { alpha:1 } );
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}