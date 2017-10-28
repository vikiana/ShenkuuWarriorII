package com.neopets.vendor.gamepill.novastorm{

	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.sound.GameSoundManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.gameEngine.gui.Interface.*;
	import com.neopets.games.inhouse.shenkuuSideScroller.menuExt.*;
	import com.neopets.examples.gameEngineExample.reference.SoundID_demo;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.AssetTool;

	//import com.neopets.projects.gameEngine.gui.AbsMenu;
	//import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	//import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	//import com.neopets.projects.gameEngine.gui.MenuManager;

	import com.neopets.projects.np9.system.NP9_Evar;
	//import com.neopets.projects.np9.vendorInterface.NP9_VendorGameExtension;

	//import com.neopets.util.display.ViewContainer;
	//import com.neopets.util.events.CustomEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import virtualworlds.lang.TranslationData;

	/*
	   *  NovaStorm game class
	   * 
	   *  @langversion ActionScript 3.0
	   *  @playerversion Flash 9.0
	   *  @Pattern GameEngine
	   * 
	   *  @author Christopher Emirzian
	   *  @since  11.11.2009
	   */

	public class novaStormGame extends GameEngine {
		protected var mScore:NP9_Evar;
		protected var mDocumentClass:MovieClip;

		public var playSound:Boolean=true;
		public var playMusic:Boolean=true;


		// constructor

		public function novaStormGame():void {
			super();
			setGameVars();
		}
		//

		protected override function setupMenus():void {
			trace("override setup menus");
			var tIntroScreen:OpeningScreen=OpeningScreen(mMenuManager.createMenu("mcOpeningScreen",MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen=GameScreen(mMenuManager.createMenu("mcGameScreen",MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:GameOverScreen=GameOverScreen(mMenuManager.createMenu("mcGameOverScreen",MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen:InstructionScreen=InstructionScreen(mMenuManager.createMenu("mcInstructionScreen",MenuManager.MENU_INSTRUCT_SCR));

			//Intro Screen
			mTranslationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_TITLE_Instructions);
			mTranslationManager.setTextField(tIntroScreen.startGameButton.label_txt, mTranslationData.IDS_TITLE_Start);
			mTranslationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT);
			mTranslationManager.setTextField(tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME);
			mTranslationManager.setTextField(title(tIntroScreen).legal_txt, mTranslationData.IDS_COPYRIGHT_TXT);
			var tLanguageStr:String = mRootMC.neopets_GS.getFlashParam("sLang");
			trace (tLanguageStr)
			title(tIntroScreen).titleFull.gotoAndStop(tLanguageStr.toUpperCase());
			//mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).titleFull.gotoAndStop(tLanguageStr.toUpperCase());

			//Instruction Screen
			mTranslationManager.setTextField(tInstructionScreen.returnBtn.label_txt, mTranslationData.IDS_INSTRUCTIONS_Back);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField, mTranslationData.IDS_INSTRUCTION_TXT);

			//In Game Screen
			mTranslationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT);

			//Game Over Screen
			mTranslationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_GAMEOVER_PlayAgain);
			mTranslationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_GAMEOVER_SubmitScore);
		}


		// restart game

		protected override function restartGame():void {
			mScore=new NP9_Evar(0);
			mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		}

		// start game

		protected override function startGame():void {
			mScore=new NP9_Evar(0);
			mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
		}

		// win game (called from game.as)

		public function winGame() {
			var game=mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			game.endGame();

			var gameOver=mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR);

			var score=game.gamePlayer.score;
			var level=game.levelNum;
			var enemyCount=game.totalEnemyDestroyCount;
			var jewelCount=game.totalJewelCollectCount;
			
			mTranslationManager.setTextField(gameOver.gameOverTxt.text, mTranslationData.IDS_GAMEOVER_WinGame)

			//gameOver.gameOverTxt.text.htmlText=mTranslationData.IDS_GAMEOVER_WinGame;
			
			mTranslationManager.setTextField(gameOver.stats.text, mTranslationData.IDS_GAMEOVER_FinalScore+"\n"+score+"\n\n"+mTranslationData.IDS_GAMEOVER_LevelsCompleted+"\n"+level+"\n\n"+mTranslationData.IDS_GAMEOVER_EnemiesBlasted+"\n"+enemyCount+"\n\n"+mTranslationData.IDS_GAMEOVER_GemsCollected+"\n"+jewelCount)
			
			//gameOver.stats.text.htmlText=mTranslationData.IDS_GAMEOVER_FinalScore+"\n"+score+"\n\n"+mTranslationData.IDS_GAMEOVER_LevelsCompleted+"\n"+level+"\n\n"+mTranslationData.IDS_GAMEOVER_EnemiesBlasted+"\n"+enemyCount+"\n\n"+mTranslationData.IDS_GAMEOVER_GemsCollected+"\n"+jewelCount;

			mMenuManager.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
		}

		// game over (called from game.as)

		public function gameOver() {
			quitGame();
		}

		// quit button pressed

		protected override function quitGame():void {
			var game=mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			game.endGame();
			var gameOver=mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR);
			trace(gameOver);
			var score=game.gamePlayer.score;
			var level=game.levelNum;
			var enemyCount=game.totalEnemyDestroyCount;
			var jewelCount=game.totalJewelCollectCount;
			
			mTranslationManager.setTextField(gameOver.gameOverTxt.text, mTranslationData.IDS_GAMEOVER_WinGame)
			mTranslationManager.setTextField(gameOver.stats.text, mTranslationData.IDS_GAMEOVER_FinalScore+"\n"+score+"\n\n"+mTranslationData.IDS_GAMEOVER_LevelsCompleted+"\n"+level+"\n\n"+mTranslationData.IDS_GAMEOVER_EnemiesBlasted+"\n"+enemyCount+"\n\n"+mTranslationData.IDS_GAMEOVER_GemsCollected+"\n"+jewelCount)
			//gameOver.gameOverTxt.text.htmlText=mTranslationData.IDS_GAMEOVER_GameOver;
			//gameOver.stats.text.htmlText=mTranslationData.IDS_GAMEOVER_FinalScore+"\n"+score+"\n\n"+mTranslationData.IDS_GAMEOVER_LevelsCompleted+"\n"+level+"\n\n"+mTranslationData.IDS_GAMEOVER_EnemiesBlasted+"\n"+enemyCount+"\n\n"+mTranslationData.IDS_GAMEOVER_GemsCollected+"\n"+jewelCount;
			mMenuManager.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
		}

		// send score to NeoPets

		protected override function reportScore():void {
			var game=mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			mScore.changeTo(game.gamePlayer.score);
			mDocumentClass.neopets_GS.sendScore(mScore.show());

		}

		// toggle music playback

		protected override function toggleMusic():void 
		{
			var title=mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR);

			if (playMusic==true) {
				playMusic=false;
			} else {
				playMusic=true;
			}
			if (title.visible==true) 
			{
				if (playMusic==true) {
					title.startMusicLoop();
				} else {
					title.stopMusicLoop();
				}
			}
		}

		// toggle sound playback

		protected override function toggleSound():void {
			if (playSound==true) {
				playSound=false;
			} else {
				playSound=true;
			}
		}

		// set game vars

		protected function setGameVars():void {
			trace(mTranslationData);
			//mTranslationData=new TranslationInfo();
		}

		// setup vars

		protected override function initChild():void 
		{
			
			mDocumentClass=mRootMC;
			
			var title=mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR);
      		title.setContainer(this);

			var tGameScreen:GameScreen=mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			var game=mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			game.setContainer(this);

			gameSetupDone();
		}

		// setup game

		protected function gameSetupDone():void 
		{
			
			trace ("what is this", mTranslationData.IDS_STORE_UpgradeDesc5)
			completedSetup();
			/*
			mDocumentClass.addChildAt(MovieClip(this),mDocumentClass.numChildren);
			mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
			
			var tLanguageStr:String=mDocumentClass.neopets_GS.getFlashParam("sLang");
			
			if (tLanguageStr==null) {
			tLanguageStr=mDocumentClass.mcBIOS.game_lang;
			}
			mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).titleFull.gotoAndStop(tLanguageStr.toUpperCase());
			*/
		}
	}
}