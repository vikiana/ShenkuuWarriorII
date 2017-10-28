/*
 *
 *
 *
 *
 */
 
 package com.neopets.users.abelee.resources.particles
 {
	 
	 //--------------------------------------------------
	 // IMPORTS 
	 //--------------------------------------------------
	 import flash.display.Sprite;
	 import flash.display.DisplayObject;
	 
	 //--------------------------------------------------
	 // CUSTOM IMPORTS 
	 //--------------------------------------------------
	 
	 public class AbstractParticle extends Sprite
	 {
		 //--------------------------------------------------
		 // CONSTANT
		 //--------------------------------------------------
		 public static const ALPHA_DOWN:String = "alpha_down";
		 public static const SCALE_DOWN:String = "scale_down";
		 public static const OFF_STAGE:String = "off_stage";
		 
		 //--------------------------------------------------
		 // VARIABLES
		 //--------------------------------------------------
		 
		 private var mActive:Boolean;
		 private var mParticleImage:DisplayObject;
		 private var mPosX:Number;
		 private var mPosY:Number;
		 private var mPower:Number;
		 private var mAccelerationX:Number
		 private var mAccelerationY:Number
		 private var mAngleOn:Boolean;
		 private var mAngleRad:Number;
		 private var mAngleDeg:Number;
		 private var mGravity:Array;
		 private var mFriction:Number;
		 private var mWeight:Number;
		 private var mLifeSpan:int;
		 private var mTerminationStart:int;
		 private var mParticleArray:Array;
		 
		 //use it for termination
		 private var mAlpha:Number;
		 private var mScale:Number;
		 
		 //--------------------------------------------------
		 // CONSTRUCTOR
		 //--------------------------------------------------
		 public function AbstractParticle (pParticleArray:Array, px:Number, py:Number, pPower:Number, pParticleImage:DisplayObject, pTerminateCondition:Object, pGravity:Array = null, pFriction:Number = 0, pAngleOn:Boolean = false, pAngleRad = 0)
		 {
			init(pParticleArray, px, py, pPower, pParticleImage, pTerminateCondition, pGravity, pFriction, pAngleOn, pAngleRad);
		 }
		 //--------------------------------------------------
		 // SETTERS AND GETTERS
		 //--------------------------------------------------
		 public function get image():DisplayObject
		 {
			return mParticleImage;
		 }
		 
		 public function get angleOn():Boolean
		 {
			return mAngleOn;
		 }
		 
		 public function set angleOn(b:Boolean):void
		 {
			mAngleOn = b;
		 }
		 
		 public function get active():Boolean
		 {
			return mActive; 
		 }
		 
		 //--------------------------------------------------
		 // PUBLIC METHODS
		 //--------------------------------------------------
		 public function update ():void
		 {
			 if (mActive)
			 {
				 calculatePosition()
				 updateImagePosition()
	
				 if (mAngleOn)
				 {
					updateAngle()
					updateImageAngle()
				 }
				  
				 mLifeSpan <= mTerminationStart ? mLifeSpan ++: terminationUpdate();
			 }
		 }
		 
		 public function reset ():void
		 {
			//override by the children 
		 }
		 
		 public function cleanup ():void
		 {
			 mActive = undefined
			 mParticleImage = null
			 mPosX = undefined;
			 mPosY = undefined;
			 mPower = undefined;
			 mAccelerationX = undefined;
			 mAccelerationY = undefined;
			 mAngleOn = undefined
			 mAngleRad = undefined;
			 mAngleDeg = undefined;
			 mGravity = null
			 mFriction  = undefined;
			 mWeight  = undefined;
			 mLifeSpan  = undefined;
			 mTerminationStart = undefined;
			 //mParticleArray = null
			 
			 
			 mAlpha = undefined;
			 mScale = undefined;  
		 }
		 
		 //--------------------------------------------------
		 // PRIVATE METHODS 
		 //--------------------------------------------------
		 private function init(pParticleArray:Array, px:Number, py:Number, pPower:Number, pParticleImage:DisplayObject, pTerminateCondition:Object, pGravity:Array, pFriction:Number, pAngleOn:Boolean, pAngleRad:Number):void
		 {
			mActive = true;
			mPosX = px;
			mPosY = py;
			mPower = pPower;
			mAccelerationX = Math.cos(pAngleRad) * mPower
			mAccelerationY = Math.sin(pAngleRad) * mPower
			mParticleImage = pParticleImage;
			mParticleImage.x = mPosX;
			mParticleImage.y = mPosY;
			mGravity = pGravity == null ? [0,0]:pGravity;
			mFriction = 1 - pFriction;		//so friction must be between 1 to -1
			mAngleOn = pAngleOn;
			mAngleRad = pAngleRad;
			mAngleDeg = mAngleRad * 180 / Math.PI;
			mParticleImage.rotation = mAngleDeg;
			mLifeSpan = 0
			mTerminationStart = 4
			//mParticleArray = pParticleArray
			mWeight = Math.random()*.05
			
			//mParticleArray.push(this)
		 }
		 
		 private function calculatePosition():void
		 {
			mAccelerationX = mAccelerationX * (mFriction * (1 - mWeight)) + mGravity[0] 
			mAccelerationY = mAccelerationY * (mFriction * (1 - mWeight)) + mGravity[1]
			mPosX += mAccelerationX
			mPosY += mAccelerationY
		 }
		 private function updateImagePosition():void
		 {
			mParticleImage.x = mPosX;
			mParticleImage.y = mPosY;
		 }
		 
		 private function updateAngle():void 
		 {
			mAngleRad = Math.atan2(mAccelerationY, mAccelerationX);
			mAngleDeg = mAngleRad * 180/Math.PI
		 }
		 
		 private function updateImageAngle():void
		 {
			mParticleImage.rotation = mAngleDeg 
		 }
		 
		 
		 private function terminationUpdate():void
		 {
			//trace ("start dying")
			mParticleImage.alpha -= .01
			if (mParticleImage.alpha <= 0)
			{
				mParticleImage.visible = false
				terminate();
				
			}
			
		 }
		 
		 private function terminate()
		 {
			 mActive = false
			 //removeFromArray();
			 //cleanup();
		 }
		 
		 private function removeFromArray()
		 {
			 /*
			for (var i in mParticleArray)
			{
				if (mParticleArray[i] == this)
				{
					mParticleArray.splice(i, 1);
				}
			}*/
		 }
		 
		
		 //--------------------------------------------------
		 // EVENT LISTENER
		 //--------------------------------------------------
		 
	 }
	 
 }
 
 