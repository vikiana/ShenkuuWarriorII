
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.adaptions.FrootLoops.TreasureHunt
{
	//import com.neopets.examples.gameEngineExample.translation.TranslationTreasureHuntEngine;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.gameEngine.NP9_GameDocument;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.Responder;
	
	/**
	 *	This is for the FLA. It Is the Interface document Class and Holds the GameShell_Interface.
	 *	> For this Version of the GameShell it will have an embeded NP9_GamingSystem
	 *  > For this Version of the GameShell it will have an embeded NP9_BIOS
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  01.07.2009 (re worked in 8/13/2009)
	 */
	 
	dynamic public class TreasureHunt_Document extends NP9_DocumentExtension
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_ToParent";
		public const INTERNAL_TESTING:Boolean = false;
		
		public static const RESTART_CLICKED:String = "TheRestartBtnClicked"; // copied from gaming system
		public static const AVAILABILITY_CALL:String = "FrootLoops2010Service.bonusItemAvailable";
		public static const CLAIM_PRIZE_CALL:String = "FrootLoops2010Service.giveBonusItem";
		public static const PRIZE_STATUS_CHANGED:String = "prize_status_changed";
		public static const PRIZE_CLAIMED:String = "prize_claimed";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		private var mTreasureHuntEngine:TreasureHuntEngine;
		protected var mGameShell_Events:GameShell_Events;
		protected var mTranslationData:TranslationTreasureHuntEngine;
		
		public var mcBIOS:NP9_BIOS;		//On Stage
		
		public var adaptedGame:MovieClip;
		protected var _prizeAvailable:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TreasureHunt_Document():void{
			
			setupVars();                                                                                                                                                         
			
			super();
			
			// initialize prize variables
			var amf:NeopetsConnectionManager = NeopetsConnectionManager.instance;
			amf.connect(this);
			var responder:Responder = new Responder(onAvailabilityResult,onAvailabilityFault);
			amf.callRemoteMethod(AVAILABILITY_CALL,responder);
			
			init(mcBIOS);
			
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get prizeAvailable():Boolean { return _prizeAvailable; }
		
		public function set prizeAvailable(bool:Boolean) {
			if(_prizeAvailable != bool) {
				_prizeAvailable = bool;
				var transmission:Event = new Event(PRIZE_STATUS_CHANGED);
				dispatchEvent(transmission);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function claimPrize():void {
			var responder:Responder = new Responder(onClaimPrizeResult,onClaimPrizeFault);
			NeopetsConnectionManager.instance.callRemoteMethod(CLAIM_PRIZE_CALL,responder);
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
			if (evt.oData.CMD == mTreasureHuntEngine.GAME_ENGINE_CLEANED)
			{
				cleanupGameEngineShell(evt);		
			}
			else
			{
				var tPassedObj:Object = evt.oData;
				this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
			}
		}
		
		// Amf Functions
		
		protected function onAvailabilityResult(result:Object) {
			prizeAvailable = Boolean(result);
			trace("prize availability set to " + _prizeAvailable + " by amf call");
		}
		
		protected function onAvailabilityFault(result:Object) { trace(AVAILABILITY_CALL + " fault"); }
		
		protected function onClaimPrizeResult(result:Object) {
			if(result) {
				var transmission:Event = new Event(PRIZE_CLAIMED);
				dispatchEvent(transmission);
				prizeAvailable = false;
			}
		}
		
		protected function onClaimPrizeFault(result:Object) { trace(CLAIM_PRIZE_CALL + " fault"); }
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: that you know its time to continue Code after the NP9 System has been loaded.
		 * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		 *		>This is Triggered by the NP9_Loader_Control
		 *		>At function Main - _STARTGAME:
		 * 	@Note: If This will use local Files for loading if offline.
		**/
		 
		protected override function gameEngineUpdate():void
		{
		
			mcBIOS.localTesting = bOffline;
			
			if (bOffline)
			{
				mcBIOS.finalPathway = mcBIOS.localPathway;	
			}
			else
			{
				mcBIOS.finalPathway = _GAMINGSYSTEM.getImageServer() + mcBIOS.localPathway;	
			}	
			
			mTreasureHuntEngine.init(this,mcBIOS.finalPathway, mTranslationData);
			
			mGamingSystem.addEventListener(mGamingSystem.RESTART_CLICKED,restartBtnPressed);
			
		}
		
		/**
		 * Cleanup Memory for Quiting the Shell.
		 * 	> Cleanup the DisplayList
		 *  > mTreasureHuntEngine to Null
		 * 	> Dispatch the Event Saying it is Done with memeory CleanUp
		 */
		 
		private function cleanupGameEngineShell(evt:CustomEvent = null):void
		{
			
			while (numChildren) 
			{    
				removeChildAt(0);
			}	
			
			mTreasureHuntEngine = null;
			var tPassedObj:Object = evt.oData;
			this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
		}
		
		// The function lets listeners know when the restart button has been pressed in the scoring meter.
		
		public function restartBtnPressed(ev:Event) {
			var transmission:Event = new Event(mGamingSystem.RESTART_CLICKED);
			dispatchEvent(transmission);
		}
		
		// This function gives our contents easy access to the scoring meter.
		
		public function sendScore(val:Number=-1):void {
			if(val < 0) val = ScoreManager.instance.getValue();
			mGamingSystem.sendScore(val); 	
			sendScoringMeterToFront( );
		}
		
		// This function send tags out through the gaming system.
		
		public function sendTag(tag:String):void {
			mGamingSystem.sendTag(tag); 	
		}
		
		/**
		 * Setup Class Variables
		 */
		 
		private function setupVars():void
		{
			mTreasureHuntEngine = new TreasureHuntEngine();
			mTreasureHuntEngine.addEventListener(mTreasureHuntEngine.SEND_THROUGH_CMD,sendThroughEvent,false,0,true);	
		
			
			mcBIOS = (mcBIOS != null) ? mcBIOS : new NP9_BIOS();
			
			//Setup BIOS
			mcBIOS.debug = false;															//Change this to True or False
			mcBIOS.translation = true; 														//Do Not Change
			mcBIOS.trans_debug =  false; 													//Do Not Change
			mcBIOS.dictionary = false;														//Do Not Change
			mcBIOS.game_id =  1262; 														//This Number will be provided by Neopets, For Demo it's 13000, GameEngineTest is 1105
			mcBIOS.game_lang = "en"; 														//Do Not Change
			mcBIOS.meterX = 185;															//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY = 0;   															//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server = "dev.neopets.com";										//Do Not Change
			mcBIOS.game_server = "images50.neopets.com"; 									//Do Not Change
			mcBIOS.metervisible = true; 													//Do Not Change
			mcBIOS.localTesting = true;														//Will always be true for local Testing for Vendors
			mcBIOS.localPathway =  "games/g"+mcBIOS.game_id+"/";		//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp =  "06/04/09";								//for testing only
			mcBIOS.game_timestamp = "11:31AM";									//for testing only
			mcBIOS.game_infostamp = "TreasureHunt";        			//for testing only
			mcBIOS.iBIOSWidth = 650;											//Width of the Game
			mcBIOS.iBIOSHeight = 240;											//Height of the Game
			bOffline = true;

			mTranslationData = new TranslationTreasureHuntEngine();
			mcBIOS.width = mcBIOS.iBIOSWidth;
			mcBIOS.height = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile = true;										//Do Not Change unless Game uses a config.xml File
		}
		
	}
	
}
