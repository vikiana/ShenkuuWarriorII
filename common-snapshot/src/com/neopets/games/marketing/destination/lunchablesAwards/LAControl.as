package com.neopets.games.marketing.destination.lunchablesAwards
{
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader_v2;
	import com.neopets.projects.destination.destinationV2.AbsControl;
	import com.neopets.projects.destination.destinationV2.AbsDatabase;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	
	/**
	 *	Main Control Class for Golden Luncheables Awards Destination.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  09.11.2009
	 */
	public class LAControl extends AbsControl  
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var LIB_PATH:String = "/assets/LA_library.swf";
		
		private var mTypeID:String = "TYPE" + AbsDatabase.TYPE_OTHER.toString()  //which is 14
		private var mProjectID:String = "ITEM" + LAView.NEOCONTENT_ID.toString()	//not srue why ITEM but that's what we call it...
		
		private var _paramObj:Object;
		private var mImageHost:String;	//passed as flavhvar, images.neopets.com or images50.neopets.com
		private var mBaseURL:String;	//passed as flavhvar, www.neopets.com or dev.neopets.com
		private var offMode:Boolean = true;	//set true when working off line  for easy testing
		
		//pages
		private var _mainLandingPage:AbstractPageCustom;
		private var _craftServicesPage:AbstractPageCustom;
		private var _BTSPage:AbstractPageCustom;
		private var _trophiesPage:AbstractPageCustom;
		
		//flags: these are to avoid that multiple clicks on the links that award trophies 
		//send too many calls to process. For performance.
		private var _trophy2Found:Boolean = false;
		private var _trophy1Found:Boolean = false;
		private var _trophy4Found:Boolean = false;
		
		
		
		public function LAControl(pDocumentClass:Object)
		{
			super(pDocumentClass);
			
		}
		
		public function loadLibrary():void {
			//Load the Flash Vars and the library
			var libPath:String;
			trace ("STAGE"+mView.stage);
			if (offMode){
				libPath = "assets/LA_library.swf";
			} else{
				try {
					//Flash Vars
					_paramObj = LoaderInfo(mView.stage.root.loaderInfo).parameters;
					mImageHost = _paramObj["imageHost"];
					mBaseURL = _paramObj["baseurl"];
					for each (var i:String in _paramObj){
						 trace ("FLASH VARS:"+i+"   : "+_paramObj[i]);
					}
					//
					libPath = "http://"+mImageHost+"/sponsors/lunchables/destination"+LIB_PATH;
				} catch (error:Error) {
					trace ("ERROR LOADING THE FLASHVARS"+", ERROR"+error.message);
					libPath = "http://images50.neopets.com/sponsors/lunchables/destination"+LIB_PATH;
				}
			}
			
			trace (this+"- offMode? "+offMode+" - Loading library from: "+libPath);
			LibraryLoader_v2.loadLibrary(libPath, onLibLoaded);
		
		}
		
		
		//----------------------------------------------------------------------------
		// PUBLIC AND PROTECTED METHODS
		// ---------------------------------------------------------------------------
		
		/**
		 *	This is the very first step when everything is ready.  
		 *	In general, it should:
		 *	1. Setup data base
		 *	2. Create landing page
		 *	3. And do everything else necessary for set up
		 **/
		override protected function afterSetupReady():void{
			trace("\n ===== 5. KRAFT LUNCHEABLES AWARDS READY ===== \n");
			offMode? setupLandingPage():gotoPage();
		}
		
		
		//----------------------------------------------------------------------------
		// PRIVATE METHODS
		// ---------------------------------------------------------------------------
		
		
		
		
		
		
		private function onLibLoaded (e:Event):void {
			dispatchEvent (new Event ("lib_loaded"));	
		}
		
		
		private function createPage(pageClass:Class, name:String):AbstractPageCustom {
			var page:AbstractPageCustom = new pageClass (name, mView, mUserName, mTypeID + mProjectID);
			//adds the display object to the view
			mView.dispatchEvent(new CustomEvent ({DATA:page}, mView.ADD_DISPLAY_OBJ));
			return page;
		}

		//PAGES
		//	Setup the main landing page
		protected override function setupLandingPage():void
		{ 
			//runJavaScript("Main Landing");
			//NeoTracker.sendTrackerID()
			_mainLandingPage  = createPage(MainLandingPage, "MainLandingPage");
		}
		
		//	Setup the main trophies page
		protected function setupTrophyPage():void
		{ 
			//runJavaScript("Trophies");
			//NeoTracker.sendTrackerID()
			_trophiesPage  = createPage (TrophyRoomPage, "TrophyRoomPage");
		}
		
		//	Setup the behind-the-scene page
		protected  function setupBTSPage():void
		{
			//runJavaScript("Behind-The-Scene");
			//NeoTracker.sendTrackerID()
			_BTSPage = createPage (BTSPage, "BTSPage");
		}
		
		// Set up the craft services page
		protected  function setupCraftServicesPage():void
		{
			//runJavaScript("Craft Services");
			//NeoTracker.sendTrackerID()
			_craftServicesPage  = createPage (CraftServicesPage, "CraftServicesPage");
		}
		
		
		
		/**
		 *	Start the first page (user sees on the browser) according to FlashVars
		 *	Clients wanted to reload the html page for each swf page users click for
		 *	In essence it loads the same swf except each time flashvars tells swf which page it should open
		 **/
		private function gotoPage():void
		{
			//this reads the flash parameter the indicates what is the URL to navigate to
			var page:String = ""
			try {
				_paramObj = LoaderInfo(mView.stage.root.loaderInfo).parameters;
				 page = _paramObj["page"]
				 mImageHost = _paramObj["imageHost"]
			} catch (error:Error) {
				trace(error.toString());
			}

			switch (page)
			{
				
				case "":
					setupLandingPage();
					break;
				
				case "BTS":
					setupBTSPage();
					break;
					
				case "trophy":
					setupTrophyPage();
					break;
					
				case "craft":
					setupCraftServicesPage()
					break;
				
				case "landing":
					setupLandingPage();
					break;
				
			}
		}
		
		
		//----------------------------------------
		//EVENT HANDLERS
		//----------------------------------------
		/**
		 *	@NOTE:	ALL of display Objects on the stage with (movieclip named) "btnArea" 
		 *			inside it will be reported.
		 *			You simply have to choose what you will process and what you will ignore 
		 *			on this control level, all the transition is handled.
		 **/
		protected override function handleObjClick(e:CustomEvent):void
		{
			var mData:Object;
			trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			var mc:MovieClip = e.oData.DATA.parent as MovieClip
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				
				
				//TODO: write your own cases
				switch (objName)
				{
				case "logoButton":
					//Gets external URL. Implement on mainlandingpage for tracking.
				break;
					
				case "BTSBadge":
					offMode? pageTransition (setupBTSPage): navigateToPage("BTS");
					
				break;
				
				case "TrophyBadge":
					offMode? pageTransition (setupTrophyPage): navigateToPage("trophy");
				break;
					
				case "csButton":
					offMode? pageTransition (setupCraftServicesPage): navigateToPage("craft");
				break;
				
				case "signButton":
					//Gets Nicktropolis URL. Implement in main landing page for tracking.
				break;
					
				case "stepButton":
					//Links to game 1142.  Implement on main landing page for tracking.
				break;
					
				case "cameraButton":
					//Links to game 1086. Implement on main landing page for tracking.
				break;
					
				case "giftstandButton":
					//Popup.Implemented in main landing page
				break;
					
				case "trophyButton":
					//TBA
				break;
					
				case "backToMain":
					offMode? pageTransition (setupLandingPage) : navigateToPage("landing");
				break;
				
				//Trophies hints
				case "te1":
					//NeoTracker.processClickURL(15046);
					/*
					if (!_trophy1Found){
						mData = {tName:"t1"};
						mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy1Found = true;
					}
					*/
				break;
				case "te2":
					//NeoTracker.processClickURL(15045);
					/*
					trace ("CHECK THIS"+_trophy2Found);
					if (!_trophy2Found){
						mData = {tName:"t2"};
						mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy2Found = true;
					}	
					*/
				break;
				case "te3":
					//offMode? pageTransition (setupBTSPage) : navigateToPage("BTS");	
				break;
				case "te4":
					//Link to Nicktrop TBA
					/*
					if (!_trophy4Found){
						mData = {tName:"t4"};
						mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy4Found = true;
					}
					*/
				break;
				case "te5":
					//offMode? pageTransition (setupCraftServicesPage) : navigateToPage("CraftServicesPage");	
				break;
				
				//gift bah popup
				case "inv_button":
				var ur:URLRequest;
				if (offMode){
					ur = new URLRequest ("http://dev.neopets.com/objects.phtml?type=inventory");
				} else {
					trace ("BASE URL"+mBaseURL);
					ur = new URLRequest (mBaseURL+"/objects.phtml?type=inventory");
				}
					var ul:URLLoader = new URLLoader ();
					navigateToURL(ur);
				break;
				
				}
			}
		}
		
		
		/**
		 *	Removes whatever is on the stage and calls a given funtion (usually setting up a page)
		 *	to populate the stage with a new "page"
		 *
		 *	@PARAM		pfunc		Fuction			such as "setupLandingPage"
		 **/
		private function pageTransition(pfunc:Function):void
		{
			cleanupPage()
			pfunc()
		}
		
		
		/**
		 *	When user clicks on any button to go to other pages, it'll naviate itself to a designated URL
		 *	And that html page will have flashVar telling swich which page to show.
		 **/
		private function navigateToPage(pString:String):void
		{
			var pathURL:String = "/sponsors/lunchables/"; 
			var pageURL:String = ""
			switch (pString)
			{
				case "trophy":
					pageURL = "trophy-room.phtml";//"?page="+pString
					break;
					
				case "BTS":
					pageURL = "bts.phtml";//"?page="+pString
					break;
					
				case "landing":
					pageURL = "index.phtml";//"?page="+pString
					break;
					
				case "craft":
					pageURL = "feed-a-pet.phtml";//"?page="+pString
					break;
			}
			
			var url:URLRequest = new URLRequest (pathURL + pageURL)
			
			try
			{            
                navigateToURL(url, "_self");
            }
            catch (e:Error)
			{
                // handle error here
            }
		}
		
		//----------------------------------------
		// GETTERS/SETTERS
		//----------------------------------------
		public function get  imageHost():String {
			return mImageHost;
		}
		
	}
}