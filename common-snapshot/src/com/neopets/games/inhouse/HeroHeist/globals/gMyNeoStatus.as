
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.HeroHeist.globals
{
	import com.neopets.projects.np9.system.NP9_Evar;
	
	/**
	 *	This class is designed to mimic a global variable used in the flash 6 version.
	 *  In this case, the global variable is a link to the gaming system.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  2.18.2010
	 */
	 
	public class gMyNeoStatus
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public static var _GAMINGSYSTEM:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function gMyNeoStatus() {
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function sendTag(tag:String) {
			if(_GAMINGSYSTEM != null) _GAMINGSYSTEM.sendTag(tag);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}