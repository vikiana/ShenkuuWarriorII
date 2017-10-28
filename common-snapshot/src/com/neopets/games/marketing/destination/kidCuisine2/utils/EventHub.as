/**
 *	This provides a global means to relay events between unconnected listeners and dispatchers.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.utils
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class EventHub
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// static components
		protected static var _dispatcher:EventDispatcher;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function EventHub():void {
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public static function get dispatcher():EventDispatcher {
			if(_dispatcher == null) _dispatcher = new EventDispatcher();
			return _dispatcher;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 * @This function simply passed the given parameter to the dispatcher function of the same name.
		 * @However, this function does default to using weak references to encourage garbage collection.
		 **/
		
		public static function addEventListener(type:String,listener:Function,useCapture:Boolean=false,priority=0,
												useWeakReference:Boolean=true) {
			dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**	
		 * @This function simply passed the given parameter to the dispatcher function of the same name.
		 **/
		
		public static function removeEventListener(type:String,listener:Function,useCapture:Boolean=false) {
			dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		/**	
		 * @Use this function to dispatch events on a local and global level simulataneously.
		 * @On the local level, this is handled by triggering the callers's dispatchEvent function.
		 * @On the global level, the original event is wrapped in a RelayedEvent and sent through
		 * @this classes static dispatcher.  The wrapper is used to retain the target property of 
		 * @the original event.
		 * @param		ev		Event 		Event to be relayed.
		 **/
		
		public static function broadcast(ev:Event,src:EventDispatcher=null) {
			if(ev != null) {
				if(src != null) src.dispatchEvent(ev);
				var wrapper:RelayedEvent = new RelayedEvent(ev,src);
				dispatcher.dispatchEvent(wrapper);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
	}
	
}