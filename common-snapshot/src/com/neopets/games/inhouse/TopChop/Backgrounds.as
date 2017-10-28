package com.neopets.games.inhouse.TopChop
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.*;
	
	public class Backgrounds extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mGarbage : Array;
		
		//===============================================================================
		// CONSTRUCTOR PowerUp
		//===============================================================================
		public function Backgrounds( )
		{
			setupVars( );
		}
		
		//===============================================================================
		// FUNCTION updateBackgrounds( ): 
		//          - displays background according to stage
		//===============================================================================
		internal function updateBackgrounds( ):void
		{
			/*
			/ get rid of any previous backgrounds and then display backgrounds 
			/ according to GameVars.mCurrentLevel
			*/
			
			clearMe( );
			
			if( GameVars.mCurrentStage <= 3 )
			{			
				GameVars.mBGCourtYard = new BGCourtYard( );
				GameVars.mBGCourtYard.x = -140;
				GameVars.mBGCourtYard.y = -230;
				addChild( GameVars.mBGCourtYard );
				mGarbage.push( GameVars.mBGCourtYard );
			}
			
			else if ( GameVars.mCurrentStage > 3 && GameVars.mCurrentStage <= 7 )
			{
				GameVars.mBGDojo = new BGDojo( );
				GameVars.mBGDojo.x = 320;
				GameVars.mBGDojo.y = 300;
				addChild( GameVars.mBGDojo );
				mGarbage.push( GameVars.mBGDojo );
			}
			
			else if( GameVars.mCurrentStage > 7 && GameVars.mCurrentStage <= 12 )
			{
				GameVars.mBGGrandHall = new BGGrandHall( );
				GameVars.mBGGrandHall.gotoAndStop( 1 );
				GameVars.mBGGrandHall.x = -200;
				GameVars.mBGGrandHall.y = -70;
				addChild( GameVars.mBGGrandHall );
				mGarbage.push( GameVars.mBGGrandHall );
			}
			
			else if( GameVars.mCurrentStage == 13 )
			{
				GameVars.mBGGrandHall = new BGGrandHall( );
				GameVars.mBGGrandHall.gotoAndStop( 2 );
				GameVars.mBGGrandHall.x = -200;
				GameVars.mBGGrandHall.y = -70;
				addChild( GameVars.mBGGrandHall );
				mGarbage.push( GameVars.mBGGrandHall );
			}
			
		} // end updateBackgrounds
		
		//===============================================================================
		// FUNCTION clearMe( ): 
		//          - removes all child backgrounds
		//===============================================================================
		internal function clearMe( ):void
		{
			for( var i : int = mGarbage.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = mGarbage[ i ];
				
				if( tCurrentObject.parent != null )
				{
					tCurrentObject.parent.removeChild( tCurrentObject );
					tCurrentObject = null;					
				}
			}
			
			mGarbage = new Array( );
			
		} // end clearMe
		
		//===============================================================================
		// FUNCTION setupVars( ): 
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mGarbage = new Array( );
			
		} // end setupVars

	} // end class
	
} // end package