package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===================================================================
	// IMPORTS
	//===================================================================
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.util.sound.SoundObj;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import virtualworlds.lang.TranslationManager;
	
	public class GameStartUp extends GameEngine
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		public const TITLE_SCREEN_MUSIC : String = "TitleScreenMusic";
		public const GAME_MUSIC         : String = "GameMusic";
		public const GAME_OVER          : String = "GameOver";
		public const BALTH_GROWL        : String = "BalthazarGrowl";
		public const SPEED_UP           : String = "PUSpeedUp";
		public const FREEZE             : String = "PUFreeze";
		public const TWO_PETPETS        : String = "PUTwoPetpets";
		
		//=======================================
		// back end stuff
		//=======================================
		
		//=======================================
		// sounds and music
		//=======================================
		
		//=======================================
		// garbage collector
		//=======================================
		//private var mSoundManager      : SoundManager;
		//private static var mGarbageArr : Array;
		
		//===============================================================================
		// CONSTRUCTOR GameStartUp
		//===============================================================================
		public function GameStartUp( )
		{
			super( );
			
			trace( this + " created" );
			
			/**
			 * event listeners for sounds called in other objects
			 */
			Dispatcher.addEventListener( ExtremeHerderIIGame.BALTH_GROWL, playOutsideSound );
			Dispatcher.addEventListener( ExtremeHerderIIGame.SPEED_UP, playOutsideSound );
			Dispatcher.addEventListener( ExtremeHerderIIGame.FREEZE, playOutsideSound );
			Dispatcher.addEventListener( ExtremeHerderIIGame.TWO_PETPETS, playOutsideSound );
			
			// triggered when back button in Instructions and GameOverScreen is clicked
			Dispatcher.addEventListener( Instructions.BACK_TO_MAIN, backToMainMenu );
			
			// triggered when end game button in Scoreboard is clicked
			Dispatcher.addEventListener( Scoreboard.GAME_OVER, createGameOverMenu );
			
			// triggered when continue button in NextLevelPopUp is clicked after last level 
			Dispatcher.addEventListener( NextLevelPopUp.GAME_OVER, createGameOverMenu );
			
			// triggered when ExtremeHerderGameII detects that there are no more lives in Scoreboard
			Dispatcher.addEventListener( ExtremeHerderIIGame.GAME_OVER, createGameOverMenu );
						
		} // end constructor		
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		public function get mMainTimeLine( ):Object { return mRootMC };
		public function get mSystem( ):Object { return mGamingSystem };		
		public function get mAssetLocation( ):ApplicationDomain
		{
			var tLoadedObject : LoadedItem = loadingEngine.getLoaderObjmID( "externalAssetStorage" );
			return tLoadedObject.localApplicationDomain;
		}
		
		//===============================================================================
		// FUNCTION initChild
		//===============================================================================
		protected override function initChild( ):void
		{
			//trace( "initChild in " + this + " called" );
			//trace ("what is my root", mRootMC)
			//mRootMC.testText.text = "initiated"
		  	//setupAssetHandler( );
			
			/**
			 * load the translation manager
			 * start everything only after manager is loaded so that the text is available
			 */
			var tEHIITranslationData : EHIITranslationData = new EHIITranslationData( );
			var tTransManager : TranslationManager = TranslationManager.instance;
			tTransManager.addEventListener( Event.COMPLETE, transManagerLoaded, false, 0, true );
			tTransManager.init( mSystem.getFlashParam( "sLang" ), 1117, 4, tEHIITranslationData, mSystem.getFlashParam( "sBaseURL" ) );
			trace( mSystem.getFlashParam( "sBaseURL" ) );
		
		}
		
		//===============================================================================
		// FUNCTION transManagerLoaded
		//===============================================================================
		private function transManagerLoaded( evt : Event ): void
		{
			//trace( "transManagerLoaded in " + this + " called" );
			
		  	completedSetup( );
		  	setupVars( );
		  	loadSounds( );
		  	createMainMenu( );
			
		} // end transManagerLoaded
		
		//===============================================================================
		// FUNCTION createMainMenu
		//===============================================================================
		internal function createMainMenu( ):void
		{		
			trace( "createMainMenu in " + this + " called" );
			
			cleanUp( );
			
			if( GameVars.mMusicOn && !mSoundManager.checkSoundState( TITLE_SCREEN_MUSIC ) )
			{			
				mSoundManager.soundPlay( TITLE_SCREEN_MUSIC, true );
			}

			var tTransManager        : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );
			
			var tMainMenuContainer : Sprite = new Sprite( );
			var tContainerName     : String = tMainMenuContainer.name = "main_menu_container";
			
			/**
			 * attach background
			 */
			var tBackgroundClass : Class = mAssetLocation.getDefinition( "MainMenuBG" ) as Class;
			var tBackground      : MovieClip = new tBackgroundClass( );
			tBackground.x = mMainTimeLine.stage.stageWidth / 2;
			tBackground.y = mMainTimeLine.stage.stageHeight / 2;
			tMainMenuContainer.addChild( tBackground );
			
			/**
			 * attach logo
			 */
			var tLogoClass : Class     = mAssetLocation.getDefinition( "GameLogo" ) as Class;
			var tLogo      : MovieClip = new tLogoClass( );
			tLogo.gotoAndStop( mSystem.getFlashParam( "sLang" ).toUpperCase( ) )
			tLogo.x = mMainTimeLine.stage.stageWidth / 2;
			tLogo.y = 120;
			tMainMenuContainer.addChild( tLogo );
			
			/**
			 * attach sound button
			 */
			var tSoundBtnClass : Class =  mAssetLocation.getDefinition( "SoundButton" ) as Class;
			var tSoundButton : MovieClip = new tSoundBtnClass( );
			tSoundButton.name = "sound_btn";
			tSoundButton.buttonMode = true;
			tSoundButton.x = 70;
			tSoundButton.y = 490;			
			tSoundButton.gotoAndStop( getSoundBtnState( ) );
			tSoundButton.addEventListener( MouseEvent.MOUSE_DOWN, soundBtnClicked, false, 0, true );
			tMainMenuContainer.addChild( tSoundButton );
			
			/**
			 * attach start button
			 */		
			var tPlayBtn        : GenericButton = new GenericButton( "GenericButton", "play_button", 220, 520, 1.4, 1, true, 20, 20 );			
			var tPlayBtnTFClass : Class     = mAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tPlayBtnTF      : MovieClip = new tPlayBtnTFClass( );		
			
			tTransManager.setTextField( tPlayBtnTF.mTextField, tEHIITranslationData.IDS_PLAY_BUTTON );

			tPlayBtnTF.y = -2;
			tPlayBtn.addChild( tPlayBtnTF );			
			tPlayBtn.addEventListener( MouseEvent.CLICK, startEHIIGame, false, 0, true );
			tMainMenuContainer.addChild( tPlayBtn );
			
			/**
			 * attach instructions button
			 */
			var tInstrBtn        : GenericButton = new GenericButton( "GenericButton", "instr_button", 400, 520, 1.4, 1, true, 20, 20 );			
			var tInstrBtnTFClass : Class     = mAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tInstrBtnTF      : MovieClip = new tInstrBtnTFClass( );
			tInstrBtnTF.mTextField.width     = 160;	

			tTransManager.setTextField( tInstrBtnTF.mTextField, tEHIITranslationData.IDS_INSTR_BUTTON );
			
			tInstrBtnTF.x = -30;
			tInstrBtnTF.y = -2;
			tInstrBtn.addChild( tInstrBtnTF );			
			tInstrBtn.addEventListener( MouseEvent.CLICK, createInstructionsMenu, false, 0, true );
			tMainMenuContainer.addChild( tInstrBtn );
			
			/**
			 * attach music button
			 */
			var tMusicBtnClass : Class =  mAssetLocation.getDefinition( "MusicButton" ) as Class;
			var tMusicButton : MovieClip = new tMusicBtnClass( );
			tMusicButton.name = "sound_btn";
			tMusicButton.buttonMode = true;
			tMusicButton.x = 490;
			tMusicButton.y = 490;			
			tMusicButton.gotoAndStop( getMusicBtnState( ) );
			tMusicButton.addEventListener( MouseEvent.MOUSE_DOWN, musicBtnClicked, false, 0, true );
			tMainMenuContainer.addChild( tMusicButton );
						
			mViewContainer.addDisplayObjectUI( tMainMenuContainer, 1, tContainerName );
			
		} // end createGameMenu
		
		//===============================================================================
		// FUNCTION soundBtnClicked
		//          - toggles state of sound button    
		//===============================================================================
		public function soundBtnClicked( evt : MouseEvent ):void 
		{
			var tSoundButton : MovieClip = evt.target as MovieClip;
			//trace( "tSoundButton: " + tSoundButton );
			//playSound( "BtnClick", GameVars.mSoundOn );
			
			GameVars.mSoundOn ? GameVars.mSoundOn = false : GameVars.mSoundOn = true;
			trace( "mSoundOn: " + GameVars.mSoundOn );
			
			if ( GameVars.mSoundOn ) 
			{
				tSoundButton.gotoAndStop( "on" );
			}
			
			else 
			{
				tSoundButton.gotoAndStop( "off" );
			}
			
		} // end soundBtnClicked
		
		//===============================================================================
		// FUNCTION getSoundBtnState
		//	- checks state of button and returns it as string so that playhead goes
		//    to frame with string's label
		//===============================================================================
		public function getSoundBtnState( ) : String 
		{
			var tSoundBtnState : String = new String;
			
			if( GameVars.mSoundOn )
			{
				tSoundBtnState = "on";
			}
			
			else
			{
				tSoundBtnState = "off";
			}
			
			return tSoundBtnState;
			
		} // end getSoundBtnState
		
		//===============================================================================
		// FUNCTION musicBtnClicked
		//          - toggles state of music button    
		//===============================================================================
		public function musicBtnClicked( evt : MouseEvent ):void 
		{
			var tMusicButton : MovieClip = evt.target as MovieClip;
			//trace( "tSoundButton: " + tSoundButton );
			//playSound( "BtnClick", GameVars.mSoundOn );
			
			GameVars.mMusicOn ? GameVars.mMusicOn = false : GameVars.mMusicOn = true;
			trace( "mMusicOn: " + GameVars.mMusicOn );
			
			if ( GameVars.mMusicOn ) 
			{
				tMusicButton.gotoAndStop( "on" );
				mSoundManager.soundPlay( TITLE_SCREEN_MUSIC, true );
			}
			
			else 
			{
				tMusicButton.gotoAndStop( "off" );
				mSoundManager.stopSound( TITLE_SCREEN_MUSIC );
			}
			
		} // end musicBtnClicked
		
		//===============================================================================
		// FUNCTION getMusicBtnState
		//          - checks state of button and returns it as string
		//===============================================================================
		public function getMusicBtnState( ) : String 
		{
			var tMusicBtnState : String = new String;
			
			if( GameVars.mMusicOn )
			{
				tMusicBtnState = "on";
			}
			
			else
			{
				tMusicBtnState = "off";
			}
			
			return tMusicBtnState;
			
		} // end getMusicBtnState
		
		//===============================================================================
		// FUNCTION startGame
		//          - called from tLevelButton  
		//===============================================================================
		private function startEHIIGame( evt : MouseEvent ):void
		{
			trace( "startGame in " + this + " called" );
			
			/**
			 * send tracking
			*/	
			mSystem.sendTag( "Game Started" );
			
			cleanUp( );
			
			mSoundManager.stopSound( TITLE_SCREEN_MUSIC );
			
			if( GameVars.mMusicOn )
			{			
				mSoundManager.soundPlay( GAME_MUSIC, true );
			}
			
			var tMainGame      : ExtremeHerderIIGame = new ExtremeHerderIIGame( );
			var tContainerName : String = tMainGame.name = "main_game";
			tMainGame.init( );
			
			mViewContainer.addDisplayObjectUI( tMainGame, 1, tContainerName );
			
		} // end startGame
		
		//===============================================================================
		// FUNCTION createInstructionsMenu
		//          - called from 
		//===============================================================================
		private function createInstructionsMenu( evt : MouseEvent ): void
		{
			trace( "createInstructionsMenu in " + this + " called" );
			
			cleanUp( );
			
			var tInstructionsContainer : Sprite = new Sprite( );
			var tContainerName : String = tInstructionsContainer.name = "instructions_container";
			
			var tInstructions : Instructions = new Instructions( );
			tInstructionsContainer.addChild( tInstructions );
			
			mViewContainer.addDisplayObjectUI( tInstructionsContainer, 1, tContainerName );
			
		} // end createInstructionsMenu
		
		//===============================================================================
		// FUNCTION createGameOverMenu
		//	- called from EndGamePopUp class via Dispatcher
		//===============================================================================
		internal function createGameOverMenu( evt : Event ): void
		{
			trace( "createGameOverMenu in " + this + " called" );
			
			/**
			 * send tracking
			 */
			mSystem.sendTag( "Game Finished" );
			
			cleanUp( );
			
			mSoundManager.stopSound( GAME_MUSIC );
			
			if( GameVars.mSoundOn )
			{			
				mSoundManager.soundPlay( GAME_OVER );
			}
			
			var tGameOverScreenContainer : Sprite = new Sprite( );
			var tContainerName : String = tGameOverScreenContainer.name = "game_over_screen_container";
			
			var tGamOverScreen : GameOverScreen = new GameOverScreen( );
			tGameOverScreenContainer.addChild( tGamOverScreen );
			
			mViewContainer.addDisplayObjectUI( tGameOverScreenContainer, 1, tContainerName );
			
		} // end createGameOverMenu
		
		//===============================================================================
		// FUNCTION backToMainMenu
		//	- called from Instructions and GameOverScreen classes via Dispatcher
		//	- dummy function to call cleanUp so that instructions can be removed
		//===============================================================================
		internal function backToMainMenu( evt : DataEvent ):void
		{	
			trace( "clearInstructions in " + this + " called" );
						
			createMainMenu( );
			
		} // end backToMainMenu
		
		//===============================================================================
		// FUNCTION cleanMenu
		//	- checks which display object container is currently held by mViewContainer
		//		and passes it on to clearContainer
		//===============================================================================
		private function cleanUp( ):void
		{
			trace( "cleanUp in " + this + " called" ) ;
			var tContainer : Sprite;
			var tHasContainer : Boolean = false;
			
			if( mViewContainer.numChildren > 0 )
			{
				/**
				 * - determine which container is currently held by mViewContainer
				 * - remove all event listeners from elements in that container
				 * - send that container to clearContainer to empty it
				 */
				if( mViewContainer.getChildByName( "main_menu_container" ) != null )
				{
					/**
					 * main_menu_container has:
					 * - play_button
					 * - instr_button
					 */
					//trace( "deactivating elements in: " + mViewContainer.getChildByName( "main_menu_container" ).name );
					tHasContainer = true;
					tContainer = mViewContainer.getChildByName( "main_menu_container" ) as Sprite;
					
					if( tContainer.getChildByName( "play_button" ) != null )
					{
						var tPlayButton : GenericButton = tContainer.getChildByName( "play_button" ) as GenericButton;
						if( tPlayButton.hasEventListener( MouseEvent.CLICK ) )
						{
							tPlayButton.removeEventListener( MouseEvent.CLICK, startEHIIGame );
						}
					}
					
					if( tContainer.getChildByName( "instr_button" ) != null )
					{
						var tInstrButton : GenericButton = tContainer.getChildByName( "instr_button" ) as GenericButton;
						if( tInstrButton.hasEventListener( MouseEvent.CLICK ) )
						{
							tInstrButton.removeEventListener( MouseEvent.CLICK, createInstructionsMenu );
						}
					}
				}
				
				/**
				 * main_game attaches event listeners to its elements so they must 
				 * be removed within main_game
				 */
				else if( mViewContainer.getChildByName( "main_game" ) != null )
				{
					//trace( "deactivating elements in: " + mViewContainer.getChildByName( "main_menu_container" ).name );
					tHasContainer = true;
					tContainer = mViewContainer.getChildByName( "main_game" ) as Sprite;										
				}
			
				/**
				 * instructions_container attaches event listeners to its elements so they must 
				 * be removed within instructions_container
				 */
				else if( mViewContainer.getChildByName( "instructions_container" ) != null )
				{
					//trace( "deactivating elements in: " + mViewContainer.getChildByName( "instructions_container" ).name );
					tHasContainer = true;
					tContainer = mViewContainer.getChildByName( "instructions_container" ) as Sprite;					
				}
			}
			
			if( tHasContainer )
			{
				trace( tContainer.name + " being cleared" );
			
				clearContainer( tContainer );
				//checkContainerChildren( mViewContainer );
				mViewContainer.removeUIDisplayObject( tContainer.name );
			}
			
			//checkContainerChildren( mViewContainer );
			
		} // end cleanMenu
		
		//===============================================================================
		// FUNCTION clearContainer
		//	- loops through the display object container that is passed in and removes
		//		all it's children
		//===============================================================================
		private function clearContainer( pContainer : * ):void
		{
			for( var i : int = pContainer.numChildren - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = pContainer.getChildAt( i );

				if( tCurrentObject is DisplayObjectContainer )
				{
					var tContainer : DisplayObjectContainer = tCurrentObject as DisplayObjectContainer;
					
					if( tContainer.numChildren > 0 )
					{
						clearContainer( tContainer );
					}
					
					else
					{
						if( tContainer != null )
						{
							//trace( tContainer + " is being removed" );
							//trace( tContainer.name + " is being removed" );
							tContainer.parent.removeChild( tContainer );
							tContainer = null;
						}
					}
				}
				
				else
				{
					if( tCurrentObject!= null )
					{
						//trace( tCurrentObject + " is being removed" );
						//trace( tCurrentObject.name + " is being removed" );
						tCurrentObject.parent.removeChild( tCurrentObject );
						tCurrentObject = null;
					}
				}
			}			
			
		} // end clearContainer
		
		//===============================================================================
		// FUNCTION checkContainerChildren
		//	- loops through the display object container that is passed in and traces
		//		out the children it contains
		//===============================================================================
		private function checkContainerChildren( pContainer : * ):void
		{
			//trace( "checkContainerChildren in " + this + " called" );
			for( var i : int = pContainer.numChildren - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = pContainer.getChildAt( i );

				if( tCurrentObject is DisplayObjectContainer )
				{
					trace (tCurrentObject)
					checkContainerChildren( tCurrentObject );
				}
				
				else
				{
					trace( "object " + i + ": " + tCurrentObject );
				}
			}			
			
		} // end checkContainerChildren
		
		//===============================================================================
		// FUNCTION loadSounds
		//===============================================================================
		private function loadSounds( ):void
		{
			mSoundManager.loadSound( TITLE_SCREEN_MUSIC, SoundObj.TYPE_INTERNAL );
			mSoundManager.loadSound( GAME_MUSIC, SoundObj.TYPE_INTERNAL );
			mSoundManager.loadSound( BALTH_GROWL, SoundObj.TYPE_INTERNAL );
			mSoundManager.loadSound( GAME_OVER, SoundObj.TYPE_INTERNAL );
			mSoundManager.loadSound( SPEED_UP, SoundObj.TYPE_INTERNAL );
			mSoundManager.loadSound( FREEZE, SoundObj.TYPE_INTERNAL );
			mSoundManager.loadSound( TWO_PETPETS, SoundObj.TYPE_INTERNAL );
			
		} // end loadSounds
		
		//===============================================================================
		// FUNCTION loadSounds
		//===============================================================================
		private function playOutsideSound( evt : DataEvent ):void
		{
			var tSound : String = evt.mData as String;
			
			mSoundManager.soundPlay( tSound );
			
		} // end loadSounds
		
		//===============================================================================
		// FUNCTION setupVars
		//          - sets up vars (duh)
		//===============================================================================
		private function setupVars( ):void
		{
			GlobalGameReference.mInstance.init( this );
			
			GameVars.mSoundOn      = true;
			GameVars.mMusicOn      = true;
			//mSoundManager = SoundManager.instance; 
			//mGarbageArr = new Array( );
			
		} // end setupVars
						
	} // end class
	
} // end package