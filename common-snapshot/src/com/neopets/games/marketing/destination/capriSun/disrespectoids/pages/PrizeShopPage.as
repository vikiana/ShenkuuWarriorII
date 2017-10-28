/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.servers.NeopetsAmfManager;
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	
	public class PrizeShopPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const STATUS_RESULT:String = "prize_shop_status_result";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PrizeShopPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// finish loading
			DisplayUtils.cacheImages(this);
			// dispatch tracking when shown by preloader
			addEventListener(DestinationView.SHOW,onShown);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			// dispatch tracking requests
			var req_event:CustomEvent = new CustomEvent("PrizeShop",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("prizeShop",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16129,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			dispatchEvent(req_event);
			// get the user's point total
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
			var responder:Responder = new Responder(onStatusResult,onStatusFault);
			delegate.callRemoteMethod("CapriSun2010Service.prizeShopGetStatus",responder);
		}
		
		// "Get Status" Response Listeners
		
		protected function onStatusResult(msg:Object):void {
			trace("onStatusResult: " + msg);
			// let listeners know about the response
			var transmission:CustomEvent = new CustomEvent(msg,STATUS_RESULT);
			dispatchEvent(transmission);
		}
		
		protected function onStatusFault(msg:Object):void {
			trace("onStatusFault: " + msg);
		}

	}
	
}