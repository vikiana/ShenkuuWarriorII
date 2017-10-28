package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
			
	public class PowerUp extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		
		//=======================================
		// getter vars
		//=======================================
		private var gSpeedUp  : MovieClip;
		private var gFreeze   : MovieClip;
		private var gTwoPPs   : MovieClip;
		private var gWaypoint : MovieClip;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		public function set mSpeedUp( pValue : MovieClip ):void { gSpeedUp = pValue };
		public function get mSpeedUp( ):MovieClip { return gSpeedUp };
		
		public function set mFreeze( pValue : MovieClip ):void { gFreeze = pValue };
		public function get mFreeze( ):MovieClip { return gFreeze };
		
		public function set mTwoPPs( pValue : MovieClip ):void { gTwoPPs = pValue };
		public function get mTwoPPs( ):MovieClip { return gTwoPPs };
		
		public function set mWaypoint( pValue : MovieClip ):void { gWaypoint = pValue };
		public function get mWaypoint( ):MovieClip { return gWaypoint };
		
		//===============================================================================
		// CONSTRUCTOR Live
		//===============================================================================
		public function PowerUp( pPowerUpKind : String )
		{
			trace( "PowerUp in " + this + " called" );
			
			switch( pPowerUpKind )
			{
				case "SpeedUp":
					draw( "SpeedUp" );
					break;
					
				case "Freeze":
					draw( "Freeze" );
					break;
					
				case "TwoPPs":
					draw( "TwoPPs" );
					break;
					
				case "Waypoint":
					draw( "Waypoint" );
					break;
								
				default:
					break;
			}
			
			
			//setupVars( );
			//draw( );
			
		} // end constructor	
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		private function draw( pPowerUpKind : String ):void
		{
			trace( "draw in " + this + " called" );
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			switch( pPowerUpKind )
			{
				case "SpeedUp":
					var tPUClass1 : Class = tAssetLocation.getDefinition( "PowerUpSpeedUp" ) as Class;
					mSpeedUp = new tPUClass1( );
					mSpeedUp.stop( );
					addChild( mSpeedUp );
					break;
					
				case "Freeze":
					var tPUClass2 : Class = tAssetLocation.getDefinition( "PowerUpFreeze" ) as Class;
					mFreeze = new tPUClass2( );
					mFreeze.stop( );
					addChild( mFreeze );
					break;
					
				case "TwoPPs":
					var tPUClass3 : Class = tAssetLocation.getDefinition( "PowerUpTwoPPs" ) as Class;
					mTwoPPs = new tPUClass3( );
					mTwoPPs.stop( );
					addChild( mTwoPPs );
					break;
					
				case "Waypoint":
					var tPUClass4 : Class = tAssetLocation.getDefinition( "PowerUpWaypoint" ) as Class;
					mWaypoint = new tPUClass4( );
					mWaypoint.stop( );
					addChild( mWaypoint );
					break;
				
				default:
					break;
			}
			
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