
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
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleboothInfo;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.games.marketing.destination.sixFlags2010.SixFlagsConstants;
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SixFlags2010InfoPopup;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SixFlags2010InfoSwitchPopUp;
	import com.neopets.games.marketing.destination.sixFlags2010.text.TextSixFlags2010;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class InfoScreen extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//icons All are on Stage
		
		//SixFlags 2010
		//public var trivia_btn:MovieClip;		
		public var californiaBtn:MovieClip;
		
		public var texasBtn:MovieClip;

		public var illinoisBtn:MovieClip;
		public var missouriBtn:MovieClip;
		
		public var georgiaBtn:MovieClip;
		public var massachusettsBtn:MovieClip;
		public var newYorkBtn:MovieClip;
		public var newJerseyBtn:MovieClip;
		public var marylandBtn:MovieClip;
		public var infoBackBtn:MovieClip;
		
		private const setupX:Number = -44.6;
		private const setupY:Number = -13.7;
		
		public var messagePopUp:SixFlags2010InfoPopup;
		public var switchPopUp:SixFlags2010InfoSwitchPopUp;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function InfoScreen(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			this.x = setupX;
			this.y = setupY;
			setupItems();
			
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
		
		/**
		 * Sets up the Stage Elements
		 */
		
		protected function setupItems():void
		{
			if (messagePopUp == null)
			{
				var tClass:Class = LibraryLoader.getLibrarySymbol("InfoPopUp");
				messagePopUp = new tClass();	
			}
			
			messagePopUp.x = 58.25;
			messagePopUp.y = 39.8;
			
			addChildAt(messagePopUp,numChildren-1);
			
			messagePopUp.visible = false;
			
			messagePopUp.addEventListener(SixFlags2010InfoPopup.CLOSE_BTN_EVENT, closeMessageWindow, false, 0, true);
			messagePopUp.addEventListener(SixFlags2010InfoPopup.WEB_BTN_EVENT, launchWebSite, false, 0, true);
			messagePopUp.addEventListener(SixFlags2010InfoPopup.GOBACK_EVENT, goBack, false, 0, true);
			
			
			
			if (switchPopUp == null)
			{
				var tClass2:Class = LibraryLoader.getLibrarySymbol("popup_InfoSwitch");
				switchPopUp = new tClass2();	
			}
			
			switchPopUp.x = 120.25;
			switchPopUp.y = 85.8;
			
			addChildAt(switchPopUp,numChildren-1);
			
			switchPopUp.visible = false;
			
			switchPopUp.addEventListener(SixFlags2010InfoSwitchPopUp.CLOSE_BTN_EVENT, closeMessageWindow, false, 0, true);
			switchPopUp.addEventListener(SixFlags2010InfoSwitchPopUp.IMAGE_BTN_EVENT,imageButtonClicked, false, 0, true);
			
		}
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		protected override function handleObjClick(e:CustomEvent):void
		{
			if (this.visible == true)
			{
				
		
				trace ("FROM INFO PAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)			
				
				var libPath:String;
				var l:Loader = new Loader();
				
				
				Parameters.onlineMode ? libPath = Parameters.imageURL+ "/" + SixFlagsConstants.IMG_PATH_BASE : libPath = SixFlagsConstants.IMG_PATH_BASE;
				
				switch (e.oData.DATA.parent.name)
				{
					case "californiaBtn": //LA
						switchPopUp.init(libPath + SixFlagsConstants.SIX_FLAGS_CA_IMG,libPath + SixFlagsConstants.SIX_FLAGS_CA_SF_IMG,"californiaBtn","californiaBtn2",true);
						switchPopUp.visible = true;
						break;

					case "texasBtn": //ARR
						switchPopUp.init(libPath + SixFlagsConstants.SIX_FLAGS_TX_IMG,libPath + SixFlagsConstants.SIX_FLAGS_TX_SA_IMG,"texasBtn","texasBtn2");
						switchPopUp.visible = true;
						break;
					case "illinoisBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_ILLINOIS_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_ILLINOIS_BOT;
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_IL_URL;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_IL_IMG);
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_IL;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408947/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16348);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFGA IL');
						break;
					case "missouriBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_MISSOURI_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_MISSOURI_BOT;
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_MI_URL;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_MI_IMG);
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_MO;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408952/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16356);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFSL MO');
						break;
					
					case "georgiaBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_GEORGIA_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_GEORGIA_BOT;
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_GE_URL;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_GE_IMG);
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_GA;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408950/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16347);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFOG CA');
						break;
					case "massachusettsBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_MASS_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_MASS_BOT;
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_MA_URL;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_MA_IMG);
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_MA;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408949/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16352);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFNE MA');
						break;
					case "newYorkBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_NEWYORK_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_NEWYORK_BOT;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_NY_IMG);
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_NY_URL;
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_NY;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408946/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16350);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFGE NY');
						break;
					case "newJerseyBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_NEWJERSEY_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_NEWJERSEY__BOT;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_NJ_IMG);
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_NJ_URL;
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_NJ;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408945/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16353);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFGA NJ');
						break;
					case "marylandBtn":
						messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_MARYLAND_TOP;
						//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_MARYLAND_BOT;
						messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_MD_IMG);
						messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_MD_URL;
						messagePopUp.visible = true;
						messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_MD;
						//tracking
						l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408942/direct/01/"));
						NeoTracker.instance.trackNeoContentID(16357);
						TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFA MD');
						break;
					case "close_btn":
						if (messagePopUp != null)
						{
							messagePopUp.visible = false;	
						}
						
						break;
					}
				}
		
			
		}
		
		protected function imageButtonClicked(evt:CustomEvent):void
		{
			
			var libPath:String;
			var l:Loader = new Loader()
			
			Parameters.onlineMode ? libPath = Parameters.imageURL+ "/" + SixFlagsConstants.IMG_PATH_BASE : libPath = SixFlagsConstants.IMG_PATH_BASE;
			
			
			switch (evt.oData.image)
			{
				case "californiaBtn": //LA
					messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_CALIFORNIA_TOP;
					//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_CALIFORNIA_TOP;
					messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_CA_URL;
					messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_CA_IMG, true);
					messagePopUp.visible = true;
					messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_CA_LA;
					//tracking
					l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408948/direct/01/"));
					NeoTracker.instance.trackNeoContentID(16351);
					TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFMM CA');
					break;
				case "californiaBtn2": //SF
					messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_CALIFORNIA_SF_TOP;
					//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_CALIFORNIA_SF_BOT;
					messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_CA_SF_URL;
					messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_CA_SF_IMG, true);
					messagePopUp.visible = true;
					messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_CA_SF;
					//tracking
					l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408943/direct/01/"));
					NeoTracker.instance.trackNeoContentID(16355);
					TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFDK CA');
					break;
				case "texasBtn": //ARR
					messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_TEXAS_TOP;
					//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_TEXAS_BOT;
					messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_TX_URL;
					messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_TX_IMG, true);
					messagePopUp.visible = true;
					messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_TX_DALLAS;
					//tracking
					l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408951/direct/01/"));
					NeoTracker.instance.trackNeoContentID(16349);
					TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFOT TX');
					break;
				case "texasBtn2": //SAN A
					messagePopUp.textFieldTop.htmlText = TextSixFlags2010.INFO_TEXAS_SA_TOP;
					//messagePopUp.textFieldBottom.htmlText = TextSixFlags2010.INFO_TEXAS_SA_BOT;
					messagePopUp.URL = SixFlagsConstants.SIX_FLAGS_TX_SA_URL;
					messagePopUp.setUpPicture(libPath + SixFlagsConstants.SIX_FLAGS_TX_SA_IMG, true);
					messagePopUp.visible = true;
					messagePopUp.activityID = SixFlagsConstants.ACTIVITY_LINK_INFO_TX_SANTONIO;
					//tracking
					l.load(new URLRequest("http://view.atdmt.com/OY6/view/243408944/direct/01/"));
					NeoTracker.instance.trackNeoContentID(16354);
					TrackingProxy.sendADLinkCall('SixFlags2010 - Info Booth to SFFT TX');
					break;
			}
			
			switchPopUp.visible = false;
		}
		
		/**
		 * Launches the Information Website for the Flag
		 */
		
		protected function launchWebSite(evt:Event):void
		{
			var tURL:String  = messagePopUp.URL;;
		
			trace("launchWebSite URL:", tURL);
			
			var tURLREQUEST:URLRequest = new URLRequest(tURL);
			navigateToURL(tURLREQUEST);
			
			Parameters.connection.call("SixFlagsService.ActivityService", null, Parameters.userName,messagePopUp.activityID);
		}
		protected function closeMessageWindow(evt:Event = null):void
		{
			messagePopUp.visible = false;
			switchPopUp.visible = false;
		}
		protected function goBack(evt:Event = null):void
		{
			messagePopUp.visible = false;
			switchPopUp.visible = true;
		}
		
	}
	
}