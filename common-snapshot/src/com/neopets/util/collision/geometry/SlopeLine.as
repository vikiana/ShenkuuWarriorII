/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.geom.Point;
	
	/**
	 *	This class handles lines that can be defined by the slope formula (y = m*x + b).
	 *  It also has some support for vertical lines (where y can be any value, but x is fixed).
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.2.2009
	 */
	public class SlopeLine
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _slope:Number;
		protected var _inverseSlope:Number;
		protected var _slopeDifference:Number; // used to calculate point distances
		public var intercept:Number; // treat as y-intercept for non-vertical lines
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function SlopeLine(ratio:Number=0,pos:Number=0):void{
			slope = ratio;
			intercept = pos;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get slope():Number { return _slope; }
		
		public function set slope(ratio:Number) {
			if(_slope != ratio) {
				_slope = ratio;
				// check for special slopes to avoid division by 0 or infinity
				if(isHorizontal) {
					_inverseSlope = Infinity;
					_slopeDifference = Infinity;
				} else {
					if(isVertical) {
						_inverseSlope = 0;
						_slopeDifference = -Infinity;
					} else {
						// the slope isn't axis aligned
						_inverseSlope = -1 / _slope;
						_slopeDifference = _inverseSlope - _slope;
					}
				} // end of axis alignment check
			}
		}
		 
		public function get isHorizontal():Boolean { return _slope == 0; }
		 
		public function get isVertical():Boolean { return _slope == Infinity; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function solves for the y-intercept given certain x and y values.
		 * @param		px		Number		Target x coordinate.
		 * @param		py		Number		Target y coordinate.
		 */
		 
		public function getInterceptFor(px:Number,py:Number):Number{
			if(isVertical) return px; // vertical lines don't use the slope formula
			// solve y-intercept using: y = mx + b -> b = y - mx
			return py - _slope * px;
		}
		
		/**
		 * @Try to find the point where this line intersects with another one.
		 * @param		other		SlopeLine		The line we're checking for intersection.
		 */
		 
		public function getIntersection(other:SlopeLine):Object{
			if(other == null) return null; // invalid line
			// parallel lines only intersect if they share the same intercept
			if(other.slope == _slope) {
				if(other.intercept == intercept) {
					return new SlopeLine(_slope,intercept);
				} else return null;
			}
			// non-parallel lines intersect at a single point
			var pt:Point = new Point();
			// check our slope
			if(isHorizontal) {
				pt.x = other.getXAt(intercept);
				pt.y = intercept;
			} else {
				if(isVertical) {
					pt.x = intercept;
					pt.y = other.getYAt(intercept);
				} else {
					// This line is sloped.  Now check the slope of the other line.
					if(other.isHorizontal) {
						pt.x = getXAt(other.intercept);
						pt.y = other.intercept;
					} else {
						if(other.isVertical) {
							pt.x = other.intercept;
							pt.y = getYAt(other.intercept);
						} else {
							// both lines are sloped, so we can combine their slope formulae
							// two "y = mx + b" formalae shorten to "x = (b1 - b2) / (m2 - m1)"
							pt.x = (intercept - other.intercept) / (other._slope - _slope);
							pt.y = getYAt(pt.x);
						}
					} // end of other slope test
				}
			} // end of slope test
			return pt;
		}
		
		/**
		 * @This function returns the point along this line that's closest to the target point.
		 * @param		pt		Point 		The point being checked.
		 */
		 
		public function getNearestPoint(pt:Point):Point{
			if(pt == null) return null;
			// check our slope
			if(isHorizontal) return new Point(pt.x,intercept);
			if(isVertical) return new Point(intercept,pt.y);
			// this line must be sloped, so get the y-intercept for a line through 
			// the point that's also perpendicular to this line.
			// solve y-intercept using: y = mx + b -> b = y - mx
			var yi:Number = pt.y - _inverseSlope * pt.x;
			// find the x coordinates of the point where both lines intersect
			// two "y = mx + b" formalae shorten to "x = (b1 - b2) / (m2 - m1)"
			var px:Number = (intercept - yi) / _slopeDifference;
			var py:Number = getYAt(px);
			// if we got this far, the calculate the distance from a point within this line
			return new Point(px,py);
		}
		
		/**
		 * @This function returns the x value for a given value of y.
		 * @param		py		Number		The y-coordinate we're solving for.
		 */
		 
		public function getXAt(py:Number):Number{
			if(isHorizontal) return NaN; // horizontal lines contain all x values
			// y = m*x + b -> y - b = m*x -> x = (y - b) / m
			return (py - intercept) / _slope;
		}
		
		/**
		 * @This function returns the y value for a given value of x.
		 * @param		px		Number		The x-coordinate we're solving for.
		 */
		 
		public function getYAt(px:Number):Number{
			if(isVertical) return NaN; // vertical lines contain all y values
			return _slope * px + intercept;
		}
		
		/**
		 * @This function checks if a given point is within this line segment.
		 * @param		pt		Point 		The point being checked for intersection.
		 */
		 
		public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			var py:Number = getYAt(pt.x);
			return (py == pt.y);
		}
		
		/**
		 * @This function moves all points in this line by the given amount.
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 */
		 
		public function movedBy(dx:Number,dy:Number):void{
			if(isVertical) {
				// update x intercept
				intercept += dx;
			} else {
				// update y intercept
				intercept += dy - _slope * dx;
			}
		}
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		public function toString():String{
			if(isHorizontal) return "[y = "+intercept+"]";
			if(isVertical) return "[x = "+intercept+"]";
			return "[y = "+_slope+"x + "+intercept+"]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
