/**
 *	Handles main control of click destination project
 *	Roughly follows the MVC separation
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  06.01.2009
 */

package com.neopets.games.marketing.destination.movieCentral
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.movieCentral.pages.*;
	import com.neopets.projects.destination.destinationV2.AbsControl;
	import com.neopets.projects.destination.destinationV2.AbsDatabase;
	import com.neopets.projects.destination.destinationV2.Parameters;
	import com.neopets.projects.destination.destinationV2.movieTheater.MovieDataHolder;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;


	
	public class MovieCentralControl extends AbsControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		private var mImageHost:String	//passed as flavhvar, images.neopets.com or images50.neopets.com
		private var offMode:Boolean = false;	//set true when working off line  for easy testing
	
		private var mCurrentPage:Sprite
		private var mTobePageCall:Function
		
		private var loadingTheater:LoadingTheater;	//initial theater shown while loading
		private var loadingSign:LoaderFlowerSign;	//five circles
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function MovieCentralControl(pDocumentClass:Object):void
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
			trace("\n ===== 5. MOVIE CENTRAL CRUISINE READY ===== \n");
			setVars()
			//set up loading box...
			setupMovieTheaterLoader()
			
			//find out the path to pass it down to amfphp
			var path:String = "http://dev.neopets.com"
			try {
				var paramObj:Object = LoaderInfo(mView.stage.root.loaderInfo).parameters;
				if (paramObj["baseurl"] != undefined || paramObj["baseurl"] != null)
				{
					 path = paramObj["baseurl"]
				}
			} catch (error:Error) {
				trace(error.toString());
			}
			MovieDataHolder.instance.addEventListener(MovieDataHolder.DATA_READY, onMovieHolderReady)
			MovieDataHolder.instance.init(path)
		}
		
		//	Setup the main landing page
		
		protected override function setupLandingPage():void
		{ 
			var landingPage:PageMainLanding = new PageMainLanding("landing page");
			mCurrentPage = Sprite(landingPage)
			mView.dispatchEvent(new CustomEvent({DATA:landingPage},mView.ADD_DISPLAY_OBJ));
			NeoTracker.instance.trackNeoContentID(14773)
		}
		
		
		
		//	Setup the games page
		protected override function setupGamesPage():void
		{
			var gamesPage:PageGames = new PageGames("games page");
			mCurrentPage = Sprite(gamesPage)
			mView.dispatchEvent(new CustomEvent({DATA:gamesPage},mView.ADD_DISPLAY_OBJ))
			NeoTracker.instance.trackNeoContentID(14774)
		}
		
		//	Set up feed a pet page
		protected override function setupFeedAPetPage():void
		{
			var feedAPetPage:PageFeedAPet = new PageFeedAPet("feed a pet page");
			mCurrentPage = Sprite(feedAPetPage)
			mView.dispatchEvent(new CustomEvent({DATA:feedAPetPage},mView.ADD_DISPLAY_OBJ))
			NeoTracker.instance.trackNeoContentID(14775)
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	Set up Movie Theater loader while retrieving data
		 **/
		 private function setupMovieTheaterLoader():void
		 {
			 loadingTheater = new LoadingTheater();
			 loadingTheater.x = 390;
			 loadingTheater.y = 120;
			 //loadingTheater.filters = [new BlurFilter (2, 2, 3)]
			 loadingTheater.scaleX = loadingTheater.scaleY = .5 
			 
			 loadingSign = new LoaderFlowerSign ();
			 loadingSign.x = 390;
			 loadingSign.y = 265;
			 
			 mView.dispatchEvent(new CustomEvent({DATA:loadingTheater},mView.ADD_DISPLAY_OBJ));
			 mView.dispatchEvent(new CustomEvent({DATA:loadingSign},mView.ADD_DISPLAY_OBJ));
		 }
		 
		 private function removeMovieTheaterLoader():void
		 {
			  mView.dispatchEvent(new CustomEvent({DATA:loadingSign},mView.REMOVE_DISPLAY_OBJ));
			  Tweener.addTween(loadingTheater, {y:265, scaleX:1, scaleY:1, time:.5, transition:"easeOutQuad", onComplete:setupPage}) 
		 }
		
		
		/**
		 *	Once static movie data is set, make a call to get url the swf is in 
		 **/
		private function onMovieHolderReady(evt:Event):void
		{
			trace ("movieHolder is ready")
			showPage();
		}
		
		/**
		 *	based on the url the swf is in, display the page accordingly 
		 **/
		private function showPage(evt:CustomEvent = null):void
		{
			//trace (evt.oData.DATA)
			removeMovieTheaterLoader()
			
		}
		
		private function setupPage():void
		{
			mView.dispatchEvent(new CustomEvent({DATA:loadingTheater},mView.REMOVE_DISPLAY_OBJ))
			setupLandingPage()
		}
		
		/**
		 *	Set initial variables;
		 **/
		private function setVars():void
		{
			var params:Object = LoaderInfo(mView.loaderInfo).parameters;
			var passedURL:String = params.baseurl != undefined ?  params.baseurl : "http://dev.neopets.com";
			trace("MovieCentralControl function afterSetupReady:", passedURL);
		}
		
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
					//setupLandingPage();
					break;
				
				case "games":
					//setupGamesPage();
					break;
				
				case "feedapet":
					//setupFeedAPetPage();
					break;
				
				case "hunt":
					//setupQuestPage();
					break;
				
				case "adventure":
					//setupInfoPage();
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
					pageURL = "?page=hunt"
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
		 *	Removes whatever is on the stage and calls a given funtion (usually setting up a page)
		 *	to populate the stage with a new "page"
		 *
		 *	@PARAM		pfunc		Fuction			such as "setupLandingPage"
		 **/
		private function pageTransition(pfunc:Function, px:Number = 0, py:Number = 0, pScale:Number = 1, pTime:Number = 0, pTransition:String = "easeIn"):void
		{
			mTobePageCall = pfunc
			trace (mCurrentPage)
			if (pTime != 0)
			{
				var screen:BlackScreen =  new BlackScreen ()
				screen.alpha = 0
				mView.dispatchEvent(new CustomEvent({DATA:screen},mView.ADD_DISPLAY_OBJ));
				Tweener.addTween(screen, {alpha:1, time:pTime/4, delay:pTime/4 * 3, transition:"easeIn"})
				
				Tweener.addTween(mCurrentPage, {x: px, y: py,  scaleX:pScale, scaleY:pScale, time:pTime, transition:pTransition, onComplete:swapPages})
				
			}
			else
			{
				swapPages()
			}
			
			//var page:Object = mView.getChildByName(pName) as Object
			//Sprite(page).filters = [new BlurFilter(32, 32, 2)]
			//Tweener.addTween(page, {_Blur_blurY:0, _Blur_blurX:0, time:.6})
			
		}
		
		
		private function swapPages():void
		{
			cleanupPage()
			mTobePageCall()
			var screen:BlackScreen =  new BlackScreen ()
			screen.name = "screen"
			mView.dispatchEvent(new CustomEvent({DATA:screen},mView.ADD_DISPLAY_OBJ));
			Tweener.addTween(screen, {alpha:0, time:.5, onComplete:removeScreen})
		}
		
		private function removeScreen():void
		{
			mView.dispatchEvent(new CustomEvent({DATA:mView.getChildByName("screen")},mView.REMOVE_DISPLAY_OBJ));			
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
					case "feedAPet":
						pageTransition (setupFeedAPetPage, 40, -20, 1.2, 1, "easeInBack")
						break;
					
					case "arcade":
						pageTransition (setupGamesPage, -150, -20, 1.2, 1, "easeInBack")
						break;
					case "backToMain":
						pageTransition (setupLandingPage, 60, 30, .8, 1, "easeInBack")
						break;
					
				}
			}
			
		}
	}
	
}