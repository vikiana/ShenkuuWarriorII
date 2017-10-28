package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.system.ApplicationDomain;
	
	public class BoardAnimation extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		internal const END_STAGE_ANIMATION_DONE : String = "AnimationDone";
		
		private var mStageResult : String;
		private var mBoard       : MovieClip;
		
		//===============================================================================
		// CONSTRUCTOR WinAnimation
		//===============================================================================
		public function BoardAnimation( )
		{
			super( );
			init( );
			
		} // end constructor
		
		//===============================================================================
		//  FUNCTION init( ):
		//===============================================================================
		internal function init( ) : void
		{
			var tBoardName : String = "Board" + GameVars.mCurrentStage.toString( );
			var BoardClass : Class;
			
			if( ApplicationDomain.currentDomain.hasDefinition( tBoardName ) )
			{
				BoardClass = ApplicationDomain.currentDomain.getDefinition( tBoardName ) as Class;
			
				trace( "tBoardName: " + tBoardName )
				trace( "BoardClass: " + BoardClass );
				
				mBoard = new BoardClass( );
				mBoard.gotoAndStop( "startFrame" );
				this.BoardsContainerMC.addChild( mBoard );
				
				this.gotoAndStop( "startFrame" );
			}
			
			else
			{
				trace( "no more boards" );
			}
			
		} // end init
		
		//===============================================================================
		//  FUNCTION doAnimation( ):
		//===============================================================================
		internal function startAnimation( ) : void
		{
			trace( "startAnimation in BoardAnimation called" );
			
			mBoard.gotoAndPlay( "startFrame" );
			mBoard.addEventListener( Event.ENTER_FRAME, checkBoardAnimationState, false, 0, true );
			
			this.gotoAndPlay( "startFrame" );
			this.addEventListener( Event.ENTER_FRAME, checkAnimationState, false, 0, true );
			
		} // end doAnimation
		
		//===============================================================================
		//  FUNCTION checkBoardAnimationState( ):
		//===============================================================================
		private function checkBoardAnimationState( evt : Event ) : void
		{
			if( mBoard.currentLabel == "endFrame" )
			{
				mBoard.stop( );
				if( mBoard.hasEventListener( Event.ENTER_FRAME ) )
				{
					mBoard.removeEventListener( Event.ENTER_FRAME, checkBoardAnimationState );
				}
			}
			
		} //end checkBoardAnimationState
		
		//===============================================================================
		//  FUNCTION checkAnimationState( ):
		//===============================================================================
		private function checkAnimationState( evt : Event ) : void
		{
			if( this.currentLabel == "endFrame" )
			{
				this.stop( );
				if( this.hasEventListener( Event.ENTER_FRAME ) )
				{
					this.removeEventListener( Event.ENTER_FRAME, checkAnimationState );
				}
			}
			
		} //end checkAnimationState
		
		//===============================================================================
		// FUNCTION updateBoard
		//===============================================================================
		internal function updateBoard( ):void
		{
			this.BoardsContainerMC.removeChild( mBoard );
			mBoard = null;
			
			init( );
		
		} // end updateBoard
		
		//===============================================================================
		// FUNCTION removeMe
		//===============================================================================
		internal function removeMe( ):void
		{
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, checkAnimationState );
			}
			
			this.gotoAndStop( "startFrame" );
		
		} // end removeMe

	} // end class

} // end package