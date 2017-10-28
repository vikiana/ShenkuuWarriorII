package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================	
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	import behaviors.Vector2D;
	
	public class Hedge extends Obstacle
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		
		//=======================================
		// getter vars
		//=======================================
		//private var gRadius : Number;
		
		//===============================================================================
		// CONSTRUCTOR Countdown
		//===============================================================================
		public function Hedge( )
		{
			setupVars( );
			init( );
						
		}
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		private function init( ):void
		{
			//trace( "init" );
			
			var tHedgeClass : Class = mAssetLocation.getDefinition( "Hedge" ) as Class;
			var tHedge      : MovieClip = new tHedgeClass( );
			this.addChild( tHedge );
						
		} // end init
				
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