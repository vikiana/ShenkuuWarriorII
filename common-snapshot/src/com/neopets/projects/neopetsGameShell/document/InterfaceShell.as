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
	 *	This is for the FLA. It Is the Interface document Class and Holds the GameShell_Interface.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.07.2009
	 */
	 
	public class InterfaceShell extends BaseObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const INTERNAL_TESTING:Boolean = false;
		public const READY:String = "InterfaceIsReady";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mInterface:GameShell_Interface;
		
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
			//setupVars();
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
			mInterface = new GameShell_Interface();
			mInterface.addEventListener(mInterface.READY,sendThroughEvent,false,0,true);	
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
