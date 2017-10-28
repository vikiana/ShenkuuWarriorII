/**
 *	Handles main control of click destination project
 *	This project has only one page so most of the things are happening in main page.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *
 *	@modified March 2010 - in progress. 
 *  @Adding the MenuManager and getting rid of AbsView.ADD_DISPLAY_OBJ
 */

package com.neopets.games.marketing.destination.destination_test
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
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsControl	//must include
	import com.neopets.projects.destination.destinationV3.AbsView	//must include
	import com.neopets.projects.destination.destinationV3.AbsPage	//must include
	import com.neopets.projects.destination.destinationV3.Parameters	//must include
	import com.neopets.games.marketing.destination.destination_test.page.*

	import com.neopets.util.events.CustomEvent;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import com.neopets.util.loading.LoadingManager;
	
	// Added 3/10
	import com.neopets.projects.gameEngine.gui.MenuManager;
	
	public class DestinationControl extends AbsControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mLocalTesting:Boolean = true; // set to false when going live
		protected var mCurrentPage:AbsPage;
		
		// added 3/10
		private	var mMenuManager = MenuManager.instance;
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DestinationControl():void
		{
			super();
			trace(" ---Destination Control--- ");
		}
		
		//----------------------------------------
		//GETTERS AND SETTERS
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
			var loadingSign:MC_LoadingSign = new MC_LoadingSign ();
			loadingSign.x = 390;
			loadingSign.y = 250;
			loadingSign.name = "loadingSign";			
			Parameters.view.dispatchEvent(new CustomEvent({DATA:loadingSign},AbsView.ADD_DISPLAY_OBJ))
			
			// If live, check/use setupMainPage to use flash vars
			if(!mLocalTesting)
			{
			  directPageTo();
			}
			
			else
			{
			  setupMainPage();
			  //setupFeedAPetPage(); // works correctly, pets will show up if you're logged into IE
			   trace("---- Local Testing ----");
			}
		}
		
		// NOT SET UP YET
		// Read flashvar or some sort of php call to get which page to show
		//we have a util clas that reads flashvars
			
		protected function directPageTo():void
		{
			var pageName:String =  "something" //use that here
			
			switch(pageName)
			{
				case "mainPage":
				setupMainPage()
				break;
				
				case "feedapetPage":
				setupFeedAPetPage();
				break;
				
				case "gamesPage":
				//setupGamePage();
				break;
				
				case "whateverPage":
				//setupWhateverPage();
				break;;
			}
			
		}
		
		/*
		  Abe's old system which grabs the content from the swfs in the sponsors folder
		  - uses addChild
		  Clive's new version will use the Menu Manager
	
		*/
		// main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up MAIN LANDING page\n")
			var mainPage = new MainPage("mainPage")
			trace("1");
			Parameters.view.dispatchEvent(new CustomEvent({DATA:mainPage},AbsView.ADD_DISPLAY_OBJ));
			trace("2");
			mCurrentPage = AbsPage(mainPage);
			trace("3");
			//mMenuManager.menuNavigation(MenuManager);
			
		}
		
		// feed a pet page
		protected override function setupFeedAPetPage():void
		{
			//var tLM:LoadingManager = LoadingManager.instance; // Clive added 3/22/10 ?
			trace("\nSet up Feed page\n")
			var feedPage = new FeedAPetPage("feedPage");
			Parameters.view.dispatchEvent(new CustomEvent({DATA:feedPage},AbsView.ADD_DISPLAY_OBJ));
			mCurrentPage = AbsPage(feedPage);
		}
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	@NOTE:	ALL of the items/objects clicked from the stage will be reported here.
		 *			You simply have to choose what you will process and what you will ignore 
		 *			Here I choose to pick up on most of buttons (that has "btnArea" movie clip within)
		 *			And respond appropriately. Some buttons are handled by the "page" itself if neccessary.
		 **/
		 
		protected override function handleObjClick(e:CustomEvent):void
		{
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
				case "feed":
				trace ("--- feed a pet btn click ---");
				// trace("mPage: " +mCurrentPage); // ok
				
				  if (mCurrentPage != null)
				  {
					//remove main screen  
					Parameters.view.dispatchEvent(new CustomEvent({DATA:mCurrentPage},AbsView.REMOVE_DISPLAY_OBJ)); 
					mCurrentPage = null;
					var loadingSign:MC_LoadingSign = new MC_LoadingSign ();
					loadingSign.x = 390;
					loadingSign.y = 250;
					loadingSign.name = "loadingSign";
					Parameters.view.dispatchEvent(new CustomEvent({DATA:loadingSign},AbsView.ADD_DISPLAY_OBJ));
					setupFeedAPetPage();
					break;
				  }
				  
		  		 
				 //Test - 3/23/10
				 // Remove feedapet page and bring back main page
				  case "feedpageBackBtn":
				  trace ("--- feedpage btn click ---");
				  
				  if (mCurrentPage != null)
				  {
					// remove feedback page
				  	Parameters.view.dispatchEvent(new CustomEvent({DATA:mCurrentPage},AbsView.REMOVE_DISPLAY_OBJ));
				  	mCurrentPage = null;
					
				  	setupMainPage(); // Not working - doesn't complete
				  	break;
				  }
				
				 
				 
					
				}
			}
		}
	}
	
}