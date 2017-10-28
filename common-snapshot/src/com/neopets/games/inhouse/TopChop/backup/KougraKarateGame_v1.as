/*
/ VERSION 1
/ - includes code for test buttons to make slider increase/decrease speed randomly, to make it skip and
/   to make green zone move
/ - passes game level instead of setting GameVars.mCurrentLevel (commented out)
*/

package kougrakarate
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================	
	import finalTemp.utils.listener.SharedListener;
	
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
		private var mID             : String = "I'm a custom event";		
		private var mGamingSystem   : MovieClip;
		private var mSharedListener : SharedListener;
		private var mStage          : Stage;
		private var mRoundTime      : uint = 30000;
		
		//===============================================================================
		// CONSTRUCTOR KougraKarateGame
		//         -
		//===============================================================================
		public function KougraKarateGame( pSharedListener : SharedListener = null )
		{
			trace( "KougraKarateGame in KougraKarateGame called" );
			
			setupVars( );
			
			mSharedListener = ( pSharedListener != null ) ? pSharedListener : mSharedListener;
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init( ): 
		//          -     
		//===============================================================================
		internal function init( pGamingSystem : MovieClip, /*pStartingLevel : int, */pStage : Stage ):void
		{	
			trace( "init in KougraKarateGame called" );
			
			/*
			/ instantiate counter for super zone hits to 9
			*/
			GameVars.mSuperZoneCounter = 2;
					
			mGamingSystem = pGamingSystem;
			
			mStage = pStage;
			
			//=======================================
			// encrypted game score
			//=======================================
			GameVars.mGameScore = mGamingSystem.createEvar( 0 );
			GameVars.mGameLevel = mGamingSystem.createEvar( 0 );
			
			//GameVars.mCurrentLevel = pStartingLevel;
			createGame( /*GameVars.mCurrentLevel*/ );
			
			/*
			/ set GameVars.mGameOn to true so that slider will
			/ stutter in levels above 3
			*/
			GameVars.mGameOn = true;
			
		} // end function init
		
		//===============================================================================
		// FUNCTION createGame( ): 
		//===============================================================================
		private function createGame( /*pStartingLevel : int*/ ):void
		{	
			trace( "createGame in KougraKarateGame called" );
			
			//trace( "level " + pStartingLevel + " started" );
			
			/*
			/ CHANGE: laod background according to level
			*/
			//=======================================
			// background
			//=======================================
			GameVars.mBGCourtYard = new BGCourtYard( );
			GameVars.mBGCourtYard.x = -140;
			GameVars.mBGCourtYard.y = -230;
			//tSpeedButton.scaleX = .6;
			//tSpeedButton.scaleY = .6;
			//setText( "displayFont", tSpeedButton.text_txt, /*endButton_str*/ "Random" );
			addChild( GameVars.mBGCourtYard );
			GameVars.mGameOverGarbage.push( GameVars.mBGCourtYard );
			
			//=======================================
			// slider random speed button
			//=======================================
			//var tSpeedButton : CenterAlignedButton = new CenterAlignedButton( );
			//tSpeedButton.x = 30;
			//tSpeedButton.y = 20;
			//tSpeedButton.scaleX = .6;
			//tSpeedButton.scaleY = .6;
			//setText( "displayFont", tSpeedButton.text_txt, /*endButton_str*/ "Random" );
			//addChild( tSpeedButton );
			//tSpeedButton.addEventListener( MouseEvent.CLICK, randomizeSliderSpeedToggle, false, 0, true );
			//GameVars.mGameOverGarbage.push( tSpeedButton );
			
			//=======================================
			// stutter slider button
			//=======================================
			//var tStutterSliderButton : CenterAlignedButton = new CenterAlignedButton( );
			//tStutterSliderButton.x = 140;
			//tStutterSliderButton.y = 20;
			//tStutterSliderButton.scaleX = .6;
			//tStutterSliderButton.scaleY = .6;
			//setText( "displayFont", tStutterSliderButton.text_txt, /*endButton_str*/ "Stutter" );
			//addChild( tStutterSliderButton );
			//tStutterSliderButton.addEventListener( MouseEvent.CLICK, stutterSliderToggle, false, 0, true );
			//GameVars.mGameOverGarbage.push( tStutterSliderButton );
			
			//=======================================
			// meter move button
			//=======================================
			//var tMeterMoveButton : CenterAlignedButton = new CenterAlignedButton( );
			//tMeterMoveButton.x = 30;
			//tMeterMoveButton.y = 60;
			//tMeterMoveButton.scaleX = .6;
			//tMeterMoveButton.scaleY = .6;
			//setText( "displayFont", tMeterMoveButton.text_txt, /*endButton_str*/ "Meter" );
			//addChild( tMeterMoveButton );
			//tMeterMoveButton.addEventListener( MouseEvent.CLICK, moveMeterToggle, false, 0, true );
			//GameVars.mGameOverGarbage.push( tMeterMoveButton );
			
			//=======================================
			// katsuo
			//=======================================
			GameVars.mKatsuoAnimation = new KatsuoAnimation( );
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
			GameVars.mMeterFrame.x = 480;
			GameVars.mMeterFrame.y = 30;
			GameVars.mMeterFrame.width = 115;
			GameVars.mMeterFrame.height = 248;
			addChild( GameVars.mMeterFrame );
			GameVars.mGameOverGarbage.push( GameVars.mMeterFrame );
			
			//=======================================
			// meter
			//=======================================
			GameVars.mMeter = new Meter( );
			var tMeterX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mMeter.width / 2 );
			var tMeterY : Number = GameVars.mMeterFrame.y + ( GameVars.mMeterFrame.height / 2 - GameVars.mMeter.height / 2 ) - 1;
			GameVars.mMeter.init( /*pStartingLevel, */tMeterX, tMeterY );
			addChild( GameVars.mMeter );
			GameVars.mGameOverGarbage.push( GameVars.mMeter );
			
			//=======================================
			// slider
			//=======================================
			GameVars.mSlider = new Slider( );
			var tSliderX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mSlider.width / 2 );
			GameVars.mSlider.init( /*pStartingLevel, */tSliderX );
			addChild( GameVars.mSlider );
			GameVars.mGameOverGarbage.push( GameVars.mSlider );
			
			//=======================================
			// distractions
			//=======================================
			GameVars.mDistractions = new Distractions( );
			addChild( GameVars.mDistractions );
			GameVars.mGameOverGarbage.push( GameVars.mDistractions );			
			
			//=======================================
			// scoreboard
			//=======================================
			GameVars.mScoreboard = new Scoreboard( );
			GameVars.mScoreboard.init( mGamingSystem, this );
			GameVars.mScoreboard.x = 10;
			GameVars.mScoreboard.y = 10;
			addChild( GameVars.mScoreboard );
			GameVars.mGameOverGarbage.push( GameVars.mScoreboard );
			
			//=======================================
			// timer
			//=======================================
			GameVars.mGameTimer = new TimeDisplay( "SF Shai Fontai Extended", "left", 0xFFFFFF, 36, 24, 36 );
			//GameVars.mGameTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimeUp, false, 0, true );			
			GameVars.mGameTimer.init( mRoundTime );
			GameVars.mGameTimer.startTimer( );
			GameVars.mScoreboard.addChild( GameVars.mGameTimer );
			GameVars.mGameOverGarbage.push( GameVars.mGameTimer );
			
			mStage.addEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked, false, 0, true );
			
		} // end function createGame
		
		//===============================================================================
		// FUNCTION onSpaceCklicked( ): 
		//          - slider is stopped and score is updated accordingly
		//===============================================================================
		private function onSpaceCklicked( evt : KeyboardEvent )
		{
			trace( "onSpaceCklicked called" );
			
			if( evt.keyCode == Keyboard.SPACE )
			{
				/*
				/ after space bar was klicked, remove event listener for 
				/ space bar click from stage
				*/ 
				if( mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) )
				{
					mStage.removeEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked );
				}
				
				/* 
				/ set GameVars.mGameOn to false so that if slider was stopped while it was
				/ also paused, it want resume and event listener will not be added to it again
				*/
				GameVars.mGameOn = false;
				
				/*
				/ remove event listener from end game button. makes my life easier so users can't mess
				/ with quitting the game between levels
				*/
				GameVars.mScoreboard.setEndGameButtonState( "deactivate" );
				
				/*
				/ FOR TESTING PURPOSES
				*/
				//GameVars.mRandomSlider  = false;
				//GameVars.mStutterSlider = false;
				//GameVars.mMovingMeter   = false;
				
				/*
				/ stop the meter
				*/
				GameVars.mMeter.stopSafeZone( );
				
				/*
				/ stop the slider
				*/
				GameVars.mSlider.stopSlider( );
				
				/*
				/ give points depending on where slider was stopped: the closer to the center of 
				/ safe zone, the more points are awarded. so calculate distance between center of green zone
				/ and slider location then subtract that distance from height of the meter. that way scoring
				/ should be fair and consistent in all levels.
				*/
				
				trace( "GameVars.mStoppedSliderLocation: " + GameVars.mStoppedSliderLocation );
				trace( "GameVars.mStoppedSafeZoneLocation: " + GameVars.mStoppedSafeZoneLocation );
				var tDistanceToGreenZone : Number = Math.abs( GameVars.mStoppedSafeZoneLocation - GameVars.mStoppedSliderLocation );
				trace( "tDistanceToGreenZone: " + tDistanceToGreenZone );
			 	GameVars.mCurrentScore   = Math.abs( GameVars.mMeter.height - tDistanceToGreenZone );
			 	trace( "GameVars.mCurrentScore: " + GameVars.mCurrentScore );
				
				GameVars.mGameScore.changeBy( GameVars.mCurrentScore );
				GameVars.mScoreboard.updateScoreDisplay( );
				
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
				
				
				if( GameVars.mStoppedSliderLocation > tSuperSafeZoneTop && GameVars.mStoppedSliderLocation < tSuperSafeZoneBottom )
				{
					/*
					/ slider stopped inside sweet spot so set GameVars.mSenseiStatus to "proud"
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
						GameVars.mSenseiStatus = "amazed";					
						trace( "GameVars.mSuperZoneCounter: " + GameVars.mSuperZoneCounter );
						GameVars.mSuperZoneCounter = 2;
					}
					
					GameVars.mKatsuoAnimation.doAnimation( "won" );
					GameVars.mKatsuoAnimation.addEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen, false, 0, true );
				}
				
				else if( GameVars.mStoppedSliderLocation > tSafeZoneTop && GameVars.mStoppedSliderLocation < tSafeZoneBottom )
				{
					/*
					/ slider stopped inside green zone so set GameVars.mSenseiStatus to "happy"
					/ and play win animation by passing in "won"
					*/
					trace( "green zone" );
					GameVars.mSuperZoneCounter = 0;
					GameVars.mSenseiStatus = "happy";
					GameVars.mKatsuoAnimation.doAnimation( "won" );
					GameVars.mKatsuoAnimation.addEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen, false, 0, true );
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
					GameVars.mKatsuoAnimation.doAnimation( "lost" );
					GameVars.mKatsuoAnimation.addEventListener( GameVars.mKatsuoAnimation.END_STAGE_ANIMATION_DONE, doSplitScreen, false, 0, true );				
				}
			}
			
		} // end onSpaceCklicked
		
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
			GameVars.mSplitScreenAnimation = new SplitScreenAnimation( mGamingSystem );
			GameVars.mSplitScreenAnimation.addEventListener( GameVars.mSplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE, moveOn, false, 0, true ); 
			GameVars.mSplitScreenAnimation.doAnimation( );
			addChild( GameVars.mSplitScreenAnimation );							
			
		} // end doSplitScreen
		
		//===============================================================================
		// FUNCTION moveOn
		//===============================================================================
		internal function moveOn( evt : Event ):void
		{
			trace( "moveOn in KougraKarateGame called" );
			
			if( GameVars.mSplitScreenAnimation.hasEventListener( GameVars.mSplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE ) )
			{
				GameVars.mSplitScreenAnimation.removeEventListener( GameVars.mSplitScreenAnimation.SPLIT_SCREEN_ANIMATION_DONE, moveOn );
			}
			
			removeChild( GameVars.mSplitScreenAnimation );
			GameVars.mSplitScreenAnimation = null;
			
			/*
			/ if slider was not stopped inside super green zone or green zone
			/ then game is over after split screen animation
			*/
			if( GameVars.mSenseiStatus == "disappointed" )
			{
				endGame( );
			}
			
			/*
			/ if slider was stopped inside super green zone or green zone then move
			/ on to next level and update unlocked levels
			*/
			else
			{
				trace( "GameVars.mCurrentLevel: " + GameVars.mCurrentLevel );
				trace( "GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel: " + GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel );
				GameVars.mCurrentLevel++;
				trace( "GameVars.mCurrentLevel: " + GameVars.mCurrentLevel );
				trace( "GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel: " + GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel );
				/*
				/ if GameVars.mCurrentLevel, aka level that was just finished, is greater than 
				/ GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel, aka level that user has unlocked so far in
				/ shared object, then set unlocked level in shared object to GameVars.mCurrentLevel
				*/
				if ( GameVars.mCurrentLevel > GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel )
				{
					GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel = new int( GameVars.mCurrentLevel );
					GameVars.mSharedObject.flush( );
					
					/* 
					/ set GameVars.mUnlockedLevel to uGameVars.mCurrentLevel so that it is recognized in game
					/ menu on the level selection buttons when game is ended and restarted
					*/
					GameVars.mUnlockedLevel = GameVars.mCurrentLevel;
				}
				
				trace( "GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel: " + GameVars.mSharedObject.data[ GameVars.mUserName ].unlockedLevel );
				trace( "go to next level" );
				nextLevel( );	
			}			
					
		} // end moveOn
		
		//===============================================================================
		// FUNCTION nextLevel( ): 
		//===============================================================================
		internal function nextLevel( ) : void
		{
			trace( "nextLevel in KougraKarateGame called" );
			
			trace( "GameVars.mCurrentLevel: " + GameVars.mCurrentLevel );
			
			/*
			/ re-attach event listener to end game button
			*/
			GameVars.mScoreboard.setEndGameButtonState( "activate" );
			
			/*
			/ if player earned power up, add it here
			*/
			
			var tMeterX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mMeter.width / 2 );
			var tMeterY : Number = GameVars.mMeterFrame.y + ( GameVars.mMeterFrame.height / 2 - GameVars.mMeter.height / 2 ) - 1;
			GameVars.mMeter.init( /*GameVars.mCurrentLevel, */tMeterX, tMeterY );
			
			var tSliderX : Number = GameVars.mMeterFrame.x + ( GameVars.mMeterFrame.width / 2 - GameVars.mSlider.width / 2 )
			GameVars.mSlider.init( /*GameVars.mCurrentLevel, */tSliderX );
			
			GameVars.mBoardAnimation.init( );
			
			mStage.focus = mStage;
			mStage.addEventListener( KeyboardEvent.KEY_DOWN, onSpaceCklicked, false, 0, true );
			
			trace( "mStage.hasEventListener( KeyboardEvent.KEY_DOWN ): " + mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) );
				
		} // end nextLevel
		
		//===============================================================================
		// FUNCTION endGame( ): 
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
			mSharedListener.sendCustomEvent( mSharedListener.GAME_OVER_SCREEN, {ID:mID} );
			
		} // end endGame
		
		//===============================================================================
		// FUNCTION clearGame( ):
		//          - clears all elements on stage
		//===============================================================================
		private function clearGame( ):void
		{	
			GameVars.mSlider.removeMe( );
			GameVars.mMeter.removeMe( );
			GameVars.mKatsuoAnimation.removeMe( );
			
			//GameVars.mRandomSlider  = false;
			//GameVars.mStutterSlider = false;
			//GameVars.mMovingMeter   = false;
			
			GameVars.mScoreboard.setEndGameButtonState( "deactivate" );
			
			if( mStage.hasEventListener( KeyboardEvent.KEY_DOWN ) );
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
		// FUNCTION setText( ): 
		//          - sets a textField with text, set up for translation     
		//===============================================================================
		private function setText( pFontName : String, pTextTield : TextField, pString : String = "********" ) : void
		{			
			mGamingSystem.setFont( pFontName );
			mGamingSystem.setTextField( pTextTield, pString );
			
		} // end setText( )
		
		//===============================================================================
		// FUNCTION setupVars( ): 
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mSharedListener           = new SharedListener( );
			GameVars.mGameOverGarbage = new Array( );
			GameVars.mCurrentScore    = 0;
			
		} // end setupVars		
				
		
		//===============================================================================
		//===============================================================================
		// FUNCTIONS FOR TESTING
		//===============================================================================
		//===============================================================================
		
		//===============================================================================
		// FUNCTION randomizeSliderSpeedToggle( ): 
		//===============================================================================
		//private function randomizeSliderSpeedToggle( evt : MouseEvent ):void
		//{
			//GameVars.mRandomSlider ? GameVars.mRandomSlider = false : GameVars.mRandomSlider = true;
			//trace( "GameVars.mRandomSlider: " + GameVars.mRandomSlider );
			
		//} // end randomizeSliderSpeedToggle
		
		//===============================================================================
		// FUNCTION stutterSliderToggle( ): 
		//===============================================================================
		//private function stutterSliderToggle( evt : MouseEvent ):void
		//{
			//GameVars.mStutterSlider ? GameVars.mStutterSlider = false : GameVars.mStutterSlider = true;
			//trace( "GameVars.mStutterSlider: " + GameVars.mStutterSlider );
			
		//} // end stutterSliderToggle
		
		//===============================================================================
		// FUNCTION moveMeterToggle( ): 
		//===============================================================================
		//private function moveMeterToggle( evt : MouseEvent ):void
		//{
			//GameVars.mMovingMeter ? GameVars.mMovingMeter = false : GameVars.mMovingMeter = true;
			//trace( "GameVars.mMovingMeter: " + GameVars.mMovingMeter );
			
			//if( GameVars.mMovingMeter )
			//{
				//trace( "GameVars.mMovingMeter true" );			
				//GameVars.mMeter.animateSafeZone( );
			//}
			
			//else
			//{
				//trace( "GameVars.mMovingMeter false" );
				//GameVars.mMeter.stopSafeZoneFromButton( );
			//}
			
		//} // end moveMeterToggle
		
	} // end class
	
} // end package
