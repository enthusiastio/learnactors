package lv.enthusiast.learnactors.progressScreen {
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import feathers.controls.Screen;
	import flash.display.Stage;
	import lv.enthusiast.learnactors.manager.InjectionManager;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class ProgressScreenView extends Screen {
		// [ Inject ]
		[Inject] public var stageReference:Stage;
		
		// [ Constants ]
		
		// [ Class variables ]
		
		// [ Items on stage]
		private var _graph:Graph;
		
		public function ProgressScreenView() {
			InjectionManager.injector.injectInto(this);
			_graph = new Graph();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			_graph.setData(Vector.<Number>([.2, .34, .32, .4, .43, .52, .51,.62,.66,.71,.81,.92,.9]));
			_graph.resize(stageReference.fullScreenWidth * .9, stageReference.fullScreenWidth * .5 );
			addChild(_graph);
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}