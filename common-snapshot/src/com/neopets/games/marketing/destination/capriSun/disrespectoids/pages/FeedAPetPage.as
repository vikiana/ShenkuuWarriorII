/**
 *	This class handles the "kitchen" location in the destination.
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
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class FeedAPetPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const FEED_CODE:String = "caprisun2010";
		public static const FEED_REQUESTED:String = "feed_pet_requested";
		public static const FEED_COMPLETED:String = "feed_pet_completed";
		public static const FEED_FAILED:String = "feed_pet_failed";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// protected variables
		protected var amfphp:DefaultAMFPHP;
		protected var petsClip:MovieClip;
		protected var _backButton:MovieClip;
		protected var _soundButton:MovieClip;
		protected var _violatorClip:MovieClip;
		protected var delegate:AmfDelegate;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedAPetPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			// finish loading
			DisplayUtils.cacheImages(this);
			//DebugTracer.addTextfieldTo(this,width,height);
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
		
		protected function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP(FEED_CODE);
			amfphp.addEventListener(amfphp.PET_DATA_IN, onPetDataIn, false, 0, true);
			amfphp.addEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem, false, 0, true);
			amfphp.addEventListener(amfphp.PET_FED,onPetFed);
			amfphp.addEventListener(amfphp.ERROR_OCCURED,onFeedFail);
			// set up amf delegate for quest notifications
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
		}
		
		protected override function setupPage():void {
			// set up amf-php
			setupAMFPHP();
			// set up broadcast listeners
			addEventListener(FEED_REQUESTED,onFeedRequest);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onFeedFail(ev:Event) {
			dispatchEvent(new Event(FEED_FAILED));
		}
		
		// Use this function to try sending out a feed request to php.
		
		protected function onFeedRequest(ev:CustomEvent) {
			var info:Object = ev.oData;
			if(info != null) amfphp.feedPet(info.name);
			// let php know we've taken a step to completing a task
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("CapriSun2010Service.recordActivity",responder,"act3");
		}
		
		// Broadcasts pet data when it comes in from php.
		
		protected function onPetDataIn(evt:Event):void
		{
			trace ("\n=========	SETUP PETS =======\n");
			// relay amf data
			var info:Array = amfphp.petDataArray;
			var transmission:CustomEvent = new CustomEvent(info,amfphp.PET_DATA_IN);
			dispatchEvent(transmission);
		}
		
		// Broadcast successful pet feed.
		
		protected function onPetFed(ev:Event) {
			dispatchEvent(new Event(FEED_COMPLETED));
			dispatchEvent(new CustomEvent("3",DestinationView.SHOP_AWARD_REQUEST));
		}
		
		// Triggered when pet data request fails.
		
		protected function onNoneErrorProblem(evt:CustomEvent):void
		{
			trace (amfphp.NONE_ERROR_PROBLEM);
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
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			// dispatch tracking requests
			var req_event:CustomEvent = new CustomEvent("FeedAPet",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("feedAPet",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16127,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			dispatchEvent(req_event);
		}
		
	}
	
}