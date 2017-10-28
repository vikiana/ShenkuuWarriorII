
/* AS3
	Copyright 2008
*/
package com.neopets.marketing.trivia.popsicleTrivia
{
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.XMLLoader;
	import com.neopets.util.support.BaseObject;
	import com.neopets.util.translation.TranslateItems;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	/**
	 *	This Loads the Config.xml File and has some of the backend communication utilities set
	     up to be overrided.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.16.2008
	 */
	 
	public class PopsicleTriviaEngineSupport extends BaseObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ID:String = "NeopetsGameSupport";
		public const INTERFACE_READY:String = "TheInterfaceIsReady";
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_UpClass";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mGameShell_Events:GameShell_Events;
		protected var mInShell:Boolean;
		protected var mConfigXML:XML;
		protected var mQuestionXML:XML;
		
		protected var mRootMC:MovieClip;
		protected var mLocalPathway:String;
		
		protected var mViewContainer:ViewContainer;
		protected var mID:String;

		protected var mLoaderXML:XMLLoader;
		protected var mQuestionLoaderXML:XMLLoader;
		
		protected var mTranslateItems:TranslateItems;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PopsicleTriviaEngineSupport():void{
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
		
		public function  get viewContainer():ViewContainer
		{
			return mViewContainer;
		}
		
		public function  get ID():String
		{
			return mID;
		}
		
		public function  set ID(pID:String):void
		{
			mID = pID;
		}
		
		public function get translateManager():TranslateItems
		{
			return mTranslateItems;
		}

		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function init(pShellRoot:MovieClip, pLocalPathway:String, pGameShell_Events:GameShell_Events = null, pConfigXML:XML = null):void
		{
			mRootMC = pShellRoot;
			mLocalPathway = pLocalPathway;
			mGameShell_Events = (pGameShell_Events != null) ? pGameShell_Events:mGameShell_Events;
			mInShell = (pGameShell_Events != null) ? true:false;
			
			
			//mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_TRANSLATION,onDataReturn,false,0,true);
			//mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_SFC,onDataReturn,false,0,true);
	
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
				case mGameShell_Events.ACTION_RETURN_SFC:
					smartFoxClientSetup(evt.oData);	
				break;
				case mGameShell_Events.ACTION_SEND_CMD_INTERFACE:
					returnedCmdInterface(evt.oData);
				break;
				case mGameShell_Events.ACTION_SEND_CMD_GAME:
					returnedCmdGame(evt.oData);
				break;
				case mGameShell_Events.ACTION_SEND_CMD_PRELOADER:
					returnedCmdPreloader(evt.oData);
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
			mLoaderXML = null;
			LoadQuestionData();
			
				
		}
		
		/**
		 * @Note: This is when the Data is Comming Back from Load
		 * @param	evt.oData.XML			XML			The Config File (useally)
		 * @param	evt.oData.ID			String		The Id of the Request
		 */
		 
		private function onQuestionDataReady(evt:CustomEvent):void
		{
			mQuestionXML = evt.oData.XML;
			mQuestionLoaderXML = null;
			localInit();
		}
		
		/**
		 * @Note: This is when the Data is Comming Back from Load
		 */
		 
		private function onConfigDataError(evt:Event):void
		{
			output("Issue loading the Config Data");
		}
		
		/**
		 * @Note: This is when an Error Getting the PHP Data
		 */
		private function onQuestionDataError(evt:Event):void
		{
			output("Issue loading the Question Data");
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
			mLocalPathway = "";
			mViewContainer = new ViewContainer();
			mTranslateItems = new TranslateItems();
		}
		
		/**
		 * @Note: This is to request the Config File (as well as other Shell Cmds)
		 * @Note: This uses the GameShell_Events as a Bridge, but if run locally will load the Config File manuelly.
		 */
		 
		private function LoadConfigData():void
		{
			trace("LoadConfigData XMLPATH ",mLocalPathway); 
			mLoaderXML = new XMLLoader(mLocalPathway + "config.xml");
			mLoaderXML.addEventListener(mLoaderXML.XML_DONE,onConfigDataReady,false,0,true);
			mLoaderXML.addEventListener(mLoaderXML.XML_LOAD_ERROR,onConfigDataError,false,0,true);
			mLoaderXML.loadXML();
		}
		
		/**
		 * @Note: This loads the Question Data From PHP
		 */
		 
		private function LoadQuestionData():void
		{
			var tPHP_URL:String = mConfigXML.SERVER.questionURL.toString();
			
			mQuestionLoaderXML = new XMLLoader(tPHP_URL,"QUESTIONS");
			mQuestionLoaderXML.addEventListener(mQuestionLoaderXML.XML_DONE,onQuestionDataReady,false,0,true);
			mQuestionLoaderXML.addEventListener(mQuestionLoaderXML.XML_LOAD_ERROR,onQuestionDataError,false,0,true);
			mQuestionLoaderXML.loadXML();
		}
		
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------

		 
		/**
		 * @Note: This is here to be OVERRIDE if needed
		 */
		 
		 protected function localInit():void {}
		 
		 
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
		 
		 /**
		 * @Note: This should to be OVERRIDED. This is needed if you wish communication between the different interface elements
		 * @param	PassedObject.CMD		String		The Desired Command
		 * @param	PassedObject.PARAM		Object		The Desired Paramaters		
		 */
		 
		 protected function returnedCmdPreloader(PassedObject:Object):void {}
	}
	
}
