package lv.enthusiast.learnactors.manager 
{
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class PopupHandler 
	{
		
		private var _bg:Quad;
		public function PopupHandler() 
		{
			_bg = new Quad(1, 1, 0x000000);
			_bg.alpha = .5;
		}
		
		public function show(screen:DisplayObject):void {
			_bg.width = Starling.current.stage.width;
			_bg.height = Starling.current.stage.height;
			
			screen.x = (Starling.current.stage.width - screen.width) / 2;
			screen.y = (Starling.current.stage.height - screen.height) / 2;
			
			Starling.current.stage.addChild(_bg);
			Starling.current.stage.addChild(screen);
		}
		
		public function removeScreen(screen:DisplayObject):void {
			if (screen && (screen.parent == Starling.current.stage)) {
				Starling.current.stage.removeChild(screen);
			}
			
			if (_bg && (_bg.parent == Starling.current.stage)) {
				Starling.current.stage.removeChild(_bg);
			}
		}
		
		
		
		
		
	}

}