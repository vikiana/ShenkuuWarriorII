
/* AS3
	Copyright 2008
*/
package com.neopets.examples.gameEngineExample.gameObjects
{
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	/**
	 *	This is the Basic Game Object Class
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  4.04.2009
	 */
	 
	public class GameObject extends MovieClip implements IGameObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const SEND_SCORE:String = "GameObjectSendingScore";

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mScoreValue:int;
		protected var mID:String;

		protected var mStartingBox:Rectangle;
		protected var mLockTransition:Boolean;
		protected var mBaseScale:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function GameObject():void{
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Setup of an Object
		 */
		 
		public function init(pID:String,pBoundingBox:Rectangle,pBaseScale:Number = 1):void
		{
			mLockTransition = false;
			mScoreValue	= Math.random() * 100;
			mID = pID;
			mStartingBox = pBoundingBox;
		
			mBaseScale = pBaseScale;
			scaleX = mBaseScale;
			scaleY = mBaseScale;
			setStartLocation();
			addEventListener(MouseEvent.MOUSE_DOWN, onClick,false,0,true);
			doLocalSetup();
		}
		
		/**
		 * @Note: This is to have the object Cleanup its memory
		 */
		 
		public function doCleanUp():void
		{
			
		}
		
		/**
		 * @Note: This sets the location of the Game Objects in a Random Area within the StartingBox
		 */
		 
		public function setStartLocation():void 
		{	
			var tX:Number = 0;
			var tY:Number = 0;
			
			tX = Math.round(Math.random() * mStartingBox.height);

			tY = Math.round(Math.random() * mStartingBox.width);

			x = tX + mStartingBox.x;
			y = tY + mStartingBox.y;
		}
		
		/**
		 * @Note: This is to be OVERRIDED
		 * @Note: This is the Basic Code to Do an Effect
		 */
		public function doEffect():void {}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Handles when an GameObject is Clicked
		 */
		 
		protected function onClick(evt:Event):void
		{
			if (!mLockTransition)
			{
				this.dispatchEvent(new CustomEvent({ID:mID, SCORE:mScoreValue}, SEND_SCORE));
			
			
				doEffect();	
			}
			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is to be OVERRIDED
		 * @Note: This is to let the Child know to do setup Functions
		 * 
		 */
		 
		protected function doLocalSetup():void {}
		
		/**
		 * @Note: This is to be OVERRIDED
		 */
		 
	}
	
}
