
/* AS3
	Copyright 2008
*/

package com.neopets.projects.trivia.shell
{
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.neopetsGameShell.support.BaseObject;
	import com.neopets.projects.trivia.common.TriviaEngine;
	import com.neopets.projects.trivia.common.TriviaWrapper;
	import com.neopets.util.events.CustomEvent;
	
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
	 
	public class TriviaEngineShell extends BaseObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const INTERNAL_TESTING:Boolean = false;
		public const READY:String = "PreloaderIsReady";
		
		public const LOCAL_PATHWAY:String = "include/";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mInterface:TriviaWrapper
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TriviaEngineShell():void{
			setupVars();
			                                                                                                                                                              
			if (INTERNAL_TESTING)
			{
				init();
			}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	
		public function get shellInterface():TriviaWrapper
		{
			return mInterface;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * This for the Shell Application to Pass Info when used in the Game Shell not the FLA
		 */
		 
		public function externalInit(pGameShell_Events:GameShell_Events = null, pConfigXML:XML = null):void
		{
			setupVars();
			mInterface.init(this,LOCAL_PATHWAY,pGameShell_Events,pConfigXML);	
		}
		
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mInterface = new TriviaWrapper();
			mInterface.addEventListener(mInterface.SEND_THROUGH_CMD,sendThroughEvent,false,0,true);	
			
		}
		
		/**
		 * This for internal testing and compiling from the Flash Application
		 */
		 
		private function init():void
		{
			mInterface.init(this,LOCAL_PATHWAY);	
		}
		
	}
	
}
