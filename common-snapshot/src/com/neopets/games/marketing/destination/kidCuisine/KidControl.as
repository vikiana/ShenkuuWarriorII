/**
 *	Handles main control of click destination project
 *	Roughly follows the MVC separation
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  06.01.2009
 */

package com.neopets.games.marketing.destination.kidCuisine
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.LoaderInfo;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV2.AbsControl
	import com.neopets.projects.destination.destinationV2.AbsDatabase;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import com.neopets.games.marketing.destination.kidCuisine.pages.*
	import com.neopets.projects.destination.destinationV2.NeoTracker

	
	public class KidControl extends AbsControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mNeoContentID:int = 1620
		private var mTypeID:String = "TYPE" + AbsDatabase.TYPE_OTHER.toString()  //which is 14
		private var mProjectID:String = "ITEM" + mNeoContentID.toString()	//not srue why ITEM but that's what we call it...
		private var mImageHost:String	//passed as flavhvar, images.neopets.com or images50.neopets.com
		private var offMode:Boolean = false;	//set true when working off line  for easy testing
	
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function KidControl(pDocumentClass:Object):void
		{			
			super (pDocumentClass);
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
		
		/**
		 *	After all setup is ready, start the initial page
		 *	@NOTE:	The client needed to have separate unique URL for each page.
		 *			This request came after the system was already built.  		 		
		 *			Thus we created way where any given html page will load the same swf with flashVar
		 *			That tells which page to start from "gotoPage" in the construction function will open.
		 *			up the page accordingly
		 **/
		protected override function afterSetupReady ():void
		{
			trace("\n ===== 5. KID CRUISINE READY ===== \n");
			offMode? setupLandingPage():gotoPage();
		}
		
		//	Setup the main landing page
		protected override function setupLandingPage():void
		{ 
			runJavaScript("Main Landing");
			NeoTracker.sendTrackerID(14656)
			var landingPage:PageMainLanding = new PageMainLanding("landing page", mView, mUserName, mTypeID + mProjectID);
			mView.dispatchEvent(new CustomEvent({DATA:landingPage},mView.ADD_DISPLAY_OBJ));
		}
		
		//	Setup the games page
		protected override function setupGamesPage():void
		{
			runJavaScript("Intergalactic Gaming Area");
			NeoTracker.sendTrackerID(14659)
			var gamesPage:PageGames = new PageGames("games page", mView);
			mView.dispatchEvent(new CustomEvent({DATA:gamesPage},mView.ADD_DISPLAY_OBJ))
		}
		
		// Set up the adventure page
		protected override function setupInfoPage():void
		{
			runJavaScript("Galactic Adventure Window");
			NeoTracker.sendTrackerID(14657)
			var infoPage:PageInfo = new PageInfo("info page", mView);
			mView.dispatchEvent(new CustomEvent({DATA:infoPage},mView.ADD_DISPLAY_OBJ))
		}
		
		//	Set up feed a pet page
		protected override function setupFeedAPetPage():void
		{
			runJavaScript("Celestial Snack Bar");
			NeoTracker.sendTrackerID(14660)
			var feedAPetPage:PageFeedAPet = new PageFeedAPet("feed a pet page", mView);
			mView.dispatchEvent(new CustomEvent({DATA:feedAPetPage},mView.ADD_DISPLAY_OBJ))
		}
		
		//	set up the collection quest page
		protected function setupQuestPage():void
		{
			runJavaScript("KC's Space Scavenger Hunt");
			NeoTracker.sendTrackerID(14658)
			var questPage:PageQuest = new PageQuest("quest page", mView, mUserName, mTypeID + mProjectID);
			mView.dispatchEvent(new CustomEvent({DATA:questPage},mView.ADD_DISPLAY_OBJ))
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		
		/**
		 *	Start the first page (user sees on the browser) according to FlashVars
		 *	Clients wanted to reload the html page for each swf page users click for
		 *	In essence it loads the same swf except each time flashvars tells swf which page it should open
		 **/
		private function gotoPage():void
		{
			var page:String = ""
			try {
				var keyStr:String;
				var valueStr:String;
				var paramObj:Object = LoaderInfo(mView.stage.root.loaderInfo).parameters;
				 page = paramObj["page"]
				 mImageHost = paramObj["imageHost"]
			} catch (error:Error) {
				trace(error.toString());
			}

			switch (page)
			{
				
				case "":
					setupLandingPage();
					break;
				
				case "games":
					setupGamesPage();
					break;
				
				case "feedapet":
					setupFeedAPetPage();
					break;
				
				case "hunt":
					setupQuestPage();
					break;
				
				case "adventure":
					setupInfoPage();
					break;
				
			}
		}
		
		
		/**
		 *	When user clicks on any button to go to other pages, it'll naviate itself to a designated URL
		 *	And that html page will have flashVar telling swich which page to show.
		 **/
		private function navigateToPage(pString:String):void
		{
			var pathURL:String = "/sponsors/kidcuisine/index.phtml" 
			var pageURL:String = ""
			switch (pString)
			{
				case "mian":
					break;
				
				case "games":
					pageURL = "?page=games"
					break;
					
				case "quest":
					//pageURL = "?page=hunt"
					break;
					
				case "info":
					pageURL = "?page=adventure"
					break;
					
				case "feedapet":
					pageURL = "?page=feedapet"
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
		
		
		/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		private function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript"+scriptID);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("sendReportingCall", scriptID,"Kid Cuisine");
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JaraScript")
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
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
				
		/**
		 *	@NOTE:	ALL of display Objects on the stage with (movieclip named) "btnArea" 
		 *			inside it will be reported.
		 *			You simply has to choose to what you will process what you will ignore 
		 *			On ths control level, all the transition is handled
		 **/
		protected override function handleObjClick(e:CustomEvent):void
		{
			trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
					case "lunch":
						offMode? pageTransition (setupFeedAPetPage): navigateToPage("feedapet");
						break;
					
					case "gameButton":
						offMode? pageTransition (setupGamesPage): navigateToPage("games");
						break;
					
					case "backToMain":
						offMode? pageTransition (setupLandingPage) : navigateToPage("main");
						break;
						
					case "spaceButton":
						offMode? pageTransition (setupInfoPage) : navigateToPage("info");
						break;
					
					case "circleWindow":
						offMode? pageTransition (setupInfoPage) : navigateToPage("info");
						break;
					
					/*case "postcard":
						//offMode? pageTransition (setupQuestPage) : navigateToPage("quest")
						break;*/
				}
			}
		}
	}
	
}