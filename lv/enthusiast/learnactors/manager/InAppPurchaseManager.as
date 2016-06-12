package lv.enthusiast.learnactors.manager {
	
	public class InAppPurchaseManager {
		public function InAppPurchaseManager() {
		
		}
		
		public function isPurchased(packId:int):Boolean {
			return packId < 5;
		}
	}
}