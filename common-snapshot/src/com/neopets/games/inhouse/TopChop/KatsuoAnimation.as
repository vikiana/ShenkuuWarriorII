package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class KatsuoAnimation extends MovieClip
	{
		//===============================================================================
		// vars & constants
		//===============================================================================
		internal const END_STAGE_ANIMATION_DONE : String = "AnimationDone";
		
		private var mKougraKarateGame : KougraKarateGame;	
		private var mStageResult      : String;
		
		//===============================================================================
		// CONSTRUCTOR WinAnimation
		//===============================================================================
		public function KatsuoAnimation( pKougraKarateGame : KougraKarateGame )
		{
			super( );
			
			mKougraKarateGame = pKougraKarateGame;
			
			this.stop( );
			startAnimation( );
			
		} // end constructor
		
		//===============================================================================
		//  FUNCTION doAnimation
		//===============================================================================
		internal function startAnimation( ) : void
		{
			if( GameVars.mCurrentStage == 13 )
			{
				trace( "stage 13 animation here!" );
				this.gotoAndPlay( "start_black_intro_frame" );
			}
			
			else
			{
				this.gotoAndPlay( "start_intro_frame" );
			}
			
			this.addEventListener( Event.ENTER_FRAME, checkAnimationState, false, 0, true );
			
		} // end doAnimation
		
		//===============================================================================
		//  FUNCTION doAnimation
		//===============================================================================
		internal function doAnimation( pStageResult : String ) : void
		{
			mStageResult = pStageResult;
			
			if( GameVars.mCurrentStage == 13 )
			{
				switch( mStageResult )
				{
					/*
					/ if "won" was passed in, play animation from "start_black_win_frame"
					*/
					case "won":
						this.gotoAndPlay( "start_black_win_frame" );
						this.addEventListener( Event.ENTER_FRAME, checkForImpact, false, 0, true );
						break;
					
					/*
					/ if "lost" was passed in, play animation from "start_black_lost_frame"
					*/	
					case "lost":
						this.gotoAndPlay( "start_black_lost_frame" );
						this.addEventListener( Event.ENTER_FRAME, checkForBadImpact, false, 0, true );
						break;
				}
			}
				
			else
			{
				switch( mStageResult )
				{
					/*
					/ if "cricket" was passed in, play animation from "start_win_frame"
					*/
					case "cricket":
						this.gotoAndPlay( "start_win_frame" );
						this.addEventListener( Event.ENTER_FRAME, checkForHesitation, false, 0, true );
						break;
											
					/*
					/ if "won" was passed in, play animation from "start_win_frame"
					*/
					case "won":
						this.gotoAndPlay( "start_win_frame" );
						this.addEventListener( Event.ENTER_FRAME, checkForImpact, false, 0, true );
						break;
					
					/*
					/ if "lost" was passed in, play animation from "start_lost_frame"
					*/	
					case "lost":
						this.gotoAndPlay( "start_lost_frame" );
						this.addEventListener( Event.ENTER_FRAME, checkForBadImpact, false, 0, true );
						break;
				}
			}
			
		} // end doAnimation
		
		//===============================================================================
		//  FUNCTION checkAnimationState
		//===============================================================================
		private function checkAnimationState( evt : Event ) : void
		{	
			if( GameVars.mCurrentStage == 13 || GameVars.mCurrentStage == 14 )
			{
				/*
				/ also check for "end_intro_frame" here because otherwise once GameVars.mCurrentStage is
				/ incremented to 13, the animation would just keep going until it hits "end_black_intro_frame"
				/ before it is caught here
				*/
				if( this.currentLabel == "end_black_intro_frame" || this.currentLabel == "end_intro_frame" )
				{
					this.gotoAndPlay( "start_black_intro_frame" );
				}
				
				else if( this.currentLabel == "end_black_win_frame" )
				{
					this.gotoAndPlay( "start_black_intro_frame" );
					dispatchEvent ( new Event( END_STAGE_ANIMATION_DONE ) );
				}
				
				else if( this.currentLabel == "end_black_lost_frame" )
				{
					this.stop( );
					dispatchEvent ( new Event( END_STAGE_ANIMATION_DONE ) );
				}
			}	
			
			else
			{					
				if( this.currentLabel == "end_intro_frame" )
				{
					this.gotoAndPlay( "start_intro_frame" );
				}
				
				else if( this.currentLabel == "end_win_frame" )
				{
					this.gotoAndPlay( "start_intro_frame" );
					dispatchEvent ( new Event( END_STAGE_ANIMATION_DONE ) );
				}
				
				else if( this.currentLabel == "end_lost_frame" )
				{
					this.stop( );
					dispatchEvent ( new Event( END_STAGE_ANIMATION_DONE ) );
				}
			}
			
		} //end checkAnimationState
		
		//===============================================================================
		//  FUNCTION checkForHesitation
		//===============================================================================
		private function checkForHesitation( evt : Event ) : void
		{			
			if( this.currentLabel == "hesitation_frame" )
			{
				trace( "hesitate here" );
				if( this.hasEventListener( Event.ENTER_FRAME ) )
				{					
					this.removeEventListener( Event.ENTER_FRAME, checkForHesitation );
				}
				
				this.stop( );
				
				var tTimer : Timer = new Timer( 1000, 1 );
				tTimer.addEventListener( TimerEvent.TIMER_COMPLETE, resumeAnimation, false, 0, true );
				tTimer.start( );
			}
			
		} //end checkForHesitation
		
		//===============================================================================
		//  FUNCTION resumeAnimation
		//===============================================================================
		private function resumeAnimation( evt : TimerEvent ) : void
		{
			var tTimer : Timer = evt.target as Timer;
			if( tTimer.running )
			{
				tTimer.stop( );
			}
			tTimer = null;
			
			/* 
			/ restart the animation now that hesitation phase is over
			*/
			startAnimation( );
			
			/*
			/ event listener was removed from stage. re-attach it
			*/
			mKougraKarateGame.reAttachListener( );
			
		} //end resumeAnimation
		
		//===============================================================================
		//  FUNCTION checkForImpact
		//===============================================================================
		private function checkForImpact( evt : Event ) : void
		{	
			if( GameVars.mCurrentStage == 13 )
			{
				if( this.currentLabel == "black_impact_frame" )
				{
					trace( "black impact now!" );
					GameVars.mBoardAnimation.startAnimation( );
					if( this.hasEventListener( Event.ENTER_FRAME ) )
					{					
						this.removeEventListener( Event.ENTER_FRAME, checkForImpact );
					}
					
					GameMenu.playSound( "BreakWood", GameVars.mSoundOn );
				}
			}
			
			else
			{
				if( this.currentLabel == "impact_frame" )
				{
					trace( "impact now!" );
					GameVars.mBoardAnimation.startAnimation( );
					if( this.hasEventListener( Event.ENTER_FRAME ) )
					{					
						this.removeEventListener( Event.ENTER_FRAME, checkForImpact );
					}
					
					//if( GameVars.mCurrentStage <= 1
					GameMenu.playSound( "BreakWood", GameVars.mSoundOn );
				}
			}
			
		} //end checkAnimationState
		
		//===============================================================================
		//  FUNCTION checkForBadImpact
		//===============================================================================
		private function checkForBadImpact( evt : Event ) : void
		{	
			if( GameVars.mCurrentStage == 13 )
			{
				if( this.currentLabel == "black_bad_impact_frame" )
				{
					trace( "black bad impact now!" );
					if( this.hasEventListener( Event.ENTER_FRAME ) )
					{					
						this.removeEventListener( Event.ENTER_FRAME, checkForBadImpact );
					}
					
					GameMenu.playSound( "BadHit", GameVars.mSoundOn );
				}
			}
			
			else
			{
				if( this.currentLabel == "bad_impact_frame" )
				{
					trace( "bad impact now!" );
					if( this.hasEventListener( Event.ENTER_FRAME ) )
					{					
						this.removeEventListener( Event.ENTER_FRAME, checkForBadImpact );
					}
					
					GameMenu.playSound( "BadHit", GameVars.mSoundOn );
				}
			}
			
		} //end checkForBadImpact
		
		//===============================================================================
		// FUNCTION removeMe
		//===============================================================================
		internal function removeMe( ):void
		{
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, checkAnimationState );
			}
			
			this.gotoAndStop( "start_intro_frame" );
		
		} // end removeMe

	} // end class

} // end package