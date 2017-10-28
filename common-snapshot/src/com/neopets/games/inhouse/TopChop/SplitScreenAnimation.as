package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// imports
	//===============================================================================	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;

	public class SplitScreenAnimation extends MovieClip
	{
		//===============================================================================
		// vars & constants
		//===============================================================================
		internal static const SPLIT_SCREEN_ANIMATION_DONE  : String = "AnimationDone";
		internal static const SPECIAL_STAGE_ANIMATION_DONE : String = "SpecialStageAnimationDone";
		internal static const HIDDEN_STAGE_ANIMATION_DONE  : String = "SpecialStageAnimationDone";
		
		private var mGamingSystem     : MovieClip;
		private var mKougraKarateGame : KougraKarateGame;	
		private var mTwoPowerUps      : Boolean;
		private var mGarbage          : Array;
		
		//===============================================================================
		// CONSTRUCTOR SplitScreenAnimation
		//===============================================================================		
		public function SplitScreenAnimation( pGamingSystem : MovieClip, pKougraKarateGame : KougraKarateGame )
		{
			super( );
			
			mGamingSystem     = pGamingSystem;
			mKougraKarateGame = pKougraKarateGame;
			
			setupVars( );
			
			this.stop( );
			this.x = 10;
			this.y = 800;		
			
		} // end constructor
		
		//===============================================================================
		//  function doAnimation( ):
		//===============================================================================
		internal function doAnimation( ) : void
		{
			switch( GameVars.mSenseiStatus )
			{
				case "amazed":
					trace( "case amazed" );
					var tPeiMeiAmazed : PeiMeiProud = new PeiMeiProud( );
					
					/*
					/ display power up inside split screen
					*/
					var tPowerUp : MovieClip;
					
					if( GameVars.mHasPowerUp )
					{					
						/*
						/ player has an unused power up so display both in split screen and
						/ make player choose one
						/*
						
						/*
						/ display special sensei blurb
						*/					
						var tChosePowerUpStr : String = mGamingSystem.getTranslation( "IDS_POPUP_CHOSE" );											 
						mKougraKarateGame.setText( "displayFont", tPeiMeiAmazed.mMainTextBox, tChosePowerUpStr );
						
						/*
						/ set mTwoPowerUps to true so that continue button won't be 
						/ displayed and power ups themselves will register the click event
						*/
						mTwoPowerUps = true;
						
						/*
						/ display the one that player already has
						*/						
						switch( GameVars.mPowerUpTracker )
						{
							case "One":
								tPowerUp = new PowerUpOne( );
								break;
								
							case "Two":
								tPowerUp = new PowerUpTwo( );
								break;
								
							case "Three":
								tPowerUp = new PowerUpThree( );
								break;
						}
						tPowerUp.scaleX = .3;
						tPowerUp.scaleY = .3;							
						tPowerUp.x = 405;
						tPowerUp.y = 275;
						tPowerUp.buttonMode = true;
						tPowerUp.addEventListener( MouseEvent.MOUSE_DOWN, endSplitScreen, false, 0, true );
						mGarbage.push( tPowerUp );
						this.addChild( tPowerUp );
						
						/*
						/ now display one of the other 2 power ups
						*/
						var tPowerUpTwo : MovieClip = createPowerUpTwo( );
						tPowerUpTwo.x = 480;
						tPowerUpTwo.y = 275;
						tPowerUpTwo.buttonMode = true;
						tPowerUpTwo.addEventListener( MouseEvent.MOUSE_DOWN, endSplitScreen, false, 0, true );
						mGarbage.push( tPowerUpTwo );
						this.addChild( tPowerUpTwo );						
					}
					
					else
					{
						/*
						/ player doesn't have a power up so create one and display regular power up sensei
						*/					
						var tAmazedStr : String = mGamingSystem.getTranslation( "IDS_POPUP_AMAZED" );											 
						mKougraKarateGame.setText( "displayFont", tPeiMeiAmazed.mMainTextBox, tAmazedStr );
					
						tPowerUp = createPowerUp( );
						tPowerUp.x = 405;
						tPowerUp.y = 275;
						this.addChild( tPowerUp );
					}
					
					tPeiMeiAmazed.x = 90;
					tPeiMeiAmazed.y = 65;
					this.addChild( tPeiMeiAmazed );
					
					break;
										
				case "proud":
					trace( "case proud" );
					var tPeiMeiProud : PeiMeiProud = new PeiMeiProud( );
					
					var tProudStr : String = mGamingSystem.getTranslation( "IDS_POPUP_PROUD" );											 
					mKougraKarateGame.setText( "displayFont", tPeiMeiProud.mMainTextBox, tProudStr );
					
					tPeiMeiProud.x = 90;
					tPeiMeiProud.y = 65;
					this.addChild( tPeiMeiProud );
					
					break;
					
				case "happy":
					trace( "case happy" );
					var tPeiMeiHappy : PeiMeiHappy = new PeiMeiHappy( );
					
					var tHappyStr : String = mGamingSystem.getTranslation( "IDS_POPUP_HAPPY" );											 
					mKougraKarateGame.setText( "displayFont", tPeiMeiHappy.mMainTextBox, tHappyStr );
					
					tPeiMeiHappy.x = 90;
					tPeiMeiHappy.y = 65;
					this.addChild( tPeiMeiHappy );
					
					break;
					
				case "extra life":
					trace( "case extra life" );
					var tPeiMeiSecondChance : PeiMeiMad = new PeiMeiMad( );
					
					var tExtraLifeStr : String = mGamingSystem.getTranslation( "IDS_POPUP_SECOND_CHANCE" );											 
					mKougraKarateGame.setText( "displayFont", tPeiMeiSecondChance.mMainTextBox, tExtraLifeStr );
					
					tPeiMeiSecondChance.x = 90;
					tPeiMeiSecondChance.y = 65;
					this.addChild( tPeiMeiSecondChance );
					
					break;
					
				case "disappointed":
					trace( "case disappointed" );
					var tPeiMeiMad : PeiMeiMad = new PeiMeiMad( );
					
					var tMadStr : String = mGamingSystem.getTranslation( "IDS_POPUP_MAD" );											 
					mKougraKarateGame.setText( "displayFont", tPeiMeiMad.mMainTextBox, tMadStr );
					
					tPeiMeiMad.x = 90;
					tPeiMeiMad.y = 65;
					this.addChild( tPeiMeiMad );
					
					break;
					
				case "time wasted":
					trace( "case time wasted" );
					var tPeiMeiMadTwo : PeiMeiMad = new PeiMeiMad( );
					
					var tMadTimeUpStr : String = mGamingSystem.getTranslation( "IDS_POPUP_MAD" );											 
					mKougraKarateGame.setText( "displayFont", tPeiMeiMadTwo.mMainTextBox, tMadTimeUpStr );
					
					tPeiMeiMadTwo.x = 90;
					tPeiMeiMadTwo.y = 65;
					this.addChild( tPeiMeiMadTwo );
					
					break;
					
				case "hidden stage":
					trace( "hidden stage" );
					var tPeiMeiHiddenStage : PeiMeiProud = new PeiMeiProud( );
					
					var tHiddenStageDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 10 );
					var tHiddenStageStr : String = mGamingSystem.getTranslation( "IDS_POPUP_HIDDEN_STAGE" );											 
					mKougraKarateGame.setText( "displayFont", tHiddenStageDisplay, tHiddenStageStr );
					tPeiMeiHiddenStage.addChild( tHiddenStageDisplay );
					
					tPeiMeiHiddenStage.x = 90;
					tPeiMeiHiddenStage.y = 65;
					this.addChild( tPeiMeiHiddenStage );
					
					break;
					
				case "stage three complete":
					trace( "case stage three complete" );
					var tPeiMeiStageThreeComplete : PeiMeiProud = new PeiMeiProud( );
					
					var tStageThreeCompleteDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 10 );
					var tStageThreeCompleteStr : String = mGamingSystem.getTranslation( "IDS_STAGE_THREE_COMPLETED" );											 
					mKougraKarateGame.setText( "displayFont", tStageThreeCompleteDisplay, tStageThreeCompleteStr );
					tPeiMeiStageThreeComplete.addChild( tStageThreeCompleteDisplay );
					
					tPeiMeiStageThreeComplete.x = 90;
					tPeiMeiStageThreeComplete.y = 65;
					this.addChild( tPeiMeiStageThreeComplete );
					
					break;
					
				case "stage seven complete":
					trace( "case stage seven complete" );
					var tPeiMeiStageSevenComplete : PeiMeiProud = new PeiMeiProud( );
					
					var tStageSevenCompleteDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 10 );
					var tStageSevenCompleteStr : String = mGamingSystem.getTranslation( "IDS_STAGE_SEVEN_COMPLETED" );											 
					mKougraKarateGame.setText( "displayFont", tStageSevenCompleteDisplay, tStageSevenCompleteStr );
					tPeiMeiStageSevenComplete.addChild( tStageSevenCompleteDisplay );
					
					tPeiMeiStageSevenComplete.x = 90;
					tPeiMeiStageSevenComplete.y = 65;
					this.addChild( tPeiMeiStageSevenComplete );
					
					break;
					
				case "game complete":
					trace( "case game complete" );
					var tPeiMeiGameComplete : PeiMeiProud = new PeiMeiProud( );
					
					var tGameCompleteDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 10 );
					var tGameCompleteStr : String = mGamingSystem.getTranslation( "IDS_POPUP_GAME_COMPLETED" );											 
					mKougraKarateGame.setText( "displayFont", tGameCompleteDisplay, tGameCompleteStr );
					tPeiMeiGameComplete.addChild( tGameCompleteDisplay );
					
					tPeiMeiGameComplete.x = 90;
					tPeiMeiGameComplete.y = 65;
					this.addChild( tPeiMeiGameComplete );
					
					break;
					
				case "final stage won":
					trace( "case final stage won" );
					var tPeiMeiFinalStageWon : PeiMeiProud = new PeiMeiProud( );
					
					var tFinalStageWonDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 10 );
					var tFinalStageWonStr : String = mGamingSystem.getTranslation( "IDS_POPUP_FINAL_STAGE_WON" );											 
					mKougraKarateGame.setText( "displayFont", tFinalStageWonDisplay, tFinalStageWonStr );
					tPeiMeiFinalStageWon.addChild( tFinalStageWonDisplay );
					
					tPeiMeiFinalStageWon.x = 90;
					tPeiMeiFinalStageWon.y = 65;
					this.addChild( tPeiMeiFinalStageWon );
					
					break;
					
				case "final stage lost":
					trace( "case final stage lost" );
					var tPeiMeiFinalStageLost : PeiMeiMad = new PeiMeiMad( );
					
					var tFinalStageLostDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 0 );
					var tFinalStageLostStr : String = mGamingSystem.getTranslation( "IDS_POPUP_FINAL_STAGE_LOST" );											 
					mKougraKarateGame.setText( "displayFont", tFinalStageLostDisplay, tFinalStageLostStr );
					tPeiMeiFinalStageLost.addChild( tFinalStageLostDisplay );
					
					tPeiMeiFinalStageLost.x = 90;
					tPeiMeiFinalStageLost.y = 65;
					this.addChild( tPeiMeiFinalStageLost );
					
					break;
					
				case "emperor asleep":
					trace( "case emperor asleep" );
					var tPeiMeiEmperorAsleep : PeiMeiMad = new PeiMeiMad( );
					
					var tEmperorAsleepDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 300, 300, 10, 0 );
					var tEmperorAsleepStr : String = mGamingSystem.getTranslation( "IDS_POPUP_EMPEROR_ASLEEP" );											 
					mKougraKarateGame.setText( "displayFont", tEmperorAsleepDisplay, tEmperorAsleepStr );
					tPeiMeiEmperorAsleep.addChild( tEmperorAsleepDisplay );
					
					tPeiMeiEmperorAsleep.x = 90;
					tPeiMeiEmperorAsleep.y = 65;
					this.addChild( tPeiMeiEmperorAsleep );
					
					break;
			}
			
			if( GameVars.mSenseiStatus == "hidden stage" || GameVars.mSenseiStatus == "stage three complete" || GameVars.mSenseiStatus == "stage seven complete" || GameVars.mSenseiStatus == "game complete" )
			{
				this.addEventListener( Event.ENTER_FRAME, moveMeUp, false, 0, true );
			}
			
			else
			{			
				/*
				/ add score breakdown here because it appears on every split screen
				/ start with time bonus text
				*/
				var tTimeBonusTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 120, 30, 150, 225 );			
				var tTimeBonusText : String = mGamingSystem.getTranslation( "IDS_TIME_BONUS" );
				mKougraKarateGame.setText( "displayFont", tTimeBonusTextDisplay, tTimeBonusText );			
				this.addChild( tTimeBonusTextDisplay );	
					
				/*
				/ time bonus digits
				*/
				var tTimeBonusDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 80, 30, 270, 225 );			
				var tTimeBonus : String = mGamingSystem.getTranslation("IDS_BONUS_OPEN") + 
									      GameVars.mTimeBonus.toString( ) + 
									      mGamingSystem.getTranslation("IDS_BONUS_CLOSE");
				mKougraKarateGame.setText( "displayFont", tTimeBonusDisplay, tTimeBonus );			
				this.addChild( tTimeBonusDisplay );
				
				/*
				/ center hit bonus text
				*/
				var tCenterBonusTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 180, 30, 90, 250 );			
				var tCenterBonusText : String = mGamingSystem.getTranslation( "IDS_CENTER_BONUS" );
				mKougraKarateGame.setText( "displayFont", tCenterBonusTextDisplay, tCenterBonusText );			
				this.addChild( tCenterBonusTextDisplay );	
					
				/*
				/ center hit bonus digits
				*/
				var tCenterBonusDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 80, 30, 270, 250 );			
				var tCenterBonus : String = mGamingSystem.getTranslation("IDS_BONUS_OPEN") + 
									        GameVars.mCenterHitBonus.toString( ) + 
									        mGamingSystem.getTranslation("IDS_BONUS_CLOSE");
				mKougraKarateGame.setText( "displayFont", tCenterBonusDisplay, tCenterBonus );
				this.addChild( tCenterBonusDisplay );
				
				/*
				/ current score text
				*/
				var tCurrentScoreTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 180, 30, 90, 275 );			
				var tCurrentScoreText : String = mGamingSystem.getTranslation( "IDS_CURRENT_SCORE" );
				mKougraKarateGame.setText( "displayFont", tCurrentScoreTextDisplay, tCurrentScoreText );			
				this.addChild( tCurrentScoreTextDisplay );	
					
				/*
				/ current score digits
				*/
				var tCurrentScoreDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 80, 30, 270, 275 );			
				var tCurrentScore : String = mGamingSystem.getTranslation("IDS_BONUS_OPEN") + 
									         GameVars.mGameScore.show( ) + 
									         mGamingSystem.getTranslation("IDS_BONUS_CLOSE");
				mKougraKarateGame.setText( "displayFont", tCurrentScoreDisplay, tCurrentScore );
				this.addChild( tCurrentScoreDisplay );		
				
				this.addEventListener( Event.ENTER_FRAME, moveMeUp, false, 0, true );
			}
			
		} // end doAnimation
		
		//===============================================================================
		//  function moveMeUp( ):
		//===============================================================================
		private function moveMeUp( evt : Event ) : void
		{
			if( this.y > 100 )
			{
				this.y -= 30;
			}
			
			else
			{
				this.removeEventListener( Event.ENTER_FRAME, moveMeUp );
				
				if( mTwoPowerUps )
				{					
					/*
					/ if 2 power ups are displayed in pop up, continue button must not be displayed because
					/ powerups themselves are registered for the click event
					/ set mTwoPowerUps to false again so if user uses power up, continue
					/ button will be displayed on next split screen
					*/
					mTwoPowerUps = false;
				}
				
				else
				{					
					GameVars.mContinueButton = new CenterAlignedButton( );		
					var tContButtonStr : String = mGamingSystem.getTranslation("IDS_CONTINUE");											 
					mKougraKarateGame.setText( "displayFont", GameVars.mContinueButton.text_txt, tContButtonStr );
					GameVars.mContinueButton.x = 460;
					GameVars.mContinueButton.y = 275;
					GameVars.mContinueButton.scaleX = .7;
					GameVars.mContinueButton.scaleY = .7;
					GameVars.mContinueButton.addEventListener( MouseEvent.MOUSE_DOWN, endSplitScreen, false, 0, true );
					mGarbage.push( GameVars.mContinueButton );
					this.addChild( GameVars.mContinueButton );
				}
			}
			
		} //end moveMeUp
		
		//===============================================================================
		//  function endSplitScreen( ):
		//===============================================================================
		private function endSplitScreen( evt : Event ) : void
		{
			trace( "endSplitScreen in " + this + " called" );
			
			/*
			/ check if clicked object was a power up icon. if it was, check which power up 
			/ player chose and set GameVars.mPowerUpTracker accordingly so that correct 
			/ power up is displayed in game. if it was not a power up then it must have been
			/ the continue button. regardless of what the clicked object was, the event
			/ listener and the object itself will be removed
			*/
			var tClickedObject : MovieClip = evt.target as MovieClip;
			trace( "tClickedPowerUp: " + tClickedObject );
			
			if( tClickedObject is PowerUpOne )
			{
				trace( "PowerUpOne chosen" );
				GameVars.mPowerUpTracker = "One";
			}
			
			else if( tClickedObject is PowerUpTwo )
			{
				trace( "PowerUpTwo chosen" );
				GameVars.mPowerUpTracker = "Two";
			}
			
			else if( tClickedObject is PowerUpThree )
			{
				trace( "PowerUpThree chosen" );
				GameVars.mPowerUpTracker = "Three";
			}
				
			for( var i : int = mGarbage.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = mGarbage[ i ];
				
				if( tCurrentObject.hasEventListener( MouseEvent.MOUSE_DOWN ) )
				{
					tCurrentObject.removeEventListener( MouseEvent.MOUSE_DOWN, endSplitScreen );
				}
				
				if( tCurrentObject.parent != null )
				{
					tCurrentObject.parent.removeChild( tCurrentObject );
					tCurrentObject = null;					
				}
			}
			
			mGarbage = new Array( );
			
			this.addEventListener( Event.ENTER_FRAME, moveMeDown, false, 0, true );
						
		} //end endSplitScreen
		
		//===============================================================================
		//  function moveMeDown( ):
		//===============================================================================
		private function moveMeDown( evt : Event ) : void
		{
			if( this.y < 800 )
			{
				this.y += 30;
			}
			
			else
			{
				this.removeEventListener( Event.ENTER_FRAME, moveMeDown );
				
				if( GameVars.mSenseiStatus == "hidden stage" || GameVars.mSenseiStatus == "stage three complete" || GameVars.mSenseiStatus == "stage seven complete" || GameVars.mSenseiStatus == "game complete" )
				{
					dispatchEvent( new Event( SPECIAL_STAGE_ANIMATION_DONE ) );
				}
				
				else
				{
					dispatchEvent( new Event( SPLIT_SCREEN_ANIMATION_DONE ) );			
				}
			}
			
		} //end moveMeDown
		
		//===============================================================================
		// FUNCTION createPowerUp( ):    
		//===============================================================================
		private function createPowerUp( ) : MovieClip
		{
			/*
			/ player won power up without having an unused one so set
			/ GameVars.mHasPowerUp to true
			*/
			GameVars.mHasPowerUp = true;
			
			/*
			/ randomly create one of the 3 power ups. it will be displayed in the
			/ split screen animation
			/ set mPowerUpTracker to the appropriate power up so it can be tracked
			/ in game play
			*/			
			var tPowerUpDecider : Number = Math.floor( Math.random( ) * 3 );
			var tPowerUp        : MovieClip;
			trace( "tPowerUpDecider: " + tPowerUpDecider );
			
			switch( tPowerUpDecider )
			{
				case 0:
					tPowerUp = new PowerUpOne( );
					GameVars.mPowerUpTracker = "One";
					break;
					
				case 1:
					tPowerUp = new PowerUpTwo( );
					GameVars.mPowerUpTracker = "Two";
					break;
					
				case 2:
					tPowerUp = new PowerUpThree( );
					GameVars.mPowerUpTracker = "Three";
					break;
			}
			
			tPowerUp.scaleX = .3;
			tPowerUp.scaleY = .3;
			return tPowerUp;
			
		} // end createPowerUp
		
		//===============================================================================
		// FUNCTION createPowerUpTwo( ):    
		//===============================================================================
		private function createPowerUpTwo( ) : MovieClip
		{			
			/*
			/ randomly create one of the 2 power ups the user does not have so check which one he
			/ has, then chose one of the other 2
			*/
			
			var tPowerUpDecider : Number = Math.floor( Math.random( ) * 2 );
			var tPowerUp        : MovieClip;
			trace( "tPowerUpDecider: " + tPowerUpDecider );
			
			switch( GameVars.mPowerUpTracker )
			{
				case "One":
					switch( tPowerUpDecider )
					{
						case 0:
							tPowerUp = new PowerUpTwo( );
							break;
						
						case 1:
							tPowerUp = new PowerUpThree( );
							break;							
					}
					break;
					
				case "Two":
					switch( tPowerUpDecider )
					{
						case 0:
							tPowerUp = new PowerUpOne( );
							break;
						
						case 1:
							tPowerUp = new PowerUpThree( );
							break;							
					}
					break;
					
				case "Three":
					switch( tPowerUpDecider )
					{
						case 0:
							tPowerUp = new PowerUpOne( );
							break;
						
						case 1:
							tPowerUp = new PowerUpTwo( );
							break;							
					}
					break;
			}
			
			tPowerUp.scaleX = .3;
			tPowerUp.scaleY = .3;
			return tPowerUp;
			
		} // end createPowerUpTwo
		
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