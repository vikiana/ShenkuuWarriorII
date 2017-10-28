package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	
	import behaviors.Vector2D;	
	
	public class Obstacle extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mBufferZone : int = 30;
		
		//=======================================
		// getter vars
		//=======================================
		private var gRadius   : Number;
		private var gTRCorner : Vector2D;
		private var gBRCorner : Vector2D;
		private var gBLCorner : Vector2D;
		private var gTLCorner : Vector2D;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================		
		public function get mPosition( ):Vector2D { return new Vector2D( x, y ) };
		public function get mTRCorner( ):Vector2D 
		{
			var tX = this.x + this.width * .5 + mBufferZone;
			var tY = this.y - this.height * .5 - mBufferZone;
			return new Vector2D( tX, tY );
		}
		
		public function get mBRCorner( ):Vector2D 
		{
			var tX = this.x + this.width * .5 + mBufferZone;
			var tY = this.y + this.height * .5 + mBufferZone;
			return new Vector2D( tX, tY );
		}
		
		public function get mBLCorner( ):Vector2D 
		{
			var tX = this.x - this.width * .5 - mBufferZone;
			var tY = this.y + this.height * .5 + mBufferZone;
			return new Vector2D( tX, tY );
		}
		
		public function get mTLCorner( ):Vector2D 
		{
			var tX = this.x - this.width * .5 - mBufferZone;
			var tY = this.y - this.height * .5 - mBufferZone;
			return new Vector2D( tX, tY );
		}
		
		//===============================================================================
		// CONSTRUCTOR Obstacle
		//===============================================================================
		public function Obstacle( )
		{
			//setupVars( );
			//init( );
						
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		private function init( ):void
		{
						
		} // end init
		
		//===============================================================================
		// FUNCTION setupVars
		//===============================================================================
		private function setupVars( ):void
		{
			
		} // end setupVars

	} // end class
	
} // end package