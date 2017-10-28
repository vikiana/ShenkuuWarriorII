/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.PointArea;
	import com.neopets.util.collision.geometry.LineArea;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 *	This class tries to create a motion trail for given point area.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern AbstractClass
	 * 
	 *	@author David Cary
	 *	@since  10.02.2009
	 */
	public class PointAreaTrail extends AreaTrail
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _area:PointArea;
		protected var prevCenter:Point;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PointAreaTrail(shape:BoundedArea=null):void{
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
			if(shape != null && shape is PointArea) {
				_area = shape as PointArea;
				_trail = area;
				// store initial state
				prevCenter = _area.center.clone();
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
			var center:Point = _area.center.clone();
			if(center.equals(prevCenter)) _trail = _area;
			else {
				// create a new trail
				var line:LineArea = new LineArea();
				line.points = [prevCenter,center];
				_trail = line;
				// record the new state
				prevCenter = center;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
