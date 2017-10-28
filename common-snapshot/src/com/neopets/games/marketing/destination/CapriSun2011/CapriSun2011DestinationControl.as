/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.CapriSun2011
{
	import com.neopets.games.marketing.destination.altadorbooths.common.AbstractPageCustom;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationView;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.FeedaPetCapriSun2011;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.CapriSun2011PointGrabPage;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.CapriSun2011CommunityChallengePage;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.InfoScreen;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.CapriSun2011LandingPage;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.CapriSun2011VideoPage;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.CapriSun2011ArcadePage;
	import com.neopets.games.marketing.destination.CapriSun2011.pages.SouvenirShop;
	import com.neopets.projects.destination.destinationV3.AbsControl;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.external.ExternalInterface;

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	public class CapriSun2011DestinationControl extends AltadorAlleyDestinationControl
	{
		
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var tLandingPage:CapriSun2011LandingPage;
		protected var mVideoScreen:CapriSun2011VideoPage;
		protected var mArcadeScreen:CapriSun2011ArcadePage;
		protected var mPointGrabScreen:CapriSun2011PointGrabPage;
		protected var mCommunityChallengeScreen:CapriSun2011CommunityChallengePage;
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function CapriSun2011DestinationControl():void
		{
			super ();
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
		override protected function createPages():void{
			setupMainPage();
			ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");

		}
		
		
		
		/**
		 * 
		 * Navigation. This is a simplified navigation in wich only the opages on top of the selected page will be hidden. This makes it useful for both pages and popups.
		 * 
		 * @param pName      name of the page to navigate to
		 * 
		 * */
		
		
		override protected function gotoPage(pName:String):void {
				
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
		
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up pages\n");
			
			var tClass:Class = LibraryLoader.getLibrarySymbol("LandingPage");
			tLandingPage = new tClass();
			tLandingPage.init("landing");
			Parameters.view.addChild (tLandingPage);
			
			var tClass2:Class = LibraryLoader.getLibrarySymbol("VideoScreen");
			mVideoScreen = new tClass2();
			mVideoScreen.init("video");
			Parameters.view.addChild (mVideoScreen);
			
			var tClass3:Class = LibraryLoader.getLibrarySymbol("ArcadeScreen");
			mArcadeScreen = new tClass3();
			mArcadeScreen.init("arcade");
			Parameters.view.addChild (mArcadeScreen);
			
			var tClass4:Class = LibraryLoader.getLibrarySymbol("PointGrabScreen");
			mPointGrabScreen = new tClass4();
			mPointGrabScreen.init("pointGrab");
			Parameters.view.addChild (mPointGrabScreen);
			
			var tClass5:Class = LibraryLoader.getLibrarySymbol("CommunityChallengeScreen");
			mCommunityChallengeScreen = new tClass5();
			mCommunityChallengeScreen.init("communityChallenge");
			Parameters.view.addChild (mCommunityChallengeScreen);
			
			// Load this page first
			gotoPage("landing");
			
		}
		
		/*private function onFeedReset(msg:String):void {
			trace (msg);
		}
		
		private function onFeedStatus(msg:String):void {
			trace (msg);
		}*/
		


		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------	
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		/**
		 *	@NOTE:	ALL of the items/objects clicked from the stage will be reported here.
		 *			You simply have to choose to what you will process what you will ignore 
		 *			Here I choose to pick up on most of buttons (that has "btnArea" movie clip within)
		 *			And respond appropriately.  Some buttons are handled by the "page" itself if neccessary.
		 **/
		protected override function handleObjClick(e:CustomEvent):void
		{
			if (e.oData.DATA.parent == null)
			{
				return;
			}
				
			trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			//if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				
				// Return to landing page from other pages
				switch (objName)
				{
					
					// common
					case "close_btn":
						ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
						gotoPage("landing");
					break;
					
					// VIDEO
					case "videoBackBtn":
						ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
						mVideoScreen.hide(); // remove the video player 
						gotoPage("landing");
					break;
					
					// ARCADE
					case "arcadeBackBtn":
						ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
						gotoPage("landing");
						break;
					
					// POINT GRAB
					case "pointGrabBackBtn":
						ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
						mPointGrabScreen.resetPage();
						if(mPointGrabScreen.myTimer != null)
						{
						  mPointGrabScreen.myTimer.stop();
						}
						gotoPage("landing");
						break;
					
				
					// COMMUNITY CHALLENGE
					case "communityBackBtn":
						gotoPage("landing");
						ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
						break;
					
					/* Duplicate
					// VIDEO BUTTON
					case "videoBackBtn":
						gotoPage("landing");
						ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
						break;
					*/
					
				}
			}
		}
	}
}