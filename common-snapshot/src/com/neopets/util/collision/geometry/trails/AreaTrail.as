/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 *	Area Trails try to recreate the space covered by a given bounded area as it transforms over time.
	 *  This class acts as an abstract base class for more shape specific subclasses.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern AbstractClass
	 * 
	 *	@author David Cary
	 *	@since  10.02.2009
	 */
	public class AreaTrail extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _trail:BoundedArea;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AreaTrail(shape:BoundedArea=null):void{
			area = shape;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get area():BoundedArea { return null; }
		
		public function set area(shape:BoundedArea):void {}
		
		public function get trail():BoundedArea { return _trail; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function checks for changes in the area an creates a new trail from those changes.
		 */
		 
		public function update():void {}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is trigger when the tracked area changes.
		 */
		 
		public function onAreaChanged(ev:Event):void {
			update();
			dispatchEvent(new Event(BoundedArea.AREA_CHANGED));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
