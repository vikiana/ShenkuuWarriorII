/**
 *	markers are not interactive chracters.  They are literarlly just a visual markers to give ques such as
 *	level end point, etc.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  08.26.2009
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



	public class Marker extends AbsCharacter {
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		public static  const LEVEL_END:String = "end_of_the_level_marker";
		public static  const GAME_END:String = "end_of_the_game_marker";
		public static  const DUMMY:String = "visual_candy_with_no_real_functionality_purpose";
		

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var mTarget:MainCharacter;
		protected var mType:String;	//type fo this marker
		protected var mBuffer:int = 150;	//buffer distance b/w player and destination point

		


		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function Marker():void {
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
		public function set behavior(pType:String):void 
		{
			mType = pType;
			switch (pType) {
				case Marker.LEVEL_END:
					break;

				case Marker.GAME_END :
					break;

				default :
					break;
			}
		}
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------

		/**
		 *	run function for maker, to move every frame or timer
		 **/
		override public function run():void 
		{
			basicMovement()
			checkDestination();
		}
		
		/**
		 *	reset markers
		 **/
		public function resetCharacter():void 
		{
			GameDataManager.removeImage(mImage, GameData.objsSprite)
			mTarget = null;
			mType = null;
			charcterReset()
		}
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	basic movement function for markers
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

			mpx += mvx;
			mpy += mvy;

			mImage.x = mpx;
			mImage.y = mpy;

			if (mpx < -60) 
			{
				resetCharacter();
			}
		}
		
		/**
		 *	dispatch event if/when player reaches the marker
		 **/
		protected function checkDestination():void 
		{
			if (mTarget != null) {
				var xDiff:Number = (mTarget.px + mBuffer) - mpx
				if (xDiff > 0 && mpx < 550 && mType != Marker.DUMMY) 
				{
					if (mMainGame != null) 
					{
						mMainGame.dispatchEvent(new CustomEvent ( {TYPE:mType}, mMainGame.OBJECT_CONTACT));
					}
					//resetCharacter();
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