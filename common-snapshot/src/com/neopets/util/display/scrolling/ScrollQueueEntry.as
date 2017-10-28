/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 *	This class acts as a wrapper for the panels used by a ScrollQueue.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollQueueEntry
	{
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _displayObject:DisplayObject;
		protected var _innerBounds:Rectangle;
		protected var _outerBounds:Rectangle;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollQueueEntry(image:DisplayObject,area:Rectangle=null):void{
			_displayObject = image;
			if(_displayObject != null) _outerBounds = _displayObject.getBounds(_displayObject);
			else _outerBounds = new Rectangle();
			// set inner bounds
			if(area != null) _innerBounds = area;
			else _innerBounds = _outerBounds.clone();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get centerX():Number {
			return (_innerBounds.left + _innerBounds.right) / 2;
		}
		
		public function get centerY():Number {
			return (_innerBounds.top + _innerBounds.bottom) / 2;
		}
		
		public function get displayObject():DisplayObject{ return _displayObject; }
		
		public function get innerBounds():Rectangle{ return _innerBounds; }
		
		public function get outerBounds():Rectangle{ return _outerBounds; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function shifts all our coordinates by the given amount
		 * @param		dx		Number		X-axis adjustment.
		 * @param		dx		Number		Y-axis adjustment.
		 */
		
		public function moveBy(dx:Number,dy:Number) {
			if(_displayObject != null) {
				_displayObject.x += dx;
				_displayObject.y += dy;
			}
			_innerBounds.x += dx;
			_innerBounds.y += dy;
			_outerBounds.x += dx;
			_outerBounds.y += dy;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
