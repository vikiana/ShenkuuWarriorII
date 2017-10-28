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
	import flash.net.Responder;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.flashvars.FlashVarManager;
	import virtualworlds.net.AmfDelegate;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	
	public class QuestPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const QUEST_STATUS_RESULT:String = "questService_getStatus_result";
		public static const QUEST_STATUS_FAULT:String = "questService_getStatus_fault";
		public static const CLAIM_PRIZE_REQUEST:String = "questService_claimPrize";
		public static const CLAIM_PRIZE_RESULT:String = "questService_claimPrize_result";
		public static const CLAIM_PRIZE_FAULT:String = "questService_claimPrize_fault";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
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
		
		public function get servers():NeopetsServerFinder { return _servers; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected function setupAMFPHP():void
		{
			_servers = new NeopetsServerFinder(this);
			// set up communication with php
			_delegate = new AmfDelegate();
			_delegate.gatewayURL = _servers.scriptServer + "/amfphp/gateway.php";
			_delegate.connect();
		}
		
		protected override function setupPage():void {
			// set up amf-php
			setupAMFPHP();
			// set up broadcast listeners
			addEventListener(CLAIM_PRIZE_REQUEST,onClaimRequest);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			// check quest status
			var responder : Responder = new Responder(onStatusResult, onStatusFault);
			_delegate.callRemoteMethod("CapriSun2010Service.getStatus",responder);
			// dispatch tracking requests
			var req_event:CustomEvent = new CustomEvent("CollectionQuest",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("collectionQuest",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16128,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			dispatchEvent(req_event);
		}
		
		// AMF Handlers
		
		// Use this function to try sending out a feed request to php.
		
		protected function onClaimRequest(ev:CustomEvent) {
			trace("sending claim request for prize " + ev.oData);
			var responder:Responder = new Responder(onClaimResult, onClaimFault);
			_delegate.callRemoteMethod("CapriSun2010Service.claimPrize",responder,ev.oData);
		}
		
		/**
		 * Amf success for claimPrize call
		*/
		public function onClaimResult(msg:Object):void
		{
			trace("claimPrize success: " + msg);
			// broadcast status
			var transmission:CustomEvent = new CustomEvent(msg,CLAIM_PRIZE_RESULT);
			dispatchEvent(transmission);
		}
		
		/**
		 * Amf fault for claimPrize call
		*/
		public function onClaimFault(msg:Object):void
		{
			trace("claimPrize fault: " + msg);
			dispatchEvent(new Event(CLAIM_PRIZE_FAULT));
		}
		
		/**
		 * Amf success for getStatus call
		*/
		public function onStatusResult(msg:Object):void
		{
			trace("getStatus success: " + msg);
			// broadcast status
			var transmission:CustomEvent = new CustomEvent(msg,QUEST_STATUS_RESULT);
			dispatchEvent(transmission);
		}
		
		/**
		 * Amf fault for getStatus call
		*/
		public function onStatusFault(msg:Object):void
		{
			trace("getStatus fault: " + msg);
			dispatchEvent(new Event(QUEST_STATUS_FAULT));
		}

	}
	
}