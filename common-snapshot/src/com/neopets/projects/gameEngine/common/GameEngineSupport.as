package com.neopets.projects.gameEngine.common
{
	/**
	 *	this is used to extend the base document of GameEngine
	 * 
	 * 	this will handle the following code:
	 * 		1) Communications between the NP9 Game System and GameEngine
	 * 		2) Loading the External Assets from the Config.xml
	 * 		3) Create Objects from the External Assets
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick (Some Code Based off Ollie B. NP9_Gaming_System)
	 *	@since 11.17.2009 -  Updates form Embeded Files
	 * 
 	 * @updated 11.10.2010 - PC: added code for resource and config file versioning
	 */
	
	//=============================================
	//	CUSTOM IMPORTS
	//=============================================
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.neopetsGameShell.support.BaseClass;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.loading.LoadingEngineXML;
	import com.neopets.util.loading.XMLLoader;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	//=============================================
	//	NATIVE IMPORTS
	//=============================================
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	/**
	 * not yet reached in program flow
	 */
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.util.translation.TranslationList;
	
	public class GameEngineSupport extends BaseClass //implements IGameContainer
	{		
		//=============================================
		//	CLASS CONSTANTS
		//=============================================
		public const SEND_THROUGH_CMD    : String = "sendACmdToParent";
		public const SETUP_LOADING_SIGN  : String = "setupLoadingSign";
		public const REMOVE_LOADING_SIGN : String = "removeLoadingSign";
		public const LOADINGENGINE_ID    : String = "gameEngineLoadingEngine";
		
		/**
		 * @Note: this constant may not be needed
		 *        it is not used in this class or any of the child classes
		 * @Note: commenting it out to see if everything works without it
		 */
		//public const GAME_ENGINE_READY:String = "theGameEngineIsReady";
		
		//=============================================
		//  PRIVATE & PROTECTED VARIABLES
		//=============================================
		protected var mLocalPathway       : String;		
		protected var mGameShell_Events   : GameShell_Events;
		protected var mExternalLoader     : LoadingEngineXML;		
		protected var mViewContainer      : ViewContainer;
		protected var mTranslationData    : TranslationData;
		protected var mTranslationManager : TranslationManager;
		protected var mApplicationDomain  : ApplicationDomain;
		protected var mVersion            : Number;
		protected var mID                 : String;
		protected var mGamingSystem       : MovieClip; // this is the loaded NP9_Gaming_System
		protected var mRootMC             : MovieClip;
		protected var mConfigXML          : XML;
		protected var mLoaderXML          : XMLLoader
		
		/**
		 * @Note: these vars may not be needed
		 *        they are not instantiated in this class or any of the child classes
		 * @Note: commenting them out to see if everything works without them
		 */
		//protected var mTimeWhenLoaded     : Number;
		//protected var mExtraSendScoreVars : Array;
		
		//=============================================
		//  GETTERS/SETTERS
		//=============================================
		public function get gameShell_Events( ):GameShell_Events { return mGameShell_Events }
		
		public function get configXML( ):XML { return mConfigXML }
		
		public function get viewContainer( ):ViewContainer { return mViewContainer }
		
		public function get ID( ):String { return mID }
		public function set ID( pID : String ):void { mID = pID }
		
		public function get translateManager( ):TranslationManager { return mTranslationManager }
		
		public function get loadingEngine( ):LoadingEngineXML { return mExternalLoader }
				
		public function get gameEngineVersion( ):Number { return mVersion }
		
		public function get gamingSystem( ):MovieClip {	return mGamingSystem }
		
		public function get shell( ):MovieClip { return mRootMC	}
		
		//=============================================
		//  CONSTRUCTOR
		//=============================================		
		public function GameEngineSupport( target : IEventDispatcher = null )
		{
			super( target );
			
			trace( "GameEngineSupport says: GameEngineSupport constructed" );
			
			setupVars( );
		}
		
		//=============================================
		//  PUBLIC METHODS
		//=============================================	
		
		/**
		 * @Note: called from document class of your game
		 */
		public function init( pShellRoot : MovieClip, pLocalPathway : String, pTranslationData : TranslationData = null ):void
		{			
			//mGameShell_Events = (pGameShell_Events != null) ? pGameShell_Events : mGameShell_Events;
			
			mRootMC          = pShellRoot;
			mLocalPathway    = pLocalPathway;
			mTranslationData = pTranslationData;			
			
			mGamingSystem = mRootMC.getGamingSystem( );
			
			trace( "GameEngineSupport says: mTranslationData = " + mTranslationData );
			
			/**
			 * @Note: determine if there is a TranslationData document
			 * @Note: some games (i.e. older games and (typically) marketing games) don't have TranslationData documents
			 *        since the text is either hardcoded within the fla or graphical or handled in some other way that 
			 *        does not involve the translation system
			 */
			if ( mTranslationData != null )
			{
				setupTranslation( mTranslationData );	
			}
			
			else
			{
				continueSetup( );	
			}
			
		}
		
		//=============================================
		//  EVENT HANDLERS
		//=============================================
		
		/** 
		 * @Note: called when TranslationManager has connected to php backend and translation data is loaded
		 * @Note: if you have translated ingame text, it should be accessible now
		 */		
		private function translationComplete( evt : Event ):void
		{
			//var tTranslationManager : TranslationManager = TranslationManager.instance;
			//mTranslationData = TranslationData( tTranslationManager.translationData );
			
			/**
			 * @Note: edited by Hauke - 01/12/2010
			 * @Note: changed to use instance variable mTranslationManager instead of temporary variable tTranslationManager
			 */
			mTranslationData = TranslationData( mTranslationManager.translationData );
			
			continueSetup( );
		}
		
		/**
		 * @Note: called from LoadConfigData when data loaded
		 * @param	evt.oData.XML			XML			The Config File (useally)
		 * @param	evt.oData.ID			String		The Id of the Request
		 */		
		private function onConfigDataReady( evt : CustomEvent ):void
		{
			//trace( "GameEngineSupport says: onConfigDataReady called" );
			mConfigXML = evt.oData.XML;
			traceReporting = GeneralFunctions.convertBoolean( mConfigXML.SETUP.SETUP_INFO.traceElements.toString( ) );
			checkForExternalAssets( );	
		}
		
		/**
		 * @Note: called from LoadConfigData when there is an error loading the data
		 */		
		private function onConfigDataError( evt : Event ):void
		{
			output( "Issue loading the Config Data" );
		}
		
		/** 
		 * @Note: called from checkForExternalAssets to update the loading process of external assets
		 */		
		private function onLoadingProgress( evt : CustomEvent ):void
		{
			//trace( "GameEngineSupport says: onLoadingProgress called" );
			//mRootMC.dispatchEvent(new CustomEvent ({TOTAL_ITEMS:e.oData.TOTAL_ITEMS, TOTAL_LOADED:e.oData.TOTAL_LOADED, BYTES_LOADED:e.oData.BYTES_LOADED, BYTES_TOTAL:e.oData.BYTES_TOTAL}, mRootMC.LOADING_PROGRESS))
			mRootMC.dispatchEvent( new CustomEvent( { DATA : evt.oData }, mRootMC.LOADING_PROGRESS ) );
		}
		
		/**
		 * @Note: called from checkForExternalAssets when mExternalLoader has finished loading external files
		 */		
		private function onExternalFilesLoaded( evt : Event ):void
		{
			mRootMC.dispatchEvent( new Event( REMOVE_LOADING_SIGN ) );
			localInit( );
		}
		
		//=============================================
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//=============================================
		
		/**
		 * @NOTE: this is the translation setup 
		 *        this is usually called later in the game startup cycle.
		 */		
		private function setupTranslation( pTranslationInfo : TranslationData ):void
		{
			trace( "GameEngineSupport says: setupTranslation URL from GameSystem: " + mGamingSystem.getScriptServer( ) );
			
			//var tManager : TranslationManager = TranslationManager.instance;
			//tManager.addEventListener( Event.COMPLETE, translationComplete, false, 0, true );
			//tManager.init( mGamingSystem.getFlashParam( "sLang" ).toUpperCase( ), mRootMC.mcBIOS.game_id, 4, pTranslationInfo, mGamingSystem.getScriptServer( ) );
			
			/**
			 * @Note: edited by Hauke - 01/12/2010
			 * @Note: changed to use instance variable mTranslationManager instead of temporary variable tManager
			 */
			mTranslationManager.addEventListener( Event.COMPLETE, translationComplete, false, 0, true );
			mTranslationManager.init( mGamingSystem.getFlashParam( "sLang" ).toUpperCase( ), mRootMC.mcBIOS.game_id, 4, pTranslationInfo, mGamingSystem.getScriptServer( ) );
			trace ("lang", mTranslationManager.languageCode);
		}
		
		/**
		 * @Note: continues the setup
		 * @Note: called from init if there is no TranslationData document for the game
		 * @Note: called from translationComplete if there is a TranslationData document and it's fully loaded
		 */		
		private function continueSetup( ):void
		{
			if ( mRootMC.mcBIOS.hasOwnProperty( "useConfigFile" ) )
			{
				if 	( mRootMC.mcBIOS.useConfigFile )
				{
					LoadConfigData( );	
				}
				
				else
				{
					trace( "GameEngineSupport says: no config file in use" );
					mConfigXML = new XML( );
					localInit( );
					//checkForExternalAssets();
				}
			}
			
			else
			{
				localInit( );
				//LoadConfigData();	
			}
		}
		
		/**
		 * @Note: This is to request the Config File (as well as other Shell Cmds)
		 * @Note: This uses the GameShell_Events as a Bridge, but if run locally will load the Config File manuelly.
		 */		
		private function LoadConfigData( ):void
		{	
			// Added by PC - to load different version of config.xml if a different file version is specified in NP9_BIOS
			var configfilename:String = mRootMC.mcBIOS.configFileName + "." + mRootMC.mcBIOS.configFileExtension;
			if (mRootMC.mcBIOS.configFileVersion > 0) {
				configfilename = mRootMC.mcBIOS.configFileName + "_v" + mRootMC.mcBIOS.configFileVersion.toString() + "." + mRootMC.mcBIOS.configFileExtension;
			}
			trace("GameEngineSupport says: Loading config file- " + mLocalPathway + configfilename);
			mLoaderXML = new XMLLoader( mLocalPathway + configfilename );
			mLoaderXML.addEventListener( mLoaderXML.XML_DONE, onConfigDataReady, false, 0, true );
			mLoaderXML.addEventListener( mLoaderXML.XML_LOAD_ERROR, onConfigDataError, false, 0, true );
			mLoaderXML.loadXML( );
		}
		
		/**
		 * @Note: checks for external assets that need to be loaded
		 */		
		private function checkForExternalAssets( ):void
		{
			trace( "GameEngineSupport says: checkForExternalAssets called" );
			
			if ( mConfigXML.hasOwnProperty( "LOADLIST" ) )
			{
				mRootMC.dispatchEvent( new Event( SETUP_LOADING_SIGN ) );
				mExternalLoader.addEventListener( mExternalLoader.LOADING_COMPLETE, onExternalFilesLoaded, false, 0, true );
				mExternalLoader.addEventListener( mExternalLoader.LOADING_PROGRESS, onLoadingProgress, false, 0, true );
				mExternalLoader.init( mConfigXML.LOADLIST[ 0 ], LOADINGENGINE_ID, mRootMC.mcBIOS );
			}
			
			else
			{
				localInit( );
			}
			
		}
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: this is the last function to be called before the main game takes over
		 *        it is called after everything (e.g. translation data, external assets, etc.) is fully set up
		 */		
		protected function localInit( ):void { }
		
		/**
		 * @Note: so the game can be compiled without being in the GameApplication Engine
		 */		
		private function setupVars( ):void
		{
			trace( "GameEngineSupport says: setupVars called" );
			
			mGameShell_Events   = new GameShell_Events( );
			mExternalLoader     = new LoadingEngineXML( );
			mViewContainer      = new ViewContainer( );
			mTranslationManager = TranslationManager.instance;
			mApplicationDomain  = ApplicationDomain.currentDomain;
		}
	}	
}
