/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	This class handles scrolling and wrapping for an unstructured collection of display objects.
	 *  Use this class if the object doesn't follow the guidelines of any other Scrolling Object classes.
	 *  This is usually the best class to use if the contents have been manually layed out and exported 
	 *  from the library.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollingClip extends ScrollingObject
	{
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var usesHorizontalWrap:Boolean;
		public var usesVerticalWrap:Boolean;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _contents:Array;
		protected var wrapBounds:Rectangle;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollingClip():void{
			_contents = new Array();
			usesHorizontalWrap = true;
			usesVerticalWrap = true;
			wrapBounds = getRect(this);
			super();
			// add our children to the contents list
			for(var i:int = 0; i < numChildren; i++) registerContent(getChildAt(i));
			addEventListener(Event.ADDED,onAdd);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns the maxBound property.
		 */
		
		public function get contents():Array{ return _contents; }
		
		/**
		 * @Returns the height of this clip's wrapping area.
		 */
		
		public function get wrapHeight():Number{ return wrapBounds.height; }
		
		/**
		 * @Use this function to adjust the height of the clip's wrapping area while keeping
		 * @that area centered.
		 * @param		val		Number 		The new target height.
		 */
		
		public function set wrapHeight(val:Number):void{
			wrapBounds.y += (wrapBounds.height - val) / 2;
			wrapBounds.height = val;
		}
		
		/**
		 * @Returns the width of this clip's wrapping area.
		 */
		
		public function get wrapWidth():Number{ return wrapBounds.width; }
		
		/**
		 * @Use this function to adjust the width of the clip's wrapping area while keeping
		 * @that area centered.
		 * @param		val		Number 		The new target width.
		 */
		
		public function set wrapWidth(val:Number):void{
			wrapBounds.x += (wrapBounds.width - val) / 2;
			wrapBounds.width = val;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to perform any remain shift operations like moving bounds and wrapping.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		override public function resolveShift(dx:Number,dy:Number):void{
			wrapBounds.x -= dx;
			wrapBounds.y -= dy;
			// cycle through all children
			var entry:Object;
			var bb:Rectangle;
			var wrap:Number;
			var ev:CustomEvent;
			for(var i:int = 0; i < _contents.length; i++) {
				entry = _contents[i];
				ev = null;
				// apply horizontal wrapping
				if(usesHorizontalWrap) {
					wrap = getWrapFor(entry.centerX,wrapBounds.left,wrapBounds.right);
					if(wrap != 0) {
						entry.target.x += wrap;
						ev = new CustomEvent({container:this,target:entry.target,wrap_x:wrap},ScrollingObject.ON_WRAP);
					}
				}
				// apply vertical wrapping
				if(usesVerticalWrap) {
					wrap = getWrapFor(entry.centerY,wrapBounds.top,wrapBounds.bottom);
					if(wrap != 0) {
						entry.target.y += wrap;
						if(ev == null) {
							ev = new CustomEvent({container:this,target:entry.target,wrap_y:wrap},ScrollingObject.ON_WRAP);
						} else ev.oData.wrap_y = wrap;
					}
				}
				if(ev != null) dispatchEvent(ev);
			} // end of child check cycle
		}
		
		/**
		 * @This function moves the clip's children by a set amount in the target direction.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		public function registerContent(obj:DisplayObject):void{
			// make sure the content isn't already listed
			var entry:Object;
			for(var i:int = 0; i < _contents.length; i++) {
				entry = _contents[i];
				if(entry.target == obj) return;
			}
			// add the new entry
			entry = new ScrolledItemData(obj);
			_contents.push(entry);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @When the scrolling object is added to the stage, register it with the ScrollManager.
		 */
		
		public function onAdd(ev:Event):void{
			if(ev.target is DisplayObject) {
				var disp:DisplayObject = ev.target as DisplayObject;
				if(disp.parent == this) {
					registerContent(disp);
					// check if the addition resized our bounds
					var bb:Rectangle = getRect(this);
					wrapBounds.left = Math.min(wrapBounds.left,bb.left);
					wrapBounds.right = Math.max(wrapBounds.right,bb.right);
					wrapBounds.top = Math.min(wrapBounds.top,bb.top);
					wrapBounds.bottom = Math.max(wrapBounds.bottom,bb.bottom);
				}
			}
		}
		
		/**
		 * @When the scrolling object is removed from the stage, take it out of the ScrollManager.
		 */
		
		override public function onRemovedFromStage(ev:Event):void{
			if(ev.target == this) {
				ScrollManager.removeEntry(this);
				removeEventListener(Event.ADDED,onAdd);
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
