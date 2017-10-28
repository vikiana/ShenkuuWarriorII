
/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo {
	
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.gameEngine.NP9_GameDocument;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;
	import com.neopets.games.inhouse.advervideo.pc.PCGameEngine;
	
	/**
	 *	This is for the FLA. It Is the Interface document Class and Holds the GameShell_Interface, 
	 * based on com.neopets.examples.gameEngineExample.GameEngineDemo_Document by Clive Henrick
	 *	> For this Version of the GameShell it will have an embeded NP9_GamingSystem
	 *  > For this Version of the GameShell it will have an embeded NP9_BIOS
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Koh Peng Chuan
	 *	@since  08.24.2009
	 */
	 
	public class GameDocument extends NP9_DocumentExtension {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const GAME_ID:int = 1270;
		private const GAME_LANG:String = "en";
		private const GAME_SCORE_METERX:int = 180;
		private const GAME_SCORE_METERY:int = 180; // watch where you place your black sendscore panel. Clicking on the "restart game" link will cause a click thru to a "Start game" button if it is right below the panel!
		private const GAME_DATESTAMP:String = "07/02/2010";
		private const GAME_TIMESTAMP:String = "1000hrs";
		public const GAME_INFOSTAMP:String = "g" + GAME_ID.toString();
		private const GAME_BIOS_WIDTH:int = 750;
		private const GAME_BIOS_HEIGHT:int = 550;
		private const GAME_USECONFIGFILE:Boolean = false;
		private const GAME_OFFLINE:Boolean = true;
		
		private const GAME_SCRIPTSERVER:String = "www.neopets.com";
		private const GAME_GAMESERVER:String = "images.neopets.com";
		
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_ToParent";
		public const INTERNAL_TESTING:Boolean = false;
		
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		private var mGame:PCGameEngine;
		protected var mGameShell_Events:GameShell_Events;
		protected var mTranslationData:NPTextData;
		
		public var mcBIOS:NP9_BIOS;		//On Stage
		
		public static var _instance:GameDocument;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameDocument():void{			
			setupVars();
			super();
			init(mcBIOS);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public static function get instance():GameDocument {
			return _instance;
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
		 	
		public function sendThroughEvent(evt:CustomEvent):void {
			if (evt.oData.CMD == mGame.GAME_ENGINE_CLEANED) {
				cleanupGameEngineShell(evt);		
			} else {
				var tPassedObj:Object = evt.oData;
				this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
			}
		}
		
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
		 
		protected override function gameEngineUpdate():void {
			mcBIOS.localTesting = bOffline;
			if (bOffline) {
				mcBIOS.finalPathway = mcBIOS.localPathway;	
			} else {
				mcBIOS.finalPathway = _GAMINGSYSTEM.getImageServer() + mcBIOS.localPathway;	
			}	
			mGame.init(this,mcBIOS.finalPathway, mTranslationData);	
		}
		
		/**
		 * Cleanup Memory for Quiting the Shell.
		 * 	> Cleanup the DisplayList
		 *  > mGameEngineDemo to Null
		 * 	> Dispatch the Event Saying it is Done with memeory CleanUp
		 */
		 
		private function cleanupGameEngineShell(evt:CustomEvent = null):void 	{
			while (numChildren) removeChildAt(0);
			mGame.removeEventListener(mGame.SEND_THROUGH_CMD,sendThroughEvent);	
			mGame = null;
			var tPassedObj:Object = evt.oData;
			this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
		}
		
		
		/**
		 * Setup Class Variables
		 */
		 
		private function setupVars():void {
			_instance = this;
			mGame = new PCGameEngine();
			mGame.addEventListener(mGame.SEND_THROUGH_CMD,sendThroughEvent, false, 0, true);	
		
			mcBIOS = (mcBIOS != null)? mcBIOS : new NP9_BIOS();
			
			//Setup BIOS
			mcBIOS.debug = false;														//Change this to True or False
			mcBIOS.translation = true; 													//Do Not Change
			mcBIOS.trans_debug =  false; 												//Do Not Change
			mcBIOS.dictionary = false;													//Do Not Change
			mcBIOS.game_id =  GAME_ID; 												//This Number will be provided by Neopets, For Demo it's 13000, GameEngineTest is 1105
			mcBIOS.game_lang = GAME_LANG; 										//Do Not Change
			mcBIOS.meterX = GAME_SCORE_METERX;								//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY = GAME_SCORE_METERY;   							//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server = GAME_SCRIPTSERVER;						//Do Not Change
			mcBIOS.game_server = GAME_GAMESERVER; 							//Do Not Change
			mcBIOS.metervisible = true; 												//Do Not Change
			mcBIOS.localTesting = false;												//Will always be true for local Testing for Vendors
			mcBIOS.localPathway =  "games/g"+mcBIOS.game_id+"/";		//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp =  GAME_DATESTAMP;					//for testing only
			mcBIOS.game_timestamp = GAME_TIMESTAMP;						//for testing only
			mcBIOS.game_infostamp = GAME_INFOSTAMP;        				//for testing only
			mcBIOS.iBIOSWidth = GAME_BIOS_WIDTH;							//Width of the Game
			mcBIOS.iBIOSHeight = GAME_BIOS_HEIGHT;							//Height of the Game
			bOffline = GAME_OFFLINE;

			mTranslationData = new NPTextData();
			mcBIOS.width = mcBIOS.iBIOSWidth;
			mcBIOS.height = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile = GAME_USECONFIGFILE;						//Do Not Change unless Game uses a config.xml File
			mcBIOS.configFileVersion = 0;
			
			trace("[GameDocument] setupVars done");
		}
		
		
	}
	
}
