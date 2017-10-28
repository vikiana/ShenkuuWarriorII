/**
 *	Handles main control of click destination project
 *	Roughly follows the MVC separation
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  04.27.2009
 */

package com.neopets.games.marketing.destination.movieTest
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	//import flash.filters.BlurFilter;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.AbstractDestinationControl
	import com.neopets.projects.destination.AbstractDatabase;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import com.neopets.games.marketing.destination.movieTest.pages.*
	
	
	public class MovieControl extends AbstractDestinationControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mNeoContentID:int = 0000
		private var mTypeID:String = "TYPE" + AbstractDatabase.TYPE_OTHER.toString()  //which is 14
		private var mProjectID:String = "ITEM" + mNeoContentID.toString()	//not srue why ITEM but that's what we call it...
		
		
	
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function MovieControl(pDocumentClass:Object):void
		{			
			super (pDocumentClass);
			FilterShortcuts.init();
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
		
		//after document class is ready, set up the database 
		//(since main landing page would have to show the collection quest status)
		protected override function afterSetupReady ():void
		{
			trace("movie destination ready")
			setupLandingPage()	
		}
		
		// method to create main page (landing page)
		
		protected override function setupLandingPage():void
		{
			var landingPage:PageMainLanding = new PageMainLanding("landing page", mView);
			mView.dispatchEvent(new CustomEvent({DATA:landingPage},mView.ADD_DISPLAY_OBJ))
		}
		
		protected override function setupGamesPage():void
		{
			var gamesPage:PageGames = new PageGames("games page");
			mView.dispatchEvent(new CustomEvent({DATA:gamesPage},mView.ADD_DISPLAY_OBJ))
		}
		
		protected override function setupFeedAPetPage():void
		{
			var feedAPetPage:PageFeedAPet = new PageFeedAPet("feed a pet page");
			mView.dispatchEvent(new CustomEvent({DATA:feedAPetPage},mView.ADD_DISPLAY_OBJ))
		}
		
		
		
		// method to create main page
		protected override function setupVideoPage():void
		{
			
			var videoPage:PageMovieTheatre = new PageMovieTheatre("Movie Theatre page", mView.stage.root);
			mView.dispatchEvent(new CustomEvent({DATA:videoPage},mView.ADD_DISPLAY_OBJ))
		}
		
		// method to create info page
		protected override function setupInfoPage():void
		{
			/*
			trace ("setup info page")
			var infoPage:InfoPage = new InfoPage();
			infoPage.name = "info page"
			mView.dispatchEvent(new CustomEvent({DATA:infoPage},mView.ADD_DISPLAY_OBJ))
			*/
		}
		
		// method to create peedApet page
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		/**
		 * 	When flags are found, a popup page needs to show
		 *	@PARAM		pMessage		text message informing user what they just found
		 *	@PARAM		foundAll		true if all flags are found (user just found a last flag)
		 **/
		private function setupPopup(pMessage:String, foundAll:Boolean):void
		{
			/*
			if (mView.getChildByName("popup page") == null)
			{
				trace ("setup popup")
				var popupPage:SixFlagsPopUp = new SixFlagsPopUp(pMessage, foundAll);
				popupPage.name = "popup page"
				mView.dispatchEvent(new CustomEvent({DATA:popupPage},mView.ADD_DISPLAY_OBJ))
			}
			*/
		}
		
		
		// set up database for the collection quest. if not logged in pUserName will be "GUEST_USER_ACCOUNT"
		private function setupDatabase(pUserName:String):void
		{
			/*
			mSixFlagsDatabase = new SixFlagsDatabase(pUserName, mTypeID + mProjectID);
			mSixFlagsDatabase.addEventListener(mSixFlagsDatabase.ACTION_CONFIRMED, handleActionConfirmed, false, 0, true)
			mSixFlagsDatabase.addEventListener(mSixFlagsDatabase.FLAG_FOUND, onFlagFound)
			*/
		
		}
		
		
		private function pageTransition(pfunc:Function):void
		{
			trace ("called???????????????????")
			cleanupPage()
			pfunc()
		}
		
		//All the operation will take place within InfoPage
		private function handleInfoClick(pState:String):void
		{
			/*
			if (mView.getChildByName("info page") != null)
			{
				var infoPage:InfoPage = mView.getChildByName("info page") as InfoPage
				infoPage.dispatchEvent(new CustomEvent ({STATE:pState}, infoPage.STATE_CLICKED))
			}
			*/
		}
		
		// tell videoPage which video to play
		private function playVideo(video:String, clickID:int):void
		{
			/*
			if (mView.getChildByName("video page") != null)
			{
				trace ("play video")
				var videoPage:VideoPage = mView.getChildByName("video page") as VideoPage
				videoPage.dispatchEvent(new CustomEvent ({VIDEO:video, NEOCONTENT_ID:clickID}, videoPage.PLAY_VIDEO))
			}
			*/
		}
		
		//Notify feedAPet page which food is selected from stage (stage that contains feedapet page)
		private function foodSelected(pFood:String):void
		{
			/*
			if (mView.getChildByName("feedAPet page") != null)
			{
				var feedPage:FeedAPetPage = mView.getChildByName("feedAPet page") as FeedAPetPage;
				feedPage.dispatchEvent(new CustomEvent ({FOOD:pFood}, feedPage.FOOD_SELECTED))
			}
			*/
		}
		
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		//When SixFlagsDatabase dispatches an event, set the popup and show it
		private function onFlagFound(evt:CustomEvent):void
		{
			/*
			trace ("flag is found")
			sendTrackerID(evt.oData.CLICKID);  //process flag found clickID
			
			var pMessage:String
			if (evt.oData.ALLFOUND)
			{
				pMessage = "You have found all flags and received a prize in your inventory!";
				sendTrackerID(evt.oData.PRIZEID) //if all flags are found send grand prize click ID as well
			}
			else 
			{
				pMessage = "Congratulations\nYou've found a flag!";
			}  
			setupPopup(pMessage, evt.oData.ALLFOUND)
			*/
		}
		
		//When a pet is fed, undate the user status
		private function onPetFed(evt:Event):void
		{
			//mSixFlagsDatabase.feedAPet++
		}
		
		//When users attempt to feed a pet, send tracking (neo content track url)
		private function onTryToFeedAPet(evt:Event):void
		{
			//sendTrackerID(14369) 
		}
		
		//When a video trailer is viewed to the end, undate the user status
		private function onVideoViewed(evt:Event):void
		{
			//mSixFlagsDatabase.trailer++
		}
		
		// this is called once the database is set
		private function handleActionConfirmed(evt:Event):void
		{
			/*
			trace ("data base action confirmed")
			mSixFlagsDatabase.removeEventListener(mSixFlagsDatabase.ACTION_CONFIRMED, handleActionConfirmed)
			setupMainPage()
			tweenerTransition(setupMainPage, "main page")
			*/
		}
		
		/**
		 *	@NOTE:	ALL of the items/objects clicked from the stage will be reported here.
		 *			You simply has to choose to what you will process what you will ignore 
		 *			Here I choose to pick up on most of buttons (that has "btnArea" movie clip within)
		 *			And respond appropriately.  Some buttons are handled by the "page" itself if neccessary.
		 **/
		protected override function handleObjClick(e:CustomEvent):void
		{
			trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
					case "lunchBox":
						trace ("\n  ==> Goto peed a pet")
						break;
					
					case "gameButton":
						trace ("\n  ==> Goto games page")
						break;
					
					case "marquee1":
						break;
										
				}
			}
		}
	}
	
}