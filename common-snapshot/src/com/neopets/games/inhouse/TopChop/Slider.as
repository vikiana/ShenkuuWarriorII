package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Slider extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mLevel          : int;
		private var mAngle          : Number;// = 0;
		private var mSlidingTop     : Number = GameVars.mMeter.y + 6;
		private var mSlidingBottom  : Number = GameVars.mMeter.y + ( GameVars.mMeter.height - 6 );
		private var mSlidingRange   : Number = GameVars.mMeter.height / 2 - 5;
		private var mSlidingCenter  : Number = GameVars.mMeter.y + ( GameVars.mMeter.height / 2 );
		private var mSliderSpeed    : Number;
		private var mSliderMinSpeed : Number;
		private var mSliderMaxSpeed : Number;
		private var mTime           : Number;
		
		//===============================================================================
		// CONSTRUCTOR Slider
		//===============================================================================
		public function Slider( )
		{
			super( );
			this.height = 3;
			this.width = GameVars.mMeter.width;
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( pSliderX : Number ):void
		{
			trace( "init in Slider called" );
			trace( "make slider behave according to level " + GameVars.mCurrentStage );
						
			/*
			/ randomize the starting position of the slider
			*/
			mAngle = Math.random( ) - Math.random( );
			
			switch( GameVars.mCurrentStage )
			{
				case 1:
				case 4:
				case 8:
					mSliderSpeed    = .5;//2;//.5;//
					mSliderMinSpeed = mSliderSpeed - .2;
					mSliderMaxSpeed = mSliderSpeed + 2;
					break;
				
				case 2:
				case 5:
				case 9:
					mSliderSpeed    = .5;//3;
					mSliderMinSpeed = mSliderSpeed - .2;
					mSliderMaxSpeed = mSliderSpeed + 2;
					break;
					
				case 3:
				case 6:
				case 10:
					mSliderSpeed    = .5;//4;
					mSliderMinSpeed = mSliderSpeed - .2;
					mSliderMaxSpeed = mSliderSpeed + 2;
					break;
				
				case 7:
				case 11:
					mSliderSpeed    = .5;
					mSliderMinSpeed = mSliderSpeed - .2;
					mSliderMaxSpeed = mSliderSpeed + 2;
					break;
				
				case 12:
				case 13:
					mSliderSpeed    = .5;//6;
					mSliderMinSpeed = mSliderSpeed - .2;
					mSliderMaxSpeed = mSliderSpeed + 2;
					break;				
			}
			
			this.x = pSliderX;
			mTime = getTimer( );
			this.addEventListener( Event.ENTER_FRAME, onSliderMove, false, 0, true );
			
		} // end init
		
		//===============================================================================
		// FUNCTION onSliderMove
		//===============================================================================
		internal function onSliderMove( evt : Event ):void
		{
			//trace( "onSliderMove in Slider called" );
			
			var tElapsedTime : Number = getTimer( ) - mTime;
			
			mTime = getTimer( );
			this.y = mSlidingCenter + Math.sin( mAngle ) * mSlidingRange;
			mAngle += mSliderSpeed * tElapsedTime / 1000;
			
			if( GameVars.mCurrentStage > 3 )
			{				
				//randomizeSpeed( );
				
				if( GameVars.mGameOn )
				{
					//stutterSlider( );					
				}
			}	
			
		} // end onSliderMove
		
		//===============================================================================
		// FUNCTION randomizeSpeed
		//===============================================================================
		internal function randomizeSpeed( ):void
		{		
			if( this.y <= mSlidingTop)
			{
				trace( "hit top" );
				mSliderSpeed = mSliderSpeed + ( ( Math.random( ) * 7 ) - ( Math.random( ) * 7 ) );
			}
			
			if( this.y >= mSlidingBottom)
			{
				//trace( "hit bottom" );
				mSliderSpeed = mSliderSpeed + ( ( Math.random( ) * 7 ) - ( Math.random( ) * 7 ) );
			}
			
			if( mSliderSpeed < mSliderMinSpeed )
			{
				mSliderSpeed = mSliderMinSpeed;
			}
			
			if( mSliderSpeed > mSliderMaxSpeed )
			{
				mSliderSpeed = mSliderMaxSpeed;
			}
			
		} // end randomizeSpeed
		
		//===============================================================================
		// FUNCTION stutterSlider
		//===============================================================================
		internal function stutterSlider( ):void
		{
			var tStutterChance : Number = Math.floor( Math.random( ) * 100 );
			trace( "tStutterChance: " + tStutterChance );
			
			if( tStutterChance > 98 )
			{
				this.removeEventListener( Event.ENTER_FRAME, onSliderMove );
				var tTimer : Timer = new Timer( 500, 1 );
				tTimer.addEventListener( TimerEvent.TIMER_COMPLETE, restartSlider, false, 0, true );
				tTimer.start( );
			}
			
		} // end stutterSlider
		
		//===============================================================================
		// FUNCTION restartSlider
		//===============================================================================
		internal function restartSlider( evt : TimerEvent ):void
		{
			var tTimer : Timer = evt.target as Timer;
			if( tTimer.running )
			{
				tTimer.stop( );
			}
			tTimer = null;
			
			/*
			/ only re-attach event listener and resume animation if GameVars.mGameOn is 
			/ true, otherwise game is over or in transition
			*/
			if( GameVars.mGameOn )
			{			
				trace( "resumeAnimation" );
				mTime = getTimer( );
				this.addEventListener( Event.ENTER_FRAME, onSliderMove, false, 0, true );
			}
						
		} // end restartSlider
		
		//===============================================================================
		// FUNCTION stopSlider
		//===============================================================================
		internal function stopSlider( ):void
		{
			trace( "stopSlider in Slider called" );
						
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, onSliderMove );
			}
			
			//trace( "this.y: " + this.y + " - GameVars.mMeter.y: " +  GameVars.mMeter.y + " = " + ( this.y - GameVars.mMeter.y ) );
			GameVars.mStoppedSliderLocation = Math.round( this.y - GameVars.mMeter.y );
						
			//trace( "slider stopped at: " + GameVars.mStoppedSliderLocation );
			
		} // end stopSlider
		
		//===============================================================================
		// FUNCTION updateSliderSpeed
		//===============================================================================
		internal function updateSliderSpeed( ):void
		{
			trace( "updateSliderSpeed in Slider called" );
			mSliderSpeed    = 1;
			mSliderMinSpeed = mSliderSpeed - .2;
			mSliderMaxSpeed = mSliderSpeed + .2;
						
		} // end updateSliderSpeed
		
		//===============================================================================
		// FUNCTION removeMe
		//===============================================================================
		internal function removeMe( ):void
		{
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, onSliderMove );
			}
		
		} // end removeMe
				
	} // end class
	
} // end package