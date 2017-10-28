package com.neopets.games.inhouse.ExtremeHerderII
{
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
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
	 *	@author Clive Henrick / Abe Lee
	 *	@since  01.07.2009
	 */
	 
	public class ExtremeHerderIIShell extends NP9_GameDocument
	{		
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		public const SEND_THROUGH_CMD : String = "Send_A_Cmd_ToParent";
		public const INTERNAL_TESTING : Boolean = false;
		
		private var objGAME           : GameStartUp;
		private var mLocalPathway     : String;
		private var mGameShell_Events : GameShell_Events;
		private var mConfigXML        : XML;
		
		public var mcBIOS : NP9_BIOS;
		
		//===============================================================================
		// CONSTRUCTOR ExtremeHerderShell
		//===============================================================================
		public function ExtremeHerderIIShell( pLocalPathwayURL : String = null ):void
		{
			super( );
			
			trace( "ExtremeHerderIIShell instantiated" );
			
			setupVars( );	                            
			
			if ( mcBIOS.localTesting )
			{
				init( mcBIOS );
			}
		
			//testText.text = "IDS_SHELL_MESSAGE_LOAD"
			
		} // end constructor
						
		//===============================================================================
		// FUNCTION externalData
		//	- this for the Shell Application to Pass Info 
		//	  when used in the Game Shell not the FLA
		//=============================================================================== 
		public function externalData( pLocalPathwayURL : String = null, pGameShell_Events : GameShell_Events = null, pConfigXML : XML = null ):void
		{			
			mcBIOS.localPathway = ( pLocalPathwayURL != null ) ?  pLocalPathwayURL : mcBIOS.localPathway;                                                                                                                                                          
			mGameShell_Events   = ( pGameShell_Events != null ) ? pGameShell_Events : null;
			mConfigXML          = ( pConfigXML != null ) ? pConfigXML : null;
			
			init( mcBIOS );
			triggerOfflineMode( );
			
		}
				
		//===============================================================================
		// FUNCTION sendThroughEvent
		//	- Sends Message Through the Shell to anything listening
		//	@param	evt.oData.CMD		String		The Desired Command
		//	@param	evt.oData.PARAM		Object		The Desired Paramaters
		//=============================================================================== 	
		public function sendThroughEvent( evt : CustomEvent ):void
		{
			
			if ( evt.oData.CMD == objGAME.GAME_ENGINE_CLEANED )
			{
				cleanupGameEngineShell( evt );		
			}
			else
			{
				var tPassedObj:Object = evt.oData;
				this.dispatchEvent( new CustomEvent( tPassedObj, SEND_THROUGH_CMD ) );	
			}
			
		}
		
		/**
		 * @Note: that you know its time to continue Code after the NP9 System has been loaded.
		 * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		 *		>This is Triggered by the NP9_Loader_Control
		 *		>At function Main - _STARTGAME:
		 * 	@Note: If This will use local Files for loading if offline.
		**/
		 
		protected override function gameEngineUpdate( ):void
		{
			mcBIOS.localTesting = bOffline
	
			if ( bOffline )
			{
				mcBIOS.finalPathway = mcBIOS.localPathway;	
			}
			else
			{
				mcBIOS.finalPathway = _GAMINGSYSTEM.getImageServer() + mcBIOS.localPathway;	
			}
		
		
			objGAME.init( this, mcBIOS.finalPathway );
			
		}		
		
		//===============================================================================
		// FUNCTION cleanupGameEngineShell
		//	- Cleanup the DisplayList
		//	- mGameEngineDemo to Null
		//	- Dispatch the Event Saying it is Done with memeory CleanUp
		//=============================================================================== 
		private function cleanupGameEngineShell( evt : CustomEvent = null ):void
		{			
			while ( numChildren ) 
			{    
				removeChildAt( 0 );
			}	
			
			objGAME = null;
			var tPassedObj : Object = evt.oData;
			this.dispatchEvent( new CustomEvent( tPassedObj, SEND_THROUGH_CMD ) );
				
		}		
		
		//===============================================================================
		// FUNCTION setupVars
		//	- sets up vars (duh)
		//=============================================================================== 
		private function setupVars( ):void
		{
			mcBIOS = ( mcBIOS != null ) ? mcBIOS : new NP9_BIOS( );
			
			mcBIOS.debug          = false;
			mcBIOS.translation    = false;
			mcBIOS.trans_debug    = false;
			mcBIOS.dictionary     = false;
			mcBIOS.game_id        = 1117;
			mcBIOS.game_lang      = "en";
			mcBIOS.meterX         = 200;
			mcBIOS.meterY         = 400;
			mcBIOS.script_server  = "dev.neopets.com";
			mcBIOS.game_server    = "images50.neopets.com";
			mcBIOS.metervisible   = true;
			mcBIOS.localTesting   = true; // when working in flash leave this always true. it's for flex only
			mcBIOS.localPathway   = "games/g1117_ExtremeHerderII/";
			mcBIOS.game_datestamp = "05/29/09";
			mcBIOS.game_timestamp = "3:00PM";
			mcBIOS.game_infostamp = "ExtremeHerderII";
			mcBIOS.iBIOSWidth     = 650;
			mcBIOS.iBIOSHeight    = 600;
			mcBIOS.width          = mcBIOS.iBIOSWidth;
			mcBIOS.height         = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile  = true;
			
			objGAME = new GameStartUp( );
			objGAME.addEventListener( objGAME.SEND_THROUGH_CMD, sendThroughEvent, false, 0, true );		

		}
		
	} // end class
	
} // end package