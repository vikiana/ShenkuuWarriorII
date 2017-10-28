package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================	
	import behaviors.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.ui.Keyboard;
	
	public class ExtremeHerderIIGame extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		/**
		 * sound events. listened to by GameStartUp
		 */
		public static const BALTH_GROWL : String = "BalthazarGrowl";
		public static const SPEED_UP    : String = "PUSpeedUp";
		public static const FREEZE      : String = "PUFreeze";
		public static const TWO_PETPETS : String = "PUTwoPetpets";
		
		// dispatch when lives in Scoreboard drop down to 0
		internal static const GAME_OVER         : String = "GameOver";
		
		// dispatch when Samrin collects a power up listened to by PowerUpManager
		internal static const ACTIVATE_POWER_UP : String = "ActivatePowerUp";
		
		// dispatched to deactivate power up display in Scoreboard
		internal static const DEACTIVATE_POWER_UP_DISP : String = "DeactivatePowerUpDisp";
		
		// dispatch when Samrin collects a power up listened to by PowerUpManager
		internal static const REMOVE_TIMER : String = "RemoveTimer";
		
		// dispatch when game is paused or over
		internal static const REMOVE_ACTIVE_PU_TIMER : String = "RemoveActivePUTimer";
		
		// dispatch when game is over to call cleanUp in classes
		internal static const CLEAR_EVERYTHING : String = "ClearEverything";
		
		private var mSystem        : Object;
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		private var mGameScore     : Object;
		private var mLevel         : int;
		private var mLevelCheck    : Boolean;
		private var mKey           : KeyObject;
		
		//=======================================
		// game elements
		//=======================================
		private var mSamrin        : Hero;
		private var mBalthArrow	   : DirArrow;
		private var mBalthazar     : Balthazar;
		private var mLeftBorder    : Number;
		private var mRightBorder   : Number;
		private var mTopBorder     : Number;
		private var mBottomBorder  : Number;	
		
		/**
		 * mObstacles holds the pen obstacle objects
		 * balthazar and petpets need to avoid them
		 * samrin mustn't be able to walk over them
		 */
		private var mObstacles      : Array;
		
		/**
		 * mHedges holds the hedges around the edge of the screen
		 * samrin mustn't be able to walk over them
		 */
		private var mHedges         : Array;
		
		private var mPetpets        : Array;
		private var mPetpetArrows   : Array;
		private var mCarriedPetpets : Array;
		private var mPetpetsInPen   : Array;
		
		private var mSamrinDir           : String;
		private var mSamrinIsRunning     : Boolean;
		private var mSamrinHasPetpet     : Boolean;
		private var mSamrinHasTwoPetpets : Boolean;
		
		private var mPowerUpManager  : PowerUpManager;
		
		//=======================================
		// scoreboard, score, levels
		//=======================================
		private var mPetpetPoints  : int = 5;
		private var mLevelManager  : LevelManager;
		
		//===============================================================================
		// CONSTRUCTOR ExtremeHerderIIGame
		//===============================================================================
		public function ExtremeHerderIIGame( )
		{
			trace( "ExtremeHerderIIGame in " + this + " called" );
			
			// triggered when end game button in Scoreboard is clicked
			Dispatcher.addEventListener( Scoreboard.END_GAME, clearGameEvt );
			
			// triggered continue button in NextLevelPopUp is clicked after level 20
			Dispatcher.addEventListener( NextLevelPopUp.END_GAME, clearGameEvt );
			
			// triggered when continue button in NextLevelPopUp is clicked before level 20
			Dispatcher.addEventListener( NextLevelPopUp.NEXT_LEVEL, setUpNextLevel );
			
			// triggered when timer in PowerUpManager is up to remove power up from stage
			Dispatcher.addEventListener( PowerUpManager.REMOVE_POWER_UP, removePowerUpsEvt );
			
			// triggered when timer in PowerUpManager is up to deactivate effect of active power up
			Dispatcher.addEventListener( PowerUpManager.DEACTIVATE_POWER_UP_EFFECT, deactivatePUEffectEvt );
			
			setupVars( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( ):void
		{	
			trace( "init in " + this + " called" );
			
			mStage.align = StageAlign.TOP_LEFT;
			mStage.scaleMode = StageScaleMode.NO_SCALE;
												
			//=======================================
			// encrypted game score
			//=======================================
			GameVars.mGameScore = mSystem.createEvar( 0 );
			GameVars.mGameLevel = mSystem.createEvar( 0 );
			
			/**
			 * set mLevelCheck to true so that first level is
			 * set up upon game start
			 */
			mLevelCheck = true;
			
			createGame( );
			
		} // end function init
		
		//===============================================================================
		// FUNCTION createGame
		//===============================================================================
		private function createGame( ):void
		{	
			//trace( "createGame in " + this + " called" );	
									
			//=======================================
			// background
			//=======================================
			var tBackground : Background = new Background( );
			tBackground.name = "background";
			tBackground.x = mStage.stageWidth / 2;
			tBackground.y = mStage.stageHeight / 2;
			addChild( tBackground );
			
			//=======================================
			// scoreboard
			//	- instantiated in setupVars
			//=======================================
			var tScoreboard : Scoreboard = new Scoreboard( );
			tScoreboard.name = "scoreboard";
			tScoreboard.init( );
			tScoreboard.x = 10;
			tScoreboard.y = 10;
			addChild( tScoreboard );
			
			checkLevel( );
			
		} // end function createGame
		
		//===============================================================================
		// FUNCTION mainOnEnterFrame
		//===============================================================================
		public function mainOnEnterFrame( evt : Event ):void
		{
			var tSamCollDet : MovieClip = this.getChildByName( "sam_coll_det" ) as MovieClip;
			
			var tPen  : MovieClip = this.getChildByName( "petpet_pen" ) as MovieClip;				
			
			moveHero( );
			catchPetpet( );
			mSamrin.update( mSamrinDir, mSamrinIsRunning, mSamrinHasPetpet );
			tSamCollDet.x = mSamrin.x;
			tSamCollDet.y = mSamrin.y;			
			
			checkBaltCollision( );
			
			if( mBalthArrow.mHasTarget )
			{
				/**
				 * as long as mPetpets.length is not 0, mBalthArrow needs to seek
				 * a petpet so check if mPetpets.length is 0, then manipulate mBalthArrow
				 */
				if( mPetpets.length > 0 )
				{
					/**
					 * always set mBalthArrow.mTarget.length to 0 and call setTarget so that
					 * on every frame, the closest petpet is found and assigned to index 0 of
					 * mBalthazar.mTarget
					 */
					mBalthArrow.mTarget.length = 0;
					mBalthArrow.mTarget[ mBalthArrow.mTarget.length ] = setTarget( );
					mBalthArrow.followPath( mBalthArrow.mTarget, true );
				}				
			
				else 
				{
					/**
					 * if there are no more petpets in mPetpets, then samrin is still carrying one petpet
					 * so set him as target for balthazar
					 */
					//trace( this + "says: no more petpets to persue so get samrin!" );
					mBalthArrow.mTarget.length = 0;
					mBalthArrow.mTarget[ mBalthArrow.mTarget.length ] = new Vector2D( mSamrin.x, mSamrin.y ); 
					mBalthArrow.followPath( mBalthArrow.mTarget, true );
				}				
			}			
				
			/**
			 * mBalthArrow.mHasWaypoint is set to true in checkBaltCollision if a collision is detected
			 */
			else if( mBalthArrow.mHasWaypoint )
			{
				mBalthArrow.followPath( mBalthArrow.mPath, true );
			}	
				
			if( !mBalthazar.mIsGrabbing && !mBalthazar.mIsFrozen )
			{
				mBalthArrow.update( );
			}
			mBalthazar.update( mBalthArrow );
						
			if( mPetpets.length > 0 )
			{
				/**
				 * - get arrow from array
				 * - check if tPetpetArrow has a way point
				 * - if true, continue and let tPetpetArrow walk to existing way point
				 * - if false, set a new way point
				 * - call update in tPetpet so that it moves with tPetpetArrow and
				 *   animates correctly 
				 */
				var tPetpetArrowsLength : int = mPetpetArrows.length - 1;
				for( var i : int = tPetpetArrowsLength; i >= 0; i-- )
				{
					var tPetpetArrow : DirArrow = mPetpetArrows[ int( i ) ] as DirArrow;
					var tPetpet 	 : Petpet = mPetpets[ int( i ) ] as Petpet;
					if( tPetpetArrow.mHasWaypoint )
					{
						//trace( this + " says: tPetpet has a waypoint" );
						tPetpetArrow.followPath( tPetpetArrow.mPath, true );
					}
					
					else
					{
						//trace( this + " says: tPetpet has no waypoint" );
						tPetpetArrow.mPath[ tPetpetArrow.mPath.length ] = setWaypoint( tPetpetArrow );
						tPetpetArrow.followPath( tPetpetArrow.mPath, true );
					}
					tPetpetArrow.update( );
					tPetpet.update( tPetpetArrow );
				}
			}
			
			if( mCarriedPetpets.length > 0 )
			{
				/**
				 * get carried petpet from array of carried petpets
				 * update it's animation to go to the upside down sequence
				 */
				var tCarriedPetpetLen : int = mCarriedPetpets.length;
				for( var j : int = tCarriedPetpetLen - 1; j >= 0; j-- )
				{
					var tCarriedPetpet : Petpet = mCarriedPetpets[ int( j ) ] as Petpet;
					tCarriedPetpet.updateCarried( );
				}
			}
			
			/**
			 * check if a power up is currently on the stage and
			 * check if a power up is currently active
			 * if not, call setPowerUp in mPowerUpManager
			 */
			if( !mPowerUpManager.mPowerUpActive && !mPowerUpManager.mPowerUpOnStage )
			{
				//trace( this + " says: checking power up" );
				var tRand : int = Math.floor( Math.random( ) * 200 );
			
				if( tRand > 197 )
				{
					var tLocRand : int = Math.floor( Math.random( ) * 4 )
					var tPowerUp : PowerUp = mPowerUpManager.setPowerUp( );
					
					switch( tLocRand )
					{
						case 0:
							tPowerUp.x = 120;
							tPowerUp.y = 160;
							break;
							
						case 1:
							tPowerUp.x = 530;
							tPowerUp.y = 160;
							break;
							
						case 2:
							tPowerUp.x = 530;
							tPowerUp.y = 500;
							break;
							
						case 3:
							tPowerUp.x = 120;
							tPowerUp.y = 500;
							break;
					}
					
					addChild( tPowerUp );
					//trace( "tPowerUp.name: " + tPowerUp.name );
				}
			}
			
			checkLevel( );
			
		} // end mainOnEnterFrame
		
		//===============================================================================
		// FUNCTION checkBaltCollision
		//===============================================================================
		public function checkBaltCollision( ):void
		{
			//trace( "checkBaltCollision in " + this + " called" );
			
			/**
			 * before anything, check if Balthazar collides with Samrin or with any of 
			 * the petpets. this can happen while he is seeking a way point
			 */
			var tScoreboard : MovieClip = this.getChildByName( "scoreboard" ) as MovieClip;
			var tSamCollDet : MovieClip = this.getChildByName( "sam_coll_det" ) as MovieClip;
			
			if( mBalthazar.hitTestObject( tSamCollDet ) && !mBalthazar.mIsFrozen )
			{
				//trace( "samrin is in trouble" );
				if( GameVars.mSoundOn )
				{
					Dispatcher.dispatchEvent( new DataEvent( BALTH_GROWL, "BalthazarGrowl" ) )
				}
				
				mBalthazar.mIsGrabbing = true;
				mBalthazar.mStartsGrab = true;
				
				positionChars( "hero" );
				tScoreboard.updateLivesDisplay( );
			}
						
			/**
			 * check if mBalthArrow has a waypoint already
			 * if it does, it means that he is currently in the process of avoiding an
			 * obstacle so there is no need to check if obstacles are in his way
			 */			
			if( mBalthArrow.mHasWaypoint ) return;
			
			/**
			 * if balthazar doesn't have a waypoint:
			 * - create a "feeler" to check for obstacles
			 * - get references to pen and obstacles
			 * - set tMinDist to 1000 so that it's greater than any possible distance
			 *   to any of the obstacles
			 */
			var tAngle       : Number = mBalthArrow.rotation * Math.PI / 180;
			var tFeelerPoint : Point = new Point( mBalthArrow.x + 60 * Math.cos( tAngle ), mBalthArrow.y + 60 * Math.sin( tAngle ) );
			var tClosestObst : Obstacle;
			var tMinDist     : Number = 1000;			
						
			/**
			 * check if it intersects with any of the obstacles, including pen
			 * - loop through mObstacles and see if feeler intersects
			 */
			var tObstacleLen : int = mObstacles.length;
			for( var i : int = 0; i < tObstacleLen;  i++ )
			{
				var tObstacle : Obstacle = mObstacles[ int( i ) ] as Obstacle;
				
				/**
				 * if the obstacle intersects with feeler point:
				 * - set mBalthArrow.mTarget.length to 0
				 * - set mBalthArrow.mHasTarget to false so that statements in mainOnEnterFrame
				 * 	 won't be executed
				 * - find correct corner of obstacle with setBaltWaypoint( tObstacle )
				 * 	 to go to and walk around it
				 */ 
				if( tObstacle.hitTestPoint( tFeelerPoint.x, tFeelerPoint.y ) )
				{
					//trace( i + " - i think i am gonna run into " + tClosestObst.name );
									
					mBalthArrow.mTarget.length = 0;
					mBalthArrow.mHasTarget = false;
					mBalthArrow.mPath[ mBalthArrow.mPath.length ] = setBaltWaypoint( tObstacle );
					
					return;								
				}
				
				/**
				 * if feeler doesn't intersect with any obstacle:
				 * - set mBalthArrow.mHasTarget to true so that statements in mainOnEnterFrame
				 * 	 will be executed
				 */
				else
				{
					//trace( i + " - i am far away from " + tClosestObst.name );
					mBalthArrow.mHasTarget = true;
				}				
			}
			
		} // end checkBaltCollision
		
		//===============================================================================
		// FUNCTION setTarget
		//	- this is called from mainOnEnterFrame if mBalthArrow.mHasTarget = true
		//===============================================================================
		public function setTarget( ):Vector2D
		{
			//trace( "setTarget in " + this + " called" );
			
			var tScoreboard : MovieClip = this.getChildByName( "scoreboard" ) as MovieClip;
						
			var tMinDist : Number = 1000;
			var tClosestPetpet : Petpet;	
			var tPetpetsLength : int = mPetpets.length - 1;
			//trace( "tPetpetsLength: " + tPetpetsLength );			
			for( var i : int = tPetpetsLength; i >= 0; i-- )
			{
				var tPetpet : Petpet = mPetpets[ int( i ) ] as Petpet;
				var tDistX  : Number = mBalthArrow.x - tPetpet.x;
				var tDistY  : Number = mBalthArrow.y - tPetpet.y;
				var tDist   : Number = Math.sqrt( tDistX * tDistX + tDistY * tDistY );
				//trace( "tDist: " + tDist );
				
				if( tDist < tMinDist ) 
				{ 
					tMinDist = tDist;
					tClosestPetpet = tPetpet;
				}
				
				/**
				 * balthazar is close enough to petpet to have caught it
				 * - remove petpet from stage and mPetpets array
				 * - remove petpet arrow from stage and mPetpetArrows array
				 * - update the lives display in scoreboard
				 */
				if( tMinDist < 25 )
				{
					if( GameVars.mSoundOn )
					{
						Dispatcher.dispatchEvent( new DataEvent( BALTH_GROWL, "BalthazarGrowl" ) )
					}
					//trace( "gotcha" );
					mBalthazar.mIsGrabbing = true;
					mBalthazar.mStartsGrab = true;
					
					tClosestPetpet.parent.removeChild( tClosestPetpet );
					tClosestPetpet = null;
					mPetpets.splice( i, 1 );
					
					removeChild( mPetpetArrows[ i ] );
					mPetpetArrows.splice( i, 1 );
					
					tScoreboard.updateLivesDisplay( );
					mLevelManager.mPetpetsInLevel--;
					
					/**
					 * - check if there are more petpets in mPetpets array
					 * - if there are, get the next/closest one
					 * - otherwise ???
					 */
					if( mPetpets.length > 0 )
					{
						return setTarget( );
					}
					
					else
					{
						trace( this + "says: no more petpets. what now?" );
						/**
						 * returning null so it can be handled accordingly
						 */
						return null;
					}					
				}
			}
			
			return new Vector2D( tClosestPetpet.x, tClosestPetpet.y ); 

		} // end setTarget
		
		//===============================================================================
		// FUNCTION setBaltWaypoint
		//	- called when balthazar detects an obstacle in his path
		//===============================================================================
		public function setBaltWaypoint( pObstacle : Obstacle ):Vector2D
		{
			trace( "setBaltWaypoint in " + this + " called" );
			
			/**
			 * set mBalthazar.mHasWaypoint to true so that mBalthazar.followPath( ) is
			 * called in mainEnterFrame
			 */
			mBalthArrow.mHasWaypoint = true;				
			
			/**
			 * - get mBalthArrow current rotation to know the direction
			 * - determine on which side of obstacle mBalthArrow is currently on
			 * - set the corner as waypoint
			 */
			var tRotation    : Number = mBalthArrow.rotation;
			var tWayPoint    : Vector2D;
			var tAngle       : Number = mBalthArrow.rotation * Math.PI / 180;
			var tFeelerPoint : Point = new Point( mBalthArrow.x + 60 * Math.cos( tAngle ), mBalthArrow.y + 60 * Math.sin( tAngle ) );
			
			if( mBalthArrow.x > pObstacle.x && mBalthArrow.y < ( pObstacle.y - pObstacle.width * .5 ) && tRotation > 90 && tRotation <= 180 )
			{
				trace( "mBalthArrow above upper right half, going SW" );
				trace( "mTLCorner" );
				tWayPoint = pObstacle.mTLCorner;
			}
			
			else if( mBalthArrow.x > pObstacle.x && mBalthArrow.y < ( pObstacle.y - pObstacle.width * .5 ) && tRotation >= 0 && tRotation <= 90 )
			{
				trace( "mBalthArrow above upper right half, going SE" );
				trace( "mTRCorner" );
				tWayPoint = pObstacle.mTRCorner;
			}
			
			else if( mBalthArrow.x > ( pObstacle.x + pObstacle.width * .5 ) && mBalthArrow.y < pObstacle.y && tRotation > -179.9 && tRotation <= -90 )
			{
				trace( "mBalthArrow right of upper right half, going NW" );
				trace( "mTRCorner" );
				tWayPoint = pObstacle.mTRCorner;
			}
			
			else if( mBalthArrow.x > ( pObstacle.x + pObstacle.width * .5 ) && mBalthArrow.y < pObstacle.y && tRotation > 90 && tRotation <= 180 )
			{
				trace( "mBalthArrow right of upper right half, going SW" );
				trace( "mBRCorner" );
				tWayPoint = pObstacle.mBRCorner;
			}
			
			else if( mBalthArrow.x > ( pObstacle.x + pObstacle.width * .5 ) && mBalthArrow.y > pObstacle.y && tRotation > -179.9 && tRotation <= -90 )
			{
				trace( "mBalthArrow right of lower right half, going NW" );
				trace( "mTRCorner" );
				tWayPoint = pObstacle.mTRCorner;
			}
			
			else if( mBalthArrow.x > ( pObstacle.x + pObstacle.width * .5 ) && mBalthArrow.y > pObstacle.y && tRotation > 90 && tRotation <= 180 )
			{
				trace( "mBalthArrow right of lower right half, going SW" );
				trace( "mBRCorner" );
				tWayPoint = pObstacle.mBRCorner;
			}
			
			else if( mBalthArrow.x > pObstacle.x && mBalthArrow.y > ( pObstacle.y + pObstacle.width * .5 ) && tRotation > -90 && tRotation < 0 )
			{
				trace( "mBalthArrow below lower right half, going NE" );
				trace( "mBRCorner" );
				tWayPoint = pObstacle.mBRCorner;
			}
			
			else if( mBalthArrow.x > pObstacle.x && mBalthArrow.y > ( pObstacle.y + pObstacle.width * .5 ) && tRotation > -179.9 && tRotation <= -90 )
			{
				trace( "mBalthArrow below lower right half, going NW" );
				trace( "mBLCorner" );
				tWayPoint = pObstacle.mBLCorner;
			}
			
			else if( mBalthArrow.x < pObstacle.x && mBalthArrow.y > ( pObstacle.y + pObstacle.width * .5 ) && tRotation > -90 && tRotation < 0 )
			{
				trace( "mBalthArrow below lower left half, going NE" );
				trace( "mBRCorner" );
				tWayPoint = pObstacle.mBRCorner;
			}
			
			else if( mBalthArrow.x < pObstacle.x && mBalthArrow.y > ( pObstacle.y + pObstacle.width * .5 ) && tRotation > -179.9 && tRotation <= -90 )
			{
				trace( "mBalthArrow below lower left half, going NW" );
				trace( "mBLCorner" );
				tWayPoint = pObstacle.mBLCorner;
			}
			
			else if( mBalthArrow.x < ( pObstacle.x - pObstacle.width * .5 ) && mBalthArrow.y > pObstacle.y && tRotation >= 0 && tRotation <= 90 )
			{
				trace( "mBalthArrow left of lower left half, going SE" );
				trace( "mBLCorner" );
				tWayPoint = pObstacle.mBLCorner;
			}
			
			else if( mBalthArrow.x < ( pObstacle.x - pObstacle.width * .5 ) && mBalthArrow.y > pObstacle.y && tRotation > -90 && tRotation < 0 )
			{
				trace( "mBalthArrow left of lower left half, going NE" );
				trace( "mTLCorner" );
				tWayPoint = pObstacle.mTLCorner;
			}
			
			else if( mBalthArrow.x < ( pObstacle.x - pObstacle.width * .5 ) && mBalthArrow.y < pObstacle.y && tRotation >= 0 && tRotation <= 90 )
			{
				trace( "mBalthArrow left of upper left half, going SE" );
				trace( "mBLCorner" );
				tWayPoint = pObstacle.mBLCorner;
			}
			
			else if( mBalthArrow.x < ( pObstacle.x - pObstacle.width * .5 ) && mBalthArrow.y < pObstacle.y && tRotation > -90 && tRotation < 0 )
			{
				trace( "mBalthArrow left of upper left half, going NE" );
				trace( "mTLCorner" );
				tWayPoint = pObstacle.mTLCorner;
			}
			
			else if( mBalthArrow.x < pObstacle.x && mBalthArrow.y < ( pObstacle.y - pObstacle.width * .5 ) && tRotation > 90 && tRotation <= 180 )
			{
				trace( "mBalthArrow above upper left half, going SW" );
				trace( "mTLCorner" );
				tWayPoint = pObstacle.mTLCorner;
			}
			
			else if( mBalthArrow.x < pObstacle.x && mBalthArrow.y < ( pObstacle.y - pObstacle.width * .5 ) && tRotation >= 0 && tRotation <= 90 )
			{
				trace( "mBalthArrow above upper left half, going SE" );
				trace( "mTRCorner" );
				tWayPoint = pObstacle.mTRCorner;
			}
			
			else
			{
				trace( "WTF! DIRECTION AND LOCATION NOT FOUND IN RELATION TO OBSTACLE!!!" );
				trace( "tRotation: " + tRotation );
				trace( "mBalthArrow.x: " + mBalthArrow.x );
				trace( "mBalthArrow.y: " + mBalthArrow.y );
				tWayPoint = pObstacle.mTRCorner;
			}
			
			return tWayPoint;			

		} // end setBaltWaypoint
		
		//===============================================================================
		// FUNCTION setWaypoint
		//	- called from mainOnEnterFrame to set a waypoint for petpet arrow
		//===============================================================================
		public function setWaypoint( pPetpetArrow : DirArrow ):Vector2D
		{
			//trace( "setWaypoint in " + this + " called" );				
			
			var tPetpetArrow : DirArrow = pPetpetArrow;
			var tPen    	 : MovieClip = this.getChildByName( "petpet_pen" ) as MovieClip;
			var tAngle       : Number = -1.57 * Math.random( ) * Math.PI;
			var tDist        : Number = Math.random( ) * 30 + 40;
			
			/**
			 * set initial coordinates of waypoint
			 */			
			var tCoordX : Number = tPetpetArrow.x + tDist * Math.cos( tAngle );
			var tCoordY : Number = tPetpetArrow.y + tDist * Math.sin( tAngle );
			
			/**
			 * check if initial waypoint is off stage
			 * then check if it is inside or too close to any of the obstacles
			 */
			if( tCoordX < mLeftBorder + 40 || tCoordX > mRightBorder - 40||
				tCoordY < mTopBorder + 90 || tCoordY > mBottomBorder - 40 )
			{									
				return setWaypoint( tPetpetArrow );				
			}
			
			var tObstLen : int = mObstacles.length;
			for( var i : int = tObstLen - 1; i >= 0; i-- )
			{
				var tObstacle : Obstacle = mObstacles[ int( i ) ] as Obstacle;
				
				if( tCoordX > tObstacle.x - tObstacle.width / 2 - 20 && tCoordX < tObstacle.x + tObstacle.width / 2 + 20 && 
					tCoordY > tObstacle.y - tObstacle.height / 2 - 20 && tCoordY < tObstacle.y + tObstacle.height / 2 + 20 )
				{
					//trace( this + " says: waypoint is inside obstacle" );
					return setWaypoint( tPetpetArrow );
				}
			}
			
			tPetpetArrow.mHasWaypoint = true;
			
			return new Vector2D ( tCoordX, tCoordY );			

		} // end setWaypoint
				
		//===============================================================================
		// FUNCTION catchPetpet
		//===============================================================================
		private function catchPetpet( ):void
		{
			if( mSamrin.mWaypoint )
			{
				//trace( this + " says: samrin carries apple so don't pick up petpet" );
				return;
			}
			//var tScoreboard : MovieClip = this.getChildByName( "scoreboard" ) as MovieClip;			
			var tSamCollDet : MovieClip = this.getChildByName( "sam_coll_det" ) as MovieClip;
			
			/**
			 * check if hero caught a petpet
			 * if so:
			 * - remove petpet from game itself so that balthazar can't get it anymore
			 * - add it to samrin so that both samrin and the petpet will disappear if
			 *   balthazar hits samrin
			 * - go to upside down animation sequence of petpet
			 * - set samrin so that he can't carry more petpets while he is carrying one
			 */
			var tPetpetsLength : int = mPetpets.length - 1; 		
			for( var j : int = tPetpetsLength; j >= 0; j-- )
			{
				var tPetpet  : Petpet = mPetpets[ int( j ) ] as Petpet;
				
				if( tSamCollDet.hitTestObject( tPetpet ) )
				{ 
					if( !mSamrinHasPetpet )
					{
						//trace( "caught petpet" );
						//trace( mSamrin.numChildren );
						/**
						 * if samrin caught petpet
						 * - set mSamrinHasPetpet so that he can't catch another petpet and so
						 *   that the arms up animation sequence is being played
						 */
						mSamrinHasPetpet = true;
						//var tPen : MovieClip = this.getChildByName( "petpet_pen" ) as MovieClip;
						
						/**
						 * add the petpet to samrin movie clip
						 */
						tPetpet.x = 5;
						tPetpet.y = -18;
						mSamrin.addChild( tPetpet );
						
						/**
						 * add the petpet to mCarriedPetpets so that the upside down
						 * animation sequence is being played
						 */ 					
						mCarriedPetpets[ mCarriedPetpets.length ] = tPetpet;
						
						/**
						 * remove petpet from mPetpets so that Balthazar won't go for it
						 */
						mPetpets.splice( j, 1 );
						
						/**
						 * remove this petpet's arrow from stage and
						 * from mPetpetArrows array
						 */
						removeChild( mPetpetArrows[ j ] );
						mPetpetArrows.splice( j, 1 );
					}
					
					else if( !mSamrinHasTwoPetpets && mSamrin.mTwoPetpets )
					{
						trace( this + " says: samrin has 1 petpet but can carry 2!" );
						
						mSamrinHasTwoPetpets = true;
						
						/**
						 * add the petpet to samrin movie clip
						 */
						tPetpet.x = 5;
						tPetpet.y = -28;
						mSamrin.addChild( tPetpet );
						
						/**
						 * add the petpet to mCarriedPetpets so that the upside down
						 * animation sequence is being played
						 */ 					
						mCarriedPetpets[ mCarriedPetpets.length ] = tPetpet;
						
						/**
						 * remove petpet from mPetpets so that Balthazar won't go for it
						 */
						mPetpets.splice( j, 1 );
						
						/**
						 * remove this petpet's arrow from stage and
						 * from mPetpetArrows array
						 */
						removeChild( mPetpetArrows[ j ] );
						mPetpetArrows.splice( j, 1 );
					}				
				}
			}
			
		} // end catchPetpet
				
		//===============================================================================
		// FUNCTION moveHero
		//===============================================================================
		public function moveHero( ):void
		{			
			//mSamrin.mPrevX = mSamrin.x;
			//mSamrin.mPrevY = mSamrin.y;
			
			var tScoreboard : MovieClip = this.getChildByName( "scoreboard" ) as MovieClip;
			var tPen        : MovieClip = this.getChildByName( "petpet_pen" ) as MovieClip;
			var tPenGaps    : MovieClip = this.getChildByName( "pen_gaps" ) as MovieClip;
			var tSamCollDet : MovieClip = this.getChildByName( "sam_coll_det" ) as MovieClip;
			
			var tSamrinLeftEdge  : Number = tSamCollDet.x - tSamCollDet.width * .5 - 1;//mSamrin.mMaxSpeed;
			var tSamrinTop       : Number = tSamCollDet.y - tSamCollDet.height * .5 - 1;//mSamrin.mMaxSpeed;
			var tSamrinRightEdge : Number = tSamCollDet.x + tSamCollDet.width * .5 + 1;//mSamrin.mMaxSpeed;
			var tSamrinBottom    : Number = tSamCollDet.y + tSamCollDet.height * .5 + 1;//mSamrin.mMaxSpeed;
			
			var tShouldMove : Boolean;
			
			if( mKey.isDown( Keyboard.SPACE ) )
			{
				if( mSamrinHasPetpet || mSamrin.mWaypoint )
				{
					//trace( this + " says: let's get this show on the road!!" );
					dropObject( );
				}				
			}
				 
			/**
			 * determine which key was pressed and move hero in that direction
			 * also rotate hero in the direction he's walking
			 * if more than one key was pressed, apply velocity and
			 * rotation accordingly
			 */
			if( mKey.isDown( Keyboard.LEFT ) )
			{
				if( mKey.isDown( Keyboard.UP ) )
				{
					if( !isColliding( tSamrinLeftEdge, tSamrinTop ) )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelX -= mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrin.mVelY -= mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrinDir = "walk_up_left";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
				
				else if( mKey.isDown( Keyboard.DOWN ) )
				{
					if( !isColliding( tSamrinLeftEdge, tSamrinBottom ) )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelX -= mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrin.mVelY += mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrinDir = "walk_down_left";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
				
				else
				{
					if( isColliding( tSamrinLeftEdge, mSamrin.y ) == false )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelX -= mSamrin.mMaxSpeed; //= mSamrin.mSpeed;
						mSamrin.mVelY = 0;
						mSamrinDir = "walk_left";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
			}
			
			else if( mKey.isDown( Keyboard.UP ) )
			{			
				if( mKey.isDown( Keyboard.RIGHT ) )
				{
					if( isColliding( tSamrinRightEdge, tSamrinTop ) == false )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelY -= mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrin.mVelX += mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrinDir = "walk_up_right";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
				
				else
				{
					if( isColliding( mSamrin.x, tSamrinTop ) == false )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelY -= mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed;
						mSamrin.mVelX = 0;
						mSamrinDir = "walk_up";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
			}
			
			else if( mKey.isDown( Keyboard.RIGHT ) )
			{						
				if( mKey.isDown( Keyboard.DOWN ) )
				{
					if( isColliding( tSamrinRightEdge, tSamrinBottom ) == false )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelX += mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrin.mVelY += mSamrin.mMaxSpeed * .5; //= mSamrin.mSpeed * .5;
						mSamrinDir = "walk_down_right";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
				
				else
				{
					if( isColliding( tSamrinRightEdge, mSamrin.y ) == false )
					{
						mSamrinIsRunning = true;
						tShouldMove = true;
						
						mSamrin.mVelX += mSamrin.mMaxSpeed; //= mSamrin.mSpeed;
						mSamrin.mVelY = 0;
						mSamrinDir = "walk_right";
					}
					
					else
					{
						mSamrinIsRunning = false;
						
						mSamrin.mVelX = 0;
						mSamrin.mVelY = 0;
					}
				}
			}
			
			else if( mKey.isDown( Keyboard.DOWN ) )
			{
				if( isColliding( mSamrin.x, tSamrinBottom ) == false )
				{
					mSamrinIsRunning = true;
					tShouldMove = true;
						
					mSamrin.mVelY += mSamrin.mMaxSpeed; //= mSamrin.mSpeed;
					mSamrin.mVelX = 0;
					mSamrinDir = "walk_down";
				}
				
				else
				{
					mSamrinIsRunning = false;
					
					mSamrin.mVelX = 0;
					mSamrin.mVelY = 0;
				}
			}
			
			else
			{
				/**
				 * no keys are pressed so stop samrin by setting mSamrinIsRunning to false
				 * this will take the playhead to the correct idle frame in Hero class
				 */
				mSamrinIsRunning = false;
								
				mSamrin.mVelY = 0;
				mSamrin.mVelX = 0;
			}
			
			if( tShouldMove )
			{
				mSamrin.x += mSamrin.mVelX;
				mSamrin.y += mSamrin.mVelY;
			}
						
			/**
			 * determine if hero has reached his max speed in any direction
			 */
			if( mSamrin.mVelX > mSamrin.mMaxSpeed )
			{
				mSamrin.mVelX = mSamrin.mMaxSpeed;
			}
			
			else if( mSamrin.mVelX < -mSamrin.mMaxSpeed )
			{
				mSamrin.mVelX = -mSamrin.mMaxSpeed;
			}
			
			if( mSamrin.mVelY > mSamrin.mMaxSpeed )
			{
				mSamrin.mVelY = mSamrin.mMaxSpeed;
			}
			
			else if( mSamrin.mVelY < -mSamrin.mMaxSpeed )
			{
				mSamrin.mVelY = -mSamrin.mMaxSpeed;
			}
			
			/**
			 * determine if hero hits border of stage
			 * if so, he appears on other side
			 */
			if( mSamrin.x + mSamrin.width * .5 < mLeftBorder )
			{
				mSamrin.x = mRightBorder + mSamrin.width * .5;
			}
			
			else if( mSamrin.x - mSamrin.width * .5 > mRightBorder )
			{
				mSamrin.x = mLeftBorder - mSamrin.width * .5;
			}
			
			if( mSamrin.y + mSamrin.height * .5 < mTopBorder )
			{
				mSamrin.y = mBottomBorder + mSamrin.height * .5;
			}
			
			else if( mSamrin.y - mSamrin.height * .5 > mBottomBorder )
			{
				mSamrin.y = mTopBorder - mSamrin.height * .5;
			}
			
			/**
			 * check if Samrin hits gaps in pen. if so
			 * - check if he carries a petpet
			 *   - if he carries a petpet
			 * 	   - set mSamrinHasPetpet to false so that code block for catching 
			 * 		 petpets is executed
			 * 	   - add petpet to the pen
			 * 	   - remove it from mCarriedPetpets
			 *     - decrement mLevelManager.mPetpetsInLevel so that level will end 
			 * 		 when all petpets in this level are gone 
			 */
			 if( mKey.isDown( Keyboard.RIGHT ) && tPenGaps.mGapLeft != null && tSamCollDet.hitTestObject( tPenGaps.mGapLeft   ) ||
			     mKey.isDown( Keyboard.DOWN ) && tPenGaps.mGapTop != null && tSamCollDet.hitTestObject( tPenGaps.mGapTop    ) ||
			     mKey.isDown( Keyboard.LEFT ) && tPenGaps.mGapRight != null && tSamCollDet.hitTestObject( tPenGaps.mGapRight  ) ||
			     mKey.isDown( Keyboard.UP ) && tPenGaps.mGapBottom != null && tSamCollDet.hitTestObject( tPenGaps.mGapBottom )   )
			 {
			 	if( mSamrinHasPetpet )
			 	{
			 		//trace( this + " says: drop that little sucker in the pen" );
			 		mSamrinHasPetpet     = false;
			 		mSamrinHasTwoPetpets = false;
			 		
			 		var tCarriedPetpetsLen : int = mCarriedPetpets.length; 		
					for( var i : int = tCarriedPetpetsLen - 1; i >= 0; i-- )
					{
						var tPetpet : Petpet = mCarriedPetpets[ int( i ) ] as Petpet;
						
						tPetpet.x = Math.floor( 40 + Math.random( ) * - 80 );
						tPetpet.y = Math.floor( 40 + Math.random( ) * - 80 );
						tPetpet.mPetpetMC.gotoAndStop( 1 );
						tPen.addChild( tPetpet );
						
						mCarriedPetpets.splice( i, 1 );
						mPetpetsInPen.push( tPetpet );
						mLevelManager.mPetpetsInLevel--;
						
						/**
						 * update the scoreboard and score display
						 */
						GameVars.mGameScore.changeBy( mPetpetPoints );
						tScoreboard.updateScoreDisplay( );
					}
				 }
			 }
			 
			 /**
			  * check if a power up is currently on stage
			  */
			 if( mPowerUpManager.mPowerUpOnStage )
			 {
			 	/**
			 	 * power up is on stage so determine which one it is
			 	 */
			 	var tPowerUp : PowerUp;
			 	
			 	if( getChildByName( "speed_up_pu" ) != null )
				{
					tPowerUp = getChildByName( "speed_up_pu" ) as PowerUp;		
				}
				
				else if( getChildByName( "freeze_pu" ) != null )
				{
					tPowerUp = getChildByName( "freeze_pu" ) as PowerUp;
				}
				
				else if( getChildByName( "two_pps_pu" ) != null )
				{
					tPowerUp = getChildByName( "two_pps_pu" ) as PowerUp;
				}
				
				else if( getChildByName( "waypoint_pu" ) != null )
				{
					tPowerUp = getChildByName( "waypoint_pu" ) as PowerUp;
				}
				
				/**
				 * determine if samrin touches it and
				 * if it is not null. it will be null
				 */
				if( tSamCollDet.hitTestObject( tPowerUp ) )
				{
					trace( this + " says: samrin got " + tPowerUp.name );
					
					if( tPowerUp.name != "waypoint_pu" )
					{					
						/**
						 * set mPowerUpManager.mPowerUpOnStage = false and 
						 * mPowerUpManager.mPowerUpActive = true so that
						 * no new power up is created in mainOnEnterFrame
						 */
						mPowerUpManager.mPowerUpOnStage = false;
						mPowerUpManager.mPowerUpActive = true;
						
						/**
						 * remove the power up from stage
						 */
						removeChild( tPowerUp );
					
						/**
						 * activate power up in PowerUpManager
						 */
						Dispatcher.dispatchEvent( new DataEvent( ACTIVATE_POWER_UP, tPowerUp.name ) );
			
						/**
						 * after samrin collected power up, mPUOnStageTimer in PowerUpManager
						 * will still be running so stop it
						 */
						Dispatcher.dispatchEvent( new DataEvent( REMOVE_TIMER ) );
					}
					
					/**
					 * activate the effect according to which power up was collected
					 */
					switch( tPowerUp.name )
				 	{
				 		case "speed_up_pu":
					 		if( GameVars.mSoundOn )
							{
								Dispatcher.dispatchEvent( new DataEvent( SPEED_UP, "PUSpeedUp" ) )
							}
							mSamrin.mMaxSpeed = 10;
							break;
							
						case "freeze_pu":
							if( GameVars.mSoundOn )
							{
								Dispatcher.dispatchEvent( new DataEvent( FREEZE, "PUFreeze" ) )
							}
							mBalthazar.mIsFrozen = true;
							break;
							
						case "two_pps_pu":
							if( GameVars.mSoundOn )
							{
								Dispatcher.dispatchEvent( new DataEvent( TWO_PETPETS, "PUTwoPetpets" ) )
							}
							mSamrin.mTwoPetpets = true;
							break;
							
						case "waypoint_pu":
							if( !mSamrinHasPetpet )
							{
								/**
								 * set mPowerUpManager.mPowerUpOnStage = false and 
								 * mPowerUpManager.mPowerUpActive = true so that
								 * no new power up is created in mainOnEnterFrame
								 */
								mPowerUpManager.mPowerUpOnStage = false;
								mPowerUpManager.mPowerUpActive = true;
								
								/**
								 * after samrin collected power up, mPUOnStageTimer in PowerUpManager
								 * will still be running so stop it
								 */
								Dispatcher.dispatchEvent( new DataEvent( REMOVE_TIMER ) );
								
								tPowerUp.mWaypoint.gotoAndStop( 3 );
								tPowerUp.x = 5;
								tPowerUp.y = - 25;
								mSamrin.addChild( tPowerUp );
								
								mSamrin.mWaypoint = true;
							}
							break;
							
						default:
							trace( this + " says: POWER UP NOT FOUND" );
							break;
					}
				}		 	
			 }

		} // end moveHero
		
		//===============================================================================
		// FUNCTION isColliding
		//===============================================================================
		private function isColliding( pX : Number, pY : Number ):Boolean
		{
			//trace( "checkHeroCollision in " + this + " called" );
			
			/**
			 * check if hero is running into obstacle
			 */
			var tObstLen : int = mObstacles.length;
			for( var i : int = tObstLen - 1; i >= 0; i-- )
			{
				var tObstacle : Obstacle = mObstacles[ int( i ) ] as Obstacle;
				if( pX >= tObstacle.x - tObstacle.width * .5 && pX <= tObstacle.x + tObstacle.width  * .5 && 
					pY >= tObstacle.y - tObstacle.height * .5 && pY <= tObstacle.y + tObstacle.height * .5 )
				{
					//trace( this + " says: samrin is inside obstacle" );
					return true;
				}				
			}
			
			/**
			 * check if hero is running into border hedge
			 */
			var tHedgeLen : int = mHedges.length;
			for( var j : int = tHedgeLen - 1; j >= 0; j-- )
			{
				var tHedge : Hedge = mHedges[ int( j ) ] as Hedge;
				if( pX >= tHedge.x - tHedge.width * .5 + 5 && pX <= tHedge.x + tHedge.width  * .5 - 5 && 
					pY >= tHedge.y - tHedge.height * .5 + 5 && pY <= tHedge.y + tHedge.height * .5 - 5 )
				{
					//trace( this + " says: samrin is inside hedge" );
					return true;
				}				
			}
			
			return false;			
			
		} // end isColliding
		
		//===============================================================================
		// FUNCTION dropObject
		//===============================================================================
		private function dropObject( ):void
		{
			//trace( this + " says: dropObject called" );
			
			trace( this + " says: mSamrin.numChildren: " + mSamrin.numChildren );
			//var tWaypoint : PowerUp = getChildByName( "waypoint_pu" ) as PowerUp;
			
			for( var i : int = mSamrin.numChildren - 1; i >= 0; i-- )
			{
				//trace( mSamrin.getChildAt( i ).name );
				if( mSamrin.getChildAt( i ) is Petpet )
				{
					trace( this + " says: drop petpet now!" );
					var tPetpet : Petpet = mSamrin.getChildAt( i ) as Petpet;
					placeObject( tPetpet );
					//return;			
				}
				
				else if( mSamrin.getChildAt( i ) is PowerUp )
				{
					trace( this + " says: drop waypoint now!" );
					var tPowerUp : PowerUp = mSamrin.getChildAt( i ) as PowerUp;
					placeObject( tPowerUp );	
				}
			} 
			
		} // end dropObject
		
		//===============================================================================
		// FUNCTION placeObject
		//===============================================================================
		private function placeObject( pObj : * ):void
		{
			trace( this + " says: placeObject called" );
			
			if( pObj is Petpet )
			{
				mSamrinHasPetpet = false;
				mSamrinHasTwoPetpets = false;
				
				/**
				 * add the petpet back to stage next to samrin
				 */
				var tCarriedPetpetsLen : int = mCarriedPetpets.length; 		
				for( var i : int = tCarriedPetpetsLen - 1; i >= 0; i-- )
				{
					var tPetpet : Petpet = mCarriedPetpets[ int( i ) ] as Petpet;
					tPetpet.visible = false;
					
					var tPen    	 : MovieClip = this.getChildByName( "petpet_pen" ) as MovieClip;
					var tAngle       : Number = -1.57 * Math.random( ) * Math.PI;
					var tDist        : Number = 60;
					
					/**
					 * set initial coordinates of waypoint
					 */			
					var tCoordX : Number = mSamrin.x + tDist * Math.cos( tAngle );
					var tCoordY : Number = mSamrin.y + tDist * Math.sin( tAngle );
					
					/**
					 * check if initial waypoint is off stage
					 * then check if it is inside or too close to any of the obstacles
					 */
					if( tCoordX < mLeftBorder + 40 || tCoordX > mRightBorder - 40||
						tCoordY < mTopBorder + 90 || tCoordY > mBottomBorder - 40 )
					{									
						return placeObject( tPetpet );				
					}
					
					var tObstLen : int = mObstacles.length;
					for( var j : int = tObstLen - 1; j >= 0; j-- )
					{
						var tObstacle : Obstacle = mObstacles[ int( j ) ] as Obstacle;
						
						if( tCoordX > tObstacle.x - tObstacle.width / 2 - 20 && tCoordX < tObstacle.x + tObstacle.width / 2 + 20 && 
							tCoordY > tObstacle.y - tObstacle.height / 2 - 20 && tCoordY < tObstacle.y + tObstacle.height / 2 + 20 )
						{
							//trace( this + " says: waypoint is inside obstacle" );
							return placeObject( tPetpet );
						}
					}
					
					tPetpet.x = tCoordX;
					tPetpet.y = tCoordY;
					addChild( tPetpet );
					tPetpet.visible = true;
					
					/**
					 * remove petpet from mCarriedPetpets array
					 */
					mCarriedPetpets.splice( i, 1 );
					
					/**
					 * add the petpet to mPetpets array
					 */ 					
					mPetpets[ mPetpets.length ] = tPetpet;
					
					/**
					 * add an arrow for this petpet
					 */
					var tPetpetArrow : DirArrow = new DirArrow( );
					tPetpetArrow.x = tPetpet.x;
					tPetpetArrow.y = tPetpet.y;
					tPetpetArrow.visible = false;
					addChild( tPetpetArrow );
					mPetpetArrows[ mPetpetArrows.length ] = tPetpetArrow;
				}			
			}
			
			else if( pObj is PowerUp )
			{
				pObj.x = mSamrin.x;
				pObj.y = mSamrin.y;
				addChild( pObj );
				
				mSamrin.mWaypoint = false;
			}
			
		} // end placeObject
						
		//===============================================================================
		// FUNCTION positionChars
		//===============================================================================
		internal function positionChars( pCharName : String ):void
		{
			//trace( "positionChars in " + this + " called" );
			
			//trace( "pCharName: " + pCharName );
						
			var tPen        : MovieClip = this.getChildByName( "petpet_pen" ) as MovieClip;
			var tScoreboard : MovieClip = this.getChildByName( "scoreboard" ) as MovieClip;
			//trace( "tScoreboard.height: " + tScoreboard.height );
			
			if( this.getChildByName( pCharName ) != null )
			{
				var tChar : MovieClip = this.getChildByName( pCharName ) as MovieClip;
				//trace( "has " + tChar );
				//trace( "tChar.name " + tChar.name );
						
				var tCorner : int;				
				var tX : Number;
				var tY : Number;
				
				/**
				 * if balthazar appears in upper right corner
				 * put petpets in lower right corner below pen (LRB)
				 * put petpets in upper left corner left of pen (ULL)
				 */
				var tULLLeft   : Number = 50;
				var tULLRight  : Number = mStage.stageWidth * .5 - tPen.width * .5 - 60;
				var tULLTop    : Number = tScoreboard.height + 40;
				var tULLBottom : Number = mStage.height * .5 - tScoreboard.height - 20;
				
				var tLRBLeft   : Number = mStage.stageWidth * .5;
				var tLRBRight  : Number = mStage.stageWidth * .5 - 40;
				var tLRBTop    : Number = mStage.stageHeight * .5 + tPen.height * .5 + 30;
				var tLRBBottom : Number = mStage.stageHeight * .5 - tPen.height * .5 - 70;
				
				/**
				 * if balthazar appears in upper left corner
				 * put petpets in lower left corner below pen (LLB)
				 * put petpets in upper right corner right of pen (URR)
				 */
				var tURRLeft  : Number = mStage.stageWidth * .5 + tPen.width * .5 + 30;
				var tURRRight : Number = mStage.stageWidth * .5 - tPen.width;
				// tURRTop = tULLTop
				// tURRBottom = tULLBottom
				
				// tLLBLeft = tULLLeft
				var tLLBRight : Number = mStage.width * .5 - tPen.width * .5;
				// tLLBTop = tLRBTop
				// tLLBBottom = tLRBTop
				
				/**
				 * if balthazar appears in lower left corner
				 * put petpets in lower right corner right of pen (LRR)
				 * put petpets in upper left corner above pen (ULA)
				 */
				// tLRRLeft = tURRLeft
				// tLRRight = tURRRight
				var tLRRTop    : Number = mStage.height * .5 + tPen.height * .5;
				var tLRRBottom : Number = mStage.height * .5 - tPen.height;
				
				// tULALeft = tULLLeft
				// tULARight = tLLBRight
				// tULATop = tULLTop
				var tULABottom = mStage.stageHeight * .5 - tPen.height - 30;
				
				/**
				 * if balthazar appears in lower right corner
				 * put petpets in lower left corner left of pen (LLL)
				 * put petpets in upper right corner above pen (URA)
				 */
				// tLLLLeft   = tULLLeft;
				// tLLLRight  = tULLRight;
				// tLLLTop    = tLRRTop;
				// tLLLBottom = tLRRBottom;
				 
				// tURALeft   = tLRBLeft
				// tURARight  = tLRBRight
				// tURATop    = tULLTop
				// tURABottom = tULABottom		
					
				/**
				 * samrin in upper left area
				 */
				var tTopLeftLeft   : Number = 50;
				var tTopLeftRight  : Number = mStage.stageWidth * .5 - tPen.width * .5 - 50;
				var tTopLeftTop    : Number = tScoreboard.height + 40;
				var tTopLeftBottom : Number = tScoreboard.height + mStage.stageHeight * .5 - tPen.height - 60;
				
				/**
				 * samrin in upper right area 
				 */
				var tTopRightLeft   : Number = mStage.stageWidth * .5 + tPen.width * .5 + 10;
				var tTopRightRight  : Number = mStage.stageWidth * .5 - tPen.width * .5 - 60;
				//tTopRightTop    = tTopLeftTop 
				//tTopRightBottom = tTopLeftBottom
				
				/**
				 * samrin in lower right area
				 */
				//tLowerRightLeft  = tTopRightLeft
				//tLowerRightRight = tTopRightRight
				var tLowerRightTop    : Number = mStage.stageHeight * .5 + tPen.height * .5 + 10;
				var tLowerRightBotton : Number = mStage.stageHeight * .5 - tPen.height * .5 - 50;
				
				/**
				 * samrin in lower left area
				 */
				//tLowerLeftLeft   = tTopLeftLeft
				//tLowerLefRight   = tTopLeftRight
				//tLowerLeftTop    = tLowerRightTop
				//tLowerLeftBottom = tLowerRightBotton
				
				if( tChar.name == "balth_arrow" ) tCorner = Math.floor( Math.random( ) * 4 );				
				else if( mBalthArrow.mInitPos == "upperLeft" ) tCorner = 2;				
				else if( mBalthArrow.mInitPos == "upperRight" ) tCorner = 3;				
				else if( mBalthArrow.mInitPos == "lowerRight" ) tCorner = 0;
				else tCorner = 1;
				
				switch( tCorner )
				{
					case 0:
						if( tChar.name == "balth_arrow" )
						{
							tChar.mInitPos = "upperLeft";
							trace( "mBalthArrow.mInitPos: " + mBalthArrow.mInitPos );
							tX = 50;
							tY = 120;
							tChar.position = new Vector2D( tX, tY );
						} 
						
						else if( tChar.name == "hero" )
						{
							trace( "hero in upper left area" );
							tChar.x = ( tTopLeftLeft ) + Math.random( ) * ( tTopLeftRight );
							tChar.y = ( tTopLeftTop ) + Math.random( ) * ( tTopLeftBottom );
							
							if( isColliding( tChar.x, tChar.y ) )
							{
								positionChars( tChar.name );
							}
						}
						
						else
						{
							var tPosToggler1 : int = Math.round( Math.random( ) * 1 );
							if( tPosToggler1 == 0 )
							{
								//trace( "petpet in upper right corner above pen" );
								tChar.x = ( tLRBLeft ) + Math.random( ) * ( tLRBRight );
								tChar.y = ( tULLTop ) + Math.random( ) * ( tULABottom );
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}
							
							else
							{
								//trace( "petpet in lower left corner left of pen" );
								tChar.x = ( tULLLeft ) + Math.random( ) * ( tULLRight );
								tChar.y = ( tLRRTop ) + Math.random( ) * ( tLRRBottom );
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}					
						}
						break;
					
					case 1:
						if( tChar.name == "balth_arrow" )
						{
							tChar.mInitPos = "upperRight";
							trace( "mBalthArrow.mInitPos: " + mBalthArrow.mInitPos );
							tX = 570;
							tY = 120;
							tChar.position = new Vector2D( tX, tY );
						}
						
						else if( tChar.name == "hero" )
						{
							trace( "samrin in upper right area" );
							tChar.x = ( tTopRightLeft ) + Math.random( ) * ( tTopRightRight );
							tChar.y = ( tTopLeftTop ) + Math.random( ) * ( tTopLeftBottom ); 
							
							if( isColliding( tChar.x, tChar.y ) )
							{
								positionChars( tChar.name );
							}
						}
						
						else
						{
							var tPosToggler2 : int = Math.round( Math.random( ) * 1 );
							if( tPosToggler2 == 0 )
							{								
								//trace( "petpet in upper left corner above pen" );
								tChar.x = ( tULLLeft ) + Math.random( ) * ( tLLBRight );
								tChar.y = ( tULLTop ) + Math.random( ) * ( tULABottom );
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}
							
							else
							{								
								//trace( "petpet in lower right corner right of pen" );
								tChar.x = ( tURRLeft ) + Math.random( ) * ( tURRRight );
								tChar.y = ( tLRRTop ) + Math.random( ) * ( tLRRBottom );
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}
						}
						break;
						
					case 2:
						if( tChar.name == "balth_arrow" )
						{
							tChar.mInitPos = "lowerRight";
							trace( "mBalthArrow.mInitPos: " + mBalthArrow.mInitPos );
							tX = 570;
							tY = 520;
							tChar.position = new Vector2D( tX, tY );
						}
						
						else if( tChar.name == "hero" )
						{
							trace( "samrin in lower right area" );
							tChar.x = ( tTopRightLeft ) + Math.random( ) * ( tTopRightRight );
							tChar.y = ( tLowerRightTop ) + Math.random( ) * ( tLowerRightBotton );
							
							if( isColliding( tChar.x, tChar.y ) )
							{
								positionChars( tChar.name );
							}
						}
						
						else
						{
							var tPosToggler3 : int = Math.round( Math.random( ) * 1 );
							if( tPosToggler3 == 0 )
							{
								//trace( "petpet in lower left corner below pen" );
								tChar.x = ( tULLLeft ) + Math.random( ) * ( tLLBRight );
								tChar.y = ( tLRBTop ) + Math.random( ) * ( tLRBBottom );
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}
							
							else
							{								
								//trace( "petpet in upper right corner right of pen" );
								tChar.x = ( tURRLeft ) + Math.random( ) * ( tURRRight );
								tChar.y = ( tULLTop ) + Math.random( ) * ( tULLBottom ); 
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}							
						}
						break;
					
					case 3:
						if( tChar.name == "balth_arrow" )
						{
							tChar.mInitPos = "lowerLeft";
							trace( "mBalthArrow.mInitPos: " + mBalthArrow.mInitPos );
							tX = 50;
							tY = 520;
							tChar.position = new Vector2D( tX, tY );
						}
						
						else if( tChar.name == "hero" )
						{
							trace( "samrin in lower left area" );
							tChar.x = ( tTopLeftLeft ) + Math.random( ) * ( tTopLeftRight );
							tChar.y = ( tLowerRightTop ) + Math.random( ) * ( tLowerRightBotton ); 
							
							if( isColliding( tChar.x, tChar.y ) )
							{
								positionChars( tChar.name );
							}
						}
						
						else
						{
							var tPosToggler4 : int = Math.round( Math.random( ) * 1 );
							if( tPosToggler4 == 0 )
							{								
								//trace( "petpet in lower right corner below pen" );
								tChar.x = ( tLRBLeft ) + Math.random( ) * ( tLRBRight );
								tChar.y = ( tLRBTop ) + Math.random( ) * ( tLRBBottom );
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}
							
							else
							{								
								//trace( "petpet in upper left corner left of pen" );
								tChar.x = ( tULLLeft ) + Math.random( ) * ( tULLRight );
								tChar.y = ( tULLTop ) + Math.random( ) * ( tULLBottom ); 
								
								if( isColliding( tChar.x, tChar.y ) )
								{
									positionChars( tChar.name );
								}
							}
						}
						break;
				}
			}
			
			if( tChar is DirArrow == false)
			{
				tChar.visible = true;
			}
						
		} // end positionChars
		
		//===============================================================================
		// FUNCTION checkLevel
		//===============================================================================
		private function checkLevel( ):void
		{	
			//trace( "checkLevel in " + this + " called" );
			
			//trace( this + " says: mLevel " + mLevel );
			
			var tScoreboard : MovieClip = this.getChildByName( "scoreboard" ) as MovieClip;
						
			if( mLevelCheck )
			{
				mLevelCheck = false;
				mLevel++;
				
				//trace( this + " says: mLevel " + mLevel );
				
				/**
				 * update scoreboard to display correct level
				 */
				tScoreboard.updateLvlDisplay( mLevel );	
			
				/**
				 * tell mLevelManager the level
				 * based on this, mLevelManager will decide
				 * - how many petpets will be created
				 * - how many gaps the edge hedges will have
				 */
				mLevelManager.mLevel = mLevel;
				mLevelManager.update( );
				
				/**
				 * - create pen first because it's an element referenced
				 *   in positionChars( ) 
				 */
				var tPen : Pen = new Pen( );
				tPen.name = "petpet_pen";
				tPen.x = mStage.stageWidth * .5;
				tPen.y = mStage.stageHeight * .5;
				if( mLevel < 6 )
				{								
					tPen.mPenMC.gotoAndStop( 1 );
				}
				
				else if( mLevel < 11 )
				{								
					tPen.mPenMC.gotoAndStop( 2 );
				}
				
				else if( mLevel < 16 )
				{								
					tPen.mPenMC.gotoAndStop( 3 );
				}
				
				else
				{
					tPen.mPenMC.gotoAndStop( 4 );
				}
				addChild( tPen );
				mObstacles[ mObstacles.length ] = tPen;
				
				/**
				 * add gaps in pen. when samrin touches them, carried
				 * petpet will be dropped
				 */
				var tGapsClass : Class = mAssetLocation.getDefinition( "PenGaps" ) as Class;
				var tGaps : MovieClip = new tGapsClass( );
				tGaps.name = "pen_gaps";
				tGaps.x = tPen.x;
				tGaps.y = tPen.y;
				
				if( mLevel < 6 )
				{								
					tGaps.gotoAndStop( 1 );
				}
				
				else if( mLevel < 11 )
				{								
					tGaps.gotoAndStop( 2 );
				}
				
				else if( mLevel < 16 )
				{								
					tGaps.gotoAndStop( 3 );
				}
				
				else
				{
					tGaps.gotoAndStop( 4 );
				}
				
				addChild( tGaps );				
				
				if( mLevel > 3 )
				{
					/**
					 * puddle one
					 */
					var tPuddle : ObstacleProper = new ObstacleProper( "Puddle" );
					tPuddle.x = 150;
					tPuddle.y = 230;
					addChild( tPuddle );
					
					var tPuddleCollDet : Obstacle = new Obstacle( );
					tPuddleCollDet.graphics.beginFill( 0xff0000, 0 );
					tPuddleCollDet.graphics.drawRect( -30, -25, 60, 50 );
					tPuddleCollDet.graphics.endFill( );
					tPuddleCollDet.x = tPuddle.x;
					tPuddleCollDet.y = tPuddle.y ;
					addChild( tPuddleCollDet );
					mObstacles[ mObstacles.length ] = tPuddleCollDet;
				}
				
				if( mLevel > 8 )
				{						
					/**
					 * boulder
					 */
					var tBoulder : ObstacleProper = new ObstacleProper( "Boulder" );
					tBoulder.x = 530;
					tBoulder.y = 330;
					addChild( tBoulder );
									
					var tBoulderCollDet : Obstacle = new Obstacle( );
					tBoulderCollDet.graphics.beginFill( 0xff0000, 0 );
					tBoulderCollDet.graphics.drawRect( -30, -25, 60, 50 );
					tBoulderCollDet.graphics.endFill( );
					tBoulderCollDet.x = tBoulder.x;
					tBoulderCollDet.y = tBoulder.y ;
					addChild( tBoulderCollDet );
					mObstacles[ mObstacles.length ] = tBoulderCollDet;
				}
				
				if( mLevel > 12 )
				{	
					/**
					 * puddle two
					 */
					var tPuddle2 : ObstacleProper = new ObstacleProper( "Puddle" );
					tPuddle2.x = 450;
					tPuddle2.y = 470;
					addChild( tPuddle2 );
					
					var tPuddleCollDet2 : Obstacle = new Obstacle( );
					tPuddleCollDet2.graphics.beginFill( 0xff0000, 0 );
					tPuddleCollDet2.graphics.drawRect( -30, -25, 60, 50 );
					tPuddleCollDet2.graphics.endFill( );
					tPuddleCollDet2.x = tPuddle2.x;
					tPuddleCollDet2.y = tPuddle2.y ;
					addChild( tPuddleCollDet2 );
					mObstacles[ mObstacles.length ] = tPuddleCollDet2;
				}
				
				if( mLevel > 17 )
				{	
					/**
					 * boulder two
					 */
					var tBoulder2 : ObstacleProper = new ObstacleProper( "Boulder" );
					tBoulder2.x = 180;
					tBoulder2.y = 460;
					addChild( tBoulder2 );
					
					var tBoulderCollDet2 : Obstacle = new Obstacle( );
					tBoulderCollDet2.graphics.beginFill( 0xff0000, 0 );
					tBoulderCollDet2.graphics.drawRect( -30, -25, 60, 50 );
					tBoulderCollDet2.graphics.endFill( );
					tBoulderCollDet2.x = tBoulder2.x;
					tBoulderCollDet2.y = tBoulder2.y ;
					addChild( tBoulderCollDet2 );
					mObstacles[ mObstacles.length ] = tBoulderCollDet2;					
				}
				
				/**
				 * - create hedges before moving characters so that if they
				 *   overlap, characters will be on top of hedges
				 * - this loop will be executed every level because they are being
				 *   removed and re-added to close the gaps in higher levels
				 */
				mHedges = mLevelManager.mBorderHedges.slice( );
				var tHedgeLen : int = mHedges.length;
				for( var i : int = 0; i < tHedgeLen; i++ )
				{
					this.addChild( mHedges[ i ] );
				}
			
				/**
				 * mBalthArrow
				 * - instantiated in setupVars
				 * - create before petpets and samrin because their initial 
				 *   position depends on initial position of mBalthArrow
				 * - assign name and mMaxSpeed only in level 1 because
				 *   those values don't change in subsequent levels
				 */
				mBalthArrow    = new DirArrow( );
				mBalthArrow.name = "balth_arrow";
				mBalthArrow.mMaxSpeed = 1.5;
				mBalthArrow.visible = false;
				addChild( mBalthArrow );
				positionChars( "balth_arrow" );
				
				/**
				 * set mBalthazar to same coordinates as mBalthArrow
				 * set visible to true because it's set to false after 
				 * a level is finished
				 */
				mBalthazar.x = mBalthArrow.x;
				mBalthazar.y = mBalthArrow.y;
				mBalthazar.visible = true;
				addChild( mBalthazar );
			
				/**
				 * samrin
				 * - instantiated in setupVars
				 * - assign name only in level 1 because 
				 * 	 it doesn't change in subsequent levels
				 */
				if( mLevel == 1 )
				{
					mSamrin.name = "hero";
				}
				mSamrin.visible = false;
				addChild( mSamrin );
				positionChars( "hero" );
				
				var tSamCollDetClass : Class = mAssetLocation.getDefinition( "SamrinCollDet" ) as Class;
				var tSamCollDet : MovieClip = new tSamCollDetClass( );
				tSamCollDet.name = "sam_coll_det";
				tSamCollDet.alpha = 0;
				tSamCollDet.x = mSamrin.x;
				tSamCollDet.y = mSamrin.y;
				addChild( tSamCollDet );
					
				mPetpetArrows = mLevelManager.mPetpetArrows.slice( );
				mPetpets      = mLevelManager.mPetpets.slice( );	
				for( var j : int = 0; j < mLevelManager.mPetpetsInLevel; j++ )
				{
					var tPetpetArrow : DirArrow = mPetpetArrows[ j ];
					tPetpetArrow.name = "petpet_arrow" + j;
					tPetpetArrow.visible = false;
					addChild( tPetpetArrow );
					positionChars( "petpet_arrow" + j );
					
					/**
					 * sometimes it seems to happen that petpet arrows are placed
					 * below stage. if that happens, place them on stage at 540
					 * it might also happen that they are placed above stage although
					 * i haven't actually seen that but just in case i am checking
					 */
					if( tPetpetArrow.y < 40 )
					{
						trace( this + " says: tPetpetArrow.y < 0" );
						trace( this + " says: tPetpetArrow.y: " + tPetpetArrow.y );
						trace( this + " says: tPetpetArrow.name: " + tPetpetArrow.name );
						tPetpetArrow.y = 90;
					}
					
					else if( tPetpetArrow.y > mStage.stageHeight - 20 )
					{
						trace( this + " says: tPetpetArrow.y > mStage.stageHeight" );
					   	trace( this + " says: tPetpetArrow.y: " + tPetpetArrow.y );
					   	trace( this + " says: tPetpetArrow.name: " + tPetpetArrow.name );
					   	tPetpetArrow.y = 540;
					}
					
					var tPetpet : Petpet = mPetpets[ j ];
					tPetpet.x = tPetpetArrow.x;
					tPetpet.y = tPetpetArrow.y;
					addChild( tPetpet );
										
					/**
					 * when testing: add arrow again so it's on top of petpet
					 */
					//addChild( tPetpetArrow );
				}
			
				/**
				 * add scoreboard last so that it's on top
				 */
				addChild( tScoreboard );
				
				/**
				 * call reset in mLevelManager so that all elements
				 * are reset and ready for next level
				 */
				mLevelManager.reset( );
			
				mStage.focus = mStage;
				addGameLisnrs( );
				//mStage.addEventListener( Event.ENTER_FRAME, mainOnEnterFrame, false, 0, true );
			}
			
			if( tScoreboard.mLivesArr.length < 1 )
			{
				/**
				 * when all 3 lives are lost, go to game over screen
				 * first, remove all event listeners in the main game
				 */
				clearGame( );
				
				/**
				 * go to game over screen by dispatching event
				 * GameStartUp listens for GAME_OVER event
				 */
				Dispatcher.dispatchEvent( new Event( GAME_OVER ) );
				
				return;
			}
			
			if( mLevelManager.mPetpetsInLevel == 0 )
			{
				trace( this + "says: all petpets gone. go to next level!" );
				
				/**
				 * when all petpets are either in pen or eaten and not all
				 * lives are lost, set game up for next level
				 * - remove event listeners pertinent to game functionality
				 * - set characters visibility to 0
				 * - add the level transition popup
				 */
				removeGameEvtLisnrs( );
				mBalthazar.visible = false;
				mSamrin.visible = false;
			
				deactivatePUEffect( );
				
				/**
				 * dispatch event to deactivate power up in Scoreboard
				 */
				Dispatcher.dispatchEvent( new DataEvent( DEACTIVATE_POWER_UP_DISP ) );
				
				var tPopUp : NextLevelPopUp = new NextLevelPopUp( mLevel );
				tPopUp.name = "next_level_pop_up";
				addChild( tPopUp );
				tPopUp.doAnimation( );
			}
			
		} // end checkLevel
		
		//===============================================================================
		// FUNCTION setUpNextLevel
		// - called through Dispatcher event NEXT_LEVEL from NextLevelPopUp
		//===============================================================================
		internal function setUpNextLevel( evt : Event ):void
		{
			trace( "setUpNextLevel in " + this + " called" );			
			
			if( this.getChildByName( "next_level_pop_up" ) != null )
			{
				var tPopUp : NextLevelPopUp = this.getChildByName( "next_level_pop_up" ) as NextLevelPopUp;
			 	removeChild( tPopUp );
			 	tPopUp = null;
			}
			 
			var tPen : Pen = this.getChildByName( "petpet_pen" ) as Pen;
			var tPenGaps : MovieClip = this.getChildByName( "pen_gaps" ) as MovieClip;
			removeChild( tPenGaps );
			tPenGaps = null;
			 
			var tHedgeLen : int = mHedges.length - 1;
			for( var i : int = tHedgeLen; i >= 0; i-- )
			{
			 	this.removeChild( mHedges[ i ] );
			}
			mHedges.length = 0;
			mHedges = [ ];
			
			var tPetpetsLen : int = mPetpets.length - 1;
			for( var j : int = tPetpetsLen; j >= 0; j-- )
			{
				this.removeChild( mPetpets[ j ] );
			}
			mPetpets.length = 0;
			mPetpets = [ ];
			
			var tPetpetArrowsLen : int = mPetpetArrows.length - 1;
			for( var k : int = tPetpetArrowsLen; k >= 0; k-- )
			{
				this.removeChild( mPetpetArrows[ k ] );
			}
			mPetpetArrows.length = 0;
			mPetpetArrows = [ ];
			
			var tCarriedPetpetsLen : int = mCarriedPetpets.length - 1;
			for( var l : int = tCarriedPetpetsLen; l >= 0; l-- )
			{
				this.removeChild( mCarriedPetpets[ l ] );
			}
			mCarriedPetpets.length = 0;
			mCarriedPetpets = [ ];
						
			var tPetpetsInPenLen : int = mPetpetsInPen.length - 1;
			for( var m : int = tPetpetsInPenLen; m >= 0; m-- )
			{
				tPen.removeChild( mPetpetsInPen[ m ] );
			}
			mPetpetsInPen.length = 0;
			mPetpetsInPen = [ ];
			
			var tObstaclesLen : int = mObstacles.length - 1;
			for( var n : int = tObstaclesLen; n >= 0; n-- )
			{
				removeChild( mObstacles[ n ] );
			}
			mObstacles.length = 0;
			mObstacles = [ ];
			
			/**
			 * setting tPen to null. does not need to be removed from 
			 * stage since it's already done in clearing mObstacles array
			 */		
			tPen = null;
			
			removeChild( mBalthArrow ); 
			mBalthArrow = null;
			
			/**
			 * set all of Balthazar's booleans to false so that
			 * he behaves correctly at beginning of next level
			 */
			mBalthazar.mIsGrabbing = false;
			mBalthazar.mStartsGrab = false;
			
			/**
			 * set all of Samrin's booleans to false so that
			 * he behaves correctly at beginning of next level
			 */
			mSamrinHasPetpet = false;
			mSamrinIsRunning = false;
			
			mLevelCheck = true;
			checkLevel( );
			
		} // end setUpNextLevel	
		
		//===============================================================================
		// FUNCTION deactivatePUEffectEvt
		//	- dumme function that can be called by dispatching an DataEvent
		//	- called from PowerUpManager when timer is up
		//===============================================================================
		internal function deactivatePUEffectEvt( evt : DataEvent ):void
		{
			trace( "deactivatePUEffectEvt in " + this + " called" );
			
			deactivatePUEffect( );
			
		} // end deactivatePUEffectEvt
		
		//===============================================================================
		// FUNCTION deactivatePUEffect
		//	- called from PowerUpManager when timer is up
		//===============================================================================
		internal function deactivatePUEffect( ):void
		{
			trace( "deactivatePUEffect in " + this + " called" );
			
			mPowerUpManager.mPowerUpActive = false;
			mSamrin.mMaxSpeed = 5;
			mBalthazar.mIsFrozen = false;
			mSamrin.mTwoPetpets = false;
			
		} // end deactivatePUEffect
		
		//===============================================================================
		// FUNCTION removePowerUpsEvt
		//	- dummy function that can be called by dispatching an event
		//	- called from PowerUpManager via Dispatcher
		//===============================================================================
		internal function removePowerUpsEvt( evt : Event ):void
		{
			trace( "removePowerUpsEvt in " + this + " called" );
			
			removePowerUps( );
			
		} // end removePowerUpsEvt
		
		//===============================================================================
		// FUNCTION removePowerUps
		//===============================================================================
		private function removePowerUps( ):void
		{
			trace( "removePowerUps in " + this + " called" );
			
			if( getChildByName( "speed_up_pu" ) != null )
			{
				trace( getChildByName( "speed_up_pu" ) );
				var tSpeedUpPU : PowerUp = getChildByName( "speed_up_pu" ) as PowerUp;
				removeChild( tSpeedUpPU );				
			}
			
			if( getChildByName( "freeze_pu" ) != null )
			{
				trace( getChildByName( "freeze_pu" ) );
				var tFreezePU : PowerUp = getChildByName( "freeze_pu" ) as PowerUp;
				removeChild( tFreezePU );
			}
			
			if( getChildByName( "two_pps_pu" ) != null )
			{
				trace( getChildByName( "two_pps_pu" ) );
				var tTwoPPsPU : PowerUp = getChildByName( "two_pps_pu" ) as PowerUp;
				removeChild( tTwoPPsPU );
			}
			
			if( getChildByName( "waypoint_pu" ) != null )
			{
				trace( getChildByName( "waypoint_pu" ) );
				var tWaypointPU : PowerUp = getChildByName( "waypoint_pu" ) as PowerUp;
				removeChild( tWaypointPU );
			}
			
			mPowerUpManager.mPowerUpOnStage = false;
			
		} // end removePowerUps
				
		//===============================================================================
		// FUNCTION removeGameEvtLisnrsEvt
		//	 - dummy function that can be called by dispatching an event
		//===============================================================================
		internal function removeGameEvtLisnrsEvt( evt : Event ):void
		{
			trace( "removeGameEvtLisnrsEvt in " + this + " called" );
			
			removeGameEvtLisnrs( );
			
		} // end removeGameEvtLisnrsEvt
		
		//===============================================================================
		// FUNCTION removeGameEvtLisnrs
		//===============================================================================
		private function removeGameEvtLisnrs( ):void
		{	
			trace( "removeGameEvtLisnrs in " + this + " called" );
			
			if( mStage.hasEventListener( Event.ENTER_FRAME ) )
			{
				mStage.removeEventListener( Event.ENTER_FRAME, mainOnEnterFrame );
			}
			
			if( Dispatcher.hasEventListener( Scoreboard.END_GAME ) )
			{
				Dispatcher.removeEventListener( Scoreboard.END_GAME, clearGameEvt );
			}
			
			if( Dispatcher.hasEventListener( PowerUpManager.REMOVE_POWER_UP ) )
			{
				Dispatcher.removeEventListener( PowerUpManager.REMOVE_POWER_UP, removePowerUpsEvt );
			}
			
			if( Dispatcher.hasEventListener( PowerUpManager.DEACTIVATE_POWER_UP_EFFECT ) )
			{
				Dispatcher.removeEventListener( PowerUpManager.DEACTIVATE_POWER_UP_EFFECT, deactivatePUEffectEvt );
			}
			
			/**
			 * stop and remove timer in PowerUpManager so that 
			 * it doesn't continue ticking between levels
			 */
			Dispatcher.dispatchEvent( new DataEvent( REMOVE_TIMER ) );
			
			removePowerUps( );
			
		} // end removeGameEvtLisnrs
		
		//===============================================================================
		// FUNCTION addGameLisnrs
		//===============================================================================
		private function addGameLisnrs( ):void
		{	
			trace( "addGameLisnrs in " + this + " called" );
			
			mStage.addEventListener( Event.ENTER_FRAME, mainOnEnterFrame );			
			Dispatcher.addEventListener( Scoreboard.END_GAME, clearGameEvt );
			Dispatcher.addEventListener( PowerUpManager.REMOVE_POWER_UP, removePowerUpsEvt );
			Dispatcher.addEventListener( PowerUpManager.DEACTIVATE_POWER_UP_EFFECT, deactivatePUEffectEvt );
						
		} // end addGameLisnrs
		
		//===============================================================================
		// FUNCTION clearGameEvt
		//	 - dummy function that can be called by dispatching an event
		//===============================================================================
		internal function clearGameEvt( evt : Event ):void
		{
			trace( "clearGameEvt in " + this + " called" );
			
			clearGame( );
			
		} // end clearGameEvt
		
		//===============================================================================
		// FUNCTION clearGame
		//===============================================================================
		private function clearGame( ):void
		{	
			trace( "clearGame in " + this + " called" );
			
			if( mStage.hasEventListener( Event.ENTER_FRAME ) )
			{
				mStage.removeEventListener( Event.ENTER_FRAME, mainOnEnterFrame );
			}
			
			if( Dispatcher.hasEventListener( Scoreboard.END_GAME ) )
			{
				//trace( "Dispatcher.hasEventListener( Scoreboard.END_GAME ) = " + Dispatcher.hasEventListener( Scoreboard.END_GAME ) );
				Dispatcher.removeEventListener( Scoreboard.END_GAME, clearGameEvt );
			}
			
			if( Dispatcher.hasEventListener( NextLevelPopUp.NEXT_LEVEL ) )
			{
				Dispatcher.removeEventListener( NextLevelPopUp.NEXT_LEVEL, setUpNextLevel );
			}
			
			if( Dispatcher.hasEventListener( PowerUpManager.REMOVE_POWER_UP ) )
			{
				Dispatcher.removeEventListener( PowerUpManager.REMOVE_POWER_UP, removePowerUpsEvt );
			}
			
			if( Dispatcher.hasEventListener( PowerUpManager.DEACTIVATE_POWER_UP_EFFECT ) )
			{
				Dispatcher.removeEventListener( PowerUpManager.DEACTIVATE_POWER_UP_EFFECT, deactivatePUEffectEvt );
			}
			
			/**
			 * stop and remove timer in PowerUpManager so that 
			 * it doesn't continue ticking after game is over
			 */
			Dispatcher.dispatchEvent( new DataEvent( REMOVE_TIMER ) );
			
			/**
			 * dispatch event that will trigger cleanUp functions in all
			 * pertinent classes
			 */
			Dispatcher.dispatchEvent( new DataEvent( CLEAR_EVERYTHING ) );
			
			removePowerUps( );
			
		} // end clearGame
		
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mSystem        = GlobalGameReference.mInstance.mGameStartUp.mSystem;
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			mStage 		   = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage;
			
			mKey   		   = new KeyObject( mStage );
			mSamrin 	   = new Hero( 100, 100 );
			mBalthazar     = new Balthazar( );
			
			mLeftBorder    = 0;
			mRightBorder   = mStage.stageWidth;
			mTopBorder     = 70;
			mBottomBorder  = mStage.stageHeight;
			//GameVars.mCurrentScore           = 0;
			
			mLevelManager   = new LevelManager( );
			mPowerUpManager = new PowerUpManager( );
			
			mPetpets        = [ ];		
			mPetpetArrows   = [ ];
			mCarriedPetpets = [ ];
			mPetpetsInPen   = [ ];
			mObstacles      = [ ];
			mHedges         = [ ];
			
		} // end setupVars
		
	} // end class
	
} // end package
