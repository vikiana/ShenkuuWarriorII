
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
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.tools.ItemBrushTool;
	
	
	/**
	 *	This class handles one-shot item placement.  It's usually used for placing
	 *  unique items like the hero and level goal.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.15.2010
	 */
	 
	public class ItemStickerTool extends ItemBrushTool
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
		
		public function ItemStickerTool():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function jumps to the target cell and tries adding our item there.
		
		override public function placeItemIn(cell:GridCell):void {
			if(cell == null) return;
			snapToCell(cell);
			// check if the cell is blank
			if(cell.linkedImage == null) {
				placeItem();
				// If the stamp succeeded, revert the grid to it's default tool.
				if(cell.linkedImage != null) _grid.useDefaultTool();
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