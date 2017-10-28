package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
		
	import behaviors.*;

	public class DirArrow extends MovingObject //MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		private var mDirArrow      : DirArrow;
		private var mSteeringForce : Vector2D;
		private var mAvoidDist     : Number = 200;
		private var mAvoidBuffer   : Number = 10;
		
		//=======================================
		// getter vars
		//=======================================
		private var gInitPos       : String;
		
		//=======================================
		//	everything waypoint
		//=======================================
		private var gPathIndex     : int = 0;
		private var gPathThreshold : Number = 10;
		private var gHasWaypoint   : Boolean;
		private var gTargetsPetpet : Boolean;
		private var gTarget        : Array = [ ];
		private var gPath          : Array = [ ];
		
		//=======================================
		// steering test
		//=======================================
		private var gMaxForce      : Number = .5;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================		
		public function set mMaxForce( pValue : Number ):void { gMaxForce = pValue };
		public function get mMaxForce( ):Number { return gMaxForce };
		
		public function set mInitPos( pString : String ):void { gInitPos = pString };
		public function get mInitPos( ):String { return gInitPos };
		
		public function set mPathIndex( pValue : int ):void { gPathIndex = pValue };
		public function get mPathIndex( ): int { return gPathIndex };
		
		public function set mPathThreshold( pValue : Number ):void { gPathThreshold = pValue };
		public function get mPathThreshold( ): Number { return gPathThreshold };
		
		public function set mHasWaypoint( pValue : Boolean ):void { gHasWaypoint = pValue };
		public function get mHasWaypoint( ): Boolean { return gHasWaypoint };
		
		public function set mHasTarget( pValue : Boolean ):void { gTargetsPetpet = pValue };
		public function get mHasTarget( ): Boolean { return gTargetsPetpet };
		
		public function set mTarget( pValue : Array ):void { gTarget = pValue };
		public function get mTarget( ):Array { return gTarget };
		
		public function set mPath( pValue : Array ):void { gPath = pValue };
		public function get mPath( ):Array { return gPath };
		
		//===============================================================================
		// CONSTRUCTOR DirArrow
		//===============================================================================
		public function DirArrow( /*pStage : Stage*/ )
		{
			//trace( "Balthazar in " + this + " called" );
			
			//mStage = pStage;
			
			setupVars( );
			
			mSteeringForce = new Vector2D( );
			super( );
			
		} // end constructor
		
		//===============================================================================
		// 	FUNCTION update
		//===============================================================================
		override public function update( ):void
		{
			mSteeringForce.truncate( mMaxForce );
			mSteeringForce = mSteeringForce.divide( mMass );
			mVelocity = mVelocity.add( mSteeringForce );
			mSteeringForce = new Vector2D( );
			super.update( );
			
		} // end update
		
		//===============================================================================
		// 	FUNCTION seek
		//===============================================================================
		public function seek( pTarget : Vector2D ):void
		{
			var tDesiredVel : Vector2D = pTarget.subtract( mPosition );
			tDesiredVel.normalize( );
			tDesiredVel = tDesiredVel.multiply( mMaxSpeed );
			var tForce : Vector2D = tDesiredVel.subtract( mVelocity );
			mSteeringForce = mSteeringForce.add( tForce );
			
		} // end seek
		
		//===============================================================================
		// 	FUNCTION followPath
		//===============================================================================
		public function followPath( pPath : Array, pRandomWaypoints : Boolean = false, pLoop : Boolean = false ):void
		{
			//trace( "mPathIndex: " + mPathIndex );
			//trace( "pPath.length: " + pPath.length );
			
			/**
			 * get the waypoint (vector) at mPathIndex index of the 
			 * array that was passed in
			 */
			var tWayPoint : Vector2D = pPath[ mPathIndex ];
			
			if( tWayPoint == null ) return;
			
			/**
			 * check if distance of MovingObject (this) to obstacle is smaller 
			 * than the specified threshold
			 */
			if( mPosition.dist( tWayPoint ) < mPathThreshold )
			{
				//trace( "mPosition.dist( tWayPoint ) < mPathThreshold" );
				
				/**
				 * check if the mPathIndex is greater than or equal to the 
				 * last waypoint in the array, i.e. check if last
				 * waypoint was reached
				 */
				if( mPathIndex >= pPath.length - 1 )
				{
					//trace( "arrived at waypoint" );
					//trace( "mPathIndex: " + mPathIndex );
					//trace( "pPath.length - 1: " + pPath.length /- 1 );
					
					/**
					 * check if path finding is set to pRandomWaypoints, i.e. if a random waypoint is
					 * assigned after previous waypoint was reached
					 * if true, set mHasTarget and mHasWaypoint to false so that new way point will be assigned in main class
					 * and set mTarget.length and mPath.length to 0 so that new waypoint is assigned to array index 0
					 */
					if( pRandomWaypoints )
					{
						mHasTarget = false;
						mHasWaypoint = false;
						mTarget.length = 0;
						mPath.length = 0;
					}
					
					if( pLoop )
					{
						mPathIndex = 0;
					}
				}
				
				else
				{
					mPathIndex++;
				}
			}
			
			if( mPathIndex >= pPath.length - 1 && !pRandomWaypoints && !pLoop )
			{
				trace( this + "says: i arrived" );
			}
			
			else
			{
				//trace( "seeking" );
				seek( tWayPoint );
			}
			
		} // end followPath
		
		//===============================================================================
		// FUNCTION reset
		//===============================================================================
		public function reset( ):void
		{
			mSteeringForce = new Vector2D( );
			mVelocity      = new Vector2D( );
			mPathIndex     = 0;
			
		} // end reset
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		override protected function draw( ):void
		{			
			graphics.lineStyle( 1, 0xffffff, 1 );
			graphics.beginFill( 0xffff00 );
			graphics.moveTo( - 15, - 5 );
			graphics.lineTo( 0, -5 );
			graphics.lineTo( 0, -15 );
			graphics.lineTo( 15, 0 );
			graphics.lineTo( 0, 15 );
			graphics.lineTo( 0, 5 );
			graphics.lineTo( -15, 5 );
			graphics.lineTo( -15, -5 );
			graphics.endFill( );
			
		} // end draw
		
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		 private function setupVars( ):void
		{
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
		} // end setupVars
		
	} // end class
	
} // end package
