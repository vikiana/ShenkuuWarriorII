/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 *	ScrollGroups are simply containers for a collection of other scrolling objects.
	 *  It's main function is the ability to broadcast scrolling commands to multiple
	 *  scrolling objects with a single command.  It's commonly used to set up multi-layered
	 *  backgrounds with parallax scrolling.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollGroup extends ScrollingObject
	{
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollGroup():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function passes on the scrollBy call to all child Scrolling Clips.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		override public function shiftBy(dx:Number,dy:Number):void{
			var shift:Point = calculateShift(dx,dy);
			if(shift.x != 0 || shift.y != 0) {
				// shift contents
				var child:DisplayObject;
				var scroller:ScrollingObject;
				for(var i:int = 0; i < numChildren; i++) {
					child = getChildAt(i);
					if(child is ScrollingObject) {
						scroller = child as ScrollingObject;
						scroller.shiftBy(shift.x,shift.y);
					}
				}
			} else dispatchEvent(new Event(SHIFT_BY_ZERO));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
