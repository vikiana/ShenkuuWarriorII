package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.getTimer;

	public class Meter extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mLevel            : int;
		private var mAngle            : Number;
		private var mSafeZoneRange    : Number;
		private var mMeterCenterPoint : Number;
		private var mSafeZoneSpeed    : Number = 1;
		private var mTime             : Number;
		
		//===============================================================================
		// CONSTRUCTOR Meter
		//===============================================================================
		public function Meter( )
		{
			super( );
			
			this.width  = 15;//16;
			//this.height = 165;
			//this.scaleY = 1.05;
			
			trace( "this.height: " + this.height );
			trace( "this.width: " + this.width );
				
			GameVars.mSafeZone      = new SafeZone( );
			GameVars.mSuperSafeZone = new SuperSafeZone( );		
			
			mAngle = GameVars.mSafeZone.y;
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( pMeterX : Number, pMeterY : Number ):void
		{
			trace( "init in Meter called" );
			trace( "make meter behave according to level " + GameVars.mCurrentStage );
			
			this.x = pMeterX;
			this.y = pMeterY;
					
			trace( "this.x: " + this.x );
			trace( "this.y: " + this.y );			
			switch( GameVars.mCurrentStage )
			{
				case 1:
				case 2:
				case 3:
					GameVars.mSafeZone.mGreenZone.height = 40;				
					break;
				 
				case 4:
				case 5:
				case 6:
				case 7:
					GameVars.mSafeZone.mGreenZone.height = 30;
					break;
				
				case 8:
				case 9:
				case 10:
				case 11:
				case 12:
					GameVars.mSafeZone.mGreenZone.height = 20;
					break;
				
			}
			//trace( "break test" );
					
			GameVars.mSafeZone.x = 0;
			GameVars.mSafeZone.y = this.height / 2 - GameVars.mSafeZone.mGreenZone.height / 2 ;
			this.addChild( GameVars.mSafeZone );

			GameVars.mSuperSafeZone.x = 0;
			GameVars.mSuperSafeZone.y = GameVars.mSafeZone.mGreenZone.height / 2 - GameVars.mSuperSafeZone.height / 2;
			GameVars.mSafeZone.addChild( GameVars.mSuperSafeZone );	
			
			GameVars.mSafeZoneOffset = GameVars.mSafeZone.height / 2;			
			mSafeZoneRange           = this.height / 2 - GameVars.mSafeZoneOffset - 5;
			mMeterCenterPoint        = this.height / 2;
			
			if( GameVars.mCurrentStage == 8 || GameVars.mCurrentStage == 9 || GameVars.mCurrentStage == 10 || GameVars.mCurrentStage == 11 || GameVars.mCurrentStage == 12 || GameVars.mCurrentStage == 13 )
			{
				//animateSafeZone( );
			}
			
		} // end init
		
		//===============================================================================
		// FUNCTION animateSafeZone
		//===============================================================================
		internal function animateSafeZone( ):void
		{
			mTime = getTimer( );
			GameVars.mSafeZone.addEventListener( Event.ENTER_FRAME, moveSafeZone, false, 0, true );		
			
		} // end animateSafeZone
		
		//===============================================================================
		// FUNCTION moveSafeZone
		//===============================================================================
		internal function moveSafeZone( evt : Event ):void
		{
			//trace( "moveSafeZone in Meter called" );
			
			var tElapsedTime : Number = getTimer( ) - mTime;
			
			mTime = getTimer( );
			GameVars.mSafeZone.y = mMeterCenterPoint + Math.sin( mAngle ) * mSafeZoneRange - GameVars.mSafeZoneOffset;
			mAngle += mSafeZoneSpeed * tElapsedTime / 1000;		
			
		} // end moveSafeZone
		
		//===============================================================================
		// FUNCTION stopSafeZone
		//===============================================================================
		internal function stopSafeZone( ):void
		{
			trace( "stopSafeZone in Meter called" );
						
			if( GameVars.mSafeZone.hasEventListener( Event.ENTER_FRAME ) )
			{
				GameVars.mSafeZone.removeEventListener( Event.ENTER_FRAME, moveSafeZone );
			}
			
			/*
			/ calculate y coordinate of center of safe zone
			*/
			GameVars.mStoppedSafeZoneLocation = Math.round( GameVars.mSafeZone.y  + GameVars.mSafeZone.height / 2 );
			
			//trace( "Math.round( GameVars.mSafeZone.y ): " + Math.round( GameVars.mSafeZone.y ) );
			
		} // end stopSafeZone
		
		//===============================================================================
		// FUNCTION updateSafeZoneSize
		//	- called from Scoreboard when player clicks GameVars.mPowerUpTwo
		//===============================================================================
		internal function updateSafeZoneSize( ):void
		{
			var tGreenZoneIncrease : int = GameVars.mSafeZone.mGreenZone.height / 2;
			
			GameVars.mSafeZone.mGreenZone.height += tGreenZoneIncrease;
			GameVars.mSafeZone.y = GameVars.mSafeZone.y - tGreenZoneIncrease / 2;
			GameVars.mSuperSafeZone.y = GameVars.mSafeZone.mGreenZone.height / 2 - GameVars.mSuperSafeZone.height / 2;
		
		} // end updateSafeZoneSize
		
		//===============================================================================
		// FUNCTION removeMe
		//===============================================================================
		internal function removeMe( ):void
		{
			if( GameVars.mSafeZone.hasEventListener( Event.ENTER_FRAME ) )
			{
				GameVars.mSafeZone.removeEventListener( Event.ENTER_FRAME, moveSafeZone );
			}
		
		} // end removeMe
			
	} // end class
	
} // end package