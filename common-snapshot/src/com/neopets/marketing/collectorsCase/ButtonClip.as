/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *	This class simply add button behaviour to a movieclip while maintaining the flexibility
	 *  and responsiveness of the movieclip class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  12.15.2009
	 */
	public dynamic class ButtonClip extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ButtonClip():void{
			addListeners();
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function addListeners():void {
			// set up mouse reactions
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownEvent);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUpEvent);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Mouse Event Handlers
		
		public function onMouseOver(ev:MouseEvent) {
			gotoAndStop("on");
		}
		
		public function onMouseOut(ev:MouseEvent) {
			gotoAndStop("off");
		}
		
		public function onMouseDownEvent(ev:MouseEvent) {
			gotoAndStop("down");
		}
		
		public function onMouseUpEvent(ev:MouseEvent) {
			gotoAndStop("on");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}