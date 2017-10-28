/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.G1156.gameEngine
{
	import caurina.transitions.*;
	
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.games.inhouse.G1156.dataObjects.MovementObjData;
	import com.neopets.games.inhouse.G1156.displayObjects.EndMessageBox;
	import com.neopets.games.inhouse.G1156.displayObjects.InGameBar;
	import com.neopets.games.inhouse.G1156.displayObjects.JumperObj;
	import com.neopets.games.inhouse.G1156.displayObjects.MapSection;
	import com.neopets.games.inhouse.G1156.displayObjects.PopUpBox;
	import com.neopets.games.inhouse.G1156.displayObjects.PopUpBoxImproved;
	import com.neopets.games.inhouse.G1156.displayObjects.ProgressBar;
	import com.neopets.games.inhouse.G1156.displayObjects.TimerBar;
	import com.neopets.games.inhouse.G1156.document.G1156_AssetDocument;
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gui.GameEffects;
	import com.neopets.games.inhouse.G1156.gui.RockExplosion;
	import com.neopets.games.inhouse.G1156.managers.ExtendedEmbededObjectsManager;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.display.scrolling.ScrollDownQueue;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.input.KeyManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This Creates each level for the Game and Handles Basic Interactions
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.27.2009
	 */
	 
	public class GameApplication extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const EVENT_GAMECOREDISPLAY_READY:String = "TheLevelisReady";
		public static const GAME_DISPLAYCORE_ID:String = "GameCoreDisplay";
		public static const EVENT_PLAYER_LANDED:String = "PlayerHasLanded";

		public static const STAGE_BOTTOM_RESTRICTION:int = 560;
		public static const STAGE_TOP_RESTRICTION:int = 130;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mLevelViewContainer:ViewContainer;
		
		protected  var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mEmbededObjectManager:ExtendedEmbededObjectsManager;
		protected var mAssetEmbedObjectData:EmbedObjectData;
		
		protected var mVertScroll:ScrollDownQueue;;
		protected var mPanelArray:Array;
		protected var mJumper:JumperObj;
		protected var mKeyManager:KeyManager;
	
		protected var mCollisionEffect:GameEffects;
		
		protected var mPlayerIndex:int;
		protected var mMovementObj:MovementObjData;
		protected var mGameMovement:DefaultGameMovement;
		

		protected var mRockExplosion:RockExplosion;
		
		protected var mTotalPanels:int;
		protected var mCurrentPanel:int;
		
		
		protected var mStartTimer:Timer;
		public var mLevelScore:NP9_Evar;
		
		//############# UI ######################
		protected var mProgressBar:ProgressBar;
		protected var mInGameBar:InGameBar;
		protected var mTimerBar:TimerBar;
		//protected var mPopUpBox:PopUpBox;
		protected var mPopUpBox:PopUpBoxImproved;
		protected var mEndMessageBox:EndMessageBox

		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		 public function GameApplication():void
		{
		 	super();	
		 	setupVars();
	
		}
		

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public function get viewContainer():ViewContainer
		{
			return mLevelViewContainer;
		}
		
		public function get jumper():JumperObj
		{
			return mJumper;	
		}
		
		public function get assetEmbedDataObj():EmbedObjectData
		{
			return 	mAssetEmbedObjectData;
		}
		
		public function get gameEffects():GameEffects
		{
			return mCollisionEffect;
		}
		
		public function get rockEffects():RockExplosion
		{
			return mRockExplosion;
		}
		
		public function get keyManager():KeyManager
		{
			return mKeyManager;
		}
		
		public function get movementData():MovementObjData
		{
			return mMovementObj;
		}
		
		public function get scrollingManager():ScrollDownQueue
		{
			return mVertScroll;
		}
		
		protected function get progressBar():ProgressBar
		{
			return mProgressBar;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Starts up the Main DisplayEngine
		 * @param		pCMD			String 		This is an Example of a Passed parameter
		 */
		 
		public function init(pEmbededObjectClass:Class):void
		{
				mSharedEventDispatcher.addEventListener(GameApplication.EVENT_PLAYER_LANDED, onEndLevel ,false,0,true);
				mAssetEmbedObjectData= mEmbededObjectManager.getEmbededAssetsObject(pEmbededObjectClass);
				setupStartingItems();
				setupLevel(1);
				mLevelViewContainer.reOrderDisplayList();
				
		}
		
		public function setupLevel(pLevel:int):void
		{
			var tAssetInstance:G1156_AssetDocument = mAssetEmbedObjectData.mInstance;
			
			switch (pLevel)
			{
				case 1:
					mPanelArray = [];
					mVertScroll.clearAllPanels();
					mPanelArray = tAssetInstance.returnLoopArray();
					setupScrollingPanels(mPanelArray);
					setupPanels(mPanelArray);
					resetJumper();
					//mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.TIMER_START_ALL));
				
				break;
				case 2: 
					//To Do >>>>>>>>>> CLEAR ALL THE OLD LEVES AND OBJECTS OUT OF MEMORY
					mPanelArray = [];
					mVertScroll.clearAllPanels();
					mPanelArray = tAssetInstance.returnMapArrayLevel2();
					setupScrollingPanels(mPanelArray);
					setupPanels(mPanelArray);
					resetJumper();
					mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.TIMER_START_ALL));
					continueGame();
				break;
				case 3:
					//To Do >>>>>>>>>> CLEAR ALL THE OLD LEVES AND OBJECTS OUT OF MEMORY
					mPanelArray = [];
					mVertScroll.clearAllPanels();
					mPanelArray = tAssetInstance.returnMapArrayLevel3();
					setupScrollingPanels(mPanelArray);
					setupPanels(mPanelArray);
					resetJumper();
					mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.TIMER_START_ALL));
					continueGame();
				break;
			}
			
		}
		
		/**
		 * @Note:Resets the Avatar
		 */
		 
		 protected function resetJumper():void
		 {
		 	var tCurrentLevel:int = GameCore.mCurrentGameLevel;
		 	
		 	mSharedEventDispatcher.dispatchEvent(new CustomEvent({level:tCurrentLevel}, GameEvents.LEVEL_RESET));	
		 }
		
		
		/**
		 * @Note When the Game Starts to Play when the GameCore PlayGame Button is pressed
		 */ 
		 
		public function onGameStart():void
		{
			continueGame();
		}
		
		/**
		 * @Note: Game is in Process and we are starting a new Level
		 */
		 
		protected function continueGame():void
		{
			trace("continueGame MapID:", tMapID);
			mVertScroll.startScrolling(0,mMovementObj.mFallSpeed);	
			mJumper.activateItem();
			var tMapID:String = mPanelArray[0].id;
			trace("continueGame MapID:", tMapID);
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({id:tMapID},GameEvents.SEND_ACTIVATE_EVENT));	
			mStartTimer.start();	
		}
		
		/**
		 * @Note: Starts up Items that must only be Here once
		 */
		 
		 protected function setupStartingItems():void
		 {
	 			var tAssetInstance:G1156_AssetDocument = mAssetEmbedObjectData.mInstance;
	 			tAssetInstance.setApplicationDomain(mAssetEmbedObjectData.mApplicationDomain);
				mJumper = tAssetInstance.getLibraryObject("RoxtonJumper", JumperObj) as JumperObj;
				var tStaticBackground:MovieClip = tAssetInstance.getLibraryObject("StaticBackground", MovieClip) as MovieClip;
				tStaticBackground.x = 0;
				tStaticBackground.y = 0;
				mLevelViewContainer.addDisplayObjectUI(tStaticBackground,0,"StaticBackground");
				mLevelViewContainer.addDisplayObjectUI(mVertScroll,1,"ScrollDownQueue");
				setupFinalUI();
				setupCollisionEffects();
				dispatchEvent(new Event(GameApplication.EVENT_GAMECOREDISPLAY_READY));	
		 }
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		/**
		 * @Note When the Map Section is removed by ScrollDownQue Class
		 * @param			evt.oData.panel			DisplayObject			The Panel that has been removed
		 */
		 
		protected function onMapRemoved(evt:CustomEvent):void
		{
			mCurrentPanel++;
			var tMapSection:MapSection = evt.oData.panel;
			trace("onMapRemoved panel removed: ", 	tMapSection.id );
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({id:tMapSection.id},GameEvents.SEND_DEACTIVATE_EVENT));	
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({sections:mTotalPanels, sectionCompleted:mCurrentPanel },	GameEvents.SECTION_COMPLETE));
		
		}
		
		/**
		 * @Note When the Map Section is added by ScrollDownQue Class
		 * @param			evt.oData.panel			DisplayObject			The Panel that has been removed
		 */
		 
		protected function onMapAdded(evt:CustomEvent):void
		{
			var tMapSection:MapSection = evt.oData.panel;
			trace("onMapRemoved panel added: ", 	tMapSection.id );
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({id:tMapSection.id},GameEvents.SEND_ACTIVATE_EVENT));	
		}
		
		/**
		 * @Note: When all the Maps Sections Stop Scrolling	
		 */
		 
		protected function onMapsFinished(evt:Event):void
		{
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({sections:mTotalPanels, sectionCompleted:mTotalPanels },	GameEvents.SECTION_COMPLETE));
		}
		 
		  /**
		 * @Note:Player has landed
		 */
		 
		 protected function onEndLevel (evt:Event):void
		 {
		 	trace("####################### End of Level  ###########################");	
		 	
		 	var tTranslationManager:TranslationManager = TranslationManager.instance;
		 	var tTransData:TranslationData = tTranslationManager.translationData;
		 	
		 	mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.TIMER_STOP_ALL));	
		 	
		 	var tLevelBonus:int = mLevelScore.show();
		 	
		 	var tTime:int = mInGameBar.time;
		 	var tTimeBonus:int = 10 * tTime;
		 	var totalBonus:int = tTimeBonus + tLevelBonus;
		 	
		 	mSharedEventDispatcher.dispatchEvent(new CustomEvent({levelBonus:tLevelBonus, overallBonus:totalBonus, timeBonus:tTimeBonus, time:tTime },GameEvents.ACTIVATE_POPUP_MENU));
		 	mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:tTimeBonus },GameEvents.SCORE_CHANGE));
		 	
		 	mPopUpBox.visible = true;
		 	
		 	mLevelScore.changeTo(0);
		 }

		/**
		 * @Note: When the QUIT BTN is Pressed
		 */
		 
		protected function onGameQuit(evt:Event = null):void
		{
			mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_CLEANUP_MEMORY));
			onGameEnd();
		}
		
		/**
		 * @Note: When the Game Ends ######################## CLEAN UP ALL MEMORY LEAKS
		 */
		 
		protected function onGameEnd():void
		{
		
			// KILL EVERYTHING TRY
			var tKillIt:int = mPanelArray.length;

			for ( var z:int = 0; z < tKillIt; z++)
			{
				var tMap:MapSection = mPanelArray[z];
				
				while ( tMap.numChildren > 0)
				{
					tMap.removeChildAt(0);
				}
				
			}
			mSharedEventDispatcher.removeEventListener(GameEvents.QUIT_GAME, onGameQuit);
			mSharedEventDispatcher.removeEventListener(GameEvents.GAMECOREDISPLAY_STARTNEXTLEVEL, setupNewLevel);
			mSharedEventDispatcher.removeEventListener(GameEvents.SCORE_CHANGE, updateLevelScore);
			
			
			mPanelArray = null;
			mVertScroll.clearAllPanels();
			mVertScroll.removeEventListener(ScrollDownQueue.EVENT_PANEL_REMOVED, onMapRemoved);
			mVertScroll.removeEventListener(ScrollDownQueue.EVENT_PANEL_ADDED, onMapAdded);
			mVertScroll.removeEventListener(ScrollDownQueue.EVENT_COMPLETED_SCROLLING, onMapsFinished);
			mLevelViewContainer.removeUIDisplayObject("ScrollDownQueue");
			mVertScroll = null;
			
			mLevelViewContainer.removeUIDisplayObject("ProgressBar");
			mProgressBar  = null;
			mLevelViewContainer.removeUIDisplayObject("MenuBar");
			mInGameBar = null;
			mLevelViewContainer.removeUIDisplayObject("PopUpBox");
			mPopUpBox = null;
			mLevelViewContainer.removeUIDisplayObject("Jumper");
			mJumper = null;
			mLevelViewContainer.removeUIDisplayObject("StaticBackground");
			
			mLevelViewContainer.removeUIDisplayObject("EndMessageBox");
			mEndMessageBox = null;
			
			GameCore.mCurrentGameLevel = 1;
			
			mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_OVER));
			mLevelScore.changeTo(0);
			
		}
		/**
		 * The Player Has lost of there health
		 */
		 
		protected function onPlayerDead(evt:Event):void
		{
			mJumper.addEventListener(JumperObj.EVENT_JUMPER_FADEOUT_COMPLETED, showPlayerDiedScreen, false, 0 , true);
			mJumper.freeFallAction(mJumper.ACTION_DEATH);	
			
			//HAULT EVERYTHING ELSE
			mVertScroll.stopScrolling();
			mJumper.parachuteActionLock = true;
			mGameMovement.mJumperFreeFallLock = true;
		}
		
		/**
		 * @Note: The Player is dead and the Icon has faided out
		 */
		 
		protected function showPlayerDiedScreen(evt:Event):void
		{
			mJumper.removeEventListener(JumperObj.EVENT_JUMPER_FADEOUT_COMPLETED, showPlayerDiedScreen);
			
			mEndMessageBox.addEventListener(mEndMessageBox.EVENT_CLOSE_MSGBOX, onCloseApplication, false, 0 , true);
		 	mEndMessageBox.dispatchEvent(new CustomEvent(	{message:"LOSE"},mEndMessageBox.EVENT_LAUNCH_MSGBOX));	
		
			mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_CLEANUP_MEMORY));	
		}
		
		/**
		 * The Player Has lost of there health
		 */
		 
		protected function onPlayerWins(evt:Event = null):void
		{
		 	mEndMessageBox.addEventListener(mEndMessageBox.EVENT_CLOSE_MSGBOX, onCloseApplication, false, 0 , true);
		 	mEndMessageBox.dispatchEvent(new CustomEvent(	{message:"WIN"},mEndMessageBox.EVENT_LAUNCH_MSGBOX));	
			mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_CLEANUP_MEMORY));
		}
		
		/**
		 * @Note: After the End Message Box Appears
		 */
		 
		protected function onCloseApplication(evt:Event):void
		{
			onGameEnd();	
		}
		
		  /**
		 * @Note: The Game is ready to go to a New Level
		 * @param 	evt.oData.level			int			The Level the Game Needs to go to
		 */
		 
		 protected function setupNewLevel(evt:CustomEvent):void
		 {
		 	if (evt.oData.level >3)
		 	{
		 		//Player Wins
		 		mCurrentPanel = 0;
		 		onPlayerWins();
		 	}
		 	else
		 	{
		 		mCurrentPanel = 0;
		 		mPopUpBox.visible = false;
		 		mLevelScore.changeTo(0);
		 		setupLevel(evt.oData.level);	
		 	}
		 
		 }

		 /**
		 * @Automatically releases the Parachute and slow the speed of the Map
		 */
		 
		 protected function onReleaseParachute (evt:TimerEvent):void
		 {
		 	mVertScroll.startScrolling(0,mMovementObj.mActiveFallSpeed);		
		 	mSharedEventDispatcher.dispatchEvent(new Event(JumperObj.EVENT_ACTIVATE_PARACHUTE));
		 	mStartTimer.stop();
		 }
		 
		 /**
		 * @Note Records the Level Score
		 * @param			evt.oData.changeAmount			int				Amount to Change the Score By	
		 */
		 
		 protected function updateLevelScore(evt:CustomEvent):void
		 {
		 	mLevelScore.changeBy(evt.oData.changeAmount);	
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{	
			mPanelArray = [];
			mEmbededObjectManager = ExtendedEmbededObjectsManager.instance;
			mLevelViewContainer = new ViewContainer();
			mVertScroll = new ScrollDownQueue();
			
			mVertScroll.addEventListener(ScrollDownQueue.EVENT_PANEL_REMOVED, onMapRemoved, false, 0, true);
			mVertScroll.addEventListener(ScrollDownQueue.EVENT_PANEL_ADDED, onMapAdded, false, 0, true);
			mVertScroll.addEventListener(ScrollDownQueue.EVENT_COMPLETED_SCROLLING, onMapsFinished, false, 0, true);
			
			mKeyManager = new KeyManager();
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			
			mSharedEventDispatcher.addEventListener(GameEvents.QUIT_GAME, onGameQuit, false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.GAMECOREDISPLAY_STARTNEXTLEVEL, setupNewLevel, false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.SCORE_CHANGE, updateLevelScore, false, 0, true);
			
			mSharedEventDispatcher.addEventListener(GameEvents.PLAYER_DIED, onPlayerDead, false, 0, true);
			mGameMovement = new DefaultGameMovement();
			mPlayerIndex = 1;
			mCurrentPanel = 0;
			
			mStartTimer = new Timer(300,1);
			mStartTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onReleaseParachute, false, 0, true);
			
			mLevelScore = new NP9_Evar(0);
		}
		
		
		
		
		/**
		 * @Note: Sets up the Verticle Loop
		 *	@Param		pArray		Objects to be Added
		 */
		 

		private function setupScrollingPanels(pArray:Array):void
		{
			mTotalPanels = pArray.length;
			
			for (var z:int = 0; z < mTotalPanels; z++)
			{
				mVertScroll.pushPanel(pArray[z]);	
			}
		}
		
		/**
		 * @Note: Sets up Jumper and the MovementObject, and UI Elements
		 */
		 

		 protected function setupFinalUI():void
		 {
		 	mKeyManager = new KeyManager(GameCore.instance.shell.stage);
		 	mKeyManager.addKey("LeftArrow",Keyboard.LEFT);
		 	mKeyManager.addKey("RightArrow", Keyboard.RIGHT);
		 	mKeyManager.addKey("UpArrow",Keyboard.UP);
		 	mKeyManager.addKey("DownArrow", Keyboard.DOWN);
		 	mKeyManager.addKey("SpaceBar", Keyboard.SPACE);
		 	
		 	mGameMovement.init(this);
		 	
		 	mJumper.x = JumperObj.START_JUMPER_X;
		 	mJumper.y = JumperObj.START_JUMPER_Y;
		 	mJumper.scaleX = .5;
		 	mJumper.scaleY = .5;
		 	
		 	mLevelViewContainer.addDisplayObjectUI(mJumper,2,"Jumper");
			
			switch (mPlayerIndex)
			{
				case 1: //Roxton
					mMovementObj = new MovementObjData(6,6,4,4,110);
				break;
				case 2: // PLAYER 2
					mMovementObj = new MovementObjData();
				break;
				default: //Player 3
					mMovementObj = new MovementObjData();
				break;
			}
			
			//Setup the Progress Bar and Health Bar and Timer Bar
			var tAssetInstance:G1156_AssetDocument = mAssetEmbedObjectData.mInstance;
			tAssetInstance.setApplicationDomain(mAssetEmbedObjectData.mApplicationDomain);
			var tTranslationManager:TranslationManager = TranslationManager.instance;
		 	var tTransData:TranslationData = tTranslationManager.translationData;
		 	
		 	mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.TIMER_STOP_ALL));	
			
			mProgressBar = tAssetInstance.getLibraryObject("ProgressBar", ProgressBar) as ProgressBar;
			mLevelViewContainer.addDisplayObjectUI(mProgressBar,3,"ProgressBar");
			
			mInGameBar = tAssetInstance.getLibraryObject("MenuBar", InGameBar) as InGameBar;
			mInGameBar.x = 35;
			mInGameBar.y = 5;
			mInGameBar.reset();
			mInGameBar.mQuitBtn.visible = true;

			tTranslationManager.setTextField(mInGameBar.txtScore, tTransData.IDS_MSG_SCORE);		

			mLevelViewContainer.addDisplayObjectUI(mInGameBar,4,"MenuBar");
			
			//Setup the PopUpBox
			mPopUpBox = tAssetInstance.getLibraryObject("PopUpBoxImproved", PopUpBoxImproved) as PopUpBoxImproved;
			mLevelViewContainer.addDisplayObjectUI(mPopUpBox,5,"PopUpBox");
		 	mPopUpBox.x = 120;
		 	mPopUpBox.y = 200;
		 	mPopUpBox.visible = false;
		 	
		 	//End Message Box
		 	
		 	mEndMessageBox =  tAssetInstance.getLibraryObject("EndMessageBox", EndMessageBox) as EndMessageBox;
		 	mLevelViewContainer.addDisplayObjectUI(mEndMessageBox,6,"EndMessageBox");
		 	mEndMessageBox.x = 120;
		 	mEndMessageBox.y = 200;
		 	mEndMessageBox.visible = false;
		 	

		 }
		
		

		
		
		/**
		 * @Note: This will set up Panels
		 */
		 

		 private function setupPanels(pArray:Array):void
		 {
		 	var tCount:int = pArray.length;

			var tAssetInstance:G1156_AssetDocument = mAssetEmbedObjectData.mInstance;
			var tCurrentLevel:int = GameCore.mCurrentGameLevel;
			
		 	for (var z:int = 0; z < tCount; z++)
			{
				var tMapSection:MapSection = pArray[z] as MapSection;
				tMapSection.setCollisionList(mJumper);
				tMapSection.lockdown = false;
				tMapSection = SetupLevelObjects.setupStaticObstacles(tMapSection,mJumper, tAssetInstance, GameCore.mCurrentGameLevel);
				tMapSection = SetupLevelObjects.setupMovingObstacles(tMapSection,mJumper,tAssetInstance,tCurrentLevel );
				tMapSection = SetupLevelObjects.setupPowerUps(tMapSection,mJumper,tAssetInstance,tCurrentLevel);
			 }
		}
		 
		/**
		 * @Note: SetUp Collision Effects
	 	*/
		

		protected function setupCollisionEffects():void
		{
			mCollisionEffect = new GameEffects();
			var tBIOS:NP9_BIOS = GameCore.instance.shell.mcBIOS;
			var EfxSprite:Sprite = mCollisionEffect.init(mAssetEmbedObjectData.mApplicationDomain,tBIOS.iBIOSWidth, tBIOS.iBIOSHeight);
			mLevelViewContainer.addDisplayObjectUI(EfxSprite,1,"CollisionSprite");
			
			mRockExplosion = new RockExplosion();
		
			mRockExplosion.init(mAssetEmbedObjectData.mInstance);
			
			mLevelViewContainer.addDisplayObjectUI(mRockExplosion,2,"CollisionSprite2");
			
		}
	
	
		
	}
	
}
