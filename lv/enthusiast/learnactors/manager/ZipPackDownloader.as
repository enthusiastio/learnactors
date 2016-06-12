package lv.enthusiast.learnactors.manager {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import org.as3commons.zip.Zip;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class ZipPackDownloader {
		
		// [ Constants ]
		private static const SERVER_ROOT:String = "http://learnactors.enthusiast.io/packs/";
		private static const IMAGE_DIR:String = "imgs";
		private var fileData:ByteArray;
		private var urlStream:URLStream;
		private var _packId:int;
		private var _progressCallback:Function;
		private var _finishedCallback:Function;
		private var _failCallback:Function;
		private var zip:Zip;
		
		// [ Class variables ]
		
		// [ Items on stage]
		
		public function ZipPackDownloader() {
			fileData = new ByteArray();
			urlStream = new URLStream();
			zip = new Zip();
		}
		
		public function downloadPack(packId:int, progressCallback:Function, finishedCallback:Function, failCallback:Function):void {
			_packId = packId;
			_progressCallback = progressCallback;
			_finishedCallback = finishedCallback;
			_failCallback = failCallback;
			
			var remoteFileURL:String = SERVER_ROOT + packId + ".zip?r=" + Math.random();
			
			urlStream.addEventListener(Event.COMPLETE, onComplete);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlStream.load(new URLRequest(remoteFileURL));
		}
		
		private function onProgress(e:ProgressEvent):void {
			_progressCallback(e.bytesLoaded / e.bytesTotal);
		}
		
		private function onError(e:Event):void {
			removeEventHandlers();
			_failCallback();
		}
		
		private function onComplete(e:Event):void {
			removeEventHandlers();
			
			urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
			
			zip.addEventListener(Event.DEACTIVATE, onZipLoaded);
			zip.loadBytes(fileData);
		}
		
		private function onZipLoaded(e:Event):void 
		{
			zip.removeEventListener(Event.DEACTIVATE, onZipLoaded);
			
			var file:File = File.applicationStorageDirectory.resolvePath(IMAGE_DIR).resolvePath(_packId.toString());
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			
			zip.serialize(fileStream);
			
			_finishedCallback();
		}
		
		private function removeEventHandlers():void {
			urlStream.removeEventListener(Event.COMPLETE, onComplete);
			urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		public function isPackDowloaded(packId:int):Boolean {
			return File.applicationStorageDirectory.resolvePath(IMAGE_DIR).resolvePath(packId.toString()).exists;
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}