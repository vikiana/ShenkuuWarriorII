
/* AS3
	Copyright 2008
*/
package com.neopets.util.servers
{
	import flash.display.DisplayObject;
	
	import com.neopets.util.servers.AmfFinder;
	import com.neopets.util.servers.NeopetsServerFinder;
	
	import virtualworlds.net.AmfDelegate;
	
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
	 
	public class  NeopetsAmfManager extends AmfFinder
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static const mInstance:NeopetsAmfManager = new NeopetsAmfManager( SingletonEnforcer);
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NeopetsAmfManager(singletonEnforcer : Class = null):void
		 {
		 		if(singletonEnforcer != SingletonEnforcer) {
					throw new Error( "Invalid Singleton access.  Use NeopetsAmfManager.instance." ); 
				}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():NeopetsAmfManager
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to initialize the manager for a given application.
		// param	dobj		DisplayObject		Display object within the target application.
		
		public function initFor(dobj:DisplayObject):void {
			_servers = new NeopetsServerFinder(dobj);
			setupAMFPHP();
		}
		
		// Use this function to retrieve the amf delegate and initialize it needed using the target object.
		
		public function getDelegateFor(dobj:DisplayObject):AmfDelegate {
			if(_delegate == null) initFor(dobj);
			return _delegate;
		}
		
		// Use this function to retrieve the amf delegate and initialize it needed using the target object.
		
		public function getServersFor(dobj:DisplayObject):ServerFinder {
			if(_servers == null) initFor(dobj);
			return _servers;
		}
		 
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