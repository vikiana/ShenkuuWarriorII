package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import virtualworlds.lang.TranslationManager;

	public class Instructions extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		internal static const BACK_TO_MAIN : String = "BackToMain";
		
		private var mStage : Stage;
		
		//===============================================================================
		// CONSTRUCTOR Instructions
		//===============================================================================
		public function Instructions( )
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
			var tInstrBGClass : Class = tAssetLocation.getDefinition( "InstructionsBG" ) as Class;			
			var tInstrBG      : MovieClip = new tInstrBGClass( );
			tInstrBG.x = mStage.stageWidth / 2;
			tInstrBG.y = mStage.stageHeight / 2;
			this.addChild( tInstrBG );
			
			//=======================================
			// frame
			//=======================================
			var tInstructionsFrameClass : Class = tAssetLocation.getDefinition( "InstructionsFrame" ) as Class;
			var tInstructionsFrame      : MovieClip = new tInstructionsFrameClass( );
			tInstructionsFrame.name = "instr_frame";
			tInstructionsFrame.x = mStage.stageWidth / 2;
			tInstructionsFrame.y = mStage.stageHeight / 2;
			this.addChild( tInstructionsFrame );
			
			//=======================================
			// instructions header and text
			//=======================================
			var tInstrHeaderTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tInstrHeaderTF      : MovieClip = new tInstrHeaderTFClass( );
			tTransManager.setTextField( tInstrHeaderTF.mTextField, tEHIITranslationData.IDS_INSTR_HEADER );
			tInstrHeaderTF.mTextField.width  = 300;
			tInstrHeaderTF.mTextField.height = 60;
			tInstrHeaderTF.x = -100;
			tInstrHeaderTF.y = -160;
			tInstructionsFrame.addChild( tInstrHeaderTF );
			
			var tInstrTextTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tInstrTextTF      : MovieClip = new tInstrTextTFClass( );
			tTransManager.setTextField( tInstrTextTF.mTextField, tEHIITranslationData.IDS_INSTR_TEXT );
			tInstrTextTF.mTextField.width  = 400;
			tInstrTextTF.mTextField.height = 300;
			tInstrTextTF.x = -140;
			tInstrTextTF.y = -80;
			tInstructionsFrame.addChild( tInstrTextTF );
			
			//=======================================
			// power up frame
			//=======================================
			var tInstrPowerUpFrameClass : Class = tAssetLocation.getDefinition( "InstructionsFrame" ) as Class;
			var tInstrPowerUpFrame      : MovieClip = new tInstrPowerUpFrameClass( );
			tInstrPowerUpFrame.name = "instr_power_up_frame";
			tInstrPowerUpFrame.x = mStage.stageWidth * 2;
			tInstrPowerUpFrame.y = mStage.stageHeight / 2;
			this.addChild( tInstrPowerUpFrame );
			
			var tInstrPowerUpHeaderTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tInstrPowerUpHeaderTF      : MovieClip = new tInstrPowerUpHeaderTFClass( );
			tTransManager.setTextField( tInstrPowerUpHeaderTF.mTextField, tEHIITranslationData.IDS_INSTR_POWER_UP_HEADER );
			tInstrPowerUpHeaderTF.mTextField.width  = 300;
			tInstrPowerUpHeaderTF.mTextField.height = 60;
			tInstrPowerUpHeaderTF.x = -100;
			tInstrPowerUpHeaderTF.y = -160;
			tInstrPowerUpFrame.addChild( tInstrPowerUpHeaderTF );
			
			/**
			 * speed up power up display
			 */
			var tPowerUpOneClass : Class = tAssetLocation.getDefinition( "PowerUpSpeedUp" ) as Class;
			var tPowerUpOne      : MovieClip = new tPowerUpOneClass( );
			tPowerUpOne.x = -200;
			tPowerUpOne.y = -70;
			tPowerUpOne.gotoAndStop( 2 );
			tInstrPowerUpFrame.addChild( tPowerUpOne );
			
			/**
			 * speed up power up text
			 */
			var tPowerUpOneDescTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tPowerUpOneDescTF      : MovieClip = new tPowerUpOneDescTFClass( );
			tTransManager.setTextField( tPowerUpOneDescTF.mTextField, tEHIITranslationData.IDS_POWER_UP_ONE_DESC );
			//tPowerUpOneDescTF.mTextField.border = true;
			tPowerUpOneDescTF.mTextField.width  = 400;
			//tPowerUpOneDescTF.mTextField.height = 60;
			tPowerUpOneDescTF.x = -90;
			tPowerUpOneDescTF.y = -70;
			tInstrPowerUpFrame.addChild( tPowerUpOneDescTF );
			
			/**
			 * freeze power up display
			 */
			var tPowerUpTwoClass : Class = tAssetLocation.getDefinition( "PowerUpFreeze" ) as Class;
			var tPowerUpTwo      : MovieClip = new tPowerUpTwoClass( );
			tPowerUpTwo.x = -200;
			tPowerUpTwo.y = 5;
			tPowerUpTwo.gotoAndStop( 2 );
			tInstrPowerUpFrame.addChild( tPowerUpTwo );
			
			
			/**
			 * freeze power up text
			 */
			var tPowerUpTwoDescTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tPowerUpTwoDescTF      : MovieClip = new tPowerUpTwoDescTFClass( );
			tTransManager.setTextField( tPowerUpTwoDescTF.mTextField, tEHIITranslationData.IDS_POWER_UP_TWO_DESC );
			//tPowerUpTwoDescTF.mTextField.border = true;
			tPowerUpTwoDescTF.mTextField.width  = 400;
			//tPowerUpTwoDescTF.mTextField.height = 60;
			tPowerUpTwoDescTF.x = -90;
			tPowerUpTwoDescTF.y = 5;
			tInstrPowerUpFrame.addChild( tPowerUpTwoDescTF );
			
			/**
			 * x2 power up display
			 */
			var tPowerUpThreeClass : Class = tAssetLocation.getDefinition( "PowerUpTwoPPs" ) as Class;
			var tPowerUpThree      : MovieClip = new tPowerUpThreeClass( );
			tPowerUpThree.x = -200;
			tPowerUpThree.y = 80;
			tPowerUpThree.gotoAndStop( 2 );
			tInstrPowerUpFrame.addChild( tPowerUpThree );
			
			/**
			 * x2 power up text
			 */
			var tPowerUpThreeDescTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tPowerUpThreeDescTF      : MovieClip = new tPowerUpThreeDescTFClass( );
			tTransManager.setTextField( tPowerUpThreeDescTF.mTextField, tEHIITranslationData.IDS_POWER_UP_THREE_DESC );
			//tPowerUpThreeDescTF.mTextField.border = true;
			tPowerUpThreeDescTF.mTextField.width  = 400;
			tPowerUpThreeDescTF.mTextField.height = 60;
			tPowerUpThreeDescTF.x = -90;
			tPowerUpThreeDescTF.y = 70;
			tInstrPowerUpFrame.addChild( tPowerUpThreeDescTF );
			
			/**
			 * waypoint power up display
			 */
			var tPowerUpFourClass : Class = tAssetLocation.getDefinition( "PowerUpWaypoint" ) as Class;
			var tPowerUpFour      : MovieClip = new tPowerUpFourClass( );
			tPowerUpFour.x = -200;
			tPowerUpFour.y = 155;
			tPowerUpFour.gotoAndStop( 2 );
			tInstrPowerUpFrame.addChild( tPowerUpFour );
			
			/**
			 * waypoint power up text
			 */
			var tPowerUpFourDescTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tPowerUpFourDescTF      : MovieClip = new tPowerUpFourDescTFClass( );
			tTransManager.setTextField( tPowerUpFourDescTF.mTextField, tEHIITranslationData.IDS_POWER_UP_FOUR_DESC );
			//tPowerUpFourDescTF.mTextField.border = true;
			tPowerUpFourDescTF.mTextField.width  = 400;
			tPowerUpFourDescTF.mTextField.height = 80;
			tPowerUpFourDescTF.x = -90;
			tPowerUpFourDescTF.y = 145;
			tInstrPowerUpFrame.addChild( tPowerUpFourDescTF );
						
			//=======================================
			// attach back to main button
			//=======================================
			var tBackToMainBtn        : GenericButton = new GenericButton( "GenericButton", "back_to_main_button", 90, 560 );			
			var tBackToMainBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tBackToMainBtnTF      : MovieClip = new tBackToMainBtnTFClass( );
			tTransManager.setTextField( tBackToMainBtnTF.mTextField, tEHIITranslationData.IDS_MAIN_MENU_BUTTON );
			tBackToMainBtnTF.y = -2;
			tBackToMainBtn.addChild( tBackToMainBtnTF );
			this.addChild( tBackToMainBtn );
			activateBackToMainButton( );
			
			//=======================================
			// attach back button
			//=======================================
			var tBackBtn        : GenericButton = new GenericButton( "GenericButton", "back_button", 290, 560 );			
			var tBackBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tBackBtnTF      : MovieClip = new tBackBtnTFClass( );
			tTransManager.setTextField( tBackBtnTF.mTextField, tEHIITranslationData.IDS_BACK_BUTTON );
			tBackBtnTF.y = -2;
			tBackBtn.addChild( tBackBtnTF );
			this.addChild( tBackBtn );	
			deactivateBackButton( );
			
			//=======================================
			// attach more button
			//=======================================	
			var tMoreBtn        : GenericButton = new GenericButton( "GenericButton", "more_button", 490, 560 );			
			var tMoreBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tMoreBtnTF      : MovieClip = new tMoreBtnTFClass( );
			tTransManager.setTextField( tMoreBtnTF.mTextField, tEHIITranslationData.IDS_MORE_BUTTON );
			tMoreBtnTF.y = -2;
			tMoreBtn.addChild( tMoreBtnTF );
			this.addChild( tMoreBtn );
			activateMoreButton( );
			
		} // end init		
				
		//===============================================================================
		// function backToMainMenu
		//	- called from mBackButton
		//===============================================================================
		private function backToMainMenu( evt : MouseEvent ):void
		{
			//trace( "backToMainMenu in " + this + " called" );
			
			deactivateAllButtons( );
			
			/**
			 * GameStartUp listens to BACK_TO_MAIN event
			 */
			Dispatcher.dispatchEvent( new DataEvent( BACK_TO_MAIN ) );
			
		} // end backToMainMenu
		
		//===============================================================================
		// FUNCTION doForwardAnimation
		//===============================================================================
		private function doForwardAnimation( evt : MouseEvent ) : void
		{	
			//trace( "doAnimation in " + this + " called" );
			
			deactivateMoreButton( );			
			deactivateBackToMainButton( );
			
			var tAnimatedInstrFrame        : MovieClip = getChildByName( "instr_frame" ) as MovieClip;
			var tAnimatedInstrPowerUpFrame : MovieClip = getChildByName( "instr_power_up_frame" ) as MovieClip;
			
			tAnimatedInstrFrame.addEventListener( Event.ENTER_FRAME, moveLeft, false, 0, true );			
			tAnimatedInstrPowerUpFrame.addEventListener( Event.ENTER_FRAME, moveLeft, false, 0, true );
			
		} // end doForwardAnimation
		
		//===============================================================================
		//  function moveLeft
		//===============================================================================
		private function moveLeft( evt : Event ):void
		{
			//trace( "moveLeft in " + this + " called" );
			
			var tAnimatedInstrFrame        : MovieClip = getChildByName( "instr_frame" ) as MovieClip;
			var tAnimatedInstrPowerUpFrame : MovieClip = getChildByName( "instr_power_up_frame" ) as MovieClip;
			
			if( tAnimatedInstrFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrFrame.x > -700 )
				{
					tAnimatedInstrFrame.x -= 40;
				}
						
				else
				{
					//trace( "event listener from tAnimatedInstrFrame removed" );
					tAnimatedInstrFrame.removeEventListener( Event.ENTER_FRAME, moveLeft );
					tAnimatedInstrFrame.x = -700;
					activateBackButton( );
					activateBackToMainButton( );
				}
			}
			
			if( tAnimatedInstrPowerUpFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrPowerUpFrame.x > mStage.stageWidth / 2 )
				{
					tAnimatedInstrPowerUpFrame.x -= 40;
				}
						
				else
				{
				
					//trace( "event listener from tAnimatedInstrPowerUpFrame removed" );
					tAnimatedInstrPowerUpFrame.removeEventListener( Event.ENTER_FRAME, moveLeft );
					tAnimatedInstrPowerUpFrame.x = mStage.stageWidth / 2;
				}
			}		
			
		} //end moveLeft
		
		//===============================================================================
		// FUNCTION doBackwardAnimation
		//===============================================================================
		private function doBackwardAnimation( evt : MouseEvent ) : void
		{	
			//trace( "doBackwardAnimation " + this + " called" );
			
			deactivateBackButton( );
			deactivateBackToMainButton( );			
			
			var tAnimatedInstrFrame        : MovieClip = getChildByName( "instr_frame" ) as MovieClip;
			var tAnimatedInstrPowerUpFrame : MovieClip = getChildByName( "instr_power_up_frame" ) as MovieClip;
			
			tAnimatedInstrFrame.addEventListener( Event.ENTER_FRAME, moveRight, false, 0, true );			
			tAnimatedInstrPowerUpFrame.addEventListener( Event.ENTER_FRAME, moveRight, false, 0, true );
			
		} // end doBackwardAnimation
		
		//===============================================================================
		//  function moveRight
		//===============================================================================
		private function moveRight( evt : Event ) : void
		{
			//trace( "moveRight " + this + " called" );
			var tAnimatedInstrFrame        : MovieClip = getChildByName( "instr_frame" ) as MovieClip;
			var tAnimatedInstrPowerUpFrame : MovieClip = getChildByName( "instr_power_up_frame" ) as MovieClip;
			
			if( tAnimatedInstrFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrFrame.x < mStage.stageWidth / 2 )
				{
					tAnimatedInstrFrame.x += 40;
				}
						
				else
				{
					//trace( "event listener from tAnimatedInstrFrame removed" );
					tAnimatedInstrFrame.removeEventListener( Event.ENTER_FRAME, moveRight );
					tAnimatedInstrFrame.x = mStage.stageWidth / 2;
					activateMoreButton( );
					activateBackToMainButton( );
				}
			}
			
			if( tAnimatedInstrPowerUpFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrPowerUpFrame.x < mStage.stageWidth * 2 )
				{
					tAnimatedInstrPowerUpFrame.x += 40;
				}
						
				else
				{
				
					//trace( "event listener from tAnimatedInstrPowerUpFrame removed" );
					tAnimatedInstrPowerUpFrame.removeEventListener( Event.ENTER_FRAME, moveRight );
					tAnimatedInstrPowerUpFrame.x = mStage.stageWidth * 2;
				}
			}		
			
		} //end moveRight
		
		//===============================================================================
		// FUNCTION activateBackToMainButton
		//===============================================================================
		internal function activateBackToMainButton( ):void
		{
			var tBackToMainButton : MovieClip = getChildByName( "back_to_main_button" ) as MovieClip;
			
			tBackToMainButton.addEventListener( MouseEvent.CLICK, backToMainMenu, false, 0, true );
			
		} // end activateBackToMainButton
		
		//===============================================================================
		// FUNCTION deactivateBackToMainButton
		//===============================================================================
		internal function deactivateBackToMainButton( ):void
		{
			var tBackToMainButton : MovieClip = getChildByName( "back_to_main_button" ) as MovieClip;
			
			if( tBackToMainButton.hasEventListener( MouseEvent.CLICK ) )
			{
				tBackToMainButton.removeEventListener( MouseEvent.CLICK, backToMainMenu );
			}
			
		} // end deactivateBackToMainButton
		
		//===============================================================================
		// FUNCTION activateMoreButton
		//===============================================================================
		internal function activateMoreButton( ):void
		{
			var tMoreButton : MovieClip = getChildByName( "more_button" ) as MovieClip;
			
			tMoreButton.addEventListener( MouseEvent.CLICK, doForwardAnimation, false, 0, true );
			tMoreButton.visible = true;
			
		} // end activateMoreButton
		
		//===============================================================================
		// FUNCTION deactivateMoreButton
		//===============================================================================
		internal function deactivateMoreButton( ):void
		{
			var tMoreButton : MovieClip = getChildByName( "more_button" ) as MovieClip;
			
			if( tMoreButton.hasEventListener( MouseEvent.CLICK ) )
			{
				tMoreButton.removeEventListener( MouseEvent.CLICK, doForwardAnimation );
			}
			
			tMoreButton.visible = false;
			
		} // end deactivateMoreButton
		
		//===============================================================================
		// FUNCTION activateBackButton
		//===============================================================================
		internal function activateBackButton( ):void
		{
			var tBackButton : MovieClip = getChildByName( "back_button" ) as MovieClip;
			
			tBackButton.addEventListener( MouseEvent.CLICK, doBackwardAnimation, false, 0, true );
			tBackButton.visible = true;
			
		} // end activateBackButton
		
		//===============================================================================
		// FUNCTION deactivateBackButton
		//===============================================================================
		internal function deactivateBackButton( ):void
		{
			var tBackButton : MovieClip = getChildByName( "back_button" ) as MovieClip;
			
			if( tBackButton.hasEventListener( MouseEvent.CLICK ) )
			{
				tBackButton.removeEventListener( MouseEvent.CLICK, doBackwardAnimation );
			}
			
			tBackButton.visible = false;
			
		} // end deactivateBackButton
		
		//===============================================================================
		// function deactivateAllButtons
		//===============================================================================
		private function deactivateAllButtons( ):void
		{
			deactivateBackToMainButton( );
			deactivateMoreButton( );
			deactivateBackButton( );
			
		} // end deactivateAllButtons
		
		//===============================================================================
		// FUNCTION setupVars
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mStage = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage;
			
		} // end setupVars
		
	} // end class
	
} // end package