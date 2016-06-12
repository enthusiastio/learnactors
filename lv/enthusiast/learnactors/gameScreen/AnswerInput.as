package lv.enthusiast.learnactors.gameScreen 
{
	
  import feathers.controls.text.StageTextTextEditor;
  import feathers.controls.text.TextFieldTextRenderer;
  import feathers.controls.TextInput;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.text.StageTextField;
	import flash.text.AutoCapitalize;
	import flash.text.TextFormat;
	import lv.enthusiast.learnactors.display.ActorStageTextField;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import lv.enthusiast.learnactors.textureAtlas.GameScreenTextureAtlas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class AnswerInput extends Sprite
	{
		
		// [ Constants ]
		public static const INPUT_CHANGED:String = "INPUT_CHANGED.AnswerInput";
		
		
		// [ Class variables ]
		[Inject] public var atlas:GameScreenTextureAtlas;
		
		
		// [ Items on stage]
		private var textField:TextInput;
		private var hintField:TextInput;
		private var bg_mc:Image;
		
		
		public function AnswerInput() 
		{
			InjectionManager.injector.injectInto(this);
			
			bg_mc = new Image(atlas.getSwfAtlasItem("input_mc").texture);
			addChild(bg_mc);
			
			hintField = createTextField(0xCCCCCC);
			hintField.touchable = false;
			addChild(hintField);
			
			textField = createTextField(0x555555);
			textField.addEventListener("change", onChange);
			addChild(textField);
		}
		
		private function onChange(e:Event):void 
		{
			dispatchEventWith(INPUT_CHANGED, false, text);
		}
		
		private function createTextField(color:uint):TextInput {
			textField = new TextInput();
			var fieldHeight:Number = bg_mc.height;
			textField.width = bg_mc.width;
			textField.height = bg_mc.height;
			textField.textEditorProperties.autoCapitalize = AutoCapitalize.ALL;
			textField.textEditorProperties.fontFamily = "Arial";
			textField.textEditorProperties.color = color;
			textField.textEditorProperties.fontWeight = "bold";
			textField.paddingLeft = fieldHeight * 0.4;
			textField.paddingRight = fieldHeight * 0.4;
			textField.paddingTop = fieldHeight * 0.22;
			textField.paddingBottom = 0;
			textField.textEditorProperties.fontSize = fieldHeight * 0.5;
			return textField;
		}
		
		public function set text(value:String):void 
		{
			textField.text = value;
		}
		
		public function get text():String 
		{
			return textField.text;
		}
		
		public function set hint(value:String):void 
		{
			hintField.text = value;
		}
		
		public function get hint():String 
		{
			return hintField.text;
		}
		
		
		
		
		// [ Setters & getters ]
		
		
		// [ Event handlers ]
		
		
		
	}

}