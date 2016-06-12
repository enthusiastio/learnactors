package lv.enthusiast.learnactors.progressScreen {
	
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import starling.display.Graphics;
	import starling.display.Quad;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class Graph extends AbstractSprite {
		
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		private var _graphics:Graphics;
		private var hPadding:int;
		private var vPadding:int;
		private var _data:Vector.<Number>;
		
		public function Graph() {
			super();
			_graphics = new Graphics(this);
		}
		
		public function setData(values:Vector.<Number>):void {
			_data = values;
		}
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			hPadding = _availableWidth * .1;
			vPadding = _availableHeight * .1;
			
			var graphWidth:Number = _availableWidth - hPadding;
			var graphHeight:Number = _availableHeight - vPadding;
			
			_graphics.lineStyle(2, 0x4396FC);
			_graphics.moveTo(hPadding, 0);
			_graphics.lineTo(hPadding, graphHeight);
			_graphics.lineTo(_availableWidth, graphHeight);
			_graphics.endFill();
			
			
			_graphics.lineStyle(1, 0x4396FC, .2);
			var numberOfHLines:int = 5;
			var label:TextField;
			for (var i:int = 0; i < numberOfHLines; i++) 
			{
				var fontSize:Number = _availableHeight * .04;
				label = new TextField(hPadding, fontSize * 1.4, (100 - (i / numberOfHLines) * 100) + " %", "Berliner Grotesk", fontSize, 0xFFFFFF);
				label.y = i * (graphHeight / numberOfHLines) - fontSize * 0.7 ;
				addChild(label);
				_graphics.moveTo(hPadding, i * graphHeight / numberOfHLines);
				_graphics.lineTo(_availableWidth, i * graphHeight / numberOfHLines);
			}
			
			var numberOfVLines:int = 5;
			for (i = 0; i < numberOfVLines; i++) 
			{
				fontSize = _availableHeight * .04;
				label = new TextField(fontSize * 2, fontSize * 1.4, (Math.ceil(_data.length * (i/numberOfVLines)) + 1).toString(), "Berliner Grotesk", fontSize, 0xFFFFFF);
				label.y = graphHeight + (vPadding/2) ;
				label.x = hPadding + ((i / (numberOfVLines-1)) * graphWidth) ;
				addChild(label);			
			}
			
			_graphics.lineStyle(3, 0xBB0000);
			_graphics.moveTo(hPadding, graphHeight - (_data[0] * graphHeight));
			for (var j:int = 1; j < _data.length; j++) 
			{
				_graphics.lineTo(hPadding + (graphWidth / (_data.length-1)) * j, graphHeight - (_data[j] * graphHeight));
			}
			
			
			
		}
		
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}