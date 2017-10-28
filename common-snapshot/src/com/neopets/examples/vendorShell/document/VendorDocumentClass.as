
/* AS3
	Copyright 2008
*/

package com.neopets.examples.vendorShell.document
{

	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.projects.np9.vendorInterface.NP9_VendorExtension;
	import com.neopets.projects.np9.vendorInterface.NP9_VendorGameSystem;
	import com.neopets.util.events.CustomEvent;
	//import com.neopets.util.assetloader.NPAssetVendorInterface; // added by PC - For resource loading
	
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
	 *	@since  01.07.2009
	 */
	 
	public class VendorDocumentClass extends NP9_VendorExtension
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mVendorDemoGame:VendorExampleGame_Extended;				/* THIS IS FOR TESTING WITH EXTENDED MENUS */
		//private var mVendorDemoGame:VendorExampleGame;
			
		public var mcBIOS:NP9_BIOS;		//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function VendorDocumentClass()
		{
			setupVars();                                                                                                                                                  
			
			super();
			
			if (mcBIOS.localTesting)
			{
				init(mcBIOS);
			}
			
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
				mcBIOS.finalPathway = neopets_GS.getImageServer() + mcBIOS.localPathway;	
			}	
			
			//var mNPAssetVendorInterface:NPAssetVendorInterface = new NPAssetVendorInterface(this); // added for resource loading
			mVendorDemoGame.init(this);

		}
		
	
		/**
		 * Setup Class Variables for the Neopets Gaming System. You Must Have this.
		 */
		 
		private function setupVars():void
		{
			//mVendorDemoGame = new VendorExampleGame();
			
			mVendorDemoGame = new VendorExampleGame_Extended();			/* THIS IS FOR TESTING WITH EXTENDED MENUS */
			
			
			mcBIOS = (mcBIOS != null) ? mcBIOS : new NP9_BIOS();
			
			//Setup BIOS
			mcBIOS.debug = false;									//Change this to True or False
			mcBIOS.translation = true; 								//Do Not Change
			mcBIOS.trans_debug =  false; 							//Do Not Change
			mcBIOS.dictionary = false;								//Do Not Change
			mcBIOS.game_id =  13000; 								//This Number will be provided by Neopets, For Demo its 13000
			mcBIOS.game_lang = "en"; 								//Do Not Change
			mcBIOS.meterX = 200;									//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY = 200;   									//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server = "dev.neopets.com";				//Do Not Change
			mcBIOS.game_server = "images50.neopets.com"; 			//Do Not Change
			mcBIOS.metervisible = true; 							//Do Not Change
			mcBIOS.localTesting = true;								//Will always be true for local Testing for Vendors
			mcBIOS.localPathway =  "games/g"+mcBIOS.game_id+"/";	//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp =  "06/04/09";					//for testing only
			mcBIOS.game_timestamp = "11:31AM";						//for testing only
			mcBIOS.game_infostamp = "NeopetsVendorGameDemo";        //for testing only
			mcBIOS.iBIOSWidth = 650;								//Width of the Game
			mcBIOS.iBIOSHeight = 600;								//Height of the Game
			mcBIOS.width = mcBIOS.iBIOSWidth;
			mcBIOS.height = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile = false;							//Do Not Change unless Game doesn't use a config.xml File
			mcBIOS.configFileVersion = 0;							// Change this value if you wish to change the version of your config.xml.  0 - config.xml; 1.. - config_vX.xml
			bOffline = true;
		}
		
		
	}
	
}
