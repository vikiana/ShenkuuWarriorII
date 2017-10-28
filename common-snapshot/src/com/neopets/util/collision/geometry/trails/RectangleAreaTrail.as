/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.RectangleArea;
	import com.neopets.util.collision.geometry.PolygonStrip;
	import com.neopets.util.collision.geometry.CompositeArea;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	
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
	public class RectangleAreaTrail extends AreaTrail
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _area:RectangleArea;
		protected var prevBounds:Rectangle;
		protected var prevCorners:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function RectangleAreaTrail(shape:BoundedArea=null):void{
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
			if(shape != null && shape is RectangleArea) {
				_area = shape as RectangleArea;
				_trail = area;
				// store initial state
				prevBounds = _area.bounds.clone();
				prevCorners = getCorners(prevBounds);
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
			var rect:Rectangle = _area.bounds.clone();
			var pts:Array = getCorners(rect);
			// create the trail
			var comp:CompositeArea = new CompositeArea();
			comp.addArea(_area);
			comp.addArea(new PolygonStrip(prevCorners,pts,true));
			_trail = comp;
			// record the new state
			prevBounds = rect;
			prevCorners = pts;
		}
		
		/**
		 * @This function converts a rectangle to a list of corner points.
		 * @param		rect		Rectangle 		The target we're getting corners from
		 */
		 
		public function getCorners(rect:Rectangle):Array {
			if(rect == null) return null;
			var ul:Point = new Point(rect.left,rect.top);
			var ur:Point = new Point(rect.right,rect.top);
			var bl:Point = new Point(rect.left,rect.bottom);
			var br:Point = new Point(rect.right,rect.bottom);
			return [ul,ur,br,bl];
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
