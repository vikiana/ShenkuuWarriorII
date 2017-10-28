// This class is basically a list of KeyCommands with keyboard listener functionality.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.input
{
	
	import flash.events.KeyboardEvent;
	import flash.display.DisplayObject;
	
	public class KeyManager {
		protected var commands:Array;
		protected var eventSource:DisplayObject;
		
		public function KeyManager(targ:DisplayObject=null) {
			commands = new Array();
			if(targ != null) listenTo(targ);
		}
		
		// Command List Functions
		
		// Use this function to retrieve the command with the target name.
		public function getCommand(ref:String):KeyCommand {
			var cmd:KeyCommand;
			for(var i:int = 0; i < commands.length; i++) {
				cmd = commands[i];
				if(cmd.name == ref) return cmd;
			}
			return null;
		}
		
		// Use this function to retrieve the command that uses the target keycode.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		public function getCommandByKey(code:uint,loc:int=-1):KeyCommand {
			var cmd:KeyCommand;
			for(var i:int = 0; i < commands.length; i++) {
				cmd = commands[i];
				if(cmd.hasKey(code,loc)) return cmd;
			}
			return null;
		}
		
		// This function adds a key to the target command's key list.  If the target command
		// does not exist, this function creates that command.
		// "Ref" is the name of the command.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		public function addKey(ref:String,code:uint,loc:int=-1):void {
			// make sure the key isn't already in use
			var cmd:KeyCommand = getCommandByKey(code,loc);
			if(cmd != null) return;
			// if not, try to find a command to attach this key to
			cmd = getCommand(ref);
			if(cmd == null) {
				cmd = new KeyCommand(ref);
				commands.push(cmd);
			}
			// attach our key to the command
			if(cmd != null) cmd.addKey(code,loc);
		}
		
		// This function can be used to reassign one of a command's target keys.
		// "Ref" is the name of the command.
		// "Code" refers to new key's keycode while "loc" refers to it's keyLocation.
		// "Slot" is the index in the command's key list for the key being replaced.
		public function replaceKeyIn(ref:String,code:uint,loc:int=-1,slot:int=0):void {
			var cmd:KeyCommand = getCommand(ref);
			if(cmd != null) cmd.replaceKey(code,loc,slot);
		}
		
		// Use this function to turn all commands on or off at once.
		// "b" should be true to enable commands and false to disable them.
		public function enableCommands(b:Boolean=true):void {
			var cmd:KeyCommand;
			for(var i:int = 0; i < commands.length; i++) {
				cmd = commands[i];
				cmd.enabled = b;
			}
		}
		
		// Listener Functions
		// Since the KeyManager is not a movieclip, it does not normally receive keyboard events.
		// These functions provide ways for the KeyManager to follow those events.
		
		// Use this function to attach listeners to an object that dispatches keyboard events, such as
		// a MovieClip.  The KeyManager can then pass those events on to commands wiht the corresponding key.
		public function listenTo(targ:DisplayObject):void {
			// clear previous event source
			if(eventSource != null) {
				eventSource.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
				eventSource.removeEventListener(KeyboardEvent.KEY_UP,onKeyEvent);
			}
			// set new event source and attach listeners
			eventSource = targ;
			if(eventSource != null) {
				eventSource.addEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
				eventSource.addEventListener(KeyboardEvent.KEY_UP,onKeyEvent);
			}
		}
		
		// This function simply passes an incoming keyboard event to our commands.
		public function onKeyEvent(ev:KeyboardEvent):void {
			for(var i:int = 0; i < commands.length; i++) {
				commands[i].onKeyEvent(ev);
			}
		}
		
	}
}