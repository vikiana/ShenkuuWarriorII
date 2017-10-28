
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid.tools
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import com.neopets.util.events.EventFunctions;
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	
	/**
	 *	This class handles level editing tools.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.15.2010
	 */
	 
	public class GridTool extends Sprite
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _grid:MapGrid;
		protected var _cursor:DisplayObject;
		protected var _offset:Point = new Point();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GridTool():void{
			addEventListener(Event.REMOVED,onRemoval);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get cursor():DisplayObject { return _cursor; }
		
		public function get grid():MapGrid { return _grid; }
		
		public function set grid(map:MapGrid) {
			// transfer listeners
			EventFunctions.transferListener(_grid,map,GridCell.CELL_EVENT,onCellEvent);
			// store new grid
			_grid = map;
			// adjust offsets to center of cell
			if(_grid != null) {
				_offset.x = _grid.cellWidth / 2;
				_offset.y = _grid.cellHeight / 2;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to set the cursor image's class.
		
		public function setCursor(class_id:String):void {
			// clear previous cursor
			if(_cursor != null) removeChild(_cursor);
			// create new cursor
			_cursor = GeneralFunctions.getDisplayInstance(class_id);
			if(_cursor != null) addChild(_cursor);
		}
		
		// Use this function to follow move our cursor over a new cell.
		
		public function snapToCell(cell:GridCell):void {
			if(cell != null) {
				x = cell.x + _offset.x;
				y = cell.y + _offset.y;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function lets the tool respond to all events broadcast by map cells.
		// This should be overriden by all grid tool sub-classes.
		
		protected function onCellEvent(ev:BroadcastEvent) {
			var cell:GridCell = ev.sender as GridCell;
			snapToCell(cell);
		}
		
		// When this object is removed, clear it's properties.
		
		protected function onRemoval(ev:Event) {
			grid = null;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}