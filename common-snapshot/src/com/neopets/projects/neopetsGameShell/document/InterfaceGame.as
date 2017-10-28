/* AS3
	Copyright 2008
*/

package com.neopets.projects.neopetsGameShell.document
{
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.neopetsGameShell.support.BaseObject;
	import com.neopets.projects.neopetsGameShell.support.GameShell_Interface;
	
	import flash.events.Event;
	
	
	/**
	 * 	THIS IS A SHELL (A Holder) for the actual Game. 
	 *	It Is the Game document Class and Holds the actual Game Class. 
	 *  You will NEED to modify the mInterface variable to be Typed to your Game Main Class.
	 * 
	 *  #### IMPORTANT ####
	 *  For Local Testing (Not in the Neopets Game Shell) You set the INTERNAL_TESTING to true.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.09.2009
	 */
	 
	public class InterfaceGame extends BaseObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const INTERNAL_TESTING:Boolean = false;
		public const READY:String = "GAMEIsReady";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mInterface:Object; /* YOU CAN SET THIS TO YOUR GAME CLASS */
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function InterfaceShell():void{
			setupVars();
			
			if (INTERNAL_TESTING)
			{
				init();
			}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get shellInterface():GameShell_Interface
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
			mInterface.init(this,pGameShell_Events,pConfigXML);	
		
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public function sendThroughEvent(evt:Event):void
		{
			this.dispatchEvent(new Event(READY));	
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mInterface = new Object();
			mInterface.addEventListener(READY,sendThroughEvent,false,0,true);	
		}
		
		/**
		 * This for internal testing and compiling from the Flash Application
		 */
		 
		private function init():void
		{
			mInterface.init(this);	
		}
		
	}
	
}
