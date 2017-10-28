
package com.neopets.projects.np9.gameEngine
{
	//=============================================
	//	CUSTOM IMPORTS
	//=============================================
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.projects.np9.system.NP9_Loader_Control;
	//import com.neopets.projects.np9.system.NP9_Sound_Control;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
/**
 *	<p>Your game's swf document class should always extend this class.
 *	This gives you access to Neopets Related Code.</p>
 * 
 * 
 *	@langversion 3.0
 *	@playerversion Flash 10.0
 *	@Pattern NP9 Neopets Game System
 * 
 *	@author Clive Henrick based on Ollie B. work
 *	@since  7.25.2009 updates 8/13/09
 * 
 * - mBIOS might be the same as mcBIOS in child class, possibly redundant
 */
	public class NP9_DocumentExtension extends MovieClip 
	{
		//=============================================
		//	CLASS CONSTANTS
		//=============================================
		public const START_LOADING       : String = "NP9_PRELOADER_tellingGametoStart";
		public const SETUP_LOADING_SIGN  : String = "setupLoadingSign";
		public const REMOVE_LOADING_SIGN : String = "removeLoadingSign";
		public const LOADING_PROGRESS    : String = "loadingProgress";
		public const START_GAME_MSG      : String = "Game Started";
		
		public const END_GAME_MSG:String = "Game Finished";
		public const TRANSLATION_COMPLETE:String = "TranslationSystemComplete";
		
		//=============================================
		//	PRIVATE & PROTECTED VARIABLES
		//=============================================
		protected var mGamingSystemIndex       : Number;
		private var mObjLoaderControl        : NP9_Loader_Control;
		
		protected var mBIOS                  : NP9_BIOS;
		protected var mGamingSystem          : MovieClip;
		protected var LoadingSignOn          : Boolean;
		protected var mNP9SystemLoadedToggle : Boolean;
		
		//=============================================
		//	PUBLIC VARIABLES
		//=============================================
		
		/**
		 * When true, the swf is being played offline.
		 */
		public var bOffline : Boolean;
		
		//=============================================
		//  GETTERS/SETTERS
		//=============================================
		
		/** 
		 * Backwards compatibility.
		 * Returns the NP9_BIOS object.
		 */		
		public function getBIOS( ):NP9_BIOS 
		{			
			return mBIOS;
		}
		
		/** 
		 * Backwards compatibility.
		 * Returns the GamingSystem object.
		 */
		public function get _GS( ):MovieClip
		{
			return mGamingSystem;
		}
		
		/** 
		 * Backwards compatibility.
		 * @see #_GS
		 */
		public function get _GAMINGSYSTEM( ):MovieClip
		{
			return mGamingSystem;
		}
		
		/** 
		 * Backwards compatibility.
		 * @see #_GS
		 */
		public function getGamingSystem( ):MovieClip
		{
			return mGamingSystem;
		}
		
		/** 
		 *  Backwards compatibility.
		 *  Throws an exception when GamingSystem does not exist.
		 * @see #_GS
		 */		
		public function get neopets_GS( ):MovieClip
		{
			if ( mGamingSystem == null )
			{
				throw new Error( "NP9_DocumentExtension says: mGamingSystem is Null in the DocumentExtension" );
				return false;
			}
			else
			{
				return mGamingSystem;
			}
		}
		
		/** 
		 * Returns the translation Manager
		 */
		
		public function get translationManager():TranslationManager
		{
			return TranslationManager.instance;
		}
		
		/**
		 * @Constructor
		 */
		public function NP9_DocumentExtension( ) 
		{
			trace( "NP9_DocumentExtension says: NP9_DocumentExtension constructed" );

			
			setupVars( );
			
			addEventListener( START_LOADING, NP9systemLoaded, false, 0, true );
			addEventListener( SETUP_LOADING_SIGN, setupLoaderSign, false, 0, true );
			addEventListener( LOADING_PROGRESS, onProgress, false, 0, true )
			
		}
		
		//=============================================
		//  PUBLIC METHODS
		//=============================================
		/**
		 * Initialization
		 * 
		 * @param p_mBIOS	The NP9_BIOS object instance passed in from the stage
		 */
		public function init( p_mBIOS:NP9_BIOS = null ):void 
		{			
			mBIOS = p_mBIOS;
			
			/**
			 *  this checks if the parent is the stage. if it is the stage, then the game must be
			 * 		  offline because once it is online, the parent is something other than the stage
			 * 		  (possibly the preloader but not sure)
			 */		
			if ( this.parent != null )
			{
				if( this.parent.toString( ).toUpperCase( ).indexOf( "STAGE", 0 ) >= 0 ) 
				{
					triggerOfflineMode( );
				}	
			}
			
			// trace out the Time Stamp for the Project in a Message for Testing
			trace(	mBIOS.game_infostamp + " " + mBIOS.game_datestamp + " " + mBIOS.game_timestamp );
			
			// turn off the Visibility of the mBIOS just in case
			mBIOS.visible = false;
			
			// keep track of scoring meter index
			mGamingSystemIndex = 0;
					
		}
		
		/**
		 *  This triggers the NP9 System to use offline mode
		 */		
		public function triggerOfflineMode( ):void
		{
			bOffline = true;
			offlineMode( );	
			
			trace("Triggered offline Mode");
		}
		
		/**
		 * Tells the game to run in offline mode and Load its own NP9_Loader_Control object.
		 */
		public function offlineMode( ):void 
		{			
			mObjLoaderControl = new NP9_Loader_Control( this );
			
			// if the game is launched offline, we need to pass the BIOS settings to the loader class
			mObjLoaderControl.setEnvironment( "offline" );
			mObjLoaderControl.setOfflineBiosParams( mBIOS );
			
			this.addEventListener( Event.ENTER_FRAME, main, false, 0, true );
		}
		
		/**
		 * This is called from the NP9_Loader_Control instance to set the gaming system, once it is loaded
		 * @param p_mcGS	The GamingSystem object
		 */		
		public function setGamingSystem( p_mcGS : MovieClip ):void 
		{
			mGamingSystem = p_mcGS;
		}
		
		/**
		 * @private
		 */		
		public function NP9_GameBase( ):void 
		{			
			mGamingSystem = getGamingSystem( );
			
		}
		
		/**
		 *  This is the translation Setup, this is usually called later in the game startup cycle.
		 * @param pTranslationInfo	Class containing all default game text strings.
		 * @param pTranslationURL	not used
		 */
		
		public function setupTranslation(pTranslationInfo:TranslationData, pTranslationURL:String = null):void
		{
			var tManager:TranslationManager = TranslationManager.instance;
			tManager.addEventListener(Event.COMPLETE, translationComplete, false, 0, true);
			trace ("LANGUAGE: "+mGamingSystem.getFlashParam("sLang").toUpperCase());
			tManager.init(mGamingSystem.getFlashParam("sLang").toUpperCase(), mBIOS.game_id, TranslationManager.TYPE_ID_GAME, pTranslationInfo);
		}
		
		/**
		 *  Brings the GamingSystem (the black score reporting box) up on stage to the top most layer so it is visible.
		 */		
		public function sendScoringMeterToFront():void 
		{			
			trace(" NP9_GameDocument > sendScoringMeterToFront bOffline>",bOffline);
			var nNumLastChild:Number = (numChildren-1);
			mGamingSystem.visible = true;
			// make sure scoring meter is always top DisplayObject
			if ( mGamingSystemIndex != nNumLastChild ) {
				setChildIndex( getChildAt(mGamingSystemIndex), nNumLastChild );
				mGamingSystemIndex = nNumLastChild;
			}
			trace("INFO SendScoreingMeterToFront>", nNumLastChild," GSINDEX>",mGamingSystemIndex, " GSVIS>",mGamingSystem.visible);
		}
		
		/**
		 *  Brings the GamingSystem (the black score reporting box) down on stage so it becomes hidden.
		 */
		public function sendScoringMeterToBack():void 
		{
			if ( bOffline ) {
				if ( mGamingSystemIndex != 0 ) {
					setChildIndex( getChildAt(mGamingSystemIndex), 0 );
					mGamingSystemIndex = 0;
				}
				trace("INFO sendScoringMeterToBack>  GSVIS>",mGamingSystem.visible);
			}
		}
		
		/**
		 *  Gets the current language code in use. eg. EN, PT, ES, FR etc
		 */
		
		protected function getLanguageCode():String
		{
			var tLanguageStr:String = mGamingSystem.getFlashParam("sLang");
			if (tLanguageStr == null) tLanguageStr = mBIOS.game_lang;				
			return tLanguageStr;
		}
		
		//=============================================
		//  EVENT HANDLERS
		//=============================================
		
		/** 
		 * <p>This bypasses the loader control handling of triggering the system once it has the NP9_GamingSystem loaded. This system uses an Event instead of a trigger on frame 2 of the timeline.</p>
		 * <li>Gets the GamingSystem (aka the black score meter)</li>
		 * <li>Adds it to the display list at lowest index, i.e. beneath every other DisplayObject</li>
		 * <li>Updates the game engine</li>
		 */		
		protected function NP9systemLoaded( evt : Event = null ):void
		{
			//trace( "NP9_DocumentExtension says: NP9systemLoaded called" );
			//trace( "NP9_DocumentExtension says: NP9systemLoaded_Outside" );
			
			if ( !mNP9SystemLoadedToggle )
			{
				//trace( "NP9_DocumentExtension says: NP9systemLoaded_Inside" );
				NP9_GameBase( );
				this.addChildAt( mGamingSystem, mGamingSystemIndex );
				gameEngineUpdate( );
			}
			
		}
		
		/**
		 *  Places loading sign on the stage. The event is dispatched from GameEngineSupport instance.
		 **/
		protected function setupLoaderSign( evt : Event = null ):void
		{
			//trace( "NP9_DocumentExtension says: setupLoaderSign called" );
			//trace( "NP9_DocumentExtension says: LoadingSignOn = " + LoadingSignOn );
			
			if ( !LoadingSignOn )
			{
				LoadingSignOn = true
				var loadingSignClass : Class = getDefinitionByName( "LoadingSign" ) as Class;
				var loadingSign      : MovieClip = new loadingSignClass ( );
				loadingSign.name = "loadingSign";
				addChild( loadingSign );
				loadingSign.x = stage.stageWidth/2;
				loadingSign.y = stage.stageHeight/2;
				addEventListener( REMOVE_LOADING_SIGN, removeLoaderSign, false, 0, true);
			}
		}
		
		/**
		 *  Removes loading sign from the stage and removes event listeners. The event is dispatched from both GameEngineSupport and GameEngine class.
		 **/		
		protected function removeLoaderSign( evt : Event = null ):void
		{
			if ( hasEventListener( SETUP_LOADING_SIGN ) )  removeEventListener( SETUP_LOADING_SIGN, setupLoaderSign );
			if ( hasEventListener( REMOVE_LOADING_SIGN ) ) removeEventListener( REMOVE_LOADING_SIGN, removeLoaderSign );
			if ( hasEventListener( LOADING_PROGRESS ) )  removeEventListener( LOADING_PROGRESS, onProgress );
			if ( getChildByName( "loadingSign" ) != null )
			{
				removeChild( getChildByName( "loadingSign" ) );
			}
			
		}
		
		/** 
		 *  Once the Transition Object is Ready, Fires this Event
		 */
		
		protected function translationComplete(evt:Event):void
		{
			dispatchEvent(new Event(TRANSLATION_COMPLETE));
			trace ("translation complete event dispatched");
		}
		
		/**
		 * ######## NEEDS TO BE RE-WORKED ######################
		 *  sends a function call to its child to continue the process
		 */		
		private function main( evt : Event ):void
		{
			if (( !mObjLoaderControl.main( )) && (hasEventListener(Event.ENTER_FRAME)) ) 
			{
			this.removeEventListener( Event.ENTER_FRAME, main );
			
			//this.removeEventListener( Event.ENTER_FRAME, main );
			}
		}
		
		/**
		 *  Tracks the loading progress 
		 */
		protected function onProgress ( evt : CustomEvent ):void
		{
			//trace( "NP9_DocumentExtension says: onProgress called" );
			
			var totalLoaded : int    = evt.oData.DATA.TOTAL_LOADED;
			var totalToLoad : int    = evt.oData.DATA.TOTAL_ITEMS;
			var BytesLoaded : Number = evt.oData.DATA.BYTES_LOADED;
			var BytesTotal  : Number = evt.oData.DATA.BYTES_TOTAL;
			var percent     : Number = Math.floor( BytesLoaded/BytesTotal * 100 )
			
			var loadingSign : MovieClip = MovieClip( getChildByName( "loadingSign" ) );
						
			if ( loadingSign.hasOwnProperty( "percentCount" ) )
			{
				loadingSign.percentCount.text = percent.toString( );
			}
			
			if (loadingSign.hasOwnProperty( "fileCount" ) )
			{
				loadingSign.fileCount.text = totalLoaded.toString( ) + "/" + totalToLoad.toString( );
			}
			
		}
		
		//=============================================
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//=============================================
		
		/**
		 *  <p>This should be overridden in your main game so that you know its time to continue code after the NP9 System has been loaded.
		 *  This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control.</p>
		 *	<p>This is Triggered by the NP9_Loader_Control. At function main() - _STARTGAME:</p>
		 * 
		 * @see com.neopets.projects.np9.system.NP9_Loader_Control#main()
		 */		
		protected function gameEngineUpdate( ):void
		{
			trace ( "NP9_DocumentExtension says: Please override gameEngineUpdate( )");	
		}
		
		/**
		 * @Note instantiate vars
		 */		
		private function setupVars( ):void
		{
			trace( "NP9_DocumentExtension says: setupVars called" );
			
			mNP9SystemLoadedToggle = false;
			LoadingSignOn = false;	
			bOffline = false;
		}
	}	
}