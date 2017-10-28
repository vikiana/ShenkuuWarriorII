package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Blossoms extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		
		//===============================================================================
		// CONSTRUCTOR Blossoms
		//===============================================================================
		public function Blossoms( )
		{
			super( );
			
			trace( "Blossoms created" );
			doAnimation( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION doAnimation
		//===============================================================================
		private function doAnimation( ) : void
		{
			this.gotoAndPlay( "startFrame" );
			this.addEventListener( Event.ENTER_FRAME, checkFrame, false, 0, true );
			
		} // end doAnimation
		
		//===============================================================================
		// FUNCTION checkFrame
		//===============================================================================
		private function checkFrame( evt : Event ):void
		{
			if( this.currentLabel == "endFrame" )
			{
				this.stop( );
				
				if( this.hasEventListener( Event.ENTER_FRAME ) )
				{
					this.removeEventListener( Event.ENTER_FRAME, checkFrame );
				}
				
				var tTimer : Timer = new Timer( 4000, 1 );
				tTimer.addEventListener( TimerEvent.TIMER_COMPLETE, backToFirstFrame, false, 0, true );
				tTimer.start( );
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
			
			/*
			/ at this point, blossoms are offscreen. might be between stages or when game is over
			/ so only resume animation when game is on
			*/
			if( GameVars.mGameOn )
			{
				doAnimation( );
			}
			
		} // end backToFirstFrame
		
		//===============================================================================
		// FUNCTION clearMe
		//===============================================================================
		internal function clearMe( ):void
		{
			this.stop( );
				
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, checkFrame );
			}
			
		} // end clearMe
		
	} // end class
	
} // end package