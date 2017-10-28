/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	ScrollQueues manages a series of panels that are shown in the order they're added(FIFO).
	 *  When the edge of the last panel shown passes the viewing area's edge the next panel is 
	 *  brought in and added to the view area.
	 *  ScrollQueues are built to support one-way scrolling.  When an on-screen panel leaves the 
	 *  view area it's taken off stage.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollQueue extends ScrollingObject
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const LAST_PANEL_SHOWN:String = "last_panel_shown";
		public static const SCROLLQUE_REMOVED_PANEL:String = "DisplayObjectRemoved";
		public static const SCROLLQUE_SHOWN_PANEL:String = "DisplayObjectAdded";
		
		public const DEFAULT_WIDTH:int = 650;
		public const DEFAULT_HEIGHT:int = 600;
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		public var useScrollBounds:Boolean;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _shownPanels:Array;
		protected var _pendingPanels:Array;
		protected var _viewArea:Rectangle;
		protected var _oneWay:Boolean;
		protected var _panelBounds:Rectangle;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollQueue():void{
			_shownPanels = new Array();
			_pendingPanels = new Array();
			viewArea = new Rectangle(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT); // set to default window size by default
			_oneWay = true;
			useScrollBounds = true;
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get oneWay():Boolean { return oneWay; }
		
		public function set oneWay(bool:Boolean) {
			_oneWay = bool;
			if(_oneWay) clearPassedPanels();
		}
		
		public function get lastEntry():ScrollQueueEntry {
			if(_pendingPanels.length > 0) return _pendingPanels[_pendingPanels.length-1];
			if(_shownPanels.length > 0) return _shownPanels[_shownPanels.length-1];
			return null;
		}
		
		public function get viewArea():Rectangle { return _viewArea; }
		
		public function set viewArea(area:Rectangle) {
			if(area != null) _viewArea = area;
			else _viewArea = new Rectangle();
			if(_oneWay) clearPassedPanels();
			fillViewArea();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Entry Handling Functions
		
		/**
		 * @This function searches our lists for the target panel.
		 * @param		panel			DisplayObject 		Panel use by the entry we're looking for.
		 */
		
		public function getEntry(panel:DisplayObject):ScrollQueueEntry{
			var entry:ScrollQueueEntry;
			for(var i:int = 0; i < _shownPanels.length; i++) {
				entry = _shownPanels[i];
				if(entry.displayObject == panel) return entry;
			}
			for(i = 0; i < _shownPanels.length; i++) {
				entry = _shownPanels[i];
				if(entry.displayObject == panel) return entry;
			}
			return null;
		}
		
		// Panel Handling Functions
		
		/**
		 * @This function take any panels that have scrolled out of the view area of stage.
		 * @This function is normally overriden by direction specific subclasses.
		 */
		 
		public function clearPassedPanels():void {
			var entry:ScrollQueueEntry;
			var bb:Rectangle;
			for(var i:int = _shownPanels.length-1; i >= 0; i--) {
				entry = _shownPanels[i];
				bb = entry.outerBounds;
				if(bb.bottom < _viewArea.top || bb.top > _viewArea.bottom ||
				   bb.right < _viewArea.left || bb.left > _viewArea.right) {
					removeChild(entry.displayObject);
				}
			}
		}
		
		/**
		 * @This function adds a panel to the loop.
		 * @param		panel		DisplayObject 		Target panel to be added.
		 * @param		area		Rectangle			Inner bounds of the new panel.
		 */
		
		public function pushPanel(panel:DisplayObject,area:Rectangle=null):void{
			if(panel == null) return;
			// make sure the panel isn't already in our list
			if(getEntry(panel) == null) {
				// create a new entry
				var entry:ScrollQueueEntry = new ScrollQueueEntry(panel,area);
				pushCheckedEntry(entry);
				// adjust our bounds
				if(_panelBounds == null) _panelBounds = entry.innerBounds.clone();
				else _panelBounds = _panelBounds.union(entry.innerBounds);
				// check if the panel should be added to the stage
				panel.addEventListener(Event.REMOVED_FROM_STAGE,onPanelRemoved);
				fillViewArea();
			}
		}
		
		// Update Functions
		
		/**
		 * @Use this function to perform any remain shift operations like moving bounds and wrapping.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		override public function resolveShift(dx:Number,dy:Number):void{
			_viewArea.x -= dx;
			_viewArea.y -= dy;
			if(_oneWay) clearPassedPanels();
			fillViewArea();
		}
		
		/**
		 * @This function tries to move pending items into the view area.
		 * @This function is normally overriden by direction specific subclasses.
		 */
		 
		public function fillViewArea():void {
			var entry:ScrollQueueEntry = _pendingPanels.shift();
			if(entry != null) {
				addChild(entry.displayObject);
				_shownPanels.push(entry);
				// update our panel bounds
				if(_shownPanels.length <= 1) {
					_panelBounds = entry.innerBounds.clone();
				} else _panelBounds = _panelBounds.union(entry.innerBounds);
				// If we cleared all pending panels, let our listeners know.
				if(_pendingPanels.length <= 0) dispatchEvent(new Event(LAST_PANEL_SHOWN));
				entry.displayObject.dispatchEvent(new Event(ScrollQueue.SCROLLQUE_SHOWN_PANEL));
			}
		}
		
		// Misc. Functions
		
		/**
		 * @This function adjusts a request shift by our scaling values.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		override public function calculateShift(dx:Number,dy:Number):Point{
			var pt:Point;
			// apply scroll ratio
			if(scrollRatio != 1) pt = new Point(dx * scrollRatio,dy * scrollRatio);
			else pt = new Point(dx,dy);
			// check if bounds are being used
			if(useScrollBounds && _panelBounds != null) {
				pt = new Point();
				var diff:Number;
				// apply horizontal scroll limits
				if(dx > 0) {
					// right scroll
					if(_panelBounds.width > _viewArea.width) {
						diff = _viewArea.left - _panelBounds.left;
					} else diff = _viewArea.right - _panelBounds.right;
					if(dx >= diff) {
						dispatchEvent(new CustomEvent({target:this,edge:"left"},SCROLL_BOUND_HIT));
						pt.x = diff;
					} else pt.x = dx;
				} else {
					if(dx < 0) {
						// left scroll
						if(_panelBounds.width > _viewArea.width) {
							diff = _viewArea.right - _panelBounds.right;
						} else diff = _viewArea.left - _panelBounds.left;
						if(dx <= diff) {
							dispatchEvent(new CustomEvent({target:this,edge:"right"},SCROLL_BOUND_HIT));
							pt.x = diff;
						} else pt.x = dx;
					}
				}
				// apply vertical scroll limits
				if(dy > 0) {
					// down scroll
					if(_panelBounds.height > _viewArea.height) {
						diff = _viewArea.top - _panelBounds.top;
					} else diff = _viewArea.bottom - _panelBounds.bottom;
					if(dy >= diff) {
						dispatchEvent(new CustomEvent({target:this,edge:"top"},SCROLL_BOUND_HIT));
						pt.y = diff;
					} else pt.y = dy;
				} else {
					if(dy < 0) {
						// up scroll
						if(_panelBounds.height > _viewArea.height) {
							diff = _viewArea.bottom - _panelBounds.bottom;
						} else diff = _viewArea.top - _panelBounds.top;
						if(dy <= diff) {
							dispatchEvent(new CustomEvent({target:this,edge:"bottom"},SCROLL_BOUND_HIT));
							pt.y = diff;
						} else pt.y = dy;
					}
				}
			} // end of scrolling constraint
			return pt;
		}
		
		/**
		 * @This function uses the target objects bounds to set the queue's view area.
		 * @param		dobj		DisplayObject 		Distance along the x-axis we want to move.
		 */
		
		public function useBoundsOf(dobj:DisplayObject):void {
			if(dobj.parent != null) viewArea = dobj.getBounds(dobj.parent);
			else viewArea = dobj.getBounds(dobj);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @When a panel is taken off stage, adjust our tracking values accordingly.
		 */
		
		public function onPanelRemoved(ev:Event) {
			var panel:DisplayObject = ev.target as DisplayObject;
			// make sure we've popped this entry off our shown list
			var entry:ScrollQueueEntry;
			for(var i:int = _shownPanels.length-1; i >= 0; i--) {
				entry = _shownPanels[i];
				if(entry.displayObject == panel) _shownPanels.splice(i,1);
			}
			// recalculate our bounds
			if(_shownPanels.length > 0) {
				entry = _shownPanels[0];
				_panelBounds = entry.innerBounds.clone();
				for(i = 1; i < _shownPanels.length; i++) {
					entry = _shownPanels[i];
					_panelBounds = _panelBounds.union(entry.innerBounds);
				}
				// add in our pending panels
				for(i = 0; i < _pendingPanels.length; i++) {
					entry = _pendingPanels[i];
					_panelBounds = _panelBounds.union(entry.innerBounds);
				}
			} else {
				if(_pendingPanels.length > 0) {
					entry = _pendingPanels[0];
					_panelBounds = entry.innerBounds.clone();
					// add the remaining panels
					for(i = 1; i < _pendingPanels.length; i++) {
						entry = _pendingPanels[i];
						_panelBounds = _panelBounds.union(entry.innerBounds);
					}
				} else _panelBounds = null;
			}
			// remove listeners
			panel.removeEventListener(Event.REMOVED_FROM_STAGE,onPanelRemoved);
			panel.dispatchEvent(new Event(ScrollQueue.SCROLLQUE_REMOVED_PANEL));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function adds the new entry to end of the pending list.
		 * @This push was placed in it's own protected function so subclasses can
		 * @properly set the position of new entries as they're added.
		 * @param		entry		ScrollQueueEntry 		The entry to be added
		 */
		
		protected function pushCheckedEntry(entry:ScrollQueueEntry):void{
			_pendingPanels.push(entry);
		}
	}
	
}
