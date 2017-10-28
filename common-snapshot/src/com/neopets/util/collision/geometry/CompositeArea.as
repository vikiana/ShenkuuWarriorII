/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import com.neopets.util.collision.geometry.trails.AreaTrail;
	import com.neopets.util.collision.geometry.trails.CompositeAreaTrail;
	
	/**
	 *	Composite Areas are connected sets of other types of areas.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class CompositeArea extends BoundedArea
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _children:Array;
		protected var listeningForChanges:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CompositeArea():void{
			listeningForChanges = true;
			super();
			_children = new Array();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get children():Array { return _children; }
		
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
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				if(child.intersectsChain(other)) return true;
			}
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
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				if(child.intersectsCircle(other)) return true;
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
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				if(child.intersectsComposite(other)) return true;
			}
			return false;
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
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				if(child.intersectsLine(other)) return true;
			}
			return false;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a point.
		 * @param		pt		Point 		The position we're checking for intersection.
		 */
		 
		override public function intersectsPoint(pt:Point):Boolean{
			if(pt == null) return false;
			if(_bounds.containsPoint(pt)) {
				// check children for intersections
				var child:BoundedArea;
				for(var i:int = 0; i < _children.length; i++) {
					child = _children[i];
					if(child.intersectsPoint(pt)) return true;
				}
			}
			return false;
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
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				if(child.intersectsPolygon(other)) return true;
			}
			return false;
		}
		
		/**
		 * @This is a shape specific collision test between this area and a rectangle.
		 * @param		rect		Rectangle 		The area we're checking for intersection.
		 */
		 
		override public function intersectsRectangle(rect:Rectangle):Boolean{
			if(_bounds.intersects(rect)) {
				// check children for intersection
				var child:BoundedArea;
				for(var i:int = 0; i < _children.length; i++) {
					child = _children[i];
					if(child.intersectsRectangle(rect)) return true;
				}
			}
			return false;
		}
		
		// Miscellaneous Functions
		
		/**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		DisplayObject 		The object we're using to draw this area.
		 */
		 
		override public function drawOn(canvas:Sprite):void{
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				child.drawOn(canvas);
			}
		}
		
		/**
		 * @This function moves the area by the given values.
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		angle	Number 		Target rotation
		 */
		 
		override public function moveBy(dx:Number,dy:Number,angle:Number=0):void{
			var changed:Boolean = false;
			if(angle == 0) {
				// if there's no rotation, use a quick update trick
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
			} else changed = true;
			// check if we changed
			if(changed) {
				// temporarily turn off listening so we don't get an area change event
				// for every child
				listeningForChanges = false;
				// move all children
				var child:BoundedArea;
				for(var i:int = 0; i < _children.length; i++) {
					child = _children[i];
					child.moveBy(dx,dy,angle);
				}
				// turn listening back on
				listeningForChanges = true;
				if(angle != 0) resetBounds();
				// let listeners know we changed
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @Repeats the area's building function with the last parameters used.
		 */
		 
		override public function rebuild():void{
			// temporarily turn off listening so we don't get an area change event
			// for every child on rebuild
			listeningForChanges = false;
			// cycle through all children
			var child:BoundedArea;
			var cbb:Rectangle;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				child.rebuild();
			} // end of child loop
			// turn listening back on
			listeningForChanges = true;
			resetBounds();
			dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @This function returns the sensor's linked display object.
		 */
		 
		public function addArea(area:BoundedArea):void {
			if(area == null) return;
			// check if the area is already in our child list
			var child:BoundedArea;
			for(var i:int = 0; i < _children.length; i++) {
				child = _children[i];
				if(child == area) return;
			}
			// if not, add it now.
			area.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			_children.push(area);
			// adjust bounds as needed
			var cbb:Rectangle = area.bounds;
			if(_children.length <= 1) {
				// if this is the only child, it sets our bounds
				_bounds.top = cbb.top;
				_bounds.bottom = cbb.bottom;
				_bounds.left = cbb.left;
				_bounds.right = cbb.right;
			} else {
				// otherwise, it may simply push them further out
				if(_bounds.top > cbb.top) _bounds.top = cbb.top;
				if(_bounds.bottom < cbb.bottom) _bounds.bottom = cbb.bottom;
				if(_bounds.left > cbb.left) _bounds.left = cbb.left;
				if(_bounds.right < cbb.right) _bounds.right = cbb.right;
			}
			resetCenter();
			dispatchEvent(new Event(AREA_CHANGED));
		}
		
		/**
		 * @This function removes the target area from this composite.
		 */
		 
		public function removeArea(area:BoundedArea):void {
			// check if the area is already in our child list
			var found:Boolean = false;
			for(var i:int = _children.length - 1; i >= 0; i--) {
				if(_children[i] == area) {
					area.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
					_children.splice(i,1);
					found = true;
				}
			}
			// update our boundaries if any areas where removed
			if(found) {
				resetBounds();
				dispatchEvent(new Event(AREA_CHANGED));
			}
		}
		
		/**
		 * @This function recalculates the composite's boundaries.
		 */
		 
		 override public function resetBounds():void{
			 if(_children.length > 0) {
				var child:BoundedArea = _children[0];
				var cbb:Rectangle = child.bounds;
				_bounds.top = cbb.top;
				_bounds.bottom = cbb.bottom;
				_bounds.left = cbb.left;
				_bounds.right = cbb.right
				for(var i:int = 1; i < _children.length; i++) {
					child = _children[i];
					cbb = child.bounds;
					if(_bounds.top > cbb.top) _bounds.top = cbb.top;
					if(_bounds.bottom < cbb.bottom) _bounds.bottom = cbb.bottom;
					if(_bounds.left > cbb.left) _bounds.left = cbb.left;
					if(_bounds.right < cbb.right) _bounds.right = cbb.right;
				}
				resetCenter();
			 } else {
				 _bounds.x = 0;
				 _bounds.y = 0;
				 _bounds.width = 0;
				 _bounds.height = 0;
				 _center.x = 0;
				 _center.y = 0;
			 }
		 }
		 
		/**
		 * @This function tries to create a new area trail which follows this area.
		 */
		 
		override public function getTrail():AreaTrail{ return new CompositeAreaTrail(this); }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is trigger when any child's area changes.
		 */
		 
		public function onAreaChanged(ev:Event):void {
			if(listeningForChanges) {
				resetBounds();
				dispatchEvent(new Event(BoundedArea.AREA_CHANGED));
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
