/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.kidCuisine2
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flash.net.URLLoader;
	import flash.display.Loader;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsControl	//must include
	import com.neopets.projects.destination.destinationV3.AbsView	//must include
	import com.neopets.projects.destination.destinationV3.Parameters	//must include
	import com.neopets.games.marketing.destination.kidCuisine2.pages.*


	import com.neopets.util.events.CustomEvent;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import com.neopets.util.flashvars.FlashVarsFinder;
	
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	
	public class DestinationControl extends AbsControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var mSixFlagsDatabase:SixFlagsDatabase
		// constants
		public static const PAGE_VAR:String = "page";
		public static const IMAGE_PATH:String = "/sponsors/kidcuisine10_phase4/destination/";
		public static const LANDING_PAGE:String = "KC_Main_Page_v1.swf";
		public static const KITCHEN_PAGE:String = "KC_Kitchen_v1.swf";
		public static const GAMES_PAGE:String = "KC_Break_Room_v1.swf";
		public static const TRAINING_PAGE:String = "KC_Training_Room_v1.swf";
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DestinationControl():void
		{
			super ();
			//FilterShortcuts.init();
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
		*	Depends on what you need to do start here.
		*	By default you would create a main landing page.
		**/
		protected override function childInit ():void
		{
			trace("\nExample Destination Launch\n")
			var page:String = FlashVarsFinder.findVar(Parameters.view.stage.root,PAGE_VAR);
			switch(page) {
				case "feed":
					setupFeedAPetPage();
					break;
				case "games":
					setupGamesPage();
					break;
				case "about":
					setupInfoPage();
					break;
				default:
					setupMainPage();
			}
			//DebugTracer.addTextfieldTo(Parameters.view as MovieClip,500,500);
			//DebugTracer.showMessage(":::"+Parameters.imageURL);
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up MAIN LANDING page\n")
			loadPage(LANDING_PAGE);
		}
		
		// method to create main page
		protected override function setupGamesPage():void
		{
			trace("set up games page")
			loadPage(GAMES_PAGE);
		}
		
		// method to create info page
		protected override function setupInfoPage():void
		{
			trace("set up info page")
			loadPage(TRAINING_PAGE);
		}
		
		// method to create peedApet page
		protected override function setupFeedAPetPage():void
		{
			trace ("setup FeedAPet page")
			loadPage(KITCHEN_PAGE);
		}
		
		/**
		 * 	Use this function to load a destination page swf.
		 *	@PARAM		tag		Name of the page being loaded.
		 **/
		
		protected function loadPage(tag:String) {
			// set up url request
			var req:URLRequest;
			if(Parameters.onlineMode) {
				var path:String;
				path = Parameters.imageURL + IMAGE_PATH + tag;
				path += "?r=" + Math.floor(Math.random()*1000000);
				req = new URLRequest(path);
			} else req = new URLRequest(tag);
			// set up loader
			var ldr:Loader = new Loader();
			ldr.load(req);
			Parameters.view.dispatchEvent(new CustomEvent({DATA:ldr},AbsView.ADD_DISPLAY_OBJ))
		}
		
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
				popupPage.name = "popup page";
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
		
		//blur transition
		private function tweenerTransition(pfunc:Function, pName:String):void
		{
			/*
			pfunc()
			var page:Object = mView.getChildByName(pName) as Object
			Sprite(page).filters = [new BlurFilter(32, 32, 2)]
			Tweener.addTween(page, {_Blur_blurY:0, _Blur_blurX:0, time:.6})
			*/
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
		
		//this is to proces neocontent url click as well as open up the html page on new browser
		/*
		private function processClickURL(linkID:int, openUP:Boolean = true):void
		{
			var url:String = "http://www.neopets.com/process_click.phtml?item_id="+linkID.toString();
			var requestURL:URLRequest = new URLRequest(url);
			navigateToURL (requestURL, 'blank');
		}
		*/
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
			trace ("data base action confirmed")
			//mSixFlagsDatabase.removeEventListener(mSixFlagsDatabase.ACTION_CONFIRMED, handleActionConfirmed)
			//setupMainPage()
			//tweenerTransition(setupMainPage, "main page")
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
				}
			}
		}
	}
	
}