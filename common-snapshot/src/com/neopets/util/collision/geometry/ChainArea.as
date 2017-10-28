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
	import com.neopets.util.collision.geometry.trails.ChainAreaTrail;
	
	/**
	 *	Chain areas cover multi-part lines where each segment can have
	 *  it's own width.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.11.2009
	 */
	public class ChainArea extends LineArea
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
		public function ChainArea(list:Array=null,cspace:DisplayObject=null):void{
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
					var seg:ThickSegment;
					for(var i:int = 0; i < _segments.length; i++) {
						seg = _segments[i];
						_points.push(seg.point1);
					}
					// add closing point
					_points.push(seg.point2);
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
					var seg:ThickSegment;
					// cycle through remaining points
					for(var i:int = 1; i < _points.length; i++) {
						pt = _points[i];
						// set up segment
						seg = new ThickSegment(prev_pt,pt);
						_segments.push(seg);
						prev_pt = pt;
					} // end of point loop
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
				var seg:ThickSegment;
				var bb:Rectangle;
				for(var i:int = list.length - 1; i >= 0; i--) {
					entry = list[i];
					if(entry is DisplayObject) {
						dobj = entry as DisplayObject;
						if(cspace == null) cspace = dobj.stage;
						bb = dobj.getBounds(cspace);
						pt = new Point((bb.left+bb.right)/2,(bb.top+bb.bottom)/2);
						_points.unshift(pt);
						if(prev_pt != null) {
							// add a segment
							seg = new ThickSegment(pt,prev_pt,(bb.height+bb.width)/2);
							_segments.unshift(seg);
						}
						prev_pt = pt;
					} else list.splice(i,1);
				} // end of point loop
				resetBounds();
				dispatchEvent(new Event(AREA_CHANGED));
			}
			// store values
			_builtFrom = list;
			_coordSpace = cspace;
		}
		
		/**
		 * @Mimics "buildFrom" with the values used last time that function was called.
		 */
		 
		override public function rebuild():void{
			if(_builtFrom != null) {
				var dobj:DisplayObject;
				var origin:Point = new Point();
				var coord:Point;
				var pt:Point;
				for(var i:int = 0; i < _builtFrom.length; i++) {
					dobj = _builtFrom[i];
					coord = dobj.localToGlobal(origin);
					if(_coordSpace != null) coord = _coordSpace.globalToLocal(coord);
					// update point
					pt = _points[i];
					pt.x = coord.x;
					pt.y = coord.y;
				} // end of point loop
				// update segments
				var seg:ThickSegment;
				var bb:Rectangle;
				for(i = 0; i < _segments.length; i++) {
					seg = _segments[i];
					seg.recalculate();
				}
				resetBounds();
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @This function tries to add a new point to the end of this line.
		 * @param		pt		Point 		Point to be added.
		 */
		 
		override public function pushPoint(pt:Point):void{
			if(pt != null) {
				_points.push(pt);
				// update segments
				if(_points.length > 1) {
					var tail:Point = _points[_points.length - 2];
					var seg:ThickSegment = new ThickSegment(tail,pt);
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
		
		/**
		 * @This function tries to add a new link point to the end of the chain.
		 * @param		px			Number 		X-coordinate of the link's end point.
		 * @param		py			Number 		Y-coordinate of the link's end point.
		 * @param		breadth		Number 		Thickness of the new segment.
		 */
		 
		public function pushCircle(px:Number,py:Number,radius:Number=0):void{
			var pt:Point = new Point(px,py);
			_points.push(pt);
			if(_points.length > 1) {
				var tail:Point = _points[_points.length - 2];
				var seg:ThickSegment = new ThickSegment(tail,pt,radius+radius);
				_segments.push(seg);
			}
			resetBounds();
			dispatchEvent(new Event(AREA_CHANGED));
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
			var s1:ThickSegment;
			var s2:ThickSegment;
			var j:int;
			for(var i:int = 0; i < other._segments.length; i++) {
				s1 = other._segments[i];
				for(j = 0; j < _segments.length; j++) {
					s2 = _segments[j];
					if(s1.intersectsSegment(s2)) return true;
				}
			} // end of segment loop
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
			var seg:ThickSegment;
			for(var i:int = 0; i < _segments.length; i++) {
				seg = _segments[i];
				if(seg.boundsIntersect(other)) {
					dist = seg.distanceToPoint(pt);
					if(dist <= r) return true;
				}
			}
			return false;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a composite area.
		 * @param		other		CompositeArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsComposite(other:CompositeArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			return other.intersectsChain(this,false);
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
			var ls:LineSegment;
			var ts:ThickSegment;
			var j:int;
			for(var i:int = 0; i < segs.length; i++) {
				ls = segs[i];
				for(j = 0; j < _segments.length; j++) {
					ts = _segments[j];
					if(ts.intersectsLine(ls)) return true;
				}
			} // end of segment loop
			return false;
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
			return other.intersectsChain(this,false);
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
				var seg:ThickSegment;
				for(i = 0; i < _segments.length; i++) {
					seg = _segments[i];
					if(seg.intersectsHorizontal(rect.top,rect.left,rect.right)) return true;
					if(seg.intersectsHorizontal(rect.bottom,rect.left,rect.right)) return true;
					if(seg.intersectsVertical(rect.left,rect.top,rect.bottom)) return true;
					if(seg.intersectsVertical(rect.right,rect.top,rect.bottom)) return true;
				}
			}
			return false;
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new ChainAreaTrail(this); }
		
		/**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		DisplayObject 		The object we're using to draw this area.
		 */
		 
		override public function drawOn(canvas:Sprite):void{
			if(canvas != null) {
				var brush:Graphics = canvas.graphics;
				var pt:Point;
				var seg:ThickSegment;
				if(_points.length > 0) {
					pt = _points[0];
					brush.moveTo(pt.x,pt.y);
					for(var i:int = 0; i < _segments.length; i++) {
						seg = _segments[i];
						brush.lineStyle(seg.thickness,0x000000,0.5);
						pt = seg.point2;
						brush.lineTo(pt.x,pt.y);
					}
					brush.lineStyle(1,0x000000,1); // try returning linestyle to normal
				}
			}
		}
		
		/**
		 * @Recalculates our boundaries if possible.
		 */
		 
		override public function resetBounds():void{
			if(_points.length > 0) {
				// start with first point
				var pt:Point = _points[0];
				_bounds.x = pt.x;
				_bounds.y = pt.y;
				_bounds.width = 0;
				_bounds.height = 0;
				// cycle through all segments
				var seg:ThickSegment;
				var bb:Rectangle;
				for(var i:int = 0; i < _segments.length; i++) {
					seg = _segments[i];
					bb = seg.bounds;
					// stretch bounds as needed
					if(bb.left < _bounds.left) _bounds.left = bb.left;
					if(bb.right > _bounds.right) _bounds.right = bb.right;
					if(bb.top < _bounds.top) _bounds.top = bb.top;
					if(bb.bottom > _bounds.bottom) _bounds.bottom = bb.bottom;
				} // end of point loop
			}
			resetCenter();
		}
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		override public function toString():String{
			return "["+_segments.length+"-part chain]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}