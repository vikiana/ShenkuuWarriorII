package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================	
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	public class Pen extends Obstacle
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		
		//=======================================
		// getter vars
		//=======================================
		private var gPenMC : MovieClip;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================	
		public function get mPenMC( ):MovieClip { return gPenMC };
		public function set mPenMC( mc : MovieClip ):void { gPenMC = mc };
		
		//===============================================================================
		// CONSTRUCTOR Countdown
		//===============================================================================
		public function Pen( )
		{
			setupVars( );
			draw( );
						
		} // end constructor
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		private function draw( ):void
		{
			//trace( "draw in " + this + " called" );
			
			var tPenClass : Class = mAssetLocation.getDefinition( "Pen" ) as Class;
			mPenMC = new tPenClass( );
			this.addChild( mPenMC );
						
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