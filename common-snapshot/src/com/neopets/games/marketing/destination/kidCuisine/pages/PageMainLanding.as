/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.kidCuisine.KidDatabase;
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.external.ExternalInterface;
	
	
	public class PageMainLanding extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mWelcomeTxt:String = "Welcome to Planet 51!\n\nKC was searching space for far-out new foods, like new Planet 51 Chicken Nugget and Mac & Cheese meals – BUT HE GOT LOST!!\n\nCan you help KC find his rocket ship and get home before time runs out?! Along the way, you’ll collect Neopoints and yummy Planet 51 foods from Kid Cuisine.";
		private var mDatabase:KidDatabase
		private var mUserName:String
		private var mDatabaseID:String
		//Phase 2
		private var mVideoPopup:VideoPopup;	//popup that allows users to see the video
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageMainLanding(pName:String = null, pView:Object = null, pUserName:String = null, pID:String = null):void
		{
			super(pName, pView);
			mUserName = pUserName;
			mDatabaseID = pID
			setupPage ()
			if (pUserName == "GUEST_USER_ACCOUNT")
			{
				createPopup()
			}
			else 
			{
				setupDatabase()
			}
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImageButton("SpaceBackground", "spaceButton")
			addImage("MainPage", "mainPage");
			addImageButton("GameButton", "gameButton", 488, -53)
			//Phase 2
			mVideoPopup = new VideoPopup("", 30,100);
			addChild(mVideoPopup)
			mVideoPopup.hide();
		}
		
		
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndPlay("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 5), new GlowFilter(0x3399FF, 1, 8, 8, 5, 5)]
			}
		}
		
		
		
		override protected function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				MovieClip(mc.parent).filters = null
			}
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupDatabase():void
		{
			trace ("data base kick in")
			mDatabase = new KidDatabase (mUserName, mDatabaseID)
			//FOR TESTING: Uncomment this to reset first time visitor and first time main vars
			//mDatabase.resetVars();
			mDatabase.addEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate, false, 0, true)
			mDatabase.myInit()
		}
		
		private function createPopup():void
		{
			var popup:PopupSimple = new PopupSimple ("", 80, 100);
			popup.updateText(mWelcomeTxt, 500)
			addChild (popup)
		}
		
		private function videoPopup ():void {
			mVideoPopup.show();
			MovieClip(mVideoPopup.getChildByName("closeButton")).btnText.text = "Back";
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function handleDatabaseUpdate (evt:Event):void
		{
			//if firstTime, show popup.
			trace ("handleDatabaBaseUpdate", mDatabase.firstTimeMain, mDatabase.firstTime)
			if (mDatabase.firstTimeMain == "true")
			{
				
				//keep this separate cause there is also undefined state
				mDatabase.updateDatabaseMain()
				mDatabase.removeEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate);  
				createPopup()
			}
			else if (mDatabase.firstTimeMain == "false")
			{
				//keep this separate cause there is also undefined state
				mDatabase.removeEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate);
				
			}
			
		}
		
		
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "lunch":
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211074;15177704;v?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=feedapet")
					NeoTracker.sendTrackerID(14524);
					break;
					
				case "gameButton":
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211011;15177704;m?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=games")
					NeoTracker.sendTrackerID(14523);
					break;
				
				case "backpack":
					NeoTracker.processClickURL(15036);
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211310;15177704;o?http://www.kidcuisine.com/realFun/promotions/index.jsp")
					//NeoTracker.sendTrackerID(14527);
					break;
					
				case "purpleplanet":
					//Linlk to the planet51 microsite
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;219134673;15177704;h?http://kidcuisine.eprize.net/planet51");
					NeoTracker.processClickURL(15273);
					break;
					
				case "sweepstake":
					//Phase 2 - Viviana - Sept 09
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211220;15177704;o?http://www.nick.com/neopets/sweepstakes/kidcuisine/")
					//NeoTracker.sendTrackerID(14526);
					break;
					
				case "spaceButton":
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216210974;15177704;d?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=adventure")
					NeoTracker.sendTrackerID(14522);
					break;
				
				//Phase 2
				/*case "postcard":
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211169;15177704;a?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt")
					NeoTracker.sendTrackerID(14525);
					break;*/
				
				
				//Phase 2
				case "video":
					videoPopup();
					//omniture
					runJavaScript2 ("Planet 51 Video");
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211169;15177704;a?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt")
					//NeoTracker.sendTrackerID(14525);
					break;
			}
		}
		
		/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		private function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				try
				{ 
					ExternalInterface.call("sendADLinkCall", scriptID) ;
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
				}
			}
		}
		
		private function runJavaScript2(scriptID:String):void
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
		

	}
	
}