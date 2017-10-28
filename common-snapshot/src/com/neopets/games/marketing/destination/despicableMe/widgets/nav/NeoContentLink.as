/**
 *	This class handles links to other pages in the same destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.nav
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import flash.net.Responder;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import virtualworlds.lang.TranslationManager;
	
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
		public var trackingURLS:Array; // for misc urls that can just be sent out on a click
		protected var delegate:AmfDelegate;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function NeoContentLink():void {
			super();
			// set up broadcasts
			useParentDispatcher(AbsPage);
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function setTranslation(txt:TextField,id:String) {
			if(txt != null) {
				// load translated text
				var translator:TranslationManager = TranslationManager.instance;
				if(translator.translationData != null) {
					txt.htmlText = translator.getTranslationOf(id);
				} else txt.text = id;
			}
		}
		
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
			// send out misc tracking url calls
			if(trackingURLS != null) {
				var req:URLRequest;
				for(var i:int = 0; i < trackingURLS.length; i++) {
					req = new URLRequest(trackingURLS[i]);
					sendToURL(req);
				}
			}
			// handle remaining tracking requests
			if(ADLinkID != null) broadcast(DestinationView.ADLINK_REQUEST,ADLinkID);
			// trigger the link
			if(neoContentID > 0) broadcast(DestinationView.NEOCONTENT_LINK_REQUEST,neoContentID);
			// trigger the quest event
			if(questID != null) {
				if(delegate == null) setupAMFPHP();
				// let php know we've taken a step to completing a task
				var responder:Responder = new Responder(onRecordResult,onRecordFault);
				delegate.callRemoteMethod("DespicableMe2010Service.recordActivity",responder,questID);
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