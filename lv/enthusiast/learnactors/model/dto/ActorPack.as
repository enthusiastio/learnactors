package lv.enthusiast.learnactors.model.dto {
	
	/**
	 * ...
	 * @author Cyberprodigy
	 */
	public class ActorPack {
		
		public static const PACK_025:int 	= 1;
		public static const PACK_050:int 	= 2;
		public static const PACK_075:int 	= 3;
		public static const PACK_NEW:int 	= 4;
		public static const PACK_OLD:int 	= 5;
		public static const PACK_ACTION:int 	= 6;
		
		public var packId:int;
		public var packName:String;
		public var price:String;
		public var isUnlocked:Boolean;
	
	}

}