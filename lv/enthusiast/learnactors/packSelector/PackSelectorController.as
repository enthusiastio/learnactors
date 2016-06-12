package lv.enthusiast.learnactors.packSelector {
	
	import flash.automation.ActionGenerator;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import lv.enthusiast.learnactors.ApplicationModel;
	import lv.enthusiast.learnactors.constants.Screens;
	import lv.enthusiast.learnactors.display.Alert;
	import lv.enthusiast.learnactors.display.DisplayRoot;
	import lv.enthusiast.learnactors.display.Styles;
	import lv.enthusiast.learnactors.gameScreen.GameScreenModel;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.manager.LevelLockManager;
	import lv.enthusiast.learnactors.manager.PackDownloader;
	import lv.enthusiast.learnactors.manager.PlayStoreStub;
	import lv.enthusiast.learnactors.manager.PopupHandler;
	import lv.enthusiast.learnactors.manager.SoundBox;
	import flash.utils.setTimeout;
	import lv.enthusiast.learnactors.model.dto.ActorPack;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class PackSelectorController {
		
		// [ Class variables ]
		[Inject] public var displayRoot:DisplayRoot;
		[Inject] public var gsModel:GameScreenModel;
		[Inject] public var popupHandler:PopupHandler;
		[Inject] public var store:PlayStoreStub;
		[Inject] public var applicationModel:ApplicationModel;
		[Inject] public var levelLockManager:LevelLockManager;
		
		private var _downloadProgress:DownloadProgess;
		private var _downloader:PackDownloader = new PackDownloader();
		private var _selectedItem:PackItemRenderer;
		private var _view:PackSelectorView;
		private var _currentAlert:Alert;
		
		public function PackSelectorController() {
			InjectionManager.injector.injectInto(this);
		}
		
		public function registerView(view:PackSelectorView):void {
			_view = view;
			//popupHandler.show(new Alert("Congrats. You bought the pack. Now click to download it.", "Success", Styles.SUCCESS_BG, Styles.SUCCESS_TITLE_BG, "Close", Styles.SUCCESS_BUTTON_BG));
			store.initialize(onStoreReady, onStoreFail);

		}
		
		public function handeItemPicked(item:PackItemRenderer):void {
			if (!levelLockManager.isUnlocked(item.data.packId)) {
				var packToUnlock:ActorPack = applicationModel.getActorPackById(item.data.packId - 1);
				_currentAlert = new Alert("Reach at least 3 stars at level \"" + packToUnlock.packName + "\" to unlock \"" + item.data.packName + "\"", "This pack is locked", Styles.INFO_BG, Styles.INFO_TITLE_BG, "Close", Styles.INFO_BUTTON_BG, onAlertCloseClicked);
				popupHandler.show(_currentAlert);
			}
			else if (!_downloader.isPackDowloaded(item.data.packId)) {
				if (store.isOwnerOf(item.data.packId)) {
					_selectedItem = item;
					_downloadProgress = new DownloadProgess(onDownloadCancelClick);
					popupHandler.show(_downloadProgress);
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
					_downloader.downloadPack(item.data.packId, onProgress, onDownloadComplete, onFail);
				}
				else {
					store.purchase(item.data.packId, onPurchaseSuccess, onPurchaseFail);
				}
				
			}
			else {
				gsModel.playOnlyTroublesome = _view.troubleSomeActorsChk.isSelected;
				gsModel.selectedPack = item.data;
				displayRoot.showScreen(Screens.GAME_SCREEN);
			}
			
		}
		
		
		
		private function onPurchaseSuccess():void 
		{
			_currentAlert = new Alert("Congrats. You bought the pack. Now click to download it.", "Success", Styles.SUCCESS_BG, Styles.SUCCESS_TITLE_BG, "Close", Styles.SUCCESS_BUTTON_BG, onAlertCloseClicked);
			popupHandler.show(_currentAlert);
			SoundBox.play(SoundBox.PACK_SOUND);
		}
		
		private function onAlertCloseClicked():void 
		{
			popupHandler.removeScreen(_currentAlert);
			_view.setupView();
		}
		
		private function onPurchaseFail(message:String):void 
		{
			_currentAlert = new Alert(message, "Oooops", Styles.ERROR_BG, Styles.ERROR_TITLE_BG, "Close", Styles.ERROR_BUTTON_BG, onAlertCloseClicked);
			popupHandler.show(_currentAlert);
		}
		
		private function onProgress(prc:Number):void 
		{
			_downloadProgress.update(prc);
		}
		
		private function onDownloadComplete():void 
		{
			resetAwakeMode();
			_downloadProgress.update(1);
			popupHandler.removeScreen(_downloadProgress);
			_downloadProgress.destroy();
			_selectedItem.data = _selectedItem.data;
			
			_currentAlert = new Alert("Download complete. You are ready to play.", "Success", Styles.SUCCESS_BG, Styles.SUCCESS_TITLE_BG, "Close", Styles.SUCCESS_BUTTON_BG, onAlertCloseClicked);
			popupHandler.show(_currentAlert);
			SoundBox.play(SoundBox.DOWNLOAD_COMPLETE);
		}
		
		private function onDownloadCancelClick():void 
		{
			resetAwakeMode();
			_downloader.interrupt();
			popupHandler.removeScreen(_downloadProgress);
			_downloadProgress.destroy();
		}
		
		private function resetAwakeMode():void {
			setTimeout(function():void {NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL; }, 10000);
		}
		
		private function onFail():void 
		{
			_currentAlert = new Alert("Failed to download pack. Check the internet?", "Error", Styles.ERROR_BG, Styles.ERROR_TITLE_BG, "Close", Styles.ERROR_BUTTON_BG, onAlertCloseClicked);
			popupHandler.show(_currentAlert);
			SoundBox.play(SoundBox.ERROR);
		}
		
		private function onStoreReady():void 
		{
			trace("PackSelectorController::onStoreReady");
			_view.setupView();
		}
		
		private function onStoreFail(reason:String):void 
		{
			_currentAlert = new Alert(reason, "Error", Styles.ERROR_BG, Styles.ERROR_TITLE_BG, "Close", Styles.ERROR_BUTTON_BG, onAlertCloseClicked);
			popupHandler.show(_currentAlert);
			SoundBox.play(SoundBox.ERROR);
		}
	
	}

}