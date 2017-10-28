/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import com.neopets.util.display.IconLoader;
	
	/**
	 *	This class lays item slots out in a grid with a set number of columns and rows.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class ItemGrid extends MovieClip 
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
		protected var rows:Array;
		protected var numRows:int;
		protected var numColumns:int;
		protected var _boundingArea:DisplayObject;
		protected var _loadList:LoaderQueue;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		num_cols		int 		Number of columns in the grid
		 *  @param		num_rows		int 		Number of rows in the grid
		 *  @param		urls			String 		List of item icon urls
		 */
		public function ItemGrid(num_cols:int=0,num_rows:int=0,area:DisplayObject=null):void{
			rows = new Array();
			resizeGrid(num_cols,num_rows);
			_boundingArea = area;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get maxCells():int { return numRows * numColumns; }
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			_loadList = list;
			// update all cells
			var row:Array;
			var j:int;
			var cell:Object;
			for(var i:int = 0; i < rows.length; i++) {
				row = rows[i];
				for(j = 0; j < row.length; j++) {
					cell = row[j];
					if(cell != null) cell.loadList = _loadList;
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function loads a new logo.
		 */
		 
		public function clearCells():void {
			for(var i:int = 0; i < rows.length; i++) clearRow(i);
		}
		
		/**
		 * @This function loads a new logo.
		 * @param		index		int 		Number of the row to be cleared
		 */
		 
		public function clearRow(index:int):void {
			if(index < 0 || index >= rows.length) return;
			// get our row
			var row:Array = rows[index];
			// cycle through all cells
			var cell:DisplayObject;
			for(var i:int = 0; i < row.length; i++) {
				cell = row[i];
				if(cell != null) {
					removeChild(cell);
					row[i] = null;
				}
			}
		}
		
		/**
		 * @This function loads a new logo.
		 * @param		entries			Array 		List of items to be added
		 */
		 
		public function loadItems(entries:Array):void {
			if(entries == null) return;
			clearCells();
			// calculate spacing
			var grid_bounds:Rectangle;
			var h_spacing:Number;
			var v_spacing:Number;
			var init_x:Number;
			var cell_x:Number;
			var cell_y:Number;
			if(_boundingArea != null) {
				grid_bounds = _boundingArea.getBounds(_boundingArea.parent);
				// calculate horizontal spacing
				h_spacing = grid_bounds.width / numColumns;
				// calculate vertical spacing
				v_spacing = grid_bounds.height / numRows;
				// get starting positions
				init_x = grid_bounds.left;
				cell_y = grid_bounds.top;
			} else {
				h_spacing = -1;
				v_spacing = -1;
				init_x = 0;
				cell_y = 0;
			}
			// cycle through all entries
			var entry:Object;
			var cell:MovieClip;
			var cell_bounds:Rectangle;
			var gx:int = 0;
			var gy:int = 0;
			for(var i:int = 0; i < entries.length; i++) {
				entry = entries[i];
				// make sure there's space on the grid
				if(gy >= numRows) break;
				// create a new cell
				cell = new ItemSlotMC();
				cell.loadList = _loadList;
				addChild(cell);
				// check if our spacing values have been set
				if(h_spacing < 0) {
					cell_bounds = cell.getBounds(this);
					h_spacing = cell_bounds.width;
					v_spacing = cell_bounds.height;
				}
				// check cell coordinates
				if(gx <= 0) cell_x = init_x;
				else cell_x += h_spacing;
				// finish setting up the cell
				cell.x = cell_x;
				cell.y = cell_y;
				rows[gy][gx] = cell;
				cell.loadData(entry);
				// move to next cell
				gx++;
				if(gx >= numColumns) {
					gx -= numColumns;
					gy++;
					cell_y += v_spacing;
				}
			}
		}
		
		/**
		 * @This function loads a new logo.
		 * @param		num_cols		int 		Number of columns in the grid
		 * @param		num_rows		int 		Number of rows in the grid
		 */
		 
		public function resizeGrid(num_cols:int=0,num_rows:int=0):void {
			// check if there are too many rows
			if(rows.length > num_rows) {
				while(rows.length > num_rows) {
					clearRow(rows.length - 1);
					rows.pop();
				}
			} else {
				// check if we need more rows
				var row:Array;
				while(rows.length < num_rows) {
					row = new Array(num_cols);
					rows.push(row);
				}
			}
			// update values
			numRows = num_rows;
			numColumns = num_cols;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}