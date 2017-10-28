/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooths.common
{
	import com.neopets.games.marketing.destination.altadorbooths.common.AbstractPageCustom;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages.TriviaPopup;
	import com.neopets.projects.destination.destinationV2.AbsPage;
	import com.neopets.projects.destination.destinationV3.AbsControl;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	
	import virtualworlds.net.AmfDelegate;

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	public class AltadorAlleyDestinationControl extends AbsControl
	{
		
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		public static const GUEST_USER_ACCOUNT:String = "GUEST_USER_ACCOUNT";
		
		//events for quest
		public static const QUEST_STATUS_RESULT:String = "questService_getStatus_result";
		public static const QUEST_STATUS_FAULT:String = "questService_getStatus_fault";
		
		//events for daily bonus
		public static const CLAIM_PRIZE_REQUEST:String = "questService_claimPrize";
		public static const CLAIM_PRIZE_RESULT:String = "questService_claimPrize_result";
		public static const CLAIM_PRIZE_FAULT:String = "questService_claimPrize_fault";
		
		public static const PAGE_DISPLAY:String = "PageIsDisplayed";
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var _neoTracker:NeoTracker;
		
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function AltadorAlleyDestinationControl():void
		{
			super ();
			Parameters.view.addEventListener(AltadorAlleyDestinationView.LIB_LOADED, handleLibLoaded, false, 0, true);	
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		protected function handleLibLoaded (e:Event):void {
			Parameters.view.removeEventListener(AltadorAlleyDestinationView.LIB_LOADED, handleLibLoaded);	
			createPages();
		}
		
		/**
		 * childInit() is not used in this version of the destination becouse it's being called in  AbsControl after the initial set up is done and it doesn't wait for the library to be loaded.
		 * Override the following instead.
		 * 
		 * */
		protected function createPages():void {
			trace ("Abstract createPages(): override");
		}
		
		/**
		 * 
		 * Navigation. This is a simplified navigation in wich only the opages on top of the selected page will be hidden. This makes it useful for both pages and popups.
		 * 
		 * @param pName      name of the page to navigate to
		 * 
		 * */
		protected function gotoPage(pName:String):void {
			var currentPage:Sprite = Parameters.view.getChildByName(pName);
			///show the page
			currentPage.visible = true;
			
			if (currentPage != null)
			{
				currentPage.dispatchEvent(new Event(AltadorAlleyDestinationControl.PAGE_DISPLAY));	
			}
			
			//hide everything on top
			var currentIndex:int = Sprite(Parameters.view).getChildIndex(currentPage);
			for (var i:int = 0; i< Sprite(Parameters.view).numChildren; i++){
				if (i > currentIndex){
					Sprite(Parameters.view).getChildAt(i).visible = false;
				}
			}
		}
	
		
		protected function sendPrizeRequest (method:String):void {
			var responder:Responder = new Responder(onClaimResult, onClaimFault);
			Parameters.connection.call(method, responder);
		}
		
		
		protected function sendQuestRequest (method:String):void {
			var responder:Responder = new Responder(onQuestResult, onQuestFault);
			Parameters.connection.call(method, responder);
		}
		
		/**
		 * Amf fault for claimPrize call
		 */
		protected function onClaimFault(msg:Object):void
		{
			trace("Abstract: override claimPrize fault: " + msg.toString());
		}
		
		
		
		/**
		 * Amf success for claimPrize call
		 */
		protected function onQuestResult(msg:Object):void
		{
			trace("Abstract: override questRequest success: " + msg);
		}
		
		/**
		 * Amf fault for claimPrize call
		 */
		protected function onQuestFault(msg:Object):void
		{
			trace("Abstract: override questRequest fault: " + msg.toString());
		}
		
		
		
		/**
		 * Amf success for claimPrize call
		 */
		protected function onClaimResult(msg:Object):void
		{
			trace("Abstract: override claimPrize success: " + msg);
		}
		
		/*
		/**
		 * Amf fault for claimPrize call
		 */
		//protected function onClaimFault(msg:Object):void
		//{
		//	trace("Abstract: override claimPrize fault: " + msg);
		//}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*private function createPopup(type:String):void
		{
			trace (this+"create popup"+type);
			var popup:AbstractPageCustom;
			switch (type){
				case "dailyPrize":
					//TODO  uncomment when PHP works
					//checkEligibility();
					popup = new DailyPrizePopup ("", 60, 30, 3, false);// eligible);
				break;
				/*case "simple":
				popup = new PopupSimple ("", 119, 11, 3);
				break;
				case "giftstand":
				checkEligibility ();
				break;
				case "VIP":
				popup = new PopupBadges ("", 60, 30, 3);
				break;
				
			}
			if (popup){
				Parameters.view.addChild (popup)
			}
		}*/
		
		//DAILY PRIZE REDEMPTION
		/*private function claimPrize(id:int):void {
			if (checkEligibility()){
				var baseURL:String = "http://dev.neopets.com"//mView.control.baseURL;//"http://dev.neopets.com" 	// this info should come via flashvar
				Amfphp.instance.init(baseURL)  // Where to connect to
				_responder = new Responder(returnGift, returnError);	// make an appropriate responder  for your proj
				Amfphp.instance.connection.call("Lunchables2009.give", _responder, id);	//make a call
				_bagRequested = id;
			}
		}
		
		private function checkEligibility():void
		{
			var baseURL:String = "http://www.neopets.com"//mView.control.baseURL;//"http://dev.neopets.com" 	// this info should come via flashvar
			Amfphp.instance.init(baseURL)  // Where to connect to
			_responder = new Responder(returnEligible, returnError);	// make an appropriate responder  for your proj
			Amfphp.instance.connection.call("Lunchables2009.eligible", _responder);	//make a call
			
		}
		
		private function returnEligible (obj:Object):void 
		{
			var eligible:Boolean;
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i])
				if (i == "eligible"){
					eligible = obj[i];
				}
			}
			///TODO: fix positioning
			_popupJar = new DailyPrizePopup ("", 60, 30, 3, false, eligible);
			Parameters.view.addChild (_popupJar)
		}
		
		private function returnError (obj:Object):void {
			trace ("Error in connection or communication with AMFPHP");
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i]);
			}
		}
		
		private function returnGift (obj:Object):void {
			trace ("Returning gift status"+obj);
			/*for (var i:String in obj)
			{
				trace ("returning obj:     "+i+" : "+obj[i]);
				if (i == "result"){
					switch (Number (obj[i]))
					{
						case 1:
							trace ("gift bag was awarded");
							var message:MovieClip = _popupgiftStand.getChildByName("message2") as MovieClip
							message.gotoAndStop(2);
							_popupgiftStand.updateOtherText("message1", "You've received a gift bag!");
							//tracking gift bag received
							NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471143;sz=1x1");
							NeoTracker.instance.trackNeoContentID(15224);
							switch (_bagRequested){
								case 1:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471533;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15225);
									break;
								case 2:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471597;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15226);
									break;
								case 3:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471920;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15227);
									break;
								case 4:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218472586;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15228);
									break;
								case 5:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218472762;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15229);
									break;
								//action = 1, superstar = 2, brain = 3, helper = 4, artist = 5
							}
							break;
						default:
							trace ("NO PRIZE WAS AWARDED: response was"+obj[i]);
							break;
					}
				}
			}
			
		}*/
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
}