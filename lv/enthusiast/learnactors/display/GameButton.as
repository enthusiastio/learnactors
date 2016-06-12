package lv.enthusiast.learnactors.display 
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import starling.display.Button;
	import starling.display.graphics.RoundedRectangle;
	import starling.display.materials.StandardMaterial;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class GameButton extends AbstractSprite 
	{
		
		// [ Constants ]
		
		
		// [ Class variables ]
		private var _originalY:int;
		
		
		// [ Items on stage]
		private var _shadow:RoundedRectangle;
		private var _background:RoundedRectangle;
		private var _label_txt:TextField;
		
		
		public function GameButton(text:String, color:uint, borderRadius:int) 
		{
			_background = new RoundedRectangle(100,100, borderRadius, borderRadius, borderRadius, borderRadius);
			var bgMat:StandardMaterial = new StandardMaterial();
			bgMat.color = color;
			_background.material = bgMat;
			
			_shadow = new RoundedRectangle();
			var shadowMat:StandardMaterial = new StandardMaterial();
			shadowMat.color = 0;
			shadowMat.alpha = .1;
			_shadow.material = shadowMat;
			
			_label_txt = new TextField(100, 100, text, "Berliner Grotesk", 12, Styles.TEXT_DEFAULT_COLOR);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED)) {
				TweenLite.to(this, .1, { y:_originalY } );
				dispatchEventWith(Event.TRIGGERED);
			}
			if (e.getTouch(this, TouchPhase.BEGAN)) {
				TweenLite.killTweensOf(this, true);
				_originalY = y;
				TweenLite.to(this, .1, { y:_originalY+_availableHeight*.05 } );
			}
		}
		
		
		override protected function resizeLayout():void 
		{
			super.resizeLayout();
			
			_shadow.width = _availableWidth;
			_shadow.height = _availableHeight;
			_shadow.y = _availableHeight * .05;
			
			_background.width = _availableWidth;
			_background.height = _availableHeight;
			
			_label_txt.y = _availableHeight * .04;
			_label_txt.width = _availableWidth;
			_label_txt.height = _availableHeight;
			_label_txt.fontSize = _availableHeight * .60;
			
			addChild(_shadow);
			addChild(_background);
			addChild(_label_txt);
		}
		
		public function set label(value:String):void {
			_label_txt.text = value;
		}
		
	}

}