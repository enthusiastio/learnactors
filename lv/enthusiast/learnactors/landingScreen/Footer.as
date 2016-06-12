package lv.enthusiast.learnactors.landingScreen 
{
	
	import lv.enthusiast.learnactors.display.AbstractSprite;
	import lv.enthusiast.learnactors.display.Styles;
	import starling.display.Quad;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class Footer extends AbstractSprite
	{
		private var _background:Quad;
		private var _title_txt:TextField;
		
		// [ Constants ]
		
		
		// [ Class variables ]
		
		
		// [ Items on stage]
		
		
		public function Footer() 
		{
			_background = new Quad(1, 1, Styles.PANEL_BACK_COLOR);
			_title_txt = new TextField(100, 100, "Get smarter with this app", "Berliner Grotesk", 12, Styles.TEXT_DEFAULT_COLOR );
		}
		
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			_background.width = _availableWidth;
			_background.height = _availableHeight;
			
			var fontSize:int = _availableHeight * .5
			_title_txt.width = _availableWidth;
			_title_txt.height = fontSize;
			_title_txt.fontSize = fontSize;
			_title_txt.y = _availableHeight * 0.3;
			
			addChild(_background);
			addChild(_title_txt);
		}
		
		// [ Setters & getters ]
		
		
		// [ Event handlers ]
		
		
		
	}

}