// This class is a basic object that links a keycode to the key's up/down state.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.input
{
	import flash.events.KeyboardEvent;
	
	public class KeyStatus {
		public var code:uint;
		public var location:int; // set as "int" so negatives can be used to turn off location checking
		protected var down:Boolean;
		
		public function KeyStatus(val:uint=0,loc:int=-1) {
			code = val;
			location = loc;
			down = false;
		}
		
		// Accessor Functions
		
		// Use this function to reset this entry to a new keycode and keyboard location.
		public function changeKey(val:uint,loc:int=-1):void {
			code = val;
			location = loc;
			down = false;
		}
		
		public function get isDown():Boolean { return down; }
		
		// Keyboard Event Functions
		
		// This function tells you if a given keyboard event applies to this entry.  It also
		// updates this entry's key down status.
		public function checkEvent(ev:KeyboardEvent):Boolean {
			if(keyMatches(ev.keyCode,ev.keyLocation)) {
				switch(ev.type) {
					case KeyboardEvent.KEY_DOWN:
						down = true;
						return true;
					case KeyboardEvent.KEY_UP:
						down = false;
						return true;
					default: return false;
				}
			} else return false;
		}
		
		// Misc. Functions
		
		// This function checks if the given keyCode and keyLocation match this object's values.
		public function keyMatches(val:uint,loc:int=-1):Boolean {
			if(val != code) return false;
			// If the "location" property is negative, we don't care what our keyLocation is.
			if(location >= 0 && loc != location) return false;
			return true;
		}
		
		// This function converts the key status info to a string for easy reading.
		public function toString():String {
			var str:String = "[key " + code + "(" + location;
			if(down) str+= ") is down]";
			else str+= ") is up]";
			return str;
		}
		
	}
}