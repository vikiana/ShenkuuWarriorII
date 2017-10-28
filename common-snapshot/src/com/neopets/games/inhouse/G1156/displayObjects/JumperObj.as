/* 
	AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.G1156.displayObjects
{
	import caurina.transitions.*;
	
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameApplication;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	import fl.transitions.easing.Strong;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 *	This is the Basic for a Jumper Icon
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  3.04.2009
	 */
	 
	public class JumperObj extends AbsInteractiveDisplayObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const EVENT_ACTIVATE_PARACHUTE:String = "JumperActivateParachute";
		public static const COLLISION_TYPE:String = "JumperObject";
		public static const START_JUMPER_X:int = 300;
		public static const START_JUMPER_Y:int = 200;
		public static const JUMPER_ID:String = "Jumper";
		
		public static const EVENT_JUMPER_FADEOUT_COMPLETED:String = "JumperHasFadedout";
	
		public const ACTION_LEFT:String = "left";
		public const ACTION_RIGHT:String = "right";
		public const ACTION_RESET:String = "reset";
		public const ACTION_HURT:String = "hurt";
		public const ACTION_UP:String = "up";
		public const ACTION_DOWN:String = "down";
		public const ACTION_LAND:String = "land";
		public const ACTION_DEATH:String = "death";
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		protected var mParachuteActive:Boolean;
		protected var mResetPositionFlag:Boolean;
		protected var mResetTimer:Timer;
		
		protected var mDeathTimer:Timer;
		
		protected var mMoveToCenterTimer:Timer;
		protected var mParachuteActionLock:Boolean;
		
		protected var mAutoMovementLock:Boolean = false;
		
		
		protected var mMaxSpeed:Number = 16;
		protected var mMinSpeed:Number = 0;
		protected var mDecSpeed:Number = .5;
		protected var mAccSpeed:Number = 4;
		protected var mFirstThrust:Number = 8;
		protected var mMoveRatio:Number = 1;
	
		protected var mRightSpeed:Number;
		protected var mLeftSpeed:Number;
		protected var mUpSpeed:Number;
		protected var mDownSpeed:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function JumperObj():void
		{
			super();
			setupJumperVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get parachuteReleased():Boolean
		{
			return mParachuteActive;
		}
		
		public function set parachuteReleased(pFlag:Boolean):void
		{
			mParachuteActive = pFlag;
		}
		
		public function get resetPositionFlag():Boolean
		{
			return mResetPositionFlag;
		}
		
		public function set resetPositionFlag(pFlag:Boolean):void
		{
			mResetPositionFlag = pFlag;
		}
		
		public function set parachuteActionLock(pFlag:Boolean):void
		{
			mParachuteActionLock = pFlag;
		}
		
		public function get parachuteActionLock():Boolean
		{
			return mParachuteActionLock;
		}
		
		
		public function set autoMovementLock (pFlag:Boolean):void
		{
			mAutoMovementLock = pFlag;
		}
		
		
		
	
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Resets the Horizontal Speed to 0
		 */
		 
		public function clearHorizontalVelocity():void
		{
			mRightSpeed = 0;
			mLeftSpeed = 0;	
		}
		
		/**
		 * Resets the Vertical Speed to 0
		 */
		 
		public function clearVerticalVelocity():void
		{
			mUpSpeed = 0;
			mDownSpeed	= 0;
		}
		
		/**
		 * Clears All Speed to 0
		 */
		 
		public function clearAllVelocity():void
		{
			mRightSpeed = 0;
			mLeftSpeed = 0;	
			mUpSpeed = 0;
			mDownSpeed	= 0;
		}
		
		
		/**
		 * @Note: Controls the Avatar
		 * @param		pAction		String		What Visible Action
		 */
		 
		public function freeFallAction(pAction:String):void
		{
			if (pAction == ACTION_LAND)
			{
				gotoAndStop("parachute_land");		
			}
			 else if  (pAction == ACTION_DEATH)
			{
						gotoAndStop("parachute_death");	
						mDeathTimer.start();
			}
			else if ( !mParachuteActionLock)
			{
 				switch (pAction)
				{
					case ACTION_UP:
						gotoAndStop("parachute_up");	
						mResetTimer.start();
					break;
					case ACTION_DOWN:
						gotoAndStop("parachute_down");	
						mResetTimer.start();
					break;
					case ACTION_LEFT:
						if (mParachuteActive)
						{
							gotoAndStop("parachute_left");		
						}
						else
						{
							gotoAndStop("fall_left");		
						}
					
						mResetTimer.start();
					break;
					case ACTION_RIGHT:
						if (mParachuteActive)
						{
							gotoAndStop("parachute_right");		
						}
						else
						{
							gotoAndStop("fall_right");			
						}
						
						mResetTimer.start();
					break;
					case ACTION_HURT:
						if (mParachuteActive)
						{
							gotoAndStop("parachute_hurt");			
						}
						else
						{
							gotoAndStop("fall_hurt");				
						}
						
						mResetTimer.start();
					break;
					case ACTION_LAND:
						
					break;
					
					default:   // Reset
						if (mParachuteActive)
						{
							gotoAndStop("parachute_default");
						}
						else
						{
							gotoAndStop("fall_default");			
						}
							
					break;
				}	
			
			}
		}
		
		/**
		 * @Note: Turns off the Reset of the Character
		 */ 
		 
		public function turnOffResetToCenter():void
		{
			mMoveToCenterTimer.stop();
			resetPositionFlag = true;
			mMoveToCenterTimer.removeEventListener( TimerEvent.TIMER, resetMoveToCenter);
		}
		
		/**
		 * @Note: Turns On the Reset of the Character
		 */ 
		 
		public function turnOnResetToCenter():void
		{
			resetPositionFlag = false;
			mMoveToCenterTimer.addEventListener( TimerEvent.TIMER, resetMoveToCenter, false, 0, true);
		}	
		
		/**
		 * @Note: This sets the Direction that the Jumper is going to moce
		 * @param			pKey				int				The Keyboard Key that was pressed
		 */
		 

		
		
		public function setDirection (pKey:int):void
		{
			//trace("setDirection", pKey)
			
			 if ( !mAutoMovementLock)
			{
			 	var tSpeedCheck:Number;
			 	
			 	switch (pKey)
				{
					case Keyboard.LEFT:
					
						if (mLeftSpeed == 0 && mRightSpeed == 0)
						{
							mLeftSpeed = mFirstThrust;
						}
						else if (mLeftSpeed == 0 && mRightSpeed != 0)
						{
							mLeftSpeed = mFirstThrust/2;	
						}
					
						tSpeedCheck = mLeftSpeed + mAccSpeed;
						
						if (tSpeedCheck < mMaxSpeed)
						{
							mLeftSpeed += mAccSpeed;
						}

					break;
					case Keyboard.RIGHT:
						
						if (mLeftSpeed == 0 && mRightSpeed == 0)
						{
							mRightSpeed = mFirstThrust;
						}
						else if (mRightSpeed == 0 && mLeftSpeed != 0)
						{
							mRightSpeed = mFirstThrust/2;	
						}
							
						tSpeedCheck = mRightSpeed + mAccSpeed;
						
						if (tSpeedCheck < mMaxSpeed)
						{
							mRightSpeed += 	mAccSpeed;
						}
						
					
						
					break;
					case Keyboard.UP:
					
						if (mUpSpeed == 0 && mDownSpeed == 0)
						{
							mUpSpeed = mFirstThrust;
						}
						else if (mUpSpeed == 0 && mDownSpeed != 0)
						{
							mUpSpeed = mFirstThrust/2;	
						}
						
						tSpeedCheck = mUpSpeed + mAccSpeed;
						
						if (tSpeedCheck < mMaxSpeed)
						{
							mUpSpeed += 	mAccSpeed;
						}
						
					
					break
					case Keyboard.DOWN:
					
						if (mDownSpeed == 0 && mUpSpeed == 0)
						{
							mDownSpeed = mFirstThrust;
						}
						else if (mDownSpeed == 0 && mUpSpeed != 0)
						{
							mDownSpeed = mFirstThrust/2;	
						}
						
						tSpeedCheck = mDownSpeed + mAccSpeed;
						
						if (tSpeedCheck < mMaxSpeed)
						{
							mDownSpeed += 	mAccSpeed;
						}
						
					
					break;
				}
				
				
				
		
		}
			
		 	
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Resets the Jumper for the Next Level
		 */
		 
		protected function resetJumperObj(evt:CustomEvent):void
		{
			parachuteReleased = false;
			parachuteActionLock = false;
			this.x = JumperObj.START_JUMPER_X;
		 	this.y = JumperObj.START_JUMPER_Y;
		 	freeFallAction( ACTION_RESET);
		 	mAutoMovementLock = false;
		}
		
		/**
		 * @Note: This Moves the Jumper on a Enter Frame style Fake Tween
		 */
		 
		 protected function moveJumper(evt:Event):void
		 {
		 	var tNewXmod:Number;
		 	var tNewYmod:Number;
			var tNewY:Number;
			var tSpeedCheck:Number;
			var tSumUpSpeed:Number = 0;
			var tSumDownSpeed:Number = 0;
			var tSumLeftSpeed:Number = 0;
			var tSumRightSpeed:Number = 0;
			
			if (mLeftSpeed > 0)
			{
				tSpeedCheck = mLeftSpeed - mDecSpeed;
						
				if (tSpeedCheck >= mMinSpeed)
				{
					mLeftSpeed -= mDecSpeed
				}
				
				tSumLeftSpeed = 	mLeftSpeed * mMoveRatio;
			}
			
			if (mRightSpeed > 0)
			{
				tSpeedCheck = mRightSpeed - mDecSpeed;
						
				if (tSpeedCheck >= mMinSpeed)
				{
					mRightSpeed -= mDecSpeed
				}
				
				tSumRightSpeed = 	mRightSpeed * mMoveRatio;		
			}
			
			if (mUpSpeed > 0)
			{
				tSpeedCheck = mUpSpeed - mDecSpeed;
						
				if (tSpeedCheck >= mMinSpeed)
				{
					mUpSpeed -= mDecSpeed
				}
				
				tSumUpSpeed = 	mUpSpeed * mMoveRatio;	
			}
			
			if (mDownSpeed > 0)
			{
				tSpeedCheck = mDownSpeed - mDecSpeed;
						
				if (tSpeedCheck >= mMinSpeed)
				{
					mDownSpeed -= mDecSpeed
				}
				
				tSumDownSpeed = 	mDownSpeed * mMoveRatio;
			}
			
			tNewXmod = tSumRightSpeed - tSumLeftSpeed;
			
			this.x += tNewXmod;
			
			
			tNewYmod = tSumDownSpeed - tSumUpSpeed;
			
			tNewY = this.y + tNewYmod;
			
			if (tNewY > GameApplication.STAGE_BOTTOM_RESTRICTION)
			{
				mDownSpeed = 0;
				tNewY = this.y
			}
			
			if (tNewY < GameApplication.STAGE_TOP_RESTRICTION)
			{
				mUpSpeed = 0;
				tNewY = this.y
			}
			
			this.y = tNewY;		
			
			//trace ("tSumLeftSpeed:", tSumLeftSpeed, " tSumRightSpeed:", tSumRightSpeed, " tSumDownSpeed:",  tSumDownSpeed, " tSumUpSpeed:", tSumUpSpeed);
		 }
	
		/**
		 * @Note: The Parachute Needs to Activate
		 */
		 
		protected function activateParachuteEvent(evt:Event):void
		{
			gotoAndStop("parachute_open");
			mParachuteActive = true;
			mResetPositionFlag = false;
		}
		
			/**
		 * @Note Items been activated
		 *	@param		evt.oData.id			String 			The Name of the MapSection or "all"
		 */
		 
		 protected function activateItemChild (evt:CustomEvent):void
		 {
		 	if (GeneralFunctions.convertBoolean(evt.oData.useTimer))
	 		{
	 			mSharedEventDispatcher.addEventListener(GameEvents.GAME_SLOW_TIMER_EVENT, moveJumpertoCenter, false, 0, true);
				mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, moveJumper, false, 0, true);
		 {
		 	
		 }
	 		}
	 		else
	 		{
	 			this.addEventListener(Event.ENTER_FRAME,moveJumpertoCenter, false, 0, true);	
	 			this.addEventListener(Event.ENTER_FRAME,moveJumper, false, 0, true);	
	 		}
	 		
		 }
		 
		 /**
		 * @Note: Items been deactivated
		 */
		 
		 protected function deActivateItemChild(evt:Event):void
		 {
				mRightSpeed = 0;
				mLeftSpeed= 0;
				mUpSpeed = 0;
				mDownSpeed = 0;
		 		
		 		if (this.hasEventListener("GameEvents.GAME_TIMER_EVENT"))
		 		{
		 			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_SLOW_TIMER_EVENT, moveJumpertoCenter);	
		 		}
		 		else
		 		{
		 			this.removeEventListener(Event.ENTER_FRAME,moveJumpertoCenter);	
		 		}
		 }
		 
		
		
		 
		 
		  /**
		 * @Note: If the Jumper is not in the center, it will slowly move the Player
		 */
		protected function moveJumpertoCenter(evt:Event):void
		{
		
		}
		
		 /**
		 * @Note:Kill all Listener
		 */
		protected function killListeners(evt:Event):void
		{
			removeEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChild);
			removeEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChild);
			mSharedEventDispatcher.removeEventListener(JumperObj.EVENT_ACTIVATE_PARACHUTE, activateParachuteEvent);
			mSharedEventDispatcher.removeEventListener(GameEvents.LEVEL_RESET, resetJumperObj);
			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners);
			
		}
		
		/**
		 * @Note: Resets the MoveToCenter Function
		 */
		 
		 protected function resetMoveToCenter(evt:TimerEvent = null):void
		 {
		 	mMoveToCenterTimer.stop();
		 	resetPositionFlag = false;
		 }
		 
		 /**
		 * @Note: Resets the Jumper
		 */
		 
		 protected function resetJumper(evt:TimerEvent = null):void
		 {
		 	freeFallAction( ACTION_RESET);	
		 }
		 
		 /**
		 * @Note: Fades out the Jumper after the players dies
		 */
		 
		 protected function faideoutJumper (evt:TimerEvent):void
		 {
				Tweener.addTween(
				           		this, 
				           		{
				           			alpha:0, 
				           			time:.5, 
				           			transition:"easeInOutQuad",
				           			onComplete:jumperFadedOut
				           		}
				           	); 	
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: The Jumper has fadedout
		 */
		 
		protected function jumperFadedOut():void
		{
			dispatchEvent(new Event(JumperObj.EVENT_JUMPER_FADEOUT_COMPLETED));	
		}
		
		
		protected function setupJumperVars():void
		{
			mType = JumperObj.COLLISION_TYPE;
			mId = JumperObj.JUMPER_ID;
		
			mRightSpeed = 0;
			mLeftSpeed= 0;
			mUpSpeed = 0;
			mDownSpeed = 0;
			
			mAutoMovementLock = false;
			registerEventDispatcher(GameCore.KEY);
			
			addEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChild, false, 0, true);
			addEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChild, false, 0, true);
			mSharedEventDispatcher.addEventListener(JumperObj.EVENT_ACTIVATE_PARACHUTE, activateParachuteEvent, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.LEVEL_RESET, resetJumperObj, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners, false,0,true);
			
			mParachuteActive = false;
			mParachuteActionLock = false;
			
			mResetTimer = new Timer(1000,1);
			mResetTimer.addEventListener( TimerEvent.TIMER, resetJumper, false, 0, true);
			
			mMoveToCenterTimer = new Timer (3000,1);
			mMoveToCenterTimer.addEventListener( TimerEvent.TIMER, resetMoveToCenter, false, 0, true);
			
			mDeathTimer = new Timer(1250,1);
			mDeathTimer.addEventListener(TimerEvent.TIMER_COMPLETE, faideoutJumper, false, 0 , true);
			
			alpha = 1;
		}
		
	
		

	}
	
}
