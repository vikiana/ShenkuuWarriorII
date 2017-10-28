/**
 *	Handles main control of click destination project
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids
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
		//CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var _landingPageURL:String = "landing_page_v2.swf";
		protected var _feedPageURL:String = "feed_page_v2.swf";
		protected var _gamesPageURL:String = "games_page_v2.swf";
		protected var _questPageURL:String = "quest_page_v2.swf";
		protected var _videoPageURL:String = "video_page_v1.swf";
		protected var _shopPageURL:String = "shop_page_v1.swf";
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DestinationControl():void
		{
			super ();
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		public function get feedPageURL():String { return _feedPageURL; }
		
		public function get gamesPageURL():String { return _gamesPageURL; }
		
		public function get landingPageURL():String { return _landingPageURL; }
		
		public function get questPageURL():String { return _questPageURL; }
		
		public function get shopPageURL():String { return _shopPageURL; }
		
		public function get videoPageURL():String { return _videoPageURL; }
		
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
			setupMainPage();
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up MAIN LANDING page\n");
			Parameters.view.loadPage(_landingPageURL);
		}
		
		// method to create main page
		protected override function setupGamesPage():void
		{
			trace("set up games page")
		}
		
		// method to create info page
		protected override function setupInfoPage():void
		{
			trace("set up info page")
		}
		
		// method to create peedApet page
		protected override function setupFeedAPetPage():void
		{
			trace ("setup FeedAPet page")
		}
		
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