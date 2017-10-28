/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *	Thick Segments add a collision radius to line segments
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.16.2009
	 */
	public class ThickSegment
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _lineSegment:LineSegment;
		protected var _radius:Number;
		protected var _thickness:Number;
		protected var _bounds:Rectangle;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ThickSegment(p1:Point=null,p2:Point=null,breadth:Number=0):void{
			_lineSegment = new LineSegment(p1,p2);
			_bounds = new Rectangle();
			thickness = breadth;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function returns the line's thickness.
		 */
		 
		public function get thickness():Number { return _thickness; }
		
		/**
		 * @This function returns the line's thickness.
		 */
		 
		public function set thickness(val:Number) {
			_thickness = Math.max(0,val);
			_radius = _thickness / 2;
			recalculateBounds();
		}
		
		/**
		 * @This function returns the line's radius.
		 */
		 
		public function get radius():Number { return _radius; }
		
		/**
		 * @This function returns a copy of the line's first point.
		 */
		 
		public function get point1():Point { return _lineSegment.point1; }	
		
		/**
		 * @This function set our first point to the target point's coordinates.
		 */
		 
		public function set point1(pt:Point) {
			_lineSegment.point1 = pt;
			recalculateBounds();
		}
		
		/**
		 * @This function returns the line's first point.
		 */
		 
		public function get x1():Number { return _lineSegment.point1.x; }
		
		/**
		 * @This function adjusts the area's y coordinates.
		 */
		 
		public function set x1(val:Number) {
			_lineSegment.point1.x = val;
			recalculateBounds();
		}
		
		/**
		 * @This function returns the line's first point.
		 */
		 
		public function get y1():Number { return _lineSegment.point1.y; }
		
		/**
		 * @This function adjusts the area's y coordinates.
		 */
		 
		public function set y1(val:Number) {
			_lineSegment.point1.y = val;
			recalculateBounds();
		}
		
		/**
		 * @This function returns a copy of the line's first point.
		 */
		 
		public function get point2():Point { return _lineSegment.point2; }	
		
		/**
		 * @This function set our first point to the target point's coordinates.
		 */
		 
		public function set point2(pt:Point) {
			_lineSegment.point2 = pt;
			recalculateBounds();
		}
		
		/**
		 * @This function returns the line's first point.
		 */
		 
		public function get x2():Number { return _lineSegment.point2.x; }
		
		/**
		 * @This function adjusts the area's y coordinates.
		 */
		 
		public function set x2(val:Number) {
			_lineSegment.point2.x = val;
			recalculateBounds();
		}
		
		/**
		 * @This function returns the line's first point.
		 */
		 
		public function get y2():Number { return _lineSegment.point2.y; }
		
		/**
		 * @This function adjusts the area's y coordinates.
		 */
		 
		public function set y2(val:Number) {
			_lineSegment.point2.y = val;
			recalculateBounds();
		}
		
		/**
		 * @This function returns the segment's boundaries
		 */
		 
		public function get bounds():Rectangle { return _bounds; }
		
		/**
		 * @This function returns the line segment this segment is based on.
		 */
		 
		public function get lineSegment():LineSegment { return _lineSegment; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Construction Functions
		
		/**
		 * @Use this function to reset values based on our end points when the 
		 * @position of one of those points changes.
		 */
		 
		public function recalculate():void{
			_lineSegment.recalculate();
			recalculateBounds();
		}
		
		/**
		 * @Use this function to reset values if our end points or thickness changes.
		 */
		 
		public function recalculateBounds():void{
			_bounds.top = _lineSegment.bounds.top - _radius;
			_bounds.bottom = _lineSegment.bounds.bottom + _radius;
			_bounds.left = _lineSegment.bounds.left - _radius;
			_bounds.right = _lineSegment.bounds.right + _radius;
		}
		
		/**
		 * @Call this function if another object has moved both our points by the same amount.
		 * @This is mainly used by LineArea's moveBy function as a way to skip a full bounds 
		 * @and slope recalculation.  Most other objects won't need this optimization and should
		 * @just use the coordinate setter functions.
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 */
		 
		public function pointsMovedBy(dx:Number,dy:Number):void{
			_lineSegment.pointsMovedBy(dx,dy);
			// update bounds
			_bounds.x += dx;
			_bounds.y += dy;
		}
		
		// Intersection Functions
		
		/**
		 * @This is a quick boundary based collision test.
		 * @param		other		Object 		The area we're checking for intersection.
		 */
		 
		public function boundsIntersect(other:Object):Boolean{
			if(other == null) return false;
			if("bounds" in other) return _bounds.intersects(other.bounds);
			else return false;
		}
		
		/**
		 * @Checks if this segment intersects a line segment
		 * @param		other		LineSegment		The line we're checking for intersection.
		 */
		 
		public function intersectsLine(other:LineSegment):Boolean{
			if(boundsIntersect(other)) {
				if(_lineSegment.intersectsSegment(other)) return true;
				if(intersectsPoint(other.point1)) return true;
				if(intersectsPoint(other.point2)) return true;
			}
			return false;
		}
		
		/**
		 * @Checks if two line segments intersect.
		 * @param		other		LineSegment		The line we're checking for intersection.
		 */
		 
		public function intersectsSegment(other:ThickSegment):Boolean{
			if(other == null) return false;
			// check bounds
			var bb:Rectangle = other.bounds;
			if(bb.top > _bounds.bottom) return false;
			if(bb.bottom < _bounds.top) return false;
			if(bb.left > _bounds.right) return false;
			if(bb.right < _bounds.left) return false;
			// check for line intersection
			var ls:LineSegment = other.lineSegment;
			if(_lineSegment.intersectsSegment(ls)) return true;
			// check end point intersections
			var r:Number = _radius + other.radius;
			if(_lineSegment.distanceToPoint(other.point1) <= r) return true;
			if(_lineSegment.distanceToPoint(other.point2) <= r) return true;
			if(ls.distanceToPoint(_lineSegment.point1) <= r) return true;
			if(ls.distanceToPoint(_lineSegment.point2) <= r) return true;
			return false;
		}
		
		/**
		 * @Checks if this segment intersects a given horizontal line.
		 * @param		py		Number		Y coordinate of the line.
		 * @param		min_x	Number		Left bound of the line.
		 * @param		max_x	Number		Right bound of the line.
		 */
		 
		public function intersectsHorizontal(py:Number,min_x:Number,max_x:Number):Boolean{
			// perform a quick bounding box test
			if(max_x < _bounds.left) return false;
			if(min_x > _bounds.right) return false;
			if(py < _bounds.top) return false;
			if(py > _bounds.bottom) return false;
			// check for line intersection
			if(_lineSegment.intersectsHorizontal(py,min_x,max_x)) return true;
			// check point distances
			var pt:Point = new Point(min_x,py);
			if(intersectsPoint(pt)) return true;
			pt.x = max_x;
			return intersectsPoint(pt);
		}
		
		/**
		 * @Checks if this segment intersects a given vertical line.
		 * @param		px		Number		X coordinate of the line.
		 * @param		min_y	Number		Top bound of the line.
		 * @param		max_y	Number		Bottom bound of the line.
		 */
		 
		public function intersectsVertical(px:Number,min_y:Number,max_y:Number):Boolean{
			// perform a quick bounding box test
			if(max_y < _bounds.top) return false;
			if(min_y > _bounds.bottom) return false;
			if(px < _bounds.left) return false;
			if(px > _bounds.right) return false;
			// check for line intersection
			if(_lineSegment.intersectsVertical(px,min_y,max_y)) return true;
			// check point distances
			var pt:Point = new Point(px,min_y);
			if(intersectsPoint(pt)) return true;
			pt.y = max_y;
			return intersectsPoint(pt);
		}
		
		/**
		 * @This function checks if a given point is within this line segment.
		 * @param		pt		Point 		The point being checked for intersection.
		 */
		 
		public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			// perform quick bounds test
			if(pt.y > _bounds.bottom) return false;
			if(pt.y < _bounds.top) return false;
			if(pt.x > _bounds.right) return false;
			if(pt.x < _bounds.left) return false;
			// check the distance to the line
			return _lineSegment.distanceToPoint(pt) <= _radius;
		}
		
		// Math Functions
		
		/**
		 * @This function return how far a given point is from this line segment.
		 * @param		pt		Point 		The point being checked.
		 */
		 
		public function distanceToPoint(pt:Point):Number{
			return Math.max(0,_lineSegment.distanceToPoint(pt)-_radius);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
