// ---------------------------------------------------------------------------------------
//
// CUSTOM GAME STRUCTURE CLASS
//
// CONTROLS SCENE NAVIGATION AND GAMING SYSTEM SETTINGS
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.game
{
	// SYSTEM IMPORTS
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// NP9 IMPORTS
	import com.neopets.projects.np9.game.NP9_Generic_Game;

	// CUSTOM IMPORTS
	import com.neopets.projects.np9.game.classGame;
	
	
	// -----------------------------------------------------------------------------------
	public class classGameStructure extends NP9_Generic_Game {

		// The actual game class
		private var _GAME:classGame;

		// the score
		private var _objGAMESCORE:Object;

		// CONSTANTS for Fonts & Sounds
		private static var _FONT_VERDANA:String = "myVerdana";
		private static var _FONT_COURIER:String = "myCourier";
		
		private static var _MUSIC_DRUMS:String  = "musicDrums";
		private static var _MUSIC_GUITAR:String = "musicGuitar";
		
		private static var _FX_ROLLOVER:String  = "fxRollover";
		private static var _FX_CLICK:String     = "fxClick";
		
		// Used in Custom Game Class
		public var _FX_BOUNCE:String = "fxBounce";
				
		// CONSTANTS for Game Structure States
		private static var _NULL:int          = 0;
		private static var _INIT:int          = 1;
		private static var _INTRO:int         = 2;
		private static var _INSTRUCTIONS:int  = 3;
		private static var _INSTRUCTIONS2:int = 4;
		private static var _GAMESCREEN:int    = 5;
		private static var _PLAY_GAME:int 	  = 6;
		private static var _STOP_GAME:int 	  = 7;
		private static var _GAMEOVER:int      = 8;
		private static var _SENDSCORE:int     = 9;
		private static var _WAITFORUSER:int   = 10;
		
		// Game Structure State Var
		private var _iState:int = _NULL;
		
		
        /* *******************************************************************************
	       ****************************************************************************
			
		  	CONSTRUCTOR
			INIT
			RESET
		  	MAIN
			
	       ****************************************************************************
	    ******************************************************************************* */
		
		// -------------------------------------------------------------------------------
		// Class Constructor
		// -------------------------------------------------------------------------------
		public function classGameStructure( objDocumentClass:Object ) {
			
			trace("\n**"+this+": "+"Instace created!");

			// INITIALIZE SUPERCLASS
			super( objDocumentClass );

			// INITIALIZE GAME STUFF
			init();
			
			// SET ENTERFRAME FUNCTION
			_ROOT.addEventListener( Event.ENTER_FRAME, main, false, 0, true );
		}
		
		// -------------------------------------------------------------------------------
		// Set Game Fonts and proceed to Intro Screen
		// -------------------------------------------------------------------------------
		private function init():void {
			
			// MAIN SCORE VAR
			_objGAMESCORE = _GAMINGSYSTEM.createEvar(0);

			// ADD GAME FONTS - PASS FONT OBJECTS AND ID
			// Params: Font Object, Internal ID
			
			_GAMINGSYSTEM.addFont( new _internalVerdana(),    "myVerdana" );
			_GAMINGSYSTEM.addFont( new _internalCourierNew(), "myCourier" );
			
			// ADD GAME SOUNDFX & MUSIC
			// Params: Sound Object, Internal ID, Flash for overlapping sounds
			
			_SOUND.addMusic( new musicDrums(),  _MUSIC_DRUMS,  false );
			_SOUND.addMusic( new musicGuitar(), _MUSIC_GUITAR, false );
			
			_SOUND.addFX   ( new fxRollover(), _FX_ROLLOVER, true  );
			_SOUND.addFX   ( new fxClick(),    _FX_CLICK,    true );
			_SOUND.addFX   ( new fxBounce(),   _FX_BOUNCE,   true );
			
			_SOUND.playMusic( _MUSIC_DRUMS, 0, 99999, 0, 0.75 );
			_SOUND.fadeMusic( _MUSIC_DRUMS, 1, -0.75, 2000 );
			
			_SOUND.playMusic( _MUSIC_GUITAR, 0, 99999, 0, -0.75 );
			_SOUND.fadeMusic( _MUSIC_GUITAR, 1, 0.75, 2000 );
			
			//_GAMINGSYSTEM.addSendScoreVar ( "test", "1" );
			
			// START GAME
			goTo("intro");
		}
		
		// -------------------------------------------------------------------------------
		// Event for Pre-render actions
		// -------------------------------------------------------------------------------
		private function onAdded( e:Event ):void {
			
			// translated game logo?
			if ( e.target.name == "mcLogo" ) {
				
				var frame:String = _GAMINGSYSTEM.getFlashParam("sLang");
				e.target.gotoAndStop( frame.toUpperCase() );
				
				_ROOT.removeEventListener( Event.ADDED, onAdded );
			}
		}
		
		// -------------------------------------------------------------------------------
		// Called from Intro Scene
		// -------------------------------------------------------------------------------
		public function resetGame():void {
			
			_iState = _INTRO;
		}
		
		// -------------------------------------------------------------------------------
		// The main loop of this class
		// -------------------------------------------------------------------------------
		private function main( e:Event ):void {
			
			switch ( _iState ) {
				
				case _INTRO:
					// idle after intro screen is initialized
					if ( initIntroScreen() ) {
						_iState = _NULL;
					}
					break;
					
				case _INSTRUCTIONS:
					// idle after instructions screen is initialized
					if ( initInstructionsScreen() ) {
						_iState = _NULL;
					}
					break;
					
				case _INSTRUCTIONS2:
					// idle after instructions screen 2 is initialized
					if ( initInstructionsScreen2() ) {
						_iState = _NULL;
					}
					break;
					
				case _GAMESCREEN:
					// idle after game screen is initialized
					if ( initGameScreen() ) {
						_iState = _PLAY_GAME;
					}
					break;

				case _PLAY_GAME:
					// This is where the actual Game Class takes over!
					// Create custom game object
					if ( _GAME != null ) _GAME = null;
					_GAME = new classGame( this, _ROOT, _GAMINGSYSTEM, _SOUND );
					_GAME.init();
					//
					_ROOT.stage.addEventListener( Event.ENTER_FRAME, _GAME.main, false, 0, true );
					//
					_GAMINGSYSTEM.sendTag("Game Started");
					//
					_SOUND.playMusic( "musicLoop", 0, 99999 );
					//
					_iState = _NULL;
					break;
					
				case _STOP_GAME:
					// Remove listeners
					_ROOT.stage.removeEventListener( Event.ENTER_FRAME, _GAME.main );
					//
					_GAMINGSYSTEM.sendTag("Game Finished");
					//
					_iState = _GAMEOVER;
					break;
					
				case _GAMEOVER:
					// idle after game over screen is initialized
					if ( initGameOverScreen() ) {
						_iState = _NULL;
					}
					break;
					
				case _SENDSCORE:
					// initialize send score screen
					if ( initSendScoreScreen() ) {
						// Send Score
						_GAMINGSYSTEM.sendScore( int(_objGAMESCORE.show()) );
						// swap scoring meter - offline only 
						sendScoringMeterToFront();
						// now wait for user to restart the game
						_iState = _WAITFORUSER;
					}
					break;
					
				case _WAITFORUSER:
					// wait for user to click Restart Game on the Scoring Meter
					if ( _GAMINGSYSTEM.userClickedRestart() ) {
						// swap scoring meter back - offline only 
						sendScoringMeterToBack();
						// restart the game
						goTo("intro");
						_iState = _INTRO;
					}
					break;
					
				case _NULL:
					// idle state
					break;
			}
		}

		
        /* *******************************************************************************
	       ****************************************************************************
			
			GOTO FRAME/SCENE
			CHECK FRAME/SCENE INITIALIZATION BY FLASH
			SET BUTTONS/TEXT
			
	       ****************************************************************************
	    ******************************************************************************* */
		
		// -------------------------------------------------------------------------------
		// Navigate to one of the game scenes
		// -------------------------------------------------------------------------------
		private function goTo( p_sGoTo:String ):void {
			
			// ---------------------------------------------------------------------------
			// Add listener for ADDED event - so that we can perform pre-render actions,
			// like selecting the correct frame in the translated logo
			// ---------------------------------------------------------------------------
			if ( !_ROOT.hasEventListener( Event.ADDED ) ) {			
				_ROOT.addEventListener( Event.ADDED, onAdded, false, 0, true );
			}
			
			// now go to frame
			switch ( p_sGoTo.toUpperCase() ) {
				
				case "INTRO":
					_ROOT.gotoAndStop("introFrame","GAME_INTRO");
					break;
					
				case "INSTRUCTIONS":
					_ROOT.gotoAndStop("instructionsFrame1","GAME_INSTRUCTIONS");
					break;
					
				case "INSTRUCTIONS2":
					_ROOT.gotoAndStop("instructionsFrame2","GAME_INSTRUCTIONS");
					break;
					
				case "GAME":
					_ROOT.gotoAndStop("gameFrame","GAME_PLAY");
					break;
					
				case "GAMEOVER":
					_ROOT.gotoAndStop("gameoverFrame","GAME_OVER");
					break;

				case "SENDSCORE":
					_ROOT.gotoAndStop("sendscoreFrame","GAME_SEND_SCORE");
					break;
			}
		}
		
		// -------------------------------------------------------------------------------
		// Make sure scene/frame is fully initialized by Flash!
		// -------------------------------------------------------------------------------
		private function allObjectsInitialized():Boolean {
			
			var bOK:Boolean = true;
			
			for ( var i:int=0; i<_ROOT.numChildren; i++ ) {
				if ( _ROOT.getChildAt(i) == null ) {
					bOK = false;
				}
			}
			
			return ( bOK );
		}

		// -------------------------------------------------------------------------------
		private function initIntroScreen():Boolean {
			
			var bInitOK:Boolean = false;
			
			if ( bInitOK = allObjectsInitialized() ) {
				initMainButton( _ROOT.butPlay,  _ROOT.butPlay.tfield,  "FGS_MAIN_MENU_START_GAME",        startGame );
				initMainButton( _ROOT.butHelp,  _ROOT.butHelp.tfield,  "FGS_MAIN_MENU_VIEW_INSTRUCTIONS", viewInstructions );
				initMainButton( _ROOT.butSound, _ROOT.butSound.tfield, "", toggleSound );
				
				updateSoundButton();
			}

			return ( bInitOK );
		}
		
		// -------------------------------------------------------------------------------
		private function initInstructionsScreen():Boolean {
			
			var bInitOK:Boolean = false;
			
			if ( bInitOK = allObjectsInitialized() ) {

				// Gaming System Help
				var t_sText:String = _GETHELPTEXT();
			
				_GAMINGSYSTEM.setFont( "myCourier" );
				_GAMINGSYSTEM.setTextField( _ROOT.mcHelp.tfHelp, t_sText );
			
				// init scrollbar:
				// target textfield, sliderbut min y, sliderbut max y
				_ROOT.mcHelp.mcScrollbar.init( _ROOT.mcHelp.tfHelp, 20, 330 );
				
				initMainButton( _ROOT.butBack,  _ROOT.butBack.tfield,  "FGS_OTHER_MENU_GO_BACK", goBack, "myCourier" );
				initMainButton( _ROOT.butMore,  _ROOT.butMore.tfield,  "FGS_OTHER_MENU_MORE", goNext, "myCourier" );
			}
			
			return ( bInitOK );
		}
		
		// -------------------------------------------------------------------------------
		private function initInstructionsScreen2():Boolean {
			
			var bInitOK:Boolean = false;
			
			if ( bInitOK = allObjectsInitialized() ) {

				// init scrollbar:
				// target mc, sliderbut min y, sliderbut max y, mc min y, mc max y, scroll speed
				_ROOT.mcHelp.mcScrollbar.init( _ROOT.mcHelp.mcExample, 20, 330, 0, -600, 10 );
				
				initMainButton( _ROOT.butBack2,  _ROOT.butBack2.tfield,  "FGS_OTHER_MENU_GO_BACK", goBack2, "myCourier" );
			}
			
			return ( bInitOK );
		}
		
		// -------------------------------------------------------------------------------
		private function initGameScreen():Boolean {
			
			var bInitOK:Boolean = false;
			
			if ( bInitOK = allObjectsInitialized() ) {
				
				initMainButton( _ROOT.butEnd,  _ROOT.butEnd.tfield,  "FGS_GAME_MENU_END_GAME", endGame );
			}
			
			return ( bInitOK );
		}

		// -------------------------------------------------------------------------------
		private function initGameOverScreen():Boolean {
			
			var bInitOK:Boolean = false;

			if ( bInitOK = allObjectsInitialized() ) {
				
				_GAMINGSYSTEM.setTextField( _ROOT.tfScore, String(_objGAMESCORE.show()) );
				
				initMainButton( _ROOT.butSend,  _ROOT.butSend.tfield,  "FGS_GAME_OVER_MENU_SEND_SCORE", sendScore );
				initMainButton( _ROOT.butRestart,  _ROOT.butRestart.tfield,  "FGS_GAME_OVER_MENU_RESTART_GAME", restartGame );
			}
			
			return ( bInitOK );
		}
		
		// -------------------------------------------------------------------------------
		private function initSendScoreScreen():Boolean {
			
			var bInitOK:Boolean = false;
			
			bInitOK = allObjectsInitialized();
			
			return ( bInitOK );
		}

		
        /* *******************************************************************************
	       ****************************************************************************
			
			BUTTON EVENTS
			BUTTON INITIALIZATION
			
	       ****************************************************************************
	    ******************************************************************************* */
		
		// -------------------------------------------------------------------------------
		// Set button text and onClick event
		// -------------------------------------------------------------------------------
		private function initMainButton( p_mc:MovieClip, p_tf:TextField,
										 p_sID:String, p_func:Function,
										 p_sFont:String = "myVerdana" ):void {
			
			var t_sText:String = _GAMINGSYSTEM.getTranslation("IDS_HTML_MENU_OPEN");
			t_sText += _GAMINGSYSTEM.getTranslation( p_sID );
			t_sText += _GAMINGSYSTEM.getTranslation("IDS_HTML_MENU_CLOSE");
			
			_GAMINGSYSTEM.setFont( p_sFont );
			_GAMINGSYSTEM.setTextField( p_tf, t_sText );
			
			// enable hand cursor
			p_mc.buttonMode = true;
			p_mc.mouseChildren = false;

			// mouse down/up func
			if ( !p_mc.hasEventListener( MouseEvent.MOUSE_DOWN ) ) {
				p_mc.addEventListener( MouseEvent.MOUSE_DOWN, mainButtonDown, false, 0, true ); }
			if ( !p_mc.hasEventListener( MouseEvent.MOUSE_UP ) ) {
				p_mc.addEventListener( MouseEvent.MOUSE_UP, p_func, false, 0, true ); }
			
			// mouse over/out funcs
			if ( !p_mc.hasEventListener( MouseEvent.MOUSE_OVER ) ) {
				p_mc.addEventListener( MouseEvent.MOUSE_OVER, mainButtonOver, false, 0, true ); }
			if ( !p_mc.hasEventListener( MouseEvent.MOUSE_OUT ) ) {
				p_mc.addEventListener( MouseEvent.MOUSE_OUT, mainButtonOut, false, 0, true ); }
		}
		

		// -------------------------------------------------------------------------------
		// Mouse rollover and rollout events
		// -------------------------------------------------------------------------------
		private function mainButtonOver( e:MouseEvent ):void {
			_SOUND.playFX( _FX_ROLLOVER );
			e.currentTarget.gotoAndStop(2);
		}
		private function mainButtonOut( e:MouseEvent ):void {
			e.currentTarget.gotoAndStop(1);
		}
		private function mainButtonDown( e:MouseEvent ):void {
			_SOUND.playFX( _FX_CLICK );
			e.currentTarget.gotoAndStop(3);
		}
		
		// -------------------------------------------------------------------------------
		private function startGame( e:MouseEvent ):void {
			
			goTo("game");
			_iState = _GAMESCREEN;
		}
		
		// -------------------------------------------------------------------------------
		private function endGame( e:MouseEvent ):void {
			
			// Let the game class know that the game is over!
			_GAME.gameOver()
		}

		// -------------------------------------------------------------------------------
		private function viewInstructions( e:MouseEvent ):void {
			
			goTo("instructions");
			_iState = _INSTRUCTIONS;
		}
		
		// -------------------------------------------------------------------------------
		private function goBack( e:MouseEvent ):void {
			
			// remove all eventListeners of the scrollbar
			_ROOT.mcHelp.mcScrollbar.destroy();
			
			goTo("intro");
			_iState = _INTRO;
		}
		
		// -------------------------------------------------------------------------------
		private function goNext( e:MouseEvent ):void {
			
			// remove all eventListeners of the scrollbar
			_ROOT.mcHelp.mcScrollbar.destroy();
			
			goTo("instructions2");
			_iState = _INSTRUCTIONS2;
		}
		
		// -------------------------------------------------------------------------------
		private function goBack2( e:MouseEvent ):void {
			
			// remove all eventListeners of the scrollbar
			_ROOT.mcHelp.mcScrollbar.destroy();
			
			goTo("instructions");
			_iState = _INSTRUCTIONS;
		}
		
		// -------------------------------------------------------------------------------
		private function toggleSound( e:MouseEvent ):void {
			
			var t_bMusic:Boolean = _SOUND.getMusic();
			var t_bFX:Boolean = _SOUND.getFX();
			
			if ( t_bMusic && t_bFX ) {
				_SOUND.setMusic( false );
				_SOUND.fadeMusic( _MUSIC_DRUMS, 0, 0.75, 2000 );
				_SOUND.fadeMusic( _MUSIC_GUITAR, 0, -0.75, 2000 );
			}
			else if ( !t_bMusic && t_bFX ) {
				_SOUND.setFX( false );
				_SOUND.fadeFX( "", 0, 1000 );
			}
			else if ( !t_bMusic && !t_bFX ) {
				_SOUND.setMusic( true );
				_SOUND.playMusic( _MUSIC_DRUMS, 0, 99999, 0, 0.75 );
				_SOUND.fadeMusic( _MUSIC_DRUMS, 1, -0.75, 2000 );
				_SOUND.playMusic( _MUSIC_GUITAR, 0, 99999, 0, -0.75 );
				_SOUND.fadeMusic( _MUSIC_GUITAR, 1, 0.75, 2000 );
			}
			else if ( t_bMusic && !t_bFX ) {
				_SOUND.setFX( true );
			}
			
			updateSoundButton();
		}
		
		// -------------------------------------------------------------------------------
		private function updateSoundButton():void {
			
			var t_bMusic:Boolean = _SOUND.getMusic();
			var t_bFX:Boolean = _SOUND.getFX();
			
			var t_sID:String = "";
			
			if ( t_bMusic && t_bFX ) t_sID = "FGS_MAIN_MENU_TURN_MUSIC_OFF";
			else if ( !t_bMusic && t_bFX ) t_sID = "FGS_MAIN_MENU_TURN_SOUND_OFF";
			else if ( !t_bMusic && !t_bFX ) t_sID = "FGS_MAIN_MENU_TURN_MUSIC_ON";
			else if ( t_bMusic && !t_bFX ) t_sID = "FGS_MAIN_MENU_TURN_SOUND_ON";
			
			var t_sText:String = _GAMINGSYSTEM.getTranslation("IDS_HTML_MENU_OPEN");
			t_sText += _GAMINGSYSTEM.getTranslation( t_sID );
			t_sText += _GAMINGSYSTEM.getTranslation("IDS_HTML_MENU_CLOSE");
			
			_ROOT.butSound.tfield.htmlText = t_sText;
		}
		
		// -------------------------------------------------------------------------------
		private function restartGame( e:MouseEvent ):void {

			goTo("intro");
			_iState = _INTRO;
		}
		
		// -------------------------------------------------------------------------------
		private function sendScore( e:MouseEvent ):void {
			
			goTo("sendscore");
			_iState = _SENDSCORE;
		}
		
		
        /* *******************************************************************************
	       ****************************************************************************
			
			CUSTOM FUNCTIONS - CALLED FROM GAME CLASS
			
	       ****************************************************************************
	    ******************************************************************************* */
		
		// -------------------------------------------------------------------------------
		public function gameOver( p_nScore:int ):void {
			
			_objGAMESCORE.changeTo( p_nScore );
			
			goTo("gameover");
			_iState = _STOP_GAME;
		}
		
		// -------------------------------------------------------------------------------
		//
		// -------------------------------------------------------------------------------
	}
}