package com.neopets.games.inhouse.TopChop
{	
	//===================================================================
	// imports
	//===================================================================
	import com.neopets.util.events.*;
	import com.neopets.util.sound.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.SharedObject;
	import flash.system.ApplicationDomain;
	import flash.text.*;
	
	import gamingsystem.np9.game.NP9_Generic_Game;
	
	public class GameMenu extends NP9_Generic_Game
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mKougraKarateGame : KougraKarateGame;	
		
		private var mMainBG         : BGMain;
		private var mInstructionsBG : BGInstructions;
		private var mGameOverBG     : BGGameOver;
		private var mStageScreenBG  : BGStageScreen;
		
		private var mStartButton        : CenterAlignedButton;
		private var mInstructionsButton : CenterAlignedButton;
		private var mBackButton         : CenterAlignedButton;
		private var mMoreButton         : CenterAlignedButton;
		private var mPlayAgainButton    : CenterAlignedButton;
		
		//=======================================
		// back end stuff
		//=======================================
		private var mImageServer   : String;
		private var mAssetBaseURL  : String;
		private var mGamingSystem  : MovieClip;
		
		//=======================================
		// sounds and music
		//=======================================	
		private var mSoundManager : SoundManagerOld;
		//private var mMusicOn	  : Boolean;
		//private var mSoundOn	  : Boolean;
		private var mBgMusic	  : String;
		private var mSoundButton  : SoundButton;
		private var mMusicButton  : MusicButton;
		
		private static var mGarbageArr : Array;
				
		private var mMyLang   : String;
		
		private static var mTopChopSharedListener : TopChopSharedListener;
		
		//===============================================================================
		// CONSTRUCTOR GameMenu
		//         -
		//===============================================================================
		public function GameMenu( objDocumentClass : Object )
		{
			super( objDocumentClass );
			
			_ROOT.stage.frameRate = 24;
			
			setupVars( );
			
			// display text font - decorative, for buttons, headlines, etc.
			mGamingSystem.addFont( new DisplayFont( ), "displayFont" );
			
			// body text font - for instructions, smaller text, etc.
			mGamingSystem.addFont( new BodyFont( ), "bodyFont" );
			
			mTopChopSharedListener = new TopChopSharedListener( );
			mTopChopSharedListener.addEventListener( mTopChopSharedListener.GAME_OVER_SCREEN, createGameOverMenu, false, 0, true );
			
			//=======================================
			// instantiate sound
			//=======================================
			mSoundManager = new SoundManagerOld ( mTopChopSharedListener );
			loadSounds( );
			
			GameVars.mSoundOn      = true;
			GameVars.mMusicOn      = true;
			
			//=======================================
			// retrieve user data
			//=======================================
			GameVars.mSharedObject = SharedObject.getLocal( "userData1095" );
			
			var tUser : String = mGamingSystem.getFlashParam( "sUsername" );
			
			if ( !GameVars.mSharedObject.data[ tUser ] ) 
			{
				GameVars.mSharedObject.data[ tUser ] = new Object( );
				GameVars.mSharedObject.data[ tUser ].username = mGamingSystem.getFlashParam( "sUsername" );
				GameVars.mSharedObject.data[ tUser ].unlockedStage = new int( 1 );
				GameVars.mSharedObject.flush( );
			}
			
			else 
			{
				if ( !GameVars.mSharedObject.data[ tUser ].username )
				{
					GameVars.mSharedObject.data[ tUser ].username = mGamingSystem.getFlashParam( "sUsername" );
				}
					
				if ( !GameVars.mSharedObject.data[ tUser ].unlockedStage )
				{
					GameVars.mSharedObject.data[ tUser ].unlockedStage = new int( 1 );					
				}				
			}
			//GameVars.mSharedObject.data[ tUser ].unlockedStage = new int( 12 );
			//GameVars.mSharedObject.flush( );
			GameVars.mUserName      = GameVars.mSharedObject.data[ tUser ].username;
			GameVars.mUnlockedStage = GameVars.mSharedObject.data[ tUser ].unlockedStage;
			
			trace( "mUserName: " + GameVars.mUserName );
			trace( "mUnlockedStage: " + GameVars.mUnlockedStage );
			
			createMainMenu( );
			
		} // end constructor function GameMenu		
		
		//===============================================================================
		// FUNCTION createMainMenu
		//===============================================================================
		internal function createMainMenu( ):void
		{			
			if( mGarbageArr != null )
			{
				clearMenu( );
			}
								
			/*
			/ set GameVars.mGameOn to false to avoid cricket animation and timer to run when game is restarted
			/ may not be necessary but just to make sure...
			*/
			GameVars.mGameOn = false;
			
			addChild( mMainBG );
			mMyLang = mGamingSystem.getFlashParam( "sLang" );
			mMainBG.logo.gotoAndStop( mMyLang );
			
			//var tLegalText : String = mGamingSystem.getTranslation( "IDS_LEGAL" );
			//setText( "bodyFont", mMainBG.test, mGamingSystem.getTranslation("IDS_LEGAL") );
			
			var tLegalTextDisplay = new GenericTextField( "bodyFont", "left", 0xFFFFFF, 20, 200, 25, 25, 560 );			
			var tLegalText : String = mGamingSystem.getTranslation( "IDS_LEGAL" );
			setText( "bodyFont", tLegalTextDisplay, tLegalText );			
			mMainBG.addChild( tLegalTextDisplay );
			mGarbageArr.push( tLegalTextDisplay );
			
			mGarbageArr.push( mMainBG );
			
			//=======================================
			// attach start button
			//=======================================
			mStartButton = new CenterAlignedButton( );
			addChild( mStartButton );
			mStartButton.buttonMode = true;
			
			var tStartStr : String = mGamingSystem.getTranslation("IDS_BUTTON_HTML_OPEN") + 
									 mGamingSystem.getTranslation("FGS_MAIN_MENU_START_GAME") + 
									 mGamingSystem.getTranslation("IDS_BUTTON_HTML_CLOSE");
									 
			setText( "displayFont", mStartButton.text_txt, tStartStr );
			
			mStartButton.x = 450;
			mStartButton.y = 350;
			mStartButton.addEventListener( MouseEvent.MOUSE_DOWN, createStageSelectionMenu, false, 0, true );
			mGarbageArr.push( mStartButton );
			
			//=======================================
			// attach instructions button
			//=======================================
			mInstructionsButton = new CenterAlignedButton( );
			addChild( mInstructionsButton );
			mInstructionsButton.buttonMode = true;
					
			var tInstrStr : String = mGamingSystem.getTranslation("IDS_BUTTON_HTML_OPEN") + 
									 mGamingSystem.getTranslation("IDS_INSTRUCTIONS") + 
									 mGamingSystem.getTranslation("IDS_BUTTON_HTML_CLOSE");
					
			setText( "displayFont", mInstructionsButton.text_txt, tInstrStr );
			
			mInstructionsButton.x = 450;
			mInstructionsButton.y = 420;
			mInstructionsButton.addEventListener( MouseEvent.MOUSE_DOWN, createInstructionsMenu, false, 0, true );
			mGarbageArr.push( mInstructionsButton );
					
			//=======================================
			// attach sound button
			//=======================================
			mSoundButton = new SoundButton( );
			mSoundButton.buttonMode = true;
			mSoundButton.x = 490;
			mSoundButton.y = 540;			
			mSoundButton.gotoAndStop( getSoundBtnState( ) );
			mSoundButton.addEventListener( MouseEvent.MOUSE_DOWN, soundBtnClicked, false, 0, true );
			addChild( mSoundButton );
			mGarbageArr.push( mSoundButton );
			
			//=======================================
			// attach music button
			//=======================================
			mMusicButton = new MusicButton( );
			mMusicButton.buttonMode = true;
			mMusicButton.x = 570;
			mMusicButton.y = 540;
			mMusicButton.gotoAndStop( getMusicBtnState( ) );			
			mMusicButton.addEventListener( MouseEvent.MOUSE_DOWN, musicBtnClicked, false, 0, true );
			addChild( mMusicButton );
			mGarbageArr.push( mMusicButton );
			
		} // end function createGameMenu
		
		//===============================================================================
		// FUNCTION soundButtonClicked
		//          - toggles state of sound button    
		//===============================================================================
		public function soundBtnClicked( evt : MouseEvent ):void 
		{
			//var tSoundButton : SoundButton = evt.target as SoundButton;
			//trace( "tSoundButton: " + tSoundButton );
			playSound( "BtnClick", GameVars.mSoundOn );
			
			GameVars.mSoundOn ? GameVars.mSoundOn = false : GameVars.mSoundOn = true;
			trace( "mSoundOn: " + GameVars.mSoundOn );
			
			if ( GameVars.mSoundOn ) 
			{
				mSoundButton.gotoAndStop( "on" );
			}
			
			else 
			{
				mSoundButton.gotoAndStop( "off" );
			}
			
		} // end soundButtonClicked
		
		//===============================================================================
		// FUNCTION getSoundBtnState
		//          - checks state of button and returns it as string
		//===============================================================================
		public function getSoundBtnState( ) : String 
		{
			var tSoundBtnState : String = new String;
			
			if( GameVars.mSoundOn )
			{
				tSoundBtnState = "on";
			}
			
			else
			{
				tSoundBtnState = "off";
			}
			
			return tSoundBtnState;
			
		} // end getSoundBtnState
		
		//===============================================================================
		// FUNCTION musicBtnClicked
		//          - toggles state of music button    
		//===============================================================================
		public function musicBtnClicked( evt : MouseEvent ):void 
		{
			//var tSoundButton : SoundButton = evt.target as SoundButton;
			//trace( "tSoundButton: " + tSoundButton );
			playSound( "BtnClick", GameVars.mSoundOn );
			
			GameVars.mMusicOn ? GameVars.mMusicOn = false : GameVars.mMusicOn = true;
			trace( "mMusicOn: " + GameVars.mMusicOn );
			
			if ( GameVars.mMusicOn ) 
			{
				mMusicButton.gotoAndStop( "on" );
			}
			
			else 
			{
				mMusicButton.gotoAndStop( "off" );
			}
			
		} // end musicBtnClicked
		
		//===============================================================================
		// FUNCTION getMusicBtnState
		//          - checks state of button and returns it as string
		//===============================================================================
		public function getMusicBtnState( ) : String 
		{
			var tMusicBtnState : String = new String;
			
			if( GameVars.mMusicOn )
			{
				tMusicBtnState = "on";
			}
			
			else
			{
				tMusicBtnState = "off";
			}
			
			return tMusicBtnState;
			
		} // end getMusicBtnState
		
		//===============================================================================
		// FUNCTION createStageSelectionMenu
		//          - called from mStartButton 
		//===============================================================================
		private function createStageSelectionMenu( evt : MouseEvent ):void
		{
			trace( "createStageSelectionMenu in GameMenu called" );	
			
			if( mGarbageArr.length > 0 )
			{
				clearMenu( );
			}
			
			addChild( mStageScreenBG );
			mGarbageArr.push( mStageScreenBG );
			
			var tCourtyardHeader = new GenericTextField( "displayFont", "left", 0xFFFFFF, 20, 160, 40, 250, 112 );			
			var tCourtyardText : String = mGamingSystem.getTranslation( "IDS_COURTYARD_HEADER" );
			setText( "displayFont", tCourtyardHeader, tCourtyardText );			
			addChild( tCourtyardHeader );
			mGarbageArr.push( tCourtyardHeader );
			
			var tImperialDojoHeader = new GenericTextField( "displayFont", "left", 0xFFFFFF, 20, 280, 40, 190, 255 );			
			var tImperialDojoText : String = mGamingSystem.getTranslation( "IDS_IMPERIAL_DOJO_HEADER" );
			setText( "displayFont", tImperialDojoHeader, tImperialDojoText );			
			addChild( tImperialDojoHeader );
			mGarbageArr.push( tImperialDojoHeader );
			
			var tEmperorHallHeader = new GenericTextField( "displayFont", "left", 0xFFFFFF, 20, 300, 40, 185, 395 );			
			var tEmperorHallText : String = mGamingSystem.getTranslation( "IDS_EMPEROR_HALL_HEADER" );
			setText( "displayFont", tEmperorHallHeader, tEmperorHallText );			
			addChild( tEmperorHallHeader );
			mGarbageArr.push( tEmperorHallHeader );
			
			var tColumn                : int;
			var tRow                   : int;
			var tLevelButton           : LevelButtonFrame;
			var LevelButtonInsideClass : Class;
			
			for( tColumn = 0; tColumn < 3; tColumn++ )
			{
				if( tColumn == 0 )
				{
					for( var tRowOne : int  = 0; tRowOne < 3; tRowOne++ )
					{
						//trace( "tRowOne: " + tRowOne );
						tLevelButton = new LevelButtonFrame( );
						tLevelButton.x = tRowOne * 110 + 170;
						tLevelButton.y = 160;
						if( tRowOne < GameVars.mUnlockedStage )
						{
							//tLevelButton.text_txt.text = ( tRowOne + 1 ).toString( );
							//trace( "checkpoint" );
							
							var tLevelButtonInsideNameRowOne : String = "LevelBtnInside" + ( tRowOne + 1 ).toString( );
							if( ApplicationDomain.currentDomain.hasDefinition( tLevelButtonInsideNameRowOne ) )
							{
								LevelButtonInsideClass = ApplicationDomain.currentDomain.getDefinition( tLevelButtonInsideNameRowOne ) as Class;
								
								var tBoardInsideRowOne : MovieClip = new LevelButtonInsideClass( );
								tLevelButton.InsideMC.addChild( tBoardInsideRowOne );
								tBoardInsideRowOne.x = 17;								
								tBoardInsideRowOne.y = 14;
								tLevelButton.name = ( tRowOne + 1 ).toString( );
								tLevelButton.buttonMode = true;
								tLevelButton.addEventListener( MouseEvent.MOUSE_DOWN, startGame, false, 0, true );
							}
						}
						
						else
						{							
							var tLevelButtonGreyNameRowOne : String = "LevelBtnInside" + ( 0 ).toString( );
							//trace( "tLevelButtonGreyName: " + tLevelButtonGreyNameRowOne );
							//trace( "ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowOne ): " + ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowOne ) );
							if( ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowOne ) )
							{
								LevelButtonInsideClass = ApplicationDomain.currentDomain.getDefinition( tLevelButtonGreyNameRowOne ) as Class;
								trace( "LevelButtonInsideClass: " + LevelButtonInsideClass );
								var tBoardGreyInsideRowOne : MovieClip = new LevelButtonInsideClass( );
								trace( "tBoardGreyInsideRowOne: " + tBoardGreyInsideRowOne );
								tBoardGreyInsideRowOne.x = 17;								
								tBoardGreyInsideRowOne.y = 14;
								tLevelButton.InsideMC.addChild( tBoardGreyInsideRowOne );
							}
							
							var tQuestionMarkDisplayRowOne = new GenericTextField( "displayFont", "left", 0xFFFFFF, 20, 30, 30, 34, 15 );			
							var tQuestionMarkTextRowOne : String = mGamingSystem.getTranslation( "IDS_QUESTIONMARK" );
							setText( "displayFont", tQuestionMarkDisplayRowOne, tQuestionMarkTextRowOne );			
							tLevelButton.addChild( tQuestionMarkDisplayRowOne );
						}					
						
						addChild( tLevelButton );
						mGarbageArr.push( tLevelButton );
					}
				}
				
				else if( tColumn == 1 )
				{
					for( var tRowTwo : int  = 0; tRowTwo < 4; tRowTwo++ )
					{
						//trace( "tRowTwo: " + tRowTwo );
						tLevelButton = new LevelButtonFrame( );
						tLevelButton.x = tRowTwo * 110 + 120;
						tLevelButton.y = 300;
						//trace( "tRowTwo + 4: " + ( tRowTwo + 4 ) );
						//trace( "GameVars.mUnlockedStage: " + GameVars.mUnlockedStage );
						if( ( tRowTwo + 4 ) <= GameVars.mUnlockedStage )
						{
							var tLevelButtonInsideNameRowTwo : String = "LevelBtnInside" + ( tRowTwo + 4 ).toString( );
							if( ApplicationDomain.currentDomain.hasDefinition( tLevelButtonInsideNameRowTwo ) )
							{
								LevelButtonInsideClass = ApplicationDomain.currentDomain.getDefinition( tLevelButtonInsideNameRowTwo ) as Class;
								
								var tBoardInsideRowTwo : MovieClip = new LevelButtonInsideClass( );
								tLevelButton.InsideMC.addChild( tBoardInsideRowTwo );
								tBoardInsideRowTwo.x = 17;								
								tBoardInsideRowTwo.y = 14;
								tLevelButton.name = ( tRowTwo + 4  ).toString( );
								tLevelButton.buttonMode = true;
								tLevelButton.addEventListener( MouseEvent.MOUSE_DOWN, startGame, false, 0, true );
							}
						}
						
						else
						{							
							var tLevelButtonGreyNameRowTwo : String = "LevelBtnInside" + ( 0 ).toString( );
							//trace( "tLevelButtonGreyNameRowTwo: " + tLevelButtonGreyNameRowTwo );
							//trace( "ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowTwo ): " + ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowTwo ) );
							if( ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowTwo ) )
							{
								LevelButtonInsideClass = ApplicationDomain.currentDomain.getDefinition( tLevelButtonGreyNameRowTwo ) as Class;
								//trace( "LevelButtonInsideClass: " + LevelButtonInsideClass );
								var tBoardGreyInsideRowTwo : MovieClip = new LevelButtonInsideClass( );
								//trace( "tBoardGreyInsideRowTwo: " + tBoardGreyInsideRowTwo );
								tBoardGreyInsideRowTwo.x = 17;								
								tBoardGreyInsideRowTwo.y = 14;
								tLevelButton.InsideMC.addChild( tBoardGreyInsideRowTwo );
							}
							
							var tQuestionMarkDisplayRowTwo = new GenericTextField( "displayFont", "left", 0xFFFFFF, 20, 30, 30, 34, 15 );			
							var tQuestionMarkTextRowTwo : String = mGamingSystem.getTranslation( "IDS_QUESTIONMARK" );
							setText( "displayFont", tQuestionMarkDisplayRowTwo, tQuestionMarkTextRowTwo );			
							tLevelButton.addChild( tQuestionMarkDisplayRowTwo );
						}
						addChild( tLevelButton );
						mGarbageArr.push( tLevelButton );
					}
				}
				
				else if( tColumn == 2 )
				{
					for( var tRowThree : int  = 0; tRowThree < 5; tRowThree++ )
					{
						//trace( "tRowThree: " + tRowThree );
						tLevelButton = new LevelButtonFrame( );
						tLevelButton.x = tRowThree * 110 + 65;
						tLevelButton.y = 440;
						if( ( tRowThree + 8 ) <= GameVars.mUnlockedStage && ( tRowThree + 8 ) < 10)
						{
							var tLevelButtonInsideNameRowThree : String = "LevelBtnInside" + ( tRowThree + 8 ).toString( );
							//trace( "tLevelButtonInsideNameRowThree: " + tLevelButtonInsideNameRowThree );
							if( ApplicationDomain.currentDomain.hasDefinition( tLevelButtonInsideNameRowThree ) )
							{
								LevelButtonInsideClass = ApplicationDomain.currentDomain.getDefinition( tLevelButtonInsideNameRowThree ) as Class;
								
								var tBoardInsideRowThree : MovieClip = new LevelButtonInsideClass( );
								tLevelButton.InsideMC.addChild( tBoardInsideRowThree );
								tBoardInsideRowThree.x = 17;								
								tBoardInsideRowThree.y = 14;
								tLevelButton.name = ( tRowThree + 8 ).toString( );
								tLevelButton.buttonMode = true;
								tLevelButton.addEventListener( MouseEvent.MOUSE_DOWN, startGame, false, 0, true );
							}
						}
						
						else
						{
							var tLevelButtonGreyNameRowThree : String = "LevelBtnInside" + ( 0 ).toString( );
							//trace( "tLevelButtonGreyNameRowThree: " + tLevelButtonGreyNameRowThree );
							//trace( "ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowThree ): " + ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowThree ) );
							if( ApplicationDomain.currentDomain.hasDefinition( tLevelButtonGreyNameRowThree ) )
							{
								LevelButtonInsideClass = ApplicationDomain.currentDomain.getDefinition( tLevelButtonGreyNameRowThree ) as Class;
								//trace( "LevelButtonInsideClass: " + LevelButtonInsideClass );
								var tBoardGreyInsideRowThree : MovieClip = new LevelButtonInsideClass( );
								//trace( "tBoardGreyInsideRowThree: " + tBoardGreyInsideRowThree );
								tBoardGreyInsideRowThree.x = 17;								
								tBoardGreyInsideRowThree.y = 14;
								tLevelButton.InsideMC.addChild( tBoardGreyInsideRowThree );
							}
							
							var tQuestionMarkDisplayRowThree = new GenericTextField( "displayFont", "left", 0xFFFFFF, 20, 30, 30, 34, 15 );			
							var tQuestionMarkTextRowThree : String = mGamingSystem.getTranslation( "IDS_QUESTIONMARK" );
							setText( "displayFont", tQuestionMarkDisplayRowThree, tQuestionMarkTextRowThree );			
							tLevelButton.addChild( tQuestionMarkDisplayRowThree );
						}
						addChild( tLevelButton );
						mGarbageArr.push( tLevelButton );
					}
				}
			}
			
		} // end createStageSelectionMenu
		
		//===============================================================================
		// FUNCTION startGame
		//          - called from tLevelButton  
		//===============================================================================
		private function startGame( evt : MouseEvent ):void
		{
			trace( "startGame in GameMenu called" );	
			/*
			/ send tracking
			*/
			mGamingSystem.sendTag( "Game Started" );
						
			if( mGarbageArr != null )
			{
				clearMenu( );
			}
			
			trace( "evt.currentTarget.name: " + evt.currentTarget.name );
			
			GameVars.mCurrentStage = int( evt.currentTarget.name );
			
			mKougraKarateGame = new KougraKarateGame( mTopChopSharedListener );
			mKougraKarateGame.init( mGamingSystem, _ROOT.stage );
			addChild( mKougraKarateGame );
			
		} // end startGame
		
		//===============================================================================
		// FUNCTION createInstructionsMenu
		//          - called from 
		//===============================================================================
		private function createInstructionsMenu( evt : MouseEvent ): void
		{
			trace( "createInstructionsMenu in GameMenu called" );
			
			if( mGarbageArr != null )
			{
				clearMenu( );
			}
			
			GameVars.mInstructionsMenu = new InstructionsMenu( );
			mGarbageArr.push( GameVars.mInstructionsMenu );
			GameVars.mInstructionsMenu.init( mGamingSystem, this );
			addChild( GameVars.mInstructionsMenu );
		
		} // end createInstructionsMenu( )
		
		//===============================================================================
		// FUNCTION createGameOverMenu
		//          - called through shared listener from KougraKarateGame 
		//===============================================================================
		internal function createGameOverMenu( evt : CustomEvent ): void
		{
			trace( "createGameOverMenu in GameMenu called" );
			
			if( mGarbageArr != null )
			{
				clearMenu( );
			}
			
			addChild( mGameOverBG );
			mGarbageArr.push( mGameOverBG );			
			
			//=======================================
			// header
			//=======================================
			var tGameOverHeaderDisplay = new GenericTextField( "displayFont", "center", 0x000000, 22, 350, 70, 160, 100 );
			var tGameOverHeaderStr : String = mGamingSystem.getTranslation( "IDS_GAME_OVER_HEADER" );											 
			setText( "displayFont", tGameOverHeaderDisplay, tGameOverHeaderStr );
			mGarbageArr.push( tGameOverHeaderDisplay );
			addChild( tGameOverHeaderDisplay );
						
			//=======================================
			// display final score player achieved
			//=======================================			
			var tFinalScoreTextDisplay = new GenericTextField( "displayFont", "left", 0x000000, 22, 150, 30, 220, 200 );
			var tFinalScoreTextStr : String = mGamingSystem.getTranslation( "IDS_FINAL_SCORE" );											 
			setText( "displayFont", tFinalScoreTextDisplay, tFinalScoreTextStr );
			mGarbageArr.push( tFinalScoreTextDisplay );
			addChild( tFinalScoreTextDisplay );
			
			var tFinalScoreDisplay = new GenericTextField( "displayFont", "left", 0x000000, 22, 60, 30, 380, 200 );
			var tFinalScoreStr : String = mGamingSystem.getTranslation("IDS_FINAL_SCORE_HTML_OPEN") + 	
										  GameVars.mFinalScore +
										  mGamingSystem.getTranslation("IDS_BUTTON_HTML_CLOSE"); 									 
			setText( "displayFont", tFinalScoreDisplay, tFinalScoreStr );
			mGarbageArr.push( tFinalScoreDisplay );
			addChild( tFinalScoreDisplay );
			
			//=======================================
			// play again button
			//=======================================
			GameVars.mPlayAgainButton = new CenterAlignedButton( );
			GameVars.mPlayAgainButton.buttonMode = true;
			
			var tPlayAgainStr : String = mGamingSystem.getTranslation("IDS_BUTTON_HTML_OPEN") + 
										 mGamingSystem.getTranslation("FGS_GAME_OVER_MENU_RESTART_GAME") + 
										 mGamingSystem.getTranslation("IDS_BUTTON_HTML_CLOSE");
										 
			setText( "displayFont",  GameVars.mPlayAgainButton.text_txt, tPlayAgainStr );
			
			GameVars.mPlayAgainButton.x = 50;
			GameVars.mPlayAgainButton.y = 530;
			GameVars.mPlayAgainButton.addEventListener( MouseEvent.MOUSE_DOWN, onPlayAgain, false, 0, true );
			mGarbageArr.push( GameVars.mPlayAgainButton );
			addChild( GameVars.mPlayAgainButton );
			
			//=======================================
			// send score button
			//=======================================
			GameVars.mSendScoreButton = new CenterAlignedButton( );
			GameVars.mSendScoreButton.buttonMode = true;
			
			
			var tSendScoreStr : String = mGamingSystem.getTranslation("IDS_BUTTON_HTML_OPEN") + 
										 mGamingSystem.getTranslation("FGS_GAME_OVER_MENU_SEND_SCORE") + 
										 mGamingSystem.getTranslation("IDS_BUTTON_HTML_CLOSE");
										 
			setText( "displayFont", GameVars.mSendScoreButton.text_txt, tSendScoreStr );
			
			GameVars.mSendScoreButton.x = 480;
			GameVars.mSendScoreButton.y = 530;
			GameVars.mSendScoreButton.addEventListener( MouseEvent.MOUSE_DOWN, onSendScore, false, 0, true );
			mGarbageArr.push( GameVars.mSendScoreButton );
			addChild( GameVars.mSendScoreButton );
				
		} // end createGameOverMenu( )
		
		//===============================================================================
		// FUNCTION onPlayAgain
		//          - called from mouse event of GameVars.mPlayAgainButton
		//===============================================================================
		private function onPlayAgain( evt:MouseEvent ) : void
		{
			if( GameVars.mPlayAgainButton.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				GameVars.mPlayAgainButton.removeEventListener( MouseEvent.MOUSE_DOWN, onPlayAgain );
			}
			
			if( GameVars.mSendScoreButton.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				GameVars.mSendScoreButton.removeEventListener( MouseEvent.MOUSE_DOWN, onSendScore );
			}
			
			createMainMenu( );
			
		} // end onPlayAgain
		
		//===============================================================================
		// FUNCTION onSendScore
		//===============================================================================
		private function onSendScore ( evt : MouseEvent ) : void
		{
			trace( "onSendScore called" );
			
			//trace( "GameVars.mGameScore.show( ): " + GameVars.mGameScore.show( ) );
			
			/*
			/ make sure user can't submit more than max score
			*/
			/*if( GameVars.mGameScore.show( ) > GameVars.mMaxScore )
			{
				GameVars.mGameScore.changeTo( GameVars.mMaxScore );
			}*/
						
			/*
			/ deactivate and remove both the restart and the send score button so user
			/ can only get back to main menu by clicking button inside score meter
			*/
			if( GameVars.mSendScoreButton.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				GameVars.mSendScoreButton.removeEventListener( MouseEvent.MOUSE_DOWN, onSendScore );
			}
			
			if( GameVars.mSendScoreButton.parent != null )
			{
				GameVars.mSendScoreButton.parent.removeChild( GameVars.mSendScoreButton );
				GameVars.mSendScoreButton = null;
			}
			
			if( GameVars.mPlayAgainButton.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				GameVars.mPlayAgainButton.removeEventListener( MouseEvent.MOUSE_DOWN, onPlayAgain );
			}
			
			if( GameVars.mPlayAgainButton.parent != null )
			{
				GameVars.mPlayAgainButton.parent.removeChild( GameVars.mPlayAgainButton );
				GameVars.mPlayAgainButton = null;
			}
			
			trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage );
			
			mGamingSystem.sendScore( GameVars.mFinalScore/*, GameVars.mCurrentStage*/ );
			
			/*
			/ add scoring meter from NP9_Generic_Game.as
			*/ 
			sendScoringMeterToFront( );
			addEventListener( Event.ENTER_FRAME, onWaitForSendScore, false, 0, true );
			
		} // end onSendScore
		
		//===============================================================================
		// FUNCTION onWaitForSendScore
		//          - waits for user to click the restart button within 
		//            the send score meter
		//===============================================================================	
		public function onWaitForSendScore ( evt : Event ) : void
		{
			/*
			/ weird heino function that detects click on 
			/ "Restart Game" inside scoring meter
			*/
			if ( mGamingSystem.userClickedRestart( ) ) 
			{
				// swap scoring meter back - offline only 
				removeEventListener( Event.ENTER_FRAME, onWaitForSendScore );
				sendScoringMeterToBack( );
				createMainMenu( );				
			}
			
		} // end onWaitForSendScore
		
		//===============================================================================
		// FUNCTION playSound  
		//===============================================================================
		internal static function playSound( pSndName : String, pOn : Boolean, pLoop : Boolean = false ) : void
		{
			if( pOn )
			{
				trace( "play sound now" );				
				mTopChopSharedListener.dispatchEvent( new CustomEvent ( { SMID : "All", SOUNDNAME : pSndName, DATA : { INFLOOP : pLoop  } }, mTopChopSharedListener.REQUEST_SND_PLAY ) );
			}
			
		} // end playSound
		
		//===============================================================================
		// FUNCTION stopSound  
		//===============================================================================
		internal static function stopSound( pSndName : String, pOn : Boolean ) : void
		{
			if( pOn )
			{
				trace( "stop sound now" );				
				mTopChopSharedListener.dispatchEvent( new CustomEvent ( { SMID : "All", SOUNDNAME : pSndName }, mTopChopSharedListener.REQUEST_SND_STOP ) );
			}
			
		} // end stopSound
		
		//===============================================================================
		// FUNCTION stopSound  
		//===============================================================================
		internal static function stopAllSounds( ) : void
		{
			mTopChopSharedListener.dispatchEvent( new CustomEvent ( { SMID : "All" }, mTopChopSharedListener.REQUEST_SND_STOPALL ) );
			
		} // end stopSound
		
		//===============================================================================
		// FUNCTION loadSounds  
		//===============================================================================
		internal function loadSounds( ) : void
		{
			mSoundManager.loadSound("BtnClick", SoundObj.TYPE_INTERNAL, 0, null, null );
			mSoundManager.loadSound("GameMusic", SoundObj.TYPE_INTERNAL, 0, null, null );
			mSoundManager.loadSound("BreakWood", SoundObj.TYPE_INTERNAL, 0, null, null );
			mSoundManager.loadSound("BadHit", SoundObj.TYPE_INTERNAL, 0, null, null );
			
			
		} // end loadSounds
		
		//===============================================================================
		// FUNCTION setText
		//          - sets a textField with text, set up for translation   
		//===============================================================================
		internal function setText( pFontName : String, pTextTield : TextField, pString : String = "********" ) : void
		{			
			mGamingSystem.setFont( pFontName );
			mGamingSystem.setTextField( pTextTield, pString );
			
		} // end setText
		
		//===============================================================================
		// FUNCTION clearMenu
		//          - loops through array that holds display objects
		//            of menu and removes them
		//===============================================================================
		internal static function clearMenu( ):void
		{
			for( var i : int = mGarbageArr.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = mGarbageArr[ i ];
				
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
			
			mGarbageArr = new Array( );
			
		} // end clearMenu
		
		//===============================================================================
		// FUNCTION setupVars
		//          - sets up vars (duh)
		//===============================================================================
		private function setupVars( ):void
		{
			
			mGamingSystem = _GAMINGSYSTEM;			
			mImageServer  = mGamingSystem.getImageServer( );
			//mAssetBaseURL = mImageServer + "/games/tangram/";
			
			mMainBG                = new BGMain( );			
			mInstructionsBG        = new BGInstructions( );
			mGameOverBG            = new BGGameOver( );
			mStageScreenBG         = new BGStageScreen( );
			mTopChopSharedListener = new TopChopSharedListener( );
			mGarbageArr            = new Array( );
			
		} // end setupVars
						
	} // end class
	
} // end package