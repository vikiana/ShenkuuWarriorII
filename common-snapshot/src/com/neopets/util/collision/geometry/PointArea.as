/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import com.neopets.util.collision.geometry.trails.AreaTrail;
	import com.neopets.util.collision.geometry.trails.PointAreaTrail;
	
	/**
	 *	Point Areas cover a single pin-point in a 2D plane.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class PointArea extends BoundedArea
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _builtAround:DisplayObject;
		protected var _coordSpace:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		image		DisplayObject 		The object we're basing this area on.
		 *  @param		cspace		DisplayObject 		The coordinate space we're using.
		 */
		public function PointArea(image:DisplayObject=null,cspace:DisplayObject=null):void{
			super();
			bounds.height = 1;
			bounds.width = 1;
			if(image != null) buildAround(image,cspace);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function returns the x coordinate of this point.
		 */
		 
		public function get x():Number { return _center.x; }
		
		/**
		 * @This function set the x coordinate of this point.
		 */
		 
		public function set x(val:Number) {
			_center.x = val;
			_bounds.x = val;
		}
		
		/**
		 * @This function returns the y coordinate of this point.
		 */
		 
		public function get y():Number { return _center.y; }
		
		/**
		 * @This function set the y coordinate of this point.
		 */
		 
		public function set y(val:Number) {
			_center.y = val;
			_bounds.y = val;
		}
		
		/**
		 * @This function set our center point
		 */
		
		public function set center(pt:Point) {
			x = pt.x;
			y = pt.y;
		}
		
		/**
		 * @This function returns the display object this point was built around.
		 */
		 
		public function get builtAround():DisplayObject { return _builtAround; }
		
		/**
		 * @This function returns the coordinate space used to build this point
		 */
		 
		public function get coordSpace():DisplayObject { return _coordSpace; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Intersection Functions
		
		/**
		 * @This is a shape specific collision test between this area and a chain.
		 * @param		other		ChainArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsChain(other:ChainArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return other.intersectsPoint(_center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a circle.
		 * @param		other		CircleArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsCircle(other:CircleArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return other.intersectsPoint(_center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a composite area.
		 * @param		other		CompositeArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsComposite(other:CompositeArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return other.intersectsPoint(_center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a line.
		 * @param		other		LineArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsLine(other:LineArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return other.intersectsPoint(_center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point.
		 * @param		pt		Point 		The position we're checking for intersection.
		 */
		 
		override public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			return _center.equals(pt);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point area.
		 * @param		other		PointArea 		The position we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsPointArea(other:PointArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return _center.equals(other.center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a polygon.
		 * @param		other		PolygonArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsPolygon(other:PolygonArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return other.intersectsPoint(_center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle.
		 * @param		rect		Rectangle 		The area we're checking for intersection.
		 */
		 
		override public function intersectsRectangle(rect:Rectangle):Boolean{
			if(rect == null) return false;
			return rect.containsPoint(_center);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle area.
		 * @param		other		RectangleArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 			Do validation and proximity tests?
		 */
		 
		override public function intersectsRectangleArea(other:RectangleArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
			}
			return other.bounds.containsPoint(_center);
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new PointAreaTrail(this); }
		
		/**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		DisplayObject 		The object we're using to draw this area.
		 */
		 
		override public function drawOn(canvas:Sprite):void{
			if(canvas != null) {
				var brush:Graphics = canvas.graphics;
				brush.drawCircle(_center.x,_center.y,1);
			}
		}
		
		/**
		 * @This function places the area at the center of the target display object.
		 * @param		image		DisplayObject 		The object we're basing this area on.
		 * @param		cspace		DisplayObject 		The coordinate space we're using
		 */
		 
		public function buildAround(image:DisplayObject,cspace:DisplayObject=null):void{
			if(image == null) return;
			if(cspace == null) cspace = image.stage;
			var bb:Rectangle = image.getBounds(cspace);
			x = (bb.left + bb.right) / 2;
			y = (bb.top + bb.bottom) / 2;
			_builtAround = image;
			_coordSpace = cspace;
			dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @Mimics "buildAround" with the values used last time that function was called.
		 */
		 
		override public function rebuild():void{
			if(_builtAround != null) {
				var bb:Rectangle = _builtAround.getBounds(_coordSpace);
				x = (bb.left + bb.right) / 2;
				y = (bb.top + bb.bottom) / 2;
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		override public function toString():String{
			return "[x:"+_center.x+",y:"+_center.y+"]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
