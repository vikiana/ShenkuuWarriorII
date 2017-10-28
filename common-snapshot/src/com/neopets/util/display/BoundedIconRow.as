// This class uses IconLoaders to create a horizontal row of same-sized images.
// These images are externally loaded and their positions are evenly spread between
// the left and right bounds of the row.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.display
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class BoundedIconRow extends MovieClip {
		protected var _bounds:Rectangle;
		protected var boundingObj:DisplayObject;
		protected var midY:Number;
		protected var icons:Array;
		
		public function BoundedIconRow() {
			icons = new Array();
			if(numChildren > 0) setBoundingObj(getChildAt(0));
			else setBoundingObj(this);
		}
		
		// Accessor Functions
		
		public function get bounds():Rectangle { return _bounds; }
		
		public function set bounds(rect:Rectangle):void {
			_bounds = rect;
			update();
		}
		
		public function setBoundingObj(obj:DisplayObject):void {
			if(obj != null) {
				if(boundingObj != obj) {
					_bounds = obj.getBounds(this);
					midY = _bounds.top + (_bounds.height/2);
					// avoid self references
					if(obj != this) boundingObj = obj;
					else boundingObj = null;
				}
				update();
			}
		}
		
		// Bounding object functions
		
		public function hideBounds():void {
			if(boundingObj != null) boundingObj.visible = false;
		}
		
		public function showBounds():void {
			if(boundingObj != null) boundingObj.visible = false;
		}
		
		// Icon handling functions
		
		public function clearIcons():void {
			var obj:DisplayObject;
			for(var i:int = icons.length - 1; i >= 0; i--) {
				obj = icons.pop();
				removeChild(obj);
			}
		}
		
		public function loadIconFrom(path:String,backing:DisplayObject=null):void {
			var ic:IconLoader = new IconLoader();
			ic.iconHeight = _bounds.height;
			ic.iconWidth = _bounds.height;
			if(backing != null) ic.addChild(backing);
			ic.loadFrom(path);
			addChild(ic);
			icons.push(ic);
			update();
		}
		
		public function update():void {
			var dist:Number = _bounds.width / (icons.length + 1);
			var px:Number = _bounds.left + dist;
			var obj:DisplayObject;
			for(var i:int = 0; i < icons.length; i++) {
				obj = icons[i];
				obj.x = px;
				obj.y = midY;
				px += dist;
			}
		}
	}
}