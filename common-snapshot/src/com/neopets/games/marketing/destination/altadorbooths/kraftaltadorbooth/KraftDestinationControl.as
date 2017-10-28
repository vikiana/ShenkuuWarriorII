/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.common.DailyPrizePopup;
	import com.neopets.games.marketing.destination.altadorbooths.common.ErrorPopup;
	import com.neopets.games.marketing.destination.altadorbooths.common.InstructionsPage;
	import com.neopets.games.marketing.destination.altadorbooths.common.NotLoggedinPopup;
	import com.neopets.games.marketing.destination.altadorbooths.common.VideoPopup;
	import com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.pages.AvatarsPage;
	import com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.pages.KraftLandingPage;
	import com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.pages.WallpapersPage;
	import com.neopets.games.marketing.destination.kidCuisine2.pages.*;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	import com.neopets.projects.destination.destinationV3.AbsControl;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	public class KraftDestinationControl extends AltadorAlleyDestinationControl
	{
		
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		//NC IDS
		//links - on landing
		private const LANDING_MAIN:int = 16195;
			private const LINK_TO_GAME:int = 16226;
		private const LINK_TO_NICK:int = 16224;
		private const LINK_TO_TOURNAMENT:int = 16413;
		private const LINK_TO_SHUNT:int = 16225;
		private const LINK_TO_WEB:int = 16217;
		private const LINK_TO_SWEEPSTAKE:int = 16216;
		private const LINK_TO_TRIVIA:int = 16215;
		//on other sections
		private const VIDEO_PLAYS:int = 16198;
		//internal
		private const LANDING_TO_WP:int = 16222;
		private const LANDING_TO_AV:int = 16223;
		private const LANDING_TO_DAILY:int = 16220;
		private const LANDING_TO_DINSTRUCTIONS:int = 16221;
	
		//downloads
		private const MOLTARA_800:int = 16227;
		private const KRAFT_800:int = 16229;
		private const MOLTARA_1024:int = 16228;
		private const KRAFT_1024:int = 16230;
		private const AIM_REX:int = 16231;
		private const AIM_COLLISEUM:int = 16233;
		private const AIM_TYRANNIAN:int = 16235;
		private const AIM_MOLTARA:int = 16237;
		private const AIM_YOOYU:int = 16239;
		private const MSN_REX:int = 16232;
		private const MSN_COLLISEUM:int = 16234;
		private const MSN_TYRANNIAN:int = 16236;
		private const MSN_MOLTARA:int = 16238;
		private const MSN_YOOYU:int = 16240;

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function KraftDestinationControl():void
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
			Parameters.view.addChild (new KraftLandingPage ("landing", Parameters.view));
			Parameters.view.addChild (new InstructionsPage ("instructions", Parameters.view ));
			Parameters.view.addChild (new AvatarsPage ("avatars", Parameters.view ));
			Parameters.view.addChild (new WallpapersPage ("wallpapers", Parameters.view ));
			Parameters.view.addChild (new DailyPrizePopup ("dailybonus", Parameters.view, 3 ));
			Parameters.view.addChild (new NotLoggedinPopup ("notloggedinpopup", Parameters.view ));
			Parameters.view.addChild (new VideoPopup ("video", Parameters.view ));
			Parameters.view.addChild (new ErrorPopup ("errorpopup", Parameters.view ));
			
			gotoPage("landing");
			
		}
		
		/**
		 * Amf success for claimPrize call
		 */
		override protected function onClaimResult(msg:Object):void
		{
			if (msg.status){
				if (msg.status == 1){
					trace ("You won a:", msg.prize.name, "URL: ", msg.prize.url);
					Parameters.view.getChildByName("dailybonus").displayPrize(msg.prize.name, msg.prize.url);
				}
				trace ("Daily Bonus status: "+msg.status);
				Parameters.view.getChildByName("dailybonus").setVisible (msg.status);
				gotoPage("dailybonus");
			}
		}
		
		/**
		 * Amf fault for claimPrize call
		 */
		override protected function onClaimFault(msg:Object):void
		{
			gotoPage("errorpopup");
		}
		
		
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
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
					//common
					case "videoclose_btn":
						gotoPage("landing");
						Parameters.view.getChildByName("video").hide();
						break;
					case "close_btn":
						gotoPage("landing");
						break;
					case "questinstructionsclose_btn":
						gotoPage("landing");
						break;
					//Landing
					case "play_btn":
						NeoTracker.processClickURL(LINK_TO_GAME);
						//the below call will happen when the tournament starts. Probably on another link
						//TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Gameing Tournament');
						break;
					case "instructions_btn":
						gotoPage("instructions");
						NeoTracker.instance.trackNeoContentID(LANDING_TO_DINSTRUCTIONS);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Daily Bonus Instructions');
						break;
					case "explosion_btn":
						gotoPage("video");
						Parameters.view.getChildByName("video").show("/sponsors/trailers/2010/kraftmacandcheese_high_v1.flv", 480, 270);//for testing. get the right address from James
						NeoTracker.instance.trackNeoContentID(VIDEO_PLAYS);
						TrackingProxy.sendReportingCall('Mac and Cheese Video','AltadorAlley2010');
						break;	
					case "tournament_btn":
						NeoTracker.processClickURL(LINK_TO_TOURNAMENT);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Gameing Tournament');
						break;
					case "nick_btn":
						NeoTracker.processClickURL(LINK_TO_NICK);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to KaBoom Room');
						break;
					case "shunt_btn":
						NeoTracker.processClickURL(LINK_TO_SHUNT);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Scavenger Hunt');
						break;	
					case "dailybonus_btn":
						if (Parameters.loggedIn){ 
							NeoTracker.instance.trackNeoContentID(LANDING_TO_DAILY);
							sendPrizeRequest("AltadorAlley2010Service.macClaimDaily");
						} else {
							gotoPage("notloggedinpopup");
						}
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Daily Bonus Activity');
						break;
					case "inventory_btn":
						navigateToURL(new URLRequest("http://www.neopets.com/objects.phtml?type=inventory"));
						break;
					case "avatars_btn":
						gotoPage("avatars");
						NeoTracker.instance.trackNeoContentID(LANDING_TO_AV);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Avatar Activity');
						break;
					case "wallpapers_btn":
						gotoPage("wallpapers");
						NeoTracker.instance.trackNeoContentID(LANDING_TO_WP);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Mac and Cheese Booth to Desktop Background Activity');
						break;
					//DOWNLOADS
					case "a1_msn_btn":
						NeoTracker.instance.trackNeoContentID(MSN_REX);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - MSN KMAC icon')
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/msnicons/msn_rex.gif"));
						break;
					case "a2_msn_btn":
						NeoTracker.instance.trackNeoContentID(MSN_COLLISEUM);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - MSN Colisseum icon')
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/msnicons/msn_colliseum.gif"));
						break;
					case "a3_msn_btn":
						NeoTracker.instance.trackNeoContentID(MSN_TYRANNIAN);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - MSN Tyrannian icon')
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/msnicons/msn_tyrannian.gif"));
						break;
					case "a4_msn_btn":
						NeoTracker.instance.trackNeoContentID(MSN_MOLTARA);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - MSN Moltara icon')
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/msnicons/msn_moltara.gif"));
						break;
					case "a5_msn_btn":
						NeoTracker.instance.trackNeoContentID(MSN_YOOYU);
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - MSN Yooyuball icon')
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/msnicons/msn_yooyu.gif"));
						break;
					case "a1_aim_btn":
						//trackAIMIcon('AltadorAlley2010 - AOL KMAC icon')
						trackAIMIcon ('AltadorAlley2010 - AOL KMAC icon');
						NeoTracker.instance.trackNeoContentID(AIM_REX);
						navigateToURL(new URLRequest("aim:BuddyIcon?src="+Parameters.imageURL+"/sponsors/altadoralley/macandcheese/aimicons/aim_rex.gif"), "_self");
						break;
					case "a2_aim_btn":
						NeoTracker.instance.trackNeoContentID(AIM_COLLISEUM);
						trackAIMIcon('AltadorAlley2010 - AOL Colisseum icon')
						navigateToURL(new URLRequest("aim:BuddyIcon?src="+Parameters.imageURL+"/sponsors/altadoralley/macandcheese/aimicons/aim_colliseum.gif"), "_self");
						break;
					case "a3_aim_btn":
						NeoTracker.instance.trackNeoContentID(AIM_TYRANNIAN);
						trackAIMIcon('AltadorAlley2010 - AOL Tyrannian icon')
						navigateToURL(new URLRequest("aim:BuddyIcon?src="+Parameters.imageURL+"/sponsors/altadoralley/macandcheese/aimicons/aim_tyrannian.gif"), "_self");
						break;
					case "a4_aim_btn":
						NeoTracker.instance.trackNeoContentID(AIM_MOLTARA);
						trackAIMIcon('AltadorAlley2010 - AOL Moltara icon')
						navigateToURL(new URLRequest("aim:BuddyIcon?src="+Parameters.imageURL+"/sponsors/altadoralley/macandcheese/aimicons/aim_moltara.gif"), "_self");
						break;
					case "a5_aim_btn":
						NeoTracker.instance.trackNeoContentID(AIM_YOOYU);
						trackAIMIcon('AltadorAlley2010 - AOL Yooyuball icon')
						navigateToURL(new URLRequest("aim:BuddyIcon?src="+Parameters.imageURL+"/sponsors/altadoralley/macandcheese/aimicons/aim_yooyu.gif"), "_self");
						break;
					case "w1_800_btn":
						NeoTracker.instance.trackNeoContentID(MOLTARA_800);
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/backgrounds/Moltara_Desktop_800x600.zip"));
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Moltara Background 800x600')
						break;
					case "w1_1024_btn":
						NeoTracker.instance.trackNeoContentID(MOLTARA_1024);
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/backgrounds/Moltara_Desktop_1024x768.zip"));
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - Moltara Background 1024x7680')
						break;
					case "w2_800_btn":
						NeoTracker.instance.trackNeoContentID(KRAFT_800);
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/backgrounds/Kraft_Desktop_800x600.zip"));
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - KMAC Background 800x600')
						break;
					case "w2_1024_btn":
						NeoTracker.instance.trackNeoContentID(KRAFT_1024);
						navigateToURL(new URLRequest(Parameters.imageURL+"/sponsors/altadoralley/macandcheese/backgrounds/Kraft_Desktop_1024x768.zip"));
						TrackingProxy.sendADLinkCall('AltadorAlley2010 - KAMC Background 1024x7680')
						break;
				}
			}
		}
		
		protected function trackAIMIcon (msg:String):void {
			var t:Timer = new Timer (1000, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:TimerEvent):void{TrackingProxy.sendADLinkCall (msg);}, false, 0, true);
			t.start();
		}
	}
	
}