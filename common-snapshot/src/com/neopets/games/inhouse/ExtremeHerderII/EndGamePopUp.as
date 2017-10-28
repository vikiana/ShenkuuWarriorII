package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// imports
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.system.ApplicationDomain;
	import flash.text.*;
	
	import virtualworlds.lang.TranslationManager;

	public class EndGamePopUp extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		internal static const POP_UP_DOWN        : String = "PopUpDown";
		internal static const END_GAME_CONFIRMED : String = "EndGameConfirmed";
		
		//===============================================================================
		// CONSTRUCTOR EndGamePopUp
		//===============================================================================		
		public function EndGamePopUp( )
		{
			super( );
			
			//trace( "EndGamePopUp in " + this + " called" );	
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			var tTransManager : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );
			
			if( tAssetLocation.hasDefinition( "GameOverPopUp" ) )
			{
				//trace( this + " says: button asset found" );
				var tGameOverPUClass : Class = tAssetLocation.getDefinition( "GameOverPopUp" ) as Class;
				var tGameOverPopUp   : MovieClip = new tGameOverPUClass( );
				
				addChild( tGameOverPopUp );
			}
			
			//=======================================
			// text
			//=======================================
			var tConfirmTextTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tConfirmTextTF      : MovieClip = new tConfirmTextTFClass( );
			tConfirmTextTF.name = "confirm_text_tf"; 
			tTransManager.setTextField( tConfirmTextTF.mTextField, tEHIITranslationData.IDS_CONFIRM_END_GAME_TEXT );
			tConfirmTextTF.mTextField.width = 400;
			tConfirmTextTF.mTextField.height = 60;
			tConfirmTextTF.x = -130;
			tConfirmTextTF.y = -60;
			this.addChild( tConfirmTextTF );
			
			//=======================================
			// confirm end game button
			//=======================================
			var tYesBtn        : GenericButton = new GenericButton( "GenericButton", "confirm_end_game_button", -130, 100 );			
			var tYesBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tYesBtnTF      : MovieClip = new tYesBtnTFClass( );
			tTransManager.setTextField( tYesBtnTF.mTextField, tEHIITranslationData.IDS_CONFIRM_END_GAME_BUTTON );
			tYesBtnTF.y = -3;
			tYesBtn.addChild( tYesBtnTF );
			this.addChild( tYesBtn );
			
			//=======================================
			// cancel end game button
			//=======================================
			var tNoBtn        : GenericButton = new GenericButton( "GenericButton", "cancel_end_game_button", 120, 100 );			
			var tNoBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
			var tNoBtnTF      : MovieClip = new tNoBtnTFClass( );
			tTransManager.setTextField( tNoBtnTF.mTextField, tEHIITranslationData.IDS_CANCEL_END_GAME_BUTTON );
			tNoBtnTF.y = -3;
			tNoBtn.addChild( tNoBtnTF );
			this.addChild( tNoBtn );
			
			this.x = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage.stageWidth / 2;
			this.y = 800;		
			
		} // end constructor
		
		//===============================================================================
		//  FUNCTION doAnimation
		//===============================================================================
		internal function doAnimation( ):void
		{
			//trace( "doAnimation in " + this + " called" );		
				
			this.addEventListener( Event.ENTER_FRAME, moveMeUp, false, 0, true );
			
		} // end doAnimation
		
		//===============================================================================
		//  FUNCTION moveMeUp
		//===============================================================================
		private function moveMeUp( evt : Event ):void
		{
			//trace( "moveMeUp in " + this + " called" );
			
			if( this.y > 250 )
			{
				this.y -= 40;
			}
			
			else
			{
				/**
				 * after pop up is all the way up, remove the event listener for the
				 * movement and add event listeners to the buttons
				 */
				this.removeEventListener( Event.ENTER_FRAME, moveMeUp );
				this.y = 250;
				
				if( this.getChildByName( "confirm_end_game_button" ) != null )
				{
					var tYesButton : GenericButton = this.getChildByName( "confirm_end_game_button" ) as GenericButton;
					tYesButton.addEventListener( MouseEvent.CLICK, btnClicked, false, 0, true );
				}
				
				if( this.getChildByName( "cancel_end_game_button" ) != null )
				{
					var tNoButton : GenericButton = this.getChildByName( "cancel_end_game_button" ) as GenericButton;
					tNoButton.addEventListener( MouseEvent.CLICK, btnClicked, false, 0, true );
				}
			}
			
		} //end moveMeUp
		
		//===============================================================================
		//  FUNCTION btnClicked
		//	- called when either button in pop up is clicked
		//===============================================================================
		private function btnClicked( evt : MouseEvent ):void
		{
			//trace( "btnClicked in " + this + " called" );
			
			/**
			 * remove event listeners from both buttons
			 */
			if( this.getChildByName( "confirm_end_game_button" ) != null )
			{
				var tYesButton : GenericButton = this.getChildByName( "confirm_end_game_button" ) as GenericButton;
				tYesButton.removeEventListener( MouseEvent.CLICK, btnClicked );
			}
			
			if( this.getChildByName( "cancel_end_game_button" ) != null )
			{
				var tNoButton : GenericButton = this.getChildByName( "cancel_end_game_button" ) as GenericButton;
				tNoButton.removeEventListener( MouseEvent.CLICK, btnClicked );
			}
			
			var tClickedButton : GenericButton = evt.target as GenericButton;
			
			/**
			 * determine which button was clicked and then call appropriate function
			 */
			switch( tClickedButton.name )
			{
				case "confirm_end_game_button":					
					trace( "tClickedButton.name: " + tClickedButton.name );
					/**
					 * GameStartUp listens for END_GAME_CONFIRMED event
					 */
					Dispatcher.dispatchEvent( new Event( END_GAME_CONFIRMED ) );		
					break;
					
				case "cancel_end_game_button":
					trace( "tClickedButton.name: " + tClickedButton.name );
					this.addEventListener( Event.ENTER_FRAME, moveMeDown, false, 0, true );
					break;
			}
						
		} //end btnClicked
		
		//===============================================================================
		//  FUNCTION moveMeDown
		//	- moves the pop up back down
		//===============================================================================
		private function moveMeDown( evt : Event ):void
		{
			if( this.y < 800 )
			{
				this.y += 40;
			}
			
			else
			{
				/**
				 * at this point, the pop up is moved all the way down and off the stage so
				 * remove the event listener and also the text and buttons to be safe
				 */
				this.removeEventListener( Event.ENTER_FRAME, moveMeDown );
				
				if( this.getChildByName( "confirm_text_tf" ) != null )
				{
					var tConfirmTextTF : MovieClip = this.getChildByName( "confirm_text_tf" ) as MovieClip;
					this.removeChild( tConfirmTextTF );
				}
				
				if( this.getChildByName( "confirm_end_game_button" ) != null )
				{
					var tYesButton : GenericButton = this.getChildByName( "confirm_end_game_button" ) as GenericButton;
					this.removeChild( tYesButton );
				}
				
				if( this.getChildByName( "cancel_end_game_button" ) != null )
				{
					var tNoButton : GenericButton = this.getChildByName( "cancel_end_game_button" ) as GenericButton;
					this.removeChild( tNoButton );
				}
				
				Dispatcher.dispatchEvent( new Event( POP_UP_DOWN ) );
			}
			
		} //end moveMeDown
		
		//===============================================================================
		// 	FUNCTION setupVars 
		//	- assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			//mGarbage = new Array( );
			
		} // end setupVars
		
	} // end class
	
} // end package