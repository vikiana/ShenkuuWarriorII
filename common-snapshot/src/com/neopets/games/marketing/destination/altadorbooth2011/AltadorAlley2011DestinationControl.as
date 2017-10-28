/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooth2011
{
	import com.neopets.games.marketing.destination.altadorbooth2011.AbstractPageCustom;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.ErrorPopup;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.InstructionsPage;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.NotLoggedinPopup;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.PopsicleDailyPrizePopup;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.PopsicleHuntPage;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.PopsicleHuntPrizePopup;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.PopsicleLandingPage;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.VideoPage;
	import com.neopets.games.marketing.destination.altadorbooth2011.pages.VideoPopup;
	import com.neopets.projects.destination.destinationV2.AbsPage;
	import com.neopets.projects.destination.destinationV3.AbsControl;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import virtualworlds.net.AmfDelegate;

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	public class AltadorAlley2011DestinationControl extends AbsControl
	{
		
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		public static const GUEST_USER_ACCOUNT:String = "GUEST_USER_ACCOUNT";
		
		//events for quest
		public static const HUNT_STATUS_RESULT:String = "huntService_getStatus_result";
		public static const HUNT_STATUS_FAULT:String = "huntService_getStatus_fault";
		
		//events for daily bonus
		public static const CLAIM_PRIZE_REQUEST:String = "huntService_claimPrize";
		public static const CLAIM_PRIZE_RESULT:String = "huntService_claimPrize_result";
		public static const CLAIM_PRIZE_FAULT:String = "huntService_claimPrize_fault";
		
		public static const PAGE_DISPLAY:String = "PageIsDisplayed";
		
		
		//external links - NEOCONTENT TRACKING
		private const LINK_TO_WEBSITE:int = 16217; 
		private const LINK_TO_SWEEPSTAKE:int = 16216;  
		private const TRIVIA_TO_WEBSITE:int = 16200;
		//others
		private const VIDEO_PLAYS:int = 16199;
		//internal
		private const LANDING_TO_PICKASTICK:int = 16213;
		private const LANDING_TO_STACKOFSTICKS:int = 16212;
		private const LANDING_TO_TRIVIA:int = 16215;
		private const LANDING_TO_GAME:int = 16214;
		private const LANDING_MAIN:int = 16196;
		//when is this one tracked? whwn the popup actually opens....
		private const SOS_MAIN:int = 16197;
		private const SOS_TO_INSTRUCTIONS:int = 16219;
		private const SOS_TO_WEBSITE:int = 16218;
		//MORE TRACKING IN PICK A STICK AND QUEST PAGES
		//EVENTS
		public static const HUNTPRIZE_POPUP:String = "openHuntPrizesPopup";
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var _neoTracker:NeoTracker;
		
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function AltadorAlley2011DestinationControl():void
		{
			super ();
			Parameters.view.addEventListener(AltadorAlley2011DestinationView.LIB_LOADED, handleLibLoaded, false, 0, true);	
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
			Parameters.view.removeEventListener(AltadorAlley2011DestinationView.LIB_LOADED, handleLibLoaded);	
			createPages();
		}
		
		/**
		 * childInit() is not used in this version of the destination becouse it's being called in  AbsControl after the initial set up is done and it doesn't wait for the library to be loaded.
		 * Override the following instead.
		 * 
		 * */
		protected function createPages():void {
			setupMainPage();
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			
			Parameters.view.addChild (new PopsicleHuntPage ("hunt", Parameters.view ));
			trace("\nSet up pages\n");
			var pclass:Class = LibraryLoader.getLibrarySymbol("landingPage");
			Parameters.view.addChild (new pclass ("landing", Parameters.view));
			
			//Parameters.view.addChild (new PopsicleHuntPage ("hunt", Parameters.view ));
			//PopsicleHuntPage(Parameters.view.getChildByName("hunt")).addEventListener (HUNTPRIZE_POPUP, openHuntPrizePopup, false, 0, true);
			//Parameters.view.addChild (new PopsicleHuntPrizePopup ("huntprizepopup", Parameters.view ));
			
			//Parameters.view.addChild (new InstructionsPage ("huntinstructionspage", Parameters.view ));
			
			//Parameters.view.addChild (new PopsicleDailyPrizePopup ("dailybonus", Parameters.view, 4 ));
			
			//Parameters.view.addChild (new NotLoggedinPopup ("notloggedinpopup", Parameters.view ));
			//Parameters.view.addChild (new ErrorPopup ("errorpopup", Parameters.view ));
			
			//Parameters.view.addChild (new VideoPage ("video", Parameters.view ));
			
			
			gotoPage("landing");
		}
		
		/**
		 * 
		 * Navigation. This is a simplified navigation in wich only the opages on top of the selected page will be hidden. This makes it useful for both pages and popups.
		 * 
		 * @param pName      name of the page to navigate to
		 * 
		 * 
		 * */
		protected function gotoPage(pName:String):void {
			var currentPage:Sprite = Parameters.view.getChildByName(pName);
			///show the page
			currentPage.visible = true;
			trace (currentPage, "index", Parameters.view.getChildIndex (currentPage));
			if (currentPage != null)
			{
				currentPage.dispatchEvent(new Event(PAGE_DISPLAY));	
			}
			
			//hide everything on top
			var currentIndex:int = Sprite(Parameters.view).getChildIndex(currentPage);
			for (var i:int = 0; i< Sprite(Parameters.view).numChildren; i++){
				trace (Sprite(Parameters.view).getChildAt(i), "index", Parameters.view.getChildIndex (Sprite(Parameters.view).getChildAt(i)));
				if (i > currentIndex){
					Sprite(Parameters.view).getChildAt(i).visible = false;
				}
			}
			trace ("----------------------------------------------------------------");
		}
	
		
		protected function sendPrizeRequest (method:String):void {
			var responder:Responder = new Responder(onClaimResult, onClaimFault);
			Parameters.connection.call(method, responder);
		}
		
		
		protected function sendHuntRequest (method:String):void {
			var responder:Responder = new Responder(onHuntResult, onHuntFault);
			Parameters.connection.call(method, responder);
		}
		
		
		
		//----------------------------------------
		// HANDLERS
		//----------------------------------------
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
		protected function onHuntResult(msg:Object):void
		{
			//TESTING:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			/*Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "game_popsicle");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "game_noise");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "game_shootout");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "game_slushie");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "game_yooyuball");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "join");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "website");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "video");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "trivia");
			Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "pick");*/
			////::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			gotoPage("hunt");
			Parameters.view.getChildByName("hunt").setResultsObj (msg);
			//Parameters.view.getChildByName("questprizepopup").setResultsObj (msg);
		}
		
		/**
		 * Amf fault for claimPrize call
		 */
		protected function onHuntFault(msg:Object):void
		{
			trace("Abstract: override questRequest fault: " + msg.toString());
		}
		
		
		
		/**
		 * Amf success for claimPrize call
		 */
		protected function onClaimResult(msg:Object):void
		{
			trace ("PICK A STICK: msg.status:"+msg.status);
			if (msg.status){
				if (msg.status == 1){
					if (msg.joke != "" && msg.joke != null){
						trace ("You won a joke:", msg.joke);
						Parameters.view.getChildByName("dailybonus").displayPrize(msg.joke);
					} else {
						if (msg.prize){
							trace ("You won a:", msg.prize.name, "URL: ", msg.prize.url);
							Parameters.view.getChildByName("dailybonus").displayPrize(msg.prize.name, msg.prize.url);
						}
					}
				}  else {
					Parameters.view.getChildByName("dailybonus").setVisible (msg.status);
				}
				gotoPage("dailybonus");
			}
			
		}
		
		protected function openHuntPrizePopup(e:Event):void {
			
			e.target.removeEventListener (HUNTPRIZE_POPUP, openHuntPrizePopup);
			gotoPage ("huntprizepopup");
		}
		
		
		/**
		 *	@NOTE:	ALL of the items/objects clicked from the stage will be reported here.
		 *			You simply has to choose to what you will process what you will ignore 
		 *			Here I choose to pick up on most of buttons (that has "btnArea" movie clip within)
		 *			And respond appropriately.  Some buttons are handled by the "page" itself if neccessary.
		 **/
		protected override function handleObjClick(e:CustomEvent):void
		{
			//trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
					//close
					case "huntprizeclose_btn":
						PopsicleHuntPage(Parameters.view.getChildByName("hunt")).addEventListener (HUNTPRIZE_POPUP, openHuntPrizePopup, false, 0, true);
						gotoPage("hunt");
						break;
					case "huntback_btn":
						//TODO add cleanup? maybe..
						gotoPage("landing");
						break;
					case "close_btn":
						gotoPage("landing");
						break;
					case "videoclose_btn":
						gotoPage("landing");
						Parameters.view.getChildByName("video").hide();
						break;
					//Landing
					case "game_btn"://for testing : get the correct address of the video from James
						NeoTracker.processClickURL (LANDING_TO_GAME);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Popsicle Game');
						break;
					case "video_btn":
						gotoPage("video");
						Parameters.view.getChildByName("video").show("/sponsors/trailers/2010/popsicle_high_v1.flv", 320, 240);//for testing : get the correct address of the video from James
						NeoTracker.instance.trackNeoContentID (VIDEO_PLAYS);
						TrackingProxy.sendReportingCall('Popsicle Video','AltadorAlley2010');
						Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "video");
						break;
					case "logo_btn":
						NeoTracker.processClickURL(LINK_TO_WEBSITE);
						Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "website");
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Popsicle.com');
						break;	
					case "huntlogo_btn":
						NeoTracker.processClickURL(SOS_TO_WEBSITE);
						Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "website");
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Stacks of Sticks to Popsicle.com');
						break;
					case "virtualprize_btn":
						if (Parameters.loggedIn){ 
							NeoTracker.instance.trackNeoContentID(LANDING_TO_PICKASTICK);
							sendPrizeRequest("AltadorAlley2010Service.popClaimDaily");
						} else {
							gotoPage("notloggedinpopup");
						}
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Pick a Stick');
						break;
					case "inventory_btn":
						navigateToURL(new URLRequest("http://www.neopets.com/objects.phtml?type=inventory"));
						break;
					case "hunt_btn":
						if (Parameters.loggedIn){ 
							//NeoTracker.instance.trackNeoContentID (LANDING_TO_STACKOFSTICKS);
							sendHuntRequest("AltadorAlley2010Service.popStatus");
						} else {
							gotoPage("notloggedinpopup");
						}
						//TrackingProxy.sendReportingCall('Popsicle Stacks of Sticks','AltadorAlley2010');
						//TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Stacks of Sticks');
						break;
					case "sweepstake_btn":
						NeoTracker.processClickURL(LINK_TO_SWEEPSTAKE);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Popsicle Sweepstakes');
						break;	
					//hunt 
					case "huntinstructions_btn":
						NeoTracker.instance.trackNeoContentID (SOS_TO_INSTRUCTIONS);
						gotoPage("huntinstructionspage");
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Stacks of Sticks to Instructions');
						break;
					case "huntinstructionsclose_btn":
						gotoPage("hunt");
						break;
					//etc.
					
				}
			}
		}

	}
}