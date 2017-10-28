/**
 *	Main character
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  aug.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.characters
{

	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;
	import com.neopets.util.sound.GameSoundManager;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.Sounds
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	
	public class MainCharacter extends AbsCharacter
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mAngle:Number = 0;	//image rotation
		private var mLineOn:Boolean = false;	//true if interacting w/ lines	
		private var	mCenterX:Number	= GameData.anchorX //character's neutral x position it'll try to goto 
		private var mRadius:Number = 10 //MovieClip(mImage).core.width/2;
		private var mInvincible:int = 0	// if greater than 0, you are invincible 
		private var mBuffer:int	= 0	// when hit by enemies, give invincible buffer for short time
		private var mDoublePoint:int = 0 // if greater than 0, all scores are doubled
		private var mLife:int = 100
		private var mPushback:int = 0;
		private var mPushAng:Number = 0;
		private var mLandingPt:Point;	//when game is completed, the ship to land to this point
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MainCharacter():void
		{
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		public function get doublePoint():int
		{
			return mDoublePoint;
		}
		
		public function get buffer():int
		{
			return mBuffer;
		}
		
		public function get landingPt():Point
		{
			return mLandingPt;
		}
		
		public function set landingPt(pp:Point):void
		{
			mLandingPt = pp
		}
		public function get invincible():int
		{
			return mInvincible
		}
		
		public function set life(pAmount):void
		{
			mLife = pAmount
			changeLifeBy(0);	//to make sure it's within it's limit
		}
		
		public function get life():int
		{
			return mLife
		}
		
		public function get angle():Number
		{
			return mAngle;
		}
		
		public function set angle(pa:Number):void
		{
			mAngle = pa
		}
		
		public function get lineOn():Boolean
		{
			return mLineOn;
		}
		
		public function set lineOn(pb:Boolean):void
		{
			mLineOn = pb
		}
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	Basic movement of player
		 **/
		override public function run():void
		{
			if (Boolean(mPushback))
			{
				mPushback--
				mvx = Math.cos(mPushAng) * mPushback * 2
				mvy = Math.sin(mPushAng) * mPushback * 2
			}
			else
			{
				if (mBuffer != 0  && mInvincible == 0) handleBuffer();
				if (mInvincible != 0) handleInvincible();
				if (mDoublePoint != 0) handleDoublePoint();
				
				
				var currpx:Number = mpx;
				var currpy:Number = mpy;
				var currvx:Number = mvx;
				var currvy:Number = mvy;
				
				var nextvx:Number = (currvx + mgx) * mFric;
				var nextvy:Number = (currvy + mgy) * mFric;
				
				mvx = nextvx;
				mvy = nextvy;
			}
			
			mpx += mvx;
			mpy += mvy;
			
			mImage.x = mpx;
			mImage.y = mpy;
			manageDepth()
		}
		
		/**
		 *	account for player's movement when colliding with the cloud/line
		 **/
		public function accountCollision():void
		{
			var collisions:Array =  GameData.collisionP.checkCollisions();
			if(collisions.length)
			{
				mLineOn = true;
				var collision:Object = collisions[0];
				var angle:Number = collision.angle;
				mAngle = angle * 180 / Math.PI;
				var overlap:int = collision.overlapping.length;
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
					
				var vx0:Number = mvx * cos + mvy * sin;
				var vy0:Number = mvy * cos - mvx * sin;
				
				vx0 = ((mMass - 50) * vx0) / (mMass + 50);
				mvx = vx0 * cos - vy0 * sin;
				mvy = vy0 * cos + vx0 * sin;
				
				mvx -= cos * overlap /mRadius;
				mvy -= sin * overlap / mRadius;
				
				if (Math.abs(mAngle) <= 90)
				{
					mvx += 1;
				}
				else if (Math.abs(mAngle) > 90)
				{
					mvx -= 1;
				}
			}
			else 
			{
				vel = new Point ((0 + gx) * fric, (0 + gy)* fric)
				mLineOn = false
				
				
				if (Math.abs(mCenterX - px) > 1.5 )
				{
					px > mCenterX ? vx -- : vx ++;
				}else 
				{
					px = mCenterX
				}
			}
			
			
			
		}
		
		/**
		 *	When called, deviate from normal run and do push back action
		 *	@PARAM		pAng		Number		angle player needs to be pushed back on
		 **/
		public function pushback(pAng:Number, pPushback:int = 10):void
		{
			mPushback = pPushback
			mPushAng = pAng
			mImage.visible = true;
		}
		
		/**
		 *	When level is completed, the is set to fly off
		 **/
		public function closingSetting():void
		{
			vel = GameData.closingVel;
			grav = GameData.closingGrav;
			mLineOn = false;
		}
		
		/**
		 *	When the game is completed, the is set to dock
		 **/
		public function endSetting():void
		{
			vel = new Point (0, 0)
			grav = new Point (0, 0)
			mLineOn = false;
		}
		
		/**
		 *	property setting for death sequence
		 **/
		public function deathSetting():void
		{
			mPushback = 0
			vel = GameData.closingVel;
			grav = new Point (0, .2);
			mLineOn = false;
		}
		
		/**
		 *	set invincible buffer when hit
		 *	@PARAM		pt		int		count duration the player will be invincible for
		 **/
		public function setBuffer(pt:int = 40):void
		{
			if (mInvincible == 0)mBuffer = pt;
		}
		
		/**
		 *	set invincibility via item collection
		 *	@PARAM		pt		int		count duration the player will be invincible for
		 **/
		public function setInvincible(pt:int = 400):void
		{
			mInvincible = pt;
			GameData.particleSprite2.filters = GameData.ShieldFilter
			GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_SHIELD_UP);
			MovieClip(mImage).protection.visible = true
			MovieClip(mImage).protection.alpha = 1
		}
		
		
		/**
		 *	set double point duration, while active all points will be doubled
		 *	@PARAM		pt		int		count duration the double points will be effective for
		 **/
		public function setDoublePoint(pt:int = 400):void
		{
			mDoublePoint = pt;
			MovieClip(mImage).money.alpha = 1;
			MovieClip(mImage).money.visible = true;
		}
		
		
		/**
		 *	set player's life
		 *	@PARAM		pAmt		int		change the life by this amount
		 **/
		public function changeLifeBy(pAmt:int):void
		{
			mLife += pAmt;
			if (mLife > 100) mLife = 100;
			if (mLife < 0) mLife = 0;
		}
		
		/**
		 *	clear player properties 
		 **/
		public function resetCharacter():void
		{
			MovieClip(mImage).protection.visible = false;
			MovieClip(mImage).money.visible = false;
			mImage.visible = true;
			mImage.x = mpx;
			mImage.y = mpy;
			mImage.rotation = 0;
			mBuffer = 0
			mInvincible = 0;
			mLineOn = false
		}
		
		/**
		 *	allow player's images to be always on the top
		 **/
		public function manageDepth():void
		{
			if (GameData.objsSprite.getChildIndex(mImage) < GameData.objsSprite.numChildren)
			{
				GameData.objsSprite.setChildIndex(mImage, GameData.objsSprite.numChildren -1)
			}
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		/**
		 *	Handles invincible buffer after colliding to an enemy
		 **/
		
		protected function handleBuffer():void
		{
			if (mBuffer > 0) 
			{
				mBuffer --
				if (mBuffer %3 ==0)
				{
					mImage.visible = false
				}
				else 
				{
					mImage.visible = true
				}
			}
			else 
			{
				mBuffer = 0;
				
			}
			
			if (mBuffer == 0)
			{
				mImage.visible = true;
			}
		}
		
		
		/**
		 *	Handles invincibility of the character
		 *	@NOTE:	When this becomes active, mBuffer is automatically nullified
		 **/
		protected function handleInvincible():void
		{
			if (mInvincible > 0) 
			{
				mInvincible --
				if (mBuffer !=0 )
				{
					mBuffer = 0;
					mImage.visible = true;
				}
				
				if (mInvincible < 30)
				{
					if (mInvincible %3 ==0)
					{
						MovieClip(mImage).protection.visible = false
					}
					else 
					{
						MovieClip(mImage).protection.visible = true
					}
				}
				if (mInvincible == 20)
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_SHIELD_DOWN);
				}
				if (mInvincible < 20)
				{
					MovieClip(mImage).protection.alpha = mInvincible/20;
				}
				
			}
			else 
			{
				mInvincible = 0;
				
			}
			
			if (mInvincible == 0)
			{
				MovieClip(mImage).protection.visible = false;
				MovieClip(mImage).protection.alpha = 1;
				GameData.particleSprite2.filters = GameData.BaseFilter
			}
		}
		
		/**
		 *	Handles doublePoint
		 **/
		protected function handleDoublePoint():void
		{
			if (mDoublePoint > 0) 
			{
				mDoublePoint --
				if (mDoublePoint < 20)
				{
					MovieClip(mImage).money.alpha = mDoublePoint/20
				}
			}
			else 
			{
				mDoublePoint = 0;
				
			}
			
			if (mDoublePoint == 0)
			{
				MovieClip(mImage).money.visible = false
			}
		}
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------

		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}