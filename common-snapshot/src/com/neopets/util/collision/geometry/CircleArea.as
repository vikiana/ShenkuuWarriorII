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
	import com.neopets.util.collision.geometry.trails.CircleAreaTrail;
	
	/**
	 *	Circle areas cover everything with a given radius of their center.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class CircleArea extends PointArea
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _radius:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		image		DisplayObject 		The object we're basing this area on.
		 *  @param		cspace		DisplayObject 		The coordinate space we're using.
		 */
		public function CircleArea(image:DisplayObject=null,cspace:DisplayObject=null):void{
			_radius = 0;
			super(image,cspace);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function set the x coordinate of this point.
		 */
		 
		override public function set x(val:Number) {
			_center.x = val;
			_bounds.left = val - _radius;
			_bounds.right = val + _radius;
		}
		
		/**
		 * @This function set the y coordinate of this point.
		 */
		 
		override public function set y(val:Number) {
			_center.y = val;
			_bounds.top = val - _radius;
			_bounds.bottom = val + _radius;
		}
		
		/**
		 * @This function returns the area's radius.
		 */
		 
		public function get radius():Number { return _radius; }
		
		/**
		 * @This function adjusts the area's radius.
		 */
		 
		 public function set radius(val:Number) {
			_radius = val;
			_bounds.top = _center.y - _radius;
			_bounds.bottom = _center.y + radius;
			_bounds.left = _center.x - _radius;
			_bounds.right = _center.x + _radius;
		}
		
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
				if(!boundsIntersect(other)) return false;
			}
			return other.intersectsCircle(this,false);
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
			var dist:Number = Point.distance(_center,other._center);
			return dist <= _radius + other._radius;
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
			return other.intersectsCircle(this,false);
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
			return other.intersectsCircle(this,false);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point.
		 * @param		pt		Point 		The position we're checking for intersection.
		 */
		 
		override public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			var dist:Number = Point.distance(_center,pt);
			return dist <= _radius;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a polygon.
		 * @param		other		PolygonArea 		The area we're checking for intersection.
		 * @param		full_test	Boolean	 		Do validation and proximity tests?
		 */
		 
		override public function intersectsPolygon(other:PolygonArea,full_test:Boolean=true):Boolean{
			if(full_test) {
				if(other == null) return false;
				if(!_bounds.intersects(other.bounds)) return false;
			}
			return other.intersectsCircle(this,false);
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle.
		 * @param		rect		Rectangle 		The area we're checking for intersection.
		 */
		 
		override public function intersectsRectangle(rect:Rectangle):Boolean{
			if(_bounds.intersects(rect)) {
				// check if the rectangle crosses our center x
				var corner:Point = new Point();
				if(_center.x < rect.left) corner.x = rect.left;
				else {
					if(_center.x > rect.right) corner.x = rect.right;
					else return true; // the areas must overlap
				}
				// check if the rectangle crosses our center x
				if(_center.y < rect.top) corner.y = rect.top;
				else {
					if(_center.y > rect.bottom) corner.y = rect.bottom;
					else return true; // the areas must overlap
				}
				// check if the closest corner is inside the circle
				return intersectsPoint(corner);
			}
			return false;
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new CircleAreaTrail(this); }
		
		/**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		DisplayObject 		The object we're using to draw this area.
		 */
		 
		override public function drawOn(canvas:Sprite):void{
			if(canvas != null) {
				var brush:Graphics = canvas.graphics;
				brush.drawCircle(_center.x,_center.y,_radius);
			}
		}
		
		/**
		 * @This function places this circle around target display object.
		 * @param		image		DisplayObject 		The object we're basing this area on.
		 * @param		cspace		DisplayObject 		The coordinate space we're using
		 */
		 
		override public function buildAround(image:DisplayObject,cspace:DisplayObject=null):void{
			if(image == null) return;
			if(cspace == null) cspace = image.stage;
			var bb:Rectangle = image.getBounds(cspace);
			_center.x = (bb.left + bb.right) / 2;
			_center.y = (bb.top + bb.bottom) / 2;
			radius = (bb.width + bb.height) / 4; // use half the average for the radius
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
				_center.x = (bb.left + bb.right) / 2;
				_center.y = (bb.top + bb.bottom) / 2;
				radius = (bb.width + bb.height) / 4; // use half the average for the radius
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		override public function toString():String{
			return "[x:"+_center.x+",y:"+_center.y+",r:"+_radius+"]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
