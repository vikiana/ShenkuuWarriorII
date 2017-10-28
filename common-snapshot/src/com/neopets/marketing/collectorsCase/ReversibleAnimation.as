/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	import flash.events.Event;
	
	/**
	 *	This class lets the user move frame by frame to a given target frame.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.15.2010
	 */
	public class ReversibleAnimation extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _targetFrame:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ReversibleAnimation():void{
			super();
			_targetFrame = -1;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get targetFrame():int { return _targetFrame; }
		
		public function set targetFrame(val:int) {
			if(_targetFrame != val) {
				// clear previous animation
				removeEventListener(Event.ENTER_FRAME,doAnimation);
				// set new index
				_targetFrame = val;
				// start new animation
				if(_targetFrame > 0 && _targetFrame <= totalFrames) {
					addEventListener(Event.ENTER_FRAME,doAnimation);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to retrieve the named frame label.
		 * @param		id		String 		Name of the target frame.
		 */
		
		public function getFrameByName(id:String):FrameLabel {
			var list:Array = currentLabels;
			var f_label:FrameLabel;
			for(var i:int = 0; i < list.length; i++) {
				f_label = list[i];
				if(f_label.name == id) return f_label;
			}
			return null;
		}
		
		/**
		 * @Use this function to start animation to a given frame.
		 * @param		id		Object 		Name or number of the target frame.
		 */
		
		public function gotoFrame(id:Object):void {
			if(id == null) return;
			// check if we're looking for a frame label
			var index:int;
			if(id is String) {
				var f_label:FrameLabel = getFrameByName(id as String);
				if(f_label != null) {
					targetFrame = f_label.frame;
					return;
				}
			}
			// if we didn't find a labeled frame, try to treat the id as a frame number
			var val:Number = Number(id);
			if(!isNaN(val)) targetFrame = int(val);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is called every frame to simulate frame animation.
		 */
		
		protected function doAnimation(ev:Event) {
			if(_targetFrame < currentFrame) {
				// try moving back to the target
				if(_targetFrame > 0) prevFrame();
				else removeEventListener(Event.ENTER_FRAME,doAnimation);
			} else {
				if(_targetFrame > currentFrame) {
					// try moving forward to the target
					if(_targetFrame <= totalFrames) nextFrame();
					else removeEventListener(Event.ENTER_FRAME,doAnimation);
				} else {
					// we're at the target, so stop animating
					removeEventListener(Event.ENTER_FRAME,doAnimation);
					_targetFrame = -1;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}