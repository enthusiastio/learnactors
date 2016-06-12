package lv.enthusiast.learnactors.manager {
	
	import flash.data.SQLResult;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class PackDownloader {
		
		[Inject]
		public var dbconn:DataBaseConnection;
		
		// [ Constants ]
		private static const SERVER_ROOT:String = "http://learnactors.enthusiast.io/packs/";
		private static const IMAGE_DIR:String = "imgs";
		private static const IMAGE_TMP_DIR:String = "imgs_tmp";
		
		// [ Class variables ]
		private var _progressCallback:Function;
		private var _finishedCallback:Function;
		private var _failCallback:Function;
		private var _queue:Array;
		private var _finished:Array;
		private var _isInterrupted:Boolean;
		
		private var _infoDownloader:URLLoader;
		private var _urlRequest:URLRequest;
		
		private var _fileDownloader:FileListDownloader;
		private var currentItem:Object;
		
		private var _packId:int;
		
		public function PackDownloader() {
			InjectionManager.injector.injectInto(this);
			_infoDownloader = new URLLoader();
			_urlRequest = new URLRequest();
			_fileDownloader = new FileListDownloader();
		}
		
		public function downloadPack(packId:int, progressCallback:Function, finishedCallback:Function, failCallback:Function):void {
			
			_packId = packId;
			_progressCallback = progressCallback;
			_finishedCallback = finishedCallback;
			_failCallback = failCallback;
			_isInterrupted = false;
				
			cleanUpTmpDir();
			
			var actors:SQLResult = dbconn.executeQuery("Select * FROM tbl_actors WHERE packId=" + packId);
			_queue = actors.data;
			if (_queue.length == 0) {
				trace("PackDownloader::downloadPack probably an error")
				finishedCallback();
			} else {
				_finished = [];
				processNextItemInQueue();
			}
		}
		
		private function processNextItemInQueue():void {
			if (_isInterrupted) {
				return;
			}
			_progressCallback(_finished.length / (_queue.length + _finished.length));
			currentItem = _queue.pop();
			_finished.push(currentItem);
			if (currentItem == null) {
				var packDownloadDir:File = File.applicationStorageDirectory.resolvePath(IMAGE_TMP_DIR).resolvePath(_packId.toString());
				var packFinalDir:File = File.applicationStorageDirectory.resolvePath(IMAGE_DIR).resolvePath(_packId.toString());
				packDownloadDir.moveTo(packFinalDir);
				
				_finishedCallback();
			} else {
				processFolder(currentItem.name.toLowerCase());
			}
		}
		
		private function onInfoListLoaded(e:Event):void {
			_infoDownloader.removeEventListener(Event.COMPLETE, onInfoListLoaded);
			_infoDownloader.removeEventListener(IOErrorEvent.IO_ERROR, onInfoFileLoadFail);
			var infoDataContents:String = _infoDownloader.data;
			var files:Array = infoDataContents.split("\r\n");
			var localDir:File = File.applicationStorageDirectory.resolvePath(IMAGE_TMP_DIR).resolvePath(_packId.toString()).resolvePath(currentItem.name.toLowerCase());
			var serverDir:String = SERVER_ROOT + "/" + _packId + "/" + currentItem.name.toLowerCase();
			_fileDownloader.download(serverDir, files, localDir, processNextItemInQueue, onIOError)
		}
		
		private function processFolder(folderName:String):void {
			_urlRequest.url = SERVER_ROOT + "/" + _packId + "/" + folderName + "/index.info";
			_infoDownloader.addEventListener(Event.COMPLETE, onInfoListLoaded);
			_infoDownloader.addEventListener(IOErrorEvent.IO_ERROR, onInfoFileLoadFail);
			_infoDownloader.load(_urlRequest);
		}
		
		private function onInfoFileLoadFail(e:Event):void {
			_infoDownloader.removeEventListener(Event.COMPLETE, onInfoListLoaded);
			_infoDownloader.removeEventListener(IOErrorEvent.IO_ERROR, onInfoFileLoadFail);
			_failCallback();
		}
		
		private function onIOError(e:Event):void {
			_failCallback()
		}
		
		public function interrupt():void {
			_isInterrupted = true;
			_queue = null;
		}
		
		private function cleanUpTmpDir():void {
			var file:File = File.applicationStorageDirectory.resolvePath(IMAGE_TMP_DIR).resolvePath(_packId.toString());
			if (file.exists) {
				file.deleteDirectory(true);
			}
		}
		
		public function isPackDowloaded(packId:int):Boolean {
			return File.applicationStorageDirectory.resolvePath(IMAGE_DIR).resolvePath(packId.toString()).exists;
		}
	
	}

}