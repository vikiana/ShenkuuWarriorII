package com.neopets.util.display.animations
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.util.events.EventFunctions;
	import com.neopets.util.general.GeneralFunctions;
	
	/**
	 *	This class alters the rate a target movie clip's frames are displayed at.  This is usually used
	 *  To make animations play at double or half speed, though it can also be used to reverse animations.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern ?
	 * 
	 *	@author David Cary
	 *	@since  10.11.2010
	 */
	public class AnimationAccelerator extends Object 
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		// properties
		protected var _target:MovieClip;
		protected var _previousFrame:int;
		protected var _endFrame:int;
		protected var _restartFrame:int;
		// accumulators
		protected var _frameShift:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var multiplier:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AnimationAccelerator(clip:MovieClip,start_pos:int=1,end_pos:int=-1):void{
			multiplier = 1;
			target = clip;
			restartFrame = start_pos;
			endFrame = end_pos;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get endFrame():int { return _endFrame; }
		
		public function set endFrame(val:int) { _endFrame = getValidIndex(val); }
		
		public function get restartFrame():int { return _restartFrame; }
		
		public function set restartFrame(val:int) {
			if(val != 0) _restartFrame = getValidIndex(val);
			else _restartFrame = 0;
		}
		
		public function get target():MovieClip { return _target; }
		
		public function set target(clip:MovieClip) {
			_previousFrame = 0; // temporarily disables frame checking
			// move listeners to new target
			EventFunctions.transferListener(_target,clip,Event.ENTER_FRAME,onEnterFrame);
			// initialize properties
			_target = clip;
			if(_target != null) {
				_previousFrame = _target.currentFrame;
				_restartFrame = 1;
				_endFrame = _target.totalFrames;
			} else {
				_restartFrame = 0;
				_endFrame = 0;
			}
			// reset the frame shift
			_frameShift = 0;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function maps a given frame index relative to our looping end points.
		
		public function getLoopedIndex(val:int):int {
			// check if we have a valid start point
			if(_restartFrame != 0) {
				var diff:int = val - _restartFrame;
				var limit:Number = _endFrame - _restartFrame + 1;
				// check looping direction
				if(diff >= 0) {
					// simply map the remainder onto our target range
					return _restartFrame + (diff % limit);
				} else {
					// For negative loops, we want to count back from our end frame.
					// To make this work, we need our index to start at 0 instead of -1.
					return _endFrame + ((diff + 1) % limit);
				}
			} else return int(GeneralFunctions.constrainValue(1,val,_endFrame));
		}
		
		// This function forces a given into to a valid postion on our target movieclip's frame track.
		
		public function getValidIndex(val:int):int {
			if(_target != null) {
				if(val >= 0) {
					if(val > 0) return Math.min(val,_target.totalFrames);
					else return 1; // convert index 0 to 1
				} else {
					// convert negative indices to distance from end of animation
					return Math.max(1,_target.totalFrames + val + 1);
				}
			} else return val;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onEnterFrame(ev:Event) {
			// make sure the target has been properly initialized.
			if(_target == null) return;
			// Only try accelerating animations if our target frame rate is different than the standard 
			// 1 frame per cycle.
			// We also want to skip acceleration if our frame record hasn't been properly set.
			if(multiplier != 1 && _previousFrame != 0) {
				// Assume the target is playing if it moved one step forward from it's last recorded position.
				// This keeps the function from operation on stopped clips and minimizes the impact on most
				// "goto" function calls.
				var next_frame = getLoopedIndex(_previousFrame + 1);
				var cur_frame:int = _target.currentFrame;
				_previousFrame = cur_frame; // set previous frame for next cycle to it's default value
				if(cur_frame == next_frame) {
					// increment frame shift
					_frameShift += multiplier;
					var int_shift:int = int(_frameShift);
					_frameShift -= int_shift; // store remainder for next frame
					// if the shift is only 1 frame, let the normal animination processing handle it.
					if(int_shift != 1){
						// If we're here, we want to shift to a non-standard frame next cycle, so calculate 
						// and apply the new position now.
						next_frame = getLoopedIndex(cur_frame + int_shift);
						if(next_frame != cur_frame) {
							_target.gotoAndPlay(next_frame);
							// Set the previous frame to where it should be after our frame shift is applied.
							_previousFrame = getLoopedIndex(next_frame - 1);
						}
					}
				}
			} else {
				// If we're not performing any acceleration, just record the frame number for future reference.
				_previousFrame = _target.currentFrame;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}