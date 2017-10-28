/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.CompositeArea;
	import flash.events.Event;
	
	/**
	 *	This class tries to create a motion trail for given point area.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern AbstractClass
	 * 
	 *	@author David Cary
	 *	@since  10.02.2009
	 */
	public class CompositeAreaTrail extends AreaTrail
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _area:CompositeArea;
		protected var _children:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CompositeAreaTrail(shape:BoundedArea=null):void{
			_children = new Array();
			super(shape);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get area():BoundedArea { return _area; }
		
		override public function set area(shape:BoundedArea):void {
			// clear previous area
			if(_area != null) _area.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			// add new area
			if(shape != null && shape is CompositeArea) {
				_area = shape as CompositeArea;
				_trail = area;
				// add listener
				_area.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			} else _area = null;
			updateChildren();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function checks for changes in the area an creates a new trail from those changes.
		 */
		 
		override public function update():void {
			if(_area == null) return;
			updateChildren();
			// build the trail from our child list
			var comp:CompositeArea = new CompositeArea();
			for(var i:int = 0; i < _children.length; i++) {
				comp.addArea(_children[i].trail);
			}
			_trail = comp;
		}
		
		/**
		 * @This function makes sure our child trails match the area's children.
		 */
		 
		public function updateChildren():void {
			var child_trail:AreaTrail;
			var child_area:BoundedArea;
			// check if we have an area
			if(_area != null) {
				var i:int;
				var j:int;
				var list:Array = _area.children;
				var cta:BoundedArea;
				var no_match:Boolean;
				// make sure our child trails are in the composite area
				for(i = _children.length - 1; i >= 0; i--) {
					child_trail = _children[i];
					cta = child_trail.area;
					no_match = true;
					// cycle through composite area's children
					for(j = 0; j < list.length; i++) {
						child_area = list[i];
						if(child_area == cta) {
							no_match = false;
							break;
						}
					}
					// if we didn't find a match, remove the child trail
					if(no_match) {
						child_trail.area = null;
						_children.splice(i,1);
					}
				}
				// check if any new elements have been added to the target composite area
				for(i = 0; i < list.length; i++) {
					child_area = list[i];
					no_match = true;
					// cycle through our child trails
					for(j = 0; j < _children.length; j++) {
						child_trail = _children[j];
						cta = child_trail.area;
						if(child_area == cta) {
							no_match = false;
							break;
						}
					}
					// if we didn't find a match, add one now
					if(no_match) {
						child_trail = child_area.getTrail();
						_children.push(child_trail);
					}
				}
			} else {
				// clear all children
				while(_children.length > 0) {
					child_trail = _children.pop();
					child_trail.area = null;
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
