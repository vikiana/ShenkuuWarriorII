// ---------------------------------------------------------------------------------------
// SCROLLBAR CLASS
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.game
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// CUSTOM IMPORTS
	
	
	// -----------------------------------------------------------------------------------
	public class NP9_Scrollbar_Movieclip extends MovieClip
	{
		private var _mcSlider:MovieClip;
		private var _mcButUp:MovieClip;
		private var _mcButDown:MovieClip;
		
		private var _sliderIsActive:Boolean;
		private var _iSliderClickedY:int;
		
		private var _mcTarget:MovieClip;
		private var _iMinY:int;
		private var _iMaxY:int;
		private var _iMcMinY:int;
		private var _iMcMaxY:int;
		private var _iScrollSpeed:int;
		
		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_Scrollbar_Movieclip() {
			
			_mcSlider  = this.slider;
			_mcButUp   = this.up;
			_mcButDown = this.down;
			
			_sliderIsActive  = false;
			_iSliderClickedY = 0;
		}
		
		// -------------------------------------------------------------------------------
		// DESTRUCTOR
		// -------------------------------------------------------------------------------
		public function destroy() {
			
			_mcButUp.removeEventListener( MouseEvent.MOUSE_OVER, hiliteButton );
			_mcButUp.removeEventListener( MouseEvent.MOUSE_OUT,  dehiliteButton );
			_mcButUp.removeEventListener( MouseEvent.MOUSE_DOWN, activateButton );
			_mcButUp.removeEventListener( MouseEvent.MOUSE_UP,   deactivateButton );
			
			_mcButDown.removeEventListener( MouseEvent.MOUSE_OVER, hiliteButton );
			_mcButDown.removeEventListener( MouseEvent.MOUSE_OUT,  dehiliteButton );
			_mcButDown.removeEventListener( MouseEvent.MOUSE_DOWN, activateButton );
			_mcButDown.removeEventListener( MouseEvent.MOUSE_UP,   deactivateButton );
			
			_mcSlider.removeEventListener( MouseEvent.MOUSE_OVER, hiliteSlider );
			_mcSlider.removeEventListener( MouseEvent.MOUSE_OUT,  dehiliteSlider );
			_mcSlider.removeEventListener( MouseEvent.MOUSE_DOWN, activateSlider );
			_mcSlider.removeEventListener( MouseEvent.MOUSE_UP,   deactivateSlider );
			
			_mcTarget.removeEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelSlider );
			
			if ( _mcButUp.hasEventListener( Event.ENTER_FRAME ) ) {
					_mcButUp.removeEventListener( Event.ENTER_FRAME, moveAllUp ); }
			if ( _mcButDown.hasEventListener( Event.ENTER_FRAME ) ) {
				_mcButDown.removeEventListener( Event.ENTER_FRAME, moveAllDown ); }
			if ( _mcSlider.hasEventListener( Event.ENTER_FRAME ) ) {
				_mcSlider.removeEventListener( Event.ENTER_FRAME, moveSlider ); }
		}
		
		// -------------------------------------------------------------------------------
		// INIT 
		// -------------------------------------------------------------------------------
		public function init( p_mc:MovieClip, p_iMin:int, p_iMax:int,
		                      p_iMcMin:int, p_iMcMax:int,
		                      p_iSpeed:int = 10 ):void {
			
			_mcTarget     = p_mc;
			_iMinY        = p_iMin;
			_iMaxY        = p_iMax;
			_iMcMinY      = p_iMcMin;
			_iMcMaxY      = p_iMcMax;
			_iScrollSpeed = p_iSpeed;
			
			setButtonFuncs();
		}
		
		// -------------------------------------------------------------------------------
		// SET FUNCTIONS FOR SLIDER AND UP/DOWN BUTTONS
		// -------------------------------------------------------------------------------
		private function setButtonFuncs():void {
			
			_mcButUp.addEventListener( MouseEvent.MOUSE_OVER, hiliteButton,     false, 0, true );
			_mcButUp.addEventListener( MouseEvent.MOUSE_OUT,  dehiliteButton,   false, 0, true );
			_mcButUp.addEventListener( MouseEvent.MOUSE_DOWN, activateButton,   false, 0, true );
			_mcButUp.addEventListener( MouseEvent.MOUSE_UP,   deactivateButton, false, 0, true );
			
			_mcButDown.addEventListener( MouseEvent.MOUSE_OVER, hiliteButton,     false, 0, true );
			_mcButDown.addEventListener( MouseEvent.MOUSE_OUT,  dehiliteButton,   false, 0, true );
			_mcButDown.addEventListener( MouseEvent.MOUSE_DOWN, activateButton,   false, 0, true );
			_mcButDown.addEventListener( MouseEvent.MOUSE_UP,   deactivateButton, false, 0, true );
			
			_mcSlider.addEventListener( MouseEvent.MOUSE_OVER, hiliteSlider,     false, 0, true );
			_mcSlider.addEventListener( MouseEvent.MOUSE_OUT,  dehiliteSlider,   false, 0, true );
			_mcSlider.addEventListener( MouseEvent.MOUSE_DOWN, activateSlider,   false, 0, true );
			_mcSlider.addEventListener( MouseEvent.MOUSE_UP,   deactivateSlider, false, 0, true );
			
			_mcTarget.addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelSlider, false, 0, true );
			
			// enable hand cursor
			_mcButUp.buttonMode = true;
			_mcButUp.mouseChildren = false;
			
			_mcButDown.buttonMode = true;
			_mcButDown.mouseChildren = false;
			
			_mcSlider.buttonMode = true;
			_mcSlider.mouseChildren = false;
		}
		
		// -------------------------------------------------------------------------------
		// BUTTON EVENTS
		// -------------------------------------------------------------------------------
		private function hiliteButton( e:MouseEvent ):void {
			
			e.target.gotoAndStop(2);
		}
		
		// -------------------------------------------------------------------------------
		private function dehiliteButton( e:MouseEvent ):void {
			
			e.target.gotoAndStop(1);
			removeButtonListener( e );
		}
		
		// -------------------------------------------------------------------------------
		private function activateButton( e:MouseEvent ):void {
			
			e.target.gotoAndStop(3);
			
			if ( e.target == _mcButUp ) {
				_mcButUp.addEventListener( Event.ENTER_FRAME, moveAllUp, false, 0, true );			
			} else if ( e.target == _mcButDown ) {
				_mcButDown.addEventListener( Event.ENTER_FRAME, moveAllDown, false, 0, true );
			}
		}
		
		// -------------------------------------------------------------------------------
		private function deactivateButton( e:MouseEvent ):void {
			
			e.target.gotoAndStop(2);
			removeButtonListener( e );
		}
		
		// -------------------------------------------------------------------------------
		private function moveAllUp( e:Event ):void {

			_mcTarget.y += _iScrollSpeed;
			if ( _mcTarget.y > _iMcMinY ) _mcTarget.y = _iMcMinY;
			
			updateSlider();
		}
		
		// -------------------------------------------------------------------------------
		private function moveAllDown( e:Event ):void {

			_mcTarget.y -= _iScrollSpeed;
			if ( _mcTarget.y < _iMcMaxY ) _mcTarget.y = _iMcMaxY;
			
			updateSlider();
		}
		
		// -------------------------------------------------------------------------------
		private function removeButtonListener( e:MouseEvent ):void {

			if ( e.target == _mcButUp ) {
				if ( _mcButUp.hasEventListener( Event.ENTER_FRAME ) ) {
					_mcButUp.removeEventListener( Event.ENTER_FRAME, moveAllUp );
				}
			} else if ( e.target == _mcButDown ) {
				if ( _mcButDown.hasEventListener( Event.ENTER_FRAME ) ) {
					_mcButDown.removeEventListener( Event.ENTER_FRAME, moveAllDown );
				}
			}
		}
		
		// -------------------------------------------------------------------------------
		// SLIDER EVENTS
		// -------------------------------------------------------------------------------
		private function hiliteSlider( e:MouseEvent ):void {
			
			_mcSlider.gotoAndStop(2);
		}
		
		// -------------------------------------------------------------------------------
		private function dehiliteSlider( e:MouseEvent ):void {
			
			if ( _sliderIsActive ) {
				updateSliderPos();
			}
			
			if ( e.relatedObject != _mcSlider ) {

				_mcSlider.gotoAndStop(1);
				
				if ( _sliderIsActive ) {
					_sliderIsActive  = false;
					_mcSlider.removeEventListener( Event.ENTER_FRAME, moveSlider );
				}
			}
		}
		
		// -------------------------------------------------------------------------------
		private function activateSlider( e:MouseEvent ):void {
			
			_mcSlider.gotoAndStop(3);
			_sliderIsActive  = true;
			_iSliderClickedY = this.mouseY;
			
			_mcSlider.addEventListener( Event.ENTER_FRAME, moveSlider, false, 0, true );
		}
		
		// -------------------------------------------------------------------------------
		private function deactivateSlider( e:MouseEvent ):void {
			
			_mcSlider.gotoAndStop(2);
			_sliderIsActive = false;
			
			_mcSlider.removeEventListener( Event.ENTER_FRAME, moveSlider );
		}
		
		// -------------------------------------------------------------------------------
		private function mouseWheelSlider( e:MouseEvent ):void {
			
			// update y of movieclip
			_mcTarget.y += (e.delta * 10);
			
			if ( _mcTarget.y > _iMcMinY ) _mcTarget.y = _iMcMinY;
			else if ( _mcTarget.y < _iMcMaxY ) _mcTarget.y = _iMcMaxY;
			
			updateSlider();
		}
		
		// -------------------------------------------------------------------------------
		private function updateSlider():void {
			
			var iPercentage:int = int( (Math.abs(_mcTarget.y) * 100) / Math.abs(_iMcMaxY) );
			_mcSlider.y = _iMinY + int( ((_iMaxY-_iMinY) / 100) * iPercentage );
		}
		
		// -------------------------------------------------------------------------------
		private function moveSlider( e:Event ):void {
			
			updateSliderPos();
		}

		// -------------------------------------------------------------------------------
		private function updateSliderPos():void {
			
			// update slider
			_mcSlider.y += (this.mouseY - _iSliderClickedY);
			
			if ( _mcSlider.y < _iMinY ) _mcSlider.y = _iMinY;
			else if ( _mcSlider.y > _iMaxY ) _mcSlider.y = _iMaxY;
			
			_iSliderClickedY = this.mouseY;
			
			// update y of movieclip
			var iPercentage:int = int( ((_mcSlider.y-_iMinY) * 100) / (_iMaxY-_iMinY) );
			_mcTarget.y = int( (Math.abs(_iMcMaxY) / 100) * iPercentage ) * -1;
		}
		
		// -------------------------------------------------------------------------------
		//
		// -------------------------------------------------------------------------------
	}
}