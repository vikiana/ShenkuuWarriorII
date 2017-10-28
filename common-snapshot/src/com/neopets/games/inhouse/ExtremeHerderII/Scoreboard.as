package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import virtualworlds.lang.TranslationManager;

	public class Scoreboard extends MovieClip
	{
		//===============================================================================
		// 	VARS & CONSTANTS
		//===============================================================================
		internal static const END_GAME  : String = "EndGame";
		internal static const GAME_OVER : String = "GameOver";
		
		private var mScoreDispTF : MovieClip;
		private var mLvlDispTF   : MovieClip;
		
		//=======================================
		// getter vars
		//=======================================
		private var gLivesArr    : Array;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		public function set mLivesArr( pValue : Array ):void { gLivesArr = pValue };
		public function get mLivesArr( ):Array { return gLivesArr };		
		
		//===============================================================================
		// 	CONSTRUCTOR Scoreboard
		//===============================================================================
		public function Scoreboard( )
		{
			super( );
			
			// triggered in PowerUpManager when power up is activated
			Dispatcher.addEventListener( PowerUpManager.ACTIVATE_POWER_UP_DISP, activatePowerUpDisp );
			
			// triggered in PowerUpManager when power up is deactivated
			Dispatcher.addEventListener( PowerUpManager.DEACTIVATE_POWER_UP_DISP, deactivatePowerUpDisp );
			
			// triggered in ExtremeHerderIIGame when level is over
			Dispatcher.addEventListener( ExtremeHerderIIGame.DEACTIVATE_POWER_UP_DISP, deactivatePowerUpDisp );
			
			setupVars( );
			addElements( );
			//init( );
		
		} // end constructor
		
		//===============================================================================
		// 	FUNCTION init  
		//===============================================================================
		internal function init( ) : void
		{	
			//trace( "init in " + this + " called" );
			
			updateScoreDisplay( );
			
		} // end function init
		
		//===============================================================================
		// 	FUNCTION addElements
		//===============================================================================
		internal function addElements( ) : void
		{
			//trace( "addElements in " + this + " called" );
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			var tSystem        : Object = GlobalGameReference.mInstance.mGameStartUp.mSystem;
			
			var tTransManager        : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );			
			
			//=======================================
			// frame
			//=======================================
			var tScoreboardFrameClass : Class = tAssetLocation.getDefinition( "Scoreboard" ) as Class;
			var tScoreboardFrame      : MovieClip = new tScoreboardFrameClass( );
			tScoreboardFrame.x = 314;
			tScoreboardFrame.y = 25;
			this.addChild( tScoreboardFrame );
			
			//=======================================
			// score and level display
			//=======================================
			var tScoreAndLvlDisp       : GenericSmallTextFieldBG = new GenericSmallTextFieldBG( "GenericSmallTextFieldBG", "score_lvl_disp", 60, 24, 1.2, 1.28, true, 20, 10 );
			
			/**
			 * word "score"
			 */		
			var tScoreDispTitleTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tScoreDispTitleTF      : MovieClip = new tScoreDispTitleTFClass( );
			tTransManager.setTextField( tScoreDispTitleTF.mTextField, tEHIITranslationData.IDS_SCORE_DISPLAY );
			tScoreDispTitleTF.x = -16;
			tScoreDispTitleTF.y = -9;
			tScoreAndLvlDisp.addChild( tScoreDispTitleTF );
			
			/**
			 * the actual score digit
			 */
			mScoreDispTF.x = 62;
			mScoreDispTF.y = -9;
			tScoreAndLvlDisp.addChild( mScoreDispTF );
			
			/**
			 * word "level"
			 */		
			var tLevelDispTitleTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tLevelDispTitleTF      : MovieClip = new tLevelDispTitleTFClass( );
			tTransManager.setTextField( tLevelDispTitleTF.mTextField, tEHIITranslationData.IDS_LEVEL_DISPLAY );
			tLevelDispTitleTF.x = -18;
			tLevelDispTitleTF.y = 8;
			tScoreAndLvlDisp.addChild( tLevelDispTitleTF );
			
			/**
			 * the actual level digit
			 */
			mLvlDispTF.x = 60;
			mLvlDispTF.y = 8;
			tScoreAndLvlDisp.addChild( mLvlDispTF );
			
			this.addChild( tScoreAndLvlDisp );
			//updateScoreDisplay( );
			
			/**
			 * lives display
			 */			
			for( var i : int = 0; i < 3; i++ )
			{
				var tLifeClass : Class = tAssetLocation.getDefinition( "Life" ) as Class;
				var tLife : MovieClip = new tLifeClass( );
				tLife.x = 150 + i * 45;
				tLife.y = 25;
				addChild( tLife );
				mLivesArr[ mLivesArr.length ] = tLife;
			}
			
			/**
			 * speed up power up
			 */
			var tSpeedUpPU : PowerUp = new PowerUp( "SpeedUp" );
			tSpeedUpPU.name = "speed_up_pu";
			tSpeedUpPU.x = 310;
			tSpeedUpPU.y = 25;
			addChild( tSpeedUpPU );
			
			/**
			 * freeze power up
			 */
			var tFreezePU : PowerUp = new PowerUp( "Freeze" );
			tFreezePU.name = "freeze_pu";
			tFreezePU.x = 340;
			tFreezePU.y = 25;
			addChild( tFreezePU );
			
			/**
			 * two petpets power up
			 */
			var tTwoPPsPU : PowerUp = new PowerUp( "TwoPPs" );
			tTwoPPsPU.name = "two_pps_pu";
			tTwoPPsPU.x = 390;
			tTwoPPsPU.y = 25;
			addChild( tTwoPPsPU );
			
			/**
			 * waypoint power up
			 */
			var tWaypointPU : PowerUp = new PowerUp( "Waypoint" );
			tWaypointPU.name = "waypoint_pu";
			tWaypointPU.x = 445;
			tWaypointPU.y = 25;
			addChild( tWaypointPU );
			
			/**
			 * end game button
			 */
			var tEndGameBtn        : GenericButton = new GenericButton( "GenericButton", "end_game_button", 565, 22, 1.1, 1, true, 20, 20 );		
			var tEndGameBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tEndGameBtnTF      : MovieClip = new tEndGameBtnTFClass( );
			tTransManager.setTextField( tEndGameBtnTF.mTextField, tEHIITranslationData.IDS_END_GAME_BUTTON );
			tEndGameBtn.addChild( tEndGameBtnTF );			
			tEndGameBtn.addEventListener( MouseEvent.CLICK, onEndGameBtnClick, false, 0, true );
			this.addChild( tEndGameBtn );
		}
		
		//===============================================================================
		//	FUNCTION updateScoreDisplay 
		//===============================================================================
		internal function updateScoreDisplay( ):void
		{
			//trace( "updateScoreDisplay in " + this + " called" );
			
			//trace( this + " says: GameVars.mGameScore.show " + GameVars.mGameScore.show( ) );
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			var tTransManager        : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );
						
			/*if( GameVars.mGameScore.show( ) > GameVars.mMaxScore )
			{
				GameVars.mGameScore.changeTo( GameVars.mMaxScore );
			}*/
						
			var tScore : String = tEHIITranslationData.IDS_SCORE_OPEN + 
								  GameVars.mGameScore.show( ) + 
								  tEHIITranslationData.IDS_SCORE_CLOSE;
								  
			tTransManager.setTextField( mScoreDispTF.mTextField, tScore );
							
		} // end updateScoreDisplay
		
		//===============================================================================
		//	FUNCTION updateLvlDisplay 
		//===============================================================================
		internal function updateLvlDisplay( pLvl : int ):void
		{
			//trace( "updateLvlDisplay in " + this + " called" );
			
			//trace( this + " says: pLvl: " + pLvl );
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			var tTransManager        : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );
			
			var tLevel : String = tEHIITranslationData.IDS_SCORE_OPEN + 
								  pLvl + 
								  tEHIITranslationData.IDS_SCORE_CLOSE;
								  
			//trace( this + " says: tLevel: " + tLevel );
								  
			tTransManager.setTextField( mLvlDispTF.mTextField, tLevel );
							
		} // end updateScoreDisplay
		
		//===============================================================================
		//	FUNCTION updateLivesDisplay 
		//===============================================================================
		internal function updateLivesDisplay( ):void
		{
			//trace( "updateLivesDisplay in " + this + " called" );
			//trace( this + " says: mLivesArr.length: " + mLivesArr.length );
			
			if( mLivesArr.length >= 1 )
			{
				removeChild( mLivesArr[ mLivesArr.length - 1 ] );
				mLivesArr[ mLivesArr.length - 1 ] = null;
				mLivesArr.splice( mLivesArr.length - 1, 1 );
			}
			
			else
			{
				trace( this + " says: no more lives. YOU ARE DEAD!!! GAME OVER!!!" );
				/**
				 * ExtremeHerderIIGame listens to END_GAME event
				 */
				//Dispatcher.dispatchEvent( new Event( END_GAME ) );
			
				/**
				 * GameStartUp listens for GAME_OVER event
				 */
				//Dispatcher.dispatchEvent( new Event( GAME_OVER ) );
			}
							
		} // end updateLivesDisplay
		
		//===============================================================================
		// 	FUNCTION onEndGameBtnClick
		//	- called when "End Game" button is clicked. creates the confirmation pop up
		//		and pauses the game
		//===============================================================================
		private function onEndGameBtnClick( evt : MouseEvent ):void
		{
			//trace( "onEndGameBtnClick in " + this + " called" );
			
			/**
			 * while the pop up is up, remove event listener from end game button
			 */
			if( this.getChildByName( "end_game_button" ) != null )
			{
				//trace( this.getChildByName( "end_game_button" ) + " found" );
				var tButton : GenericButton = this.getChildByName( "end_game_button" ) as GenericButton;
				tButton.removeEventListener( MouseEvent.CLICK, onEndGameBtnClick );
			}
			
			/**
			 * ExtremeHerderIIGame listens to END_GAME event
			 */
			Dispatcher.dispatchEvent( new Event( END_GAME ) );
			
			/**
			 * GameStartUp listens for GAME_OVER event
			 */
			Dispatcher.dispatchEvent( new Event( GAME_OVER ) );
			
		} // end onEndGameBtnClick
		
		//===============================================================================
		// 	FUNCTION activatePowerUpDisp
		//===============================================================================
		internal function activatePowerUpDisp( evt : DataEvent ):void
		{
			trace( "activatePowerUpDisp in " + this + " called" );
			
			var tPowerUpName : String = evt.mData as String;
			
			var tPowerUp : PowerUp = getChildByName( tPowerUpName ) as PowerUp;
			
			trace( "tPowerUpName: " + tPowerUpName );
			
			switch( tPowerUp.name )
			{
				case "speed_up_pu":
					tPowerUp.mSpeedUp.gotoAndStop( 2 );
					break;
					
				case "freeze_pu":
					tPowerUp.mFreeze.gotoAndStop( 2 );
					break;
					
				case "two_pps_pu":
					tPowerUp.mTwoPPs.gotoAndStop( 2 );
					break;
					
				case "waypoint_pu":
					tPowerUp.mWaypoint.gotoAndStop( 2 );
					break;					
			}
			
		} // end activatePowerUpDisp
		
		//===============================================================================
		// 	FUNCTION activatePowerUpDisp
		//===============================================================================
		internal function deactivatePowerUpDisp( evt : DataEvent ):void
		{
			trace( "deactivatePowerUpDisp in " + this + " called" );
			
			var tPowerUp1 : PowerUp = getChildByName( "speed_up_pu" ) as PowerUp;
			var tPowerUp2 : PowerUp = getChildByName( "freeze_pu" ) as PowerUp;
			var tPowerUp3 : PowerUp = getChildByName( "two_pps_pu" ) as PowerUp;
			var tPowerUp4 : PowerUp = getChildByName( "waypoint_pu" ) as PowerUp;
			
			if( tPowerUp1.mSpeedUp.currentFrame == 2 )
			{
				tPowerUp1.mSpeedUp.gotoAndStop( 1 );
			}
			
			if( tPowerUp2.mFreeze.currentFrame == 2 )
			{
				tPowerUp2.mFreeze.gotoAndStop( 1 );
			}
			
			if( tPowerUp3.mTwoPPs.currentFrame == 2 )
			{
				tPowerUp3.mTwoPPs.gotoAndStop( 1 );
			}
			
			if( tPowerUp4.mWaypoint.currentFrame == 2 )
			{
				tPowerUp4.mWaypoint.gotoAndStop( 1 );
			}
			
		} // end deactivatePowerUpDisp
		
		//===============================================================================
		// 	FUNCTION setupVars 
		//  - assigns vars
		//===============================================================================
		private function setupVars( ) : void
		{
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			//mSystem = GlobalGameReference.mInstance.mGameStartUp.mSystem;
			//mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			var tScoreDispTFClass : Class = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			mScoreDispTF = new tScoreDispTFClass( );
			
			var tLvlDispTFClass : Class = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			mLvlDispTF = new tLvlDispTFClass( );
			
			mLivesArr = [ ];
			
		} // end setupVars
		
	} // end class
	
} // end package