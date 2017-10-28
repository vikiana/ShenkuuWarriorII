/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *	Ray handle a line that extends indefinately in a single direction from a given point.
	 *  This class stores a lot of precalculated values to speed up collision testing.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.2.2009
	 */
	public class Ray
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _origin:Point;
		protected var _direction:Number; // in radians
		protected var _line:SlopeLine = new SlopeLine();
		protected var _unitVector:Point = new Point();
		protected var _bounds:Rectangle = new Rectangle();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Ray(pt:Point=null,dir:Number=0):void{
			if(pt != null) _origin = pt;
			else _origin = new Point();
			_direction = dir;
			// synch values
			updateSlope();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		 
		public function get direction():Number { return _direction; }	
		 
		public function set direction(dir:Number) {
			_direction = dir;
			updateSlope();
		}
		 
		public function get origin():Point { return _origin; }	
		 
		public function set origin(pt:Point) {
			_origin = pt;
			updateBounds();
		}
		 
		public function get x():Number { return _origin.x; }
		 
		public function set x(val:Number) {
			if(_origin.x != val) {
				_origin.x = val;
				updateBounds();
			}
		}
		 
		public function get y():Number { return _origin.y; }
		 
		public function set y(val:Number) {
			if(_origin.y != val) {
				_origin.y = val;
				updateBounds();
			}
		}
		
		public function get line():SlopeLine { return _line; }
		
		public function get bounds():Rectangle { return _bounds; }
		 
		public function get isHorizontal():Boolean { return _line.isHorizontal; }
		 
		public function get isVertical():Boolean { return _line.isVertical; }
		
		public function get xRatio():Number { return _unitVector.x; }
		
		public function get yRatio():Number { return _unitVector.y; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Construction Functions
		
		/**
		 * @Use this function to update our slope values when our direction changes.
		 */
		 
		public function updateSlope():void{
			// calculate slope
			var rise:Number = Math.sin(_direction);
			var run:Number = Math.cos(_direction);
			if(run != 0) {
				_line.slope = rise / run;
				_line.intercept = _line.getInterceptFor(_origin.x,_origin.y);
			} else {
				// we have a vertical line
				_line.slope = Infinity;
				_line.intercept = _origin.x;
			}
			// calculate unit vector
			_unitVector.x = Math.cos(_direction);
			_unitVector.y = Math.sin(_direction);
			// update our bound to compensate for the change in direction
			updateBounds();
		}
		
		/**
		 * @Use this function to update our bounds values when our origin or direction changes.
		 */
		 
		public function updateBounds():void{
			if(_unitVector.x >= 0) {
				_bounds.left = _origin.x;
				_bounds.right = Infinity;
			} else {
				_bounds.left = -Infinity;
				_bounds.right = _origin.x;
			}
			if(_unitVector.y >= 0) {
				_bounds.top = _origin.y;
				_bounds.bottom = Infinity;
			} else {
				_bounds.top = -Infinity;
				_bounds.bottom = _origin.y;
			}
		}
		
		/**
		 * @Use this function to change this ray's origin position without creating a new point object.
		 */
		 
		public function moveTo(px:Number,py:Number):void{
			_origin.x = px;
			_origin.y = py;
			updateBounds();
		}
		
		// Intersection Functions
		
		/**
		 * @Checks if two line segments intersect.
		 * @param		other		LineSegment		The line we're checking for intersection.
		 */
		 
		public function intersectsSegment(other:LineSegment):Boolean{
			if(other == null) return false;
			// start with a quick bounds test
			if(!_bounds.intersects(other.bounds)) return false;
			// find the overlap for each segment's line
			var overlap:Object = _line.getIntersection(other.line);
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
		 * @This function returns a point at a given distance along the ray.
		 * @param		dist		Number 		The distance along the ray.
		 */
		 
		public function getPointAt(dist:Number):Point {
			var px:Number = _origin.x + dist * _unitVector.x;
			var py:Number = _origin.y + dist * _unitVector.y;
			return new Point(px,py);
		}
		
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
				// otherwise, use the distance to our origin
				return Point.distance(pt,origin);
			}
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		public function toString():String{
			return "[from "+_origin+" at "+_direction+" radians]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
