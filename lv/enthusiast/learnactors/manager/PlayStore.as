package lv.enthusiast.learnactors.manager {
	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseEvent;
	import com.pozirk.payment.android.InAppPurchaseDetails;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class PlayStore {
		
		protected var _iap:InAppPurchase = new InAppPurchase();
		private var _state:String = "uninitialized";
		private var _allProducts:Array = ["pack_3","pack_4","pack_5","pack_6"];
		private var _skuDetails:Dictionary = new Dictionary(true);
		
		public function PlayStore() {
		
		}
		
		
		public function initialize(onSuccess:Function, onFail:Function):void {
			function onInitComplete():void {
				restore(onSuccess, onFail);
			}
			init(onInitComplete, onFail);
		}
		
		public function isOwnerOf(packId:int):Boolean 
		{
			return true; // free gift :)
			
			if (packId == 1 || packId == 2) {
				return true;
			}
			
			var purchase:InAppPurchaseDetails = _iap.getPurchaseDetails("pack_" + packId);
			return purchase != null;
		}
		
		private function init(initComplete:Function, initFail:Function):void {
			if (_state == "initialized") {
				initComplete();
			} 
			else if (_state == "initializing") {
				initFail("Error, another purchase in progress");
			} 
			else {
				_state = "initializing";
				function onInitSuccess(e:Event):void {
					_iap.removeEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
					_iap.removeEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
					_state = "initialized";
					initComplete();
				}
				
				function onInitError(e:InAppPurchaseEvent):void {
					_iap.removeEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
					_iap.removeEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
					initFail(e.data);
				}
				
				_iap.addEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
				_iap.addEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
				
				_iap.init("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhyFvx9669PmipjNAwY4llnmf1grZYyreh+RaQDvz/TEYj+wz4CeCxRdChu9rGkbU5vKxPx183v+3Kss9HdsliqHYuBhgU1qC4jnqrOqsxo32suhjuBtB/oIiio2t6xB9qe/j2EAkfdglrQb1p1epW7v0JHTYkHhejuWmUHpqT7DK0jGsPHeu5J4TvxTzKPpKwi8y3qNL+EruQVrvglV79TSqfj2MxuZ5BcQ7QtuLCcWkarRxMvwePM1Vs9v5btcPC/AdJN+tbO7BdaTiDxyazY02XreVxGu02pCWhWk0B7B9LGwVqs2KM1RZNFTbykN0iaxsYKPs1BldD2kRiMUJ8wIDAQAB");
				
			}
		}
		
		private function restore(callback:Function, failCallback:Function):void {
			function onRestoreSuccess(e:InAppPurchaseEvent):void {
				_iap.removeEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
				_iap.removeEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
				
				_skuDetails[3] = _iap.getPurchaseDetails("pack_3");
				_skuDetails[4] = _iap.getPurchaseDetails("pack_4");
				_skuDetails[5] = _iap.getPurchaseDetails("pack_5");
				_skuDetails[6] = _iap.getPurchaseDetails("pack_6");
				
				
				/*_iap.consume("pack_3");
				_iap.consume("pack_4");
				_iap.consume("pack_5");
				_iap.consume("pack_6");
				*/
				
				
			
				callback();
			}
			
			function onRestoreError(e:InAppPurchaseEvent):void {
				_iap.removeEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
				_iap.removeEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
				failCallback(e.data);
			}
			
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
			_iap.restore();

		}
		
		public function purchase(productId:int, purchaseComplete:Function, purchaseFail:Function):void {
			function onPurchaseSuccess(e:Event):void {
				_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
				_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseSuccess);
				_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
				restore(purchaseComplete, purchaseFail);
			}
			
			function onPurchaseError(e:InAppPurchaseEvent):void {
				_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
				_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseSuccess);
				_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
				purchaseFail(e.data);
			}
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseSuccess);
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
			_iap.purchase("pack_" + productId, InAppPurchaseDetails.TYPE_INAPP);
		}
	
	}
}