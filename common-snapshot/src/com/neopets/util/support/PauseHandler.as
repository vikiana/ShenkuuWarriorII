// A PauseHandler can be attached to a low level movie clip to help handle pausing and resuming a game.
// Author: David Cary
// Last Updated: April 2008
// Todo: Make the "pausing" state track all currently active animations so they can be stopped and
// restarted when the pause handler resumes.

package com.neopets.util.support
{
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import com.neopets.util.events.CustomEvent;
	
	public class PauseHandler extends EventDispatcher{
		// Variables
		protected var eventSource:DisplayObject;
		protected var _state:int;
		// Constants
		public static const UPDATE_EVENT:String = "update";
		
		public function PauseHandler(targ:DisplayObject=null) {
			_state = 0;
			if(targ != null) listenTo(targ);
		}
		
		// Accessor Functions
		
		public function get paused():Boolean { return (_state > 0); }
		
		public function set paused(p:Boolean) {
			// check current state
			if(_state <= 0) { // system is running
				if(p) startPause();
			} else { // system is pausing or paused
				if(p == false) endPause();
			}
		}
		
		// Pause Functions
		
		// Use this function to alternate between paused and unpaused.
		// This function accept an event so it can be included in "addEventListener".
		public function toggle(ev:Event=null):void {
			if(_state <= 0) startPause();
			else endPause();
		}
		
		// Use this function to disable updates and start trying to pause animations.
		protected function startPause():void {
			_state = 1;
		}
		
		// Use this function to enable updates and resume animations.
		protected function endPause():void {
			_state = 0;
		}
		
		// Listener Functions
		// Since the PauseHandler is not a movieclip, it does not normally receive enter frame events.
		// These functions provide ways for the PauseHandler to follow those events.
		
		// Use this function to attach listeners to an object that dispatches enter frame events, such as
		// a MovieClip.  This lets the update function happen each frame while the system is unpaused.
		public function listenTo(targ:DisplayObject):void {
			// clear previous event source
			if(eventSource != null) {
				eventSource.removeEventListener(Event.ENTER_FRAME,update);
			}
			// set new event source and attach listeners
			eventSource = targ;
			if(eventSource != null) {
				eventSource.addEventListener(Event.ENTER_FRAME,update);
			}
		}
		
		public function update(ev:Event=null):void {
			switch(_state) {
				case 0: // game running
					dispatchEvent(new CustomEvent(this,UPDATE_EVENT));
					break;
				case 1: // pausing game
					break;
				case 2: // game paused
					break;
			}
		}
		
	}
	
}