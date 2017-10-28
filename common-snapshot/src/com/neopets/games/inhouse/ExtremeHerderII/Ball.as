package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import behaviors.Vector2D;
	
	import flash.display.MovieClip;
	
	public class Ball extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mColor  : int;
		public var mVelX    : Number = 0;
		public var mVelY    : Number = 0;
		public var mMass    : Number = 1;
		
		//=======================================
		// getter vars
		//=======================================
		private var gRadius : Number;
		
		//===============================================================================
		// CONSTRUCTOR Countdown
		//===============================================================================
		public function Ball( pRadius : Number = 40, pColor : int = 0xff0000 )
		{
			//trace( "Ball" );
			
			this.gRadius = pRadius;
			this.mColor  = pColor;
			init( );
						
		}
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		private function init( ):void
		{
			//trace( "init" );
			
			graphics.beginFill( mColor );
			graphics.drawCircle( 0, 0, mRadius );
			graphics.endFill( );
						
		}
		
		public function get mRadius( ):Number { return gRadius };
		public function get mPosition( ):Vector2D { return new Vector2D( x, y ) };

	} // end class
	
} // end package