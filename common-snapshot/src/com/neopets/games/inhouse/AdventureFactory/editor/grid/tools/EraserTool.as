
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid.tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.EventFunctions;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.HeroClip;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.GoalClip;
	
	/**
	 *	This tool erases items while the mouse is held down.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.15.2010
	 */
	 
	public class EraserTool extends GridTool
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
		
		public function EraserTool():void{
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
		
		// This function jumps to the target cell before trying to place the item.
		
		public function clearCell(cell:GridCell):void {
			if(cell == null) return; // check for valid cell
			// move to cell
			snapToCell(cell);
			// check if there's anything in the cell to erase
			var image:DisplayObject = cell.linkedImage;
			if(image != null) {
				// cancel if the target isn't the right type
				if(image is HeroClip) return;
				if(image is GoalClip) return;
				// remove the erased item from the stage
				var img_parent:DisplayObjectContainer = image.parent;
				if(img_parent != null) img_parent.removeChild(image);
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
					clearCell(cell);
					break;
				case MouseEvent.ROLL_OVER:
					if(_isDown) clearCell(cell);
					else snapToCell(cell);
					break;
				case MouseEvent.MOUSE_UP:
					_isDown = false;
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