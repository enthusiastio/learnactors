package lv.enthusiast.learnactors {
	
	import feathers.controls.TextInput;
	import lv.enthusiast.learnactors.display.Styles;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author
	 */
	public class TestText extends Sprite {
		private var textField:TextInput;
		
		public function TestText() {
			textField = new TextInput();
			textField.width = 500;
			textField.height = 200;
			textField.textEditorProperties.fontFamily = "Arial";
			textField.textEditorProperties.color = Styles.TEXT_EMPH_COLOR;
			textField.textEditorProperties.fontSize = 24;
			addChild(textField);
		}
	}

}