/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics
{
	import flash.events.Event;
	
	/**
	 *	Movement events simply attach x, y, and rotation changes to an event.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.6.2009
	 */
	public class NumberChangeEvent extends Event
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		protected var _previousValue:Number;
		protected var _currentValue:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NumberChangeEvent(prev:Number,cur:Number,type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_previousValue = prev;
			_currentValue = cur;
			super(type, bubbles, cancelable);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get currentValue():Number { return _currentValue; }
		
		public function get previousValue():Number { return _previousValue; }
		
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
