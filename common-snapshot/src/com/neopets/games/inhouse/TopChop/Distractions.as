package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.*;
	import flash.events.*;

	public class Distractions extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mGarbage : Array;
		
		//===============================================================================
		// CONSTRUCTOR Distractions
		//===============================================================================
		public function Distractions( )
		{
			super( );
			trace( "Distractions created" );
			setupVars( );
						
		} // end constructor
		
		//===============================================================================
		// FUNCTION updateDistractions
		//===============================================================================
		internal function updateDistractions( ):void
		{
			clearMe( );
			
			if( GameVars.mCurrentStage <= 3 )
			{
				createBlossoms( );				
			}
			
			else if( GameVars.mCurrentStage > 3 && GameVars.mCurrentStage <= 7 )
			{
				trace( "put cricket distraction here" );
				createCricket( );
			}
			
			else if( GameVars.mCurrentStage >= 8 && GameVars.mCurrentStage <= 12 )
			{
				trace( "put guard pole distraction here" );
				//createGuard( );
				//createEmperor( );
			}
			
			else if( GameVars.mCurrentStage == 13 )
			{
				trace( "put emperor distraction here" );
				//createGuard( );
				//createEmperor( );
			}
			
		} // end updateDistractions
		
		//===============================================================================
		// FUNCTION createBlossoms
		//===============================================================================
		private function createBlossoms( ) : void
		{
			GameVars.mBlossoms = new Blossoms( );
			GameVars.mBlossoms.x = 130;
			GameVars.mBlossoms.y = -280;
			addChild( GameVars.mBlossoms );
			mGarbage.push( GameVars.mBlossoms );
			
		} // end createBlossoms		
		
		
		//===============================================================================
		// FUNCTION createCricket
		//===============================================================================
		private function createCricket( ) : void
		{						
			GameVars.mCricketAnimation = new CricketAnimation( );
			GameVars.mCricketAnimation.scaleX = .5;
			GameVars.mCricketAnimation.scaleY = .5;
			GameVars.mKatsuoAnimation.CricketContainerMC.addChild( GameVars.mCricketAnimation );
			mGarbage.push( GameVars.mCricketAnimation );
			
		} // end createCricket
		
		//===============================================================================
		// FUNCTION updateCricketAnim
		//===============================================================================
		private function updateCricketAnim( ) : void
		{						
			GameVars.mCricketAnimation.init( );
			
		} // end createCricket
		
		//===============================================================================
		// FUNCTION createGuard
		//===============================================================================
		private function createGuard( ) : void
		{						
			GameVars.mGuard = new Guard( );
			GameVars.mGuard.scaleX = .553;
			GameVars.mGuard.scaleY = .553;
			GameVars.mGuard.x = 403;
			GameVars.mGuard.y = 88;
			addChild( GameVars.mGuard );
			mGarbage.push( GameVars.mGuard );
			
		} // end createGuard
		
		//===============================================================================
		// FUNCTION createEmperor
		//===============================================================================
		private function createEmperor( ) : void
		{						
			GameVars.mEmperor = new Emperor( );
			GameVars.mEmperor.scaleX = .515;
			GameVars.mEmperor.scaleY = .545;
			GameVars.mEmperor.x = 314;
			GameVars.mEmperor.y = 35;
			addChild( GameVars.mEmperor );
			mGarbage.push( GameVars.mEmperor );
			
		} // end createEmperor
		
		//===============================================================================
		// FUNCTION clearMe( ): 
		//          - removes all child backgrounds
		//===============================================================================
		internal function clearMe( ):void
		{
			if( GameVars.mBlossoms )
			{
				GameVars.mBlossoms.clearMe( );
			}
			
			if( GameVars.mGuard )
			{
				GameVars.mGuard.clearMe( );
			}
			
			if( GameVars.mEmperor )
			{
				GameVars.mEmperor.clearMe( );
			}
			
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