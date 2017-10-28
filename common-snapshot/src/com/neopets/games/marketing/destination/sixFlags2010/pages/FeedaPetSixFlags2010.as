
/**
 *	This class handles the "kitchen" location in the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary / Clive Henrick 
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.sixFlags2010.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.feed.FoodItem;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	import com.neopets.games.marketing.destination.sixFlags2010.SixFlagsConstants;
	import com.neopets.games.marketing.destination.sixFlags2010.button.Button;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.FeedMessagePopUp;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SixFlagsFoodItem;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.Responder;
	
	import virtualworlds.net.AmfDelegate;
	
	public class FeedaPetSixFlags2010 extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		public static const FEED_REQUESTED:String = "feed_pet_requested";
		public static const FEED_COMPLETED:String = "feed_pet_completed";
		public static const FEED_FAILED:String = "feed_pet_failed";
		
		private const startX:Number = 388.50;
		private const startY:Number = 270.75;
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// protected variables
		protected var amfphp:DefaultAMFPHP;
		protected var petsClip:MovieClip;
		public var backBtn:MovieClip; // OnStage
		//protected var _soundButton:MovieClip;
		protected var _violatorClip:MovieClip;
		protected var delegate:AmfDelegate;
		
		public var messageBox:FeedMessagePopUp;
		
		public var apple_mc:SixFlagsFoodItem;// OnStage
		public var popcorn_mc:SixFlagsFoodItem;// OnStage
		public var lemonade_mc:SixFlagsFoodItem;// OnStage
		private var _selectedFood:String = "";
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedaPetSixFlags2010(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			// finish loading
			DisplayUtils.cacheImages(this);
			//DebugTracer.addTextfieldTo(this,width,height);
			// dispatch tracking when shown by preloader
			addEventListener(DestinationView.SHOW,onShown);
			
			
			
			this.x = startX;
			this.y = startY;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function init(pName:String = null):void
		{
			this.name = pName;	
			apple_mc.sharedDispatcher.addEventListener(FoodItem.FOOD_SELECTED, trackFood);
			popcorn_mc.sharedDispatcher.addEventListener(FoodItem.FOOD_SELECTED, trackFood);
			lemonade_mc.sharedDispatcher.addEventListener(FoodItem.FOOD_SELECTED, trackFood);
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP(SixFlagsConstants.FEED_CODE);
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
			delegate.callRemoteMethod("SixFlagsService.ActivityService",responder,SixFlagsConstants.ACTIVITY_LINK_FEED);
			trackFoodItem(_selectedFood);
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
			
			if (Parameters.loggedIn == false)
			{
				messageBox.showLogIn();	
			}
			 
			// dispatch tracking requests
			/*
			var req_event:CustomEvent = new CustomEvent("FeedAPet",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("feedAPet",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16127,DestinationView.NEOCONTENT_IMPRESSION_REQUEST); //TRACKING WILL NEED TO UPDATE
			dispatchEvent(req_event);
			*/
		}
		
		override protected function handleObjClick(e:CustomEvent):void{
			if (e.target.name){
				if (e.target.name == "btnArea"){
					switch (e.target.parent.name){
						case "popcorn_mc":
							_selectedFood = "popcorn";
						break;
						case "apple_mc":
							_selectedFood = "apple";
							break;
						case "lemonade_mc":
							_selectedFood = "lemonade";
							break;
					}
				}
			}
		}
		
		
		private function trackFoodItem (food:String):void {
			trace ("TRACKING FOOD ITEM"+food);
			var ncid:int = 0;
			var adcall:String=  "";
			switch (food){
				case "popcorn_mc":
					ncid = 15963;
					adcall = 'SixFlags2010 - Feed-a-Pet Popcorn';
					break;
				case "apple_mc":
					ncid = 15964;
					adcall = 'SixFlags2010 - Feed-a-Pet Candy Apple';
					break;
				case "lemonade_mc":
					ncid = 15965;
					adcall = 'SixFlags2010 - Feed-a-Pet Frozen Lemonade';
					break;
			}
			
			if (ncid > 0){
				NeoTracker.instance.trackNeoContentID(ncid);
			}
			if (adcall != ""){
				trace ("FOOD AD LINK CALL"+adcall);
				TrackingProxy.sendADLinkCall(adcall);
			}
		}
		
		private function trackFood (e:BroadcastEvent):void {
			_selectedFood = e.sender.name;
		}
		
	}
	
}