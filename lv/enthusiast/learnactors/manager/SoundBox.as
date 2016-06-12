package lv.enthusiast.learnactors.manager  {

  import flash.events.EventDispatcher;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.net.URLRequest;

	/**
	 * ...
	 * @author CyberProdigy
	 */
	public class SoundBox extends EventDispatcher {
		
		// [ Constants ]
		private static const SOUND_PATH:String = "./assets/sounds/";
			
		public static const STAR_SOUND					:String = SOUND_PATH + "star.mp3";
		public static const CORRECT_SOUND				:String = SOUND_PATH + "correct.mp3";
		public static const PACK_SOUND					:String = SOUND_PATH + "pack.mp3";
		public static const FINISH_SOUND				:String = SOUND_PATH + "finish.mp3";
		static public const ERROR						:String = SOUND_PATH + "error.mp3";
		static public const DOWNLOAD_COMPLETE			:String = SOUND_PATH + "download_complete.mp3";
		static public const SKIP						:String = SOUND_PATH + "skip.mp3";
		
		
		// [ Class variables ]
		private static var _sndChannelRefs:Array = [];
		private static var _sndRefs:Array = [];
		
		
		// [ Items on stage]
		
		
		public function SoundBox() {
			
		}
		
		public static function play(soundURL:String, loops:int = 1):void {
			var sndChannel:SoundChannel = _sndChannelRefs[soundURL] as SoundChannel;
			var sound:Sound = _sndRefs[soundURL] as Sound;
			
			/*if (sndChannel != null) { // if sound is already playing
				sndChannel.stop();
			}
			*/
			
			if (sound == null) { // sound is not loaded yet from the disk
				sound = new Sound(new URLRequest(soundURL));
				_sndRefs[soundURL] = sound;
			}
			
			_sndChannelRefs[soundURL] = sound.play(0, loops);
			
		}
		
		public static function preload(soundURL:String):void {
			var sound:Sound = new Sound(new URLRequest(soundURL));
			_sndRefs[soundURL] = sound;
		}
		
		public static function stop(soundURL:String=null):void {
			if (soundURL == null) {
				for each(var sc:SoundChannel in _sndChannelRefs) {
					sc.stop();
				}
			} else if (_sndChannelRefs[soundURL] != null) {
				SoundChannel(_sndChannelRefs[soundURL]).stop();
			}
		}
		
		// [ Setters & getters ]
		
		
		// [ Event handlers ]
		
		
	}

}