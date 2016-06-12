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
	public class TopTitle extends AbstractSprite
	{
		
		// [ Constants ]
		
		
		// [ Class variables ]
		
		
		// [ Items on stage]
		private var _background:Quad;
		private var _title_txt:TextField;
		private var _subTitle_txt:TextField;
		
		
		public function TopTitle() 
		{
			_background = new Quad(1, 1, Styles.PANEL_BACK_COLOR);
			_title_txt = new TextField(10, 10, "Learn Actors", "Berliner Grotesk", 12, Styles.TEXT_DEFAULT_COLOR);
			_subTitle_txt = new TextField(10, 10, "The quiz game", "Berliner Grotesk", 12, Styles.TEXT_DEFAULT_COLOR);
		}
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			_background.width = _availableWidth;
			_background.height = _availableHeight;
			
			var fontSize:int = _availableHeight * .4
			_title_txt.width = _availableWidth;
			_title_txt.height = fontSize;
			_title_txt.fontSize = fontSize;
			_title_txt.y = _availableHeight * .2;
			
			fontSize = _availableHeight * .2;
			_subTitle_txt.width = _availableWidth;
			_subTitle_txt.height = fontSize*1.3;
			_subTitle_txt.fontSize = fontSize;
			_subTitle_txt.y = _availableHeight * .6;
			
			addChild(_background);
			addChild(_title_txt);
			addChild(_subTitle_txt);
			
		}
		
		
		// [ Setters & getters ]
		
		
		// [ Event handlers ]
		
		
		
	}

}