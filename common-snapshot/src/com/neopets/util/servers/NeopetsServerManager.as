
/* AS3
	Copyright 2008
*/
package com.neopets.util.servers
{
	import flash.display.DisplayObject;
	
	import com.neopets.util.servers.NeopetsServerFinder;
	
	/**
	 *	This class provides global access to the neopets amf servers.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author David Cary
	 *	@since  6.13.10
	 */
	 
	public class  NeopetsServerManager extends NeopetsServerFinder
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static const mInstance:NeopetsServerManager = new NeopetsServerManager( SingletonEnforcer);
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NeopetsServerManager(singletonEnforcer : Class = null):void
		 {
		 		if(singletonEnforcer != SingletonEnforcer) {
					throw new Error( "Invalid Singleton access.  Use NeopetsServerManager.instance." ); 
				}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():NeopetsServerManager
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