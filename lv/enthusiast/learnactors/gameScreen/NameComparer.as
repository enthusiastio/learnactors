package lv.enthusiast.learnactors.gameScreen 
{
	
  import com.greensock.motionPaths.RectanglePath2D;
  import flash.display.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class NameComparer 
	{
		private var _correctWord:String;
		private var _correctDoubles:Vector.<String>;
		private var _testDoubles:Vector.<String>;
		
		
		public function NameComparer() 
		{
			_correctDoubles = new Vector.<String>();
			_testDoubles = new Vector.<String>();
		}
		
		public function set correctWord(value:String):void {
			value = value.toLocaleLowerCase();
			_correctWord = value;
			splitInDoubles(value, _correctDoubles);
		}
		
		public function compare(str:String):Number {
			str = str.toLocaleLowerCase();
			splitInDoubles(str, _testDoubles);
			var testDoublesLen:int = _testDoubles.length;
			var correctDoublesLen:int = _correctDoubles.length;
			
			var _correctDoublesClone:Vector.<String> = _correctDoubles.concat();
			var result:Number = 0;
			if (_testDoubles.length > 2) {
				var found:int = 0;
				for (var i:int = 0; i < _correctDoublesClone.length; i++) 
				{
					for (var j:int = 0; j < _testDoubles.length; j++) 
					{
						if (_correctDoublesClone[i] == _testDoubles[j]) {
							found++;
							_correctDoublesClone.splice(i, 1);
							i--;
							_testDoubles.splice(j, 1);
							j--;
							break;
						}
					}
				}
				result = (2 * found) / (testDoublesLen + correctDoublesLen);
			}
			return result;
		}
		
		private function splitInDoubles(word:String, resultVec:Vector.<String>):void {
			resultVec.length = 0;
			for (var i:int = 0; i < word.length-1; i++) 
			{
				resultVec.push(word.substr(i,2));
			}
		}
		
		// [ Setters & getters ]
		
		
		// [ Event handlers ]
		
		
		
	}

}