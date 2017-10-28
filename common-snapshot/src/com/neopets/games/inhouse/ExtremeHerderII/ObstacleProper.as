package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	public class ObstacleProper extends MovieClip//Obstacle
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		
		//=======================================
		// getter vars
		//=======================================
		var gType    : String;
		var gCollDet : Sprite;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		private function get mType( ):String { return gType };
		private function set mType( str : String ):void { gType = str };
		
		private function get mCollDet( ):Sprite { return gCollDet };
		private function set mCollDet( spr : Sprite ):void { gCollDet = spr };
		
		//===============================================================================
		// CONSTRUCTOR Countdown
		//===============================================================================
		public function ObstacleProper( pType : String )
		{
			mType = pType;
			
			setupVars( );
			draw( );
						
		} // end constructor
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		private function draw( ):void
		{
			switch( mType )
			{
				case "Puddle":
					trace( "create puddle" );
					var tPuddleClass : Class = mAssetLocation.getDefinition( "ObstaclePuddle" ) as Class;						
					var tPuddle : MovieClip = new tPuddleClass( );
					addChild( tPuddle );									
					break;
					
				case "Boulder":
					trace( "create boulder" );
					var tBoulderClass : Class = mAssetLocation.getDefinition( "ObstacleBoulder" ) as Class;						
					var tBoulder : MovieClip = new tBoulderClass( );
					addChild( tBoulder );
					break;
					
				default:
					trace( this + " says: obstacle type not found" );
			}
						
		} // end draw
		
		//===============================================================================
		// FUNCTION setupVars
		//===============================================================================
		private function setupVars( ):void
		{
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
		} // end setupVars

	} // end class
	
} // end package