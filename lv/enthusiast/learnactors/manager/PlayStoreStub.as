package lv.enthusiast.learnactors.manager {
	import flash.events.Event;
	
	public class PlayStoreStub {
		
		public function PlayStoreStub() {
		
		}
		
		public function initialize(onSuccess:Function, onFail:Function):void {
			onSuccess();
		}
		
		public function isOwnerOf(packId:int):Boolean {
			return true;
		}
		
		public function purchase(productId:int, purchaseComplete:Function, purchaseFail:Function):void {
			purchaseComplete();
		}
	
	}
}