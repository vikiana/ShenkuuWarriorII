package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	
	public class LevelManager extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		
		//=======================================
		// getter vars
		//=======================================
		private var gLevel          : int;
		private var gPetpetsInLevel : int;
		private var gBorderHedges   : Array;
		private var gPetpetArrows   : Array;
		private var gPetpets        : Array;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		public function set mLevel( pValue : int ):void { gLevel = pValue };
		public function get mLevel( ):int { return gLevel };
		
		public function set mPetpetsInLevel( pValue : int ):void { gPetpetsInLevel = pValue };
		public function get mPetpetsInLevel( ):int { return gPetpetsInLevel };
		
		public function set mBorderHedges( pValue : Array ):void { gBorderHedges = pValue };
		public function get mBorderHedges( ):Array { return gBorderHedges };
		
		public function set mPetpetArrows( pValue : Array ):void { gPetpetArrows = pValue };
		public function get mPetpetArrows( ):Array { return gPetpetArrows };
		
		public function set mPetpets( pValue : Array ):void { gPetpets = pValue };
		public function get mPetpets( ):Array { return gPetpets };
		
		//===============================================================================
		// CONSTRUCTOR LevelManager
		//===============================================================================
		public function LevelManager( )
		{
			setupVars( );
			//init( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION update
		//===============================================================================
		internal function update( ):void
		{
			trace( "init in " + this + " called" );
			
			/**
			 * set mPetpetsInLevel based on mLevel
			 */
			switch( mLevel )
			{
				case 1:
				case 2:
				case 3:
					mPetpetsInLevel = 4;
					break;
				
				case 4:
				case 5:
				case 6:
					mPetpetsInLevel = 5;
					break;
					
				case 7:
				case 8:
				case 9:
					mPetpetsInLevel = 6;
					break;
					
				case 10:
				case 11:
				case 12:
					mPetpetsInLevel = 7;
					break;
					
				case 13:
				case 14:
				case 15:
					mPetpetsInLevel = 8;
					break;
					
				case 16:
				case 17:
				case 18:
				case 19:
				case 20:
					mPetpetsInLevel = 10;
					break;
					
				default:
					break;
			}
			
			//=======================================
			// petpets
			//=======================================
			for( var i : int = 0; i < mPetpetsInLevel; i++ )
			{
				var tPetpetArrow : DirArrow = new DirArrow( );
				mPetpetArrows[ mPetpetArrows.length ] = tPetpetArrow;
				
				var tPetpet : Petpet = new Petpet( );
				mPetpets[ mPetpets.length ] = tPetpet;
			}
			
			//=======================================
			// hedges
			//======================================= 
			for( var j : int = 0; j < 33; j++ )
			{
				var tHedge : Hedge = new Hedge( );
				tHedge.name = "hedge" + j;
				
				switch( j )
				{
					/**
					 * upper left corner
					 */
					case 0:
						tHedge.y = 80;
						tHedge.rotation = -45;
						break;
						
					case 1:
						tHedge.x = 80;
						tHedge.y = 60;
						break;
						
					case 2:
						tHedge.x = 160;
						tHedge.y = 60;
						break;
						
					case 3:
						tHedge.x = 240;
						tHedge.y = 60;
						break;
						
					/**
					 * upper center
					 */
					case 4:
						if( mLevel > 3 )
						{						
							tHedge.x = mStage.stageWidth * .5;
							tHedge.y = 60;
						}
						break;
						
					case 5:
						tHedge.x = 410;
						tHedge.y = 60;
						break;
						
					case 6:
						tHedge.x = 490;
						tHedge.y = 60;
						break;
						
					case 7:
						tHedge.x = 570;
						tHedge.y = 60;
						break;
						
					/**
					 * upper right corner
					 */
					case 8:
						tHedge.x = 650;
						tHedge.y = 80;
						tHedge.rotation = 45;
						break;
						
					case 9:
						tHedge.x = 660;
						tHedge.y = 140;
						tHedge.rotation = 90;
						break;
						
					case 10:
						tHedge.x = 660;
						tHedge.y = 220;
						tHedge.rotation = 90;
						break;
						
					/**
					 * right center
					 */
					case 11:
						if( mLevel > 6 )
						{
							tHedge.x = 660;
							tHedge.y = mStage.stageHeight * .5;
							tHedge.rotation = 90;
						}
						break;
						
					case 12:
						tHedge.x = 660;
						tHedge.y = 380;
						tHedge.rotation = 90;
						break;
						
					case 13:
						tHedge.x = 660;
						tHedge.y = 460;
						tHedge.rotation = 90;
						break;
						
					case 14:
						tHedge.x = 660;
						tHedge.y = 540;
						tHedge.rotation = 90;
						break;
					
					/**
					 * lower right corner
					 */
					case 15:
						tHedge.x = 650;
						tHedge.y = 590;
						tHedge.rotation = 135;
						break;
						
					case 16:
						tHedge.x = 570;
						tHedge.y = 610;
						tHedge.rotation = 180;
						break;
						
					case 17:
						tHedge.x = 490;
						tHedge.y = 610;
						tHedge.rotation = 180;
						break;
						
					case 18:
						tHedge.x = 410;
						tHedge.y = 610;
						tHedge.rotation = 180;
						break;
						
					/**
					 * lower center
					 */
					case 19:
						if( mLevel > 3 )
						{
							tHedge.x = mStage.stageWidth * .5;
							tHedge.y = 610;
							tHedge.rotation = 180;
						}
						break;
						
					case 20:
						tHedge.x = 240;
						tHedge.y = 610;
						tHedge.rotation = 180;
						break;
						
					case 21:
						tHedge.x = 160;
						tHedge.y = 610;
						tHedge.rotation = 180;
						break;
						
					case 22:
						tHedge.x = 80;
						tHedge.y = 610;
						tHedge.rotation = 180;
						break;
						
					/**
					 * lower left corner
					 */
					case 23:
						tHedge.y = 590;
						tHedge.rotation = 225;
						break;
						
					case 24:
						tHedge.x = -5;
						tHedge.y = 540;
						tHedge.rotation = -90;
						break;
						
					case 25:
						tHedge.x = -5;
						tHedge.y = 460;
						tHedge.rotation = -90;
						break;
						
					case 26:
						tHedge.x = -5;
						tHedge.y = 380;
						tHedge.rotation = -90;
						break;
						
					/**
					 * left center
					 */
					case 27:
						if( mLevel > 6 )
						{
							tHedge.x = -5;
							tHedge.y = mStage.stageHeight * .5;
							tHedge.rotation = -90;
						}
						break;
						
					case 28:
						tHedge.x = -5;
						tHedge.y = 220;
						tHedge.rotation = -90;
						break;
						
					case 29:
						tHedge.x = -5;
						tHedge.y = 140;
						tHedge.rotation = -90;
						break;
				}
				
				mBorderHedges.push( tHedge );
			}			
			
		} // end update
		
		//===============================================================================
		// FUNCTION reset
		//===============================================================================
		internal function reset( ):void
		{
			mBorderHedges = [ ];
			mPetpetArrows = [ ];
			mPetpets      = [ ];
			
		} // end reset
		
		//===============================================================================
		// FUNCTION setupVars
		//===============================================================================
		private function setupVars( ):void
		{
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			mStage 		   = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage;
			
			mBorderHedges = [ ];
			mPetpetArrows = [ ];
			mPetpets      = [ ];
			
		} // end setupVars
	}
}