package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;

	public class Background extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		private var mKey           : KeyObject;
		
		//=======================================
		// getter vars
		//=======================================
		private var gBGMC : MovieClip;
		
		//===============================================================================
		// CONSTRUCTOR Background
		//===============================================================================
		public function Background( )
		{
			//trace( "Hero in " + this + " called" );
			
			//mStage = pStage;
			//this.x = pX;
			//this.y = pY
			cacheAsBitmap = true;
			setupVars( );
			init( );
			
		} // end constructor
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( ):void
		{
			var tBGClass : Class = mAssetLocation.getDefinition( "Background" ) as Class;
			gBGMC = new tBGClass( );
			gBGMC.cacheAsBitmap = true;
			this.addChild( gBGMC );
			
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
