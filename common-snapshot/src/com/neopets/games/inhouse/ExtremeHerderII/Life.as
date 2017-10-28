package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
		
	import behaviors.*;
	
	public class Life extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		//private var mAssetLocation : ApplicationDomain;
		//private var mStage         : Stage;
		//private var mBalthazarMC   : MovieClip;
		//private var tIsWalking     : String;
		
		//=======================================
		// getter vars
		//=======================================
		
		//===============================================================================
		// CONSTRUCTOR Live
		//===============================================================================
		public function Life( )
		{
			//trace( "Balthazar in " + this + " called" );
			
			//setupVars( );
			draw( );
			
		} // end constructor	
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		private function draw( ):void
		{			
			graphics.beginFill( 0xffffff, 1 );
			graphics.drawCircle( 0, 0, 5 );
			graphics.endFill( );
			
		} // end draw
		
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		 private function setupVars( ):void
		{
			//mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
		} // end setupVars
		
	} // end class
	
} // end package