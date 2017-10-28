/* AS3
Copyright 2008
*/

package com.neopets.games.inhouse.FaerieBubblesAS3{
	
	
	import com.neopets.examples.gameEngineExample.gameObjects.IGameObject;
	import com.neopets.examples.gameEngineExample.reference.SoundID_demo;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.*;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.GameSoundManager;
	import com.neopets.games.inhouse.FaerieBubblesAS3.game.FaerieBubble;
	import com.neopets.games.inhouse.FaerieBubblesAS3.game.Sounds;
	import com.neopets.games.inhouse.FaerieBubblesAS3.game.ExtGameOverScreen;

	/**
	 *This is an Example of the Main Game Code for a Demo. 
	 *  @NOTE: The GameEngine is going to do it own process first, then once it is done, it will trigger
	 *  this class through the initChild() Function.
	 * 
	 *@NOTE: This extends GameEngine so you have access to most of the GameEngine Functions.
	 *  >The GameEngine has the SoundManager
	 * >The GameEngine has the Loader with has loaded all the external Files
	 * >The GameEngine is the way you communicate to the NP9 GameEngine
	 * 
	 * @NOTE: gameEngineDemo eventually extends EventDispatcher not a DisplayObject.
	 * >So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 * 
	 *@langversion ActionScript 3.0
	 *@playerversion Flash 9.0
	 *@Pattern GameEngine
	 * 
	 *@author Clive Henrick
	 *@since  4.02.2009
	 */

	public class FaerieBubblesAS3Engine extends GameEngine {

		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var mFaerieBubblesGame : FaerieBubble;
		private var mGameObjectArray:Array;
		private var mGameObjectVC:ViewContainer;
		protected var mQuitBtn:NeopetsButton;
		protected var mSendScoreBtn:NeopetsButton;
		protected var mLockButtons:Boolean;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		/**
		 *@Constructor
		 */

		public function FaerieBubblesAS3Engine():void {
			super( );
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

		public function cleanUpEngineDemo():void {
			mQuitBtn = null;
			mGameObjectVC.cleanUpAllUI();

			for each (var tGameObject:IGameObject in mGameObjectArray) {
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

		private function setGameVars():void {
			mGameObjectArray = [];
			mGameObjectVC = new ViewContainer("GameScreen");
			mLockButtons = false;
		}
		/**
		 * @Note: This is called by GameEngine once:
		 * >All soundFiles are loaded, 
		 * >Congfig file is ready,
		 * >All external assets are loaded and can be in this ApplicationDomain (Depends on the Config.xml)
		 * @Note: This is the start of your Games Setup
		 */

		protected override function initChild():void {
			MenuManager.instance.addEventListener(MenuManager.instance.MENU_BUTTON_EVENT, onMenuSelected, false, 0, true);
			setGameVars();
			startGameSetup();
		}
		/**
		  * @Note: From Each Game Object when they are clicked
		  * @paramevt.oData.SCOREintThe GameObj Score
		  * @paramevt.oData.IDStringThe GameObj ID
		  */

		protected function addScore(evt:CustomEvent):void {
			ScoreManager.instance.changeScore(evt.oData.SCORE);
		}
		/**
		 * @Note: This is going to pull objects out of the externalLibrary
		 * > Since the ExternalAssets are loaded into the Parent Application Domain, 
		 * > you can just access an item in the library.
		 */

		protected override function startGameSetup():void {
			mFaerieBubblesGame = new FaerieBubble ();
			mFaerieBubblesGame.setRoot(mRootMC);
			mFaerieBubblesGame.setup();
			gameSetupDone( );
		}
		/**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  *> ReOrders the ViewContainers
		  * > Adds the GameDemo View Contaienr to the GameEngines ViewContainer
		  * > Tells the GameEngine it is ready
		  */

		protected function gameSetupDone():void {
			GameSoundManager.soundPlay(GameSoundManager.musicOn, Sounds.SND_LOOP, true);
			mGameObjectVC.reOrderDisplayList();
			var tGameScreen:GameScreen = MenuManager.instance.getMenuScreen(MenuManager.MENU_GAME_SCR)
			tGameScreen.addChildAt(mGameObjectVC,tGameScreen.numChildren);
			tGameScreen.addChild( mFaerieBubblesGame );
			completedSetup();
		}
		//--------------------------------------
		//  OVERRIDE PROTECTED INSTANCE METHODS (FROM THE GAME ENGINE)
		//--------------------------------------
		
		
		 /**
		 * @Menu Navigation can trigger Events if Needed
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 */
		 
		 protected override function onMenuNavigationEvent (evt:CustomEvent):void
		 {
		 	switch (evt.oData.MENU)
		 	{
		 		case MenuManager.MENU_GAMEOVER_SCR:		// FIRST TIME GOING TO THE END SCREEN , NEED TO SEND GAME OVER TO SERVER
		 			mGamingSystem.sendTag (mRootMC.END_GAME_MSG);
		 			var tGameOverScreen:ExtGameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as ExtGameOverScreen;
		 			tGameOverScreen.toggleInterfaceButtons(true);
					tGameOverScreen.finalScore.text = (ScoreManager.instance.getValue()).toString();;
		 		break;
		 		case MenuManager.MENU_INTRO_SCR:
		 		break;
		 	}	
		 }
		 
		 /**
		  *	override extendMenus to continue the further translation on menu items
		  **/
		  
		protected override function setupMenus():void
		{
			var tIntroScreen:OpeningScreen = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:ExtGameOverScreen = ExtGameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			
						
			//Intro Screen
			mTranslationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_help);
			mTranslationManager.setTextField(tIntroScreen.startGameButton.label_txt, mTranslationData.IDS_playgame);
			mTranslationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT);
			mTranslationManager.setTextField(tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME);
			
			
			//In Game Screen
			mTranslationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT);
			
			//Game Over Screen
			mTranslationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_BTN_PLAYAGAIN);
			mTranslationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_BTN_SENDSCORE);
			mTranslationManager.setTextField(tGameOverScreen.finalScoreText, mTranslationData.IDS_FINAL_SCORE);
			
			
		}
		
		

		
		/**
		 * @NOTE: This to reset basic elements for a New Game
		 */

		protected override function restartGame():void {
			ScoreManager.instance.changeScoreTo(0);
			mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		}
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 */

		protected override function startGame():void {
			trace("StartGame");
			mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
			mFaerieBubblesGame.startGame( );
		}
		/**
		 * @Note: Quit for your Game from the In Game Screen
		 */

		protected override function quitGame():void 
		{
			MenuManager.instance.menuNavigation(MenuManager.MENU_GAMEOVER_SCR)
		}
		/**
		 * @Note: Need to Turn off / On  the Background Track
		 */
		 
		 protected override function toggleMusic():void
		 {
			 GameSoundManager.musicOn = GameSoundManager.musicOn? false: true;
			 if (GameSoundManager.musicOn)
			 {
				GameSoundManager.soundPlay(GameSoundManager.musicOn, Sounds.SND_LOOP, true);
			 }
			 else
			 {
				GameSoundManager.stopSound(Sounds.SND_LOOP);   
			 }
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 */
		 
		 protected override function toggleSound():void
		 {
		 	GameSoundManager.soundOn = GameSoundManager.soundOn? false: true;
		 }
		
		protected function onMenuSelected(evt:CustomEvent):void
		{
			switch (evt.oData.EVENT)
			{
				case "instructionsButton":	//this overrides the instructions funciton... sort of
					mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
					mFaerieBubblesGame.startGame( true );
					break;
			}
		}
		
	}
}