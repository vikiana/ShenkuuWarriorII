/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import com.neopets.util.collision.geometry.trails.AreaTrail;
	import com.neopets.util.collision.geometry.trails.PolygonAreaTrail;
	
	/**
	 *	Polygon areas are closed shapes bounded by line segments.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.11.2009
	 */
	public class PolygonArea extends LineArea
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		image		DisplayObject 		The object we're basing this area on.
		 *  @param		cspace		DisplayObject 		The coordinate space we're using.
		 */
		public function PolygonArea(list:Array=null,cspace:DisplayObject=null):void{
			super(list,cspace);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function rebuilds this line from a given point list.
		 */
		 
		override public function set segments(list:Array) {
			clearPoints();
			if(list != null) {
				_segments = list;
				if(_segments.length > 0) {
					// add starting points for each segment
					var pt:Point;
					var seg:LineSegment;
					for(var i:int = 0; i < _segments.length; i++) {
						seg = _segments[i];
						_points.push(seg.point1);
					}
				}
				resetBounds();
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @This function rebuilds this line from a given point list.
		 */
		 
		override public function set points(list:Array) {
			clearPoints();
			if(list != null) {
				_points = list;
				if(_points.length > 0) {
					// get first point
					var prev_pt:Point = _points[0];
					var pt:Point;
					var seg:LineSegment;
					// cycle through remaining points
					for(var i:int = 1; i < _points.length; i++) {
						pt = _points[i];
						// set up segment
						seg = new LineSegment(prev_pt,pt);
						_segments.push(seg);
						prev_pt = pt;
					} // end of point loop
					// close the polygon
					pt = _points[0];
					seg = new LineSegment(prev_pt,pt);
					_segments.push(seg);
				}
				resetBounds();
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Construction Functions
		
		/**
		 * @This function places the area at the center of the target display object.
		 * @param		list		Array		 		The display objects we're converting to points.
		 * @param		cspace		DisplayObject 		The coordinate space we're using
		 */
		 
		override public function buildFrom(list:Array,cspace:DisplayObject=null):void{
			clearPoints();
			if(list != null) {
				var entry:Object;
				var dobj:DisplayObject;
				var origin:Point = new Point();
				var pt:Point;
				var prev_pt:Point;
				var seg:LineSegment;
				for(var i:int = list.length - 1; i >= 0; i--) {
					entry = list[i];
					if(entry is DisplayObject) {
						dobj = entry as DisplayObject;
						pt = dobj.localToGlobal(origin);
						if(cspace != null) pt = cspace.globalToLocal(pt);
						_points.unshift(pt);
						if(prev_pt == null) {
							// set bounds from first point
							_bounds.x = pt.x;
							_bounds.y = pt.y;
							_bounds.height = 0;
							_bounds.width = 0;
						} else {
							// stretch bounds as needed
							if(pt.x < _bounds.left) _bounds.left = pt.x;
							else {
								if(pt.x > _bounds.right) _bounds.right = pt.x;
							}
							if(pt.y < _bounds.top) _bounds.top = pt.y;
							else {
								if(pt.y > _bounds.bottom) _bounds.bottom = pt.y;
							}
							// add a line segment
							seg = new LineSegment(pt,prev_pt);
							_segments.unshift(seg);
						}
						prev_pt = pt;
					} else list.splice(i,1);
				} // end of point loop
				// close the polygon
				pt = _points[_points.length-1];
				seg = new LineSegment(pt,prev_pt);
				_segments.push(seg);
				resetCenter();
				dispatchEvent(new Event(AREA_CHANGED));
			}
			// store values
			_builtFrom = list;
			_coordSpace = cspace;
		}
		
		/**
		 * @This function tries to insert a point after our last one.
		 * @param		pt		Point 		Point to be added.
		 */
		 
		override public function pushPoint(pt:Point):void{
			if(pt != null) {
				_points.push(pt);
				// update segments
				if(_points.length > 1) {
					var seg:LineSegment;
					if(_segments.length > 1) {
						seg = _segments[_segments.length - 2];
						seg.point2 = pt;
					}
					seg = new LineSegment(pt,_points[0]);
					_segments.push(seg);
				}
				// stretch bounds as needed
				if(pt.x < _bounds.left) _bounds.left = pt.x;
				else {
					if(pt.x > _bounds.right) _bounds.right = pt.x;
				}
				if(pt.y < _bounds.top) _bounds.top = pt.y;
				else {
					if(pt.y > _bounds.bottom) _bounds.bottom = pt.y;
				}
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		// Intersection Functions
		
		/**
		 * @This is a shape specific collision test between this area and a chain.
		 * @param		other		ChainArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsChain(other:ChainArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			// check for overlapping segments
			var segs:Array = other.segments;
			var ls:LineSegment;
			var ts:ThickSegment;
			var j:int;
			for(var i:int = 0; i < segs.length; i++) {
				ts = segs[i];
				for(j = 0; j < _segments.length; j++) {
					ls = _segments[j];
					if(ts.intersectsLine(ls)) return true;
				}
			} // end of segment loop
			// check if the line has is inside this polygon
			var pts:Array = other.points;
			if(pts.length > 0) {
				if(intersectsPoint(pts[0])) return true;
			} // end of point check
			return false;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a circle.
		 * @param		other		CircleArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsCircle(other:CircleArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			// store circle properties locally
			var pt:Point = other.center;
			var r:Number = other.radius;
			// check each segment
			var dist:Number;
			var seg:LineSegment;
			for(var i:int = 0; i < _segments.length; i++) {
				seg = _segments[i];
				if(seg.boundsIntersect(other)) {
					dist = seg.distanceToPoint(pt);
					if(dist <= r) return true;
				}
			}
			// make sure the circle isn't inside this polygon
			if(intersectsPoint(other.center)) return true;
			return false;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a composite area.
		 * @param		other		CompositeArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 			Do validation and proximity tests?
		 */
		 
		override public function intersectsComposite(other:CompositeArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			return other.intersectsPolygon(this,false);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a line.
		 * @param		other		LineArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsLine(other:LineArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			// check for overlapping segments
			var segs:Array = other.segments;
			var s1:LineSegment;
			var s2:LineSegment;
			var j:int;
			for(var i:int = 0; i < segs.length; i++) {
				s1 = segs[i];
				for(j = 0; j < _segments.length; j++) {
					s2 = _segments[j];
					if(s1.intersectsSegment(s2)) return true;
				}
			} // end of segment loop
			// check if the line has is inside this polygon
			var pts:Array = other.points;
			if(pts.length > 0) {
				if(intersectsPoint(pts[0])) return true;
			} // end of point check
			return false;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point.
		 * @param		pt		Point 		The position we're checking for intersection.
		 */
		 
		override public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			if(_bounds.containsPoint(pt)) {
				// Draw a horizontal line between the point and just past our left edge.
				// The line starts outside the polgon and flips to inside each time we pass a barrier.
				// We'll use this toggling to determine if the point must be interior or exterior.
				var inside:Boolean = false;
				var min_x:Number = _bounds.left - 1;
				// test the line against each of our segments
				var seg:LineSegment;
				var prev_vert:Point;
				var cur_vert:Point;
				var next_vert:Point;
				for(var i:int = 0; i < _segments.length; i++) {
					seg = _segments[i];
					// does the line pass through this segments end point?
					cur_vert = seg.point2;
					if(pt.y == cur_vert.y) {
						// Check if the line passes though this vertex.
						if(cur_vert.x <= pt.x) {
							// if the point actually overlaps the vertex it's inside the polygon
							if(cur_vert.x == pt.x) return true;
							// Otherwise, we need to check the angle of this corner.  If both lines go
							// up or down from this point we just pass through a tip and don't need
							// to change our inside status.  It's only if the angle's sides are on opposite
							// sides of our test path that we need to toggle the status.
							prev_vert = seg.point1;
							next_vert = _points[(i + 2) % _points.length];
							if(prev_vert.y < cur_vert.y) {
								if(next_vert.y >= cur_vert.y) inside = !inside;
							} else {
								if(prev_vert.y > cur_vert.y) {
									if(next_vert.y <= cur_vert.y) inside = !inside;
								} else {
									// the segment is horizontal
									if(next_vert.y != cur_vert.y) inside = !inside;
								}
							} // end of angle checking
						}
					} else {
						// Skip this segment if it passes through our first point.
						// That vertex is checked by the previous segment and doesn't need
						// to be checked twice.
						prev_vert = seg.point1;
						if(pt.y != prev_vert.y) {
							// otherwise, we can just check if our test line passes through the segment
							if(seg.intersectsHorizontal(pt.y,min_x,pt.x)) inside = !inside;
						}
					} // end of vertex test
				} // end of segment loop
			} // end of bounding test
			return inside;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a polygon.
		 * @param		other		PolygonArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 			Do validation and proximity tests?
		 */
		 
		override public function intersectsPolygon(other:PolygonArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			if(intersectsLine(other,false)) return true;
			// check if we're inside the other polygon
			if(other != null) {
				if(_points.length > 0) {
					return other.intersectsPoint(_points[0]);
				}
			}
			return false
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle.
		 * @param		rect		Rectangle 		The area we're checking for intersection.
		 */
		 
		override public function intersectsRectangle(rect:Rectangle):Boolean{
			if(_bounds.intersects(rect)) {
				// check if any of our points are inside the rectangle
				var i:int;
				var pt:Point;
				for(i = 0; i < _points.length; i++) {
					pt = _points[i];
					if(rect.containsPoint(pt)) return true;
				}
				// check if any of our segments overlap the rectangle
				var seg:LineSegment;
				for(i = 0; i < _segments.length; i++) {
					seg = _segments[i];
					if(seg.intersectsHorizontal(rect.top,rect.left,rect.right)) return true;
					if(seg.intersectsHorizontal(rect.bottom,rect.left,rect.right)) return true;
					if(seg.intersectsVertical(rect.left,rect.top,rect.bottom)) return true;
					if(seg.intersectsVertical(rect.right,rect.top,rect.bottom)) return true;
				}
				// make sure the rectangle isn't hidding inside the polygon
				var corner:Point = new Point(rect.left,rect.top);
				if(intersectsPoint(corner)) return true;
			}
			return false;
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new PolygonAreaTrail(this); }
		
		/**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		DisplayObject 		The object we're using to draw this area.
		 */
		 
		override public function drawOn(canvas:Sprite):void{
			if(canvas != null) {
				var brush:Graphics = canvas.graphics;
				var pt:Point;
				if(_points.length > 0) {
					pt = _points[0];
					brush.moveTo(pt.x,pt.y);
					brush.beginFill(0x000000,0.5);
					for(var i:int = 1; i < _points.length; i++) {
						pt = _points[i];
						brush.lineTo(pt.x,pt.y);
					}
					// close the polygon
					pt = _points[0];
					brush.lineTo(pt.x,pt.y);
					brush.endFill();
				}
			}
		}
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		override public function toString():String{
			return "["+_points.length+"-point polygon]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
