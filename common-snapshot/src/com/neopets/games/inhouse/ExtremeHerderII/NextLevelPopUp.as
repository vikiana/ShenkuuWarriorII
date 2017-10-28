package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// imports
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.system.ApplicationDomain;
	import flash.text.*;
	
	import virtualworlds.lang.TranslationManager;

	public class NextLevelPopUp extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		internal static const POP_UP_DOWN : String = "PopUpDown";
		internal static const NEXT_LEVEL  : String = "NextLevel";
		internal static const END_GAME    : String = "EndGame";
		internal static const GAME_OVER   : String = "GameOver";
		
		private var mStage : Stage;
		private var mLevel : int;
		
		//===============================================================================
		// CONSTRUCTOR EndGamePopUp
		//===============================================================================		
		public function NextLevelPopUp( pLevel : int )
		{
			super( );
			
			mLevel = pLevel;
			
			setupVars( );
			
			//trace( "NextLevelPopUp in " + this + " called" );	
			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			var tTransManager : TranslationManager = TranslationManager.instance;
			var tEHIITranslationData : EHIITranslationData = EHIITranslationData( tTransManager.translationData );
			
			if( tAssetLocation.hasDefinition( "GenericPopUp" ) )
			{
				//trace( this + " says: button asset found" );
				var tNextLevelPUClass : Class = tAssetLocation.getDefinition( "GenericPopUp" ) as Class;
				var tNextLevelPopUp   : MovieClip = new tNextLevelPUClass( );
				
				addChild( tNextLevelPopUp );
			}
			
			/**
			 * in after levels 1 - 19 the pop up informs user that they have
			 * reached the next level and the continue button continues the game
			 */
			if( mLevel < 20 )
			{
				//=======================================
				// text
				//=======================================
				var tNextLevelTextTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
				var tNextLevelTextTF      : MovieClip = new tNextLevelTextTFClass( );
				tNextLevelTextTF.name = "next_level_text_tf"; 
				tTransManager.setTextField( tNextLevelTextTF.mTextField, tEHIITranslationData.IDS_NEXT_LEVEL_TEXT );
				tNextLevelTextTF.mTextField.width = 400;
				tNextLevelTextTF.mTextField.height = 60;
				tNextLevelTextTF.x = -130;
				tNextLevelTextTF.y = -60;
				this.addChild( tNextLevelTextTF );
			
				//=======================================
				// continue button
				//=======================================
				var tContinueBtn        : GenericButton = new GenericButton( "GenericButton", "continue_button", 0, 100, 1.1, 1, true, 20, 20 );			
				var tContinueBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
				var tContinueBtnTF      : MovieClip = new tContinueBtnTFClass( );
				tTransManager.setTextField( tContinueBtnTF.mTextField, tEHIITranslationData.IDS_CONTINUE );
				//tContinueBtnTF.mTextField.border = true;
				tContinueBtnTF.y = -2;
				tContinueBtn.addChild( tContinueBtnTF );
				this.addChild( tContinueBtn );
			}
			
			/**
			 * after level 20 the pop up informs user that they have beaten the game
			 * and the continue button takes them to game over screen
			 */
			else
			{
				//=======================================
				// text
				//=======================================
				var tGameFinishedTextTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
				var tGameFinishedTextTF      : MovieClip = new tGameFinishedTextTFClass( );
				tGameFinishedTextTF.name = "next_level_text_tf"; 
				tTransManager.setTextField( tGameFinishedTextTF.mTextField, tEHIITranslationData.IDS_FINISHED_TEXT );
				//tGameFinishedTextTF.mTextField.border = true;
				tGameFinishedTextTF.mTextField.width = 400;
				tGameFinishedTextTF.mTextField.height = 80;
				tGameFinishedTextTF.x = -150;
				tGameFinishedTextTF.y = -60;
				this.addChild( tGameFinishedTextTF );
			
				//=======================================
				// continue button
				//=======================================
				var tGameFinishedBtn        : GenericButton = new GenericButton( "GenericButton", "game_finished_button", 0, 100, 1.1, 1, true, 20, 20 );			
				var tGameFinishedBtnTFClass : Class     = tAssetLocation.getDefinition( "GenericTextField" ) as Class;
				var tGameFinishedBtnTF      : MovieClip = new tGameFinishedBtnTFClass( );
				tTransManager.setTextField( tGameFinishedBtnTF.mTextField, tEHIITranslationData.IDS_CONTINUE );
				//tGameFinishedBtnTF.mTextField.border = true;
				tGameFinishedBtnTF.y = -2;
				tGameFinishedBtn.addChild( tGameFinishedBtnTF );
				this.addChild( tGameFinishedBtn );
			}
			
			this.x = mStage.stageWidth / 2;
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
			
			if( this.y > 300 )
			{
				this.y -= 40;
			}
			
			else
			{
				/**
				 * after pop up is all the way up, remove the event listener for the
				 * movement and add event listeners to the button
				 */
				this.removeEventListener( Event.ENTER_FRAME, moveMeUp );
				this.y = 300;
				
				if( this.getChildByName( "continue_button" ) != null )
				{
					var tContinueBtn : GenericButton = this.getChildByName( "continue_button" ) as GenericButton;
					tContinueBtn.addEventListener( MouseEvent.CLICK, btnClicked, false, 0, true );
				}
				
				if( this.getChildByName( "game_finished_button" ) != null )
				{
					var tGameFinishedBtn : GenericButton = this.getChildByName( "game_finished_button" ) as GenericButton;
					tGameFinishedBtn.addEventListener( MouseEvent.CLICK, btnClicked, false, 0, true );
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
			 * remove event listeners from buttons after it was clicked
			 */
			if( this.getChildByName( "continue_button" ) != null )
			{
				var tContinueBtn : GenericButton = this.getChildByName( "continue_button" ) as GenericButton;
				tContinueBtn.removeEventListener( MouseEvent.CLICK, btnClicked );
			}
			
			if( this.getChildByName( "game_finished_button" ) != null )
			{
				var tGameFinishedBtn : GenericButton = this.getChildByName( "game_finished_button" ) as GenericButton;
				tGameFinishedBtn.removeEventListener( MouseEvent.CLICK, btnClicked );
			}
			
			/**
			 * determine which button was clicked and then call appropriate function
			 */
			var tClickedButton : GenericButton = evt.target as GenericButton;
			switch( tClickedButton.name )
			{
				case "continue_button":					
					trace( "tClickedButton.name: " + tClickedButton.name );					
					this.addEventListener( Event.ENTER_FRAME, moveMeDown, false, 0, true );		
					break;
					
				case "game_finished_button":
					trace( "tClickedButton.name: " + tClickedButton.name );
					/**
					 * ExtremeHerderIIGame listens to END_GAME event
					 */
					Dispatcher.dispatchEvent( new Event( END_GAME ) );
					
					/**
					 * GameStartUp listens for GAME_OVER event
					 */
					Dispatcher.dispatchEvent( new Event( GAME_OVER ) );
					break;
			}
									
		} //end btnClicked
		
		//===============================================================================
		//  FUNCTION moveMeDown
		//	- moves the pop up back down
		//===============================================================================
		private function moveMeDown( evt : Event ):void
		{
			//trace( "moveMeDown in " + this + " called" );
			
			if( this.y < 800 )
			{
				this.y += 40;
			}
			
			else
			{
				/**
				 * at this point, the pop up is moved all the way down and off the stage so
				 * remove the event listener and also the text and button
				 */
				this.removeEventListener( Event.ENTER_FRAME, moveMeDown );
				
				if( this.getChildByName( "next_level_text_tf" ) != null )
				{
					var tNextLevelTextTF : MovieClip = this.getChildByName( "next_level_text_tf" ) as MovieClip;
					this.removeChild( tNextLevelTextTF );
				}
				
				if( this.getChildByName( "continue_button" ) != null )
				{
					var tContinueBtn : GenericButton = this.getChildByName( "continue_button" ) as GenericButton;
					this.removeChild( tContinueBtn );
				}
				
				Dispatcher.dispatchEvent( new Event( NEXT_LEVEL ) );
			}
			
		} //end moveMeDown
		
		//===============================================================================
		// 	FUNCTION setupVars 
		//	- assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mStage = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage;
			
		} // end setupVars
		
	} // end class
	
} // end package