/**
 *	This class handles the first page users should see on entering the 

destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/Viviana Baldarelli / Clive Henrick
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.CapriSun2011.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.CapriSun2011.CapriSun2011Constants;
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	import com.neopets.games.marketing.destination.CapriSun2011.ecard.ECardPopUp;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SixFlags2010Popup;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SixFlags2010SmallPopup;
	import com.neopets.games.marketing.destination.CapriSun2011.text.TextSixFlags2010;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleboothInfo;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.games.marketing.destination.movieCentral.MovieCentralControl;
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
	import flash.net.SharedObject;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.CapriSun2011PointGrabPage;

	
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
	import flash.external.ExternalInterface;
	
	public class CapriSun2011LandingPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		// New buttons - a btnArea movieclip needs to be added to these for the rollover effect to work	
		public var video_btn:MovieClip;
		public var nick_btn:MovieClip;
		public var respect_btn:MovieClip;
		public var community_btn:MovieClip;
		public var welcome_mc:MovieClip;
		public var close_btn:MovieClip;
		
		public var don_mc:MovieClip;
		public var peggy_mc:MovieClip;
		
		//PointGrab page reference
		protected var mPointGrabScreen:CapriSun2011PointGrabPage;
		
		
		protected var donPopupMC:MovieClip;
		protected var peggyPopupMC:MovieClip;
		
		private const setupX:Number = 0;
		private const setupY:Number = 0;
		
		protected var mSmallPopUp:SixFlags2010SmallPopup;
		protected var mLargePopUp:SixFlags2010Popup;
		
		protected var mLargeDisplayCheck:Boolean = false;
		protected var mFirstTimeToday:Boolean = true;
		protected var loadRecord:SharedObject;
		
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CapriSun2011LandingPage(pName:String = null, pView:Object = null):void
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
		 //this.name = pName;
		 //super (pName)
		 if (pName != null) this.name = pName;
	
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected function setupListeners():void
		{
			// Links
			nick_btn.addEventListener(MouseEvent.CLICK,goToNickSite,false,0,true);
			respect_btn.addEventListener(MouseEvent.CLICK,goToCapriSite,false,0,true);	
			don_mc.addEventListener(MouseEvent.CLICK,openDonPopup,false,0,true);
			peggy_mc.addEventListener(MouseEvent.CLICK,openPeggyPopup,false,0,true);
			
			// Close the welcome popup if it exists
			welcome_mc.close_btn.addEventListener(MouseEvent.CLICK,closeIntroPopup,false,0,true);
		}
		
	
		// Pop up will be visible ONLY the first time the user enters the destination
		protected function checkFirstTime():void
		{
			trace("==== checkFirstTime()in LandingPage ====");
			
			loadRecord = SharedObject.getLocal("CapriSunLandingPage_SO"); // Randomly created name
			if(loadRecord != null) {
				var info:Object = loadRecord.data;
				
				if("last_load" in info) {
					
					trace("==== Shared Object exists, don't show Welcome Popup ====");
					// hide the message window
					if(welcome_mc != null) 
						
						welcome_mc.visible = false;
				}
				info.last_load = new Date();
			}
			
			
			
			
		}
		
		/*  Not used on Landing Page ---------
		
		 //Check to See if the User is Logged In
		 
		
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
		
		
		 //Amf fault  call
		 protected function checkLogInMessageFault(msg:Object):void
		{
			trace("Abstract: checkLogInMessageFault fault: " + msg.toString());
		}
		
		
		*/
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 * Sets up the Stage Elements
		 */
		
		protected function setupItems():void
		{
			// Point Grab reference
			var tClass4:Class = LibraryLoader.getLibrarySymbol("PointGrabScreen");
			mPointGrabScreen = new tClass4();
			mPointGrabScreen.init("pointGrab");
			
			
			//welcomePopUp.close_btn.addEventListener(MouseEvent.CLICK,closeIntroPopup,false,0,true);
			/*
			//Larger PopUp for Loggedin or Not Loggedin
			
			if (mLargePopUp == null)
			{
				var tClass2:Class = LibraryLoader.getLibrarySymbol("Message_popupBox");
				mLargePopUp = new tClass2();	
			}
			
			// Main Intro Popup
			mLargePopUp.x = -14;
			mLargePopUp.y = 3;
			
			addChildAt(mLargePopUp,numChildren);
			
			mLargePopUp.addEventListener(SixFlags2010Popup.CLOSE_BTN_EVENT,closeIntroPopup,false,0,true);
			mLargePopUp.visible = false;
			
			// Disable button until ready to go live
			//mLargePopUp.addEventListener(SixFlags2010Popup.LOGIN_BTN_EVENT,loginToSite,false,0,true);
			*/
			
		}
		
		
		
		// Will be used in phase 2
		// 	window.top.sendADLinkCall('CapriSun2011 - Destination Main - Simon callout')
		
		protected function openDonPopup(evt:Event):void
		{
			var tClass3:Class = LibraryLoader.getLibrarySymbol("donPopup");
			donPopupMC = new tClass3();	
			
			donPopupMC.x = 0;
			donPopupMC.y = 0;
			
			addChildAt(donPopupMC,numChildren);
			
			donPopupMC.close_mc.buttonMode = true;
			donPopupMC.close_mc.addEventListener(MouseEvent.CLICK,closeDonPopup,false,0,true);
			
			ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Main - Don')");
		

		}
		
		protected function closeDonPopup(evt:Event):void
		{
			donPopupMC.visible = false;
		}
		
		protected function openPeggyPopup(evt:Event):void
		{
			var tClass4:Class = LibraryLoader.getLibrarySymbol("peggyPopup");
			peggyPopupMC = new tClass4();	
			
			peggyPopupMC.x = 0;
			peggyPopupMC.y = 0;
			
			addChildAt(peggyPopupMC,numChildren);
			
			peggyPopupMC.close_mc.buttonMode = true;
			peggyPopupMC.close_mc.addEventListener(MouseEvent.CLICK,closePeggyPopup,false,0,true);
			
			//
		ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Main - Peggy')");
		
		}
		
		protected function closePeggyPopup(evt:Event):void
		{
			peggyPopupMC.visible = false;
		}
		
		
		/**
		 * 
		 * Navigation. This is a simplified navigation in wich only the opages on top of the selected page will be hidden. 
		 * This makes it useful for both pages and popups.
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
		
	
		protected function sendActivityService(pID:int):void
		{
			if (Parameters.loggedIn)
			{
				//Parameters.connection.call("SixFlagsService.ActivityService", null , Parameters.userName, pID);	
			}
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 * When the Main Page is Shown
		 */
		
		public function onShown(ev:Event):void 
		{
			
			
		}
		
		
		
		protected function closeIntroPopup(evt:Event):void
		{
			
			welcome_mc.visible = false;	
			//close_btn.visible = false;
		}
		
	
		protected function loginToSite(evt:Event):void
		{
			mLargePopUp.login_btn.visible = false;
			var tURLREQUEST:URLRequest = new URLRequest(Parameters.baseURL + CapriSun2011Constants.LOG_PATH_BASE);
			navigateToURL(tURLREQUEST,"_self");	
		}
		
	
		// Added 3/2011
		protected function goToNickSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://ads.nick.com/sponsors/2011/caprisun/truth-or-dare");
			navigateToURL(request);
			
			//amfphp
			var responder:Responder = new Responder(getNickSiteReturn, getNickSiteError);
			Parameters.connection.call("CapriSun2011Service.Activity", responder)
            ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Main to nick.com')");				
			
		}
		
		protected function goToCapriSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.respectthepouch.com");
			navigateToURL(request);
			
			//amfphp
			var responder:Responder = new Responder(getCapriSiteReturn, getCapriSiteError);
			Parameters.connection.call("CapriSun2011Service.Activity", responder)
				
		ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Main to respectthepouch.com')");

			
		}
		
		protected function getNickSiteReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("getNeopointsReturn result:",result);
		}
		
		// What happens if the call fails
		protected function getNickSiteError(msg:Object):void
		{
			trace("getNeopointsError: ", msg.toString());
		}
		
		protected function getCapriSiteReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("getNeopointsReturn result:",result);
		}
		
		// What happens if the call fails
		protected function getCapriSiteError(msg:Object):void
		{
			trace("getNeopointsError: ", msg.toString());
		}
		
	
		
		
		protected override function handleObjClick(e:CustomEvent):void
		{
			if (e.oData.DATA.parent == null)
			{
				return;
			}
			
			//trace ("FROM LANDINGPAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				
				switch (objName)
				{
					case "video_btn":
						gotoPage("video");
						ExternalInterface.call("window.top.sendReportingCall('Video Gallery','CapriSun2011')");
					break;
					
					case "arcade_btn":
						ExternalInterface.call("window.top.sendReportingCall('Arcade','CapriSun2011')");
						gotoPage("arcade");	
						break;
					
					case "pointGrab_btn":
						gotoPage("pointGrab");
						trace("==== POINT GRAB BUTTON PRESSED ====")
						mPointGrabScreen.checkIfPointGrabPlayed(); 
						ExternalInterface.call("window.top.sendReportingCall('Point Grab','CapriSun2011')");
						break;
					
					case "community_btn":
						gotoPage("communityChallenge");
				        ExternalInterface.call("window.top.sendReportingCall('Community Challenge','CapriSun2011')");

						break;
							
				}
			}
		}
	}
	
}