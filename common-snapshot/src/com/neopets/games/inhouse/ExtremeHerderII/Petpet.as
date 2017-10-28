package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================		
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	import behaviors.*;

	public class Petpet extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		private var gPetpetMC      : MovieClip;
		
		//=======================================
		// getter vars
		//=======================================
		private var gIsWalking      : String;
		//private var gIsBeingCarried : Boolean;
		
		//=======================================
		//	GETTERS & SETTERS
		//=======================================
		public function set mIsWalking( pValue : String ):void { gIsWalking = pValue };
		public function get mIsWalking( ):String { return gIsWalking };
		
		public function set mPetpetMC( pValue : MovieClip ):void { gPetpetMC = pValue };
		public function get mPetpetMC( ):MovieClip { return gPetpetMC };
		
		//public function set mIsBeingCarried( pValue : Boolean ):void { gIsBeingCarried = pValue };
		//public function get mIsBeingCarried( ):Boolean { return gIsBeingCarried };
		
		//===============================================================================
		// CONSTRUCTOR Petpet
		//===============================================================================
		public function Petpet( /*pStage : Stage*/ )
		{
			//trace( "Balthazar in " + this + " called" );
			
			//mStage = pStage;
			
			setupVars( );
			create( );
			mPetpetMC.stop( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION create
		//===============================================================================
		private function create( ):void
		{
			mPetpetMC = draw( );
			addChild( mPetpetMC );
			
		} // end create
				
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		private function draw( ):MovieClip
		{
			var tPetpet : MovieClip;
			var tWhichPetpet : int = Math.floor( Math.random( ) * 4 )
			
			switch( tWhichPetpet )
			{
				case 0:
					var tPetpetClass1     : Class = mAssetLocation.getDefinition( "PetpetBabaa" ) as Class;						
					var tPetpetMC1 : MovieClip = new tPetpetClass1( );
					tPetpet = tPetpetMC1;//addChild( mPetpetMC1 );
					break;
					
				case 1:
					var tPetpetClass2     : Class = mAssetLocation.getDefinition( "PetpetHoovle" ) as Class;						
					var tPetpetMC2 : MovieClip = new tPetpetClass2( );
					tPetpet = tPetpetMC2;//addChild( mPetpetMC2 );
					break;
					
				case 2:
					var tPetpetClass3     : Class = mAssetLocation.getDefinition( "PetpetSnorkle" ) as Class;						
					var tPetpetMC3 : MovieClip = new tPetpetClass3( );
					tPetpet = tPetpetMC3;//addChild( mPetpetMC3 );
					break;
					
				case 3:
					var tPetpetClass4     : Class = mAssetLocation.getDefinition( "PetpetWibreth" ) as Class;						
					var tPetpetMC4 : MovieClip = new tPetpetClass4( );
					tPetpet = tPetpetMC4;//addChild( mPetpetMC4 );
					break;
					
				default:
					break;
			}
			
			return tPetpet;
			
		} // end draw
		
		//===============================================================================
		// 	FUNCTION update
		//===============================================================================
		public function update( pDirArrow : DirArrow ):void
		{
			/**
			 * go to appropriate frame of petpet's animation
			 */	
			this.x = pDirArrow.x;
			this.y = pDirArrow.y;
			
			var tRot : Number = pDirArrow.rotation;
		
			if( tRot >= -22.5 && tRot < 22.5 )
			{				
				if( mIsWalking != "walk_right" )
				{
					mPetpetMC.gotoAndPlay( "walk_right" );
					mIsWalking = "walk_right";				
				}
			}
			
			else if( tRot >= 22.5 && tRot < 77.5 )
			{				
				if( mIsWalking != "walk_down_right" )
				{
					mPetpetMC.gotoAndPlay( "walk_down_right" );
					mIsWalking = "walk_down_right";
				}
			}
			
			else if( tRot >= 77.5 && tRot < 112.5 )
			{				
				if( mIsWalking != "walk_down" )
				{
					mPetpetMC.gotoAndPlay( "walk_down" );
					mIsWalking = "walk_down";
				}
			}
			
			else if( tRot >= 112.5 && tRot < 157.5 )
			{				
				if( mIsWalking != "walk_down_left" )
				{
					mPetpetMC.gotoAndPlay( "walk_down_left" );
					mIsWalking = "walk_down_left";
				}
			}
			
			else if( tRot >= 157.5 && tRot < 180 || tRot >= -179.9 && tRot < -157.5 )
			{				
				if( mIsWalking != "walk_left" )
				{
					mPetpetMC.gotoAndPlay( "walk_left" );
					mIsWalking = "walk_left";
				}
			}
			
			else if( tRot >= -157.5 && tRot < -112.5 )
			{
				if( mIsWalking != "walk_up_left" )
				{
					mPetpetMC.gotoAndPlay( "walk_up_left" );
					mIsWalking = "walk_up_left";
				}
			}
			
			else if( tRot >= -112.5 && tRot < -77.5 )
			{
				if( mIsWalking != "walk_up" )
				{
					mPetpetMC.gotoAndPlay( "walk_up" );
					mIsWalking = "walk_up";
				}
			}
			
			else if( tRot >= -77.5 && tRot < -22.5 )
			{
				if( mIsWalking != "walk_up_right" )
				{
					mPetpetMC.gotoAndPlay( "walk_up_right" );
					mIsWalking = "walk_up_right";
				}
			}
				
			checkAnimationState( );
			
		} // end update
		
		//===============================================================================
		// 	FUNCTION updateCarried
		//===============================================================================
		public function updateCarried( ):void
		{
			if( mIsWalking != "being_carried" )
			{
				mPetpetMC.gotoAndPlay( "being_carried" );
				mIsWalking = "being_carried";				
			}
			
			checkAnimationState( );
			
		} // end updateCarried
		
		//===============================================================================
		//  FUNCTION checkAnimationState
		//===============================================================================
		private function checkAnimationState( ):void
		{
			if( mPetpetMC.currentLabel == "end_walk_down" )
			{
				mPetpetMC.gotoAndPlay( "walk_down" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_down_right" )
			{
				mPetpetMC.gotoAndPlay( "walk_down_right" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_right" )
			{
				mPetpetMC.gotoAndPlay( "walk_right" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_up_right" )
			{
				mPetpetMC.gotoAndPlay( "walk_up_right" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_up" )
			{
				mPetpetMC.gotoAndPlay( "walk_up" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_up_left" )
			{
				mPetpetMC.gotoAndPlay( "walk_up_left" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_left" )
			{
				mPetpetMC.gotoAndPlay( "walk_left" );
			}
			
			else if( mPetpetMC.currentLabel == "end_walk_down_left" )
			{
				mPetpetMC.gotoAndPlay( "walk_down_left" );
			}
			
			/**
			 * being carried sequence
			 */
			else if( mPetpetMC.currentLabel == "end_being_carried" )
			{
				mPetpetMC.gotoAndPlay( "being_carried" );
			}
						
		} //end checkAnimationState
		
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
