/**
 *	Handles main control of click destination project
 *	Roughly follows the MVC separation
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  04.27.2009
 */

package com.neopets.games.marketing.destination.sixFlags
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
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.AbstractDestinationControl
	import com.neopets.projects.destination.AbstractDatabase;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	
	public class SixFlagsControl extends AbstractDestinationControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mSixFlagsDatabase:SixFlagsDatabase
		private var mNeoContentID:int = 1592
		private var mTypeID:String = "TYPE" + AbstractDatabase.TYPE_OTHER.toString()  //which is 14
		private var mProjectID:String = "ITEM" + mNeoContentID.toString()	//not srue why ITEM but that's what we call it...
		
		
	
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SixFlagsControl(pDocumentClass:Object):void
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
			trace("six flags destination ready, now set up data base")
			setupDatabase(mUserName);			
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace ("setup main page called")
			var userLoggedIn:Boolean = mUserName == mView.GUEST_USER ? false: true;
			var mainPage:MainPage = new MainPage(userLoggedIn);
			trace ("show flag", mSixFlagsDatabase.showFlags())
			mainPage.showFlags(mSixFlagsDatabase.showFlags())
			mainPage.name = "main page"
			mView.dispatchEvent(new CustomEvent({DATA:mainPage},mView.ADD_DISPLAY_OBJ))
		}
		
		// method to create main page
		protected override function setupVideoPage():void
		{
			trace ("setup video page")
			var videoPage:VideoPage = new VideoPage(mView.stage.root);
			videoPage.name = "video page"
			videoPage.addEventListener (videoPage.VIDEO_VIEWED, onVideoViewed);
			mView.dispatchEvent(new CustomEvent({DATA:videoPage},mView.ADD_DISPLAY_OBJ))
		}
		
		// method to create info page
		protected override function setupInfoPage():void
		{
			trace ("setup info page")
			var infoPage:InfoPage = new InfoPage();
			infoPage.name = "info page"
			mView.dispatchEvent(new CustomEvent({DATA:infoPage},mView.ADD_DISPLAY_OBJ))
		}
		
		// method to create peedApet page
		protected override function setupFeedAPetPage():void
		{
			trace ("setup FeedAPet page")
			var userLoggedIn:Boolean = mUserName == mView.GUEST_USER ? false: true;
			var feedPage:FeedAPetPage = new FeedAPetPage(mTypeID+mProjectID, userLoggedIn);
			feedPage.name = "feedAPet page"
			feedPage.addEventListener(feedPage.PET_WAS_FED, onPetFed, false, 0, true);
			feedPage.addEventListener(feedPage.FEED_MY_PET, onTryToFeedAPet, false, 0, true);
			mView.dispatchEvent(new CustomEvent({DATA:feedPage},mView.ADD_DISPLAY_OBJ))
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
			if (mView.getChildByName("popup page") == null)
			{
				trace ("setup popup")
				var popupPage:SixFlagsPopUp = new SixFlagsPopUp(pMessage, foundAll);
				popupPage.name = "popup page";
				mView.dispatchEvent(new CustomEvent({DATA:popupPage},mView.ADD_DISPLAY_OBJ))
			}
		}
		
		
		// set up database for the collection quest. if not logged in pUserName will be "GUEST_USER_ACCOUNT"
		private function setupDatabase(pUserName:String):void
		{
			mSixFlagsDatabase = new SixFlagsDatabase(pUserName, mTypeID + mProjectID);
			mSixFlagsDatabase.addEventListener(mSixFlagsDatabase.ACTION_CONFIRMED, handleActionConfirmed, false, 0, true)
			mSixFlagsDatabase.addEventListener(mSixFlagsDatabase.FLAG_FOUND, onFlagFound)
		
		}
		
		//blur transition
		private function tweenerTransition(pfunc:Function, pName:String):void
		{
			pfunc()
			var page:Object = mView.getChildByName(pName) as Object
			Sprite(page).filters = [new BlurFilter(32, 32, 2)]
			Tweener.addTween(page, {_Blur_blurY:0, _Blur_blurX:0, time:.6})
		}
		
		//All the operation will take place within InfoPage
		private function handleInfoClick(pState:String):void
		{
			if (mView.getChildByName("info page") != null)
			{
				var infoPage:InfoPage = mView.getChildByName("info page") as InfoPage
				infoPage.dispatchEvent(new CustomEvent ({STATE:pState}, infoPage.STATE_CLICKED))
			}
		}
		
		// tell videoPage which video to play
		private function playVideo(video:String, clickID:int):void
		{
			if (mView.getChildByName("video page") != null)
			{
				trace ("play video")
				var videoPage:VideoPage = mView.getChildByName("video page") as VideoPage
				videoPage.dispatchEvent(new CustomEvent ({VIDEO:video, NEOCONTENT_ID:clickID}, videoPage.PLAY_VIDEO))
			}
		}
		
		//Notify feedAPet page which food is selected from stage (stage that contains feedapet page)
		private function foodSelected(pFood:String):void
		{
			
			if (mView.getChildByName("feedAPet page") != null)
			{
				var feedPage:FeedAPetPage = mView.getChildByName("feedAPet page") as FeedAPetPage;
				feedPage.dispatchEvent(new CustomEvent ({FOOD:pFood}, feedPage.FOOD_SELECTED))
			}
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
		}
		
		//When a pet is fed, undate the user status
		private function onPetFed(evt:Event):void
		{
			mSixFlagsDatabase.feedAPet++
		}
		
		//When users attempt to feed a pet, send tracking (neo content track url)
		private function onTryToFeedAPet(evt:Event):void
		{
			sendTrackerID(14369) 
		}
		
		//When a video trailer is viewed to the end, undate the user status
		private function onVideoViewed(evt:Event):void
		{
			mSixFlagsDatabase.trailer++
		}
		
		// this is called once the database is set
		private function handleActionConfirmed(evt:Event):void
		{
			trace ("data base action confirmed")
			mSixFlagsDatabase.removeEventListener(mSixFlagsDatabase.ACTION_CONFIRMED, handleActionConfirmed)
			setupMainPage()
			tweenerTransition(setupMainPage, "main page")
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
					case "Btn_Tower":
						cleanupPage()
						sendTrackerID(14364) 
						tweenerTransition(setupVideoPage, "video page")
						break;
					
					case "Btn_WaterSlide":
						processClickURL(14259)
						mSixFlagsDatabase.game2++
						break;
					
					case "Btn_RollerCoaster":
						processClickURL(14258)
						mSixFlagsDatabase.game1++
						break;
					
					case "Btn_Info":
						cleanupPage()
						sendTrackerID(14365) 
						tweenerTransition(setupInfoPage, "info page")
						break;
					
					case "Btn_Gate":
						processClickURL(14261)   
						mSixFlagsDatabase.gate++
						break;
						
					case "goBack":
						cleanupPage();
						tweenerTransition(setupMainPage, "main page")
						break;
						
					case "Btn_FeedAPet":
						cleanupPage()
						sendTrackerID(14366)
						tweenerTransition(setupFeedAPetPage, "feedAPet page")
						break;
						
					//Info page, states
					case "ca":
						handleInfoClick(objName);
						break;
					
					case "ga":
						handleInfoClick(objName);
						break;
						
					case "il":
						handleInfoClick(objName);
						break;
						
					case "ky":
						handleInfoClick(objName);
						break;
						
					case "md":
						handleInfoClick(objName);
						break;
						
					case "mo":
						handleInfoClick(objName);
						break;
						
					case "ma":
						handleInfoClick(objName);
						break;
						
					case "nj":
						handleInfoClick(objName);
						break;
					
					case "ny":
						handleInfoClick(objName);
						break;
					
					case "tx":
						handleInfoClick(objName);
						break;
					
					case "infoVisitWeb":
						trace ("webClicked")
						var infoPage:InfoPage = mView.getChildByName("info page") as InfoPage
						infoPage.dispatchEvent(new CustomEvent ({DATA:e.oData.DATA.parent}, infoPage.WEB_CLICKED));
						mSixFlagsDatabase.clickLink++
						break;
					
					//feed a pet
					case "grill":
						foodSelected(objName);
						break;
					
					case "popcorn":
						foodSelected(objName);
						break;
					
					case "hotdog":
						foodSelected(objName);
						break;
						
					//videoRoom
					case "video1":
						trace ("video 1 clicked")
						playVideo(objName, 14294)
						//ID:14294 water slide 
						break;
					
					case "video2":
						playVideo(objName, 14295)
						//ID:14295 Kid Reel
						break;
						
					//pupUP, found a flag
					case "viewFlag":
						cleanupPage();
						tweenerTransition(setupMainPage, "main page")
						break;
					case "prizeClose":
						trace ("close popup")
						cleanupPage("popup page");
						break;
				}
			}
		}
	}
	
}