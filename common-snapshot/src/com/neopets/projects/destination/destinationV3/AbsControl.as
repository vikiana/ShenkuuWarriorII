/**
 *	Handles main control of click destination project
 *	Roughly follows the MVC separation
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  04.27.2009
 */

 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------
 /**
  * Prep:
  *	To use any classes here, you must create a class(es) and extend abstract classes you wish to use
  *	Every time any class name (or abstract class name) is mentioned, 
  * assume I am referring it as a child class of that abstract class.
  *
  * Workflow:
  * 1) DestinationView (D.view) should be your document class
  * 2) D.view should instantiates DestinationControl(D.control) class
  *	3) D.view retrieves user name and once it's ready it'll dispatch an event for D.control to hear 
  *	4) upon hearing it, D.control takes over the control and usually sets up the landing page
  *	5) Once this inital dynamic has been set up, a triangle dynamic is formed:
  *
  *	ABS. DESTINATION VIEW (or its child)
  * -In charge of adding and removing "pages" (scene) from the stage when it is told to do so by D.control 
  *	-When display Objects are clicked, it will report to D.control via event dispatcher
  *	
  *	ABS. DESTINATION CONTROL (or its child)
  *	-It is in charge of hearing what's being clicked from the stage and taking appropriate actions   
  *	-However Not all actions must be contolled by DestinationControl.
  *
  * OTHER PAGES
  *	-Each "page" must extend AbstractClass or one of its children
  *	-Each page should set up its components ex. introPage should set up it's own background, buttons, etc.
  * -Small actions can be managed within page itself
  **/
 
 
 
package com.neopets.projects.destination.destinationV3
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	
	public class AbsControl extends EventDispatcher
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public const OBJ_CLICKED:String = "Obj Clicked from Main Display"
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function AbsControl():void
		{
			trace("\n ===== 2. CONTROL INITIATED ===== \n");
			Parameters.view.addEventListener(AbsView.OBJ_CLICKED, handleObjClick, false, 0, true);
			Parameters.view.addEventListener(AbsView.SETUP_READY, handleSetupReady, false, 0, true);			
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
		
		//When DestinationMain (Document class) is set up, it'll dispatch an event and call this function
		private function handleSetupReady(evt:Event):void
		{
			afterSetupReady()
		}
		
		/**
		 *	When intial parameters are set up (view, control, user name, project id, etc.)
		 *	this function is called
		 **/
		protected function afterSetupReady():void
		{
			Parameters.view.removeEventListener(AbsView.SETUP_READY, handleSetupReady);
			childInit();
		}
		
		/**
		 *	This is the very first step when everything is ready.  It must be overriden by child class
		 *	In general, it should:
		 *	1. Setup data base
		 *	2. Create landing page
		 *	3. And do everything else necessary for set up
		 **/
		protected function childInit():void{};
		
		//	These are general pages you might need to create destination project
		// 	due to it's components each page should be re-writen
		
		protected function setupLandingPage():void{}
		protected function setupMainPage():void{}
		protected function setupVideoPage():void{}
		protected function setupInfoPage():void{}
		protected function setupFeedAPetPage():void{}
		protected function setupGamesPage():void{}
		
		
		
		/**
		 * If pName is left as null, it will remove all the pages on the stage.
		 * Otherwise, it will remove designated page from the stage
		 *
		 *	@PARAM		pName		Name of the page you'd like to remove from the stage		
		 **/
		protected function cleanupPage(pName:String = null):void
		{
			//trace ("what the", mView.getChildByName(pName))
			var page:Object //abstract page class or it's descedents
			if (pName == null)
			{
				while (Parameters.view.numChildren > 0)
				{
					page = Parameters.view.getChildAt(0) as Object;
					if (page.hasOwnProperty("cleanup"))
					{
						page.cleanup()
					}
					Parameters.view.dispatchEvent(new CustomEvent({DATA:page}, Parameters.view.REMOVE_DISPLAY_OBJ))
				}
			}
			else 
			{
				if (Parameters.view.getChildByName(pName) != null)
				{
					trace (Parameters.view.getChildByName(pName) as Object)
					page = Parameters.view.getChildByName(pName) as Object;
					Parameters.view.cleanup();
					Parameters.view.dispatchEvent(new CustomEvent({DATA:page},Parameters.view.REMOVE_DISPLAY_OBJ))
				}
			}
		}

		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------

		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		/**
		 * Child should override this function
		 * This should handle most of the important button clicks from the stage
		 *
		 * @PARAM		e		displayObject (mostly it assumes it'a a button with "btnArea" inside)		
		 **/
		protected function handleObjClick(e:CustomEvent):void
		{
			//trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			//e.oData.DATA.parent will return the button object
			//e.oData.DATA.parent.name will return the name of the object
			
			//example of handling the button click below:
			
			/*
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "Btn_VideoPage":
					cleanupPage()
					sendTrackerID(14364) 
					setupVideoPage()
					break;
				
				case "Btn_Game1":
					processClickURL(14258)
					mSixFlagsDatabase.game1++
					break;
				
				case "Btn_InfoPage":
					cleanupPage()
					sendTrackerID(14365) 
					setupInfoPage()
					break;
			}
			*/
			
		}
		
	}
	
}