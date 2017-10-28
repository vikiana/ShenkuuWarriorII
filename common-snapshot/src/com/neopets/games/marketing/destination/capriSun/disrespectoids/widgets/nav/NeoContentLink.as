/**
 *	This class handles links to other pages in the same destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.nav
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class NeoContentLink extends BroadcasterClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var ADLinkID:String;
		public var neoContentID:int;
		public var questID:String;
		public var shopAwardID:String;
		protected var delegate:AmfDelegate;
		protected var _linkTimer:Timer;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function NeoContentLink():void {
			super();
			// set up link timer
			_linkTimer = new Timer(1000,1);
			_linkTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onLinkTimerDone);
			// set up broadcasts
			useParentDispatcher(AbsPage);
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
			tabEnabled = false;
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
		
		protected function setupAMFPHP():void {
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Relay click through shared dispatcher.
		
		protected function onClick(ev:MouseEvent) {
			// if there's a shop award, delay the link so the award can be seen
			if(shopAwardID != null) {
				broadcast(DestinationView.SHOP_AWARD_REQUEST,shopAwardID);
				_linkTimer.start();
			} else {
				// if there's no shop award, skip the link timer
				onLinkTimerDone(ev);
			}
		}
		
		// After the xp award has had timer to play, follow the link.
		
		protected function onLinkTimerDone(ev:Event) {
			if(ADLinkID != null) broadcast(DestinationView.ADLINK_REQUEST,ADLinkID);
			if(neoContentID > 0) broadcast(DestinationView.NEOCONTENT_LINK_REQUEST,neoContentID);
			if(questID != null) {
				if(delegate == null) setupAMFPHP();
				// let php know we've taken a step to completing a task
				var responder:Responder = new Responder(onRecordResult,onRecordFault);
				delegate.callRemoteMethod("CapriSun2010Service.recordActivity",responder,questID);
			}
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordResult(msg:Object):void {
			trace("onRecordResult: " + msg);
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordFault(msg:Object):void {
			trace("onRecordFault: " + msg);
		}

	}
	
}