
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid.tools
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import com.neopets.util.events.BroadcastEvent;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	
	/**
	 *	This tool adds item to the game world based on it's cursor image.
	 *  Note that image placement tools default to drag tool behaviour if the user
	 *  clicks on or drags an existing item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.15.2010
	 */
	 
	public class ItemPlacementTool extends ItemDragTool
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ItemPlacementTool():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to add our cursor item at our current position.
		
		public function placeItem():void {
			// check if we have a grid and something to add to it.
			if(_grid == null || _cursor == null) return;
			// check if there's an open spot where we want to place the item.
			if(_grid.validPlacement(this,x,y)) {
				var cursor_id:String = getQualifiedClassName(_cursor);
				_grid.addInstanceAt(cursor_id,x,y);
			}
		}
		
		// This function jumps to the target cell before trying to place the item.
		
		public function placeItemIn(cell:GridCell):void {
			if(cell == null) return; // check for valid cell
			// move to cell
			snapToCell(cell);
			// check if the cell is open
			if(cell.linkedImage == null) placeItem();
			// hide the brush since the cell should be filled now
			visible = false;
		}
		
		// Use this function to follow move our cursor over a new cell.
		
		override public function snapToCell(cell:GridCell):void {
			if(cell != null) {
				x = cell.x + _offset.x;
				y = cell.y + _offset.y;
				visible = (cell.linkedImage == null);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}