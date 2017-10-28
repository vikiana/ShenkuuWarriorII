package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;

	public class Hero extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		private var mKey           : KeyObject;
		
		//=======================================
		// getter vars
		//=======================================
		private var gSamrinMC   : MovieClip;
		private var gCollDetMC  : Sprite;
		private var gSpeed      : Number;
		private var gVelX       : Number;
		private var gVelY       : Number;
		private var gFriction   : Number;
		private var gMaxSpeed   : Number;
		private var gPrevX      : Number;
		private var gPrevY      : Number;
		private var gWalkDir    : String;
		private var gTwoPetpets : Boolean;
		private var gWaypoint   : Boolean;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================	
		public function get mSamrinMC( ):MovieClip { return gSamrinMC };
		public function set mSamrinMC( mc : MovieClip ):void { gSamrinMC = mc };
		
		public function get mCollDetMC( ):Sprite { return gCollDetMC };
		public function set mCollDetMC( sp : Sprite ):void { gCollDetMC = sp };
		
		public function get mSpeed( ):Number { return gSpeed };
		public function set mSpeed( num : Number ):void { gSpeed = num };
		
		public function get mVelX( ):Number { return gVelX };
		public function set mVelX( num : Number ):void { gVelX = num };
		
		public function get mVelY( ):Number { return gVelY };
		public function set mVelY( num : Number ):void { gVelY = num };	
		
		public function get mFriction( ):Number { return gFriction };
		
		public function get mMaxSpeed( ):Number { return gMaxSpeed };
		public function set mMaxSpeed( num : Number ):void { gMaxSpeed = num };
		
		public function get mPrevX( ):Number { return gPrevX };
		public function set mPrevX( num : Number ):void { gPrevX = num };
		
		public function get mPrevY( ):Number { return gPrevY };
		public function set mPrevY( num : Number ):void { gPrevY = num };
		
		public function get mWalkDir( ):String { return gWalkDir };
		public function set mWalkDir( str : String ):void { gWalkDir = str };
		
		public function get mTwoPetpets( ):Boolean { return gTwoPetpets };
		public function set mTwoPetpets( bool : Boolean ):void { gTwoPetpets = bool };
		
		public function get mWaypoint( ):Boolean { return gWaypoint };
		public function set mWaypoint( bool : Boolean ):void { gWaypoint = bool };
		
		//===============================================================================
		// CONSTRUCTOR Hero
		//===============================================================================
		public function Hero( pX : Number = 0, pY : Number = 0 )
		{
			//trace( this + " created" );
			
			//mStage = pStage;
			this.x = pX;
			this.y = pY
			setupVars( );
			draw( );
			mSamrinMC.stop( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		internal function draw( ):void
		{
			var tSamrinClass : Class = mAssetLocation.getDefinition( "Samrin" ) as Class;
			mSamrinMC = new tSamrinClass( );
			this.addChild( mSamrinMC );
			
		} // end draw
		
		//===============================================================================
		// 	FUNCTION update
		//===============================================================================
		internal function update( pDir : String, pIsRunning : Boolean, pHasPetpet : Boolean ):void
		{
			if( pIsRunning && pHasPetpet )
			{
				//trace( "running and carrying" );
				
				if( pDir == "walk_up_left" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_down_left" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_left" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_up_right" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_up" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_down_right" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_right" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_down" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( "carry_" + pDir );
						mWalkDir = pDir;
					}
				}
			}	
			
			else if( pIsRunning )
			{
				if( pDir == "walk_up_left" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_down_left" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_left" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_up_right" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_up" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_down_right" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_right" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
				
				else if( pDir == "walk_down" )
				{				
					if( mWalkDir != pDir )
					{
						mSamrinMC.gotoAndPlay( pDir );
						mWalkDir = pDir;
					}
				}
			}
			
			else if( pHasPetpet )
			{
				if( pDir == "walk_up_left" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_down_left" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_left" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_up_right" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_up" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_down_right" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_right" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
				
				else if( pDir == "walk_down" )
				{				
					mSamrinMC.gotoAndStop( "idle_carry_" + pDir );
				}
			}
			
			else
			{
				if( pDir == "walk_up_left" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_down_left" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_left" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_up_right" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_up" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_down_right" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_right" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
				
				else if( pDir == "walk_down" )
				{				
					mSamrinMC.gotoAndStop( "idle_" + pDir );
				}
			}
			
			checkAnimationState( );
			
		} // end update
		
		//===============================================================================
		//  FUNCTION checkAnimationState
		//===============================================================================
		private function checkAnimationState( ):void
		{
			if( mSamrinMC.currentLabel == "end_walk_up_left" )
			{
				mSamrinMC.gotoAndPlay( "walk_up_left" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_down_left" )
			{
				mSamrinMC.gotoAndPlay( "walk_down_left" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_left" )
			{
				mSamrinMC.gotoAndPlay( "walk_left" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_up_right" )
			{
				mSamrinMC.gotoAndPlay( "walk_up_right" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_up" )
			{
				mSamrinMC.gotoAndPlay( "walk_up" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_down_right" )
			{
				mSamrinMC.gotoAndPlay( "walk_down_right" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_right" )
			{
				mSamrinMC.gotoAndPlay( "walk_right" );
			}
			
			else if( mSamrinMC.currentLabel == "end_walk_down" )
			{
				mSamrinMC.gotoAndPlay( "walk_down" );
			}
			
			/**
			 * carrying sequences
			 */
			if( mSamrinMC.currentLabel == "end_carry_walk_up_left" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_up_left" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_down_left" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_down_left" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_left" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_left" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_up_right" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_up_right" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_up" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_up" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_down_right" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_down_right" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_right" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_right" );
			}
			
			else if( mSamrinMC.currentLabel == "end_carry_walk_down" )
			{
				mSamrinMC.gotoAndPlay( "carry_walk_down" );
			}
						
		} //end checkAnimationState
				
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			gSpeed    = 2;
			gVelX     = 0;
			gVelY     = 0;
			gFriction = .5;
			gMaxSpeed = 5;
			//mKey = new KeyObject( mStage );
			
		} // end setupVars
		
	} // end class
	
} // end package
