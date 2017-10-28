package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// imports
	//===============================================================================
	import flash.display.*;
	import flash.events.*;

	public class InstructionsMenu extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mGamingSystem   : MovieClip;
		private var mGameMenu       : GameMenu;
		private var mGarbage        : Array;
		
		//===============================================================================
		// CONSTRUCTOR Blossoms
		//===============================================================================
		public function InstructionsMenu( )
		{
			super( );
			
			trace( "InstructionsMenu created" );
			
			setupVars( );		
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( pGamingSystem : MovieClip, pGameMenu : GameMenu ) : void
		{
			trace( "init in InstructionsMenu called" );
			
			mGamingSystem = pGamingSystem;
			mGameMenu     = pGameMenu;
			
			var tInstructionsBackground : BGInstructions = new BGInstructions( );
			mGarbage.push( tInstructionsBackground );
			addChild( tInstructionsBackground );
			
			//=======================================
			// instructions frame
			//=======================================
			var tInstructionsFrame : InstructionsFrame = new InstructionsFrame( );
			tInstructionsFrame.name = "InstrFrame";
			tInstructionsFrame.x = 40;
			tInstructionsFrame.y = 80;
			mGarbage.push( tInstructionsFrame );
			this.addChild( tInstructionsFrame );
			
			//=======================================
			// instructions header and text
			//=======================================
			var tInstructionsHeaderTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 410, 70, 72, 25 );			
			var tInstructionsHeaderText : String = mGamingSystem.getTranslation( "IDS_INSTRUCTIONS_HEADER" );
			mGameMenu.setText( "displayFont", tInstructionsHeaderTextDisplay, tInstructionsHeaderText );
			mGarbage.push( tInstructionsHeaderTextDisplay );	
			tInstructionsFrame.addChild( tInstructionsHeaderTextDisplay );
			
			var tInstructionsTextDisplay = new GenericTextField( "displayFont", "right", 0xFFFFFF, 20, 410, 250, 72, 120 );			
			var tInstructionsText : String = mGamingSystem.getTranslation( "IDS_INSTRUCTIONS_BODY" );
			mGameMenu.setText( "displayFont", tInstructionsTextDisplay, tInstructionsText );	
			mGarbage.push( tInstructionsTextDisplay );	
			tInstructionsFrame.addChild( tInstructionsTextDisplay );
			
			//=======================================
			// power up frame
			//=======================================
			var tInstructionsPowerUpFrame : InstructionsFrame = new InstructionsFrame( );
			tInstructionsPowerUpFrame.name = "InstrPowerUpFrame";
			tInstructionsPowerUpFrame.x = 700;
			tInstructionsPowerUpFrame.y = 80;
			mGarbage.push( tInstructionsPowerUpFrame );
			this.addChild( tInstructionsPowerUpFrame );
			
			var tPowerUpHeaderTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 410, 70, 72, 25 );			
			var tPowerUpHeaderText : String = mGamingSystem.getTranslation( "IDS_POWER_UP_HEADER" );
			mGameMenu.setText( "displayFont", tPowerUpHeaderTextDisplay, tPowerUpHeaderText );
			tInstructionsPowerUpFrame.addChild( tPowerUpHeaderTextDisplay );
			
			var tPowerUpOne : PowerUpOne = new PowerUpOne( );
			tPowerUpOne.x = 100;
			tPowerUpOne.y = 120;
			tPowerUpOne.scaleX = .4;
			tPowerUpOne.scaleY = .4;
			mGarbage.push( tPowerUpOne );
			tInstructionsPowerUpFrame.addChild( tPowerUpOne );
			
			var tPowerUpOneDescDisplay = new GenericTextField( "displayFont", "right", 0xFFFFFF, 20, 250, 60, 180, 120 );			
			var tPowerUpOneDescText : String = mGamingSystem.getTranslation( "IDS_POWER_ONE_DESC" );
			mGameMenu.setText( "displayFont", tPowerUpOneDescDisplay, tPowerUpOneDescText );
			tInstructionsPowerUpFrame.addChild( tPowerUpOneDescDisplay );
			
			var tPowerUpTwo : PowerUpTwo = new PowerUpTwo( );
			tPowerUpTwo.x = 100;
			tPowerUpTwo.y = 220;
			tPowerUpTwo.scaleX = .4;
			tPowerUpTwo.scaleY = .4;
			mGarbage.push( tPowerUpTwo );
			tInstructionsPowerUpFrame.addChild( tPowerUpTwo );
			
			var tPowerUpTwoDescDisplay = new GenericTextField( "displayFont", "right", 0xFFFFFF, 20, 250, 60, 180, 220 );			
			var tPowerUpTwoDescText : String = mGamingSystem.getTranslation( "IDS_POWER_TWO_DESC" );
			mGameMenu.setText( "displayFont", tPowerUpTwoDescDisplay, tPowerUpTwoDescText );
			tInstructionsPowerUpFrame.addChild( tPowerUpTwoDescDisplay );
			
			var tPowerUpThree : PowerUpThree = new PowerUpThree( );
			tPowerUpThree.x = 100;
			tPowerUpThree.y = 320;
			tPowerUpThree.scaleX = .4;
			tPowerUpThree.scaleY = .4;
			mGarbage.push( tPowerUpThree );
			tInstructionsPowerUpFrame.addChild( tPowerUpThree );
			
			var tPowerUpThreeDescDisplay = new GenericTextField( "displayFont", "right", 0xFFFFFF, 20, 250, 60, 180, 320 );			
			var tPowerUpThreeDescText : String = mGamingSystem.getTranslation( "IDS_POWER_THREE_DESC" );
			mGameMenu.setText( "displayFont", tPowerUpThreeDescDisplay, tPowerUpThreeDescText );
			tInstructionsPowerUpFrame.addChild( tPowerUpThreeDescDisplay );
			
			//=======================================
			// attach back to main button
			//=======================================	
			var tBackToMainButton : CenterAlignedButton = new CenterAlignedButton( );
			tBackToMainButton.name = "backToMainBtn";
			
			var tBackToMainBtnTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 100, 30, 15, 18 );			
			var tBackToMainBtnText : String = mGamingSystem.getTranslation( "IDS_MAIN_MENU_BUTTON" );
			mGameMenu.setText( "displayFont", tBackToMainBtnTextDisplay, tBackToMainBtnText );
			tBackToMainButton.addChild( tBackToMainBtnTextDisplay );
			
			tBackToMainButton.x = 50;
			tBackToMainButton.y = 528;
			tBackToMainButton.addEventListener( MouseEvent.CLICK, backToMainMenu, false, 0, true );
			mGarbage.push( tBackToMainButton );
			this.addChild( tBackToMainButton );
			
			//=======================================
			// attach back button
			//=======================================	
			var tBackButton : CenterAlignedButton = new CenterAlignedButton( );
			tBackButton.name = "backButton";
			
			var tBackBtnTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 100, 30, 15, 18 );			
			var tBackBtnText : String = mGamingSystem.getTranslation( "IDS_BACK_BUTTON" );
			mGameMenu.setText( "displayFont", tBackBtnTextDisplay, tBackBtnText );
			tBackButton.addChild( tBackBtnTextDisplay );
			
			tBackButton.x = 260;
			tBackButton.y = 528;
			mGarbage.push( tBackButton );
			this.addChild( tBackButton );
			deactivateBackButton( );
			
			//=======================================
			// attach more button
			//=======================================	
			var tMoreButton : CenterAlignedButton = new CenterAlignedButton( );
			tMoreButton.name = "moreButton";
			
			var tMoreBtnTextDisplay = new GenericTextField( "displayFont", "right", 0x000000, 20, 100, 30, 15, 18 );			
			var tMoreBtnText : String = mGamingSystem.getTranslation( "IDS_MORE_BUTTON" );
			mGameMenu.setText( "displayFont", tMoreBtnTextDisplay, tMoreBtnText );
			tMoreButton.addChild( tMoreBtnTextDisplay );
			
			tMoreButton.x = 460;
			tMoreButton.y = 528;
			mGarbage.push( tMoreButton );
			this.addChild( tMoreButton );
			activateMoreButton( );
			
		} // end init		
				
		//===============================================================================
		// function backToMainMenu( ): 
		//          - called from mBackButton
		//===============================================================================
		private function backToMainMenu( evt : MouseEvent ):void
		{
			var tBackToMainButton : CenterAlignedButton = getChildByName( "backToMainBtn" ) as CenterAlignedButton;
			
			if( tBackToMainButton.hasEventListener( MouseEvent.CLICK ) )
			{
				tBackToMainButton.removeEventListener( MouseEvent.CLICK, backToMainMenu );
			}
			
			clearMe( );
			mGameMenu.createMainMenu( );
			
		} // end backToMainMenu
		
		//===============================================================================
		// FUNCTION doForwardAnimation
		//===============================================================================
		private function doForwardAnimation( evt : MouseEvent ) : void
		{	
			trace( "doAnimation called" );
			
			deactivateMoreButton( );			
			deactivateBackToMainButton( );
			
			var tAnimatedInstrFrame        : InstructionsFrame = getChildByName( "InstrFrame" ) as InstructionsFrame;
			var tAnimatedInstrPowerUpFrame : InstructionsFrame = getChildByName( "InstrPowerUpFrame" ) as InstructionsFrame;
			
			tAnimatedInstrFrame.addEventListener( Event.ENTER_FRAME, moveLeft, false, 0, true );			
			tAnimatedInstrPowerUpFrame.addEventListener( Event.ENTER_FRAME, moveLeft, false, 0, true );
			
		} // end doForwardAnimation
		
		//===============================================================================
		//  function moveLeft( ):
		//===============================================================================
		private function moveLeft( evt : Event ) : void
		{
			trace( "moveLeft called" );
			var tAnimatedInstrFrame        : InstructionsFrame = getChildByName( "InstrFrame" ) as InstructionsFrame;
			var tAnimatedInstrPowerUpFrame : InstructionsFrame = getChildByName( "InstrPowerUpFrame" ) as InstructionsFrame;
			
			if( tAnimatedInstrFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrFrame.x > -700 )
				{
					tAnimatedInstrFrame.x -= 40;
				}
						
				else
				{
					trace( "event listener from tAnimatedInstrFrame removed" );
					tAnimatedInstrFrame.removeEventListener( Event.ENTER_FRAME, moveLeft );
					tAnimatedInstrFrame.x = -700;
					activateBackButton( );
					activateBackToMainButton( );
				}
			}
			
			if( tAnimatedInstrPowerUpFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrPowerUpFrame.x > 40 )
				{
					tAnimatedInstrPowerUpFrame.x -= 40;
				}
						
				else
				{
				
					trace( "event listener from tAnimatedInstrPowerUpFrame removed" );
					tAnimatedInstrPowerUpFrame.removeEventListener( Event.ENTER_FRAME, moveLeft );
					tAnimatedInstrPowerUpFrame.x = 40;
				}
			}		
			
		} //end moveLeft
		
		//===============================================================================
		// FUNCTION doBackwardAnimation
		//===============================================================================
		private function doBackwardAnimation( evt : MouseEvent ) : void
		{	
			trace( "doBackwardAnimation called" );
			
			deactivateBackButton( );
			deactivateBackToMainButton( );
			
			var tAnimatedInstrFrame        : InstructionsFrame = getChildByName( "InstrFrame" ) as InstructionsFrame;
			var tAnimatedInstrPowerUpFrame : InstructionsFrame = getChildByName( "InstrPowerUpFrame" ) as InstructionsFrame;
			
			tAnimatedInstrFrame.addEventListener( Event.ENTER_FRAME, moveRight, false, 0, true );			
			tAnimatedInstrPowerUpFrame.addEventListener( Event.ENTER_FRAME, moveRight, false, 0, true );
			
		} // end doBackwardAnimation
		
		//===============================================================================
		//  function moveRight( ):
		//===============================================================================
		private function moveRight( evt : Event ) : void
		{
			trace( "moveRight called" );
			var tAnimatedInstrFrame        : InstructionsFrame = getChildByName( "InstrFrame" ) as InstructionsFrame;
			var tAnimatedInstrPowerUpFrame : InstructionsFrame = getChildByName( "InstrPowerUpFrame" ) as InstructionsFrame;
			
			if( tAnimatedInstrFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrFrame.x < 0 )
				{
					tAnimatedInstrFrame.x += 40;
				}
						
				else
				{
					trace( "event listener from tAnimatedInstrFrame removed" );
					tAnimatedInstrFrame.removeEventListener( Event.ENTER_FRAME, moveRight );
					tAnimatedInstrFrame.x = 40;
					activateMoreButton( );
					activateBackToMainButton( );
				}
			}
			
			if( tAnimatedInstrPowerUpFrame.hasEventListener( Event.ENTER_FRAME ) )
			{
				if( tAnimatedInstrPowerUpFrame.x < 700 )
				{
					tAnimatedInstrPowerUpFrame.x += 40;
				}
						
				else
				{
				
					trace( "event listener from tAnimatedInstrPowerUpFrame removed" );
					tAnimatedInstrPowerUpFrame.removeEventListener( Event.ENTER_FRAME, moveRight );
					tAnimatedInstrPowerUpFrame.x = 700;
				}
			}		
			
		} //end moveRight
		
		//===============================================================================
		// FUNCTION activateBackToMainButton
		//===============================================================================
		internal function activateBackToMainButton( ):void
		{
			var tBackToMainButton : CenterAlignedButton = getChildByName( "backToMainBtn" ) as CenterAlignedButton;
			
			tBackToMainButton.addEventListener( MouseEvent.CLICK, backToMainMenu, false, 0, true );
			
		} // end activateBackToMainButton
		
		//===============================================================================
		// FUNCTION deactivateBackToMainButton
		//===============================================================================
		internal function deactivateBackToMainButton( ):void
		{
			var tBackToMainButton : CenterAlignedButton = getChildByName( "backToMainBtn" ) as CenterAlignedButton;
			
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
			var tMoreButton : CenterAlignedButton = getChildByName( "moreButton" ) as CenterAlignedButton;
			
			tMoreButton.addEventListener( MouseEvent.CLICK, doForwardAnimation, false, 0, true );
			tMoreButton.visible = true;
			
		} // end activateMoreButton
		
		//===============================================================================
		// FUNCTION deactivateMoreButton
		//===============================================================================
		internal function deactivateMoreButton( ):void
		{
			var tMoreButton : CenterAlignedButton = getChildByName( "moreButton" ) as CenterAlignedButton;
			
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
			var tBackButton : CenterAlignedButton = getChildByName( "backButton" ) as CenterAlignedButton;
			
			tBackButton.addEventListener( MouseEvent.CLICK, doBackwardAnimation, false, 0, true );
			tBackButton.visible = true;
			
		} // end activateBackButton
		
		//===============================================================================
		// FUNCTION deactivateBackButton
		//===============================================================================
		internal function deactivateBackButton( ):void
		{
			var tBackButton : CenterAlignedButton = getChildByName( "backButton" ) as CenterAlignedButton;
			
			if( tBackButton.hasEventListener( MouseEvent.CLICK ) )
			{
				tBackButton.removeEventListener( MouseEvent.CLICK, doBackwardAnimation );
			}
			
			tBackButton.visible = false;
			
		} // end deactivateBackButton
		
		//===============================================================================
		// FUNCTION clearMe
		//===============================================================================
		internal function clearMe( ):void
		{
			for( var i : int = mGarbage.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = mGarbage[ i ];
				
				if( tCurrentObject.parent != null )
				{
					tCurrentObject.parent.removeChild( tCurrentObject );
					tCurrentObject = null;					
				}
			}
			
			mGarbage = new Array( );
			
		} // end clearMe
		
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