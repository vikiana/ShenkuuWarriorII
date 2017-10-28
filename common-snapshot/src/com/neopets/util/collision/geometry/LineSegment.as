/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *	Line Segments handle a straight line connecting two given points.
	 *  This class stores a lot of precalculated values to speed up collision testing.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.2.2009
	 */
	public class LineSegment
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _point1:Point;
		protected var _point2:Point;
		protected var _line:SlopeLine = new SlopeLine();
		protected var _bounds:Rectangle = new Rectangle();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LineSegment(p1:Point=null,p2:Point=null):void{
			// initialize end points
			if(p1 != null) _point1 = p1;
			else _point1 = new Point();
			if(p2 != null) _point2 = p2;
			else _point2 = new Point();
			// synch values
			recalculate();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		 
		public function get point1():Point { return _point1; }	
		 
		public function set point1(pt:Point) {
			_point1 = pt;
			recalculate();
		}
		 
		public function get x1():Number { return _point1.x; }
		 
		public function set x1(val:Number) {
			if(_point1.x != val) {
				_point1.x = val;
				recalculate();
			}
		}
		 
		public function get y1():Number { return _point1.y; }
		 
		public function set y1(val:Number) {
			if(_point1.y != val) {
				_point1.y = val;
				recalculate();
			}
		}
		 
		public function get point2():Point { return _point2; }	
		 
		public function set point2(pt:Point) {
			_point2 = pt;
			recalculate();
		}
		 
		public function get x2():Number { return _point2.x; }
		 
		public function set x2(val:Number) {
			if(_point2.x != val) {
				_point2.x = val;
				recalculate();
			}
		}
		 
		public function get y2():Number { return _point2.y; }
		 
		public function set y2(val:Number) {
			if(_point2.y != val) {
				_point2.y = val;
				recalculate();
			}
		}
		 
		public function get bounds():Rectangle { return _bounds; }
		 
		public function get isHorizontal():Boolean { return _point1.y == _point1.y; }
		 
		public function get isVertical():Boolean { return _point1.x == _point1.x; }
		
		public function get line():SlopeLine { return _line; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Construction Functions
		
		/**
		 * @Use this function to reset values based on our end points when the 
		 * @position of one of those points changes.
		 */
		 
		public function recalculate():void{
			// calculate bounds
			if(_point1.x <= _point2.x) {
				_bounds.left = _point1.x;
				_bounds.right = _point2.x;
			} else {
				_bounds.left = _point2.x;
				_bounds.right = _point1.x;
			}
			if(_point1.y <= _point2.y) {
				_bounds.top = _point1.y;
				_bounds.bottom = _point2.y;
			} else {
				_bounds.top = _point2.y;
				_bounds.bottom = _point1.y;
			}
			// calculate slope
			if(_bounds.left == _bounds.right) {
				// we have a vertical line
				_line.slope = Infinity;
				_line.intercept = _bounds.left;
			} else {
				if(_bounds.top == _bounds.bottom) {
					// we have a horizontal line
					_line.slope = 0;
					_line.intercept = _bounds.top;
				} else {
					// the slope isn't axis aligned
					var rise:Number = _point2.y - _point1.y;
					var run:Number = _point2.x - _point1.x;
					_line.slope = rise / run;
					_line.intercept = _line.getInterceptFor(_point1.x,_point1.y);
				}
			}
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
			// shift line
			_line.movedBy(dx,dy);
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
		 * @Checks if two line segments intersect.
		 * @param		other		LineSegment		The line we're checking for intersection.
		 */
		 
		public function intersectsSegment(other:LineSegment):Boolean{
			if(other == null) return false;
			// start with a quick bounds test
			if(!_bounds.intersects(other.bounds)) return false;
			// find the overlap for each segment's line
			var overlap:Object = _line.getIntersection(other._line);
			if(overlap == null) return false; // the lines don't overlap
			if(overlap is Point) {
				// we intersect if the target point is in bounds
				var pt:Point = overlap as Point;
				return _bounds.containsPoint(pt);
			} else {
				// If the overlap is more than 1 point, the segments must be along
				// the same line.  Segments of the same line with overlapping bounds 
				// must intersect each other.
				return true;
			}
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
			// Check this segment's slope.  If it's axis aligned there must be an intersection since
			// we passed the bounding box test.
			if(isHorizontal || isVertical) return true;
			// otherwise, use our line to find the point of intersection
			var px:Number = _line.getXAt(py);
			if(px < min_x) return false;
			if(px > max_x) return false;
			return true;
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
			// Check this segment's slope.  If it's axis aligned there must be an intersection since
			// we passed the bounding box test.
			if(isHorizontal || isVertical) return true;
			// otherwise, use our line to find the point of intersection
			var py:Number = _line.getYAt(px);
			if(py < min_y) return false;
			if(py > max_y) return false;
			return true;
		}
		
		/**
		 * @This function checks if a given point is within this line segment.
		 * @param		pt		Point 		The point being checked for intersection.
		 */
		 
		public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			if(!_bounds.containsPoint(pt)) return false;
			if(!_line.intersectsPoint(pt)) return false;
			return true;
		}
		
		// Math Functions
		
		/**
		 * @This function return how far a given point is from this line segment.
		 * @param		pt		Point 		The point being checked.
		 */
		 
		public function distanceToPoint(pt:Point):Number{
			var closest:Point = _line.getNearestPoint(pt);
			if(closest == null) return 0;
			// check if the closest point on the line is in bounds
			if(_bounds.containsPoint(closest)) {
				return Point.distance(pt,closest);
			} else {
				// if not, use closest end point
				var d1:Number = Point.distance(pt,_point1);
				var d2:Number = Point.distance(pt,_point2);
				return Math.min(d1,d2);
			}
		}
		
		/**
		 * @This function finds the last point a particle would pass through this line if it 
		 * @were projected along the given path.
		 * @param		path		Ray 		The path we're projecting along.
		 */
		
		public function getExitPoint(path:Ray):Point {
			if(path == null) return null;
			// start with a quick bounds test
			var path_bounds:Rectangle = path.bounds;
			if(!_bounds.intersects(path_bounds)) return null;
			// find the overlap for each segment's line
			var overlap:Object = _line.getIntersection(path.line);
			if(overlap == null) return null; // the lines don't overlap
			if(overlap is Point) {
				// we intersect if the target point is in bounds
				var pt:Point = overlap as Point;
				if(_bounds.containsPoint(pt) && path_bounds.containsPoint(pt)) {
					return pt;
				} else return null;
			} else {
				// If the overlap is more than 1 point, the segment and path must be along
				// the same line.  As such, the exit point will be one of our end points.
				// Since our bounds overlap, at least one end point must be within the ray's bounds.
				if(!path_bounds.containsPoint(_point1)) return _point2.clone();
				if(!path_bounds.containsPoint(_point2)) return _point1.clone();
				// if that fails, both points are valid, so pick the further of the two.
				// Since all points are along the same slope, smaller changes in x position correspond 
				// to smaller distance for all non-vertical lines.
				var d1:Number;
				var d2:Number;
				if(isVertical) {
					d1 = Math.abs(path.y - _point1.y);
					d2 = Math.abs(path.y - _point2.y);
				} else {
					d1 = Math.abs(path.x - _point1.x);
					d2 = Math.abs(path.x - _point2.x);
				}
				// use the greatest distance to pick our point
				if(d1 >= d2) return _point1.clone();
				else return _point2.clone();
			}
			return null;
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		public function toString():String{
			return "["+_point1+" to "+_point2+"]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
