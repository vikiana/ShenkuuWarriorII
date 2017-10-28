
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 *	This class just lays out child clips in a horizontal line.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.26.2010
	 */
	 
	public class ImageRow extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _spacing:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ImageRow():void{
			super();
			_spacing = 0;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get spacing():Number { return _spacing; }
		
		public function set spacing(val:Number) {
			var shift:Number = val - _spacing;
			// apply change in spacing
			var child:DisplayObject;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				child.x += shift * (i + 1);
			}
			// store new spacing
			_spacing = val;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @AddChild is overriden to enforce horizontal placement.
		 */
		
		override public function addChild(obj:DisplayObject):DisplayObject {
			// check for valid image
			if(obj != null && obj.parent == null) {
				// add clip
				super.addChild(obj);
				// find clip bounds
				var bbox:Rectangle = obj.getBounds(this);
				// vertically center clip
				obj.y -= (bbox.top + bbox.bottom) / 2;
				// find right edge of last clip added
				var r_edge:Number;
				if(numChildren > 1) {
					var r_child:DisplayObject = getChildAt(numChildren - 2);
					var r_bounds:Rectangle = r_child.getBounds(this);
					r_edge = r_bounds.right + _spacing;
				} else r_edge = _spacing;
				// move left edge of new clip to right edge of previous clip
				obj.x += r_edge - bbox.left;
			}
			return obj;
		}
		
		/**
		 * @This function aligns the row with the center of the target's left edge.
		 */
		 
		public function alignWith(obj:DisplayObject):void {
			if(obj == null) return; // make sure there's something to align to.
			// get bounds of target
			var obj_bounds:Rectangle = obj.getBounds(obj);
			// get center left point of target
			var pt:Point = new Point();
			pt.x = obj_bounds.left;
			pt.y = (obj_bounds.top + obj_bounds.bottom) / 2;
			// convert to parent coordinates
			pt = obj.localToGlobal(pt);
			pt = parent.globalToLocal(pt);
			x = pt.x;
			y = pt.y;
		}
		
		/**
		 * @This function removes all children from this object.
		 */
		 
		public function clearChildren():void {
			for(var i:int = numChildren - 1; i >= 0; i--) {
				removeChildAt(i);
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
