package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// imports
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;

	public class CricketAnimation extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		
		//===============================================================================
		// CONSTRUCTOR Blossoms
		//===============================================================================
		public function CricketAnimation( )
		{
			super( );
			this.stop( );
			
			trace( "CricketAnimation created" );
			
			init( );			
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( ) : void
		{
			if( GameVars.mGameOn )
			{
				var tTimer : Timer = new Timer( 2000, 1 );
				tTimer.addEventListener( TimerEvent.TIMER_COMPLETE, doAnimation, false, 0, true );
				tTimer.start( );
			}
			
		} // end init
		
		//===============================================================================
		// FUNCTION doAnimation
		//===============================================================================
		private function doAnimation( evt : TimerEvent ) : void
		{
			trace( "doAnimation called" );
			
			/*
			/ set GameVars.mCricketAnimOn to true so that space bar won't have effect
			*/
			GameVars.mCricketAnimOn = true;
			
			var tSequenceSwitch : Number = Math.floor( Math.random( ) * 2 );
			
			switch( tSequenceSwitch )
			{
				case 0:	
					trace( "sequence one started" );				
					this.gotoAndPlay( "startFrameOne" );
					break;
				
				case 1:
					trace( "sequence two started" );
					this.gotoAndPlay( "startFrameTwo" );
					break;
			}
			
			this.addEventListener( Event.ENTER_FRAME, checkFrame, false, 0, true );
			
		} // end doAnimation
		
		//===============================================================================
		// FUNCTION checkFrame
		//===============================================================================
		private function checkFrame( evt : Event ):void
		{
			//trace( "checkFrame called" );
			if( GameVars.mGameOn )
			{
				if( this.currentLabel == "endFrameOne" || this.currentLabel == "endFrameTwo" )
				{
					this.stop( );
					
					/*
					/ set GameVars.mCricketAnimOn to false because animation is over and 
					/ space bar has effect again
					*/
					GameVars.mCricketAnimOn = false;
					
					if( this.hasEventListener( Event.ENTER_FRAME ) )
					{
						this.removeEventListener( Event.ENTER_FRAME, checkFrame );
						trace( "checkFrame stopped" );
					}
					
					var tTimer : Timer = new Timer( 4000, 1 );
					tTimer.addEventListener( TimerEvent.TIMER_COMPLETE, backToFirstFrame, false, 0, true );
					tTimer.start( );
				}
			}
			
			else
			{
				clearMe( );
			}
			
		} // end checkFrame
		
		//===============================================================================
		// FUNCTION backToFirstFrame
		//===============================================================================
		private function backToFirstFrame( evt : TimerEvent ):void
		{
			var tTimer : Timer = evt.target as Timer;
			if( tTimer.running )
			{
				tTimer.stop( );
			}
			tTimer = null;
			
			if( GameVars.mGameOn )
			{
				init( );
			}			
			
		} // end backToFirstFrame
		
		//===============================================================================
		// FUNCTION clearMe
		//===============================================================================
		internal function clearMe( ):void
		{
			GameVars.mCricketAnimOn = false;
			this.stop( );
				
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, checkFrame );
			}
			
		} // end clearMe
		
	} // end class
	
} // end package