/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import com.neopets.util.collision.geometry.trails.AreaTrail;
	import com.neopets.util.collision.geometry.trails.RectangleAreaTrail;
	
	/**
	 *	Rectangle Areas cover axis aligned bounding boxes.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class RectangleArea extends BoundedArea
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _builtAround:DisplayObject;
		protected var _coordSpace:DisplayObject;
		protected var baseHeight:Number;
		protected var baseWidth:Number;
		protected var _radians:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		image		DisplayObject 		The object we're basing this area on.
		 *  @param		cspace		DisplayObject 		The coordinate space we're using.
		 */
		public function RectangleArea(image:DisplayObject=null,cspace:DisplayObject=null):void{
			super();
			if(image != null) buildAround(image,cspace);
			else {
				baseHeight = 0;
				baseWidth = 0;
				_radians = 0;
			}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
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
				if(!_bounds.intersects(other.bounds)) return false;
			}
			return other.intersectsRectangle(_bounds);
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
			return other.intersectsRectangle(_bounds);
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
			return other.intersectsRectangle(_bounds);
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
			return other.intersectsRectangle(_bounds);
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
			return other.intersectsRectangle(_bounds);
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function places the area at the center of the target display object.
		 * @param		image		DisplayObject 		The object we're basing this area on.
		 * @param		cspace		DisplayObject 		The coordinate space we're using
		 */
		 
		public function buildAround(image:DisplayObject,cspace:DisplayObject=null):void{
			if(image == null) return;
			if(cspace == null) cspace = image.stage;
			_bounds = image.getBounds(cspace);
			resetCenter();
			_builtAround = image;
			_coordSpace = cspace;
			// store rotation values
			baseHeight = _bounds.height;
			baseWidth = _bounds.width;
			_radians = 0;
			dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @Mimics "buildAround" with the values used last time that function was called.
		 */
		 
		override public function rebuild():void{
			if(_builtAround != null){
				_bounds = _builtAround.getBounds(_coordSpace);
				resetCenter();
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @This function moves the area by the given values
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		dr		Number 		Change in rotation
		 */
		 
		override public function moveBy(dx:Number,dy:Number,dr:Number=0):void{
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
			// approximate rotation of the bounded area while staying axis aligned
			if(dr != 0) {
				// get new angle
				_radians += dr * AreaTransformation.RADIANS_PER_DEGREE;
				var sine:Number = Math.abs(Math.sin(_radians));
				var cosine:Number = Math.abs(Math.cos(_radians));
				// calculate change in width
				var sum:Number = baseWidth * cosine + baseHeight * sine;
				_bounds.left += (_bounds.width - sum) / 2;
				_bounds.width = sum;
				// calculate change in height
				sum = baseWidth * sine + baseHeight * cosine;
				_bounds.top += (_bounds.height - sum) / 2;
				_bounds.height = sum;
				// record the change
				changed = true;
			}
			// let listeners know we changed
			if(changed) dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new RectangleAreaTrail(this); }
		
		/**
		 * @This function returns a string representation of this object.
		 */
		 
		override public function toString():String{
			return _bounds.toString();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
