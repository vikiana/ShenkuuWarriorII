package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================		
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	
	import behaviors.*;

	public class Balthazar extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		private var mBalthazarMC   : MovieClip;
		
		//=======================================
		// getter vars
		//=======================================
		private var gIsGrabbing : Boolean;
		private var gStartsGrab : Boolean;
		private var gIsWalking  : String;
		private var gIsFrozen   : Boolean;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================		
		public function set mIsGrabbing( pValue : Boolean ):void { gIsGrabbing = pValue };
		public function get mIsGrabbing( ):Boolean { return gIsGrabbing };
		
		public function set mStartsGrab( pValue : Boolean ):void { gStartsGrab = pValue };
		public function get mStartsGrab( ):Boolean { return gStartsGrab };		
		
		public function set mIsWalking( pValue : String ):void { gIsWalking = pValue };
		public function get mIsWalking( ):String { return gIsWalking };
		
		public function set mIsFrozen( pValue : Boolean ):void { gIsFrozen = pValue };
		public function get mIsFrozen( ):Boolean { return gIsFrozen };
		
		//===============================================================================
		// CONSTRUCTOR Balthazar
		//===============================================================================
		public function Balthazar( /*pStage : Stage*/ )
		{
			//trace( "Balthazar in " + this + " called" );
			
			//mStage = pStage;
			
			setupVars( );
			draw( );
			mBalthazarMC.stop( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION draw
		//===============================================================================
		private function draw( ):void
		{
			var tBalthazarClass : Class = mAssetLocation.getDefinition( "Balthazar" ) as Class;
			mBalthazarMC = new tBalthazarClass( );
			this.addChild( mBalthazarMC );
			
		} // end draw
		
		//===============================================================================
		// 	FUNCTION update
		//===============================================================================
		internal function update( pDirArrow : DirArrow ):void
		{	
			this.x = pDirArrow.x;
			this.y = pDirArrow.y;
			
			var tRot : Number = pDirArrow.rotation;
			
			/**
			 * go to appropriate frame of balthazar's animation
			 */
			if( tRot >= -22.5 && tRot < 22.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_right" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_right" );
					mBalthazarMC.gotoAndPlay( "swipe_right" );
					mIsWalking = "walk_right";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_right" )
				{
					mBalthazarMC.gotoAndPlay( "walk_right" );
					mIsWalking = "walk_right";				
				}
			}
			
			else if( tRot >= 22.5 && tRot < 77.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_down_right" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_down_right" );
					mBalthazarMC.gotoAndPlay( "swipe_down_right" );
					mIsWalking = "walk_down_right";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_down_right" )
				{
					mBalthazarMC.gotoAndPlay( "walk_down_right" );
					mIsWalking = "walk_down_right";
				}
			}
			
			else if( tRot >= 77.5 && tRot < 112.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_down" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_down" );
					mBalthazarMC.gotoAndPlay( "swipe_down" );
					mIsWalking = "walk_down";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_down" )
				{
					mBalthazarMC.gotoAndPlay( "walk_down" );
					mIsWalking = "walk_down";
				}
			}
			
			else if( tRot >= 112.5 && tRot < 157.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_down_left" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_down_left" );
					mBalthazarMC.gotoAndPlay( "swipe_down_left" );
					mIsWalking = "walk_down_left";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_down_left" )
				{
					mBalthazarMC.gotoAndPlay( "walk_down_left" );
					mIsWalking = "walk_down_left";
				}
			}
			
			else if( tRot >= 157.5 && tRot < 180 || tRot >= -179.9 && tRot < -157.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_left" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_left" );
					mBalthazarMC.gotoAndPlay( "swipe_left" );
					mIsWalking = "walk_left";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_left" )
				{
					mBalthazarMC.gotoAndPlay( "walk_left" );
					mIsWalking = "walk_left";
				}
			}
			
			else if( tRot >= -157.5 && tRot < -112.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_up_left" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_up_left" );
					mBalthazarMC.gotoAndPlay( "swipe_up_left" );
					mIsWalking = "walk_up_left";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_up_left" )
				{
					mBalthazarMC.gotoAndPlay( "walk_up_left" );
					mIsWalking = "walk_up_left";
				}
			}
			
			else if( tRot >= -112.5 && tRot < -77.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_up" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_up" );
					mBalthazarMC.gotoAndPlay( "swipe_up" );
					mIsWalking = "walk_up";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_up" )
				{
					mBalthazarMC.gotoAndPlay( "walk_up" );
					mIsWalking = "walk_up";
				}
			}
			
			else if( tRot >= -77.5 && tRot < -22.5 )
			{
				if( mIsFrozen )
				{
					mBalthazarMC.gotoAndStop( "frozen_up_right" );
					return;
				}
				
				if( mIsGrabbing && mStartsGrab )
				{
					//trace( "swipe_up_right" );
					mBalthazarMC.gotoAndPlay( "swipe_up_right" );
					mIsWalking = "walk_up_right";
					mStartsGrab = false;
				}
				
				if( mIsWalking != "walk_up_right" )
				{
					mBalthazarMC.gotoAndPlay( "walk_up_right" );
					mIsWalking = "walk_up_right";
				}
			}
			
			checkAnimationState( );
			
		} // end update
		
		//===============================================================================
		//  FUNCTION checkAnimationState
		//===============================================================================
		private function checkAnimationState( ):void
		{
			if( mBalthazarMC.currentLabel == "end_walk_down" )
			{
				mBalthazarMC.gotoAndPlay( "walk_down" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_down_right" )
			{
				mBalthazarMC.gotoAndPlay( "walk_down_right" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_right" )
			{
				mBalthazarMC.gotoAndPlay( "walk_right" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_up_right" )
			{
				mBalthazarMC.gotoAndPlay( "walk_up_right" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_up" )
			{
				mBalthazarMC.gotoAndPlay( "walk_up" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_up_left" )
			{
				mBalthazarMC.gotoAndPlay( "walk_up_left" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_left" )
			{
				mBalthazarMC.gotoAndPlay( "walk_left" );
			}
			
			else if( mBalthazarMC.currentLabel == "end_walk_down_left" )
			{
				mBalthazarMC.gotoAndPlay( "walk_down_left" );
			}
			
			/**
			 * grabbing sequences
			 */
			else if( mBalthazarMC.currentLabel == "end_swipe_right" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_down_right" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_down" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_down_left" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_left" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_up_left" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_up" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
			
			else if( mBalthazarMC.currentLabel == "end_swipe_up_right" )
			{
				mIsGrabbing = false;
				mBalthazarMC.stop( );
			}
						
		} //end checkAnimationState
		
		//===============================================================================
		// FUNCTION setupVars
		//===============================================================================
		 private function setupVars( ):void
		{
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			mIsGrabbing = false;
			
		} // end setupVars
		
	} // end class
	
} // end package
