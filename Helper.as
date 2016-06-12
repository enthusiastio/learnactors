package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class Helper extends Sprite {
		private var log_txt:TextField;
		
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		
		public function Helper() {
			log_txt = createLogTextField()
			addChild(log_txt);
			generateSQLs();
		}
		
		
		private function generateSQLs():void 
		{
			var packId:int = 6;
			var baseDir:String = "D:\\discipline\\darbs\\Learn Actors\\2.0\\design\\packs\\rescaled\\" + packId;
			var mainDir:File = new File(baseDir);
			var files:Array = mainDir.getDirectoryListing();
			
			var infoContents:String = "";
			for (var i:uint = 0; i < files.length; i++) {
				var curDir:File = files[i] as File;
				var actorName:String = curDir.name;
				actorName = actorName.replace(/(^[a-z]|\s[a-z])/g, function(){ return arguments[1].toUpperCase(); });
				infoContents += "executeQuery(\"INSERT INTO tbl_actors(name, packId) VALUES('" + actorName + "'," + packId + ")\");\n";
			}
			addLog(infoContents);
		}
		
		private function generateInfos():void 
		{
			var baseDir:String = "D:\\discipline\\darbs\\Learn Actors\\2.0\\design\\packs\\rescaled\\6";
			var mainDir:File = new File(baseDir);
			var files:Array = mainDir.getDirectoryListing();
			
			for (var i:uint = 0; i < files.length; i++) {
				var infoContents:String = "";
				var curDir:File = files[i] as File;
				var jpgs:Array = curDir.getDirectoryListing();
				for (var j:uint = 0; j < jpgs.length; j++) {
					var curJpg:File = jpgs[j] as File;
					infoContents += curJpg.name + "\r\n"
				}
				var dataFile:File = curDir.resolvePath("index.info");
				var fs:FileStream = new FileStream();
				fs.open(dataFile, FileMode.WRITE);
				fs.writeUTFBytes(infoContents);
			}
		}
		
		private function moveToTester():void {
			var mainDir:File = new File("D:\\discipline\\darbs\\Learn Actors\\2.0\\design\\packs\\fullSize\\6");
			var files:Array = mainDir.getDirectoryListing();
			for (var i:uint = 0; i < files.length; i++) {
				var curDir:File = files[i] as File;
				var jpgs:Array = curDir.getDirectoryListing();
				for (var j:uint = 0; j < jpgs.length; j++) {
					var curJPG:File = jpgs[j];
					var newFile:File = new File("D:\\discipline\\darbs\\Learn Actors\\2.0\\design\\packs\\fullSize\\common\\" + curDir.name + "_" + j.toString() + ".jpg");
					curJPG.moveTo(newFile);
				}
			}
		}
		
		private function renameFolders():void {
			var baseDir:String = "D:\\discipline\\darbs\\Learn Actors\\2.0\\design\\packs\\rescaled\\6";
			var mainDir:File = new File(baseDir);
			var files:Array = mainDir.getDirectoryListing();
			for (var i:uint = 0; i < files.length; i++) {
				var curDir:File = files[i] as File;
				//var newFile:File = new File(baseDir + "\\" + curDir.name.split("_").join(""));
				var tmpDir:File = new File(baseDir + "\\" + curDir.name.toLocaleLowerCase() + "_");
				curDir.moveTo(tmpDir);
				var finalDir:File = new File(tmpDir.nativePath.split("_").join(""));
				tmpDir.moveTo(finalDir);
			}
		}
	
		private function createLogTextField():TextField {
			var log_txt:TextField = new TextField();
			log_txt.width = stage.fullScreenWidth;
			log_txt.height = stage.fullScreenHeight;
			log_txt.defaultTextFormat = new TextFormat("Arial", 14);
			log_txt.border = 1;
			return log_txt;
		}
		
		public function addLog(str:String):void {
			log_txt.appendText(str + "\n");
		}
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}