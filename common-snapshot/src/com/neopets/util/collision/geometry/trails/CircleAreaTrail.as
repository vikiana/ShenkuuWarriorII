/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.CircleArea;
	import com.neopets.util.collision.geometry.CompositeArea;
	import com.neopets.util.collision.geometry.PolygonArea;
	import com.neopets.util.collision.geometry.ChainArea;
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
	public class CircleAreaTrail extends AreaTrail
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _area:CircleArea;
		protected var prevCenter:Point;
		protected var prevRadius:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CircleAreaTrail(shape:BoundedArea=null):void{
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
			if(shape != null && shape is CircleArea) {
				_area = shape as CircleArea;
				_trail = area;
				// store initial state
				prevCenter = _area.center.clone();
				prevRadius = _area.radius;
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
			var radius:Number = _area.radius;
			// check for a radius change
			if(radius != prevRadius) {
				// check if either radius is big enough to include both circles
				var big_r:Number;
				var small_r:Number;
				var big_center:Point;
				if(radius > prevRadius) {
					big_r = radius;
					small_r = prevRadius;
					big_center = center;
				} else {
					big_r = prevRadius;
					small_r = radius;
					big_center = prevCenter;
				}
				var circle:CircleArea;
				var dist:Number = Point.distance(center,prevCenter);
				if(dist + small_r <= big_r) {
					// set the big circle as our trail
					circle = new CircleArea();
					circle.radius = big_r;
					circle.center = big_center;
					_trail = circle;
				} else {
					// make 2 circle linked by a polygon
					var comp:CompositeArea = new CompositeArea();
					comp.addArea(_area);
					// add our previous circle
					circle = new CircleArea();
					circle.radius = prevRadius;
					circle.center = prevCenter;
					comp.addArea(circle);
					// attach both circles with a polygon
					var sine:Number = (center.x - prevCenter.x) / dist;
					var cosine:Number = (center.y - prevCenter.y) / dist;
					var dx:Number = cosine * prevRadius;
					var dy:Number = sine * prevRadius;
					var pt_a_1:Point = new Point(prevCenter.x + dx, prevCenter.y - dy);
					var pt_a_2:Point = new Point(prevCenter.x - dx, prevCenter.y + dy);
					dx = cosine * radius;
					dy = sine * radius;
					var pt_b_1:Point = new Point(center.x + dx, center.y - dy);
					var pt_b_2:Point = new Point(center.x - dx, center.y + dy);
					var poly:PolygonArea = new PolygonArea();
					poly.points = [pt_a_1,pt_a_2,pt_b_2,pt_b_1];
					comp.addArea(poly);
					// set the composite area as our trail
					_trail = comp;
				}
				// record the current state
				prevRadius = radius;
				prevCenter = center;
			} else {
				// check if the circle moved
				if(center.equals(prevCenter)) _trail = _area;
				else {
					// use a thick line to cover our trail
					var chain:ChainArea = new ChainArea();
					chain.pushCircle(prevCenter.x,prevCenter.y,prevRadius);
					chain.pushCircle(center.x,center.y,radius);
					_trail = chain;
					// record our new center
					prevCenter = center;
				}
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
