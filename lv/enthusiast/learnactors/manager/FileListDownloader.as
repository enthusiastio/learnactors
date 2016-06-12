package lv.enthusiast.learnactors.manager {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class FileListDownloader {
		private var _onComplete:Function;
		private var _onFail:Function;
		private var _files:Array;
		private var _downloader:URLLoader;
		private var _currentFile:String;
		private var _urlRequest:URLRequest;
		private var _localDirectory:File;
		private var _folder:String;
		private var _serverRoot:String;
		
		
		public function FileListDownloader() {
			_downloader = new URLLoader();
			_downloader.dataFormat = URLLoaderDataFormat.BINARY;
			_downloader.addEventListener(Event.COMPLETE, onFileDowloaded);
			_downloader.addEventListener(IOErrorEvent.IO_ERROR, onFileDownloadFail);
			
			_urlRequest = new URLRequest();
		}
		
		private function onFileDownloadFail(e:IOErrorEvent):void 
		{
			_onFail(e);
		}
		
		private function onFileDowloaded(e:Event):void {
			var outFile:File = _localDirectory.resolvePath(_currentFile);
			var fs:FileStream = new FileStream();
			fs.open(outFile, FileMode.WRITE);
			fs.writeBytes(_downloader.data);
			fs.close();
			processNextFile()
		}
		
		public function download(serverRoot:String, files:Array, localDirectory:File, onComplete:Function, onFail:Function):void {
			_serverRoot = serverRoot;
			_files = files;
			_localDirectory = localDirectory;
			_onComplete = onComplete;
			_onFail = onFail;
			
			if (_localDirectory.exists) {
				_localDirectory.deleteDirectory(true);
			}
			_localDirectory.createDirectory();
			processNextFile()
		}
		
		private function processNextFile():void {
			if (_files.length == 0) {
				_onComplete();
				return;
			}
			do {
			_currentFile = _files.pop();
			} while (_currentFile == "");
			
			_urlRequest.url = _serverRoot + "/" + _currentFile;
			
			_downloader.load(_urlRequest);
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}