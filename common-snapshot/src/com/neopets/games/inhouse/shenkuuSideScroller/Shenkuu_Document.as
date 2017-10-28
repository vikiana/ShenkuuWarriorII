﻿
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.shenkuuSideScroller
{
	import com.neopets.games.inhouse.shenkuuSideScroller.translation.G1149Text;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.gameEngine.NP9_GameDocument;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	This is for the FLA. It Is the Interface document Class and Holds the GameShell_Interface.
	 *	> For this Version of the GameShell it will have an embeded NP9_GamingSystem
	 *  > For this Version of the GameShell it will have an embeded NP9_BIOS
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Abraham Lee (with Clive Henrick's base code)
	 *	@since  01.07.2009 (reworked in 8/13/2009)
	 */
	 
	public class Shenkuu_Document extends NP9_DocumentExtension
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_ToParent";
		public const INTERNAL_TESTING:Boolean = false;
		
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		private var mGameEngine:Shenkuu_Engine;
		protected var mGameShell_Events:GameShell_Events;
		protected var mTranslationData:G1149Text;
		
		public var mcBIOS:NP9_BIOS;		//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function Shenkuu_Document():void{
			
			setupVars();                                                                                                                                                         
			
			super();
			
			init(mcBIOS);
			
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		
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
			if (evt.oData.CMD == mGameEngine.GAME_ENGINE_CLEANED)
			{
				cleanupGameEngineShell(evt);		
			}
			else
			{
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
			trace ("\nmcBIOS final path way:", mcBIOS.finalPathway)
			mGameEngine.init(this,mcBIOS.finalPathway, mTranslationData);	
			
		}
		
		/**
		 * Cleanup Memory for Quiting the Shell.
		 * 	> Cleanup the DisplayList
		 *  > mGameEngine to Null
		 * 	> Dispatch the Event Saying it is Done with memeory CleanUp
		 */
		 
		private function cleanupGameEngineShell(evt:CustomEvent = null):void
		{
			
			while (numChildren) 
			{    
				removeChildAt(0);
			}	
			
			mGameEngine = null;
			var tPassedObj:Object = evt.oData;
			this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
		}
		
		
		/**
		 * Setup Class Variables
		 */
		 
		private function setupVars():void
		{
			mGameEngine = new Shenkuu_Engine();
			mGameEngine.addEventListener(mGameEngine.SEND_THROUGH_CMD,sendThroughEvent,false,0,true);	
		
			
			mcBIOS = (mcBIOS != null) ? mcBIOS : new NP9_BIOS();
			
			//Setup BIOS
			mcBIOS.debug = false;															//Change this to True or False
			mcBIOS.translation = true; 														//Do Not Change
			mcBIOS.trans_debug =  false; 													//Do Not Change
			mcBIOS.dictionary = false;														//Do Not Change
			mcBIOS.game_id =  1149; 														//This Number will be provided by Neopets, For Demo it's 13000, GameEngineTest is 1105
			mcBIOS.game_lang = "en"; 														//Do Not Change
			mcBIOS.meterX = 180;															//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY = 200;   															//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server = "dev.neopets.com";										//Do Not Change
			mcBIOS.game_server = "images50.neopets.com"; 									//Do Not Change
			mcBIOS.metervisible = true; 													//Do Not Change
			mcBIOS.localTesting = true;														//Will always be true for local Testing for Vendors
			mcBIOS.localPathway =  "games/g"+mcBIOS.game_id+"/";		//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp =  "06/04/09";								//for testing only
			mcBIOS.game_timestamp = "11:31AM";									//for testing only
			mcBIOS.game_infostamp = "NeopetsVendorGameDemo";        			//for testing only
			mcBIOS.iBIOSWidth = 650;											//Width of the Game
			mcBIOS.iBIOSHeight = 600;											//Height of the Game
			bOffline = false;

			mTranslationData = new G1149Text();
			mcBIOS.width = mcBIOS.iBIOSWidth;
			mcBIOS.height = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile = true;										//Do Not Change unless Game uses a config.xml File
		}
		
		
	}
	
}
