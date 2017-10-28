package com.neopets.projects.gameEngine.common
{
	/**
	 * this sets up basic functionality of the game engine:
	 * 1) loads sounds from external SWF
	 * 2) creates the MenuManager for basic menu navigation
	 * 2) handles communication to the NP9 Game System
	 * 3) holds the ViewContainer for the game
	 * 
	 * 
	 * ###### NOTE ######
	 * From Project to Project the only functions that should be needed to be changed is
	 * the ExternalCommands Class.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @Pattern Neopets Game Shell
	 * 
	 * @author Clive Henrick
	 * @since  01.21.2008
	 * 
 	 * @updated 11.10.2010 - PC: added code for resource and config file versioning
	*/
	
	//=============================================
	//	CUSTOM IMPORTS
	//=============================================
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.assetloader.NPAssetLoader;
	
	//=============================================
	//	NATIVE IMPORTS
	//=============================================
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	/**
	 * not yet reached in program flow
	 */	
	import com.neopets.projects.mvc.view.NeopetsScene;
	import com.neopets.projects.neopetsGameShell.model.IExternalCommands;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.util.button.*;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class GameEngine extends GameEngineSupport
	{		
		//=============================================
		//	CLASS CONSTANTS
		//=============================================
		public const GAME_ENGINE_CLEANED : String = "TheMemoryIsCleanedUp";
		
		//=============================================
		//  PRIVATE & PROTECTED VARIABLES
		//=============================================
		protected var mButtonLock   : Boolean;
		protected var mSoundManager : SoundManager;
		protected var mMusicOn      : Boolean;
		protected var mMenuManager  : MenuManager;
		protected var mNPAssetLoader: NPAssetLoader;
		
		/**
		 * not yet reached in program flow
		 */
		protected var mScenesToLoad:int;
		protected var mRunningSceneCount:int;
		protected var mCurrentScene:NeopetsScene;
		protected var mSceneArray:Array;
		protected var mExternalCommand:IExternalCommands;
		
		//=============================================
		//  GETTERS/SETTERS
		//=============================================
		
		/**
		 * not yet reached in program flow
		 */
		public function get buttonLock():Boolean {
			return mButtonLock;
		}
		public function set buttonLock(pFlag:Boolean):void {
			mButtonLock = pFlag;
		}
		public function set externalCommand(pExternalCmd:IExternalCommands):void {
			mExternalCommand = pExternalCmd;
		}
		
		//=============================================
		//  CONSTRUCTOR
		//=============================================	
		public function GameEngine( ):void 
		{
			super( );
			
			trace( "GameEngine says: GameEngine constructed" );
			
			mVersion = .3;                                     // mVersion declared in GameEngineSupport
			mID      = "NeoPets_GameEngine_V_" + mVersion;     // mID declared in GameEngineSupport
			output( "GameEngine says: GameEngine is " + mID );
			setupVars( );
			
		}
		
		//=============================================
		//  PUBLIC METHODS
		//=============================================
		
		/**
		 * not yet reached in program flow
		 */
		/**
		 * @Note: Used to Translate Text
		 * @param		fontName			String				The Name of the Font
		 * @param		tf						TextFiled			The TextField to be translated
		 * @param		str						String				The ID of the Translated Text
		 * @param		textFormat			TextFormat		Any Effects you want on the Translated Text Field				
		 */
		
		public function setText( fontName:String = null, tf:TextField = null, str:String = null):void {
			
			mTranslationManager.setTextField(tf,str,fontName);
		}
		
		//=============================================
		//  EVENT HANDLERS
		//=============================================
		
		/**
		 * @Note: events from the menus that affect the game
		 * @param		evt.oData.EVENT		String 		the name of the function that you want called
		 */		
		protected function onMenuEvent( evt : CustomEvent ):void
		{
			switch ( evt.oData.EVENT )
			{
				case "restartGame":		// dispatched when Restart Game link in scoring meter is clicked
					restartGame( );
					break;
			}
		}
		
		/**
		 * @Note: events from the menu buttons that can affect the game
		 * @param		evt.oData.EVENT		String 		name of the button that was pressed in the menus
		 */		
		protected function onMenuButtonEvent( evt : CustomEvent ):void
		{
			switch ( evt.oData.EVENT )
			{
				case "startGameButton":  // located on intro screen
					startGame( );
					break;
				case "quitGameButton":  // located on game screen
					quitGame( );
					break;
				case "playAgainBtn":    // located on game over screen
					restartGame( );
					break;
				case "reportScoreBtn":  // located on game over screen
					reportScore( );
					break;
				case "musicToggleBtn":  // located on intro screen
					toggleMusic( );
					break;
				case "soundToggleBtn":  // located on intro screen
					toggleSound( );
					break;
			}
			
			extraMenuButtons ( evt.oData.EVENT );
			
		}
		
		/**
		 * @Note: this catches MENU_NAVIGATION_EVENT dispatched from function menuNavigation in MenuManager class
		 *        after new screen is being made visible
		 * @Note: can be used for additional functionality (i.e. custom screen transition) 
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 */		
		protected function onMenuNavigationEvent( evt : CustomEvent ):void
		{			
			switch ( evt.oData.MENU )
			{
				/**
				 * sends the game over tag to the server for tracking
				 * activates buttons on game over screen
				 */
				case MenuManager.MENU_GAMEOVER_SCR:
					mGamingSystem.sendTag ( mRootMC.END_GAME_MSG );	
					var tGameOverScreen : GameOverScreen = mMenuManager.getMenuScreen( MenuManager.MENU_GAMEOVER_SCR ) as GameOverScreen;
					tGameOverScreen.toggleInterfaceButtons( true );					
					break;
			}	

		}
		
		/**
		 * not yet reached in program flow
		 */
		/** 
		 * @Note: After the Loading Engine has completed clearing itself, tells the SoundManager to Clean itself.
		 */
		
		protected function cleanUpAfterLoader(evt:Event):void 
		{
			mExternalLoader = null;
			mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_ALLCLEANED,cleanUpAfterSoundManager,false,0,true);
			mSoundManager.cleanUpAllMemory();
		}
		/** 
		 * @Note: After the SoundManager has completed clearing itself, send the Event up the Objects.
		 */
		
		protected function cleanUpAfterSoundManager(evt:Event):void 
		{
			mSoundManager = null;
			dispatchEvent(new CustomEvent({CMD:GAME_ENGINE_CLEANED},SEND_THROUGH_CMD));
		}
		
		
		//=============================================
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//=============================================
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: this is called in parent class GameEngineSupport
		 * @Note: the artAsset SWF should be loaded by the parent before this is called
		 */		
		protected override function localInit( ):void 
		{
			trace( "GameEngine says: localInit called" );
			
			//mRootMC.dispatchEvent( new Event( REMOVE_LOADING_SIGN ) ); //this is redundant but sometimes necessary
			mViewContainer.ID = mID;
			setupSounds( );
		}
		
		/**
		 * @Note: used to setup the sound files. files are set in the config.xml.
		 * @Note: sound files are assumed to be located library of the fla and of class soundObj
		 */		
		protected function setupSounds( ):void 
		{
			var tWaitForSounds : Boolean = false;
			
			if ( mConfigXML.SETUP.hasOwnProperty( "SOUNDS" ) ) 
			{
				for each ( var sndXML : XML in mConfigXML.SETUP.SOUNDS.* ) 
				{
					var sndVolume:Number = sndXML.hasOwnProperty("volume")? sndXML.volume: 1;
					
					trace( "GameEngine says: volume", sndXML.volume, sndVolume, sndXML.id );
					
					if ( sndXML.hasOwnProperty ( "url" ) ) 
					{
						mSoundManager.addEventListener( mSoundManager.SOUNDMANAGER_ALLLOADED, continueSetup, false, 0, true );
						mSoundManager.loadSound( sndXML.id,sndXML.type,0,sndXML.url, null, sndVolume );
						tWaitForSounds = true;						
					} 
					
					else 
					{
						mSoundManager.loadSound( sndXML.id,sndXML.type, 0, null, null, sndVolume );
					}
				}
				
				if( !tWaitForSounds ) 
				{
					trace( "GameEngine says: tWaitForSounds = " + tWaitForSounds + " -> continue setup" );
					continueSetup( );
				}
			} 
			
			else 
			{
				trace( "GameEngine says: continue setup" );
				continueSetup( );
			}
		}
		
		/**
		 * @Note: after sounds are ready, continue the setup
		 */		
		protected function continueSetup( evt : Event = null ):void 
		{
			//trace("Gameengine says: continueSetup called");
			mSoundManager.removeEventListener( mSoundManager.SOUNDMANAGER_ALLLOADED, continueSetup );
			// added by PC  - proceed to load external assets after sounds are initiated -- commented on 25 oct 2010 because of inbuilt asset loading function
			/*mNPAssetLoader.addEventListener(NPAssetLoader.ASSETS_FAILED, haltSetup);
			mNPAssetLoader.addEventListener(NPAssetLoader.ASSETS_LOADED, continueSetup2);

			mNPAssetLoader.processAssets(mConfigXML, mRootMC);*/
			
			// delayed till after external assets are loaded
			mMenuManager.init( mRootMC, mTranslationData );

			setupMenus( );
			mViewContainer.addDisplayObjectUI( mMenuManager.menusDisplayObj, 999, "Menus" );
			initChild( );
		}
		
		/**
		 * Added by PC
		 * @Note: after external assets are loaded, continue setup
		 */		
		/*protected function continueSetup2(evt:Event = null):void {
			//trace("Gameengine says: continueSetup2 called");
			mNPAssetLoader.removeEventListener(NPAssetLoader.ASSETS_FAILED, haltSetup);
			mNPAssetLoader.removeEventListener(NPAssetLoader.ASSETS_LOADED, continueSetup2);
			
			mMenuManager.init( mRootMC, mTranslationData );

			setupMenus( );
			mViewContainer.addDisplayObjectUI( mMenuManager.menusDisplayObj, 999, "Menus" );
			initChild( );			
		}*/
		
		/**
		 * Added by PC
		 * @Note: external assets failed to load. Halt setup
		 */		
		/*protected function haltSetup(evt:Event = null):void {
			mNPAssetLoader.removeEventListener(NPAssetLoader.ASSETS_FAILED, haltSetup);
			mNPAssetLoader.removeEventListener(NPAssetLoader.ASSETS_LOADED, continueSetup2);
			error("GameEngine says: Asset loading failed");
		}*/
		
		/**
		 * @Note: called from continueSetup2 after sounds are loaded and menu manager is instantiated
		 * @Note: handles standard translation for menus 
		 * @Note: one centeral location to have all the text strings converted menus 
		 * @Note: these are the default values for the default objects
		 * @Note: if game class extends VendorGameExtension then this function may be overridden to extend the menus
		 * @Note: if you just want to add menus or translated text, then override extendMenus function instead
		 */	
		protected function setupMenus( ):void
		{		
			trace( "GameEngine says: setupMenus called" );
			//var tBallClass         : Class             = getDefinitionByName( "TestAsset" ) as Class;
			//var tBall              : MovieClip         = new tBallClass( );
						
			var tIntroScreen       : OpeningScreen     = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen        : GameScreen        = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen    : GameOverScreen    = GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen : InstructionScreen = InstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));
						
			//Intro Screen
			mTranslationManager.setTextField( tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_BTN_INSTRUCTION );
			mTranslationManager.setTextField( tIntroScreen.startGameButton.label_txt, mTranslationData.IDS_BTN_START );
			mTranslationManager.setTextField( tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT );
			mTranslationManager.setTextField( tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME );
			
			//Instruction Screen
			mTranslationManager.setTextField( tInstructionScreen.returnBtn.label_txt, mTranslationData.IDS_BTN_BACK );
			mTranslationManager.setTextField( tInstructionScreen.instructionTextField, mTranslationData.IDS_INSTRUCTION_TXT );
			
			//In Game Screen
			mTranslationManager.setTextField( tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT );
			
			//Game Over Screen
			mTranslationManager.setTextField( tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_BTN_PLAYAGAIN );
			mTranslationManager.setTextField( tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_BTN_SENDSCORE );
			
			extendMenus( );
		}		
		
		/** 
		 * @Note: the main game class should call this as the last step in the setup of the GameEngine object
		 * @Note: this will:
		 * 		  - order the objects in the main view container mViewContainer
		 *          -> by default, there is only one object contained in mViewContainer and that is
		 *             mMenuHolder. all screens are added to it
		 *        - add the main view container to the root movieclip
		 *        - get the language and set the logo to the appropriate frame
		 *        - put the intro screen into the foreground
		 */		
		protected function completedSetup( ):void 
		{
			trace( "GameEngine says: completedSetup called" );
			
			mViewContainer.reOrderDisplayList( );
			mRootMC.addChildAt( mViewContainer, mRootMC.numChildren );
			
			var tLanguageStr : String = mGamingSystem.getFlashParam( "sLang" );
			
			if( tLanguageStr == null )
			{
				tLanguageStr = mRootMC.mcBIOS.game_lang;	
			}
			
			mMenuManager.getMenuScreen( MenuManager.MENU_INTRO_SCR ).mcTransLogo.gotoAndStop( tLanguageStr.toUpperCase( ) );
			
			mMenuManager.menuNavigation( MenuManager.MENU_INTRO_SCR );
			
			dispatchEvent(new CustomEvent({CMD:mGameShell_Events.CMD_PRELOADER_DONE},SEND_THROUGH_CMD));
		}
		
		/**
		 * @Note: sends player's score to backend
		 * @Note: puts scoring meter onto foreground
		 */		
		protected function reportScore( ):void
		{
			mGamingSystem.sendScore( ScoreManager.instance.getValue( ) ); 	
			mRootMC.sendScoringMeterToFront( );		
		}
		
		/**
		 * not yet reached in program flow
		 */
		/** 
		 * @Note: This will CleanUp all the Memory (That I can Think of)
		 */		
		protected function cleanupGameEngine():void {
			mViewContainer.cleanUpAllUI();
			mViewContainer = null;
			mExternalLoader.addEventListener(mExternalLoader.LOADING_CLEANED,cleanUpAfterLoader,false,0,true);
			mExternalLoader.cleanUpAllMemory();
		}
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: called when Restart Game link in scoring meter is clicked
		 * @Note: takes player back to intro screen
		 */		
		protected function restartGame( ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: starts the game with all the code you need to start at this moment
		 * @Note: called when Start Game button on intro screen is clicked
		 */		
		protected  function startGame( ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: quits the game
		 * @Note: called when Quit Game button in game is clicked
		 */	
		protected function quitGame( ):void	{ }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: toggle background music on and off
		 */
		protected function toggleMusic( ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: toggle all sounds on and off 
		 */		
		protected function toggleSound( ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: If you need to Extend Menus instead of override setupMenus, just add you Menus and Translation Here.
		 * @Note: Use this to add Btn Cmds to the new Menus.
		 */		
		protected  function extraMenuButtons ( pBtnName : String ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: if you need to extend menus instead of overriding setupMenus, just add your menus and translation here
		 */		
		protected  function extendMenus( ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 */
		protected function initChild( ):void { }
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: starts setting up your game
		 */
		protected function startGameSetup( ):void { }
		
		/**
		 * @Note: sets up vars
		 */
		private function setupVars( ):void 
		{
			mNPAssetLoader = NPAssetLoader.instance;
			mButtonLock   = false;
			mSoundManager = SoundManager.instance;
			mMusicOn      = true;
			mMenuManager  = MenuManager.instance;
			
			mMenuManager.addEventListener( mMenuManager.MENU_EVENT, onMenuEvent, false, 0, true );
			mMenuManager.addEventListener( mMenuManager.MENU_BUTTON_EVENT, onMenuButtonEvent, false, 0, true );
			mMenuManager.addEventListener( mMenuManager.MENU_NAVIGATION_EVENT, onMenuNavigationEvent, false, 0, true );
					
		}

	}
}