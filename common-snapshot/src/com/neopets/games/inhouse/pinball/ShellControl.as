
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.pinball
{
	import com.neopets.games.inhouse.pinball.gui.GameOverScene;
	import com.neopets.games.inhouse.pinball.gui.GameScene;
	import com.neopets.games.inhouse.pinball.gui.InstructionScene;
	import com.neopets.games.inhouse.pinball.gui.IntroScene;
	import com.neopets.games.inhouse.pinball.gui.MessageScreen;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadedItem;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 * // This class handles all the game data and functions not specific to a single game level.
		// Author: David Cary, Clive Henrick
		// Last Updated: April 2008
 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Ape, GameEngine, PinBall
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	 
	public class ShellControl extends GameEngine 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		// scene label constants
		public const INSTRUCTION_SCENE:String = "instructionScreen";
		public const GAMEOVER_SCENE:String = "gameOverScreen";
		public const PLAY_GAME_SCENE:String = "play_game_scene";
		public const INTRO_SCENE:String = "IntroductionScene";
		
		// event constants
		public static const CHANGE_SCENE:String = "scene_change_requested";
		
		//--------------------------------------
		//  PRIVATE /PROTECTED VARIABLES
		//--------------------------------------
		protected var mCurrentSceneData:Object;
		protected var mExternalAssetsLoadedItem:LoadedItem;
		protected var mMenuViewContainer:ViewContainer;
		protected var mGameShell:GameShell;
		protected var mInstructionsPage:InstructionScene;
		protected var mIntroScreen:IntroScene;
		protected var mGameOverScreen:GameOverScene;
		protected var mMessageScreen:MessageScreen;
		protected var mMusicOn:Boolean = false;
		protected var mSoundOn:Boolean = true;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ShellControl() 
		{
			trace("MainControl called");
			mSceneArray = new Array();
			super();
			mMenuViewContainer = new ViewContainer();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function onSceneChangeRequest(ev:CustomEvent):void
		{
			trace(ev);
			gotoScene(ev.oData.scene);
		}
		
		/**
		 * @NOTE: Sets the Current Scene to Visible
		 * @Param		id			String		The Name of the Scene
		 */
		 
		public function gotoScene(id:String):void
		 {
			var entry:Object = getSceneEntry(id);
			
			if(entry == null) return; // don't go to a scene that doesn't exist
			
			// if we shifted to the game scene, start the heroes series
			var scene:GameScene = entry.scene;
			if(scene is GameShell) {
				var gs:GameShell = scene as GameShell;
				gs.series = "heroes";
			}
			
			if (scene is GameOverScene)
			{
				mGameOverScreen.showScore(mGameShell.score)
			}
			
			// check for a special transitions
			if(mCurrentSceneData != null) 
			{
				var trans:Object = mCurrentSceneData.getTransition(id);
				if(trans != null) {
					trans.func(mCurrentSceneData,entry);
					return;
				}
			}
			
			// if there are no special transitions, just show the default transition
			mCurrentSceneData = entry;
			
			var tCount:int = mSceneArray.length;
			
			for(var i:int = 0; i < tCount; i++) 
			{
				entry = mSceneArray[i];
				entry.display.visible = (entry == mCurrentSceneData);
			}
			
		}
		
		/**
		 * @NOTE: When the Play Again Button is Pressed, this clears the Game form Memory so it can be replayed
		 */
		 
		 public function resetGame():void
		 {
		 	//########### TBP ###########################	
		 	gotoScene(INTRO_SCENE);
			playSound(SoundIDs.BEEP_SHORT2);
			mGameOverScreen.showButtons();
			//mGameOverScreen.showScore(mGameShell.score)
			//mGameShell.series = "heroes";
			mGameShell.score = 0;
			
			if (mMusicOn)
			{
				soundManager.soundPlay(SoundIDs.MUSIC_LOOP, true);
			}
			
		 }
		 
		// Transition Functions
		
		public function dragDownScene(scene_a:SceneData,scene_b:SceneData):void
		 {
			scene_a.tween = new Tween(scene_a.display,"y",Regular.easeInOut,0,GameShell.SCREEN_HEIGHT,1,true);
			scene_a.tween.addEventListener(TweenEvent.MOTION_FINISH,hideTweenedClip);
			scene_b.tween = new Tween(scene_b.display,"y",Regular.easeInOut,-GameShell.SCREEN_HEIGHT,0,1,true);
			scene_b.display.visible = true;
		}
		
		public function getSceneEntry(id:String):Object 
		{
			var entry:Object;
			for(var i:int = 0; i < mSceneArray.length; i++) 
			{
				entry = mSceneArray[i];
				if(entry.id == id) return entry;
			}
			return null;
		}
		
		public function getTransition(id_a:String,id_b:String):*
		 {
			var entry:Object = getSceneEntry(id_a);
			if(entry != null) return entry.getTransition(id_b);
			else return null;
		}
		
			/** 
		 * @NOTE: Plays a Sound File through the Sound Manager
		 * @param		evt.oData.SOUND		String 			Name of the Sound File to Play
		 * @param		evt.oData.LOOP			Boolean 		Loops a Sound File
		 */
		 
		public function playSoundEvent(evt:CustomEvent):void
		{
			if (evt.oData.hasOwnProperty("LOOP"))
			{
				mSoundManager.soundPlay(evt.oData.SOUND,evt.oData.LOOP);
			}
			else
			{
				mSoundManager.soundPlay(evt.oData.SOUND);	
			}
			
		}
		
		
		/** 
		 * @NOTE: Plays a Sound File through the Sound Manager
		 * @param		pSound						String 			Name of the Sound File to Play
		 * @param		pLoop						Boolean 		Loops a Sound File
		 */
		 	public function playSound(pSound:String, pLoop:Boolean = false):void
		{
				trace("Play This Sound: ", pSound, mSoundOn);
				
				if (mSoundOn)
				{
					mSoundManager.soundPlay(pSound,pLoop);	
				}
				
		}
		 
		 
		/** 
		 * @NOTE: Stops all Sound Files through the Sound Manager
		 */
		 
		public function stopAllSoundFiles():void
		{
			mSoundManager.stopAllCurrentSounds();
		}
		
		/**
		 * @Note Swaps the Music On Mode
		 */
		 
		public function changeMusicMode (e:CustomEvent = null):void {
			
			soundManager.stopAllCurrentSounds();
			
			if (mMusicOn)
			{
				mMusicOn = false;
			}
			 else
			{
				mMusicOn = true;
				soundManager.soundPlay(SoundIDs.MUSIC_LOOP, true);
			}
		}
		
		/**
		 * @Note Swaps the Sound On Mode
		 */
		 
		public function changeSoundsMode (e:CustomEvent = null):void 
		{
			if (mSoundOn)
			{
				mSoundOn = false;
			}
			else
			{
				mSoundOn = true;
			}
		}
		
		/**
		 * @Note When the Game is Over, This is called to send you to the GameOverScene
		 */
		 
		 // The "success" parameter tells us whether they cleared the game or failed it.
		 
		public function gameIsOver (success:Boolean = false):void 
		{
			
			stopAllSoundFiles();
			
			if (success)
			{
				inGameMessager("GameWin");	
			}
			else
			{
				if (mMusicOn)
				{
					soundManager.soundPlay(SoundIDs.MUSIC_LOOP, true);	
				}
				trace ("//////////////////// going ot game over scene ///////////////")
				gotoScene(GAMEOVER_SCENE);
				//mGameOverScreen.showScore(mGameShell.score)
			}
			
			
		}
		
		/**
		 * @Note When the Game is Over, This is called to send you to the GameOverScene
		 * @param			level		String			The Message that you are Looking For 
		 */
		 
		 // The "success" parameter tells us whether they cleared the game or failed it.
		 
		public function inGameMessager (Level:String):void 
		{
			switch (Level)
			{
				case "Level1to2":
					setText( "bodyFont",mMessageScreen.textBox, mGamingSystem.getTranslation ("IDS_GAME_MESSAGE_LEVELUP1"));
				break;
				case "GameWin":
					setText( "bodyFont", mMessageScreen.textBox, mGamingSystem.getTranslation ("IDS_GAME_MESSAGE_WIN"));
					mMessageScreen.addEventListener(mMessageScreen.FAIDOUTMSG, continueGameOver);
				break;
			}
			
			mMessageScreen.startMessage();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @NOTE: When The Message Screen is Done Displaying the Win TEXT
		 */
		 
		 protected function continueGameOver (evt:Event):void
		 {
		 	mMessageScreen.removeEventListener(mMessageScreen.FAIDOUTMSG, continueGameOver);
		 	gameIsOver(false);
		 }
		 
		 
		 
		 
		/**
		 * @NOTE: When the Transition is complete, Reset the Menu
		 */
		 
		protected function hideTweenedClip(ev:TweenEvent):void
		 {
			var tw:Tween = ev.target as Tween;
			var obj:Object = tw.obj;
			
			if (obj != null)
			{
				obj.visible = false;
				obj.x = 0;
				obj.y = 0;	
			} 
			
			tw.removeEventListener(TweenEvent.MOTION_FINISH,hideTweenedClip);
		}
		
		/**
		 * @NOTE: This is for the Buttons on a SCENE. The Buttons Needed to have different names inorder for it to know what scene its from.
		 * @param			evt.oData.TARGETID			String			The Name of the Button Being Pressed
		 */
		 
		protected function onSceneButtonPressed(evt:CustomEvent):void
		{
			
			trace("Pressed", evt.oData.TARGETID);
			
			switch (evt.oData.TARGETID)
			{
				case "InstructionHelpBtn": // Instruction Scene
					gotoScene(INTRO_SCENE);
					playSound(SoundIDs.BEEP_SHORT2);
				break;
				case "sendScoreBtn":  //Game Over Scene
					playSound(SoundIDs.BEEP_SHORT2);
					mGamingSystem.sendScore(mGameShell.score);
					mGamingSystem.sendTag ("Game Finished");
					mRootMC.sendScoringMeterToFront();
					mRootMC.addEventListener(Event.ENTER_FRAME, onWaitForSendScore, false, 0, true);
					mGameOverScreen.hideButtons();
				break;
				case "restartGameBtn": //Game Over Scene
					resetGame();
				break;
				case "startBtn":  //INTRO Scene
					mGamingSystem.sendTag ("Game Started");
					gotoScene(PLAY_GAME_SCENE);
					playSound(SoundIDs.BEEP_SHORT2);
				break;
				case "goInstructionsBtn": //INTRO Scene
					gotoScene(INSTRUCTION_SCENE);
					playSound(SoundIDs.BEEP_SHORT2);
				break;
				case "soundsBtn": // Toggle Sounds on/off
					changeSoundsMode();
				break;
				case "musicBtn": //Toggles the Music Loop
					changeMusicMode();
				break;
				
			}	
		}
		
		/**
		* @Note: Just a Another way to call the score meter (NP9 Gamesystem)
		**/
		
		protected function onWaitForSendScore ( e: Event ) : void 
		{
	
			if (mGamingSystem.userClickedRestart( ) ) 
				{
					mRootMC.removeEventListener( Event.ENTER_FRAME, onWaitForSendScore );
					mRootMC.sendScoringMeterToBack();
					resetGame();
				}
			
			} 
			
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @NOTE: Called when the GameEngine has SoundsManager and All Files Loaded
		 */
		 
		protected override function initChild():void 
		{
			mExternalAssetsLoadedItem = mExternalLoader.getLoaderObj("externalAssets.swf");
		
			createMenus();
			setupText();
			
			// add special transitions
			addTransition(INTRO_SCENE,PLAY_GAME_SCENE,dragDownScene);

			gameSetupDone();
		}
	
		/**
		 * @Note  Adds fonts needed for the game
		 */

		private function setupText():void
		{
			var FontClass:Class = ApplicationDomain.currentDomain.getDefinition("BoisterBlackEuro") as Class;
			mGamingSystem.addFont( new FontClass(), "bodyFont" );
			
			var FontClass2:Class = ApplicationDomain.currentDomain.getDefinition("LucidaConsole") as Class;
			mGamingSystem.addFont( new FontClass2(), "PinballCabinetFont" );
			
			setText( "bodyFont",mInstructionsPage.InstructionHelpBtn.label_txt, mGamingSystem.getTranslation ("IDS_INSTRUCTIONS_BUTTON_BACK"));
			setText( "bodyFont", mInstructionsPage.instructionTF, mGamingSystem.getTranslation ("IDS_INSTRUCTIONS_CONTENT"));
			setText( "bodyFont", mInstructionsPage.textBox, mGamingSystem.getTranslation ("IDS_INSTRUCTIONS_TITLE"));
		
		
			setText( "bodyFont",mGameOverScreen.sendScoreBtn.label_txt, mGamingSystem.getTranslation ("IDS_GAMEOVER_SEND_SCORE"));
			setText( "bodyFont", mGameOverScreen.restartGameBtn.label_txt, mGamingSystem.getTranslation ("IDS_GAMEOVER_RESTART_BUTTON"));
			setText( "bodyFont", mGameOverScreen.textBox, mGamingSystem.getTranslation ("IDS_GAMEOVER_TEXT"));
			
			setText( "bodyFont",mIntroScreen.startBtn.label_txt, mGamingSystem.getTranslation ("IDS_MAIN_MENU_BUTTON_PLAY"));
			setText( "bodyFont",mIntroScreen.startBtn.label_txt_Down, mGamingSystem.getTranslation ("IDS_MAIN_MENU_BUTTON_PLAY"));
			setText( "bodyFont",mIntroScreen.startBtn.label_txt_On, mGamingSystem.getTranslation ("IDS_MAIN_MENU_BUTTON_PLAY"));
			
			setText( "bodyFont", mIntroScreen.goInstructionsBtn.label_txt, mGamingSystem.getTranslation ("IDS_MAIN_MENU_BUTTON_INSTRUCTIONS"));
			setText( "bodyFont", mIntroScreen.goInstructionsBtn.label_txt_Down, mGamingSystem.getTranslation ("IDS_MAIN_MENU_BUTTON_INSTRUCTIONS"));
			setText( "bodyFont", mIntroScreen.goInstructionsBtn.label_txt_On, mGamingSystem.getTranslation ("IDS_MAIN_MENU_BUTTON_INSTRUCTIONS"));

		  	mIntroScreen.setTranlationLogo(mGamingSystem.getFlashParam("sLang").toLowerCase());
		}
		
		/**
		 * @Note Creates all the Menus from the External Artwork Files in an AssetSwf
		 */

		protected function createMenus():void
		{

			loadScene(INSTRUCTION_SCENE,"mcInstructionScene",2);
			loadScene(INTRO_SCENE,"mcIntroScene",1);
			loadScene(GAMEOVER_SCENE,"mcGameOverSceen",3);
			loadScene(PLAY_GAME_SCENE,"mcIntroScene",0);
			
			//Creates the Message Screen
			mMessageScreen = mExternalAssetsLoadedItem.getObjectOutofLibrary_ParentDomain("mcMessageScreen") as MessageScreen;
			mMessageScreen.x = mMessageScreen.STARTX;
			mMessageScreen.y = mMessageScreen.STARTY;
			mMenuViewContainer.addDisplayObjectUI(mMessageScreen,mMenuViewContainer.numChildren,"MessageScreen",null,false);
		
		}
		
		
		 /**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  *		> ReOrders the ViewContainers
		  * 	> Adds the mMenuViewContainer View Contaienr to the GameEngines ViewContainer
		  * 	> Tells the GameEngine it is ready
		  * */
		  
		  protected function gameSetupDone():void
		  {
		  	mMenuViewContainer.reOrderDisplayList();
		  	mViewContainer.addUIViewContainer(mMenuViewContainer,0,"GameVC");
			gotoScene(INTRO_SCENE);
		   	completedSetup();
		   	
		  // 	inGameMessager("Level1to2");
		  }
		  
	// Scene Management Functions
		
		/**
		 * @NOTE: This will go into the loaded ExternAssets.swf and pull items out of its Library for Scenes
		 * 	Then it will setup the Scene and call the Add Scene.
		 * @param		id						String		The Name of the Scene
		 * @param		filename			String		The Name of the Item in the flash Library
		 * @param		pIndex				int				The Order of the Object in the ViewContainer
		 */
		 
		protected function loadScene(id:String,filename:String,pIndex:int = 0):void
		 {
			
			switch (id)
			{
				case INSTRUCTION_SCENE:
					mInstructionsPage = mExternalAssetsLoadedItem.getObjectOutofLibrary_ParentDomain(filename) as InstructionScene;
					mInstructionsPage.controller = this;
					mInstructionsPage.addEventListener("ButtonhasbeenPressed", onSceneButtonPressed);
					addScene(id,mInstructionsPage,pIndex);
				break;
				case GAMEOVER_SCENE:
					mGameOverScreen = mExternalAssetsLoadedItem.getObjectOutofLibrary_ParentDomain(filename) as GameOverScene;
					mGameOverScreen.controller = this;
					mGameOverScreen.addEventListener("ButtonhasbeenPressed", onSceneButtonPressed);
					addScene(id, mGameOverScreen, pIndex);
				break;
				case PLAY_GAME_SCENE:
					mGameShell = new GameShell (mRootMC)
					mGameShell.controller = this;
					mGameShell.loadData();
					addScene(PLAY_GAME_SCENE,mGameShell,0);
				break;
				case INTRO_SCENE:
					mIntroScreen = mExternalAssetsLoadedItem.getObjectOutofLibrary_ParentDomain(filename) as IntroScene;
					mIntroScreen.controller = this;
					mIntroScreen.addEventListener("ButtonhasbeenPressed", onSceneButtonPressed);
					addScene(id,mIntroScreen,pIndex);
					changeMusicMode();
					
				break;
				
			}
			
		}
		
		// use this function to attach a scene to the stage.
		protected function addScene(id:String,dobj:DisplayObject,pIndex:int):Object
		 {
			// make sure the scene hasn't already been created
			var entry:Object = getSceneEntry(id);
			if(entry != null) return entry;
			// create a new entry
			entry = new SceneData(id,dobj,this);
			mSceneArray.push(entry);
			
			mMenuViewContainer.addDisplayObjectUI(entry.display,pIndex,id,null,false);
			//mRootMC.addChild(entry.display);
			return entry;
		}
		
			protected function addTransition(id_a:String,id_b:String,func:Function):Object
			 {
			// check if the transition already exists
			var trans:Object = getTransition(id_a,id_b);
			if(trans != null) return trans;
			// if not, try to create a new transition
			var entry:Object = getSceneEntry(id_a);
			if(entry != null) return entry.addTransition(id_b,func);
			else return null;
		}
		
		
	}
}
