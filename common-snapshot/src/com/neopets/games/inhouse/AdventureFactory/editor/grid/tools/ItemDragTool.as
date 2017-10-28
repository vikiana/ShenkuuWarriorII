
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid.tools
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.events.BroadcastEvent;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.CellCluster;
	
	/**
	 *	This class sets the behaviour for the level editor's brush.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.15.2010
	 */
	 
	public class ItemDragTool extends GridTool
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _draggedCells:CellCluster = new CellCluster();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ItemDragTool():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function lets the tool respond to all events broadcast by map cells.
		
		override protected function onCellEvent(ev:BroadcastEvent) {
			var cell:GridCell = ev.sender as GridCell;
			var cell_event:Event = ev.oData as Event;
			switch(cell_event.type) {
				case MouseEvent.MOUSE_DOWN:
					// if the cell has content, try grabbing it and any connected cells.
					if(cell.linkedImage != null) {
						_draggedCells.initAt(_grid,cell.gridX,cell.gridY);
					}
					break;
				case MouseEvent.ROLL_OVER:
					snapToCell(cell);
					_draggedCells.dragTo(cell.gridX,cell.gridY);
					break;
				case MouseEvent.MOUSE_UP:
					_draggedCells.clear();
					break;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}