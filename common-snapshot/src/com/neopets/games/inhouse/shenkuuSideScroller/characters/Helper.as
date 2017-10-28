/**
 *enemy Character
 *
 *@langversion ActionScript 3.0
 *@playerversion Flash 9.0 
 *@author Abraham Lee
 *@since  aug.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.characters{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameDataManager;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;


	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------



	public class Helper extends AbsCharacter {
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		public static  const SCORE:String = "add_score";
		public static  const HEAL:String = "restore_life";
		public static  const DOUBLE:String = "double_point";
		public static  const INVINCIBLE:String = "make_player_invincible";
		public static  const KILL:String = "kill_all_enemies_on_screen";
		public static  const MORPH:String = "morph_all_enemies_to_item";
		public static  const SPEED_UP:String = "make_timer_faster";
		public static  const SPEED_DOWN:String = "make_timer_slower";

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var mTarget:MainCharacter;
		protected var mBehavior:Function  = behaviorPatterA;
		protected var mType:String;

		protected var mHeal:int;//Life restoration amount
		protected var mScore:int;
		protected var mMultiplier:Number;//score multiplier, if set to 2, all scores are doubled
		protected var mKill:Boolean;//kill all enemies
		protected var mMorph:Boolean;//morph all enemies to points
		protected var mInvincible:int;//make main character invincible
		protected var mTime:int;//duration of the effects that has to do with time ex) invincible


		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function Helper():void {
			super();
		}
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function set myTarget(pTarget:MainCharacter):void 
		{
			mTarget = pTarget;
		}
		public function get myTarget():MainCharacter 
		{
			return mTarget;
		}
		
		/**
		 *	set behavior and properties 
		 **/
		public function set behavior(pType:String):void 
		{
			mType = pType;
			switch (pType) {
				case Helper.SCORE :
					setProperties(10, 0);
					break;

				case Helper.HEAL :
					setProperties(2, 5, 1);
					break;

				case Helper.DOUBLE :
					setProperties(3, 0, 2, false, false, 0, 300);
					break;

				case Helper.INVINCIBLE :
					setProperties(3, 0, 1, false, false, 0, 300);
					break;

				case Helper.KILL :
					setProperties(15, 0, 1, true, false, 0, 0);
					break;

				case Helper.MORPH :
					setProperties(15, 0, 1, false, true, 0, 0);
					break;

				case Helper.SPEED_UP :
					setProperties(3, 0, 1, false, false, 0, 500);
					break;

				case Helper.SPEED_DOWN :
					setProperties(3, 0, 1, false, false, 0, 200);
					break;

				default :
					break;
			}
		}
		
		public function get score ():int
		{
			return mScore;
		}
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------

		
		/**
		 *	runs the helpers
		 **/
		override public function run():void 
		{
			mBehavior();
			checkHit();
		}
		
		/**
		 *	reset helper properties 
		 **/
		public function resetCharacter():void 
		{
			GameDataManager.removeImage(mImage, GameData.objsSprite)
			GameDataManager.toReserve(this, GameData.activeHelpers, GameData.helpers)
			mTarget = null;
			mType = null;
			mHeal = 0;
			mScore = 0;
			mMultiplier = 1;
			mKill = false;
			mMorph = false;
			mInvincible = 0;
			mTime = 0;			
			charcterReset()
		}
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	Based on the type of the helper/item, set the properties accodingly
		 *	@PARAM		pScore		int			helper's score value
		 *	@PARAM		pHeal		int			helper's heal value
		 *	@PARAM		pMul		int			Score multiplier...
		 *	@PARAM		pKill		Boolean		Kills all enemies on screen
		 *	@PARAM		pMorph		Boolean		morph all enemies on screen into score helpers
		 *	@PARAM		pInv		int			duration player will stay invincible
		 *	@PARAM		pTime		int			duration of time driven effects should last
		 **/
		protected function setProperties(pScore:int = 0, pHeal:int = 0, pMul:Number = 1, pKill:Boolean = false, pMorph:Boolean = false, pInv:int = 0, pTime:int = 0):void 
		{
			mHeal = pHeal;
			mScore = pScore;
			mMultiplier = pMul;
			mKill = pKill;
			mMorph = pMorph;
			mInvincible = pInv;
			mTime = pTime;
		}
		
		/**
		 *	baiscally move according ot velocity, friction and gravity
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

			mpx += mvx * GameData.speedFactor;
			mpy += mvy * GameData.speedFactor;

			mImage.x = mpx;
			mImage.y = mpy;

			if (mpx < -60 || mpy > 650) 
			{
				resetCharacter();
			}
		}
		
		
		/**
		 *	basic behavior patters, ther is only one for now
		 **/
		protected function behaviorPatterA():void 
		{
			basicMovement()
		}
		
		
		/**
		 *	check if it came to contact with the player
		 **/
		protected function checkHit():void 
		{
			if (mTarget != null) {
				if (MovieClip(mImage).objHitArea.hitTestObject (MovieClip(mTarget.image).core)) 
				{
					if (mMainGame != null) {
						mMainGame.dispatchEvent(new CustomEvent ( 
						 {
							 TYPE:mType,
							 POS:new Point (mpx, mpy),
							 HEAL:mHeal,
							 SCORE:mScore,
							 TIME:mTime
						 },
						 mMainGame.OBJECT_CONTACT
						 )
						);
					}
					resetCharacter();
				}
			}
		}
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------

		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
}