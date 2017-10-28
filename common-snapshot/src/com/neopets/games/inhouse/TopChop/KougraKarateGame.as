package com.neopets.games.inhouse.TopChop
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextField;
	import flash.ui.*;
	import flash.utils.*;
	import flash.xml.*;

	public class KougraKarateGame extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mID                    : String = "I'm a custom event";		
		private var mGamingSystem          : MovieClip;
		private var mTopChopSharedListener : TopChopSharedListener;
		private var mStage                 : Stage;
		private var mRoundTime             : uint = 30000;
		
		//===============================================================================
		// CONSTRUCTOR KougraKarateGame
		//         -
		//===============================================================================
		public function KougraKarateGame( pTopChopSharedListener : TopChopSharedListener = null )
		{
			trace( "KougraKarateGame in KougraKarateGame called" );
			
			setupVars( );
			
			mTopChopSharedListener = ( pTopChopSharedListener != null ) ? pTopChopSharedListener : mTopChopSharedListener;
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init( ): 
		//          -     
		//===============================================================================
		internal function init( pGamingSystem : MovieClip, pStage : Stage ):void
		{	
			trace( "init in KougraKarateGame called" );
			
			if( GameVars.mCurrentStage <= 3 )
			{ 
				GameMenu.playSound( "GameMusic", GameVars.mMusicOn, true );
			}
			
			/*
			/ instantiate counter for super zone hits to 0
			*/
			GameVars.mSuperZoneCounter = 0;
			
			/*
			/ instantiate counter for hidden stage to 0
			/ is incremented when super safe zone is hit in stages 10, 11, and 12
			*/
			GameVars.mHiddenStageCounter = 0;
			
			/*
			/ set GameVars.mHasPowerUp to false as player can't have power up
			/ at beginning of game
			*/
			GameVars.mHasPowerUp = false;
			
			/*
			/ initialise mHasSecondLife to false. will be set to true once player
			/ activates the power up
			*/
			GameVars.mHasExtraLife = false;
					
			mGamingSystem = pGamingSystem;
			
			/*
			/ reference to root stage
			*/
			mStage = pStage;
			
			//=======================================
			// encrypted game score
			//=======================================
			GameVars.mGameScore = mGamingSystem.createEvar( 0 );
			GameVars.mGameLevel = mGamingSystem.createEvar( 0 );
			
			/*
			/ set GameVars.mGameOn to true so that slider will
			/ stutter in levels above 3
			*/
			GameVars.mGameOn = true;
			
			createGame( );
			
		} // end function init
		
		//===============================================================================
		// FUNCTION createGame( ): 
		//===============================================================================
		private function createGame( ):void
		{	
			trace( "createGame in KougraKarateGame called" );
									
			//=======================================
			// background
			//=======================================
			GameVars.mBackgrounds = new Backgrounds( );
			addChild( GameVars.mBackgrounds );
			GameVars.mGameOverGarbage.push( GameVars.mBackgrounds );
			GameVars.mBackgrounds.updateBackgrounds( );
			
			//=======================================
			// katsuo
			//=======================================
			GameVars.mKatsuoAnimation = new KatsuoAnimation( this );
			GameVars.mKatsuoAnimation.x = 40;
			GameVars.mKatsuoAnimation.y = 150;
			GameVars.mKatsuoAnimation.scaleX = .8;
			GameVars.mKatsuoAnimation.scaleY = .8;
			addChild( GameVars.mKatsuoAnimation );
			GameVars.mGameOverGarbage.push( GameVars.mKatsuoAnimation );
			
			//=======================================
			// board
			//=======================================
			GameVars.mBoardAnimation = new BoardAnimation( );
			GameVars.mKatsuoAnimation.BoardContainerMC.addChild( GameVars.mBoardAnimation );
			GameVars.mGameOverGarbage.push( GameVars.mBoardAnimation );
			
			//=======================================
			// meter frame
			//=======================================
			GameVars.mMeterFrame = new MeterFrame( );
			GameVars.mMeterFrame.x = 530;
			GameVars.mMeterFrame.y = 10;
			GameVars.mMeterFrame.width = 100;
			GameVars.mMeterFrame.height = 230;
			addChild( GameVars.mMeterFrame );
			GameVars.mGameOverGarbage.push( GameVars.mMeterFrame );
			
			//=======================================
			// meter
			//=======================================
			GameVars.mMeter = new Meter( );
			var tMeterX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mMeter.width / 2 );
			var tMeterY : Number = GameVars.mMeterFrame.y + ( GameVars.mMeterFrame.height / 2 - GameVars.mMeter.height / 2 ) - 1;
			GameVars.mMeter.init( tMeterX, tMeterY );
			addChild( GameVars.mMeter );
			GameVars.mGameOverGarbage.push( GameVars.mMeter );
			
			//=======================================
			// slider
			//=======================================
			GameVars.mSlider = new Slider( );
			var tSliderX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mSlider.width / 2 );
			GameVars.mSlider.init( tSliderX );
			addChild( GameVars.mSlider );
			GameVars.mGameOverGarbage.push( GameVars.mSlider );		
			
			//=======================================
			// scoreboard
			//=======================================
			GameVars.mScoreboard = new Scoreboard( );
			GameVars.mScoreboard.init( mGamingSystem, this, mStage );
			GameVars.mScoreboard.x = 10;
			GameVars.mScoreboard.y = 10;
			GameVars.mScoreboard.scaleX = 1.1;			
			GameVars.mScoreboard.scaleY = 1.1;
			addChild( GameVars.mScoreboard );
			GameVars.mGameOverGarbage.push( GameVars.mScoreboard );
			
			//=======================================
			// distractions
			//=======================================
			GameVars.mDistractions = new Distractions( );
			GameVars.mDistractions.updateDistractions( );
			addChild( GameVars.mDistractions );
			GameVars.mGameOverGarbage.push( GameVars.mDistractions );	
			
			//=======================================
			// timer
			//=======================================
			GameVars.mGameTimer = new TimeDisplay( "SF Shai Fontai Extended", "left", 0xFFFFFF, 36, 24, 36 );
			GameVars.mGameTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimeUp, false, 0, true );			
			GameVars.mGameTimer.init( mRoundTime );
			GameVars.mGameTimer.startTimer( );
			GameVars.mScoreboard.addChildAt( GameVars.mGameTimer, GameVars.mScoreboard.getChildIndex( GameVars.mEndGameButton ) - 1 );
			GameVars.mGameOverGarbage.push( GameVars.mGameTimer );
			
			//=======================================
			// level display
			//=======================================
			GameVars.mLevelDisplay = new LevelDisplay( "SF Shai Fontai Extended", "left", 0xFFFFFF, 18, 110, 12 );
			GameVars.mLevelDisplay.updateLevelDisplay( );
			GameVars.mScoreboard.addChild( GameVars.mLevelDisplay );
			GameVars.mGameOverGarbage.push( GameVars.mLevelDisplay );
			
			mStage.focus = mStage;
			mStage.addEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked, false, 0, true );
			
		} // end function createGame
		
		//===============================================================================
		// FUNCTION onSpaceCklicked( ): 
		//          - slider is stopped and score is updated accordingly
		//===============================================================================
		private function onSpaceCklicked( evt : KeyboardEvent ):void
		{
			trace( "onSpaceCklicked called" );
			
			/*
			/ after space bar was klicked, remove event listener for 
			/ space bar click from stage
			*/ 
			if( mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) )
			{
				mStage.removeEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked );
			}
			
			if( evt.keyCode == Keyboard.SPACE )
			{
				if( GameVars.mCricketAnimOn )
				{
					trace( "do partial animation here" );
					GameVars.mKatsuoAnimation.doAnimation( "cricket" );					
					
					var tCricketAlert = new CricketAlert( mGamingSystem, this );
					tCricketAlert.doAnimation( );
					tCricketAlert.addEventListener( CricketAlert.CRICKET_ANIMATION_DONE, cricketAlertDone, false, 0, true );
					addChild( tCricketAlert );					
				}
				
				else
				{					
					/* 
					/ set GameVars.mGameOn to false. do this first because of dependants 
					/ dependants: 
					/ slider stutter - event listener for slider stutter mustn't continue when space
				 	/ 	bar was clicked and game is over
				 	/ cricket animation - event listener for cricket animation mustn't continue when space
				 	/ 	bar was clicked and game is over
				 	/ power ups - shouldn't be able to be activated when space bar was clicked			
					*/
					GameVars.mGameOn = false;
					
					/*
					/ remove event listener from end game button. makes my life easier so users can't mess
					/ with quitting the game between levels
					*/
					GameVars.mScoreboard.setEndGameButtonState( "deactivate" );
					
					/*
					/ stop the safe zone
					*/
					GameVars.mMeter.stopSafeZone( );
					
					/*
					/ stop the slider
					*/
					GameVars.mSlider.stopSlider( );
					
					GameVars.mGameTimer.stopTimer ( );
					
					/*
					/ determine zone between top and bottom of sweet spot
					*/				
					var tSuperSafeZoneTop    : Number = Math.abs( Math.round( GameVars.mSafeZone.y + GameVars.mSuperSafeZone.y ) );
					var tSuperSafeZoneBottom : Number = Math.abs( Math.round( GameVars.mSafeZone.y + ( GameVars.mSuperSafeZone.y + GameVars.mSuperSafeZone.height ) ) );
									
					/*
					/ determine zone between top and bottom of safe zone
					*/	
					var tSafeZoneTop    : Number = Math.abs( Math.round( GameVars.mSafeZone.y ) );
					var tSafeZoneBottom : Number = Math.abs( Math.round( GameVars.mSafeZone.y + GameVars.mSafeZone.height ) );
					
					/*
					/ give points depending on where slider was stopped: the closer to the center of 
					/ safe zone, the more points are awarded. so calculate distance between center of green zone
					/ and slider location then subtract that distance from height of the meter. that way scoring
					/ should be fair and consistent in all levels.
					*/					
					//trace( "GameVars.mStoppedSliderLocation: " + GameVars.mStoppedSliderLocation );
					//trace( "GameVars.mStoppedSafeZoneLocation: " + GameVars.mStoppedSafeZoneLocation );
					var tDistanceToGreenZone : Number = Math.abs( GameVars.mStoppedSafeZoneLocation - GameVars.mStoppedSliderLocation );
					//trace( "tDistanceToGreenZone: " + tDistanceToGreenZone );
				 	GameVars.mCurrentScore   = Math.abs( GameVars.mMeter.height - tDistanceToGreenZone );
				 	trace( "GameVars.mCurrentScore: " + GameVars.mCurrentScore );
					
					/*
					/ calculate time bonus
					*/
					GameVars.mTimeBonus = GameVars.mGameTimer.mSecondsLeft;
					trace( "GameVars.mTimeBonus: " +  GameVars.mTimeBonus );
					
					/*
					/ check if player hit center. if so, award bonus
					*/
					if( GameVars.mStoppedSliderLocation > tSuperSafeZoneTop && GameVars.mStoppedSliderLocation < tSuperSafeZoneBottom )
					{
						GameVars.mCenterHitBonus = 20;
					}
					
					else
					{
						GameVars.mCenterHitBonus = 0;
					}
					trace( "GameVars.mCenterHitBonus: " +  GameVars.mCenterHitBonus );
					
									 	
				 	GameVars.mCurrentScore += GameVars.mTimeBonus;
				 	GameVars.mCurrentScore += GameVars.mCenterHitBonus;
					
					GameVars.mGameScore.changeBy( GameVars.mCurrentScore );
					GameVars.mScoreboard.updateScoreDisplay( );
					
					
					if( GameVars.mStoppedSliderLocation > tSuperSafeZoneTop && GameVars.mStoppedSliderLocation < tSuperSafeZoneBottom )
					{
						/*
						/ if player stopped slider in super safe zone in stages 10, 11, and 12 GameVars.mHiddenStageCounter
						/ is incremented
						*/
						switch( GameVars.mCurrentStage )
						{
							case 10:
							case 11:
							case 12:
								trace( "GameVars.mHiddenStageCounter: " + GameVars.mHiddenStageCounter );
								GameVars.mHiddenStageCounter++;
								trace( "GameVars.mHiddenStageCounter: " + GameVars.mHiddenStageCounter );
								break;
						}
						
						/*
						/ check if player hit super safe zone in stage 13. if it's stage 13, then play final win animation
						*/
						if( GameVars.mCurrentStage == 13 )
						{
							if( GameVars.mEmperorAnimOn )
							{
								GameVars.mSenseiStatus = "emperor asleep";
							}
							
							else
							{
								trace( "player won stage 13" );
								GameVars.mSenseiStatus = "final stage won";
							}
						} 
						
						else
						{
							/*
							/ slider stopped inside sweet spot so set GameVars.mSenseiStatus to "proud" or "amazed"
							/ and play win animation by passing in "bullseye"
							*/
							trace( "super zone" );
							if( GameVars.mSuperZoneCounter < 3 )
							{
								GameVars.mSuperZoneCounter++;					
								trace( "GameVars.mSuperZoneCounter: " + GameVars.mSuperZoneCounter );
							}
							
							if( GameVars.mSuperZoneCounter < 3 )
							{
								GameVars.mSenseiStatus = "proud";					
								trace( "GameVars.mSuperZoneCounter: " + GameVars.mSuperZoneCounter );
							}
							else if( GameVars.mSuperZoneCounter == 3 )
							{
								/*
								/ player stopped slider in sweet spot for third time so award power up
								/ and reset GameVars.mSuperZoneCounter to 0
								*/
								GameVars.mSenseiStatus = "amazed";					
								trace( "GameVars.mSuperZoneCounter: " + GameVars.mSuperZoneCounter );
								GameVars.mSuperZoneCounter = 0;
							}
						}
						
						GameVars.mKatsuoAnimation.doAnimation( "won" );
						GameVars.mKatsuoAnimation.addEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen, false, 0, true );
					}
					
					else if( GameVars.mStoppedSliderLocation > tSafeZoneTop && GameVars.mStoppedSliderLocation < tSafeZoneBottom )
					{
						/*
						/ check if player hit safe zone in stage 13. if it's stage 13, then play final win animation
						*/
						if( GameVars.mCurrentStage == 13 )
						{
							if( GameVars.mEmperorAnimOn )
							{
								GameVars.mSenseiStatus = "emperor asleep";
							}
							
							else
							{
								trace( "player won stage 13" );
								GameVars.mSenseiStatus = "final stage won";
							}
						} 
						
						else
						{
							/*
							/ slider stopped inside green zone so set GameVars.mSenseiStatus to "happy"
							/ and play win animation by passing in "won"
							*/
							trace( "green zone" );
							GameVars.mSenseiStatus = "happy";
						}
						
						GameVars.mKatsuoAnimation.doAnimation( "won" );
						GameVars.mKatsuoAnimation.addEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen, false, 0, true );
					}				
					
					else
					{
						if( GameVars.mCurrentStage == 13 )
						{
							/*
							/ slider stopped outside green zone but player had an extra life so
							/ increment GameVars.mCurrentStage by 1 so they repeat the same stage
							/ and set GameVars.mSenseiStatus to "extra life"
							*/
							if( GameVars.mHasExtraLife )
							{
								trace( "you get a second chance" );
								GameVars.mHasExtraLife = false;
								GameVars.mCurrentStage--;
								GameVars.mSenseiStatus = "extra life";								
							}
							
							else
							{								
								trace( "player lost stage 13" );
								GameVars.mSenseiStatus = "final stage lost";
							}
						}
						
						else
						{						
							/*
							/ slider stopped outside green zone but player had an extra life so
							/ increment GameVars.mCurrentStage by 1 so they repeat the same stage
							/ and set GameVars.mSenseiStatus to "extra life"
							*/
							if( GameVars.mHasExtraLife )
							{
								trace( "you get a second chance" );
								GameVars.mHasExtraLife = false;
								GameVars.mCurrentStage--;
								GameVars.mSenseiStatus = "extra life";								
							}
							
							
							else
							{
								/*
								/ slider stopped outside green zone so set GameVars.mSenseiStatus to "disappointed"
								/ and play lose animation by passing in "lost"
								*/
								trace( "outside of zone" );
								GameVars.mSuperZoneCounter = 0;
								GameVars.mSenseiStatus = "disappointed";
							}
						}
						
						GameVars.mKatsuoAnimation.doAnimation( "lost" );
						GameVars.mKatsuoAnimation.addEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen, false, 0, true );			
					}
				}
			}
			
		} // end onSpaceCklicked
		
		//===============================================================================
		// FUNCTION onTimeUp
		//===============================================================================
		internal function onTimeUp( evt : TimerEvent ):void
		{
			trace( "onTimeUp in KougraKarateGame called" );
			
			if( GameVars.mHasExtraLife )
			{
				/*
				/ time ran out but player had an extra life so
				/ increment GameVars.mCurrentStage by 1 so they repeat the same stage
				/ and set GameVars.mSenseiStatus to "extra life"
				*/
				trace( "you get a second chance" );
				GameVars.mCurrentStage--;
				GameVars.mSenseiStatus = "extra life";
				GameVars.mHasExtraLife = false;
			}
			
			else
			{
				/*
				/ time ran out so set GameVars.mSenseiStatus to "time wasted"
				/ and play lose animation by passing in "lost"
				*/			
				GameVars.mSenseiStatus = "time wasted";
			}
			
			/*
			/ after time is up, remove event listener for 
			/ space bar click from stage
			*/ 
			if( mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) )
			{
				mStage.removeEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked );
			}
			
			/* 
			/ set GameVars.mGameOn to false so that if slider was stopped while time
			/ ran up, it won't resume and event listener will not be added to it again
			*/
			GameVars.mGameOn = false;
			
			/*
			/ remove event listener from end game button. makes my life easier so users can't mess
			/ with quitting the game between levels
			*/
			GameVars.mScoreboard.setEndGameButtonState( "deactivate" );
			
			/*
			/ stop the meter
			*/
			GameVars.mMeter.stopSafeZone( );
			
			/*
			/ stop the slider
			*/
			GameVars.mSlider.stopSlider( );
			
			/*
			/ initiate split screen animation. it will play according to time up event,
			/ i.e. according to state of mSenseiStatus
			*/		
			GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem, this );
			GameVars.mSplitScreenAnimation.addEventListener( SplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE, moveOn, false, 0, true ); 
			GameVars.mSplitScreenAnimation.doAnimation( );
			addChild( GameVars.mSplitScreenAnimation );							
			
		} // end onTimeUp
		
		//===============================================================================
		// FUNCTION doSplitScreen
		//===============================================================================
		internal function doSplitScreen( evt : Event ):void
		{
			trace( "doSplitScreen in KougraKarateGame called" );
			
			/*
			/ remove end stage animation
			*/
			if( GameVars.mKatsuoAnimation.hasEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE ) )
			{
				GameVars.mKatsuoAnimation.removeEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen );
			}		
			
			/*
			/ initiate split screen animation. it will play according to the result of slider stop
			/ i.e. according to state of mSenseiStatus
			*/		
			GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem, this );
			GameVars.mSplitScreenAnimation.addEventListener( SplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE, moveOn, false, 0, true ); 
			GameVars.mSplitScreenAnimation.doAnimation( );
			addChild( GameVars.mSplitScreenAnimation );							
			
		} // end doSplitScreen
		
		//===============================================================================
		// FUNCTION moveOn
		//===============================================================================
		internal function moveOn( evt : Event ):void
		{
			trace( "moveOn in KougraKarateGame called" );
			
			if( GameVars.mSplitScreenAnimation.hasEventListener( SplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE ) )
			{
				GameVars.mSplitScreenAnimation.removeEventListener( SplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE, moveOn );
			}
			
			if( GameVars.mSplitScreenAnimation.hasEventListener( SplitScreenAnimation.SPECIAL_STAGE_ANIMATION_DONE ) )
			{
				GameVars.mSplitScreenAnimation.removeEventListener( SplitScreenAnimation.SPECIAL_STAGE_ANIMATION_DONE, moveOn );
			}
			
			removeChild( GameVars.mSplitScreenAnimation );
			GameVars.mSplitScreenAnimation = null;
			
			/*
			/ if slider was not stopped inside super safe zone or safe zone or time ran out and player did not
			/ have an extra life then game is over after split screen animation
			*/
			if( GameVars.mSenseiStatus == "disappointed" || GameVars.mSenseiStatus == "time wasted" )
			{
				endGame( );
			}
			
			else if( GameVars.mCurrentStage == 3 )
			{
		
				trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage )
				trace( "stage three complete. pop up here" );
				GameVars.mCurrentStage++;
				
				GameVars.mSenseiStatus = "stage three complete";
				
				GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem, this );
				GameVars.mSplitScreenAnimation.addEventListener( SplitScreenAnimation.SPECIAL_STAGE_ANIMATION_DONE, callNextLevel, false, 0, true ); 
				GameVars.mSplitScreenAnimation.doAnimation( );
				addChild( GameVars.mSplitScreenAnimation );					
			}
			
			else if( GameVars.mCurrentStage == 7 )
			{
		
				trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage )
				trace( "stage seven complete. pop up here" );
				GameVars.mCurrentStage++;
				
				GameVars.mSenseiStatus = "stage seven complete";
				
				GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem, this );
				GameVars.mSplitScreenAnimation.addEventListener( SplitScreenAnimation.SPECIAL_STAGE_ANIMATION_DONE, callNextLevel, false, 0, true ); 
				GameVars.mSplitScreenAnimation.doAnimation( );
				addChild( GameVars.mSplitScreenAnimation );				
			}
			
			/*
			/ if slider was stopped inside super safe zone or safe zone but player was already in stage 12
			/ then check if they hit the super safe zone 3 times consecutively. if they did, move on to stage 13
			/ if they did not, game is over
			*/
			else if( GameVars.mCurrentStage == 12 )
			{
				if( GameVars.mHiddenStageCounter == 3 )
				{					
					GameVars.mCurrentStage++;
					
					GameVars.mSenseiStatus = "hidden stage";
					
					GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem, this );
					GameVars.mSplitScreenAnimation.addEventListener( SplitScreenAnimation.SPECIAL_STAGE_ANIMATION_DONE, callNextLevel, false, 0, true ); 
					GameVars.mSplitScreenAnimation.doAnimation( );
					addChild( GameVars.mSplitScreenAnimation );	
				}
				
				else
				{
					trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage )
					trace( "game is complete. pop up here" );
					GameVars.mSenseiStatus = "game complete";
					
					GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem, this );
					GameVars.mSplitScreenAnimation.addEventListener( SplitScreenAnimation.SPECIAL_STAGE_ANIMATION_DONE, callNextLevel, false, 0, true ); 
					GameVars.mSplitScreenAnimation.doAnimation( );
					addChild( GameVars.mSplitScreenAnimation );
				}				
			}
			
			else if( GameVars.mCurrentStage == 13 )
			{					
				GameVars.mCurrentStage++;
				
				trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage )
				trace( "hidden stage was completed. no more pop ups!" );
				GameVars.mSenseiStatus = "";
				
				endGame( );							
			}
			
			/*
			/ if slider was stopped inside super green zone or green zone then move
			/ on to next level and update unlocked levels
			*/
			else
			{
				trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage );
				trace( "GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage: " + GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage );
				GameVars.mCurrentStage++;
				trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage );
				trace( "GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage: " + GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage );
				/*
				/ if GameVars.mCurrentLevel, aka level that was just finished, is greater than 
				/ GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage, aka level that user has unlocked so far in
				/ shared object, then set unlocked level in shared object to GameVars.mCurrentLevel
				*/
				if ( GameVars.mCurrentStage > GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage && GameVars.mCurrentStage < 10 )
				{
					GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage = new int( GameVars.mCurrentStage );
					GameVars.mSharedObject.flush( );
					
					/* 
					/ set GameVars.munlockedStage to GameVars.mCurrentLevel so that it is recognized in game
					/ menu on the level selection buttons when game is ended and restarted
					*/
					GameVars.mUnlockedStage = GameVars.mCurrentStage;
				}
				
				trace( "GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage: " + GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedStage );
				trace( "go to next level" );
				nextLevel( );	
			}			
					
		} // end moveOn
		
		//===============================================================================
		// FUNCTION callNextLevel 
		//===============================================================================
		internal function callNextLevel( evt : Event ) : void
		{
			trace( "callNextLevel in KougraKarateGame called" );
			
			if( GameVars.mSenseiStatus == "stage three complete" || GameVars.mSenseiStatus == "stage seven complete" )
			{
				nextLevel( );
			}
			
			else if( GameVars.mSenseiStatus == "hidden stage" )
			{
				trace( "PROCEED TO HIDDEN STAGE!" );
				nextLevel( );
			} 
			
			else if( GameVars.mSenseiStatus == "game complete" )
			{
				endGame( );
			} 
							
		} // end callNextLevel
		
		//===============================================================================
		// FUNCTION nextLevel 
		//===============================================================================
		internal function nextLevel( ) : void
		{
			trace( "nextLevel in KougraKarateGame called" );
			
			trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage );
			
			/* 
			/ set GameVars.mGameOn to false. do this first because of dependants 
			/ dependants: 
			/ slider stutter - event listener for slider stutter mustn't continue when space
		 	/ 	bar was clicked and game is over
		 	/ cricket animation - event listener for cricket animation mustn't continue when space
		 	/ 	bar was clicked and game is over
		 	/ power ups - shouldn't be able to be activated when space bar was clicked			
			*/
			GameVars.mGameOn = true;
			
			/*
			/ set GameVars.mCricketAnimOn to false. there was a bug where it was set to true after a stage
			/ was finished and the kougra animation would always be the partial animation that is performed
			/ when the cricket is on the board
			*/
			GameVars.mCricketAnimOn = false;

			/*
			/ reset boni for time and center hit in new stage
			*/
			GameVars.mTimeBonus       = 0;
			GameVars.mCenterHitBonus  = 0;
			
			var tMeterX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mMeter.width / 2 );
			var tMeterY : Number = GameVars.mMeterFrame.y + ( GameVars.mMeterFrame.height / 2 - GameVars.mMeter.height / 2 ) - 1;
			GameVars.mMeter.init( tMeterX, tMeterY );
			
			GameVars.mSlider.y = GameVars.mMeter.y + 6;
			var tSliderX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mSlider.width / 2 );
			GameVars.mSlider.init( tSliderX );
			
			GameVars.mLevelDisplay.updateLevelDisplay( );
			
			/*
			/ restart kougra blink animation
			*/
			GameVars.mKatsuoAnimation.startAnimation( );
				
			/*
			/ update background. if appropriate level is reached, background will change
			/ otherwise it will stay the same
			*/
			GameVars.mBackgrounds.updateBackgrounds( );
			
			/*
			/ re-attach event listener to end game button
			*/
			GameVars.mScoreboard.setEndGameButtonState( "activate" );
			
			/*
			/ check if player earned a power up
			*/
			GameVars.mScoreboard.checkPowerUp( );
			
			/*
			/ update distractions according to stage
			*/
			GameVars.mDistractions.updateDistractions( );
			
			/*
			/ restart the timer
			*/
			GameVars.mGameTimer.init( mRoundTime );
			GameVars.mGameTimer.startTimer( );
			
			GameVars.mBoardAnimation.updateBoard( );
			
			reAttachListener( );
			
			trace( "mStage.hasEventListener( KeyboardEvent.KEY_DOWN ): " + mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) );
				
		} // end nextLevel
		
		//===============================================================================
		// FUNCTION cricketAlertDone  
		//===============================================================================
		internal function cricketAlertDone( evt : Event ) : void
		{	
			trace( "cricketAlertDone called" );
			
			var tEventTarget : MovieClip = evt.target as MovieClip;
						
			if( tEventTarget.hasEventListener( CricketAlert.CRICKET_ANIMATION_DONE ) )
			{
				tEventTarget.removeEventListener( CricketAlert.CRICKET_ANIMATION_DONE, cricketAlertDone );
			}
			
			removeChild( tEventTarget );
			tEventTarget = null;
			
		} // end cricketAlertDone( )
		
		//===============================================================================
		// FUNCTION reAttachListener
		//		- called from KatsuoAnimation after "checkForHesitation" is over when
		//        cricket was blocking katsuo's animation
		//===============================================================================
		internal function reAttachListener( ): void
		{
			mStage.focus = mStage;
			mStage.addEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked, false, 0, true );
						
		} // end reAttachListener
		
		//===============================================================================
		// FUNCTION endGame
		//===============================================================================
		internal function endGame( ): void
		{
			/*
			/ send tracking
			*/
			mGamingSystem.sendTag( "Game Finished" );			
			
			GameVars.mFinalScore = GameVars.mGameScore.show( );
			
			clearGame( );
			
			/*
			/ give control back to GameMenu by creating game over menu
			*/	
			mTopChopSharedListener.sendCustomEvent( mTopChopSharedListener.GAME_OVER_SCREEN, {ID:mID} );
			
		} // end endGame
		
		//===============================================================================
		// FUNCTION clearGame
		//          - clears all elements on stage
		//===============================================================================
		private function clearGame( ):void
		{				
			GameMenu.stopAllSounds( );
			
			GameVars.mGameTimer.stopTimer( );
			GameVars.mSlider.removeMe( );
			GameVars.mMeter.removeMe( );
			GameVars.mKatsuoAnimation.removeMe( );
			GameVars.mBackgrounds.clearMe( );
			GameVars.mDistractions.clearMe( );
			
			GameVars.mGameOn = false;
			
			GameVars.mScoreboard.setEndGameButtonState( "deactivate" );
			
			if( mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) )
			{
				mStage.removeEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked );
			}
					
			/*
			/ removes all elements from this game by looping through GameVars.mGameOverGarbage
			*/			
			for( var i : int = GameVars.mGameOverGarbage.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = GameVars.mGameOverGarbage[ i ];
				
				if( tCurrentObject.parent != null )
				{
					//trace( "-----------------------------------------------" );
					//trace( "tCurrentObject: " + tCurrentObject );
					//trace( "tCurrentObject.parent: " + tCurrentObject.parent );				
					//trace( "removing tCurrentObject " + tCurrentObject );
					tCurrentObject.parent.removeChild( tCurrentObject );
					//trace( "setting tCurrentObject " + tCurrentObject + " to null" );
					tCurrentObject = null;					
				}
			}
			
			GameVars.mGameOverGarbage = new Array( );
			
		} // end clearGame
		
		//===============================================================================
		// FUNCTION setText
		//          - sets a textField with text, set up for translation     
		//===============================================================================
		internal function setText( pFontName : String, pTextTield : TextField, pString : String = "********" ) : void
		{			
			mGamingSystem.setFont( pFontName );
			mGamingSystem.setTextField( pTextTield, pString );
			
		} // end setText( )
		
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mTopChopSharedListener           = new TopChopSharedListener( );
			GameVars.mGameOverGarbage        = new Array( );
			GameVars.mCurrentScore           = 0;
			
		} // end setupVars
		
	} // end class
	
} // end package
