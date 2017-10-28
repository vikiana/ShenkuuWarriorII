//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.advervideo.pc.gui.GameoverScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.ChooseLevelScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.ChooseModeScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.EndLevelPopup;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.InstructionsScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.IntroScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.Popup;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.SW2_GameOverScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.SW2_GameScreen;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.ScorePopup;
	import com.neopets.games.inhouse.shenkuuwarrior2.utils.control_panel;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.SendScoreScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * public class ShenkuuWarrior2_GameEngine extends GameEngine
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ShenkuuWarrior2_GameEngine extends GameEngine
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public static const MENU_CHOOSEMODE_SCR:String = "mChooseModeScreen";
		public static const MENU_CHOOSELEVEL_SCR:String = "mChooseLevelScreen";
		public static const MENU_SCORE_SCR:String = "mScoreScreen";
		public static const MENU_SENDSCORE_SCR:String = "mSendScoreScreen";
		public static const MENU_ENDLEVEL_SCR:String = "mEndlevelScreen";
		
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var _game:ShenkuuWarrior2_Game;
		private var _gameMode:String;
		private var _controller:controlpanel;
		
		
		//flags
		private var _musicIsOn:Boolean = true;
		private var _soundsIsOn:Boolean = true;
		
		private var _loopIsPlaying:Boolean = false;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ShenkuuWarrior2_GameEngine extends GameEngine instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ShenkuuWarrior2_GameEngine()
		{
			super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
	
	
		
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		override protected function setupMenus( ):void
		{		
			trace( "ShenkuuWarrior2_GameEngine says: setupMenus called" );
			//var tBallClass         : Class             = getDefinitionByName( "TestAsset" ) as Class;
			//var tBall              : MovieClip         = new tBallClass( );
			
			var tIntroScreen       : IntroScreen     = IntroScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen        :SW2_GameScreen        = SW2_GameScreen (mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen    :SW2_GameOverScreen    = SW2_GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen : InstructionsScreen = InstructionsScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));
			
			//Game Over Screen
			mTranslationManager.setTextField( tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_BTN_PLAYAGAIN );
			mTranslationManager.setTextField( tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_BTN_SENDSCORE );
			
			extendMenus( );
		}	
		
		override protected function extendMenus():void {
			
			//Choose Level Screen
			var tChooseLevelScreen : ChooseLevelScreen = ChooseLevelScreen(mMenuManager.createMenu("mcChooseLevelScreen", MENU_CHOOSELEVEL_SCR));
			mTranslationManager.setTextField( tChooseLevelScreen.forestLevelBtn.label_txt, mTranslationData.IDS_BTN_FIRSTLEVEL );
			mTranslationManager.setTextField( tChooseLevelScreen.mountainLevelBtn.label_txt, mTranslationData.IDS_BTN_SECONDLEVEL );
			mTranslationManager.setTextField( tChooseLevelScreen.icedMountainLevelBtn.label_txt, mTranslationData.IDS_BTN_THIRDLEVEL );
			mTranslationManager.setTextField( tChooseLevelScreen.skyLevelBtn.label_txt, mTranslationData.IDS_BTN_FOURTHLEVEL );
			
			//choose mode screen
			//score popup
			var tChooseMode : ChooseModeScreen = ChooseModeScreen(mMenuManager.createMenu("mcChooseModeScreen", MENU_CHOOSEMODE_SCR));
			
			//score popup
			var tScorePopup : ScorePopup = ScorePopup(mMenuManager.createMenu("mcScorePopup", MENU_SCORE_SCR));
			
			//end level popup
			var tEndLevelPopup : EndLevelPopup = EndLevelPopup(mMenuManager.createMenu("mcEndLevelPopup", MENU_ENDLEVEL_SCR));
			
			//send score screen
			var tSendScoreScreen : SendScoreScreen = SendScoreScreen(mMenuManager.createMenu("mcSendScoreScreen", MENU_SENDSCORE_SCR));
			
			//intro screen 
			mTranslationManager.setTextField(mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).chooseModeButton.label_txt, mTranslationData.IDS_BTN_START);
			IntroScreen(mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR)).mcTransLogo.gotoAndStop(mTranslationManager.languageCode);
			
		}
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		override protected function initChild ():void {
			mMenuManager.addEventListener(mMenuManager.MENU_BUTTON_EVENT, onMenuButtonClicked, false, 0, true);
			_game = new ShenkuuWarrior2_Game(mRootMC);
			_game.addEventListener(GameInfo.GET_LEVELS_SCREEN, getLevelsScreen);
			//listeners
			_game.addEventListener(GameInfo.GET_POPUP, getPopup, false, 0, true);
			var gm:SW2_GameScreen = MenuManager.instance.getMenuScreen("mGameScreen");
			gm.addChildAt(_game, gm.numChildren-1);
			//CONTROL PANEL FOR LEVEL DESIGN:::::::::::::::::::::::::::::
			//createController ();
			//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			//start music
			startMusic(true);
			//go to intro screen
			completedSetup();
		}
		
		override protected function startGame():void {
			trace("StartGame")
			startMusic(false);
			mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
			mRootMC.neopets_GS.sendTag (mRootMC.START_GAME_MSG);
			_game.init(XML (mConfigXML.LEVELS));
		}
		
		
		/**
		 * 
		 * @Note: toggle background music on and off
		 */
		override protected function toggleMusic( ):void { 
			if (_musicIsOn){
				startMusic(false)
				_musicIsOn = false;
			} else {
				startMusic(true)
				_musicIsOn = true;
			};
		}
		
		/**
		 * 
		 * @Note: toggle all sounds on and off 
		 */		
		override protected function toggleSound( ):void { 
			if (_soundsIsOn){
				_game.isSoundOn = false;
				_soundsIsOn = false;
			} else {
				_game.isSoundOn = true;
				_soundsIsOn = true;
			};
		}
		
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: called when Restart Game link in scoring meter is clicked
		 * @Note: takes player back to intro screen
		 */		
		override protected function restartGame( ):void { 
			trace ("Restart Game");
			_game.cleanUp();
			_game.resetScore();
			_game.addEventListener(GameInfo.GET_POPUP, getPopup);
			mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
			_game.levelNo = 0;
		}
		
		private function startMusic (flag:Boolean):void {
			if (_musicIsOn){
				if (flag && !_loopIsPlaying){
					mSoundManager.stopSound(GameInfo.MENU_LOOP);
					mSoundManager.soundPlay(GameInfo.MENU_LOOP, true, 0,0);
					_loopIsPlaying = true;
				} else if (!flag && _loopIsPlaying) {
					mSoundManager.fadeOutSound(GameInfo.MENU_LOOP, 2);
					_loopIsPlaying = false;
				}
			}
		}
		
		override protected function quitGame():void	{ 
			startMusic(true);
			mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR).init(_game.getScore());
			_game.removeEventListener(GameInfo.GET_POPUP, getPopup);
			_game.cleanUp();
			_game.levelNo = 0;
		}
		
		protected function restartLevel ():void {
			_game.restartLevel();
		}
		
		protected function nextLevel ():void {
			_game.pause(false);
			_game.cleanUp();
			startGame();
		}
		
		override protected function reportScore( ):void
		{
			mMenuManager.menuNavigation(MENU_SENDSCORE_SCR);
			mGamingSystem.sendScore( ScoreManager.instance.getValue( ) ); 	
			mRootMC.sendScoringMeterToFront( );		
			mRootMC.neopets_GS.sendTag (mRootMC.END_GAME_MSG);
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		//CONTROL PANEL FOR LEVEL DESIGN  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		/*private function createController ():void {
			//var cclass:Class = Class (getDefinitionByName("controlpanel"));
			_controller = new controlpanel();
			_controller.init(_game);
			_controller.x = 500;
			_controller.addEventListener (control_panel.APPLY, displayApply, false, 0, true);
			_game.addEventListener (control_panel.UPDATEFROMPARAMS, updateFromParams, false, 0, true);
			mRootMC.addChild(_controller);
		}
		
		private function updateFromParams (e:Event):void {
			_controller.updateFromParams();
		}
		
		private function displayApply(e:Event):void {
			var aclass:Class = Class (getDefinitionByName("applied"));
			var sign:Sprite = new aclass ();
			mRootMC.addChild(sign);
			Tweener.addTween(sign, {alpha:0, time:2, transition:"easeoutcubic", onComplete:removeSign, onCompleteParams:[sign]});
		}
		private function removeSign (sign:Sprite):void {
			mRootMC.removeChild (sign);
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		private function onMenuButtonClicked (e:CustomEvent):void {
			if (_soundsIsOn){
				SoundManager.instance.soundPlay(GameInfo.BUTTON_SOUND);
			}
			switch (e.oData.EVENT)
			{
				case "chooseModeButton":  // INTRO Scene
					mMenuManager.menuNavigation(MENU_CHOOSEMODE_SCR);
					break;
				case "trainingModeBtn":
					_game.levelNo = -1;
					startGame();
					break;
				case "zenModeBtn":
					_game.levelNo = 2;
					startGame();
					break;
				case "forestLevelBtn":
					_game.levelNo = -1;
					startGame();
					break;
				case "mountainLevelBtn":
					_game.levelNo = 0;
					startGame();
					break;
				case "icedMountainLevelBtn":
					_game.levelNo = 1;
					startGame();
					break;
				case "skyLevelBtn":
					_game.levelNo = 2;
					startGame();
					break;
				case "retryBtn":
					restartLevel();
					break;
				case "nextLevelBtn":
					nextLevel();
					break;
				case "reportScoreBtn":
					_game.stopMusic();
					break;
			}
		
		}
		
		private function getPopup (e:CustomEvent):void {
			var popup:Popup = Popup(mMenuManager.getMenuScreen(e.oData.screen));
			popup.visible = true;
			e.oData.data.levelNo = _game.levelNo;
			popup.init(e.oData.data);
			popup.enter();
		}
		
		private function getLevelsScreen (e:Event):void {
			_game.cleanUp();
			_game.levelNo = 0;
			mMenuManager.menuNavigation(MENU_CHOOSELEVEL_SCR);
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get game():ShenkuuWarrior2_Game{
			return _game;
		}
	}
}