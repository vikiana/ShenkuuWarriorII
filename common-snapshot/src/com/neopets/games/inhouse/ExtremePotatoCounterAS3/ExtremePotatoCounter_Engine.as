/* AS3
	Copyright 2008
*/

package  com.neopets.games.inhouse.ExtremePotatoCounterAS3
{
	import com.neopets.examples.gameEngineExample.gameObjects.IGameObject;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.Interface.SendScoreScreen;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.examples.gameEngineExample.reference.SoundID_demo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
	import com.neopets.games.inhouse.ExtremePotatoCounterAS3.game.ExtremePotatoCounterGameScreen;
	
	/**
	 *	This is an Example of the Main Game Code for a Demo. 
	 *  @NOTE: The GameEngine is going to do it own process first, then once it is done, it will trigger
	 *  this class through the initChild() Function.
	 * 
	 *	@NOTE: This extends GameEngine so you have access to most of the GameEngine Functions.
	 *  	>The GameEngine has the SoundManager
	 * 		>The GameEngine has the Loader with has loaded all the external Files
	 * 		>The GameEngine is the way you communicate to the NP9 GameEngine
	 * 
	 * 	@NOTE: ExtremePotatoCounter_Engine eventually extends EventDispatcher not a DisplayObject.
	 * 		>So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  4.02.2009
	 */
	 
	public class ExtremePotatoCounter_Engine extends GameEngine
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const INTRO_SOUND:String = "introsound";
		public static const MENU_SCORE_SCR:String = "mSendScoreScreen";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mGameObjectVC:ViewContainer;
		protected var mQuitBtn:NeopetsButton;
		protected var mSendScoreBtn:NeopetsButton;
		protected var mLockButtons:Boolean;
		
		protected var mMusicFlag:Boolean = true; // added 2/24/2010. This fixes the previous bug issues with the toggle button. 
		
		protected var prevMenu:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ExtremePotatoCounter_Engine():void
		{
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @NOTE: This will Start the CleanUp of Objects for Quittting the Game
		 */
		 
		public function cleanUpEngineDemo():void
		{
			mQuitBtn = null;
			mGameObjectVC.cleanUpAllUI();
			
			cleanupGameEngine();		
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setGameVars():void
		{	
			mGameObjectVC = new ViewContainer("GameScreen");
			mLockButtons = false;	
		}
		
		/**
		 * @Note: This is called by GameEngine once:
		 * 		>All soundFiles are loaded, 
		 * 		>Congfig file is ready,
		 * 		>All external assets are loaded and can be in this ApplicationDomain (Depends on the Config.xml)
		 * @Note: This is the start of your Games Setup
		 */
		 
		  protected override function initChild():void 
		  {
		  	setGameVars();
		  	startGameSetup();
		  }
		  
		  /**
		 * @Note: Handles Standard Translation for Menus
		 */
		 
		override protected function setupMenus():void
		{

			var tIntroScreen:OpeningScreen = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:GameOverScreen = GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen:InstructionScreen = InstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));
			var tScoreScreen:SendScoreScreen = SendScoreScreen(mMenuManager.createMenu("mcSendScoreScreen", MENU_SCORE_SCR));
			
			//Intro Screen
			mTranslationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_INSTRUCTIONS);
			mTranslationManager.setTextField(tIntroScreen.startGameButton.label_txt, mTranslationData.IDS_PLAYBUTTON);
			mTranslationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT);
			mTranslationManager.setTextField(tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME);
			
			//Instruction Screen
			mTranslationManager.setTextField(tInstructionScreen.returnBtn.label_txt, mTranslationData.IDS_BACKBUTTON);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField, mTranslationData.IDS_INSTRUCTIONS_CONTENT);
			
			//In Game Screen
			mTranslationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT);
			
			//Game Over Screen
			mTranslationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationData.FGS_GAME_OVER_MENU_RESTART_GAME);
			mTranslationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_SENDSCORE);
			
			extendMenus();
		}
		  
		  /**
		  * @Note: From Each Game Object when they are clicked
		  * @param		evt.oData.SCORE		int			The GameObj Score
		  * @param		evt.oData.ID		String		The GameObj ID
		  */
		  
		  protected function addScore(evt:CustomEvent):void
		  {
		  		ScoreManager.instance.changeScore(evt.oData.SCORE);
		  }
		  
		  /**
		 * @Note: This is going to pull objects out of the externalLibrary
		 * 		> Since the ExternalAssets are loaded into the Parent Application Domain, 
		 * 		> you can just access an item in the library.
		 */
		 
		  protected override function startGameSetup():void 
		  {
		 	gameSetupDone();
		  }
		  
		  /**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  *		> ReOrders the ViewContainers
		  * 	> Adds the GameDemo View Contaienr to the GameEngines ViewContainer
		  * 	> Tells the GameEngine it is ready
		  * */
		  
		  protected function gameSetupDone():void
		  {
		  	mGameObjectVC.reOrderDisplayList();
		  	
		  	var tGameScreen:GameScreen = MenuManager.instance.getMenuScreen(MenuManager.MENU_GAME_SCR);
		  	tGameScreen.addChildAt(mGameObjectVC,tGameScreen.numChildren);
		   	completedSetup();
		  }
		  
		
		 //--------------------------------------
		//  OVERRIDE PROTECTED INSTANCE METHODS (FROM THE GAME ENGINE)
		//--------------------------------------
		
		/**
		 * @Note Events from the Menus that are from Buttons that can effect the Game
		 * @param		evt.oData.EVENT		String 		The Name of the Button that was pressed in the Menus
		 */
		 
		 override protected function onMenuButtonEvent (evt:CustomEvent):void
		 {
		 	switch (evt.oData.EVENT)
		 	{
		 		case "startGameButton":  // INTRO Scene
					startGame();
				break;
				case "quitGameButton":  // GAME SCENE
					quitGame();
				break;
				case "playAgainBtn":  // Game Over SCENE
					restartGame();
				break;
				case "reportScoreBtn": // Game Over SCENE
					mMenuManager.menuNavigation(MENU_SCORE_SCR);
					reportScore();
				break;
					case "musicToggleBtn":  // INTRO SCENE
					toggleMusic();
				break;
				case "soundToggleBtn": // INTRO SCENE
					toggleSound();
				break;
		 	}
		 	
		 	extraMenuButtons (evt.oData.EVENT);
		 	
		 }
		
		 /**
		 * @Menu Navigation can trigger Events if Needed
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 * updated 2-24-2010 to include mMusicFlag since toggle btn wasn't working correctly
		 */
		  
		 protected override function onMenuNavigationEvent (evt:CustomEvent):void
		 {
		 	
			var tIntroScreen:OpeningScreen;
			
		 	switch (evt.oData.MENU)
		 	{
		 		case MenuManager.MENU_GAMEOVER_SCR:		// FIRST TIME GOING TO THE END SCREEN , NEED TO SEND GAME OVER TO SERVER
		 			mGamingSystem.sendTag (mRootMC.END_GAME_MSG);	
		 			var tGameOverScreen:GameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as GameOverScreen;
					tGameOverScreen.gotoAndPlay("shown");
		 			tGameOverScreen.toggleInterfaceButtons(true);
		 			mSoundManager.stopSound(INTRO_SOUND);
		 		break;
		 		case MenuManager.MENU_INTRO_SCR:
					// replaced music loop with intro sound track
		 			if(prevMenu != MenuManager.MENU_INSTRUCT_SCR) {
						tIntroScreen = mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR) as OpeningScreen;
						tIntroScreen.gotoAndPlay(1);
						// start intro sound
						mSoundManager.soundPlay(INTRO_SOUND, false);
						if(mMusicFlag) mSoundManager.changeSoundVolume(INTRO_SOUND,1);
						else mSoundManager.changeSoundVolume(INTRO_SOUND,0);
					}
		 		break;
				case MenuManager.MENU_INSTRUCT_SCR:
		 			tIntroScreen = mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR) as OpeningScreen;
					if(tIntroScreen != null) tIntroScreen.visible = true;
		 		break;
				case MenuManager.MENU_GAME_SCR:
		 			var tGameScreen:ExtremePotatoCounterGameScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR) as ExtremePotatoCounterGameScreen;
					if(tGameScreen != null) {
						tGameScreen.gamingSystem = gamingSystem;
						tGameScreen.gotoAndPlay("gameframe");
					}
		 		break;
				case MENU_SCORE_SCR:
		 			var tScoreScreen:SendScoreScreen = mMenuManager.getMenuScreen(MENU_SCORE_SCR) as SendScoreScreen;
					if(tScoreScreen != null) tScoreScreen.gotoAndPlay("shown");
		 		break;
		 	}
			
			prevMenu = evt.oData.MENU; // track previous menu
		 }
		 
		  
		  /**
		 * @NOTE: This to reset basic elements for a New Game
		 */
		 
		 protected override  function restartGame():void
		 {
		 	ScoreManager.instance.changeScoreTo(0);
		 	mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		 }
		
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 */
		 
		 protected override function startGame():void
		 {
		 	trace("StartGame")
		 	mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
		 }
		
		  /**
		 * @Note: Quit for your Game from the In Game Screen
		 */
		 
		 protected override function quitGame():void
		 {
				
		 }
		 
		 /**
		 * @Note: Need to Turn off / On  the Background Track
		 * updated 2-24-2010
		 */
		 
		 protected override function toggleMusic():void
		 {
		 		var tFlag:Boolean = mSoundManager.checkSoundState(INTRO_SOUND);
			 
		 		if (tFlag)
			 	{
			 		mSoundManager.changeSoundVolume(INTRO_SOUND,0);
			 	}
			 	
			 	if (mMusicFlag)
			 	{
			 		mMusicFlag = false;	
			 	} 
			 	else
			 	{
			 		mMusicFlag = true;
					mSoundManager.changeSoundVolume(INTRO_SOUND,1);
			 	}
			 	
				var tGameScreen:ExtremePotatoCounterGameScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR) as ExtremePotatoCounterGameScreen;
				if(tGameScreen != null) tGameScreen.noMusic = int(!mMusicFlag);
			 	
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 * updated 2-24-2010
		 */
		 
		 protected override function toggleSound():void
		 {
		 	var tFlag:Boolean = mSoundManager.checkSoundState(INTRO_SOUND);
		 	
		 	if (tFlag)
			 {
			 	mSoundManager.changeSoundVolume(INTRO_SOUND,0);
			 }
			 	
		 	if (mSoundManager.soundOverRide)
		 	{
		 		mSoundManager.soundOverRide = false;

			 	if (mMusicFlag)
			 	{
					mSoundManager.changeSoundVolume(INTRO_SOUND,1);
			 	} 
		 		
		 	}
		 	else
		 	{
		 		mSoundManager.soundOverRide = true;	
		 	}
		 
		 }
		
		  
	}
	
}
