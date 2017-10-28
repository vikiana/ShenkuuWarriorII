/**
 *	Abstract particle of particle system
 *	Hold basic stats.
 *	@NOTE: for efficiency purposes, the "image" of the particle is not contained at this class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  08.13.2009
 */

 /**
  *	////////////////////////////////////////
  *	//	TO DO /MISC NOTES
  *	////////////////////////////////////////
  *
  *	scale management (grow larger or smaller)
  *	angle/rotation mangement (rotate the object to it's trajectory angle)
  **/
 
 
package com.neopets.users.abelee.effects.particle
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.geom.Point;
	import flash.display.Sprite;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class AbsParticle
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mPos:Point;	// poistion x,y in Point
		protected var mVel:Point;	// velosity x,y in Point
		protected var mForce:Point;	// force (wind, gravity, etc.) x,y in Point
		protected var mActive:Boolean;	// true if "visually" active, false otherwise
		protected var mFriction:Number;	// friction
		protected var mDelay:uint;	// period that decay will be delayed for (larger number = longer life)
		protected var mDecay:Number = 1;	// value 1 to 0.  When hit 0, particle is considered inactive
		protected var mDecayRate:Number;
		protected var mImageName:String;	// id of the image this particle should be using
		protected var mLocation:Sprite;		//	name of the Sprite where this particle should be drawn at
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function AbsParticle():void
		{		
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get pos():Point {return mPos};
		public function set pos(pPos:Point):void {mPos = pPos}
		
		public function get force():Point {return mForce};
		public function get decay():Number {return mDecay};
		
		public function get imageName():String {return mImageName};
		public function get holder():Sprite {return mLocation};
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	initial call to make a prticle live
		 **/
		public function init(
							 pLocation:Sprite,
							 pImageName:String,
							 pPos:Point, 
							 pVel:Point, 
							 pForce:Point, 
							 pFriction:Number = 0, 
							 pDecayRate:Number = 0.02,
							 pDelay:uint = 5,
							 pActive:Boolean = true
							):void
		{
			setup(pLocation,pImageName, pPos, pVel, pForce, pFriction, pDecayRate, pDelay, pActive);
		}
		
		/**
		 *	set it to neutral/preactive state
		 *	@NOTE:	Instead of destrorying and recreating a prticle, 
		 *			reset and use it again to better processing speed
		 **/
		public function reset():void
		{
			setup(null,null, new Point(), new Point(), new Point(), 0, 0.02, 5, false);
			mDecay = 1
		}
		
		public function cleanup():void
		{
			mPos = null;
			mVel = null;
			mForce = null;
			mDelay = undefined;
			mDecay = undefined;
			mFriction = undefined;
			mActive = undefined;
			mLocation = null;
		}
		
		/**
		 *	Main behavior the particle. Currently it only accounts for velocity, friction and moves
		 *	And decays (via alpha property...rather alpha is based on decay rate)
		 **/
		public function update():void
		{
			var currentPos = new Point (mPos.x + mVel.x + mForce.x, mPos.y + mVel.y + mForce.y)
			mVel.x *= 1 - mFriction
			mVel.y *= 1 - mFriction
			
			mPos = currentPos
			if (mDelay > 0)
			{
				mDelay --
			}
			else 
			{
				mDecay -= mDecayRate
				mDecay = mDecay > 0 ? mDecay: 0;
			}
		}
	
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	setup particle properties and variables
		 **/
		protected function setup(
								 pLocation:Sprite,
								 pImageName:String,
								 pPos:Point, 
								 pVel:Point, 
								 pForce:Point, 
								 pFriction:Number, 
								 pDecayRate:Number,
								 pDelay:uint,
								 pActive:Boolean = true
								 ):void
		{
			mLocation = pLocation;
			mPos = pPos;
			mVel = pVel;
			mForce = pForce;
			mImageName = pImageName;
			mFriction = pFriction;
			mDecayRate = pDecayRate;
			mDelay = pDelay;
			mActive = pActive;
		}
			
		
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}