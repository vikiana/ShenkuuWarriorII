package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import virtualworlds.lang.TranslationManager;
	
	public class GameOverScreen extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		internal static const BACK_TO_MAIN        : String = "BackToMain";
		
		private var mSystem : Object;
		private var mStage  : Stage;
		
		//===============================================================================
		// CONSTRUCTOR GameOverScreen
		//===============================================================================
		public function GameOverScreen( )
		{
			super( );
			
			trace( this + " created" );
			
			setupVars( );
			init( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( ):void
		{
			//trace( "init in " + this + " called" );
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			var tSystem        : Object = GlobalGameReference.mInstance.mGameStartUp.mSystem;
			
			var tTransManager        : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );
			
			//=======================================
			// background
			//=======================================
			var tGameOverBGClass : Class = tAssetLocation.getDefinition( "GameOverBG" ) as Class;			
			var tGameOverBG      : MovieClip = new tGameOverBGClass( );
			tGameOverBG.x = mStage.stageWidth / 2;
			tGameOverBG.y = mStage.stageHeight / 2;
			this.addChild( tGameOverBG );
			
			//=======================================
			// frame
			//=======================================
			var tGameOverFrameClass : Class = tAssetLocation.getDefinition( "GameOverFrame" ) as Class;
			var tGameOverFrame      : MovieClip = new tGameOverFrameClass( );
			tGameOverFrame.name = "game_over_frame";
			tGameOverFrame.x = mStage.stageWidth / 2;
			tGameOverFrame.y = mStage.stageHeight / 2;
			this.addChild( tGameOverFrame );
			
			/**
			 * game over header
			 */
			var tGameOverHeaderTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tGameOverHeaderTF      : MovieClip = new tGameOverHeaderTFClass( );
			tTransManager.setTextField( tGameOverHeaderTF.mTextField, tEHIITranslationData.IDS_GAME_OVER_HEADER );
			tGameOverHeaderTF.mTextField.width  = 300;
			tGameOverHeaderTF.mTextField.height = 60;
			tGameOverHeaderTF.x = -100;
			tGameOverHeaderTF.y = -160;
			tGameOverFrame.addChild( tGameOverHeaderTF );
			
			/**
			 * final score display: label
			 */
			var tFinalScoreLblTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tFinalScoreLblTF      : MovieClip = new tFinalScoreLblTFClass( );
			tTransManager.setTextField( tFinalScoreLblTF.mTextField, tEHIITranslationData.IDS_FINAL_SCORE );
			//tFinalScoreLblTF.mTextField.border = true;
			tFinalScoreLblTF.mTextField.width  = 140;
			//tFinalScoreTF.mTextField.height = 60;
			tFinalScoreLblTF.x = -100;
			tFinalScoreLblTF.y = -80;
			tGameOverFrame.addChild( tFinalScoreLblTF );
			
			/**
			 * final score display: digit
			 */
			var tFinalScoreTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tFinalScoreTF      : MovieClip = new tFinalScoreTFClass( );
			
			var tScore : String = tEHIITranslationData.IDS_SCORE_OPEN + 
								  GameVars.mGameScore.show( ) + 
								  tEHIITranslationData.IDS_SCORE_CLOSE;
								  
			tTransManager.setTextField( tFinalScoreTF.mTextField, tScore );
			
			//tFinalScoreTF.mTextField.border = true;
			tFinalScoreTF.mTextField.width  = 60;
			//tFinalScoreTF.mTextField.height = 60;
			tFinalScoreTF.x = 50;
			tFinalScoreTF.y = -80;
			tGameOverFrame.addChild( tFinalScoreTF );
						
			/**
			 * play again button
			 */
			var tPlayAgainBtn        : GenericButton = new GenericButton( "GenericButton", "play_again_button", 140, 490, 1.5, 1, true, 20, 20 );			
			var tPlayAgainBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tPlayAgainBtnTF      : MovieClip = new tPlayAgainBtnTFClass( );
			tPlayAgainBtnTF.mTextField.width = 150;
			//tPlayAgainBtnTF.mTextField.border = true;
			
			tTransManager.setTextField( tPlayAgainBtnTF.mTextField, tEHIITranslationData.IDS_PLAY_AGAIN );
			
			tPlayAgainBtnTF.x = -25;
			tPlayAgainBtnTF.y = -3;
			tPlayAgainBtn.addChild( tPlayAgainBtnTF );
			tPlayAgainBtn.addEventListener( MouseEvent.MOUSE_DOWN, onPlayAgain, false, 0, true );
			this.addChild( tPlayAgainBtn );
			
			/**
			 * send score button
			 */
			var tSendScoreBtn        : GenericButton = new GenericButton( "GenericButton", "send_score_button", 505, 490, 1.5, 1, true, 20, 20 );			
			var tSendScoreBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tSendScoreBtnTF      : MovieClip = new tSendScoreBtnTFClass( );
			tSendScoreBtnTF.mTextField.width = 150;
			//tSendScoreBtnTF.mTextField.border = true;
			
			tTransManager.setTextField( tSendScoreBtnTF.mTextField, tEHIITranslationData.IDS_SEND_SCORE );
			
			tSendScoreBtnTF.x = -25;
			tSendScoreBtnTF.y = -3;
			tSendScoreBtn.addChild( tSendScoreBtnTF );
			tSendScoreBtn.addEventListener( MouseEvent.MOUSE_DOWN, onSendScore, false, 0, true );
			this.addChild( tSendScoreBtn );
			
		} // end init
		
		//===============================================================================
		// FUNCTION onPlayAgain
		//===============================================================================
		private function onPlayAgain( evt : MouseEvent ) : void
		{
			trace( "onPlayAgain in " + this + " called" );
			
			var tPlayAgainBtn : GenericButton = this.getChildByName( "play_again_button" ) as GenericButton;
			var tSendScoreBtn : GenericButton = this.getChildByName( "send_score_button" ) as GenericButton;
			
			if( tPlayAgainBtn.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				tPlayAgainBtn.removeEventListener( MouseEvent.MOUSE_DOWN, onPlayAgain );
			}
			
			if( tSendScoreBtn.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				tSendScoreBtn.removeEventListener( MouseEvent.MOUSE_DOWN, onSendScore );
			}
			
			/**
			 * GameStartUp listens to BACK_TO_MAIN event
			 */
			Dispatcher.dispatchEvent( new DataEvent( BACK_TO_MAIN ) );
			
		} // end onPlayAgain
		
		//===============================================================================
		// FUNCTION onSendScore
		//===============================================================================
		private function onSendScore ( evt : MouseEvent ) : void
		{
			trace( "onSendScore in " + this + " called" );
			
			trace( "GameVars.mGameScore.show( ): " + GameVars.mGameScore.show( ) );
			
			//var tRootMC : 
			
			/**
			 * make sure user can't submit more than max score
			 */
			/*if( GameVars.mGameScore.show( ) > GameVars.mMaxScore )
			{
				GameVars.mGameScore.changeTo( GameVars.mMaxScore );
			}*/
						
			/**
			 * deactivate and remove both the restart and the send score button so user
			 *  can only get back to main menu by clicking button inside score meter
			 */
			var tPlayAgainBtn : GenericButton = this.getChildByName( "play_again_button" ) as GenericButton;
			var tSendScoreBtn : GenericButton = this.getChildByName( "send_score_button" ) as GenericButton;
			
			if( tPlayAgainBtn.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				tPlayAgainBtn.removeEventListener( MouseEvent.MOUSE_DOWN, onPlayAgain );
			}
			removeChild( tPlayAgainBtn );
			
			if( tSendScoreBtn.hasEventListener( MouseEvent.MOUSE_DOWN ) )
			{
				tSendScoreBtn.removeEventListener( MouseEvent.MOUSE_DOWN, onSendScore );
			}
			removeChild( tSendScoreBtn );
						
			mSystem.sendScore( GameVars.mGameScore.show( ) );
			
			/**
			 * add scoring meter from NP9_Generic_Game.as
			 */
			GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.sendScoringMeterToFront( );
			addEventListener( Event.ENTER_FRAME, onWaitForSendScore, false, 0, true );
			
		} // end onSendScore
		
		//===============================================================================
		// FUNCTION onWaitForSendScore( ): 
		//	- waits for user to click the restart button within the send score meter
		//===============================================================================
		public function onWaitForSendScore ( evt:Event ) : void
		{
			if ( mSystem.userClickedRestart( ) ) 
			{
				// swap scoring meter back - offline only 
				removeEventListener( Event.ENTER_FRAME, onWaitForSendScore );
				
				GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.sendScoringMeterToBack( );
							
				/**
				 * GameStartUp listens to BACK_TO_MAIN event
				 */
				Dispatcher.dispatchEvent( new DataEvent( BACK_TO_MAIN ) );				
			}
			
		} // end onWaitForSendScore
		
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{			
			mSystem = GlobalGameReference.mInstance.mGameStartUp.mSystem;
			mStage  = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage;
			
		} // end setupVars
	}
}