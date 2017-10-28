/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.sixFlags2010
{
	import com.neopets.games.marketing.destination.altadorbooths.common.AbstractPageCustom;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationView;
	import com.neopets.games.marketing.destination.sixFlags2010.pages.FeedaPetSixFlags2010;
	import com.neopets.games.marketing.destination.sixFlags2010.pages.FlagsOfFrenzy;
	import com.neopets.games.marketing.destination.sixFlags2010.pages.InfoScreen;
	import com.neopets.games.marketing.destination.sixFlags2010.pages.SixFlags2010LandingPage;
	import com.neopets.games.marketing.destination.sixFlags2010.pages.SixFlags2010VideoPage;
	import com.neopets.games.marketing.destination.sixFlags2010.pages.SouvenirShop;
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

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	public class SixFlags2010DestinationControl extends AltadorAlleyDestinationControl
	{
		
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var mVideoScreen:SixFlags2010VideoPage;
		
		
	
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SixFlags2010DestinationControl():void
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
			
			//SixFlags 2010
			/*
			** Main Landing Page
			** Feed a Pet
			** Flags Frezy
			** Information Booth
			** Freq Flags (Souvenir Shop)
			** Video
			** E-Card
			** Collection Completition
			*/
			
			var tClass:Class = LibraryLoader.getLibrarySymbol("LandingPage");
			var tLandingPage:SixFlags2010LandingPage = new tClass();
			tLandingPage.init("landing");
			Parameters.view.addChild (tLandingPage);
			
			var tClass2:Class = LibraryLoader.getLibrarySymbol("FeedaPetScreen");
			var tFeedPet:FeedaPetSixFlags2010 = new tClass2();
			tFeedPet.init("feedaPet");
			Parameters.view.addChild (tFeedPet);
			
			var tClass3:Class = LibraryLoader.getLibrarySymbol("VideoScreen");
			mVideoScreen = new tClass3();
			mVideoScreen.init("video");
			Parameters.view.addChild (mVideoScreen);
			
			var tClass4:Class = LibraryLoader.getLibrarySymbol("InfoScreen");
			var tInfo:InfoScreen = new tClass4();
			tInfo.init("info");
			Parameters.view.addChild (tInfo);
			
			var tClass5:Class = LibraryLoader.getLibrarySymbol(SouvenirShop.LIBRARYID);
			var tSouviner:SouvenirShop = new tClass5();
			tSouviner.init("souvenir");
			Parameters.view.addChild (tSouviner);
			
			var tClass6:Class = LibraryLoader.getLibrarySymbol(FlagsOfFrenzy.LIBRARYID);
			var tFlagsOfFrenzy:FlagsOfFrenzy = new tClass6();
			tFlagsOfFrenzy.init("flags");
			Parameters.view.addChild (tFlagsOfFrenzy);
			
			//Parameters.view.addChild (new SixFlags2010VideoPage ("video", Parameters.view ));
			//sendActivityService(SixFlagsConstants.ACTIVITY_LINK_LANDINGPAGE);
			//var r:Responder = new Responder (onFeedReset, onFeedStatus);
			//Parameters.connection.call ("FeedAPet.setFedRecentlyFalse", null);
			
			
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
		 *			You simply has to choose to what you will process what you will ignore 
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
				
				switch (objName)
				{
					//LANDING PAGE
					//common
					case "close_btn":
						gotoPage("landing");
					break;
					//FeedaPet
					case "backBtn":
						gotoPage("landing");	
					break;
					//VIDEO
					case "videoclose_btn":
						mVideoScreen.hide();
						gotoPage("landing");
					break;
					//Info
					case "infoBackBtn":
						gotoPage("landing");
					break;
					//Souvenir
					case "souvenirExitBtn":
						gotoPage("landing");	
					break;
					//FlagsofFrenzy
					case "flagsOfFrenzyBack":
						gotoPage("landing");		
					break;
				}
			}
		}
	}
}