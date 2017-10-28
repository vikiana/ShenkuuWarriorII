
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.SuperSearch.classes.util.keyboard
{
	import flash.events.KeyboardEvent;
	
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
	 
	public class KeyID extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _keyCode:uint;
		protected var _keyLocation:uint;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function KeyID(code:uint=0,loc:uint=0):void{
			super();
			// initialize variables
			_keyCode = code;
			_keyLocation = loc;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get keyCode():uint { return _keyCode; }
		
		public function get keyLocation():uint { return _keyLocation; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function checks if the given keyCode and keyLocation match this object's values.
		
		public function matches(code:uint,loc:uint=0):Boolean {
			return _keyCode == code && _keyLocation == loc;
		}
		
		// This function converts the key status info to a string for easy reading.
		
		public function toString():String {
			var str:String = "[key " + _keyCode + " (" + _keyLocation + ")]";
			return str;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
