package lv.enthusiast.learnactors.manager {
	
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class StarlingManager {
		
		// [ Constants ]
		
		// [ Class variables ]
		private static var _mStarling:Starling;
		private var _callbackReady:Function;
		
		public function StarlingManager(stageRef:flash.display.Stage, callbackReady:Function) {
			if (_mStarling) { // already an instance running
				if (callbackReady != null) {
					callbackReady();
				}
				return;
			}
			
			function onRootCreated(e:Event):void {
				_mStarling.removeEventListener(Event.ROOT_CREATED, onRootCreated);
				_mStarling.start();
				if (callbackReady != null) {
					callbackReady();
				}
			}
			
			_mStarling = new Starling(Sprite, stageRef);
			_mStarling.enableErrorChecking = false;
			_mStarling.shareContext = false;
			_mStarling.simulateMultitouch = false;
			
			_mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
		}
		
		public function loadStarlingContents(clazz:Class, contructorArguments:Array, viewPort:Rectangle):DisplayObject {
			var container:Sprite = new Sprite();
			var instance:DisplayObject = createInstance(clazz, contructorArguments);
			if (viewPort) {
				container.x = viewPort.x;
				container.y = viewPort.y;
				container.clipRect = new Rectangle(0, 0, viewPort.width, viewPort.height);
			}
			// Do not exchange next two lines arround. It will cause only first addedToStage Event to fire, thus mediator for "instance" will not be created.
			_mStarling.stage.addChild(container);
			container.addChild(instance);
			return instance;
		}
		
		public function get starlingInstance():* {
			return Starling.current;
		}
		
		public function unloadStarlingContents(dob:DisplayObject):void {
			// tmp implementaton
			if (!dob)
				return;
			dob.removeFromParent(true);
		}
		
		public function enableInteraction(value:Boolean):void {
			if (!Starling.current) {
				return;
			}
			Starling.current.stage.touchable = value;
		}
		
		public function destroy():void {
			Starling.current.context.dispose();
			Starling.current.dispose();
			_mStarling = null;
		
		}
		
		public function takeScreenshot(scl:Number = 1.0):BitmapData {
			if (!Starling.current) {
				return null;
			}
			var stage:Stage = Starling.current.stage;
			var width:Number = stage.stageWidth;
			var height:Number = stage.stageHeight;
			
			var rs:RenderSupport = new RenderSupport();
			
			rs.clear(stage.color, 1.0);
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, width, height);
			
			stage.render(rs, 1.0);
			rs.finishQuadBatch();
			
			var outBmp:BitmapData = new BitmapData(width * scl, height * scl, true);
			Starling.context.drawToBitmapData(outBmp);
			
			return outBmp;
		}
		
		private function createInstance(clazz:Class, arg:Array):DisplayObject {
			if (!arg || arg.length == 0) {
				return new clazz();
			}
			switch (arg.length) {
				case 1: 
					return new clazz(arg[0]);
				case 2: 
					return new clazz(arg[0], arg[1]);
				case 3: 
					return new clazz(arg[0], arg[1], arg[2]);
				case 4: 
					return new clazz(arg[0], arg[1], arg[2], arg[3]);
				// ... add more argument options if you need
				default: 
					throw new Error("too much arguments in createInstance");
			}
		}
	
		// [ Setters & getters ]
	
		// [ Event handlers ]
	
	}

}

