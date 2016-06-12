package lv.enthusiast.learnactors.finishScreen {
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.manager.SoundBox;
	import lv.enthusiast.learnactors.textureAtlas.FinishScreenTextureAtlas;
	import org.swiftsuspenders.Injector;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class Stars extends AbstractSprite {
		
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		[Inject]
		public var atlas:FinishScreenTextureAtlas;
		
		private var _starContainer:Sprite;
		private var _starsRef:Vector.<Image> = new Vector.<Image>(4, true);
		private var star_1:Image;
		private var star_2:Image;
		private var star_3:Image;
		private var star_4:Image;
		
		public function Stars() {
			super();
			InjectionManager.injector.injectInto(this);
			_starContainer = new Sprite();
			addChild(_starContainer);
			var emptyTexture:Texture = atlas.getSwfAtlasItem("starEmpty_mc").texture;
			_starsRef[0] = new Image(emptyTexture);
			_starsRef[1] = new Image(emptyTexture);
			_starsRef[2] = new Image(emptyTexture);
			_starsRef[3] = new Image(emptyTexture);
		}
		
		public function showStars(count:int):void {
			if (count > 0) {
				SoundBox.play(SoundBox.FINISH_SOUND);
			}
			var img:Image;
			var animPadding:Number = .3
			for (var i:int = 0; i < _starsRef.length; i++) 
			{
				img = _starsRef[i];
				if (i < count) {
					img.texture = atlas.getSwfAtlasItem("starFull_mc").texture;
					TweenMax.to(img, .5, { y:-this.height*.8, delay:i*animPadding + 1, ease:Expo.easeOut} );
					TweenMax.to(img, .5, { y:0, delay:i*animPadding + 1.5, ease:Bounce.easeOut} );
				}
				else {
					img.texture = atlas.getSwfAtlasItem("starEmpty_mc").texture;
				}
			}
			resizeLayout();
		}
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			for (var i:int = 0; i < _starsRef.length; i++) {
				if (_starsRef[i]) {
					_starContainer.addChild(_starsRef[i]);
					_starsRef[i].x = _starsRef[i].width * 1.2 * i;
				}
			}
			ScalingUtil.floatInContainer(_starContainer, this, "horizontalCenter", 0);
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}