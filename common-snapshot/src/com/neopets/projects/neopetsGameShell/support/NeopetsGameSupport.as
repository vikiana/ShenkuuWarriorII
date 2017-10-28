
/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.support
{
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.pppGameShell.support.IGameContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.XMLLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	/**
	 *	This is used to extend the GameShell Interface
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.16.2008
	 */
	 
	public class NeopetsGameSupport extends BaseClass //implements IGameContainer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ID:String = "NeopetsGameSupport";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mGameShell_Events:GameShell_Events;
		protected var mInShell:Boolean;
		protected var mConfigXML:XML;
		protected var mRootMC:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function NeopetsGameSupport():void{
			setupVars();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get gameShell_Events():GameShell_Events
		{
			return mGameShell_Events;	
		}
		
		public function get inShell():Boolean
		{
			return mInShell;
		}
		
		public function  get configXML():XML
		{
			return mConfigXML;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function init(pShellRoot:MovieClip = null,pGameShell_Events:GameShell_Events = null, pConfigXML:XML = null):void
		{
			mRootMC = pShellRoot;
			
			mGameShell_Events = (pGameShell_Events != null) ? pGameShell_Events:mGameShell_Events;
			mInShell = (pGameShell_Events != null) ? true:false;
			
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_TRANSLATION,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_SFC,onDataReturn,false,0,true);
	
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_INTERFACE,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_GAME,onDataReturn,false,0,true);
			
			if (pConfigXML != null)
			{
				mConfigXML = pConfigXML;
				localInit();	
			}
			else
			{
				LoadConfigData();	
			}
			
			
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
		
		/**
		 * @Note: This is when the Data is Comming Back from Load
		 * @param	evt.oData.XML			XML			The Config File (useally)
		 * @param	evt.oData.ID			String		The Id of the Request
		 */
		 
		private function onConfigDataReady(evt:CustomEvent):void
		{
			mConfigXML = evt.oData.XML;
			traceReporting = Boolean(Number(mConfigXML.SETUP.TESTING.TRACE_EVENTS.@FLAG));
			localInit();
				
		}
		
		private function onConfigDataError(evt:Event):void
		{
			output("Issue loading the Config Data");
		}
		
		//--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * So the Game and be Complied without being in the GameApplication Engine
		 */
		 
		private function setupVars():void
		{
			mGameShell_Events = new GameShell_Events();	
		}
		
		/**
		 * @Note: This is to request the Config File (as well as other Shell Cmds)
		 * @Note: This uses the GameShell_Events as a Bridge, but if run locally will load the Config File manuelly.
		 */
		 
		private function LoadConfigData():void
		{
			var tloaderXML:XMLLoader = new XMLLoader("config.xml");
			tloaderXML.addEventListener(tloaderXML.XML_DONE,onConfigDataReady,false,0,true);
			tloaderXML.addEventListener(tloaderXML.XML_LOAD_ERROR,onConfigDataError,false,0,true);
		}
		
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
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
