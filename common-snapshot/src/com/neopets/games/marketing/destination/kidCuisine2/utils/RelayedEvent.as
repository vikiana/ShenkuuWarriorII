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
	import flash.events.Event;
	
	public class RelayedEvent extends Event
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		protected var NO_EVENT:String = "No_Event_Relayed";
		// protected variables
		protected var _message:Event;
		protected var _source:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function RelayedEvent(msg:Event,src:Object=null):void {
			_message = msg;
			_source = src;
			// set up super statement
			var type_str:String;
			var bubs:Boolean;
			var cancel:Boolean;
			if(_message != null) {
				type_str = _message.type;
				bubs = _message.bubbles;
				cancel = _message.cancelable;
			} else {
				type_str = NO_EVENT;
				bubs = false;
				cancel = true;
			}
			super(type_str,bubs,cancel);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get message():Event { return _message; }
		
		public function get source():Object {
			if(_source != null) return _source;
			if(_message != null) return _message.target;
			return null;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
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