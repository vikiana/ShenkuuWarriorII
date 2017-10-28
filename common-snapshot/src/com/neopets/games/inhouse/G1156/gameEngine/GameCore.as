
/* AS3
	Copyright 2008
*/
package  com.neopets.games.inhouse.G1156.gameEngine
{
	import com.neopets.games.inhouse.G1156.document.BasicEmbedAssets;
	import com.neopets.games.inhouse.G1156.document.G1156_AssetDocument;
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gui.GameEffects;
	import com.neopets.games.inhouse.G1156.managers.ExtendedEmbededObjectsManager;
	import com.neopets.games.inhouse.G1156.menus.InstructionMenu;
	import com.neopets.games.inhouse.G1156.reference.SoundID_G1156;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.managers.ScoreManager;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	/**
	 *	This will be the Main WorkHorse Class for the Game
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine / Singleton
	 * 
	 *	@author Clive Henrick 
	 *	@since  9.24.2009
	 */
	 
	public class GameCore extends GameEngine 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		public static const KEY:String = "G1156";
		
		public static const USE_TIMER:Boolean = true;
		
		public const TIMER_DELAY:int = 30;
		public const QUICK_TIMER_DELAY:int = 40;
		public const SLOW_TIMER_DELAY:int = 1000;

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mGameObjectVC:ViewContainer;
		protected var mLockButtons:Boolean;
		
	
		protected var mGameTimer:Timer;
		protected var mGameQuickTimer:Timer;
		protected var mSlowTimer:Timer;
		
		protected var mCollisionEffect:GameEffects;

		protected  var mSharedEventDispatcher:MultitonEventDispatcher;
		
		protected var mGameCoreDisplay:GameApplication;
		
		private static const mInstance:GameCore = new GameCore( SingletonEnforcer);
		
		public static var mCurrentGameLevel:int;
		
		protected var mMusicFlag:Boolean = true;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		 public function GameCore(singletonEnforcer : Class = null):void
		{
		 	super();	
		 	
	 		if(singletonEnforcer != SingletonEnforcer)
	 		{
				throw new Error( "Invalid Singleton access.  Use GameCore.instance." ); 
			}

		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():GameCore
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/**
		 * @NOTE: This will Start the CleanUp of Objects for Quittting the Game
		 */
		 
		public function cleanUpEngineDemo():void
		{
			cleanupGameEngine();
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note the Game is Over from Playing all three Levels
		 */
		 
		protected function onGameOverEvent (evt:Event = null):void
		{
			//ADDED
			stopGameTimersEvent();
			
			mGameCoreDisplay.removeEventListener(GameApplication.EVENT_GAMECOREDISPLAY_READY, gameSetupDone);
			mGameCoreDisplay.viewContainer.cleanUpAllUI();
			mGameObjectVC.removeUIDisplayObject("GameCoreDisplay");
			mGameCoreDisplay = null;
			
			trace("startGameSetup running");
		  	mGameCoreDisplay = new GameApplication();
		  	mGameObjectVC.addUIViewContainer(mGameCoreDisplay.viewContainer, 999,"GameCoreDisplay");
		  	mGameCoreDisplay.init(G1156_AssetDocument);
		  		
			stopGameTimersEvent();
			GameCore.mCurrentGameLevel = 1;	
			mMenuManager.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
			
			mSoundManager.stopAllCurrentSounds();
		}
		
		/**
		 * @Note: Starts the Game Timers
		 */
		 
		protected function startGameTimersEvent(evt:Event = null):void
		{
			mGameTimer.start();
			mGameQuickTimer.start();
			mSlowTimer.start();	
		}
		
		/**
		 * @Note: Stops the Game Timers
		 */
		 
		protected function stopGameTimersEvent(evt:Event = null):void
		{
			mGameTimer.stop();
			mGameQuickTimer.stop();
			mSlowTimer.stop();	
			
			mGameTimer.reset();
			mGameQuickTimer.reset();
			mSlowTimer.reset()
			
		}
		/**
		 * @Note: This fires a GameTimer Event for BroadCast
		 */
		 
		 protected function onGameTimerEvent(evt:TimerEvent):void
		 {
		 	mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_TIMER_EVENT));	
		 }
		 
		 /**
		 * @Note: This fires a Quick GameTimer Event for BroadCast
		 */
		 
		 protected function onGameQuickTimerEvent(evt:TimerEvent):void
		 {
		 	mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_QUICK_TIMER_EVENT));	
		 }
		 
		  /**
		 * @Note: This fires a Quick GameTimer Event for BroadCast
		 */
		 
		 protected function onGameSlowTimerEvent(evt:TimerEvent):void
		 {
		 	mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_SLOW_TIMER_EVENT));	
		 }
		 
		 /**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  *		> ReOrders the ViewContainers
		  * 	> Adds the GameDemo View Contaienr to the GameEngines ViewContainer
		  * 	> Tells the GameEngine it is ready
		  * */
		  
		  protected function gameSetupDone(evt:Event = null):void
		  {
		  	trace("GameCore: gameSetupDone");
		  	
		  //	mGameObjectVC.reOrderDisplayList();
		  	
		  	//GAME IS READY TO START
			mGameObjectVC.addUIViewContainer(mGameCoreDisplay.viewContainer, 999,"GameCoreDisplay");

		   	completedSetup();
		  }
		  
		//--------------------------------------
		//  PRIVATE  METHODS
		//--------------------------------------
		
		private function setupGameVars():void
		{
			mGameObjectVC = new ViewContainer("GameCoreScreen");
			mGameTimer = new Timer( TIMER_DELAY);
			mGameTimer.addEventListener( TimerEvent.TIMER, onGameTimerEvent, false,0,true);
			mGameQuickTimer = new Timer (QUICK_TIMER_DELAY);
			mGameQuickTimer.addEventListener( TimerEvent.TIMER, onGameQuickTimerEvent, false,0,true);
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			mSlowTimer = new Timer(SLOW_TIMER_DELAY);
			mSlowTimer.addEventListener( TimerEvent.TIMER, onGameSlowTimerEvent, false,0,true);
			
			GameCore.mCurrentGameLevel = 1;
			mSharedEventDispatcher.addEventListener(GameEvents.TIMER_START_ALL, startGameTimersEvent,false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.TIMER_STOP_ALL, stopGameTimersEvent,false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.GAME_OVER, onGameOverEvent, false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.QUIT_GAME, onGameOverEvent, false,0,true);
	
						
		  	var tGameScreen:GameScreen = MenuManager.instance.getMenuScreen(MenuManager.MENU_GAME_SCR);
		  	tGameScreen.addChildAt(mGameObjectVC,tGameScreen.numChildren);
		}
		
		//--------------------------------------
		//  PROTECTED OVERRIDE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is called by GameEngine once:
		 * 		>All soundFiles are loaded, 
		 * 		>Congfig file is ready,
		 * 		>All external assets are loaded and can be in this ApplicationDomain (Depends on the Config.xml)
		 * @Note: This is the start of your Games Setup
		 */
		 
		  protected override function initChild():void 
		  {
		  	trace("GameCore initChild");
		  	setupGameVars();
		  	startGameSetup();
		  }
		  
		 /**
		 * @Note: This is going to pull objects out of the externalLibrary
		 * 		> Since the ExternalAssets are loaded into the Parent Application Domain, 
		 * 		> you can just access an item in the library.
		 */
		   protected override function startGameSetup():void 
		  {
		  		trace("startGameSetup running");
		  		mGameCoreDisplay = new GameApplication();
		  		//mGameCoreDisplay = GameCoreDisplay.instance;
		  		mGameCoreDisplay.addEventListener(GameApplication.EVENT_GAMECOREDISPLAY_READY, gameSetupDone,false,0,true);
		  		mGameCoreDisplay.init(G1156_AssetDocument);
		  }
		  
		  	/**
		 * @Note: Send Your Score to Neopets
		 */
		 
		 protected override function reportScore():void
		 {
		 	trace("GameCore reportScore Value:", ScoreManager.instance.getValue());
			mGamingSystem.sendScore(ScoreManager.instance.getValue()); 	

			
		 }
		 
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
		 		break;
		 		case MenuManager.MENU_INTRO_SCR:
					 if (mMusicFlag)
			 		{
			 			var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_G1156.SND_MUSIC);
		 	
		 				if ( !tFlag)
						 {
			 				mSoundManager.soundPlay(SoundID_G1156.SND_MUSIC, true);	
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
		 	mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		 }
		
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 */
		 
		 protected override function startGame():void
		 {
		 	trace("StartGame")
		 	ScoreManager.instance.changeScoreTo(0);
		 	mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
		 	startGameTimersEvent();
			mGameCoreDisplay.onGameStart();
			
			
			 }
		
		  /**
		 * @Note: Quit for your Game from the In Game Screen
		 */
		 
		 protected override function quitGame():void
		 {
				onGameOverEvent();
		 }
		 
		   /**
		 * @Note: Need to Turn off / On  the Background Track
		 */
		 
		 protected override function toggleMusic():void
		 {
		 		var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_G1156.SND_MUSIC);
			 
		 		if (tFlag)
			 	{
			 		mSoundManager.stopSound(SoundID_G1156.SND_MUSIC);
			 	}
			 	
			 	if (mMusicFlag)
			 	{
			 		mMusicFlag = false;	
			 	} 
			 	else
			 	{
			 		mMusicFlag = true;
			 		mSoundManager.soundPlay(SoundID_G1156.SND_MUSIC, true);	
			 	}
			 	
			 	
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 */
		 
		 protected override function toggleSound():void
		 {
		 	var tFlag:Boolean = mSoundManager.checkSoundState(SoundID_G1156.SND_MUSIC);
		 	
		 	if (tFlag)
			 {
			 	mSoundManager.stopSound(SoundID_G1156.SND_MUSIC);
			 }
			 	
		 	if (mSoundManager.soundOverRide)
		 	{
		 		mSoundManager.soundOverRide = false;

			 	if (mMusicFlag)
			 	{
			 		mSoundManager.soundPlay(SoundID_G1156.SND_MUSIC, true);	
			 	} 
		 		
		 	}
		 	else
		 	{
		 		mSoundManager.soundOverRide = true;	
		 	}
		 
		 }
		 
		 /**
		 * @Note: Handles Standard Translation for Menus
		 * 
		 * @Note: One Centeral Location to have all the TextFiles Converted for all the Menus These are the default values for the Default Objects.
		 * @Note: If you wish to override these feel free to in your Game class that Extends VendorGameExtension
		 * @Note: If you just want to add Menus or Translation of Text,  override extendMenus function instead.
		 * @Note: Since this game uses Embeded Files this had to be override to Work Correctly
		 */
		 
		protected override function setupMenus():void
		{
			var tEmbededObjManager:ExtendedEmbededObjectsManager = ExtendedEmbededObjectsManager.instance;
			var tBasicEmbedObjData:EmbedObjectData = tEmbededObjManager.getEmbededAssetsObject(BasicEmbedAssets);			
			
			var tIntroScreen:OpeningScreen = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR,true,tBasicEmbedObjData));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR,true,tBasicEmbedObjData));
			var tGameOverScreen:GameOverScreen = GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR,true,tBasicEmbedObjData));
			var tInstructionScreen:InstructionMenu = InstructionMenu(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR,true,tBasicEmbedObjData));	
			
			//Intro Screen
			mTranslationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationData.IDS_BTN_INSTRUCTION);
			mTranslationManager.setTextField(tIntroScreen.startGameButton.label_txt, mTranslationData.IDS_BTN_START);
			mTranslationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationData.IDS_COPYRIGHT_TXT);
			mTranslationManager.setTextField(tIntroScreen.txtFld_title, mTranslationData.IDS_TITLE_NAME);
			
			//Instruction Screen
			mTranslationManager.setTextField(tInstructionScreen.returnBtn.label_txt, mTranslationData.IDS_BTN_BACK);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField, mTranslationData.IDS_INSTRUCTION_TXT);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField2, mTranslationData.IDS_INSTRUCTION_TXT3);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField3, mTranslationData.IDS_INSTRUCTION_TXT4);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField4, mTranslationData.IDS_INSTRUCTION_TXT2);
			mTranslationManager.setTextField(tInstructionScreen.instructionTextField5, mTranslationData.IDS_INSTRUCTION_TXT5);
			
			//In Game Screen
			mTranslationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationData.IDS_BTN_QUIT);
			
			//Game Over Screen
			mTranslationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationData.IDS_BTN_PLAYAGAIN);
			mTranslationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationData.IDS_BTN_SENDSCORE);
			
			extendMenus();
		}


		/**
		 * @Note: This is used to setup the Sound Files. These files are set in the config.xml.
		 * @Note: The SoundFiles are assumed to be embeded in the Library and of the soundObj Class
		 * @Note: Since this game uses Embeded Files this had to be override to Work Correctly
		 */

		protected override function setupSounds():void {
			var tWaitForSounds:Boolean = false;

			if (mConfigXML.SETUP.hasOwnProperty("SOUNDS")) {
				
				var tEmbededObjManager:ExtendedEmbededObjectsManager = ExtendedEmbededObjectsManager.instance;
				var tBasicEmbedObjData:EmbedObjectData = tEmbededObjManager.getEmbededAssetsObject(BasicEmbedAssets);			

				for each (var sndXML:XML in mConfigXML.SETUP.SOUNDS.*) {
					var sndVolume:Number = sndXML.hasOwnProperty("volume")? sndXML.volume: 1;
					trace ("volume", sndXML.volume, sndVolume, sndXML.id)
					if (sndXML.hasOwnProperty("url")) 
					{
						mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_ALLLOADED, continueSetup, false,0,true);
						mSoundManager.loadSound(sndXML.id,sndXML.type,0,sndXML.url, null, sndVolume);
						tWaitForSounds = true;
					} else {
						if (sndXML.type == mSoundManager.TYPE_EMBEDED)
						{
							mSoundManager.loadSound(sndXML.id,sndXML.type, 0, null, null, sndVolume,null,tBasicEmbedObjData);	
						}
						else
						{
							mSoundManager.loadSound(sndXML.id,sndXML.type, 0, null, null, sndVolume);	
						}
						
					}
				}
				if (!tWaitForSounds) {
					trace ("tWait for sounds: continue setup");
					continueSetup();
				}
			} else {
				trace ("continue setup");
				continueSetup();
			}
		}
		
	}
	
}
/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}
