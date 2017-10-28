// ---------------------------------------------------------------------------------------
//
// CUSTOM GAME CLASS
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.game
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;

	import flash.text.TextField;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.utils.getTimer;
	
	// CUSTOM IMPORTS

	
	// -----------------------------------------------------------------------------------
	public class classGame {

		// REFERENCE TO GAME STRUCTURE CLASS
		private var _PARENT:Object;
		
		// ROOT AND GAMING SYSTEM VARS
		private var _ROOT:Object;
		private var _GAMINGSYSTEM:Object;
		private var _SOUND:Object;
		
		// CONSTANTS for Game States
		private static var _NULL:int     = 0;
		private static var _PLAY:int     = 1;
		private static var _GAMEOVER:int = 2;
		
		// Game State Var
		private var _iGameState:int = _PLAY;
		
		// score evar
		private var _evarScore:Object;

		// game vars - use integers for better performance!
		private var _iScreenW:int;
		private var _iScreenH:int;

		private var _iXDir:int;
		private var _iYDir:int;
		private var _iXSpeed:int;
		private var _iYSpeed:int;
		
		private var _mcChar:MovieClip;
		
		// control speed of game
		private var _objGameSpeed:Object;
		
		// Framerate check
		private var _objFPS:Object;

		
        /* *******************************************************************************
	       ****************************************************************************
			
		  	CONSTRUCTOR
			GAME INITIALIZATION
		  	MAIN (ENTER FRAME) FUNCTION
			
	       ****************************************************************************
	    ******************************************************************************* */
		
		// -------------------------------------------------------------------------------
		public function classGame( p_Parent:Object, p_Root:Object,
								   p_GS:Object, p_SOUND:Object) {
			
			trace("**"+this+": "+"Instace created!\n");

			// reference to parent game structure class
			_PARENT = p_Parent;
			
			// reference to game document class (_root) and Gaming System
			_ROOT = p_Root;
			_GAMINGSYSTEM = p_GS;
			_SOUND = p_SOUND;

			// control speed of game
			_objGameSpeed = new Object();
			_objGameSpeed.iTimer     = new int( getTimer() );
			_objGameSpeed.iFPS       = new int(60);
			_objGameSpeed.iInterval  = new int( Math.ceil( 1000 / _objGameSpeed.iFPS ) );
			_objGameSpeed.iNextFrame = _objGameSpeed.iTimer;
			
			// Framerate check
			_objFPS = new Object();
			_objFPS.iCount     = new int(0);
			_objFPS.iNextCheck = new int(0);
			_objFPS.tfFPS      = _ROOT.getChildByName("tfFPS");
			
			// game stuff
			_iScreenW = 640;
			_iScreenH = 480;
			
			_iXDir = 1;
			_iYDir = 1;
			_iXSpeed = 5;
			_iYSpeed = 5;
		}
		
		// -------------------------------------------------------------------------------
		public function init():void {
			
			_evarScore = _GAMINGSYSTEM.createEvar(0);
			
			createCharacter();
		}
		
		// -------------------------------------------------------------------------------
		public function main( e:Event ):void {

			// control speed of game
			_objGameSpeed.iTimer = getTimer();
			if ( _objGameSpeed.iTimer < _objGameSpeed.iNextFrame ) return;
			// set next render frame 
			_objGameSpeed.iNextFrame += _objGameSpeed.iInterval;
			
			// show framerate
			_objFPS.iCount++;
			if ( _objGameSpeed.iTimer > _objFPS.iNextCheck ) {
				_objFPS.tfFPS.text = "FPS: "+String(_objFPS.iCount);
				_objFPS.iCount = 0;
				_objFPS.iNextCheck = _objGameSpeed.iTimer + 1000;
			}
			
			switch ( _iGameState ) {
				
				case _PLAY:
					moveCharacter();
					break;
					
				case _GAMEOVER:
					leaveGame();
					_iGameState = _NULL;
					break;
			}
		}
		
		
        /* *******************************************************************************
	       ****************************************************************************
			
		  	GAME STUFF
			
	       ****************************************************************************
	    ******************************************************************************* */
		
		// -------------------------------------------------------------------------------
		private function createCharacter():void {
			
			/*_mcChar = new mcCharacter();
			_mcChar.cacheAsBitmap = true;
			_mcChar.addEventListener( MouseEvent.CLICK, characterHit, false, 0, true );
			
			// enable hand cursor
			_mcChar.buttonMode = true;
			_mcChar.mouseChildren = false;

			_ROOT.addChild( _mcChar );*/
		}
		
		// -------------------------------------------------------------------------------
		private function moveCharacter():void {
			
			_mcChar.x += (_iXDir * _iXSpeed);
			_mcChar.y += (_iYDir * _iYSpeed);
			
			if ( (_mcChar.x + _mcChar.width) > _iScreenW ) {
				_mcChar.x = (_iScreenW - _mcChar.width);
				_iXDir *= -1;
				_SOUND.playFX( _PARENT._FX_BOUNCE );
			} else if ( _mcChar.x < 0 ) {
				_mcChar.x = 0;
				_iXDir *= -1;
				_SOUND.playFX( _PARENT._FX_BOUNCE );
			}
			
			if ( (_mcChar.y + _mcChar.height) > _iScreenH ) {
				_mcChar.y = (_iScreenH - _mcChar.height);
				_iYDir *= -1;
				_SOUND.playFX( _PARENT._FX_BOUNCE );
			} else if ( _mcChar.y < 0 ) {
				_mcChar.y = 0;
				_iYDir *= -1;
				_SOUND.playFX( _PARENT._FX_BOUNCE );
			}
		}

		// -------------------------------------------------------------------------------
		private function characterHit( e:MouseEvent ):void {
			
			_evarScore.changeTo(100);
			gameOver();
		}
		
		
        /* *******************************************************************************
	       ****************************************************************************
			
		  	GAME OVER STUFF
			
	       ****************************************************************************
	    ******************************************************************************* */

		// -------------------------------------------------------------------------------
		// can be called from 'end game button script' in game structure class
		// -------------------------------------------------------------------------------
		public function gameOver():void {
			
			_iGameState = _GAMEOVER;
		}
		
		// -------------------------------------------------------------------------------
		private function leaveGame():void {
			
			// remove all children - delete all objects
			cleanUp();
			
			// call gameOver function in game structure class - pass main score
			_PARENT.gameOver( int( _evarScore.show() ) );
		}
		
		// -------------------------------------------------------------------------------
		private function cleanUp():void {

			if ( _mcChar != null ) {
				_ROOT.removeChildAt( _ROOT.getChildIndex(_mcChar) );
				_mcChar = null;
			}
		}
		
		// -------------------------------------------------------------------------------
		//
		// -------------------------------------------------------------------------------
	}
}