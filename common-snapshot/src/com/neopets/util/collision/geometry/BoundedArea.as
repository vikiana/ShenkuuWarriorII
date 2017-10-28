/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.neopets.util.collision.geometry.trails.AreaTrail;
	
	/**
	 *	Bounded Areas are basic units of space that can be checked for intersection with similar areas.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class BoundedArea extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const AREA_CHANGED:String = "area_changed";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _bounds:Rectangle;
		protected var _center:Point;
		protected var _enableHistory:Boolean;
		protected var prevState:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function BoundedArea():void{
			_bounds = new Rectangle();
			_center = new Point();
			_enableHistory = false;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function returns our bounding box.
		 */
		 
		public function get bounds():Rectangle { return _bounds; }
		
		/**
		 * @This function returns our center point
		 */
		 
		public function get center():Point { return _center; }
		
		/**
		 * @This function returns whether or not we're tracking the area's past state.
		 */
		 
		public function get enableHistory():Boolean { return _enableHistory; }
		
		/**
		 * @This function turn on tracking of the area's past state.
		 */
		 
		public function set enableHistory(b:Boolean) {
			if(_enableHistory != b) {
				_enableHistory = b;
				if(!_enableHistory) prevState = null;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Intersection Functions
		
		/**
		 * @This function checks if two bounded areas have overlapping boundaries.
		 * @param		other		BoundedArea 		The area we're checking for intersection.
		 */
		 
		public function boundsIntersect(other:BoundedArea):Boolean{
			if(other == null) return false;
			return _bounds.intersects(other.bounds);
		}
		
		/**
		 * @This returns our angle in radians from another bounded area.
		 * @param		other		BoundedArea 		The area we're using as our origin.
		 */
		
		public function getDirectionFrom(other:BoundedArea):Number {
			if(other == null) return 0;
			var dx:Number = _center.x - other.center.x;
			var dy:Number = _center.y - other.center.y;
			return Math.atan2(dy,dx);
		}
		
		/**
		 * @This function tries to find how far you'd have to move this area so it no longer
		 * @overlaps the provided area.
		 * @This version of the function uses bounding boxes for the exit area.
		 * @However, subclasses can override this for greater precision.
		 * @param		other		BoundedArea 		The area we're checking for intersection.
		 * @param		dir			Number		 		Direction to project the exit along, in radians.
		 * @param		strict		Boolean		 		This flag forces the exit vector along the provided 
		 * @											direction, even if there's a shorter path.
		 */
		
		public function getExitVectorFor(other:BoundedArea,dir:Number=NaN,strict:Boolean=false):Point {
			if(!boundsIntersect(other)) return new Point(); // don't move if our bounds don't intersect
			// if no direction is provided, use our center points to calculate it
			if(isNaN(dir)) dir = getDirectionFrom(other);
			// calculate the distance needed for a horizontal shift
			var other_bounds:Rectangle = other.bounds;
			var dx:Number;
			var h_dist:Number;
			var unit_x:Number = Math.cos(dir);
			if(unit_x != 0) {
				// positive unit vector means move right, negative means move left
				if(unit_x > 0) dx = other_bounds.right - _bounds.left;
				else dx = other_bounds.left - _bounds.right;
				h_dist = Math.abs(dx / unit_x);
			} else h_dist = Infinity; // ignore horizontal shift if direction is vertical
			// repeat check for vertical shift
			var dy:Number;
			var v_dist:Number;
			var unit_y:Number = Math.sin(dir);
			if(unit_y != 0) {
				// positive unit vector means move down, negative means move up
				if(unit_y > 0) dy = other_bounds.bottom - _bounds.top;
				else dy = other_bounds.top - _bounds.bottom;
				v_dist = Math.abs(dy / unit_y);
			} else v_dist = Infinity; // ignore vertical shift if direction is horizontal
			// use the smaller of the provided distances
			if(h_dist <= v_dist) {
				if(strict) {
					dy = dx * Math.tan(dir);
					return new Point(dx,dy);
				} else return new Point(dx,0);
			} else {
				if(strict) {
					if(unit_x != 0) dx = dy / Math.tan(dir);
					else dx = 0;
					return new Point(dx,dy);
				} else return new Point(0,dy);
			}
		}
		
		/**
		 * @This function checks the type of the other bounded area and selects a more
		 * @shape specific collision function to deal with it.
		 * @param		other		BoundedArea 		The area we're checking for intersection.
		 */
		 
		public function intersects(other:BoundedArea):Boolean{
			if(other == null) return false;
			if(_bounds.intersects(other.bounds)) {
				if(other is LineArea) {
					if(other is PolygonArea) {
						return intersectsPolygon(other as PolygonArea,false);
					} else {
						if(other is ChainArea) return intersectsChain(other as ChainArea,false);
						else return intersectsLine(other as LineArea,false);
					}
				} else {
					if(other is PointArea) {
						if(other is CircleArea) {
							return intersectsCircle(other as CircleArea,false);
						} else {
							return intersectsPoint(other.center);
						}
					} else {
						if(other is RectangleArea) {
							return intersectsRectangle(other.bounds);
						} else {
							if(other is CompositeArea) {
								return intersectsComposite(other as CompositeArea,false);
							}
						} // end of Rectangle check
					} // end of PointArea check
				} // end of LineArea check
				return true; // areas with overlapping bounds intersect by default
			} 
			return false;
		}
		
		// Note: Shape specific collision tests can take an optional "full_test" flag which
		// can be set false if we know that the other object exists and intersects our bounds.
		// This flag lets you skip redundant testing as needed.
		
		/**
		 * @This is a shape specific collision test between this area and a chain.
		 * @param		other		ChainArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		public function intersectsChain(other:ChainArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				return _bounds.intersects(other.bounds);
			} else return true;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a circle.
		 * @param		other		CircleArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		public function intersectsCircle(other:CircleArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				return _bounds.intersects(other.bounds);
			} else return true;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a composite area.
		 * @param		other		CompositeArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		public function intersectsComposite(other:CompositeArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				return _bounds.intersects(other.bounds);
			} else return true;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a line.
		 * @param		other		LineArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		public function intersectsLine(other:LineArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				return _bounds.intersects(other.bounds);
			} else return true;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point.
		 * @param		pt		Point 		The position we're checking for intersection.
		 */
		 
		public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			return _bounds.containsPoint(pt);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point area.
		 * @param		other		PointArea 		The position we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		public function intersectsPointArea(other:PointArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			return _bounds.containsPoint(other.center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a polygon.
		 * @param		other		PolygonArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 			Do validation and proximity tests?
		 */
		 
		public function intersectsPolygon(other:PolygonArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				return _bounds.intersects(other.bounds);
			} else return true;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle.
		 * @param		rect		Rectangle 		The area we're checking for intersection.
		 */
		 
		public function intersectsRectangle(rect:Rectangle):Boolean{
			return _bounds.intersects(rect);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle area.
		 * @param		other		RectangleArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 			Do validation and proximity tests?
		 */
		 
		public function intersectsRectangleArea(other:RectangleArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			return intersectsRectangle(other.bounds);
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		DisplayObject 		The object we're using to draw this area.
		 */
		 
		public function drawOn(canvas:Sprite):void{
			if(canvas != null) {
				var brush:Graphics = canvas.graphics;
				brush.drawRect(_bounds.left,_bounds.top,_bounds.width,_bounds.height);
			}
		}
		
		/**
		 * @This function moves the area by the given values
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		dr		Number 		Change in rotation
		 */
		 
		public function moveBy(dx:Number,dy:Number,dr:Number=0):void{
			var changed:Boolean = false;
			if(dx != 0) {
				_bounds.x += dx;
				_center.x += dx;
				changed = true;
			}
			if(dy != 0) {
				_bounds.y += dy;
				_center.y += dy;
				changed = true;
			}
			if(changed) dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @This function moves the area so it's centered over a given position.
		 * @param		tx		Number 		Target x coordinate
		 * @param		ty		Number 		Target y coordinate
		 * @param		tr		Number 		Target rotation
		 */
		 
		public function moveTo(tx:Number,ty:Number,tr:Number=0):void{
			var dx:Number = tx - _center.x;
			var dy:Number = ty - _center.y;
			moveBy(dx,dy);
		}
		
		/**
		 * @Repeats the area's building function with the last parameters used.
		 */
		 
		public function rebuild():void{
			dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @Forces our center to the middle of our bounding area.
		 */
		 
		public function resetCenter():void{
			_center.x = (_bounds.left + _bounds.right) / 2;
			_center.y = (_bounds.top + _bounds.bottom) / 2;
		}
		
		/**
		 * @Recalculates our boundaries if possible.
		 */
		 
		public function resetBounds():void{}
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		public function getTrail():AreaTrail{ return new AreaTrail(this); }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
	
}
