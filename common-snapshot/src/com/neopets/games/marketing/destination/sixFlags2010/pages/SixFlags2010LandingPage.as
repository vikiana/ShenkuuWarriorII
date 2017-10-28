/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/Viviana Baldarelli / Clive Henrick
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.sixFlags2010.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleboothInfo;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.games.marketing.destination.sixFlags2010.SixFlagsConstants;
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.games.marketing.destination.sixFlags2010.ecard.ECardPopUp;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SixFlags2010Popup;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SixFlags2010SmallPopup;
	import com.neopets.games.marketing.destination.sixFlags2010.text.TextSixFlags2010;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class SixFlags2010LandingPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//icons All are on Stage
		
		//SixFlags 2010
			
		public var video_btn:MovieClip;
		public var logo_btn:MovieClip;
		public var info_btn:MovieClip;
		public var souvenir_btn:MovieClip;
		public var flagsFrenzy_btn:MovieClip;
		public var Ecard_btn:MovieClip;
		public var feedapet_btn:MovieClip;
		public var flagsofFun_btn:MovieClip;
		public var gamesTower_btn:MovieClip;
		public var rollercoaster_btn:MovieClip;
		
		private const setupX:Number = 397.3
		private const setupY:Number = 279.5;
		
		protected var mSmallPopUp:SixFlags2010SmallPopup;
		protected var mLargePopUp:SixFlags2010Popup;
		protected var mLargeDisplayCheck:Boolean = false;
		protected var mFirstTimeToday:Boolean = true;
		protected var mEcardPopUPScreen:ECardPopUp;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SixFlags2010LandingPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			this.x = setupX;
			this.y = setupY;
			addEventListener(DestinationView.SHOW,onShown);
			setupItems();
			setupListeners();
			checkFirstTime();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function init(pName:String = null):void
		{
		 this.name = pName;
	
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected function setupListeners():void
		{
			video_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			video_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			logo_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			logo_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			info_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			info_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			souvenir_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			souvenir_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			flagsFrenzy_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			flagsFrenzy_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			Ecard_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			Ecard_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			feedapet_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			feedapet_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			//flagsofFun_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			//flagsofFun_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			gamesTower_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			gamesTower_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
			rollercoaster_btn.addEventListener(MouseEvent.MOUSE_OVER,launchInfoPopUp,false,0,true);
			rollercoaster_btn.addEventListener(MouseEvent.MOUSE_OUT,closeInfoPopUp,false,0,true);
		}
		
		
		
		protected function checkFirstTime():void
		{
			trace ("UserLogin:" + Parameters.userName);
			
			if (Parameters.userName == AbsView.GUEST_USER || Parameters.userName == "false")
			{
				Parameters.loggedIn = false;	
			} 
			else
			{
				Parameters.loggedIn = true;
			}
				
			trace ("UserLogin:" + Parameters.userName, "LOGGEDIN:", Parameters.loggedIn);
			
			if (Parameters.loggedIn)
			{
				var responder:Responder = new Responder(checkLogInMessage, checkLogInMessageFault);
				Parameters.connection.call("SixFlagsService.ActivityService", responder, Parameters.userName,SixFlagsConstants.ACTIVITY_LINK_LANDINGPAGE);	
			}
			else
			{
				if (!mLargeDisplayCheck)
				{
					mLargeDisplayCheck = true;
					mLargePopUp.textField.htmlText = TextSixFlags2010.MAINSRC_NOT_LOGIN;
					mLargePopUp.visible = true;
					mLargePopUp.login_btn.visible = true;
				}
			}
			
		}
		
		/**
		 * Check to See if the User is Logged In
		 */
		
		protected function 	checkLogInMessage(msg:Object):void
		{
			
			var result:int = msg.result.valueOf();
			
			trace ("checkLogInMessage Result:",result);
			
			if (result)
			{
				mLargeDisplayCheck = true;
				mLargePopUp.textField.htmlText = TextSixFlags2010.MAINSRC_LOGIN_WELCOME;
				mLargePopUp.visible = true;
				mLargePopUp.login_btn.visible = false;	
			}
			
		}
		
		/**
		 * Amf fault  call
		 */
		
		protected function checkLogInMessageFault(msg:Object):void
		{
			trace("Abstract: checkLogInMessageFault fault: " + msg.toString());
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 * Sets up the Stage Elements
		 */
		
		protected function setupItems():void
		{
			//Small Popup for the Rollovers
			if (mSmallPopUp == null)
			{
				var tClass:Class = LibraryLoader.getLibrarySymbol("popup_small");
				mSmallPopUp = new tClass();	
			}
			
			mSmallPopUp.x = -74.55;
			mSmallPopUp.y = 116.70;
			
			addChildAt(mSmallPopUp,numChildren);
			
			mSmallPopUp.visible = false;
			
			//Larger PopUp for Loggedin or Not Loggedin
			
			if (mLargePopUp == null)
			{
				var tClass2:Class = LibraryLoader.getLibrarySymbol("Message_popupBox");
				mLargePopUp = new tClass2();	
			}
			
			mLargePopUp.x = -227;
			mLargePopUp.y = -206;
			
			addChildAt(mLargePopUp,numChildren);
			
			mLargePopUp.addEventListener(SixFlags2010Popup.CLOSE_BTN_EVENT,closeIntroPopup,false,0,true);
			mLargePopUp.addEventListener(SixFlags2010Popup.LOGIN_BTN_EVENT,loginToSite,false,0,true);
			mLargePopUp.visible = false;
			
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
			
			Parameters.view.trackPageViews (pName);
		}
		
	
		
		protected function launchExternalItem(pGame:int):void
		{
			var tURL:String;
			
			switch (pGame)
			{
				case 1217: //MRSIX
					tURL = Parameters.baseURL + SixFlagsConstants.URL_GAME1;
					sendActivityService(SixFlagsConstants.ACTIVITY_LINK_MRSIX);
					break;
				case 1218: //COASTER
					tURL = Parameters.baseURL +SixFlagsConstants.URL_GAME2;
					sendActivityService(SixFlagsConstants.ACTIVITY_LINK_THRILLRIDE);
					break;
				case 1: // SIX FLAGS LOGO
					tURL = SixFlagsConstants.URL_SIX_FLAGS;
					sendActivityService(SixFlagsConstants.ACTIVITY_LINK_SIXFLAGS);
					break;
			}
			
			trace("launchExternalItem URL:", tURL);
			
			var tURLREQUEST:URLRequest = new URLRequest(tURL);
			navigateToURL(tURLREQUEST);
			
			//ADD TRACKING
		}
		
		protected function sendActivityService(pID:int):void
		{
			if (Parameters.loggedIn)
			{
				Parameters.connection.call("SixFlagsService.ActivityService", null , Parameters.userName, pID);	
			}
		}
		
		protected function EcardDisplayObject():void
		{
			//Small Popup for the Rollovers
			if (mEcardPopUPScreen == null)
			{
				var tClass:Class = LibraryLoader.getLibrarySymbol("ecard_popup");
				mEcardPopUPScreen = new tClass();
				addChildAt(mEcardPopUPScreen,numChildren-1);
			}
			
			mEcardPopUPScreen.x = -298;
			mEcardPopUPScreen.y = -178;

			mEcardPopUPScreen.visible = true;;
	
		}
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 * When the Main Page is Shown
		 */
		
		public function onShown(ev:Event) 
		{
			
			
		}
		protected function closeInfoPopUp(evt:MouseEvent):void
		{
			mSmallPopUp.visible = false;	
		}
		
		protected function closeIntroPopup(evt:Event):void
		{
			mLargePopUp.visible = false;	
		}
		
		protected function loginToSite(evt:Event):void
		{
			mLargePopUp.login_btn.visible = false;
			var tURLREQUEST:URLRequest = new URLRequest(Parameters.baseURL + SixFlagsConstants.LOG_PATH_BASE);
			navigateToURL(tURLREQUEST,"_self");	
		}
		
		protected function launchInfoPopUp(evt:MouseEvent):void
		{
			var X:Number = 0;
			var Y:Number = 0;
			switch (evt.currentTarget.name)
			{
				case "video_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_VIDEO;
					X = SixFlagsConstants.SMPOPUP_VIDEO_X;
					Y = SixFlagsConstants.SMPOPUP_VIDEO_Y;
					break;
				case "logo_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_LOGO;
					X = SixFlagsConstants.SMPOPUP_LOGO_X
					Y = SixFlagsConstants.SMPOPUP_LOGO_Y;
					break;
				case "info_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_INFO;
					X = SixFlagsConstants.SMPOPUP_INFO_X;
					Y = SixFlagsConstants.SMPOPUP_INFO_Y;
					break;
				case "souvenir_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_SOUV;
					X = SixFlagsConstants.SMPOPUP_SOUVENIR_X;
					Y = SixFlagsConstants.SMPOPUP_SOUVENIR_Y;
					break;	
				case "flagsFrenzy_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_FRENZY;
					X = SixFlagsConstants.SMPOPUP_FFRENZY_X;
					Y = SixFlagsConstants.SMPOPUP_FFRENZY_Y;
					break;
				case "Ecard_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_ECARD;
					X = SixFlagsConstants.SMPOPUP_ECARD_X;
					Y = SixFlagsConstants.SMPOPUP_ECARD_Y;
					break;
				case "feedapet_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_FEED;
					X = SixFlagsConstants.SMPOPUP_FEED_X;
					Y = SixFlagsConstants.SMPOPUP_FEED_Y;
					break;	
				case "flagsofFun_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_FLAGS;
					//where is this?
					break;
				case "gamesTower_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_TOWER;
					X = SixFlagsConstants.SMPOPUP_GTOWER_X;
					Y = SixFlagsConstants.SMPOPUP_GTOWER_Y;
					break;
				
				case "rollercoaster_btn":
					mSmallPopUp.textField.htmlText = TextSixFlags2010.MAINSRC_SPOPUP_ROLLERC;
					X = SixFlagsConstants.SMPOPUP_RCOASTER_X;
					Y = SixFlagsConstants.SMPOPUP_RCOASTER_Y;
					break;	
			}
			mSmallPopUp.x = X;
			mSmallPopUp.y = Y;
			mSmallPopUp.visible = true;
		}
		protected override function handleObjClick(e:CustomEvent):void
		{
			if (e.oData.DATA.parent == null)
			{
				return;
			}
			
	
			trace ("FROM LANDINGPAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)			
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				
				switch (objName)
				{
					case "video_btn":
						sendActivityService(SixFlagsConstants.ACTIVITY_LINK_VIDEO);
						gotoPage("video");
						NeoTracker.instance.trackNeoContentID(16358);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Main to Video Gallery');
					break;
					case "logo_btn":
						launchExternalItem(1);
						var l:Loader = new Loader ();
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243389474/direct/01/"));
						NeoTracker.instance.trackNeoContentID(15954);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Main to SixFlags.com');
					break;
					case "info_btn":
						gotoPage("info");	
						NeoTracker.instance.trackNeoContentID(15957);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Main to Info Booth');
					break;
					case "souvenir_btn":
						NeoTracker.instance.trackNeoContentID(15960);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Main to Souvenir Shop');
						gotoPage("souvenir");	
					break;	
					case "flagsFrenzy_btn":
						sendActivityService(SixFlagsConstants.ACTIVITY_LINK_FRENZY);
						NeoTracker.instance.trackNeoContentID(15959);
						//TODO missing call
						//TrackingProxy.sendADLinkCall('');
						gotoPage("flags");
					//}
					//else
					//{
						//gotoPage("notloggedinpopup");
					//}
					break;
					case "Ecard_btn":
						sendActivityService(SixFlagsConstants.ACTIVITY_LINK_ECARD);
						EcardDisplayObject();
					break;
					case "feedapet_btn":
						sendActivityService(SixFlagsConstants.ACTIVITY_LINK_FEED);
						gotoPage("feedaPet");	
						NeoTracker.instance.trackNeoContentID(15958);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Main to Feed-a-pet');
					break;	
					
					case "flagsofFun_btn":
						navigateToURL(new URLRequest (Parameters.baseURL+"/sponsors/sixflags/competition.phtml"), "_self");
						NeoTracker.instance.trackNeoContentID(15961);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Main to Flags of Fun Competition');
					break;
					case "gamesTower_btn":
						launchExternalItem(1217);	
						NeoTracker.instance.trackNeoContentID(15955);
					break;
					case "rollercoaster_btn":
						launchExternalItem(1218);	
						NeoTracker.instance.trackNeoContentID(15956);
					break;
				}
			}
		}
	}
	
}