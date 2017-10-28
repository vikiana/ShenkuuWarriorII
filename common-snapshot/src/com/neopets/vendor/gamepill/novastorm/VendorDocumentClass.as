package com.neopets.vendor.gamepill.novastorm
{
	
	import com.neopets.games.inhouse.shenkuuSideScroller.translation.G1149Text;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.gameEngine.NP9_GameDocument;
	import com.neopets.projects.np9.system.NP9_BIOS;

	//import com.neopets.projects.np9.system.NP9_BIOS;
	//import com.neopets.projects.np9.vendorInterface.NP9_VendorExtension;
	//import com.neopets.projects.np9.vendorInterface.NP9_VendorGameSystem;
	//import com.neopets.util.events.CustomEvent;




	/**
	   *  VendorDocumentClass for novaStormGame FLA
	   *  > For this Version of the GameShell it will have an embeded NP9_GamingSystem
	   *  > For this Version of the GameShell it will have an embeded NP9_BIOS
	   * 
	   *  @langversion ActionScript 3.0
	   *  @playerversion Flash 9.0
	   *  @Pattern GameEngine
	   * 
	   *  @author Christopher Emirzian
	   *  @since  11.11.2009
	   */

	public class VendorDocumentClass extends NP9_DocumentExtension {
		private var mNovaStormGame:novaStormGame;
		public var mcBIOS:NP9_BIOS;// on Stage
		protected var mTranslationData:TranslationInfo;

		// constructor

		public function VendorDocumentClass() {
			setupVars();

			super();

			if (mcBIOS.localTesting) {
				init(mcBIOS);
			}
		}

		/**
		     * @Note: that you know its time to continue Code after the NP9 System has been loaded.
		     * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		     *    >This is Triggered by the NP9_Loader_Control
		     *    >At function Main - _STARTGAME:
		    **/

		protected override function gameEngineUpdate():void {
			mcBIOS.localTesting=bOffline;

			if (bOffline) {
				mcBIOS.finalPathway=mcBIOS.localPathway;
			} else {
				mcBIOS.finalPathway=neopets_GS.getImageServer()+mcBIOS.localPathway;
			}

			mNovaStormGame.init(this,mcBIOS.finalPathway, mTranslationData);
		}

		/**
		     * Setup Class Variables for the Neopets Gaming System.
		     */

		private function setupVars():void {
			mNovaStormGame = new novaStormGame();

			mcBIOS=(mcBIOS!=null) ? mcBIOS : new NP9_BIOS();

			//Setup BIOS

			mcBIOS.debug=false;//Change this to True or False
			mcBIOS.translation=true;//Do Not Changegg
			mcBIOS.trans_debug=false;//Do Not Change
			mcBIOS.dictionary=false;//Do Not Change
			mcBIOS.game_id=1188;//This Number will be provided by Neopets, For Demo its 13000
			mcBIOS.game_lang="en";//Do Not Change
			mcBIOS.meterX=200;//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY=200;//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server="www.neopets.com";//Do Not Change
			mcBIOS.game_server="images50.neopets.com";//Do Not Change
			mcBIOS.metervisible=true;//Do Not Change
			mcBIOS.localTesting=true;//Will always be true for local Testing for Vendors
			mcBIOS.localPathway="games/g"+mcBIOS.game_id+"/";//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp="06/04/09";//for testing only
			mcBIOS.game_timestamp="11:31AM";//for testing only
			mcBIOS.game_infostamp="NeopetsVendorGameDemo";//for testing only
			mcBIOS.iBIOSWidth=650;// Width of the Game
			mcBIOS.iBIOSHeight=600;// Height of the Game
			mcBIOS.width=mcBIOS.iBIOSWidth;
			mcBIOS.height=mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile=false;// Game doesn't use a config.xml File
			bOffline=true;
			
			mTranslationData = new TranslationInfo ();
		}
	}
}