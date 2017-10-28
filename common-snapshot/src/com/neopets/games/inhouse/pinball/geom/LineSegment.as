// Use this class to handle line segment operations and tests.
// Author: David Cary
// Last updated: June 2008

package com.neopets.games.inhouse.pinball.geom
{
	
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class LineSegment {
		protected var _pointA:Vector;
		protected var _pointB:Vector;
		protected var slope:Number;
		protected var crossSlope:Number;
		protected var yIntercept:Number;
		protected var minY:Number;
		protected var maxY:Number;
		protected var minX:Number;
		protected var maxX:Number;
		
		public function LineSegment(p1:Vector=null,p2:Vector=null) {
			setPoints(p1,p2);
		}
		
		// Accessor Functions
		
		public function get length():Number {
			if(_pointA == null || _pointB == null) return 0;
			else return _pointA.distance(_pointB);
		}
		
		public function get pointA():Vector { return _pointA; }
		
		public function set pointA(pt:Vector) {
			_pointA = pt;
			recalculate();
		}
		
		public function get pointB():Vector { return _pointB; }
		
		public function set pointB(pt:Vector) {
			_pointB = pt;
			recalculate();
		}
		
		public function setPoints(p1:Vector,p2:Vector) {
			_pointA = p1;
			_pointB = p2;
			recalculate();
		}
		
		// use this function to make sure our values are up to date.
		public function recalculate() {
			if(_pointA != null && _pointB != null) {
				// calculate slope: slope = rise/run = delta y / delta x
				slope = (_pointB.y - _pointA.y)/(_pointB.x - _pointA.x);
				crossSlope = -1 / slope;
				// get boundaries
				if(_pointA.x < _pointB.x) {
					minX = _pointA.x;
					maxX = _pointB.x;
				} else {
					minX = _pointB.x;
					maxX = _pointA.x;
				}
				if(_pointA.y < _pointB.y) {
					minY = _pointA.y;
					maxY = _pointB.y;
				} else {
					minY = _pointB.y;
					maxY = _pointA.y;
				}
				// find y intercept
				yIntercept = _pointA.x * slope - _pointA.y;
			}
		}
		
		// Math Functions
		
		// Use this function to determin how close our spring is to a given point.
		public function distanceTo(pt:Vector):Number {
			// get the distance to the line
			if(minY == maxY) {
				// the line is horizontal
				if(pt.x > minX && pt.x < maxX) return Math.abs(pt.y - minY);
			} else {
				if(minX == maxX) {
					// the line is vertical
					if(pt.y > minY && pt.y < maxY) return Math.abs(pt.x - minX);
				} else {
					// find the y-intercept of a perpendicular line that runs through
					// the center of the target circle
					var cyi:Number = pt.x * crossSlope - pt.y;
					// solve y = m * x + b for x at the point both lines intersect
					var ix:Number = (cyi - yIntercept) / (slope - crossSlope);
					// check if the intersection is in bounds
					if(ix > minX && ix < maxX) {
						var iy:Number = ix * slope + yIntercept;
						return pt.distance(new Vector(ix,iy));
					}
				}
			}
			// get the distance to our end points
			var da:Number = pt.distance(_pointA);
			var db:Number = pt.distance(_pointB);
			return Math.min(da,db);
		}
		
		// Use this function to return the point on this line closest to a given point.
		public function getClosestPointTo(pt:Vector):Vector {
			// search along the line
			if(minY == maxY) {
				// the line is horizontal
				if(pt.x > minX && pt.x < maxX) return new Vector(pt.x,minY);
			} else {
				if(minX == maxX) {
					// the line is vertical
					if(pt.y > minY && pt.y < maxY) return new Vector(minX,pt.y);
				} else {
					// find the y-intercept of a perpendicular line that runs through
					// the center of the target circle
					var cyi:Number = pt.x * crossSlope - pt.y;
					// solve y = m * x + b for x at the point both lines intersect
					var ix:Number = (cyi - yIntercept) / (slope - crossSlope);
					// check if the intersection is in bounds
					if(ix > minX && ix < maxX) {
						var iy:Number = ix * slope + yIntercept;
						return new Vector(ix,iy);
					}
				}
			}
			// check our end points
			var da:Number = pt.distance(_pointA);
			var db:Number = pt.distance(_pointB);
			if(da < db) return _pointA;
			else return _pointB;
		}
		
		// This function checks if this line segment passes through a second line segment.
		public function intersects(ln:LineSegment):Boolean {
			if(ln == null) return false;
			// perform a quick bounding box test
			if(ln.minX > maxX || ln.maxX < minX) return false;
			if(ln.minY > maxY || ln.maxY < minY) return false;
			// check if the lines are parallel
			if(ln.slope == slope) return (ln.yIntercept == yIntercept);
			// search along the line
			var ix:Number;
			var iy:Number;
			if(minY == maxY) {
				// the line is horizontal
				if(ln.minX != maxX) {
					// y = mx + b -> x = (y - b) / m
					ix = (minY - ln.yIntercept) / ln.slope;
					return (ix >= minX && ix <= maxX);
				} else return true; // we already know the bounding boxes overlap
			} else {
				if(minX == maxX) {
					// the line is vertical
					if(ln.minX != maxX) {
						iy = ln.slope * minX + ln.yIntercept; // y = mx + b
						return (iy >= minY && iy <= maxY);
					} else return true; // we already know the bounding boxes overlap
				} else {
					// solve y = m * x + b for x at the point both lines intersect
					ix = (ln.yIntercept - yIntercept) / (slope - ln.slope);
					// check if the intersection is in bounds
					if(ix > minX && ix < maxX) {
						iy = ix * slope + yIntercept;
						return (iy >= minY && iy <= maxY);
					} else return false;
				} // end of vertical test
			} // end of horizontal test
		}
		
	}
	
}