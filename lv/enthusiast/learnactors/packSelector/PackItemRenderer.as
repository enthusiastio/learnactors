package lv.enthusiast.learnactors.packSelector 
{
	
	import flash.display.Stage;
	import lv.enthusiast.learnactors.display.ScalingUtil;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.manager.InAppPurchaseManager;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.manager.PackDownloader;
	import lv.enthusiast.learnactors.manager.PlayStoreStub;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	import lv.enthusiast.learnactors.textureAtlas.PacksScreenTextureAtlas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class PackItemRenderer extends Sprite
	{
		
		// [ Constants ]
		[Inject] public var textureAtlas:PacksScreenTextureAtlas;
		[Inject] public var stageRef:Stage;
		[Inject] public var store:PlayStoreStub;
		
		// [ Class variables ]
		private var _data:ActorPack;
		private var _packDownloader:PackDownloader = new PackDownloader();
		private var _packPurchaseManager:InAppPurchaseManager = new InAppPurchaseManager();
		
		
		
		// [ Items on stage]
		private var _img:Image;
		private var _lock:Image;
		private var _buy:Image;
		private var _title:TextField;
		private var _download:Image;
		
		public function PackItemRenderer() 
		{
			InjectionManager.injector.injectInto(this);
		}
		
		public function set data(value:ActorPack):void {
			_data = value;
			
			removeChildren();
			
			_img = initPackIfNeeded(_img, _data.packId, _data.packName);
			addChild(_img);
			addChild(_title);
			
			if (store.isOwnerOf(data.packId)) {
				if(value.isUnlocked) {
					if (_packDownloader.isPackDowloaded(data.packId)) {
						_img.alpha = 1;
					}
					else {
						_download = initImgIfNeeded(_download, "download_btn");
						_download.y = _img.height * .4;
						_download.x = (_img.width-_download.width) / 2
						addChild(_download);
						_img.alpha = .3;
					}
				}
				else
				{
					_lock = initImgIfNeeded(_lock, "lock_btn");
					_lock.y = _img.height * .4;
					_lock.x = (_img.width-_lock.width) / 2
					addChild(_lock);
					_img.alpha = .3;
				}
			}
			else {
				_buy = initImgIfNeeded(_buy, "purchase_btn");
				_buy.y = _img.height * .4;
				_buy.x = (_img.width-_buy.width) / 2
				addChild(_buy);
				_img.alpha = .3;
			}
		}
		
		private function initPackIfNeeded(_img:Image, textureId:int, title:String):Image {
			if(_img) {
				_img .texture = textureAtlas.getSwfAtlasItemForPack(textureId).texture;
				_title.text = title;
			}
			else {
				var texture:Texture = textureAtlas.getSwfAtlasItemForPack(textureId).texture;
				_img = new Image(texture);
				var fontSize:Number = texture.nativeHeight * .2;
				_title = new TextField(_img.width, fontSize*1.5, title, "Berliner Grotesk", fontSize, Styles.TEXT_DEFAULT_COLOR);
				_title.y = texture.nativeHeight;
			}
			return _img;
		}
		
		private function initImgIfNeeded(img:Image, textureId:String):Image {
			if(img) {
				img .texture = textureAtlas.getSwfAtlasItem(textureId).texture;
			}
			else {
				img = new Image(textureAtlas.getSwfAtlasItem(textureId).texture);
			}
			return img;
		}
		
		public function get data():ActorPack {
			return _data;
		}
		
	}

}