
/* AS3
	Copyright 2008
*/
package com.neopets.projects.support.shell
{
	import com.neopets.projects.mvc.view.ViewContainerold;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.neopetsGameShell.support.BaseClass;
	import com.neopets.projects.np9.system.NP9_Score_Encryption;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.XMLLoader;
	import com.neopets.util.translation.TranslateItems;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.getTimer;
	
	
	/**
	 *	This is used to extend the Base Document of any game
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick (Some Code Based off Ollie B. NP9_Gaming_System)
	 *	@since  12.16.2008
	 */
	 
	public class NeopetsShellSupport extends BaseClass //implements IGameContainer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		public const INTERFACE_READY:String = "TheInterfaceIsReady";
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_UpClass";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mGameShell_Events:GameShell_Events;
		protected var mInShell:Boolean;
		protected var mConfigXML:XML;
		protected var mRootMC:MovieClip;
		protected var mViewContainer:ViewContainerold;
		protected var mID:String;
		protected var mLoaderXML:XMLLoader
		protected var mTranslateItems:TranslateItems;
		
		protected var mTimeWhenLoaded:Number;
		protected var mExtraSendScoreVars : Array;
		protected var mEncryption:NP9_Score_Encryption;
		
		private var mScoreLoader:URLLoader;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function NeopetsShellSupport(target:IEventDispatcher=null)
		{
			setupVars();
			super(target);
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
		
		public function  get viewContainer():ViewContainerold
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
		
		public function init(pShellRoot:MovieClip, pGameShell_Events:GameShell_Events = null, pConfigXML:XML = null):void
		{
			mInShell = (pGameShell_Events != null) ? true : false;
			mGameShell_Events = (pGameShell_Events != null) ? pGameShell_Events : mGameShell_Events;
			mRootMC = pShellRoot;
			mConfigXML = pConfigXML;
			
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_RETURN_SFC,onDataReturn,false,0,true);
	
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_INTERFACE,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_GAME,onDataReturn,false,0,true);
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_PRELOADER,onDataReturn,false,0,true);
			
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
			localInit();
				
		}
		
		/**
		 * @Note: Loading the Congfig Error
		 */
		 
		private function onConfigDataError(evt:Event):void
		{
			output("Issue loading the Config Data");
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			mScoreLoader.removeEventListener(Event.COMPLETE, completeHandler);
			mScoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			output( "securityErrorHandler: "+event.text);
        }
		
		/**
		*	@Note: send score data received
		*/
		
		private function completeHandler(event:Event):void {
			
			mScoreLoader.removeEventListener(Event.COMPLETE, completeHandler);
			mScoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			var sResult:String = String(event.target.data);
			
			// !!DEBUG!!
			// sResult = "eof=0&np=1,479,743&success=1&errcode=0&avatar=&plays=1&eof=1&call_url=&sk=0e34701c3a4df4e74c52&sh=f963c971ef9f4f82e5bd";
			
			var aResult:Array = sResult.split("&");
			//aScoreMeterVars = new Array();
			
			for ( var i:Number=0; i<aResult.length; i++ ) {
				var aPair:Array = aResult[i].split("=");
			//	aScoreMeterVars[aPair[0]] = aPair[1];
			}
			
			//scoreResult(); $$$$$$$$$$$$$$$$$$$$$  NEED TO HOOKUPS
			
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
			mViewContainer = new ViewContainerold();
			mTranslateItems = new TranslateItems();
			mTimeWhenLoaded = getTimer();
			mExtraSendScoreVars = [];
			mEncryption = new NP9_Score_Encryption();
			mScoreLoader = new URLLoader();
			
		}
		
		/**
		 * @Note: This is to request the Config File (as well as other Shell Cmds)
		 * @Note: This uses the GameShell_Events as a Bridge, but if run locally will load the Config File manuelly.
		 */
		 
		private function LoadConfigData():void
		{
			var pURL:String;
			
			pURL = mInShell ? "config.xml":"include/config.xml"
			mLoaderXML = new XMLLoader(pURL);
			mLoaderXML.addEventListener(mLoaderXML.XML_DONE,onConfigDataReady,false,0,true);
			mLoaderXML.addEventListener(mLoaderXML.XML_LOAD_ERROR,onConfigDataError,false,0,true);
			mLoaderXML.loadXML();
		}
		
		// -------------------------------------------------------------------------------
		// SEND THE SCORE AND SHOW SCORING METER
		// -------------------------------------------------------------------------------
		
		protected function callScoreScript( p_nVal:Number ):void 
		{
			/*
			var tBaseInfo:XMLList = mConfigXML.SETUP.SETUP_INFO;
			var tBaseURL:String = tBaseInfo.script_server;
			var tServerInfo:XMLList = mConfigXML.SERVER;
			
			mEncryption.init( tServerInfo.sHash, tServerInfo.sSK );
			
			// created to be encrypted string
			var sString:String = "s="+String(p_nVal);
			
			// checknum - probably not needed anymore!
			var cn:String = String(300*Number(tServerInfo.iGameID));

			var sURL:String = "?cn="+cn+"&gd="+String(getTimer()- mTimeWhenLoaded); // create url plus checknum & time played
			sURL += "&r="+String( (Math.random()*1000000) ); // prevent caching
			
			// encrypt data
			var sRaw:String = "ssnhsh="+tServerInfo.sHash+"&ssnky="+tServerInfo.sSK+"&gmd="+tServerInfo.iGameID+"&scr="+String(p_nVal)+"&frmrt="+tServerInfo.iAvgFramerate+"&chllng="+tServerInfo.iChallenge+"&gmdrtn="+String(getTimer()- mTimeWhenLoaded);
			
			// added 7/14/08 -- moved the extra vars over to encryption
			var tCount:uint = mExtraSendScoreVars.length;
			
			for( var i : uint = 0; i < tCount; i ++ ){
				var a : Array = mExtraSendScoreVars[ i ];
				sRaw += "&" + String( a[0] ) + "=" + String( a[1] );
			}
			
			var sEncryptedData:String = mEncryption.encrypt( sRaw );
			var sessionID:String = String(tServerInfo.sHash)+String(tServerInfo.sSK);
			sURL += "&gmd_g="+tServerInfo.iGameID+"&mltpl_g="+tServerInfo.iMultiple+"&gmdt_g="+sEncryptedData+"&sh_g="+tServerInfo.sHash+"&sk_g="+tServerInfo.sSK+"&usrnm_g="+tServerInfo.sUsername+"&dc_g="+tServerInfo.iDailyChallenge+"&cmgd_g="+mEncryption.iVID;
			
			
			// call scoring script
			var request:URLRequest = new URLRequest();
			var tBaseURL:String = "http://" + tServerInfo.sBaseURL + String.fromCharCode(47);
			var sSlash:String = String.fromCharCode(47);
			var sScoreURL = "high_scores" + sSlash + "process_flash_score.phtml";
			
			request.url = tBaseURL + sScoreURL + sURL;
			request.method = URLRequestMethod.POST;
			mScoreLoader.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			mScoreLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			mScoreLoader.load( request );
			

			// update user's highscore
			if ( p_nVal > tServerInfo.iHiscore ) tServerInfo.iHiscore = p_nVal;
			
			var cStr:String = "";
			*/
			/*
			// show scoring meter?
			if ( objGameData.bMeterVisible ) {
				showScoringMeter( true );
				objScoringMeter.scoreSent( nShowScore, nShowNP );
				addEventListener(TextEvent.LINK, TextLinkHandler, false, 0, true);
			}
			*/
		}

		
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS (FOR OVERRIDE in Children)
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
