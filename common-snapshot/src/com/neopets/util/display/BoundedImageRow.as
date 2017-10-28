// This class spreads the target contents in a row over a given area.
// Author: David Cary
// Last Updated: March 2011

package com.neopets.util.display
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.neopets.util.display.DisplayUtils;
	
	public class BoundedImageRow extends MovieClip {
		// alignment constants
		public static const NO_ALIGN:int = 0;
		public static const CENTER_ALIGN:int = 1;
		public static const TOP_ALIGN:int = 2;
		public static const BOTTOM_ALIGN:int = 3;
		// protected variables
		protected var _bounds:Rectangle;
		protected var _boundingObject:DisplayObject;
		protected var _midY:Number;
		protected var _images:Array;
		protected var _verticalAlignment:int;
		
		public function BoundedImageRow() {
			_images = new Array();
			_verticalAlignment = NO_ALIGN;
			// set up default bounds
			if(numChildren > 0) boundingObject = getChildAt(0);
			else boundingObject = this;
		}
		
		// Accessor Functions
		
		public function get bounds():Rectangle { return _bounds; }
		
		public function set bounds(rect:Rectangle):void {
			_bounds = rect;
			if(_bounds != null) _midY = _bounds.top + _bounds.height / 2;
			updateImages();
		}
		
		public function get boundingObject():DisplayObject { return _boundingObject; }
		
		public function set boundingObject(obj:DisplayObject):void {
			if(_boundingObject != obj) {
				_boundingObject = obj;
				updateBounds();
			}
		}
		
		public function get verticalAlignment():int { return _verticalAlignment; }
		
		public function set verticalAlignment(val:int) {
			if(_verticalAlignment != val) {
				_verticalAlignment = val;
				updateImages();
			}
		}
		
		// Bounding object functions
		
		public function hideBounds():void {
			if(_boundingObject != null) _boundingObject.visible = false;
		}
		
		public function showBounds():void {
			if(_boundingObject != null) _boundingObject.visible = false;
		}
		
		// Image handling functions
		
		public function clearImages():void {
			var obj:DisplayObject;
			for(var i:int = _images.length - 1; i >= 0; i--) {
				obj = _images.pop();
				removeChild(obj);
			}
		}
		
		public function addImage(img:DisplayObject):void {
			if(img == null) return;
			// check if we already have the image
			if(_images.indexOf(img) >= 0) return;
			// add the image
			_images.push(img);
			addChild(img);
			updateImages();
		}
		
		public function updateBounds():void {
			if(_boundingObject != null) bounds = _boundingObject.getBounds(this);
		}
		
		public function updateImages():void {
			// calculate spacing
			var dist:Number = _bounds.width / (_images.length + 1);
			// cycle through all positions
			var px:Number = _bounds.left + dist;
			var obj:DisplayObject;
			var cp:Point;
			var bb:Rectangle;
			for(var i:int = 0; i < _images.length; i++) {
				obj = _images[i];
				cp = DisplayUtils.getCenter(obj,this);
				// do vertical align
				switch(_verticalAlignment) {
					case CENTER_ALIGN:
						obj.y += _midY - cp.y;
						break;
					case TOP_ALIGN:
						bb = obj.getBounds(this);
						obj.y += _bounds.top - bb.top;
						break;
					case BOTTOM_ALIGN:
						bb = obj.getBounds(this);
						obj.y += _bounds.bottom - bb.bottom;
						break;
					default:
						obj.y = _midY;
				}
				// apply horizontal spacing
				obj.x += px - cp.x;
				// set up next position
				px += dist;
			}
		}
		
	}
}