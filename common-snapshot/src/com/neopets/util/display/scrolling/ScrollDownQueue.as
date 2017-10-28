/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
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
	 *	@author David Cary - Mod by Clive Henrick
	 *	@since  7.28.2009
	 */
	 
	public class ScrollDownQueue extends ScrollQueue
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		public static const EVENT_PANEL_REMOVED:String = "ScrollQuePanelRemoved";
		public static const EVENT_PANEL_ADDED:String = "ScrollQuePanelAdded";
		public static const EVENT_COMPLETED_SCROLLING:String = "ScrollDownQueComplete";
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ScrollDownQueue():void{
			super();
			addEventListener(ScrollingObject.SCROLL_BOUND_HIT, checkScrollCompleted, false,0,true);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Clears all Panels out of Memory
		 */
		 
		public function clearAllPanels():void
		{
			var tCount:int =  _shownPanels.length-1;
			var entry:ScrollQueueEntry;
			
			for(var i:int = tCount; i >= 0; i--) {
				entry = _shownPanels[i];
				removeChild(entry.displayObject);
				dispatchEvent(new CustomEvent({panel:entry.displayObject},ScrollDownQueue.EVENT_PANEL_REMOVED));
			}	
		}

	/**
		 * @This function take any panels that have scrolled out of the view area of stage.
		 * @This function is normally overriden by direction specific subclasses.
		 */
		 
		override public function clearPassedPanels():void {
			var entry:ScrollQueueEntry;
			for(var i:int = _shownPanels.length-1; i >= 0; i--) {
				entry = _shownPanels[i];
				if(entry.outerBounds.bottom < _viewArea.top) {
					removeChild(entry.displayObject);
					dispatchEvent(new CustomEvent({panel:entry.displayObject},ScrollDownQueue.EVENT_PANEL_REMOVED));
				}
			}
		}
		
		/**
		 * @This function tries to move pending items into the view area.
		 */
		 
		override public function fillViewArea():void {
			// keep showing panels until we go off screen
			var entry:ScrollQueueEntry;
			if(_pendingPanels.length > 0) {
				while(_pendingPanels.length > 0) {
					entry = _pendingPanels[0];
					if(entry.outerBounds.top <= _viewArea.bottom) {
						_pendingPanels.shift();
						_shownPanels.push(entry);
						addChild(entry.displayObject);
						dispatchEvent(new CustomEvent({panel:entry.displayObject},ScrollDownQueue.EVENT_PANEL_ADDED));
					} else break;
				}
				// If we cleared all pending panels, let our listeners know.
				if(_pendingPanels.length <= 0) dispatchEvent(new Event(LAST_PANEL_SHOWN));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
/**
		 * @Note Checks to see if the panels are on the Last one and stopped moving
		 * @param			evt.oData.target			ScrollingQueue
		 * @param			evt.oData.edge			String							If it equals Bottom it is Done
		 */
		 
		protected function checkScrollCompleted(evt:CustomEvent):void
		{
			if (evt.oData.edge == "bottom")
			{
				dispatchEvent(new Event(ScrollDownQueue.EVENT_COMPLETED_SCROLLING));
				stopScrolling();
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function adds the new entry to end of the pending list.
		 * @param		entry		ScrollQueueEntry 		The entry to be added
		 */
		
		override protected function pushCheckedEntry(entry:ScrollQueueEntry):void{
			// check if there are any other entries to align with
			var tail:ScrollQueueEntry = lastEntry;
			var dx:Number;
			var dy:Number;
			if(tail != null) {
				dx = tail.centerX - entry.centerX;
				dy = tail.innerBounds.bottom - entry.innerBounds.top;
			} else {
				dx = (_viewArea.left + _viewArea.right) / 2 - entry.centerX;
				dy = _viewArea.top - entry.innerBounds.top;
			}
			// apply alignment
			entry.moveBy(dx,dy);
			// add the entry to our pending list
			_pendingPanels.push(entry);
		}
	}
	
}
