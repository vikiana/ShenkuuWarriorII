
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.SuperSearch.classes.util.keyboard
{
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	import com.neopets.games.inhouse.SuperSearch.classes.util.keyboard.KeyState;
	
	/**
	 *	This class acts as a container for multiple key states.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.12.2010
	 */
	 
	public class KeyboardProxy extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _keyStates:Array;
		protected var _eventSource:EventDispatcher; // source of keyboard events
		public var trackAllKeys:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function KeyboardProxy():void{
			super();
			// initialize variables
			_keyStates = new Array();
			trackAllKeys = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get eventSource():EventDispatcher { return _eventSource; }
		
		public function set eventSource(dispatcher:EventDispatcher) {
			// clear previous listeners
			if(_eventSource != null) {
				_eventSource.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
				_eventSource.removeEventListener(KeyboardEvent.KEY_UP,onKeyEvent);
			}
			// set up new listeners
			_eventSource = dispatcher;
			if(_eventSource != null) {
				_eventSource.addEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
				_eventSource.addEventListener(KeyboardEvent.KEY_UP,onKeyEvent);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to wipe all current key trackers.
		
		public function clearStates():void {
			while(_keyStates.length > 0) _keyStates.pop();
		}
		
		// Use this to retrieve a single key state tracker.
		
		public function getKey(code:uint,loc:uint=0) {
			var key:KeyState;
			for(var i:int = 0; i < _keyStates.length; i++) {
				key = _keyStates[i];
				if(key.matches(code,loc)) return key;
			}
			return null;
		}
		
		// Use this function to indirectly check a key state.
		
		public function keyIsDown(code:uint,loc:uint=0):Boolean {
			var key:KeyState = getKey(code,loc);
			if(key != null) return key.isDown;
			else return false;
		}
		
		// Use this function to add a new key state tracker.
		
		public function trackKey(code:uint,loc:uint=0):void {
			if(getKey(code,loc) == null) {
				var key:KeyState = new KeyState(code,loc);
				_keyStates.push(key);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Any time a key changes, update our key states.
		
		protected function onKeyEvent(ev:KeyboardEvent) {
			// check if we already have an entry for this key
			var key:KeyState = getKey(ev.keyCode,ev.keyLocation);
			// if we don't have a key and are tracking them all, make a new record now
			if(trackAllKeys && key == null) {
				key = new KeyState(ev.keyCode,ev.keyLocation);
				_keyStates.push(key);
			}
			// let the key update itself from this event
			if(key != null) key.onKeyEvent(ev);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
