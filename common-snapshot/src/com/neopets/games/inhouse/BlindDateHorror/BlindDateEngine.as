/* AS3
	Copyright 2008
*/

package  com.neopets.games.inhouse.BlindDateHorror
{
	import com.neopets.examples.gameEngineExample.gameObjects.IGameObject;
	import com.neopets.examples.gameEngineExample.reference.SoundID_demo;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
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
	 * 	@NOTE: gameEngineDemo eventually extends EventDispatcher not a DisplayObject.
	 * 		>So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  4.02.2009
	 */
	 
	public class BlindDateEngine extends GameEngine
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		// 7/22 - Viv's version
		public static const MENU_ENDLEVEL_SCR:String = "mEndLevelScreen"; // shouldn't be mcEndLevelScreen, since that is the linkage name of the symbol in the library
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mGameObjectArray:Array;
		private var mGameObjectVC:ViewContainer;
		private var blindDateGame:BlindDateGame;
		
		
		
		protected var mQuitBtn:NeopetsButton;
		protected var mSendScoreBtn:NeopetsButton;
		protected var mLockButtons:Boolean;
		
		protected var mMusicFlag:Boolean = true; // added 2/24/2010. This fixes the previous bug issues with the toggle button. 
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function BlindDateEngine():void
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
		 * @NOTE: This will Start the CleanUp of Objects for quitting the Game
		 */
		 
		public function cleanUpEngineDemo():void
		{
			mQuitBtn = null;
			mGameObjectVC.cleanUpAllUI();
			
			for each (var tGameObject:IGameObject in mGameObjectArray)
			{
				tGameObject.doCleanUp();	
			}
			
			mGameObjectArray = [];
			
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
			mGameObjectArray = [];
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
		  
		  // overridden from NP9_VendorGameExtension
		   
		// add a new menu/screen - end of level screen
		  protected override function extendMenus():void 
		  {
			  var tEndLevelScreen : EndLevelScreen = EndLevelScreen(mMenuManager.createMenu("mcEndLevelScreen", BlindDateEngine.MENU_ENDLEVEL_SCR));
			  
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
			blindDateGame = new BlindDateGame();
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
			trace("blindDate game - setup: "+blindDateGame);
			tGameScreen.addChild(blindDateGame);
		   	completedSetup();
		  }
		  
		
		 //--------------------------------------
		//  OVERRIDE PROTECTED INSTANCE METHODS (FROM THE GAME ENGINE)
		//--------------------------------------
		
		 /**
		 * @Menu Navigation can trigger Events if Needed
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 * updated 2-24-2010 to include mMusicFlag since toggle btn wasn't working correctly
		 */
		  
		 protected override function onMenuNavigationEvent (evt:CustomEvent):void
		 {
		 		
		 	switch (evt.oData.MENU)
		 	{
		 		case MenuManager.MENU_GAMEOVER_SCR:		// FIRST TIME GOING TO THE END SCREEN , NEED TO SEND GAME OVER TO SERVER
		 			mGamingSystem.sendTag (mRootMC.END_GAME_MSG);	
		 			var tGameOverScreen:GameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as GameOverScreen;
		 			tGameOverScreen.toggleInterfaceButtons(true);
		 		break;
		 		case MenuManager.MENU_INTRO_SCR:
					 if (mMusicFlag)
			 		{
			 			var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_demo.SND_MUSIC);
		 	
		 				if ( !tFlag)
						 {
							// turn off soundtrack while testing
			 				//mSoundManager.soundPlay(SoundID_demo.SND_MUSIC, true);	
						 }
			 		} 

		 		break;
		 	}	
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
		 	trace("Start Game")
		 	mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
			blindDateGame.startGame();
			
		 }
		 
		
		
		  /**
		 * @Note: Quit for your Game from the In Game Screen
		 */
		 
		 protected override function quitGame():void
		 {
			  trace("quitGame()");
			  // end and reset game 
			  blindDateGame.endLevelOne();
			  blindDateGame.endTimer();
			  blindDateGame.resetLevelOne();
		 }
		 
		   /**
		 * @Note: Need to Turn off / On  the Background Track
		 * updated 2-24-2010
		 */
		 
		 protected override function toggleMusic():void
		 {
		 		var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_demo.SND_MUSIC);
			 
		 		if (tFlag)
			 	{
			 		mSoundManager.stopSound(SoundID_demo.SND_MUSIC);
			 	}
			 	
			 	if (mMusicFlag)
			 	{
			 		mMusicFlag = false;	
			 	} 
			 	else
			 	{
			 		mMusicFlag = true;
			 		mSoundManager.soundPlay(SoundID_demo.SND_MUSIC, true);	
			 	}
			 	
			 	
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 * updated 2-24-2010
		 */
		 
		 protected override function toggleSound():void
		 {
		 	var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_demo.SND_MUSIC);
		 	
		 	if (tFlag)
			 {
			 	mSoundManager.stopSound(SoundID_demo.SND_MUSIC);
			 }
			 	
		 	if (mSoundManager.soundOverRide)
		 	{
		 		mSoundManager.soundOverRide = false;

			 	if (mMusicFlag)
			 	{
			 		mSoundManager.soundPlay(SoundID_demo.SND_MUSIC, true);	
			 	} 
		 		
		 	}
		 	else
		 	{
		 		mSoundManager.soundOverRide = true;	
		 	}
		 
		 }
		
		  
	}
	
}
