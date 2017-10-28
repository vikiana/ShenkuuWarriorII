// Use this class to dynamically attach a command to a specific keyboard key.
// This class also provides keystate tracking and enabling/disabling commands.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.input
{
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import com.neopets.util.array.ArrayUtils;
	
	public class KeyCommand extends EventDispatcher {
		public var name:String;
		public var enabled:Boolean;
		protected var keys:Array;
		
		public function KeyCommand(tag:String,active:Boolean = true) {
			name = tag;
			enabled = active;
			keys = new Array();
		}
		
		// Accessor Functions
		
		public function get numKeys():int { return keys.length; }
		
		// Key Management Functions
		
		// This function returns whether on not this command uses the specified key.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		public function hasKey(code:uint,loc:int=-1):Boolean {
			var ks:KeyStatus;
			for(var i:int = 0; i < keys.length; i++) {
				ks = keys[i];
				if(ks.keyMatches(code,loc)) return true;
			}
			return false;
		}
		
		// This function lets you add new key entries to this command's key list.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		public function addKey(code:uint,loc:int=-1):void {
			if(hasKey(code,loc) == false) {
				var ks:KeyStatus = new KeyStatus(code,loc);
				keys.push(ks);
			}
		}
		
		// Use this function to remove the specified key from our list.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		public function removeKey(code:uint,loc:int=-1):void {
			var ks:KeyStatus;
			for(var i:int = keys.length - 1; i >= 0; i--) {
				ks = keys[i];
				if(ks.code == code && ks.location == loc) keys.splice(i,1);
			}
		}
		
		// Use this function to change the code and location the key at a specific index.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		// "Slot" refers to it's index in the key list.
		public function replaceKey(code:uint,loc:int=-1,slot:int=0):void {
			slot = ArrayUtils.getValidIndex(slot,keys); // make sure index is in bounds
			keys[slot].changeKey(code,loc);
		}
		
		public function get keyIsDown():Boolean {
			var ks:KeyStatus;
			for(var i:int = keys.length - 1; i >= 0; i--) {
				ks = keys[i];
				if(ks.isDown) return true;
			}
			return false;
		}
		
		// KeyboardEvent Functions
		
		// This function checks an incoming keyboard event against it's keys and relays the event
		// if the key's pressed/released match this command's keys.
		public function onKeyEvent(ev:KeyboardEvent):void {
			if(checkEvent(ev)) dispatchEvent(ev);
		}
		
		// This function returns whether the target keyboard event uses this command's keys.
		// If there is a match, the function updates the target keys and returns true.
		public function checkEvent(ev:KeyboardEvent):Boolean {
			if(enabled) {
				var ks:KeyStatus;
				for(var i:int = 0; i < keys.length; i++) {
					ks = keys[i];
					if(ks.checkEvent(ev)) return true;
				}
			}
			return false;
		}
		
	}
}