/* AS3
	Copyright 2008
*/

package  com.neopets.games.inhouse.SuperSearch.Spinbrush
{
	import com.neopets.examples.gameEngineExample.gameObjects.IGameObject;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.examples.gameEngineExample.reference.SoundID_demo;
	
	import com.neopets.util.sound.SoundObj;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_OpeningScreen;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	import com.neopets.util.tracker.NeoTracker;
	import flash.net.navigateToURL;
	
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
	 * 	@NOTE: SpinbrushSuperSearch_Engine eventually extends EventDispatcher not a DisplayObject.
	 * 		>So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  4.02.2009
	 */
	 
	public class SpinbrushSuperSearch_Engine extends GameEngine
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const MENU_ABOUT_CLIENT:String = "mcAboutScreen";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mGameObjectArray:Array;
		private var mGameObjectVC:ViewContainer;
		protected var mQuitBtn:NeopetsButton;
		protected var mSendScoreBtn:NeopetsButton;
		protected var mLockButtons:Boolean;
		
		public var buttonSound=new BtnSound();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SpinbrushSuperSearch_Engine():void
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
		 * @Note: called from continueSetup after sounds are loaded and menu manager is instantiated
		 * @Note: handles standard translation for menus 
		 * @Note: one centeral location to have all the text strings converted menus 
		 * @Note: these are the default values for the default objects
		 * @Note: if game class extends VendorGameExtension then this function may be overridden to extend the menus
		 * @Note: if you just want to add menus or translated text, then override extendMenus function instead
		 */	
		override protected function setupMenus( ):void
		{		
			trace( "GameEngine says: setupMenus called" );
			//var tBallClass         : Class             = getDefinitionByName( "TestAsset" ) as Class;
			//var tBall              : MovieClip         = new tBallClass( );
						
			var tIntroScreen       : SuperSearch_OpeningScreen     = SuperSearch_OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen        : GameScreen        = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen    : GameOverScreen    = GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen : InstructionScreen = InstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));
			var tAboutScreen : InstructionScreen = InstructionScreen(mMenuManager.createMenu(MENU_ABOUT_CLIENT,MENU_ABOUT_CLIENT));
						
			//Intro Screen
			mTranslationManager.setTextField( tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_BTN_INSTRUCTION );
			mTranslationManager.setTextField( tIntroScreen.startGameButton.label_txt, mTranslationData.IDS_BTN_START );
			mTranslationManager.setTextField( tIntroScreen.aboutButton.label_txt, mTranslationData.IDS_BTN_ABOUT );
			mTranslationManager.setTextField( tIntroScreen.visitSiteButton.label_txt, mTranslationData.IDS_BTN_VISIT_SITE );
			mTranslationManager.setTextField( tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT );
			mTranslationManager.setTextField( tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME );
			
			//Instruction Screen
			mTranslationManager.setTextField( tInstructionScreen.returnBtn.label_txt, mTranslationData.IDS_BTN_BACK );
			mTranslationManager.setTextField( tInstructionScreen.instructionTextField, mTranslationData.IDS_INSTRUCTION_TXT );
			
			//About Screen
			mTranslationManager.setTextField( tAboutScreen.returnBtn.label_txt, mTranslationData.IDS_BTN_BACK );
			mTranslationManager.setTextField( tAboutScreen.instructionTextField, mTranslationData.IDS_ABOUT_TXT );
			
			//In Game Screen
			mTranslationManager.setTextField( tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT );
			
			//Game Over Screen
			mTranslationManager.setTextField( tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_BTN_PLAYAGAIN );
			mTranslationManager.setTextField( tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_BTN_SENDSCORE );
			
			extendMenus( );
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
		  
		  /**
		 * @Note: events from the menu buttons that can affect the game
		 * @param		evt.oData.EVENT		String 		name of the button that was pressed in the menus
		 */		
		override protected function onMenuButtonEvent( evt : CustomEvent ):void
		{
			switch ( evt.oData.EVENT )
			{
				case "startGameButton":  // located on intro screen
					startGame( );
					//buttonSound.playSound();
					break;
				case "aboutButton":  // located on intro screen
					NeoTracker.instance.trackNeoContentID(16388);
					MenuManager.instance.menuNavigation(MENU_ABOUT_CLIENT);
					//buttonSound.playSound();
					break;
				case "visitSiteButton":  // located on intro screen
					visitSite();
					//buttonSound.playSound();
					break;
				case "quitGameButton":  // located on game screen
					quitGame( );
					//buttonSound.playSound();
					break;
				case "playAgainBtn":    // located on game over screen
					restartGame( );
					//buttonSound.playSound();
					break;
				case "reportScoreBtn":  // located on game over screen
					reportScore( );
					//buttonSound.playSound();
					break;
				case "musicToggleBtn":  // located on intro screen
					toggleMusic( );
					//buttonSound.playSound();
					break;
				case "soundToggleBtn":  // located on intro screen
					toggleSound( );
					
					break;
			}
			buttonSound.playSound();
			
			extraMenuButtons ( evt.oData.EVENT );
			
		}
		
		// This function uses a neocontent like to go to the target web site.
		
		public function visitSite(window:String=null):void {
			var server:String = mRootMC.mcBIOS.script_server;
			var full_path:String = "http://" + server + "/process_click.phtml?item_id=" + 16331;
			var req:URLRequest = new URLRequest(full_path);
			navigateToURL(req,window);
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
		 			var tGameOverScreen:GameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as GameOverScreen;
		 			tGameOverScreen.toggleInterfaceButtons(true);
		 			mSoundManager.stopSound(SoundID_demo.SND_MUSIC);
		 		break;
		 		case MenuManager.MENU_INTRO_SCR:
		 			//mSoundManager.soundPlay(SoundID_demo.SND_MUSIC, true);
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
		 */
		 
		 protected override function toggleMusic():void
		 {
			 var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_demo.SND_MUSIC);
			 
		 		if (tFlag)
			 	{
			 		mSoundManager.stopSound(SoundID_demo.SND_MUSIC);
			 	}
			 	else
			 	{
			 		mSoundManager.soundPlay(SoundID_demo.SND_MUSIC, true);
			 	}
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 */
		 
		 protected override function toggleSound():void
		 {
		 	
		 	if (mSoundManager.soundOverRide)
		 	{
		 		mSoundManager.soundOverRide = false;	
		 	}
		 	else
		 	{
		 		mSoundManager.soundOverRide = true;	
		 	}
		 
		 }
		
		  
	}
	
}
