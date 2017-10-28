/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.LineArea;
	import com.neopets.util.collision.geometry.PolygonStrip;
	import flash.events.Event;
	
	/**
	 *	This class tries to create a motion trail for given point area.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern AbstractClass
	 * 
	 *	@author David Cary
	 *	@since  10.05.2009
	 */
	public class LineAreaTrail extends AreaTrail
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _area:LineArea;
		protected var prevPoints:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LineAreaTrail(shape:BoundedArea=null):void{
			super(shape);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get area():BoundedArea { return _area; }
		
		override public function set area(shape:BoundedArea):void {
			// clear previous area
			if(_area != null) _area.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			// add new area
			if(shape != null && shape is LineArea) {
				_area = shape as LineArea;
				_trail = area;
				// store initial state
				prevPoints = _area.clonePoints();
				// add listener
				_area.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			} else _area = null;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function checks for changes in the area an creates a new trail from those changes.
		 */
		 
		override public function update():void {
			if(_area == null) return;
			// check area's current state
			var pts:Array = _area.clonePoints();
			// create the trail
			_trail = new PolygonStrip(prevPoints,pts);
			// record the new state
			prevPoints = pts;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
