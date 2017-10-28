/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.tracking
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 *	Area Trackers add change tracking to the target bounded area.  This class is the simplest
	 *  form of area tracker and mainly just dispatches events when the area changes.
	 *  It's main purpose is serving as a base class for more complex trackers.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.29.2009
	 */
	public class BasicAreaTracker extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _area:BoundedArea;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function BasicAreaTracker(shape:BoundedArea=null):void{
			area = shape;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get area():BoundedArea { return _area; }
		
		public function set area(shape:BoundedArea):void {
			if(_area != null) _area.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			_area = shape;
			if(_area != null) _area.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
		}
		
		public function get motionArea():BoundedArea { return _area; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to call our area's rebuild function.
		 */
		 
		public function rebuildArea():void {
			if(_area != null) _area.rebuild();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is trigger when the tracked area changes.
		 */
		 
		public function onAreaChanged(ev:Event):void {
			dispatchEvent(new Event(BoundedArea.AREA_CHANGED));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
