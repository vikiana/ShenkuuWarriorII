/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.G1156.displayObjects
{
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameApplication;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.games.inhouse.G1156.reference.SoundID_G1156;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 
	 *	This is for the Health Bar
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Game G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.19.2009
	 */
	 
	public class InGameBar extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const STARTING_HEALTH:int = 100;
		public const START_TIME:int = 90;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var mSharedEventDispatcher:MultitonEventDispatcher;

		protected var mCurrentHealth:int;
		
		public var mNewHealthBar:MovieClip 	//On Stage
		public var timerFld:TextField; 				// On Stage
		public var pointFld:TextField; 				// On Stage
		public var mQuitBtn:MovieClip; 			// On Stage
		public var mTimeBackGround:MovieClip; 		// Onstage
		public var txtScore:TextField;						// On sTAGE
		
		protected var mTime:int;
		protected var mScore:int;
		protected var mSoundManager:SoundManager;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function InGameBar():void
		{
			super();
			setupVars();
			
		}

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set health(pHealth:int):void
		{
			mCurrentHealth = 	pHealth;
		}
		
		public function get health():int
		{
			return mCurrentHealth;
		}
		
		public function get time():int
		{
			return mTime;
		}
		
		public function set time(pTime:int):void
		{
			mTime = pTime;
		}
		
		public function get quitButton():MovieClip
		{
			return mQuitBtn;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note Resets the Health Bar
		 */
		 
		 public function reset():void
		 {
		 	mNewHealthBar.gotoAndStop(1);	
			mScore = 0;
			pointFld.text = String(mScore);
			mCurrentHealth = InGameBar.STARTING_HEALTH;
			timerFld.text = String(START_TIME);
			mTime = START_TIME;	
			mTimeBackGround.gotoAndStop(1);
		 }
		
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: This updates the Bar
		 * @param			evt.oData.changeAmount			int				The Section Just Completed		
		 */
		 
		protected function updateBar(evt:CustomEvent):void
		{
			mCurrentHealth -= evt.oData.changeAmount;
			var tFrame:int;

			if (mCurrentHealth > InGameBar.STARTING_HEALTH)
			{
				mCurrentHealth = InGameBar.STARTING_HEALTH;
				tFrame = 1;	
			}
			else if (0 >= mCurrentHealth)
			{
				mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.PLAYER_DIED));	
				tFrame = 100;
			}
			else
			{
			tFrame = InGameBar.STARTING_HEALTH - mCurrentHealth;
			}
			
			
			mNewHealthBar.gotoAndStop(tFrame);	
			
		}
		
		protected function onUpdateTimer(evt:Event):void
		{
			mTime--;
		
			if (0 >= mTime)
			{
				mTime = 0;
				mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_TIMEOUT_EVENT));
				mSoundManager.stopSound(SoundID_G1156.SND_CLOCKTICKETING);
				mTimeBackGround.gotoAndStop(2);			
			}
			else if (15 > mTime)
			{
				if ( !mSoundManager.checkSoundState(SoundID_G1156.SND_CLOCKTICKETING))
				{
					mSoundManager.soundPlay(SoundID_G1156.SND_CLOCKTICKETING);	
				}
				
				if ( mTimeBackGround.currentFrame == 1)
				{
					mTimeBackGround.gotoAndStop(2);		
				}
				else
				{
					mTimeBackGround.gotoAndStop(1);
				}
			}
			else
			{
				if ( mSoundManager.checkSoundState(SoundID_G1156.SND_CLOCKTICKETING))
				{
					mSoundManager.stopSound(SoundID_G1156.SND_CLOCKTICKETING);
				}	
			}
			
			
			timerFld.text = String(mTime);
		}
		
		/**
		 * @Note: This updates the Bar
		 * @param			evt.oData.changeAmount			int				Amount to Change the Score By		
		 */
		 
		protected function updateScore(evt:CustomEvent):void
		{
			mScore += 	evt.oData.changeAmount;
			ScoreManager.instance.changeScore(evt.oData.changeAmount);
			pointFld.text = String(mScore);
		}
		
		/**
		 * @Note: This updates the Bar
		 * @param			evt.oData.changeAmount			int				Amount to Change the Score By		
		 */
		 
		protected function updateTime(evt:CustomEvent):void
		{
			mTime += evt.oData.changeAmount;
			
			if (mTime > START_TIME) 
			{
				mTime = 	START_TIME;
			}
			
			timerFld.text = String(mTime);
		}
		
		
		 /**
		 * @Note: The Game is ready to go to a New Level
		 * @param 	evt.oData.level			int			The Level the Game Needs to go to
		 */
		 
		 protected function setupNewLevel(evt:CustomEvent):void
		 {
			mTime = START_TIME;
			timerFld.text = String(mTime);
		 }
		 
		 /**
		 * @Note: Resets All the Items on the Object
		 */
		 
		 protected function killListeners (evt:Event):void
		 {
		 	mSharedEventDispatcher.removeEventListener( GameEvents.GAME_SLOW_TIMER_EVENT, onUpdateTimer);
			mSharedEventDispatcher.removeEventListener(GameEvents.HEALTH_CHANGE, updateBar);
			mSharedEventDispatcher.removeEventListener(GameEvents.SCORE_CHANGE, updateScore);
			mSharedEventDispatcher.removeEventListener(GameEvents.TIME_CHANGE, updateTime);
			mSharedEventDispatcher.removeEventListener(GameEvents.LEVEL_RESET, setupNewLevel);
			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners);
			mSharedEventDispatcher.removeEventListener(GameApplication.EVENT_PLAYER_LANDED, killSound);
			
			mQuitBtn.removeEventListener(MouseEvent.MOUSE_UP, onActivateQuitBtn);
			mQuitBtn.removeEventListener(MouseEvent.MOUSE_OVER, onRolloverQuitBtn);
			mQuitBtn.removeEventListener(MouseEvent.MOUSE_OUT, onRollOutQuitBtn);	
		 }
		 
		 protected function onActivateQuitBtn(evt:MouseEvent):void
		 {
		 	mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.QUIT_GAME));	
		 }
		  
		  protected function onRolloverQuitBtn(evt:MouseEvent):void
		 {
		 	mQuitBtn.gotoAndStop("on");
		 }
		  protected function onRollOutQuitBtn(evt:MouseEvent):void
		 {
		 	mQuitBtn.gotoAndStop("off");	
		 }
		 
		 /**
		 * @Player has landed so turn off the Sound
		 */
		 
		 protected function killSound(evt:Event):void
		 {
		 		if ( mSoundManager.checkSoundState(SoundID_G1156.SND_CLOCKTICKETING))
				{
					mSoundManager.stopSound(SoundID_G1156.SND_CLOCKTICKETING);
				}	
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			mSharedEventDispatcher.addEventListener( GameEvents.GAME_SLOW_TIMER_EVENT, onUpdateTimer, false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.HEALTH_CHANGE, updateBar, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.SCORE_CHANGE, updateScore, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.TIME_CHANGE, updateTime, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.LEVEL_RESET, setupNewLevel,false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners, false,0,true);
			mSoundManager = SoundManager.instance;
			
			mQuitBtn.addEventListener(MouseEvent.MOUSE_UP, onActivateQuitBtn, false, 0, true);
			mQuitBtn.addEventListener(MouseEvent.MOUSE_OVER, onRolloverQuitBtn, false, 0, true);
			mQuitBtn.addEventListener(MouseEvent.MOUSE_OUT, onRollOutQuitBtn, false, 0, true);
			mQuitBtn.mouseEnabled = true;
			
			mSharedEventDispatcher.addEventListener(GameApplication.EVENT_PLAYER_LANDED, killSound, false, 0, true);
			mCurrentHealth = InGameBar.STARTING_HEALTH;
			timerFld.text = String(START_TIME);
			mTime = START_TIME;
			mScore = 0;
		
			
		}
		
		
	}
	
}
