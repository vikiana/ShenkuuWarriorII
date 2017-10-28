package com.neopets.games.inhouse.FreakyFactoryAS3
{
	//=============================================
	//	CUSTOM IMPORTS
	//=============================================
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.CustomEvent;
	

	
	//=============================================
	//	NATIVE IMPORTS
	//=============================================
	
	public class FreakyFactoryAS3_DocumentClass extends NP9_DocumentExtension
	{
		//=============================================
		//	CLASS CONSTANTS
		//=============================================
		public const SEND_THROUGH_CMD : String = "sendACmdToParent";
		
		//=============================================
		//	VARIABLES
		//=============================================		
		private var mFreakyFactoryAS3_Engine : FreakyFactoryAS3_Engine;
		protected var mTranslationData       : FreakyFactoryAS3_TranslationData;
		
		/**
		 * @Note: the mcBIOS is located in the library of the root fla
		 * 		  in older games it was located on the stage
		 */
		public var mcBIOS : NP9_BIOS;
		
		//=============================================
		//	CONSTRUCTOR
		//=============================================		
		public function FreakyFactoryAS3_DocumentClass( ):void
		{	
			/**
			 * initiate NP9_DocumentExtension
			 */
			super( );
			
			trace( "FreakyFactoryAS3_DocumentClass says: FreakyFactoryAS3_DocumentClass constructed" );
			
			setupVars( );  
			
			if (mcBIOS.localTesting)
			{
				init(mcBIOS);
			}
			
		}
		
		
		/**
		 * This needs to be override bcouse the document class is instantated instead 
		 */
		override public function init( p_mBIOS:NP9_BIOS = null ):void 
		{			
			mBIOS = p_mBIOS;
			
	
			/*if ( this.parent != null )
			{
				if( this.parent.toString( ).toUpperCase( ).indexOf( "STAGE", 0 ) >= 0 ) 
				{
					
				}	
			}*/
			
			if (mcBIOS.localTesting)
			{
				triggerOfflineMode();
			}
			
			// trace out the Time Stamp for the Project in a Message for Testing
			trace(	mBIOS.game_infostamp + " " + mBIOS.game_datestamp + " " + mBIOS.game_timestamp );
			
			// turn off the Visibility of the mBIOS just in case
			mBIOS.visible = false;
			
			// keep track of scoring meter index
			mGamingSystemIndex = 0;
			
		}
		
		//=============================================
		//  PUBLIC METHODS
		//=============================================	
		
		//=============================================
		//  EVENT HANDLERS
		//=============================================
		
		/**
		 * @Note: sends message through the shell to anything listening
		 * @param	evt.oData.CMD		String		The Desired Command
		 * @param	evt.oData.PARAM		Object		The Desired Paramaters
		 */		 	
		public function sendThroughEvent( evt : CustomEvent ):void
		{
			if ( evt.oData.CMD == mFreakyFactoryAS3_Engine.GAME_ENGINE_CLEANED )
			{
				cleanupGameEngineShell( evt );		
			}
				
			else
			{
				var tPassedObj : Object = evt.oData;
				this.dispatchEvent( new CustomEvent( tPassedObj, SEND_THROUGH_CMD ) );	
			}
		}
		
		/**
		 * @Note: cleans memory for quiting the shell
		 * 		  - removes childrem from display list
		 *  	  - sets engine of game to null
		 * 		  - dispatches Event saying it is done with memeory cleanup
		 */		 
		private function cleanupGameEngineShell( evt : CustomEvent = null ):void
		{			
			while( numChildren ) 
			{    
				removeChildAt( 0 );
			}	
			
			mFreakyFactoryAS3_Engine = null;
			var tPassedObj : Object = evt.oData;
			this.dispatchEvent( new CustomEvent( tPassedObj, SEND_THROUGH_CMD ) );	
		}
		
		//=============================================
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//=============================================
		
		/**
		 * @Note: that you know its time to continue code after the NP9 System has been loaded
		 * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		 *		  >This is Triggered by the NP9_Loader_Control
		 *		  >At function Main - _STARTGAME:
		 * @Note: If This will use local Files for loading if offline.
		 */		
		protected override function gameEngineUpdate( ):void
		{		
			trace( "FreakyFactoryAS3_DocumentClass says: gameEngineUpdate called" );
			
			mcBIOS.localTesting = bOffline;
			
			if ( bOffline )
			{
				mcBIOS.finalPathway = mcBIOS.localPathway;	
			}
				
			else
			{
				mcBIOS.finalPathway = _GAMINGSYSTEM.getImageServer( ) + mcBIOS.localPathway;	
			}	
			
			/**
			 * @Note: init is located in GameEngineSupport class extended by mFreakyFactoryAS3_Engine
			 */
			mFreakyFactoryAS3_Engine.init( this, mcBIOS.finalPathway, mTranslationData );	
			
		}
		
		/**
		 * @Note: setup class variables
		 */
		private function setupVars( ):void
		{
			trace( "FreakyFactoryAS3_DocumentClass says: setupVars called" );
			
			mFreakyFactoryAS3_Engine = new FreakyFactoryAS3_Engine( );
			mFreakyFactoryAS3_Engine.addEventListener( mFreakyFactoryAS3_Engine.SEND_THROUGH_CMD, sendThroughEvent, false, 0, true );
			
			mcBIOS = ( mcBIOS != null ) ? mcBIOS : new NP9_BIOS( );
			
			mcBIOS.debug          = false;								// Change this to True or False
			mcBIOS.translation    = true; 								// Do Not Change
			mcBIOS.trans_debug    = false;	 							// Do Not Change
			mcBIOS.dictionary     = false;								// Do Not Change
			mcBIOS.game_id        = 1198; 								// This Number will be provided by Neopets, For Demo it's 13000, GameEngineTest is 1105
			mcBIOS.game_lang      = "en"; 								// Do Not Change
			mcBIOS.meterX         = 100;								// This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY         = 200;   								// This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server  = "dev.neopets.com";					// Do Not Change
			mcBIOS.game_server    = "images50.neopets.com"; 			// Do Not Change
			mcBIOS.metervisible   = true; 								// Do Not Change
			mcBIOS.localTesting   = true;								// Will always be true for local Testing for Vendors
			mcBIOS.localPathway   = "games/g"+mcBIOS.game_id+"/";		// All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp = "development started: 12/02/09";	// for testing only
			mcBIOS.game_timestamp = "6:00PM";							// for testing only
			mcBIOS.game_infostamp = "FreakyFactoryAS3";        	        // for testing only
			mcBIOS.iBIOSWidth     = 650;								// Width of the Game
			mcBIOS.iBIOSHeight    = 600;								// Height of the Game
			bOffline              = true;
			
			mTranslationData      = new FreakyFactoryAS3_TranslationData( );
			mcBIOS.width          = mcBIOS.iBIOSWidth;
			mcBIOS.height         = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile  = true;							    // do not change unless game doesn't use a config.xml file
				
		}
		
	}	
}