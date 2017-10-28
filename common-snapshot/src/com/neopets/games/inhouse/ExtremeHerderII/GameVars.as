package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// imports
	//===============================================================================
	import flash.net.SharedObject;
	
	internal class GameVars extends Object
	{		
		//===============================================================================
		// user data info
		//===============================================================================
		//internal static var mSharedObject  : SharedObject;
		//internal static var mUserName	   : String;
		//internal static var mUnlockedStage : uint;
		
		//===============================================================================
		// backgrounds
		//===============================================================================
		//internal static var mBackgrounds : Backgrounds;
		//internal static var mBGCourtYard : BGCourtYard;
		//internal static var mBGDojo      : BGDojo;
		//internal static var mBGGrandHall : BGGrandHall;
		
		//===============================================================================
		// isntructions menu
		//===============================================================================
		//internal static var mInstructionsMenu : InstructionsMenu;
		
		//===============================================================================
		// meter and slider
		//===============================================================================
		//internal static var mMeterFrame              : MeterFrame;
		//internal static var mMeter                   : Meter;
		//internal static var mSafeZone                : SafeZone;
		//internal static var mSuperSafeZone           : SuperSafeZone;
		//internal static var mSafeZoneOffset          : Number;
		//internal static var mSlider                  : Slider;
		//internal static var mStoppedSliderLocation   : Number;
		//internal static var mStoppedSafeZoneLocation : Number;
		//internal static var mSliderTop               : Number;
		//internal static var mSliderBottom            : Number;
		//internal static var mRandomSlider            : Boolean; // for testing
		//internal static var mStutterSlider           : Boolean; // for testing
		//internal static var mMovingMeter             : Boolean; // for testing
		
		//===============================================================================
		// level status
		//===============================================================================
		//internal static var mSenseiStatus       : String;
		//internal static var mHiddenStageCounter : int;
		
		//===============================================================================
		// score board
		//===============================================================================
		//internal static var mScoreboard       : Scoreboard;
		internal static var mGameScore        : Object;
		internal static var mGameLevel        : Object;
		//internal static var mScoreTextDisplay : GenericTextField;
		//internal static var mScoreDisplay     : GenericTextField;
		//internal static var mLevelDisplay     : LevelDisplay;
		//internal static var mCurrentScore     : int;
		//internal static var mTimeBonus        : int;
		//internal static var mCenterHitBonus   : int;
		//internal static var mMaxScore         : int = 3375; // test with 15;
		//internal static var mFinalScore       : int;
		//internal static var mEndGameButton    : EndGameBtn;
		//internal static var mGameTimer        : TimeDisplay;
		
		//===============================================================================
		// power ups
		//===============================================================================
		//internal static var mPowerUpFrame      : GenericFrame;
		//internal static var mDummyPowerUpOne   : DummyPowerUpOne;
		//internal static var mDummyPowerUpTwo   : DummyPowerUpTwo;
		//internal static var mDummyPowerUpThree : DummyPowerUpThree;
		//internal static var mPowerUpOne        : PowerUpOne;
		//internal static var mPowerUpTwo        : PowerUpTwo;
		//internal static var mPowerUpThree      : PowerUpThree;
		//internal static var mPowerUpTracker    : String;
		//internal static var mHasPowerUp        : Boolean;
		//internal static var mHasExtraLife      : Boolean;		
		
		//===============================================================================
		// mcs, animations, etc.
		//===============================================================================
		//internal static var mKatsuoAnimation      : KatsuoAnimation;
		//internal static var mBoardAnimation       : BoardAnimation;
		//internal static var mSplitScreenAnimation : SplitScreenAnimation;
		
		//===============================================================================
		// distractions
		//===============================================================================
		/* internal static var mDistractions     : Distractions;
		internal static var mBlossoms         : Blossoms;
		internal static var mCricketAnimation : CricketAnimation;
		internal static var mCricketAnimOn    : Boolean;
		internal static var mGuard            : Guard;
		internal static var mEmperor          : Emperor;
		internal static var mEmperorAnimOn    : Boolean; */
		
		//===============================================================================
		// garbage collection
		//===============================================================================
		//internal static var mGameOverGarbage : Array;
		
		//===============================================================================
		// misc
		//===============================================================================
		/* internal static var mContinueButton   : CenterAlignedButton;
		internal static var mSendScoreButton  : CenterAlignedButton;
		internal static var mPlayAgainButton  : CenterAlignedButton;
		internal static var mCurrentStage     : int;
		internal static var mSuperZoneCounter : int;
		internal static var mGameOn           : Boolean; */ // keeps track if game is currently played
		internal static var mSoundOn          : Boolean;
		internal static var mMusicOn          : Boolean;
		
	} // end class
	
} // end package