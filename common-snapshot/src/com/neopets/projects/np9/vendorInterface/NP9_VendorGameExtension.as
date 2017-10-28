
/* AS3
	Copyright 2008
*/
package com.neopets.projects.np9.vendorInterface
{

	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This is some Neopets Functions that you will need for translation and Menu Control
	 *	You Should Have your Main Game Engine Extend this Class
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Neopets Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.10.2009
	 */
	 
	public class NP9_VendorGameExtension extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mTranslationInfo:TranslationData;
		protected var mMenuManager:MenuManager;
		protected var mDocumentClass:MovieClip;
		protected var mScore:NP9_Evar;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NP9_VendorGameExtension():void{
			super();
			setVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/** 
		 * @Note: Starts the Game Init Process.
		 * 	>> First it Sets up the Translation by Sending your TranslationList to the Engine and Waits for the Translation Engine to Tell it is loaded
		 * 
		 * @Param		pRoot		The Document Class of your Project
		 */
		 
		public function init (pRoot:MovieClip):void
		{
			trace ("vendor extension init called");
			mDocumentClass = pRoot;
			mDocumentClass.addEventListener(mDocumentClass.TRANSLATION_COMPLETE, setupTranslationComplete);
			var tTranslationURL:String = mDocumentClass.neopets_GS.getFlashParam("sBaseURL");
			mDocumentClass.setupTranslation(mTranslationInfo,tTranslationURL);
		}
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note When TranslationManager has contected to PHP and Translation is Complete.
		 * @Note: If you Have In game Items Needed for Translation, You should have them in them translated after this event
		 */
		 
		 protected function setupTranslationComplete(evt:Event):void
		 {
			
		 	var translationManager : TranslationManager = TranslationManager.instance;
		 	
		 	mDocumentClass.removeEventListener(mDocumentClass.TRANSLATION_COMPLETE, setupTranslationComplete);
		 	mTranslationInfo = TranslationData(translationManager.translationData);
		 	
		 	mMenuManager.init(mDocumentClass,mTranslationInfo);
		 	
		 	setupMenus();
		 	
		 	addChild(mMenuManager.menusDisplayObj);
		 	
		 	startGameSetup();	
		 }
		 
		
		 
		 /**
		 * @Note Events from the Menus that are from Buttons that can effect the Game
		 * @param		evt.oData.EVENT		String 		The Name of the Button that was pressed in the Menus
		 */
		 
		 protected function onMenuButtonEvent (evt:CustomEvent):void
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
		 * @Note Events from the Menus that Effect The Game
		 * @param		evt.oData.EVENT		String 		The Name of the Function that you want called
		 */
		 
		 protected function onMenuEvent (evt:CustomEvent):void
		 {
		 	switch (evt.oData.EVENT)
		 	{
		 		case "restartGame":		// From when the Restart Game Button on the Score Report Box has been Pressed
		 			restartGame();
		 		break;
		 	}
		 }
		 
		/**
		 * @Menu Navigation can trigger Events if Needed
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 */
		  
		 protected function onMenuNavigationEvent (evt:CustomEvent):void
		 {
		 		
		 	switch (evt.oData.MENU)
		 	{
		 		case MenuManager.MENU_GAMEOVER_SCR:		// FIRST TIME GOING TO THE END SCREEN , NEED TO SEND GAME OVER TO SERVER
		 			mDocumentClass.neopets_GS.sendTag (mDocumentClass.END_GAME_MSG);	
		 			var tGameOverScreen:GameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as GameOverScreen;
		 			tGameOverScreen.toggleInterfaceButtons(true);
		 		break;
		 	}	
		 }
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is all the Startup Vars
		 */
		 
		protected function setVars():void
		{	
			mMenuManager =MenuManager.instance;
			mMenuManager.addEventListener(mMenuManager.MENU_EVENT, onMenuEvent, false, 0, true);
			mMenuManager.addEventListener(mMenuManager.MENU_BUTTON_EVENT, onMenuButtonEvent, false, 0, true);
			mMenuManager.addEventListener(mMenuManager.MENU_NAVIGATION_EVENT, onMenuNavigationEvent, false, 0, true);
				
			mScore = new NP9_Evar(0);
		}
		
		 /**
		 * @Note: Send Your Score to Neopets
		 */
		 
		 protected function reportScore():void
		 {
			mDocumentClass.neopets_GS.sendScore(mScore.show()); 	
		 }
		
		/**
		 * @Note: Handles Standard Translation for Menus
		 * 
		 * @Note: One Centeral Location to have all the TextFiles Converted for all the Menus These are the default values for the Default Objects.
		 * @Note: If you wish to override these feel free to in your Game class that Extends VendorGameExtension
		 * @Note: If you just want to add Menus or Translation of Text,  override extendMenus function instead.
		 */
		 
		protected function setupMenus():void
		{
			var translationManager : TranslationManager = TranslationManager.instance;
			
			var tIntroScreen:OpeningScreen = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:GameOverScreen = GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen:InstructionScreen = InstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));	
			
			//Intro Screen
			translationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationInfo.IDS_BTN_INSTRUCTION);
			translationManager.setTextField(tIntroScreen.startGameButton.label_txt, mTranslationInfo.IDS_BTN_START);
			translationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationInfo.IDS_COPYRIGHT_TXT);
			translationManager.setTextField(tIntroScreen.txtFld_title, mTranslationInfo.IDS_TITLE_NAME);
			
			//Instruction Screen
			translationManager.setTextField(tInstructionScreen.returnBtn.label_txt, mTranslationInfo.IDS_BTN_BACK);
			translationManager.setTextField(tInstructionScreen.instructionTextField, mTranslationInfo.IDS_INSTRUCTION_TXT);
			
			//In Game Screen
			translationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationInfo.IDS_BTN_QUIT);
			
			//Game Over Screen
			translationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationInfo.IDS_BTN_PLAYAGAIN);
			translationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationInfo.IDS_BTN_SENDSCORE);
			
			extendMenus();
		}
		
		
		
		//--------------------------------------
		//  PROTECTED OVERRIDE METHODS
		//--------------------------------------
		
		/**
		 * @Note:  If you need to Extend Menus instead of override setupMenus, just add you Menus and Translation Here.
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		 
		 protected  function extendMenus():void
		 {
		 	
		 }
		 	
		 /**
		 * @Note:  If you need to Extend Menus instead of override setupMenus, just add you Menus and Translation Here.
		 * @Note: Use this to add Btn Cmds to the new Menus.
		 * @NOTE: This should be OVERRIDED in your Main Game Class
		 */
		 
		 protected  function extraMenuButtons (pBtnName:String):void
		 {
		 	
		 }
		 
		/**
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		 
		 protected function restartGame():void
		 {
		 	
		 }
		
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		 
		 protected  function startGame():void
		 {
		 	
		 }
		 
		 /**
		 * @Note: Starts Setting up your Game
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		  protected function startGameSetup():void 
		  {
		 
		  }
		 
		  /**
		 * @Note: Quit for your Game
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		 protected function quitGame():void
		 {
		 	
		 }
		 
		   /**
		 * @Note: Toggle off the Background Music
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		 protected function toggleMusic():void
		 {
		 	
		 }
		
		 /**
		 * @Note: Toggle off the all Sounds
		 * @NOTE: This should be OVERRIDED in your Main Game
		 */
		 
		 protected function toggleSound():void
		 {
		 		
		 }
		 
	}
	
}
