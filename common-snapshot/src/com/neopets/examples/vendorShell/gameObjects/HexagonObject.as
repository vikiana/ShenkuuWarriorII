
/* AS3
	Copyright 2008
*/

package com.neopets.examples.vendorShell.gameObjects
{
	import caurina.transitions.*;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 *	Simple Demo Class for an Object
	 * 		>This Object has an FadeOut Effect for onClick
	 * 		>This Object uses an TimerBased Movement System
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  04.06.2009
	 */
	 
	public class HexagonObject extends GameObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mTimer:Timer;
		protected var mDefaultEffectTime:int;
		protected var mResetTime:int;
		protected var mMoveTimer:Timer;
		protected var mMovementTime:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function HexagonObject():void{
			super();
			setupVars();
	
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is the Basic Code to Do an Effect
		 */
		public override function doEffect():void 
		{
			if (!mLockTransition)
			{
				mLockTransition = true;
				
				Tweener.addTween(
	           		this, 
	           		{
	           			alpha:0, 
	           			time:mDefaultEffectTime, 
	           			onComplete:startResetObject
	           		}
	           	);  	
			}
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onResetObject(evt:TimerEvent):void
		{
			alpha = 1;
			mLockTransition = false;
		}
		
		private function onNewMovement(evt:TimerEvent = null):void
		{
			var tNewX:Number = Math.round(Math.random() * mStartingBox.height);
			var tNewY:Number = Math.round(Math.random() * mStartingBox.width);
			var tMoveTime:Number = mMovementTime/1000;
			
			Tweener.addTween(
           		this, 
           		{
           			x:tNewX,
           			y:tNewY, 
           			time:tMoveTime, 
           			onComplete:MoveResetObject
           		}
	         );  
	
		}
		
		//--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mDefaultEffectTime = 2;
			mResetTime = 500;
			mTimer = new Timer(mResetTime);
			mTimer.addEventListener(TimerEvent.TIMER, onResetObject, false, 0 , true);	
			mMovementTime = Math.round(Math.random() * 3000) + 2000;
			mMoveTimer = new Timer(mMovementTime);
			mMoveTimer.addEventListener(TimerEvent.TIMER, onNewMovement,false,0,true);
		}
		
		private function startResetObject():void
		{
			mTimer.reset();
			mTimer.start();	
		}
		
		private function MoveResetObject():void
		{
			mMoveTimer.reset();
			mMoveTimer.start();
			
			var tRandom:Number = Math.random() * 1;
			var tSpinTest:Boolean = (tRandom > .5) ? true : false;
			
			if (tSpinTest) 
			{
				 gotoAndPlay(1);	
			}
			else
			{
				gotoAndStop(1);
			}	
		}
		
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note after the Parent is Done with its setup, this is used.
		 */
		 
		protected override function doLocalSetup():void 
		{
			mScoreValue += 50;
			onNewMovement();
		}

	}
	
}
