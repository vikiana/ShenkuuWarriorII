
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid
{
	import flash.display.DisplayObject;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	
	/**
	 *	This class simply adds game world linkages to grid cell movieclips
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  09.07.2010
	 */
	 
	public class CellCluster extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _grid:MapGrid;
		protected var _cells:Array;
		protected var _images:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function CellCluster(map:MapGrid=null,gx:int=0,gy:int=0):void{
			super();
			initAt(map,gx,gy);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get grid():MapGrid { return _grid; }
		
		public function get cells():Array { return _cells; }
		
		public function get images():Array { return _images; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to clear our properties.
		
		public function clear():void {
			_grid = null;
			// clear cells list
			if(_cells != null) {
				while(_cells.length > 0) _cells.pop();
			} else _cells = new Array();
			// clear images list
			if(_images != null) {
				while(_images.length > 0) _images.pop();
			} else _images = new Array();
		}
		
		// Use this function to try dragging all cells in the cluster to a new location.
		
		public function dragTo(gx:int,gy:int):void {
			if(_grid == null || _cells == null || _cells.length < 1) return; // abort if no cells are being dragged
			// Calculate the change in position in grid units
			var cur_cell:GridCell = _cells[0];
			var dx:int = gx - cur_cell.gridX;
			var dy:int = gy - cur_cell.gridY;
			// abort if there's no change in position
			if(dx == 0 && dy == 0) return;
			// validate the new position for all cells
			var tx:int;
			var ty:int;
			var dest_cell:GridCell;
			var image:DisplayObject;
			var info:Object;
			var buffer:Array = new Array(); // used to store linkage changes
			for(var i:int = 0; i < _cells.length; i++) {
				cur_cell = _cells[i];
				// get the cell at our target location
				tx = cur_cell.gridX + dx;
				ty = cur_cell.gridY + dy;
				dest_cell = _grid.getCell(tx,ty);
				// check if a valid destination was found
				if(dest_cell != null) {
					// check if the destination cell is empty
					image = dest_cell.linkedImage;
					if(image != null) {
						// abort if the destination is full and is not a member of this cluster
						if(_cells.indexOf(dest_cell) < 0) return;
					}
				} else return; // if we went out of bounds the drag fails
				// store pending changes into buffer
				info = {data:cur_cell.linkedImage,destination:dest_cell};
				buffer.push(info);
			}
			// if we got this far, the drag is valid.
			// Clear current dragged cell linkages
			while(_cells.length > 0) {
				cur_cell = _cells.pop();
				cur_cell.linkedImage = null;
			}
			// use buffer to set new image linkages for cells
			while(buffer.length > 0) {
				info = buffer.shift();
				dest_cell = info.destination;
				dest_cell.linkedImage = info.data;
				// rebuild dragged cell list from buffer
				_cells.push(dest_cell);
			}
			// convert to pixel displacement
			dx = dx * _grid.cellWidth;
			dy = dy * _grid.cellHeight;
			// move the dragged images
			for(i = 0; i < _images.length; i++) {
				image = _images[i];
				image.x += dx;
				image.y += dy;
			}
		}
		
		// Use this to extract the target cells from a given map.
		
		public function initAt(map:MapGrid,gx:int,gy:int):void {
			clear();
			_grid = map; // store this map grid
			expandInto(gx,gy); // expand from our seed point
			resetImages(); // calculate our image list
		}
		
		// Use this function to make sure our image list is up to date.
		
		public function resetImages():void {
			// clear images list
			if(_images != null) {
				while(_images.length > 0) _images.pop();
			} else _images = new Array();
			// cycle through cell list
			var cell:GridCell;
			var image:DisplayObject;
			for(var i:int = 0; i < _cells.length; i++) {
				cell = _cells[i] as GridCell;
				if(cell != null) {
					// extract this cell's linked image
					image = cell.linkedImage;
					if(image != null) {
						if(_images.indexOf(image) < 0) _images.push(image);
					}
				} // end of cell check
			}
		}
		
		// This function simply converts this cluster to a string for trace statements.
		
		public function toString():String {
			return _cells.toString();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function is called recursively to populate the cluster from a target point.
		
		protected function expandInto(gx:int,gy:int):void {
			if(_grid == null) return; // do nothing if we have to grid to extract cells from
			// get the target cell
			var target_cell:GridCell = _grid.getCell(gx,gy);
			if(target_cell == null) return; // stop if we couldn't find a target cell
			// check the new cell against our current list
			if(_cells.length > 0) {
				if(_cells.indexOf(target_cell) >= 0) return; // stop if the target is already in our list
				// check if the target cell is compatible with our other cells
				var cur_cell:GridCell = _cells[0] as GridCell;
				if(cur_cell != null) {
					// if cell types don't match it can't be added to this cluster so exit out.
					if(!cur_cell.linkMatches(target_cell)) return;
				}
			}
			// If we got this far, the cell is a valid addition
			_cells.push(target_cell);
			// try to expand into neighboring cells
			expandInto(gx + 1,gy);
			expandInto(gx - 1,gy);
			expandInto(gx,gy + 1);
			expandInto(gx,gy - 1);
		}
		
	}
	
}