﻿/* AS3
Copyright 2008
*/

package com.neopets.games.inhouse.suteksTomb{
	
	import flash.display.MovieClip;
	
	import com.neopets.games.inhouse.suteksTomb.game.AssetTool;
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
	import com.neopets.games.inhouse.suteksTomb.game.SutekTomb;
	import com.neopets.games.inhouse.suteksTomb.game.Sounds;
	import com.neopets.games.inhouse.suteksTomb.game.extendedMenus.ExtGameOverScreen;
	import com.neopets.games.inhouse.suteksTomb.game.extendedMenus.ExtOpeningScreen;
	import com.neopets.games.inhouse.suteksTomb.game.extendedMenus.ExtInstructionScreen;
	//

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

	public class SuteksTombEngine extends GameEngine {

		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var mSutek : SutekTomb;
		private var mGameObjectArray:Array;
		private var mGameObjectVC:ViewContainer;
		protected var mQuitBtn:NeopetsButton;
		protected var mSendScoreBtn:NeopetsButton;
		protected var mLockButtons:Boolean;
		protected var mZenmode:Boolean;
		protected var mDifficulty:int;
		protected var sunOpen:MovieClip;	//for transition open

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		/**
		 *@Constructor
		 */

		public function SuteksTombEngine():void 
		{
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

		private function setGameVars():void 
		{
			trace (mViewContainer.numChildren)
			

			sunOpen = AssetTool.getMC("sunblendOpen");
			mViewContainer.addDisplayObjectUI(sunOpen,1001,"Open");
			//sunOpen.visible = false;
			//mViewContainer
			//mGameObjectArray = [];
			//mGameObjectVC = new ViewContainer("GameScreen");
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
			mSutek = new SutekTomb ();
			mSutek.setRoot(mRootMC, this);
			mSutek.setup();
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
			//mGameObjectVC.reOrderDisplayList();
			var tGameScreen:GameScreen = MenuManager.instance.getMenuScreen(MenuManager.MENU_GAME_SCR)
			//tGameScreen.addChildAt(mGameObjectVC,tGameScreen.numChildren);
			tGameScreen.addChild( mSutek );
			//playSunScreen()
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
			var tIntroScreen:ExtOpeningScreen = ExtOpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:ExtGameOverScreen = ExtGameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen:ExtInstructionScreen = ExtInstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));
			
						
			//Intro Screen
			mTranslationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_help);
			mTranslationManager.setTextField(tIntroScreen.startGameEasyButton.label_txt, mTranslationData.IDS_playgameeasy);
			mTranslationManager.setTextField(tIntroScreen.startGameHardButton.label_txt, mTranslationData.IDS_playgamehard);
			mTranslationManager.setTextField(tIntroScreen.startGameZenButton.label_txt, mTranslationData.IDS_playgamezen);
			
			mTranslationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT);
			mTranslationManager.setTextField(tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME);
			
			//Instruction screen
			mTranslationManager.setTextField(tInstructionScreen.returnBtn.label_txt, mTranslationData.IDS_back);
			mTranslationManager.setTextField(tInstructionScreen.longText_txt, mTranslationData.IDS_helplongtext);
			mTranslationManager.setTextField(tInstructionScreen.longText2_txt, mTranslationData.IDS_helplongtext2);
			mTranslationManager.setTextField(tInstructionScreen.longText3_txt, mTranslationData.IDS_helplongtext3);
			mTranslationManager.setTextField(tInstructionScreen.longText4_txt, mTranslationData.IDS_helplongtext4);
			mTranslationManager.setTextField(tInstructionScreen.longText5_txt, mTranslationData.IDS_helplongtext5);
		
			
			//In Game Screen
			mTranslationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT);
			
			//Game Over Screen
			mTranslationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_playagain);
			mTranslationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_sendscore);
			mTranslationManager.setTextField(tGameOverScreen.finalScoreText, mTranslationData.IDS_FINAL_SCORE);
			
			
		}
		
		

		
		/**
		 * @NOTE: This to reset basic elements for a New Game
		 */

		protected override function restartGame():void 
		{
			playSunScreen()
			ScoreManager.instance.changeScoreTo(0);
			mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		}
		
		public function restartMyGame():void
		{
			restartGame();
		}
		
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 */

		protected override function startGame():void {
			trace("StartGame");
			mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
			mSutek.startGame(mDifficulty, mZenmode );
		}
		/**
		 * @Note: Quit for your Game from the In Game Screen
		 */

		protected override function quitGame():void 
		{
			MenuManager.instance.menuNavigation(MenuManager.MENU_GAMEOVER_SCR)
		}
		
		public function quitMyGame():void
		{
			playSunScreen()
			quitGame()
		}
		
		/**
		 * @Note: Need to Turn off / On  the Background Track
		 */
		 
		 protected override function toggleMusic():void
		 {
			 GameSoundManager.musicOn = GameSoundManager.musicOn? false: true;
			 if (GameSoundManager.musicOn)
			 {
				//GameSoundManager.soundPlay(GameSoundManager.musicOn, Sounds.SND_LOOP, true);
			 }
			 else
			 {
				//GameSoundManager.stopSound(Sounds.SND_LOOP);   
			 }
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 */
		 
		 protected override function toggleSound():void
		 {
		 	GameSoundManager.soundOn = GameSoundManager.soundOn? false: true;
		 }
		 
		 /**
		  *	This sis basically transition gimmic... just fades out orange screen
		  **/
		 public function playSunScreen():void
		 {
			 sunOpen.visible = true;
			 sunOpen.gotoAndPlay(1);
		 }
		 
		 protected function onMenuSelected(evt:CustomEvent):void
		 {
			trace (evt.oData.EVENT)
			switch (evt.oData.EVENT)
			{
				case "startGameEasyButton":
					playSunScreen()
					mDifficulty = 0
					mZenmode = false
					startGame();
				break;
				case "startGameHardButton":
					playSunScreen()
					mDifficulty = 1
					mZenmode = false
					startGame();
				break;
				case "startGameZenButton":
					playSunScreen()
					mDifficulty = 1
					mZenmode = true
					startGame();
				break;
				case "instructionsButton":
					playSunScreen()
					ExtInstructionScreen(MenuManager.instance.getMenuScreen(MenuManager.MENU_INSTRUCT_SCR)).matchSoundSetting()
				break;
								
				case "returnBtn":
					playSunScreen()
				break;
			}
		}
		
	}
}