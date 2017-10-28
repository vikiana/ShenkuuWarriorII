package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextFormat;	

	public class Scoreboard extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================	
		private var mGamingSystem     : MovieClip;
		private var mKougraKarateGame : KougraKarateGame;	
		private var mStage            : Stage;
		private var mPowerUpGarbage   : Array;
		
		//===============================================================================
		// CONSTRUCTOR Scoreboard
		//===============================================================================
		public function Scoreboard( )
		{
			super( );
			setupVars( );
		
		} // end constructor
		
		//===============================================================================
		// FUNCTION init  
		//===============================================================================
		internal function init( pGamingSystem : MovieClip, pKougraKarateGame : KougraKarateGame, pStage : Stage ) : void
		{	
			trace( "init in Scoreboard called" );
			
			mGamingSystem     = pGamingSystem;
			mKougraKarateGame = pKougraKarateGame;
			
			mStage = pStage;
			
			addElements( );
			
		} // end function init
		
		//===============================================================================
		// FUNCTION addElements
		//===============================================================================
		internal function addElements( ) : void
		{
			//=======================================
			// power up frame
			//=======================================
			GameVars.mPowerUpFrame = new GenericFrame( );
			GameVars.mPowerUpFrame.x = 370;
			GameVars.mPowerUpFrame.y = 445;
			GameVars.mGameOverGarbage.push( GameVars.mPowerUpFrame );
			this.addChild( GameVars.mPowerUpFrame );
			
			//=======================================
			// power up dummies
			//=======================================
			GameVars.mDummyPowerUpOne = new DummyPowerUpOne( );
			GameVars.mDummyPowerUpOne.x = 30;
			GameVars.mDummyPowerUpOne.y = 20;
			GameVars.mDummyPowerUpOne.scaleX = .25;
			GameVars.mDummyPowerUpOne.scaleY = .25;
			GameVars.mDummyPowerUpOne.alpha = .8;
			GameVars.mPowerUpFrame.addChild( GameVars.mDummyPowerUpOne );
			GameVars.mGameOverGarbage.push( GameVars.mDummyPowerUpOne );
			
			GameVars.mDummyPowerUpTwo = new DummyPowerUpTwo( );
			GameVars.mDummyPowerUpTwo.x = 80;
			GameVars.mDummyPowerUpTwo.y = 20;
			GameVars.mDummyPowerUpTwo.scaleX = .25;
			GameVars.mDummyPowerUpTwo.scaleY = .25;
			GameVars.mDummyPowerUpTwo.alpha = .8;
			GameVars.mPowerUpFrame.addChild( GameVars.mDummyPowerUpTwo );
			GameVars.mGameOverGarbage.push( GameVars.mDummyPowerUpTwo );
			
			GameVars.mDummyPowerUpThree = new DummyPowerUpThree( );
			GameVars.mDummyPowerUpThree.x = 130;
			GameVars.mDummyPowerUpThree.y = 20;
			GameVars.mDummyPowerUpThree.scaleX = .25;
			GameVars.mDummyPowerUpThree.scaleY = .25;
			GameVars.mDummyPowerUpThree.alpha = .8;
			GameVars.mPowerUpFrame.addChild( GameVars.mDummyPowerUpThree );
			GameVars.mGameOverGarbage.push( GameVars.mDummyPowerUpThree );
			
			//=======================================
			// score display
			//=======================================			
			GameVars.mScoreTextDisplay  = new GenericTextField( "displayFont", "right", 0xFFFFFF, 20, 60, 30, 85, 48 );
			var tScoreText : String = mGamingSystem.getTranslation( "IDS_SCORE_TEXT" );
			mKougraKarateGame.setText( "displayFont", GameVars.mScoreTextDisplay, tScoreText );
			this.addChild( GameVars.mScoreTextDisplay );
			GameVars.mGameOverGarbage.push( GameVars.mScoreTextDisplay );
			
			GameVars.mScoreDisplay = new GenericTextField( "displayFont", "right", 0xFFFFFF, 20, 60, 30, 145, 48 );
			this.addChild( GameVars.mScoreDisplay );
			GameVars.mGameOverGarbage.push( GameVars.mScoreDisplay );
			updateScoreDisplay( );	
			
			//=======================================
			// end game button
			//=======================================	
			GameVars.mEndGameButton   = new EndGameBtn( );
			GameVars.mEndGameButton.x = 94;
			GameVars.mEndGameButton.y = 86;	
			var tEndGameBtnStr : String = mGamingSystem.getTranslation("IDS_END_GAME");
										 
			mKougraKarateGame.setText( "displayFont", GameVars.mEndGameButton.text_txt, tEndGameBtnStr );			
			
			GameVars.mEndGameButton.buttonMode = true;
			GameVars.mEndGameButton.addEventListener( MouseEvent.MOUSE_DOWN, quitGame, false, 0, true );
			this.addChild( GameVars.mEndGameButton );
			GameVars.mGameOverGarbage.push( GameVars.mEndGameButton );
		}
		
		//===============================================================================
		// FUNCTION updateScoreDisplay 
		//          - updates the score display
		//===============================================================================
		internal function updateScoreDisplay( ) : void
		{
			trace( "GameVars.mGameScore.show " + GameVars.mGameScore.show( ) );
						
			if( GameVars.mGameScore.show( ) > GameVars.mMaxScore )
			{
				GameVars.mGameScore.changeTo( GameVars.mMaxScore );
			}
						
			var tScore : String = mGamingSystem.getTranslation("IDS_SCORE_OPEN") + 
								  GameVars.mGameScore.show( ) + 
								  mGamingSystem.getTranslation("IDS_SCORE_CLOSE");
								  
			mKougraKarateGame.setText( "displayFont", GameVars.mScoreDisplay, tScore );
							
		} // end updateScoreDisplay
		
		//===============================================================================
		// FUNCTION checkPowerUp 
		//          - called from KougraKarateGame to check if player earned power up
		//            if they did, then power up is displayed and activated
		//===============================================================================
		internal function checkPowerUp( ) : void
		{
			trace( "checkPowerUp in " + this + " called" );
			
			/*
			/ since function is called at beginning of every stage, check if player has even
			/ won a power up by checking GameVars.mHasPowerUp. if not, skip. 
			/ if they have, remove any previous power up, then create, activate and display new one
			*/
			if( GameVars.mHasPowerUp )
			{
				removePowerUp( );
				
				switch( GameVars.mPowerUpTracker )
				{
					case "One":
						GameVars.mPowerUpOne = new PowerUpOne( );
						GameVars.mPowerUpOne.x = 30;
						GameVars.mPowerUpOne.y = 20;
						GameVars.mPowerUpOne.scaleX = .25;
						GameVars.mPowerUpOne.scaleY = .25;
						GameVars.mPowerUpOne.buttonMode = true;
						GameVars.mPowerUpOne.addEventListener( MouseEvent.CLICK, extraLife, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpOne );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpOne );
						/*GameVars.mPowerUpTwo = new PowerUpTwo( );
						GameVars.mPowerUpTwo.x = 80;
						GameVars.mPowerUpTwo.y = 20;
						GameVars.mPowerUpTwo.scaleX = .25;
						GameVars.mPowerUpTwo.scaleY = .25;
						GameVars.mPowerUpTwo.buttonMode = true;
						GameVars.mPowerUpTwo.addEventListener( MouseEvent.CLICK, increaseSweetspot, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpTwo );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpTwo );*/
						/*GameVars.mPowerUpThree = new PowerUpThree( );
						GameVars.mPowerUpThree.x = 130;
						GameVars.mPowerUpThree.y = 20;
						GameVars.mPowerUpThree.scaleX = .25;
						GameVars.mPowerUpThree.scaleY = .25;
						GameVars.mPowerUpThree.buttonMode = true;
						GameVars.mPowerUpThree.addEventListener( MouseEvent.CLICK, slowSlider, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpThree );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpThree );*/
						break;
						
					case "Two":
						/*GameVars.mPowerUpOne = new PowerUpOne( );
						GameVars.mPowerUpOne.x = 30;
						GameVars.mPowerUpOne.y = 20;
						GameVars.mPowerUpOne.scaleX = .25;
						GameVars.mPowerUpOne.scaleY = .25;
						GameVars.mPowerUpOne.buttonMode = true;
						GameVars.mPowerUpOne.addEventListener( MouseEvent.CLICK, extraLife, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpOne );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpOne );*/		
						GameVars.mPowerUpTwo = new PowerUpTwo( );
						GameVars.mPowerUpTwo.x = 80;
						GameVars.mPowerUpTwo.y = 20;
						GameVars.mPowerUpTwo.scaleX = .25;
						GameVars.mPowerUpTwo.scaleY = .25;
						GameVars.mPowerUpTwo.buttonMode = true;
						GameVars.mPowerUpTwo.addEventListener( MouseEvent.CLICK, increaseSweetspot, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpTwo );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpTwo );
						/*GameVars.mPowerUpThree = new PowerUpThree( );
						GameVars.mPowerUpThree.x = 130;
						GameVars.mPowerUpThree.y = 20;
						GameVars.mPowerUpThree.scaleX = .25;
						GameVars.mPowerUpThree.scaleY = .25;
						GameVars.mPowerUpThree.buttonMode = true;
						GameVars.mPowerUpThree.addEventListener( MouseEvent.CLICK, slowSlider, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpThree );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpThree );*/
						break;
						
					case "Three":
						/*GameVars.mPowerUpOne = new PowerUpOne( );
						GameVars.mPowerUpOne.x = 30;
						GameVars.mPowerUpOne.y = 20;
						GameVars.mPowerUpOne.scaleX = .25;
						GameVars.mPowerUpOne.scaleY = .25;
						GameVars.mPowerUpOne.buttonMode = true;
						GameVars.mPowerUpOne.addEventListener( MouseEvent.CLICK, extraLife, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpOne );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpOne );*/
						/*GameVars.mPowerUpTwo = new PowerUpTwo( );
						GameVars.mPowerUpTwo.x = 80;
						GameVars.mPowerUpTwo.y = 20;
						GameVars.mPowerUpTwo.scaleX = .25;
						GameVars.mPowerUpTwo.scaleY = .25;
						GameVars.mPowerUpTwo.buttonMode = true;
						GameVars.mPowerUpTwo.addEventListener( MouseEvent.CLICK, increaseSweetspot, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpTwo );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpTwo );*/
						GameVars.mPowerUpThree = new PowerUpThree( );
						GameVars.mPowerUpThree.x = 130;
						GameVars.mPowerUpThree.y = 20;
						GameVars.mPowerUpThree.scaleX = .25;
						GameVars.mPowerUpThree.scaleY = .25;
						GameVars.mPowerUpThree.buttonMode = true;
						GameVars.mPowerUpThree.addEventListener( MouseEvent.CLICK, slowSlider, false, 0, true );
						mPowerUpGarbage.push( GameVars.mPowerUpThree );
						GameVars.mPowerUpFrame.addChild( GameVars.mPowerUpThree );
						break;
					
					default:
						break;
				}
			}
			
		} // end checkPowerUp
		
		//===============================================================================
		// FUNCTION extraLife
		//===============================================================================
		internal function extraLife( evt : MouseEvent ) : void
		{
			trace( "extraLife called" );
			
			/*
			/ check GameVars.mGameOn so that player can't use power up after they have
			/ hit the space bar/time is up
			*/
			if( GameVars.mGameOn )
			{
				if( GameVars.mPowerUpOne.hasEventListener( MouseEvent.CLICK ) )
				{
					GameVars.mPowerUpOne.removeEventListener( MouseEvent.CLICK, extraLife );
				}
				removePowerUp( );
				GameVars.mPowerUpTracker = "";
				GameVars.mHasExtraLife = true;
				
				GameVars.mHasPowerUp = false;
				
				mStage.focus = mStage;
			}
			
		} // end extraLife
		
		//===============================================================================
		// FUNCTION increaseSweetspot
		//===============================================================================
		internal function increaseSweetspot( evt : MouseEvent ) : void
		{
			trace( "increaseSweetspot called" );
			
			/*
			/ check GameVars.mGameOn so that player can't use power up after they have
			/ hit the space bar/time is up
			*/
			if( GameVars.mGameOn )
			{
				if( GameVars.mPowerUpTwo.hasEventListener( MouseEvent.CLICK ) )
				{
					GameVars.mPowerUpTwo.removeEventListener( MouseEvent.CLICK, increaseSweetspot );
				}
				removePowerUp( );
				
				GameVars.mPowerUpTracker = "";
				
				GameVars.mMeter.updateSafeZoneSize( );
				
				GameVars.mHasPowerUp = false;
				
				mStage.focus = mStage;
			}
			
		} // end increaseSweetspot
		
		//===============================================================================
		// FUNCTION slowSlider
		//===============================================================================
		internal function slowSlider( evt : MouseEvent ) : void
		{
			trace( "slowSlider called" );
			
			/*
			/ check GameVars.mGameOn so that player can't use power up after they have
			/ hit the space bar/time is up
			*/
			if( GameVars.mGameOn )
			{
				if( GameVars.mPowerUpThree.hasEventListener( MouseEvent.CLICK ) )
				{
					GameVars.mPowerUpThree.removeEventListener( MouseEvent.CLICK, slowSlider );
				}
				removePowerUp( );
				
				GameVars.mPowerUpTracker = "";
				
				GameVars.mSlider.updateSliderSpeed( );
				
				GameVars.mHasPowerUp = false;
				
				mStage.focus = mStage;
			}
			
		} // end slowSlider
		
		//===============================================================================
		// FUNCTION removePowerUp
		//          - removes any power ups that user may have had
		//===============================================================================
		internal function removePowerUp( ) : void
		{
			for( var i : int = mPowerUpGarbage.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = mPowerUpGarbage[ i ];
				
				if( tCurrentObject.parent != null )
				{
					tCurrentObject.parent.removeChild( tCurrentObject );
					tCurrentObject = null;					
				}
			}
			
			mPowerUpGarbage = new Array( );
			
		} // end removePowerUp
		
		//===============================================================================
		// FUNCTION quitGame
		//          - dummy function that calls endGame, so endGame doesn't need to have
		//            a mouse event passed
		//===============================================================================
		private function quitGame( evt : MouseEvent ) : void
		{
			trace( "quitGame in Scoreboard called" );
			mKougraKarateGame.endGame( );
			
		} // end quitGame
		
		//===============================================================================
		// FUNCTION setEndGameButtonState
		//          - activate/deactivete GameVars.mEndGameButton from 
		//            KougraKarateGame
		//===============================================================================
		internal function setEndGameButtonState( pState : String ) : void
		{
			switch( pState )
			{
				case "deactivate":
					if( GameVars.mEndGameButton.hasEventListener( MouseEvent.MOUSE_DOWN ) )
					{
						GameVars.mEndGameButton.removeEventListener( MouseEvent.MOUSE_DOWN, quitGame );
					}
					break;
				
				case "activate":
					GameVars.mEndGameButton.addEventListener( MouseEvent.MOUSE_DOWN, quitGame, false, 0, true );
					break;				
			}
			
		} // end setEndGameButtonState
		
		//===============================================================================
		// FUNCTION setupVars 
		//          - assigns vars
		//===============================================================================
		private function setupVars( ) : void
		{
			mPowerUpGarbage = new Array( );
			
		} // end setupVars
		
	} // end class
	
} // end package