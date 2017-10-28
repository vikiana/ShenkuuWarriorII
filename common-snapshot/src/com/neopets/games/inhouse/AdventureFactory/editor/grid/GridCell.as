
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.BroadcasterClip;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	
	/**
	 *	This class simply adds game world linkages to grid cell movieclips
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  03.29.2010
	 */
	 
	public class GridCell extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const CELL_EVENT:String = "grid_cell_transmission";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var gridX:int;
		public var gridY:int;
		protected var _linkedImage:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GridCell():void{
			super();
			buttonMode = true;
			useParentDispatcher(MapGrid);
			// create listeners
			addEventListener(MouseEvent.ROLL_OVER,relayEvent);
			addEventListener(MouseEvent.MOUSE_UP,relayEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,relayEvent);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get linkedImage():DisplayObject { return _linkedImage; }
		
		public function set linkedImage(dobj:DisplayObject) {
			// remove listeners
			if(_linkedImage != null) {
				_linkedImage.removeEventListener(Event.REMOVED,onImageRemoved);
			}
			_linkedImage = dobj;
			// set up new listeners
			if(_linkedImage != null) {
				_linkedImage.addEventListener(Event.REMOVED,onImageRemoved);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Check if the other cell is linked either to our own linkImage or a another object that "sticks"
		// to our linkImage.
		
		public function linkMatches(other:GridCell):Boolean {
			if(other == null) return false;
			if(other.linkedImage == _linkedImage) return true;
			return false;
		}
		
		override public function toString():String {
			return "["+_linkedImage+":"+gridX+","+gridY+"]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function is triggered when our linked image is removed.
		
		public function onImageRemoved(ev:Event) {
			if(ev.target == _linkedImage) linkedImage = null;
		}
		
		// This function simply sends the target event on to the cell's shared dispatcher.
		
		public function relayEvent(ev:Event) {
			broadcast(CELL_EVENT,ev);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}