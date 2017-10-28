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
	import com.neopets.util.collision.geometry.trails.LineAreaTrail;
	
	/**
	 *	Line Areas cover a series of points linked by connected line segments.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.2.2009
	 */
	public class LineArea extends BoundedArea
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _points:Array;
		protected var _segments:Array;
		protected var _builtFrom:Array;
		protected var _coordSpace:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		list		Array		 		The display objects we're converting to points.
		 *  @param		cspace		DisplayObject 		The coordinate space we're using
		 */
		 
		public function LineArea(list:Array=null,cspace:DisplayObject=null):void{
			super();
			_points = new Array();
			_segments = new Array();
			if(list != null) buildFrom(list,cspace);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function returns the line's segment list.
		 */
		 
		public function get segments():Array { return _segments; }
		
		/**
		 * @This function rebuilds this line from a given point list.
		 */
		 
		public function set segments(list:Array) {
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
					// add closing point
					_points.push(seg.point2);
				}
				resetBounds();
			}
		}
		
		/**
		 * @This function returns the line's segment list.
		 */
		 
		public function get points():Array { return _points; }
		
		/**
		 * @This function rebuilds this line from a given point list.
		 */
		 
		public function set points(list:Array) {
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
				}
				resetBounds();
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
		 
		public function buildFrom(list:Array,cspace:DisplayObject=null):void{
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
						if(prev_pt != null) {
							// add a line segment
							seg = new LineSegment(pt,prev_pt);
							_segments.unshift(seg);
						}
						prev_pt = pt;
					} else list.splice(i,1);
				} // end of point loop
				resetBounds();
			}
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
				}
				resetBounds();
				// update segments
				for(i = 0; i < _segments.length; i++) {
					_segments[i].recalculate();
				}
			}
		}
		
		/**
		 * @This function tries to add a new point to the end of this line.
		 * @param		pt		Point 		Point to be added.
		 */
		 
		public function pushPoint(pt:Point):void{
			if(pt != null) {
				_points.push(pt);
				// update segments
				if(_points.length > 1) {
					var tail:Point = _points[_points.length - 2];
					var seg:LineSegment = new LineSegment(tail,pt);
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
			return other.intersectsLine(this,false);
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
			return other.intersectsLine(this,false);
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
			var s1:LineSegment;
			var s2:LineSegment;
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
		 * @This is a shape specific collision test between this area and a point.
		 * @param		pt		Point 		The position we're checking for intersection.
		 */
		 
		override public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			// do quick bounding test
			if(_bounds.contains(pt.x,pt.y)) {
				// check each segment
				for(var i:int = 0; i < _segments.length; i++) {
					if(_segments[i].intersectsPoint(pt)) return true;
				}
			}
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
			return other.intersectsLine(this,false);
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
			}
			return false;
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new LineAreaTrail(this); }
		
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
					for(var i:int = 1; i < _points.length; i++) {
						pt = _points[i];
						brush.lineTo(pt.x,pt.y);
					}
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
				// cycle through all remaining points
				for(var i:int = 1; i < _points.length; i++) {
					pt = _points[i];
					// stretch bounds as needed
					if(pt.x < _bounds.left) _bounds.left = pt.x;
					else {
						if(pt.x > _bounds.right) _bounds.right = pt.x;
					}
					if(pt.y < _bounds.top) _bounds.top = pt.y;
					else {
						if(pt.y > _bounds.bottom) _bounds.bottom = pt.y;
					}
				} // end of point loop
			}
			dispatchEvent(new Event(AREA_CHANGED));
			resetCenter();
		}
		
		/**
		 * @This function moves the area by the given values
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		dr		Number 		Change in rotation
		 */
		 
		override public function moveBy(dx:Number,dy:Number,dr:Number=0):void{
			var pt:Point;
			var i:int;
			// check if we have any linear movement and store the results
			var x_changed:Boolean = (dx != 0);
			var y_changed:Boolean = (dy != 0);
			// check if rotation is used
			if(dr != 0) {
				// move our center point
				if(x_changed) center.x += dx;
				if(y_changed) center.y += dy;
				// calculate trig values
				var radians:Number = dr * AreaTransformation.RADIANS_PER_DEGREE;
				var sine:Number = Math.sin(radians);
				var cosine:Number = Math.cos(radians);
				// transform our points
				var dx:Number;
				var dy:Number;
				for(i = 0; i < _points.length; i++) {
					pt = _points[i];
					// apply linear movement
					if(x_changed) pt.x += dx;
					if(y_changed) pt.y += dy;
					// apply rotation
					dx = pt.x - center.x;
					dy = pt.y - center.y;
					pt.x = center.x + dx * cosine - dy * sine;
					pt.y = center.y + dx * sine + dy * cosine;
				}
				// update the corresponding segments
				for(i = 0; i < _segments.length; i++) {
					_segments[i].recalculate();
				}
				// update bounds (also triggers area change event dispatch)
				resetBounds();
			} else {
				// check for linear movement
				if(x_changed || y_changed) {
					// transform our points
					for(i = 0; i < _points.length; i++) {
						pt = _points[i];
						// apply linear movement
						if(x_changed) pt.x += dx;
						if(y_changed) pt.y += dy;
					}
					// update the corresponding segments
					for(i = 0; i < _segments.length; i++) {
						_segments[i].pointsMovedBy(dx,dy);
					}
					// update bounds
					if(x_changed) {
						_bounds.x += dx;
						_center.x += dx;
					}
					if(y_changed) {
						_bounds.y += dy;
						_center.y += dy;
					}
					// let listeners know we changed
					dispatchEvent(new Event(AREA_CHANGED));
				}
			}
		}
		
		/**
		 * @This function removes all points and line segments from the area.
		 */
		 
		public function clearPoints():void{
			while(_points.length > 0) _points.pop();
			while(_segments.length > 0) _segments.pop();
			_bounds.x = 0;
			_bounds.y = 0;
			_bounds.width = 0;
			_bounds.height = 0;
			_center.x = 0;
			_center.y = 0;
			_builtFrom == null;
			prevState = null;
		}
		
		/**
		 * @This function store our current into out previous state object.
		 */
		 
		public function clonePoints():Array{
			var pts:Array = new Array();
			var pt:Point;
			for(var i:int = 0; i < _points.length; i++) {
				pt = _points[i];
				pts.push(pt.clone());
			}
			return pts;
		}
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		override public function toString():String{
			return "["+_segments.length+"-part line]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function extracts all children that whose names follow a prefix + number pattern, 
		 * @such as "p1,p2,p3..".
		 * @param		container	DisplayObjectContainer 		The object we're getting children from.
		 * @param		prefix		String				 		The common name of all children in the series.
		 * @param		index		int					 		The serial number of the first child.
		 */
		 
		public static function getChildSeries(container:DisplayObjectContainer,prefix:String,index:int=1):Array{
			var series:Array = new Array();
			if(container != null && prefix != null) {
				var child:DisplayObject = container[prefix + index];
				while(child != null) {
					series.push(child);
					index++;
					child = container[prefix + index];
				}
			}
			return series;
		}
		
	}
	
}
