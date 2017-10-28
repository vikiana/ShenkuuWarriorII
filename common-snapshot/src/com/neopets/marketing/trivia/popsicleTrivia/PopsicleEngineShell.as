
/* AS3
	Copyright 2008
*/

package com.neopets.marketing.trivia.popsicleTrivia
{
	import com.neopets.projects.neopetsGameShell.support.BaseObject;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 *	This is for the FLA. It Is the Interface document Class and Holds the GameShell_Interface.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.07.2009
	 */
	 
	public class PopsicleEngineShell extends BaseObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const INTERNAL_TESTING:Boolean = true;
		public const READY:String = "PreloaderIsReady";
		
		//public const LOCAL_PATHWAY:String = "include/";
		public const LOCAL_PATHWAY:String = "http://images.neopets.com/sponsors/popsicle/include/config.xml";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mTriviaApp:PopsicleTriviaWrapper;
		private var mTriviaAppOnStage:Boolean = false;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var mcInterface:MovieClip; //This is the Main Interface on the Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PopsicleEngineShell():void
		{
			setupVars();
			var tObj1:* = LoaderInfo(this.root.loaderInfo).parameters.popsiclesFound;
			var tObj2:* = LoaderInfo(this.root.loaderInfo).parameters.popsiclesFound;
			
			trace("PopsicleEngineShell FlashVars:", tObj1, " > ", tObj2);
			mcInterface.popsiclesFound = tObj1;
			mcInterface.popsiclesBanner = tObj2;
			init();
		}


		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	
		public function get shellInterface():PopsicleTriviaWrapper
		{
			return mTriviaApp;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Sends Message Through the Shell to anything listening
		 * @param	evt.oData.CMD		String		The Desired Command
		 * @param	evt.oData.PARAM		Object		The Desired Paramaters
		 */
		 	
		public function sendThroughEvent(evt:CustomEvent):void
		{
			var tPassedObj:Object = evt.oData.hasOwnProperty("PARAM") ? evt.oData.PARAM : {};
			this.dispatchEvent(new CustomEvent(tPassedObj,evt.oData.CMD));	
		}
		
		/**
		 * @Note: Interface has sent a show Trivia Event
		 */
		 
		private function showTrivia(evt:Event):void
		{
			if (!mTriviaAppOnStage)
			{
				mTriviaAppOnStage = true;
				setupTrivia();	
			}
		}
		
		/**
		 * @Note: Interface has sent a close Trivia Event
		 */
		 
		private function hideTrivia(evt:Event):void
		{
			mTriviaApp.closeTrivia();	
		}
		
		/**
		 * @Note: Get Rid of Trivia
		 */
		 
		private function closeDownTrivia(evt:Event):void
		{
			removeChild(mTriviaApp);
			mTriviaApp = null;
			mTriviaAppOnStage = false;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			
			mcInterface.addEventListener("SHOW_TRIVIA",showTrivia,false,0,true);
			mcInterface.addEventListener("CLOSE_TRIVIA",hideTrivia,false,0,true);
			
		}
		
		private function setupTrivia():void
		{
			mTriviaApp = new TriviaBase(); //This is the Linked Name in the Flash Library
			mTriviaApp.addEventListener(mTriviaApp.SEND_THROUGH_CMD,sendThroughEvent,false,0,true);
			mTriviaApp.addEventListener(mTriviaApp.TRIVIA_COMPLETED,closeDownTrivia,false,0,true);	
			mTriviaApp.addEventListener(mTriviaApp.TRIVIA_LOADED,triviaReady,false,0,true);	
			
			mTriviaApp.x = 517.6;
			mTriviaApp.y = 55.6;
			addChild(mTriviaApp);
			
			mTriviaApp.init(this,LOCAL_PATHWAY);
			
		}
		
		/**
		 * Need to Wait for Config.xml to be ready before showTrivia
		 */
		 
		private function triviaReady(evt:Event):void
		{
			mTriviaApp.showTrivia();
		}
		
		/**
		 * This for internal testing and compiling from the Flash Application
		 */
		 
		private function init():void
		{
				
		}
		
	}
	
}
