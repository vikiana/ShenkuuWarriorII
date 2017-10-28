/**
 *	base for all characters including the player and other enemies
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
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class AbsCharacter
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mvx:Number = 0;	//velocity x
		protected var mvy:Number = 0;	//velocity y
		protected var mpx:Number = 0;	//position x
		protected var mpy:Number = 0;	//position y
		protected var mgx:Number = 0;	//gravity x
		protected var mgy:Number = 0;	//gravity y
		protected var mFric:Number = 1; //friction, 1 on friction, .9 means 10% friction
		protected var mMass:Number = 100;	//mMass
		protected var mImage:DisplayObject;	//character image
		protected var mMainGame:Object;	//main game, Shenkuu_Game in this case.
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AbsCharacter():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function set vel(pP:Point):void
		{
			mvx = pP.x;
			mvy = pP.y;
		}
	
		public function set pos(pP:Point):void
		{
			mpx = pP.x;
			mpy = pP.y;
		}
		
		public function set grav(pP:Point):void
		{
			mgx = pP.x;
			mgy = pP.y;
		}
		
		public function set image(pImage:DisplayObject):void
		{
			mImage = pImage;
		}
		
		public function set px(pv:Number):void { mpx = pv }
		public function set py(pv:Number):void  { mpy = pv }

		public function set vx(pv:Number):void { mvx = pv }
		public function set vy(pv:Number):void  { mvy = pv }
		
		
		public function get vel():Point { return new Point (mvx, mvy)}
		public function get pos():Point { return new Point (mpx, mpy)}
		public function get grav():Point { return new Point (mvx, mvy)}
		public function get fric():Number { return mFric}
		
		public function get vx():Number { return mvx }
		public function get vy():Number { return mvy }
		public function get px():Number { return mpx }
		public function get py():Number { return mpy }
		public function get gx():Number { return mgx }
		public function get gy():Number { return mgy }
		
		public function get image():DisplayObject {return mImage}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		/**
		 *	Initial set up of a character
		 *	@PARAM		pImage		DisplayObject		the image of the enemy
		 *	@PARAM		pPos		Point				Starting x,y position in point
		 *	@PARAM		pVel		Point				x,y velocity of the character in point
		 *	@PARAM		pGrav		Point				x,y gravity of the chracter in point
		 *	@PARAM		pMainGAme	Object				Main Game obj to mainly dispatch event
		 *	@PARAM		pFric		Number				friction of the character
		 *	@PARAM		pMass		Number				mass of the object
		 **/
		public function init(pImage:DisplayObject, pPos:Point, pVel:Point, pGrav:Point, pMainGame:Object = null, pFric:Number = 1, pMass:Number = 100):void
		{
			mImage = pImage;
			pos = pPos;
			vel = pVel;
			grav = pGrav;
			mFric = pFric;
			mMass = pMass;
			mImage.x = mpx;
			mImage.y = mpy;
			mMainGame = pMainGame
		}
		
		/**
		 *	current clean up is not supported since they are never destroyed
		 **/
		public function cleanup():void
		{
			
		}
		
		/**
		 *	basic run function to move a character.  Call on enter frame or timer
		 *	Meant to be overridden
		 **/
		public function run():void
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
			
		}
		
		/**
		 *	resets character's properties
		 **/
		public function charcterReset():void
		{
			mvx = 0;
			mvy = 0;
			mpx = 0;
			mpy = 0;
			mgx = 0;
			mgy = 0;
			mMass = 100;
			mImage = null;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------

		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}