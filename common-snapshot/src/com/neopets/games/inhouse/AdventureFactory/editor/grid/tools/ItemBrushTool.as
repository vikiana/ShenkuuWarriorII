
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid.tools
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.EventFunctions;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	
	/**
	 *	This tool should place items as long as the mouse is held down.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.15.2010
	 */
	 
	public class ItemBrushTool extends ItemPlacementTool
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _isDown:Boolean = false;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ItemBrushTool():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function set grid(map:MapGrid) {
			// transfer listeners
			EventFunctions.transferListener(_grid,map,GridCell.CELL_EVENT,onCellEvent);
			EventFunctions.transferListener(_grid,map,MouseEvent.ROLL_OUT,onGridRollOut);
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
		
		public function dragToCell(cell:GridCell):void {
			// check if we're dragging any cells along
			if(_draggedCells.cells.length > 0) {
				snapToCell(cell);
				_draggedCells.dragTo(cell.gridX,cell.gridY);
				visible = false; // don't reveal while dragging content
			} else {
				// if not, simply paint this cell with our content
				placeItemIn(cell);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function lets the tool respond to all events broadcast by map cells.
		
		override protected function onCellEvent(ev:BroadcastEvent) {
			var cell:GridCell = ev.sender as GridCell;
			var cell_event:Event = ev.oData as Event;
			switch(cell_event.type) {
				case MouseEvent.MOUSE_DOWN:
					_isDown = true;
					// if the cell has content, try grabbing it and any connected cells.
					if(cell.linkedImage != null) {
						_draggedCells.initAt(_grid,cell.gridX,cell.gridY);
					} else placeItemIn(cell);
					break;
				case MouseEvent.ROLL_OVER:
					if(_isDown) dragToCell(cell);
					else snapToCell(cell);
					break;
				case MouseEvent.MOUSE_UP:
					_isDown = false;
					_draggedCells.clear();
					break;
			}
		}
		
		// Lift the brush when the user leaves the drawing area.
		
		public function onGridRollOut(ev:Event) {
			_isDown = false;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}