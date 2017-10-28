
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.SuperSearch.classes.util.keyboard
{
	import flash.events.KeyboardEvent;
	
	import com.neopets.games.inhouse.SuperSearch.classes.util.keyboard.KeyID;
	
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
	 
	public class KeyState extends KeyID
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _isDown:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function KeyState(code:uint=0,loc:uint=0):void{
			super(code,loc);
			_isDown = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isDown():Boolean { return _isDown; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function converts the key status info to a string for easy reading.
		
		override public function toString():String {
			var str:String = "[key " + _keyCode + " (" + _keyLocation + ") is ";
			if(_isDown) str+= "down]";
			else str+= "up]";
			return str;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Use this function to process keyboard events.
		
		public function onKeyEvent(ev:KeyboardEvent) {
			if(matches(ev.keyCode,ev.keyLocation)) {
				switch(ev.type) {
					case KeyboardEvent.KEY_DOWN:
						_isDown = true;
						break;
					case KeyboardEvent.KEY_UP:
						_isDown = false;
						break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
