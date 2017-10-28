/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooths.popsiclebooth
{
	import com.neopets.games.marketing.destination.altadorbooths.common.AbstractPageCustom;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationView;
	import com.neopets.games.marketing.destination.altadorbooths.common.DailyPrizePopup;
	import com.neopets.games.marketing.destination.altadorbooths.common.ErrorPopup;
	import com.neopets.games.marketing.destination.altadorbooths.common.InstructionsPage;
	import com.neopets.games.marketing.destination.altadorbooths.common.NotLoggedinPopup;
	import com.neopets.games.marketing.destination.altadorbooths.common.VideoPopup;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages.PopsicleDailyPrizePopup;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages.PopsicleLandingPage;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages.PopsicleQuestPage;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages.PopsicleQuestPrizePopup;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages.TriviaPopup;
	import com.neopets.projects.destination.destinationV3.AbsControl;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	


	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	public class PopsicleDestinationControl extends AltadorAlleyDestinationControl
	{
		
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
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
		public static const QUESTPRIZE_POPUP:String = "openQuestPrizesPopup";
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function PopsicleDestinationControl():void
		{
			super ();
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
		override protected function createPages():void{
			setupMainPage();
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up pages\n");
			Parameters.view.addChild (new PopsicleLandingPage ("landing", Parameters.view));
			
			Parameters.view.addChild (new PopsicleQuestPage ("quest", Parameters.view ));
			PopsicleQuestPage(Parameters.view.getChildByName("quest")).addEventListener (QUESTPRIZE_POPUP, openQuestPrizePopup, false, 0, true);
			Parameters.view.addChild (new PopsicleQuestPrizePopup ("questprizepopup", Parameters.view ));
			
			Parameters.view.addChild (new InstructionsPage ("questinstructionspage", Parameters.view ));

			
			Parameters.view.addChild (new TriviaPopup ("trivia"));//"trivia", Parameters.view ));
			
			Parameters.view.addChild (new PopsicleDailyPrizePopup ("dailybonus", Parameters.view, 4 ));
			
			Parameters.view.addChild (new NotLoggedinPopup ("notloggedinpopup", Parameters.view ));
			Parameters.view.addChild (new ErrorPopup ("errorpopup", Parameters.view ));
			
			Parameters.view.addChild (new VideoPopup ("video", Parameters.view ));

			
			gotoPage("landing");
		}
		
		/**
		 * Amf success for claimPrize call
		 */
		override protected function onClaimResult(msg:Object):void
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
		
		
		/**
		 * Amf success for claimPrize call
		 */
		override protected function onQuestResult(msg:Object):void
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
			gotoPage("quest");
			Parameters.view.getChildByName("quest").setResultsObj (msg);
			Parameters.view.getChildByName("questprizepopup").setResultsObj (msg);
		}
		
		/**
		 * Amf fault for claimPrize call
		 */
		override protected function onQuestFault(msg:Object):void
		{
			gotoPage("errorpopup");
		}
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------	
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		protected function openQuestPrizePopup(e:Event):void {
			
			e.target.removeEventListener (QUESTPRIZE_POPUP, openQuestPrizePopup);
			gotoPage ("questprizepopup");
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
					case "questprizeclose_btn":
						PopsicleQuestPage(Parameters.view.getChildByName("quest")).addEventListener (QUESTPRIZE_POPUP, openQuestPrizePopup, false, 0, true);
						gotoPage("quest");
						break;
					case "questclose_btn":
						//TODO add cleanup? maybe..
						PopsicleQuestPage(Parameters.view.getChildByName("quest")).reset();
						gotoPage("landing");
						break;
					case "close_btn":
						gotoPage("landing");
						break;
					case "activitycomplete_btn":
						var weekid:String = PopsicleQuestPage(Parameters.view.getChildByName("quest")).currentWeek.id;
						PopsicleQuestPage(Parameters.view.getChildByName("quest")).addHiddenTask (weekid);
						break;
					case "videoclose_btn":
						gotoPage("landing");
						Parameters.view.getChildByName("video").hide();
						break;
					case "triviaclose_btn":
						gotoPage("landing");
						TriviaPopup(Parameters.view.getChildByName("trivia")).cleanup();
						//TODO add code to cleanup the trivia page if needed
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
					case "trivia_btn":
						if (Parameters.loggedIn){
							gotoPage("trivia");
							Parameters.view.getChildByName("trivia").showTrivia();
							NeoTracker.instance.trackNeoContentID (LANDING_TO_TRIVIA);
							TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Daily Trivia');
						} else {
							gotoPage("notloggedinpopup");
						}
						break;
					case "logo_btn":
						NeoTracker.processClickURL(LINK_TO_WEBSITE);
						Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "website");
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Popsicle.com');
						break;	
					case "questlogo_btn":
						NeoTracker.processClickURL(SOS_TO_WEBSITE);
						Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "website");
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Stacks of Sticks to Popsicle.com');
						break;
					case "dailybonus_btn":
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
					case "quest_btn":
						if (Parameters.loggedIn){ 
							NeoTracker.instance.trackNeoContentID (LANDING_TO_STACKOFSTICKS);
							sendQuestRequest("AltadorAlley2010Service.popStatus");
						} else {
							gotoPage("notloggedinpopup");
						}
						TrackingProxy.sendReportingCall('Popsicle Stacks of Sticks','AltadorAlley2010');
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Stacks of Sticks');
						break;
					case "sweepstake_btn":
						NeoTracker.processClickURL(LINK_TO_SWEEPSTAKE);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Main to Popsicle Sweepstakes');
						break;	
					//Quest 
					case "questinstructions_btn":
						NeoTracker.instance.trackNeoContentID (SOS_TO_INSTRUCTIONS);
						gotoPage("questinstructionspage");
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Stacks of Sticks to Instructions');
						break;
					case "questinstructionsclose_btn":
						gotoPage("quest");
						break;
					//trivia
					case "triviahint_btn":
						NeoTracker.processClickURL(TRIVIA_TO_WEBSITE);
						break;
					//etc.
					
				}
			}
		}
	}
}