package com.neopets.games.inhouse.TopChop
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;	
	import flash.text.TextFormat;

	public class TimeDisplay extends MovieClip
	{		
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		
		/*
		/ default string displayed
		*/
		public static const TIME_UP_STRING : String = "00";//"00:00";
		
		/*
		/ Number of seconds left.
		*/
		public function get mSecondsLeft( ) : int { return gSecondsLeft };
		public function set mSecondsLeft( num : int ) : void { gSecondsLeft = num };		
		private var gSecondsLeft : int;		
		
		//public  var time_txt     : TextField; // textfield for display of time				
		private var mTimer       : Timer;	
		private var mTimeLimitMS : int;	  // time limit in miliseconds
		private var mStartTime   : int;
		
		
		//===============================================================================
		// CONSTRUCTOR TimeDisplay
		//===============================================================================
		public function TimeDisplay( pFont  : String = "Times",
									 pAlign : String = "center",
									 pColor : int   = 0x000000,
									 pSize  : int   = 20,
									 pXpos  : int    = 0,
									 pYpos  : int    = 0 )
		{					
 			var tFormat:TextFormat = new TextFormat( );
			
            tFormat.font  = pFont;
			tFormat.align = pAlign;
            tFormat.color = pColor;
            tFormat.size  = pSize;
			
			//time_txt = new TextField( );
			
			time_txt.x = pXpos;
			time_txt.y = pYpos;
			time_txt.selectable = false;
			time_txt.defaultTextFormat = tFormat;
			addChild( time_txt );
			time_txt.text = "";
						
		} // end constructor
		
		//===============================================================================
		// FUNCTION init( ): 
		//          - initializes the timer display
		//===============================================================================
		public function init( pTimeLimitMS : int ) : void
		{
			mTimeLimitMS  = pTimeLimitMS;
			time_txt.text = formatTime( mTimeLimitMS );
			
		} // end init
		
		//===============================================================================
		// FUNCTION startTimer( ): 
		//          - starts the timer
		//===============================================================================
		public function startTimer ( ) : void
		{
			mStartTime = getTimer( );
			
			var tInterval : uint = 60;
			var tRepeat   : Number = Math.floor( mTimeLimitMS / tInterval );
			mTimer = new Timer( tInterval, tRepeat );
			mTimer.addEventListener( TimerEvent.TIMER, onTimer );
			mTimer.start( );
			
		} // end startTimer
		
		//===============================================================================
		// FUNCTION stopTimer( ): 
		//          - stops the timer
		//===============================================================================
		public function stopTimer ( ) : void
		{
			mTimer.stop( );
			trace( "timer stopped" );
			
		} // stopTimer
		
		//===============================================================================
		// FUNCTION formatTime( ): 
		//          - formats the time left like "mm:ss"
		//===============================================================================
		private function formatTime( pTimeLeft : Number ) : String
		{
			var tStr : String = "";
			
			// min : seconds
			var tSeconds : uint = Math.floor( pTimeLeft / 1000 );
			//var tMinutes : uint =  Math.floor( tSeconds / 60 );
			
			//tSeconds -= tMinutes * 60;
			
			//var tMinutesStr : String = String( tMinutes );
			//if( tMinutesStr.length == 1 )
			//{
				//tMinutesStr = "0" + tMinutesStr;
			//}
			
			var tSecondsStr : String = String( tSeconds );
			if( tSecondsStr.length == 1 )
			{
				tSecondsStr = "0" + tSecondsStr;
			}
			
			tStr = /* tMinutesStr + ":" + */tSecondsStr;
			return tStr;
			
		} // end formatTime
		
		//===============================================================================
		// FUNCTION onTimer( ): 
		//          - handles the TimerEvent.TIMER event
		//===============================================================================
		private function onTimer( evt : TimerEvent ) : void
		{
			// add secondsLeft getter 
			var elapsed  : Number = getTimer( ) - mStartTime;
			var timeLeft : Number = mTimeLimitMS - elapsed;
			mSecondsLeft = Math.floor( timeLeft / 1000 );
			
			if( timeLeft <= 0 )
			{				
				timeLeft = 0;
				time_txt.text = TIME_UP_STRING;
				
				var evt : TimerEvent = new TimerEvent( TimerEvent.TIMER_COMPLETE );
				dispatchEvent ( evt );
				
				stopTimer( );				
			}
			
			else
			{
				//var str : String = formatTime( timeLeft );
				// update the time left
				time_txt.text = formatTime( timeLeft );
			}
			
		} // end onTimer
		
	} // end class
	
} // end package
