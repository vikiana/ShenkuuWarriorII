/**
 *	Main Game file for slot machine game
 *	This handles all business until the slot game has started.  once slotmachine core has been instantiated
 *	This class is only responsible for music and sound on
 *
 *	General Game flow
 *	MainGame -> intro page -> (-> back to MainGame ->) Slot machine (SlotMachine core) and play the game
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee /C
 *	@since  03.26.2009
 */



package com.neopets.games.inhouse.brucyBSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.*;
	import com.neopets.util.sound.*;
	
	import flash.events.Event;
	import flash.sampler.startSampling;
	import flash.system.ApplicationDomain;
		import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.loading.LoadingEngineXML;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.projects.mvc.model.SharedListener;
	import com.neopets.util.display.ViewContainer;
	
	public class MainGame extends GameEngine
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mMasterLoader:Object; 	// handles all loading files (xml, art asset, etc.)
		private var mSlotMachine:SlotMachineCore;	// all things slot machine
		private var mIntroPage:IntroPage;	// all things introPage
		private var mInstructionsPage:InstructionsPage;	// all things instructions
		private var mSoundBank:Object	//all sounds is linked here
		private var mSoundOn:Boolean;
		private var mMusicOn:Boolean;
		private var mStartWithIntroScreen:Boolean = true;
		//################ ADDED
		private var mGameScreen:ViewContainer;
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function MainGame():void
		{
			super();
		}
		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		public function get mainTimeLine():Object
		{
			//return _ROOT		//	this is for old gaming system to get to the root
			return mRootMC;		//	this is for newer gaming system to get to the root
		}
		
		public function get system():Object
		{
			//return _GAMINGSYSTEM		//	this is for old gaming system to get to the gaming system
			return mGamingSystem		//	this is for newer gaming system to get to the gaming system
		}
		
		/** 
		 * This is hardwired for only the AssetLibrary
		 */

		public function get assetInfo():ApplicationDomain
		{
			//return mMasterLoader.myAsset.artAssetInfo
			var LoadedObject:LoadedItem = loadingEngine.getLoaderObjmID("externalAssetStorage");
			return LoadedObject.localApplicationDomain;
		}
		
		public function get soundBank():Object
		{
			return mSoundBank
		}
		
		public function get soundOn():Boolean
		{
			return mSoundOn
		}
		
		public function set soundOn(b:Boolean):void
		{
			mSoundOn = b
		}
		
		public function get musicOn():Boolean
		{
			return mMusicOn
		}
		
		public function set musicOn(b:Boolean):void
		{
			mMusicOn = b
		}		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		
		
		public function playThisSound(sound:String, condition:Boolean, loop:Boolean = false):void {
			if (condition) mSoundManager.soundPlay(sound,loop);
		}
		
		public function stopThisSound(sound:String):void {
			mSoundManager.stopSound(sound);
		}
		
		public function changeThisVolume(sound:String, pVolume:Number):void {
			mSoundManager.changeSoundVolume(sound,pVolume);
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		
		
		
		////
		// set up all inital variables for the game
		////
		
		private function variableInit():void
		{
			//Create a ViewContainer for the Game
			mGameScreen = new ViewContainer("GameScreen");
						
			//slot machine
			trace("////////////////////////////////////////////////////////////////")
			mSlotMachine = new SlotMachineCore (this);
			
			mIntroPage = new IntroPage (this);
			mInstructionsPage = new InstructionsPage(this);
			mSoundBank = new Object ()
			mSoundOn = true;
			mMusicOn = true;
		}
		
		////
		// All the sound is linked as an object.  Other class will access via mSoundBank refernce only
		// thus the actual sound has to be changed only once here 
		////
		private function soundInit():void
		{	
			mSoundBank.machineClick = "MachineClickSound";
			mSoundBank.explosion  = "ExplosionSound";
			mSoundBank.line = "LineSound";
			mSoundBank.stake = "StakeSound";
			mSoundBank.happy = "HappySound";
			mSoundBank.metal = "MetalSound";
			mSoundBank.button = "MetalSound";
			mSoundBank.roll = "SlotRollSound"; 
			mSoundBank.bg = "BackgroundMusic";
			mSoundBank.jackpot = "JackpotSound";
			mSoundBank.winShort = "WinShortSound";		
			mSoundBank.winLong = "WinLongSound";
			
			playThisSound(mSoundBank.bg, mMusicOn, true);
		}
		
		
		////
		// Adds fonts needed for the game
		////
		private function addFonts():void
		{
			var headerFontClass:Class = assetInfo.getDefinition("_HEADER_FONT") as Class;
			var bodyFontClass:Class = assetInfo.getDefinition("_BODY_FONT") as Class;
			var timeNewRoman:Class = assetInfo.getDefinition("TimesNewRoman") as Class;
			var messageFontClass:Class = assetInfo.getDefinition("message_font") as Class;
		
			mGamingSystem.addFont( new headerFontClass(), "headerFont" );
			mGamingSystem.addFont( new bodyFontClass(), "bodyFont" );
			mGamingSystem.addFont( new timeNewRoman(), "times" );
			mGamingSystem.addFont( new messageFontClass(), "messageFont" );
			
		}
		
		
		
		////
		// sets up the slot machine
		////
		private function setupSlotMachine():void
		{
			var numSlots:int = int(this.configXML.GAME.gameSetup.@slot.split("||").length);
			trace ("init my slot machine")
			mSlotMachine.init(numSlots);
			mGameScreen.addDisplayObjectUI(mSlotMachine,0,"SlotMachine");
			mSlotMachine.addEventListener("endGame", endGame);
			addEventListener("updateMusicStatus", musicFunctionCalls)	//from IntroPage and controlPanel class an event can be dispatched to update sound settings
		}
		
		////
		// sets up the introducntion page
		////
		private function setupIntroPage():void
		{
			mRootMC.testText.text ="intro page initiated"
			mIntroPage.init();
			mGameScreen.addDisplayObjectUI(mIntroPage,1,"IntroPage");
			mIntroPage.addEventListener("updateIntroStatus", introFunctionCalls)
		}
		
		
		////
		// sets up the instruction page
		////
		private function setupInstructionsPage():void
		{
			mInstructionsPage.init(this);
			mGameScreen.addDisplayObjectUI(mInstructionsPage,2,"InstructionPage");
			mInstructionsPage.addEventListener("updateInstructionsStatus", instructionsFunctionCalls)
		}
		
		
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		////
		//when assets are loaded and the NP9_GS is loaded, it should continue with the setup
		////
		private function setupAssetHandler(e:Event = null):void
		{
			
			//mRootMC.testText.text ="art asset loaded"
			//mRootMC.arrow.stop
			//mRootMC.removeChild(mRootMC.getChildByName("arrow"))
			
			variableInit()
			addFonts();
			soundInit();
			if( mStartWithIntroScreen)
			{
				setupIntroPage();
			}
			else
			{
				setupSlotMachine();
			}
			
			gameSetupDone();
			
		}

		////
		//	When any buttons are clicked from intro page, it'll dispatch an event.
		//	And this will handle what should happen
		////
		private function introFunctionCalls(evt:Event):void
		{
			var clickedButton:String = mIntroPage.clickedButton
			trace ("MAIN GAME:", clickedButton)
			switch (clickedButton) {
				case IntroPage.PLAY_GAME:
					mIntroPage.removeEventListener("updateIntroStatus", introFunctionCalls)
					mIntroPage.cleanup();
					mGameScreen.removeUIDisplayObject("IntroPage");
					//removeChild(mIntroPage)
					setupSlotMachine();
					break;
				case IntroPage.VIEW_INSTRUCTIONS:
					mIntroPage.removeEventListener("updateIntroStatus", introFunctionCalls)
					mIntroPage.cleanup();
					mGameScreen.removeUIDisplayObject("IntroPage");
					//removeChild(mIntroPage)
					setupInstructionsPage();
					break;
				case IntroPage.SOUND_ON:
					mSoundOn = true;
					break;
				case IntroPage.SOUND_OFF:
					mSoundOn = false;
					
					break;
				case IntroPage.MUSIC_ON:
					mMusicOn = true;
					playThisSound(mSoundBank.bg, mMusicOn, true);
					break;
				case IntroPage.MUSIC_OFF:
					mMusicOn = false;
					stopThisSound(mSoundBank.bg);
					break;
			}
		}
		
		
		////
		//	play or stop the main background music based on its setting
		////
		private function musicFunctionCalls(evt:Event):void
		{
			mMusicOn? playThisSound(mSoundBank.bg, mMusicOn, true): stopThisSound(mSoundBank.bg);
		}
		
		////
		//	When any buttons are clicked from instruction page, it'll dispatch an event.
		//	And this will handle what should happen
		////
		private function instructionsFunctionCalls(evt:Event):void
		{
			var clickedButton:String = mInstructionsPage.clickedButton
			trace (clickedButton)
			switch (clickedButton) {
				case InstructionsPage.BACK_BUTTON:
					mInstructionsPage.removeEventListener("updateInstructionsStatus", introFunctionCalls)
					mInstructionsPage.cleanup();
					mGameScreen.removeUIDisplayObject("InstructionPage");
					setupIntroPage();
					break;
			}
		}
		
		// it's here in case, but this game never calls for endGame
		private function endGame(evt:Event):void
		{
			mSlotMachine.cleanup();
			mSlotMachine.removeEventListener("endGame", endGame);
			setupIntroPage();
		}
		
		//--------------------------------------
		//  GAME ENGINE FUNCTIONS
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
			//trace ("what is my root", mRootMC)
			mRootMC.testText.text = "initiated"
		  	setupAssetHandler();
		  }
		  
		  /**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  *		> ReOrders the ViewContainers
		  * 	> Adds the GameDemo View Contaienr to the GameEngines ViewContainer
		  * 	> Tells the GameEngine it is ready
		  * */
		  
		  protected function gameSetupDone():void
		  {
			mRootMC.testText.text ="game set up is done"
		  	mGameScreen.reOrderDisplayList();
		  	mViewContainer.addUIViewContainer(mGameScreen,0,"GameDemoVC");
		  	trace("GameEngineDemo VC has", mGameScreen.numChildren);
		   	completedSetup();
		  }
		  
	}
}
	
	
	