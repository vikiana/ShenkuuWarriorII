
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes.util.keyboard
{
	import com.neopets.games.inhouse.SuperSearch.classes.util.keyboard.KeyboardProxy;
	
	/**
	 *	This class provides global access to keyboard input and key states.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author David Cary
	 *	@since  05.12.2010
	 */
	 
	public class KeyboardManager extends KeyboardProxy
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static const mInstance:KeyboardManager = new KeyboardManager( SingletonEnforcer);
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function KeyboardManager(singletonEnforcer : Class = null):void
		 {
		 		super();
				if(singletonEnforcer != SingletonEnforcer)
		 		{
					throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
				}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():KeyboardManager
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}