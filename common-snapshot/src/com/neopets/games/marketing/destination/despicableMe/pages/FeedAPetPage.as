/**
 *	This class handles the "kitchen" location in the destination.
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.despicableMe.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import virtualworlds.lang.TranslationManager;
	import flash.net.Responder;
	
	public class FeedAPetPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const FEED_CODE:String = "despicableme"; 
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
			
			trace("What is: "+logo_mc);
			logo_mc.buttonMode = true;
			back_mc.addEventListener(MouseEvent.CLICK, backMCTracking);
			logo_mc.addEventListener(MouseEvent.CLICK, logoTracking);
			logo_mc.addEventListener(MouseEvent.CLICK, goToSite);
			
			// set up instruction text
			setTranslation(sign_txt,"IDS_GRUS_CAFE");
			setTranslation(step_1_mc,"IDS_FEED_STEP_1");
			setTranslation(step_2_mc,"IDS_FEED_STEP_2");
			
			// dispatch tracking when shown by preloader
			this.addEventListener(DestinationView.SHOW,onShown);
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
			delegate.callRemoteMethod("DespicableMe2010Service.recordActivity",responder,"feed");
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
		
		protected function onShown(ev:Event) {
			// Metric tracking
			var rand:int = Math.floor(Math.random() * 1000000);
			var url:String = "http://ad.doubleclick.net/ad/N4518.Neopets/B4526503.24;sz=1x1;ord="+rand+"?";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Feed-A-Pet','DespicableMe2010')");
				ExternalInterface.call("window.top.urchinTracker('DespicableMe2010/FeedAPet')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
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
		
		private function backMCTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224987286;15177704;t?http://www.neopets.com/sponsors/despicableme/index.phtml";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
		}
		
		private function logoTracking(e:Event):void
		{
			// Metric tracking
			//var url:String = "http://ad.doubleclick.net/clk;224987541;15177704;n?http://www.despicable.me/";
			var url:String = "http://ad.doubleclick.net/clk;224987541;15177704;n?http://ad.doubleclick.net/clk;225101386;48963470;i";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			// Javascript tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Destination Feed-a-Pet to Despicable.Me Microsite')");
				
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
			
		}
		
		private function goToSite(e:Event):void 
		{
			// Old version
			//var url:String = "http://www.neopets.com/process_click.phtml?item_id=16261";
			
			var req_event:CustomEvent = new CustomEvent(16326,DestinationView.NEOCONTENT_LINK_REQUEST);
			dispatchEvent(req_event);
			
		}
		
	}
	
}