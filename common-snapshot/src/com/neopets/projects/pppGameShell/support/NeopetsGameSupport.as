
/* AS3
	Copyright 2008
*/
package com.neopets.projects.pppGameShell.support
{
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	/**
	 *	This is used to extend the Base Document of any game
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.16.2008
	 */
	public class NeopetsGameSupport extends MovieClip implements IGameContainer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mGameShell_Events:GameShell_Events;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function NeopetsGameSupport():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get gameShell_Events():GameShell_Events
		{
			return mGameShell_Events;	
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function init(pGameShell_Events:GameShell_Events):void
		{
			mGameShell_Events = pGameShell_Events;
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_TRANSLATION,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_SFC,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_INTERFACE,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_GAME,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_INTRO,onDataReturn,false,0,true);
			
			localInit();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: This is for handling The Events from the mGameShell_Events.
		 * @param		evt.oData.CMD		String		The Command Back
		 */
		private function onDataReturn(evt:CustomEvent):void
		{
			switch (evt.type)
			{
				case mGameShell_Events.ACTION_RETURN_TRANSLATION:
					translateObject(evt.oData);	
				break;
				case mGameShell_Events.ACTION_RETURN_SFC:
					smartFoxClientSetup(evt.oData);	
				break;
				case mGameShell_Events.ACTION_SEND_CMD_INTERFACE:
					returnedCmdInterface(evt.oData);
				break;
				case mGameShell_Events.ACTION_SEND_CMD_GAME:
					returnedCmdGame(evt.oData);
				break;
			
			}
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is here to be OVERRIDE if needed
		 */
		 
		 protected function localInit():void {}
		 
		 /**
		 * @Note: This should to be OVERRIDED
		 * @param	PassedObject.OBJECT		DisplayObject		The Button /TextField which the String needs to go
		 * @param	PassedObject.STRING		String				The Translated Text
		 */
		 
		 protected function translateObject(PassedObject:Object):void {}

		 
		 /**
		 * @Note: This should to be OVERRIDED. This is only needed if this is a multiplayer game
		 * @param	PassedObject.OBJECT		SmartFoxClient		
		 */
		 
		 protected function smartFoxClientSetup(PassedObject:Object):void {}
		 
		 /**
		 * @Note: This should to be OVERRIDED. This is only needed if the Game Container is Loading a seperate Interface Layer
		 * @param	PassedObject.CMD		String		The Desired Command
		 * @param	PassedObject.PARAM		Object		The Desired Paramaters
		 */
		 
		 protected function returnedCmdInterface(PassedObject:Object):void {}
		 
		 
		 /**
		 * @Note: This should to be OVERRIDED. This is needed if you wish communication between the different interface elements
		 * @param	PassedObject.CMD		String		The Desired Command
		 * @param	PassedObject.PARAM		Object		The Desired Paramaters		
		 */
		 
		 protected function returnedCmdGame(PassedObject:Object):void {}
	}
	
}
