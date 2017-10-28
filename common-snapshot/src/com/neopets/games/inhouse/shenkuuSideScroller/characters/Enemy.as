/**
 *	enemy Character
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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameDataManager;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.Sounds
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.ParticleBridge
	import com.neopets.util.sound.GameSoundManager;

	
	
	public class Enemy extends AbsCharacter
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------

		public static const DEFAULT:String = "move_one_direction";
		public static const DEFAULT2:String = "move_one_direction_type_2";
		public static const TRACKER:String = "Turn_once_in_range";
		public static const SHOOTER:String = "shoot_missiles";
		public static const DESTROYER:String = "shoot_multiple_missiles";
		public static const KILLER:String = "kill_playre_at_once";
		public static const BLOCKER:String = "simple_road_block";
		public static const MISSILE:String = "missle_itself";
		public static const WALL:String = "unbreakable_enemy"
		public static const WALL_V:String = "unbreakable_vertical_enemy"
		public static const WALL_H:String = "unbreakable_horizontal_enemy"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mTarget:MainCharacter
		protected var mDamage:int = 10
		protected var mBehavior:Function  = behaviorDefault
		protected var mTurned:int = 0
		
		protected var mRealvx:Number;	//velocity accounts for speed down item
		protected var mRealvy:Number;	//velocity accounts for speed down item
		
		protected var mShootTimer:int =  50;
		protected var mMissileNum:int = 1;	//number of missiles to shoot, 1 by default (this is for shooters)
		protected var mType:String;		//Enemy type
		protected var mTargetY:Number;	// only used for destinatin Move
		protected var mTargetX:Number;
		
		protected var mScore:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Enemy():void
		{
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function set myTarget (pTarget:MainCharacter):void
		{
			mTarget = pTarget;
		}
		
		public function get myTarget ():MainCharacter
		{
			return mTarget;
		}
		
	
		public function set damage (pDamage:int):void
		{
			mDamage = pDamage;
		}
		
		public function get damage ():int
		{
			return mDamage;
		}
		
		public function get unbreakable ():Boolean
		{
			return mType == Enemy.DESTROYER || mType == Enemy.WALL ||mType == Enemy.WALL_V || mType == Enemy.WALL_H
		}
		
		/**
		 *	set the behavior as well as other properties of the enemy
		 **/
		public function set behavior(pType:String):void
		{
			var ang:Number
			mType = pType;
			switch (pType)
			{
				case DEFAULT:
				mBehavior = behaviorDefault;
				ang = Math.atan2(vel.y, vel.x);
				mImage.rotation = ang * 180 / Math.PI;
				mScore = 3;
				break;
				
				case DEFAULT2:
				mBehavior = behaviorDefault;
				ang = Math.atan2(vel.y, vel.x);
				mImage.rotation = ang * 180 / Math.PI;
				mScore = 3;
				break;
				
				case KILLER:
				mBehavior = behaviorKill;
				mDamage = 50;
				ang = Math.atan2(vel.y, vel.x);
				mImage.rotation = ang * 180 / Math.PI;
				mScore = 30;
				break;
				
				case BLOCKER:
				mBehavior = behaviorDefault;
				mDamage = 0;
				break;
				
				case TRACKER:
				mBehavior = behaviorTrack;
				ang = Math.atan2(vel.y, vel.x);
				mImage.rotation = ang * 180 / Math.PI;
				mScore = 5;
				break;
				
				case SHOOTER:
				mMissileNum = 1;
				mBehavior = behaviorShoot;
				mScore = 20;
				break;
				
				case DESTROYER:
				mMissileNum = 6;
				mBehavior = behaviorShoot;
				mScore = 0;
				break;
				
				case MISSILE:
				mBehavior = behaviorPatterD;
				ang = Math.atan2(vel.y, vel.x);
				mImage.rotation = ang * 180 / Math.PI;
				mScore = 1;
				break;
				
				case WALL:
				mBehavior = behaviorDefault;
				mDamage = 1;
				mScore = 0;
				break;
				
				case WALL_H:
				mBehavior = behaviorDefault;
				mDamage = 1;
				mScore = 0;
				break;
				
				case WALL_V:
				mBehavior = behaviorDefault;
				mDamage = 1;
				mScore = 0;
				break;
				
				default:
				mBehavior = behaviorDefault;
				break;
			}
		}
		
		
		public function get score ():int
		{
			return mScore;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	run enemy's behavior and move function
		 **/
		override public function run():void
		{
			mBehavior();
			checkHit()
		}
		
		/**
		 *	function to reset the enemy's properties
		 **/
		public function resetCharacter():void
		{

			GameDataManager.removeImage(mImage, GameData.objsSprite)
			
			if (unbreakable)
			{
				GameDataManager.toReserve(this, GameData.activeUnbreakables, GameData.enemies)
			}
			else
			{
				GameDataManager.toReserve(this, GameData.activeEnemies, GameData.enemies)
			}
			mTarget = null
			mBehavior = null
			mTurned = 0
			mRealvx = 0
			mRealvy = 0
			mMissileNum = 1;	
			mType = null		
			mTargetY = NaN 			
			mTargetX = NaN
			charcterReset()
		}
		
		
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		/**
		 *	Basic movement of enemies: it simply moves enemies each frame
		 **/
		protected function basicMovement():void
		{
			var currpx:Number = mpx;
			var currpy:Number = mpy;
			var currvx:Number = mvx;
			var currvy:Number = mvy;
			
			var nextvx:Number = (currvx + mgx) * mFric;
			var nextvy:Number = (currvy + mgy) * mFric;
			
			mvx = nextvx;
			mvy = nextvy;
			
			mRealvx = mvx;
			mRealvy = mvy;
			
			if (GameData.slowOn)
			{
				mRealvx *= GameData.slowRate;
				mRealvy *= GameData.slowRate;
				
			}
			
			mRealvx *= GameData.speedFactor;
			mRealvy *= GameData.speedFactor;
			
			mpx += mRealvx;
			mpy += mRealvy;
			
			mImage.x = mpx;
			mImage.y = mpy;
			
			

			if (mType == Enemy.WALL_H  &&  (mpx < -200 || mpy > 650))
			{
				resetCharacter()
			}
			else if (mType != Enemy.WALL_H  && mpx < -60 || mpy > 650) 
			{
				resetCharacter()
			}
			else if (mType == Enemy.MISSILE  && (mpx > 680 || mpy < -50))
			{
				resetCharacter()
			}
			
			
		}
		
		/**
		 *	picks a point and moves there
		 **/
		protected function destinationMovement():void
		{
			if (isNaN(mTargetX) || mTargetX > mpx)
			{
				mTargetX = mpx - (Math.random() * 50 + 50)
				mTargetY = Math.random() * (GameData.stageHeight -100) + 50
				mvy = (mTargetY - mpy) * .01
				
			}
			var currpx:Number = mpx;
			var currpy:Number = mpy;
			var currvx:Number = mvx;
			var currvy:Number = (mTargetY - mpy) * .01 //mvy;
			
			var nextvx:Number = (currvx + mgx) * mFric;
			var nextvy:Number = (currvy + mgy) * mFric;
			
			mvx = nextvx;
			mvy = nextvy;
			
			mRealvx = mvx;
			mRealvy = mvy;
			
			if (GameData.slowOn)
			{
				mRealvx *= GameData.slowRate;
				mRealvy *= GameData.slowRate;
			}
			
			mpx += mRealvx;
			mpy += mRealvy;
			
			mImage.x = mpx;
			mImage.y = mpy;
			
			if (mpx < -60 || mpy > 650) 
			{
				resetCharacter()
			}
			else if (mType == Enemy.MISSILE  && (mpx > 680 || mpy < -50))
			{
				resetCharacter()
			}
			
			
		}
		
		
		/**
		 *	very basic movement of the enemy
		 **/
		protected function behaviorDefault():void
		{
			basicMovement()
		}
		
		/**
		 *	changes angle once towards the player when distance is close enough
		 **/
		protected function behaviorTrack():void
		{
			basicMovement()
			if (mTurned == 0 && mTarget != null)
			{
				var dist:Number =  mTarget.px - mpx; 
				if (Math.abs(dist) < 250)
				{
					var ang:Number = Math.atan2(mTarget.py - mpy, dist)
					mvx = Math.cos(ang) * -mvx
					mvy = Math.sin(ang) * -mvx
					mImage.rotation = ang * 180 / Math.PI 
					mTurned ++
				}
				
			}

			
		}
		
		/**
		 *	Fire missiles at given time duration
		 **/
		protected function behaviorShoot():void
		{
			if (mTarget != null && mImage != null )
			{
				if (mType == Enemy.DESTROYER)
				{
					MovieClip(mImage).cannon.rotation +=2  
					destinationMovement()
				}
				else 
				{
					var ang:Number = Math.atan2(mTarget.py - mpy, mTarget.px - mpx)
					MovieClip(mImage).cannon.rotation = ang * 180 / Math.PI
					basicMovement();
				}
				accountShooting();
			}
		}
		
		/**
		 *	behavior of the missile: die upon contact with the lines
		 **/
		protected function behaviorPatterD():void
		{
			basicMovement()
			accountCollision()
		}
		
		/**
		 *	add smoke affect to basic behavior, deals big damage
		 **/
		protected function behaviorKill():void
		{
			basicMovement()
			ParticleBridge.showTrail2(px, py)
		}
		
		/**
		 *	should the image of the enemy collide with teh line, it should die... 
		 **/
		protected function accountCollision():void
		{
			var collisions:Array =  GameData.collisionA.checkCollisions();
			if(collisions.length)
			{
				var collision:Object = collisions[0];
				if (collision.object1 == mImage || collision.object2 == mImage)
				{
					GameData.collisionA.removeItem(mImage)
					explode()
				}
				
			}
		}
		
		/**
		 *	based on their shooter type, shoot 1 missile or multiples 
		 **/
		protected function accountShooting():void
		{
			if (mShootTimer > 0)
			{
				GameData.slowOn ? mShootTimer -- : mShootTimer -= 2;
				if (mpx > 10 && mpx < 600)
				{
					if (mShootTimer < 30)
					{
						MovieClip(mImage).ready.alpha = 1 - mShootTimer/30
						MovieClip(mImage).ready.visible = true
					}
					if (mShootTimer == 0)
					{
						MovieClip(mImage).ready.alpha = 0
						MovieClip(mImage).ready.visible = false
						var inc:Number = Math.PI * 2 / mMissileNum
						var angle:Number = MovieClip(mImage).cannon.rotation * Math.PI/180
												
						for (var i:int = 0; i < mMissileNum; i ++)
						{
							var rad:Number = Math.abs(MovieClip(mImage).cannon.x-MovieClip(mImage).missilePoint.x);
							var px:Number = Math.cos(angle + inc * i) * rad + mpx;
							var py:Number = Math.sin(angle + inc * i) * rad + mpy;
							var vx:Number = Math.cos(angle + inc * i) * 10;  
							var vy:Number = Math.sin(angle + inc * i) * 10;
							dispatchShoot(px, py, vx, vy)
						}
					}
				}
			}
			else
			{
				if (mType == Enemy.SHOOTER)mShootTimer = 30 + Math.floor(Math.random() * 40);
				if (mType == Enemy.DESTROYER)mShootTimer = 80;
			}
		}
		
		/**
		 *	dispatch an event to tell main game to create a missile at given point
		 *	@PARAM			px		Number		x pos
		 *	@PARAM			py		Number		y pos
		 *	@PARAM			vx		Number		x velocity
		 *	@PARAM			vy		Number		y velocity
		 **/
		protected function dispatchShoot(px:Number, py:Number, vx:Number, vy:Number):void
		{
			
			GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_FIRE);
			mMainGame.dispatchEvent(new CustomEvent (
													 {
														 TYPE:"missile",
														 POS:new Point (px, py),
														 VEL:new Point (vx, vy)
													 },
													 mMainGame.OBJECT_CONTACT
													 )
									)
		}
		
		/**
		 *	reporting function to notify when the enemy collides with the player
		 **/
		protected function checkHit():void
		{
			if (mTarget != null && mImage != null)
			{
				if (MovieClip(mImage).objHitArea.hitTestObject (MovieClip(mTarget.image).core))
				{
					switch (mType)
					{
						case Enemy.WALL:
							MovieClip(mImage).image.play();
							dispatchHitInfo(mTarget.px, mTarget.py);
							GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SHORT_CIRCUIT);
							break;
							
						case Enemy.WALL_H:
							MovieClip(mImage).image.play();
							dispatchHitInfo(mTarget.px, mTarget.py);
							GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SHORT_CIRCUIT);
							break;
							
						case Enemy.WALL_V:
							MovieClip(mImage).image.play();
							dispatchHitInfo(mTarget.px, mTarget.py);
							//
							GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_HIT)
							break;
						
						case Enemy.DESTROYER:
							dispatchHitInfo(mpx, mpy);
							break;
							
						default:
							if (!Boolean(mTarget.buffer))
							{
								manageDeathSound(); 
								dispatchHitInfo(mpx, mpy);
								resetCharacter();
							}
							break;
					}
				}
			}
		}
		
		
		/**
		 *	dipatch hit point and other information to the main game
		 *	@PARAM		pxt			Number		Pos X where impact particle should  appear
		 *	@PARAM		pyt			Number		Pos Y where impact particle should  appear
		 **/
		protected function dispatchHitInfo(pxt:Number, pyt:Number):void
		{
			if (mMainGame != null)
			{
				var ang:Number = Math.atan2(mTarget.py-py, mTarget.px-px)
				var dAng:Number = ang * 180 /Math.PI
				var top:MovieClip = MovieClip(mImage).top;
				var bottom:MovieClip = MovieClip(mImage).bottom;
				var right:MovieClip = MovieClip(mImage).right;
				var left:MovieClip = MovieClip(mImage).left;
				var target:MovieClip = MovieClip(mTarget.image).core
				if (mType == Enemy.WALL_H || mType == Enemy.WALL_V)
				{
					if ( top.hitTestObject (target)|| bottom.hitTestObject(target))
					{
						ang = Math.atan2(mTarget.py-py, (mTarget.px-px) * 0)
					}
					else if (right.hitTestObject (target) || left.hitTestObject (target))
					{
						ang = Math.atan2((mTarget.py-py) * 0, mTarget.px-px)
					}
					if (right.hitTestObject (target) && top .hitTestObject (target) )ang = Math.PI * -.25;
					if (left.hitTestObject (target) && top .hitTestObject (target) )ang = Math.PI * -.75;
					if (left.hitTestObject (target) && bottom .hitTestObject (target) )ang = Math.PI * - 1.25;
					if (right.hitTestObject (target) && bottom .hitTestObject (target) )ang = Math.PI * -1.75;
				}
				mMainGame.dispatchEvent(new CustomEvent({TYPE:"enemy",POS:new Point (pxt, pyt),DAMAGE:mDamage,KIND:mType,  SCORE:mScore, ANGLE: ang}, mMainGame.OBJECT_CONTACT))
			}
			
		}
		
		
		/**
		 *	If there shoudl be any death sounds, make it happen...
		 **/
		 protected function manageDeathSound():void
		 {
			 switch (mType)
			{
				case DEFAULT:
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_BIRD);
				break;
				
				case DEFAULT2:
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_HIT_W_SHOCK);
				break;
				
				case TRACKER:
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_POOF);
				break;
				
				case SHOOTER:
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_FIRE);
				break;
				
				case MISSILE:
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_FIRE);
				//GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_POOF);
				break;
				
				case KILLER:
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_FIRE);
				//GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_POOF);
				break;
				
				
				default:
				break;
			}

		 }
		
		/**
		 *	When missile hits the line it should just explode
		 **/
		protected function explode():void
		{
			if (mTarget != null)
			{
				if (mMainGame != null)
				{
					mMainGame.dispatchEvent(new CustomEvent ( 
															 {
																 TYPE:"missileExp",
																 SCORE:mScore,
																 POS:new Point (mpx, mpy)
															 },
															 mMainGame.OBJECT_CONTACT
															 )
											)
				}
				resetCharacter()
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





















