/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 *	ScrollGroups are simply containers for a collection of other scrolling objects.
	 *  It's main function is the ability to broadcast scrolling commands to multiple
	 *  scrolling objects with a single command.  It's commonly used to set up multi-layered
	 *  backgrounds with parallax scrolling.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollGrid extends ScrollingObject
	{
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var usesHorizontalWrap:Boolean;
		public var usesVerticalWrap:Boolean;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _contents:Array;
		protected var _cellHeight:Number;
		protected var _cellWidth:Number;
		protected var _numRows:uint;
		protected var _numColumns:uint;
		protected var wrapBounds:Rectangle;
		protected var nonContent:Array; // children that aren't in the content list
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollGrid():void{
			_contents = new Array();
			usesHorizontalWrap = true;
			usesVerticalWrap = true;
			super();
			clearGrid();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns the maxBound property.
		 */
		
		public function get contents():Array{ return _contents; }
		
		/**
		 * @Returns the cellHeight property.
		 */
		
		public function get cellHeight():Number{ return _cellHeight; }
		
		/**
		 * @Returns the cellWidth property.
		 */
		
		public function get cellWidth():Number{ return _cellWidth; }
		
		/**
		 * @This function return the art for an empty grid space.  This can be
		 * @be overriden by subclasses for a more visible blank tile.
		 */
		
		public function getBlankTile():DisplayObject{
			return new MovieClip();
		}
		
		/**
		 * @This function returns the display object at the target grid coordinates.
		 * @param		px		int 		X coordinate of target.
		 * @param		py		int 		Y coordinate of target.
		 */
		
		public function getTileAt(px:int,py:int):DisplayObject{
			var index:int = px + py * _numColumns;
			if(index >= 0 && index < _contents.length) return _contents[index];
			else return null;
		}
		
		/**
		 * @Returns the numRows property.
		 */
		
		public function get numRows():uint{ return _numRows; }
		
		/**
		 * @Returns the numColumns property.
		 */
		
		public function get numColumns():uint{ return _numColumns; }
		
		/**
		 * @This function returns the display object at the target grid coordinates.
		 * @param		px		int 		X coordinate of target.
		 * @param		py		int 		Y coordinate of target.
		 */
		
		public function replaceTileAt(px:int,py:int,image:DisplayObject):void{
			if(image != null) {
				var index:int = px + py * _numColumns;
				if(index >= 0 && index < _contents.length) {
					var tile:DisplayObject = _contents[index];
					image.x = tile.x;
					image.y = tile.y;
					addChildAt(image,getChildIndex(tile));
					_contents[index] = image;
					removeChild(tile);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to perform any remain shift operations like moving bounds and wrapping.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		override public function resolveShift(dx:Number,dy:Number):void{
			wrapBounds.x -= dx;
			wrapBounds.y -= dy;
			// apply wrapping to children
			var i:int;
			var j:int;
			var tile:DisplayObject;
			var wrap:Number;
			// apply horizontal wrapping
			if(usesHorizontalWrap) {
				for(i = 0; i < _numColumns; i++) {
					// find out if this column wraps
					tile = _contents[i];
					wrap = getWrapFor(tile.x,wrapBounds.left,wrapBounds.right);
					// apply the same wrapping to the entire column
					if(wrap != 0) {
						for(j = 0; j < _numRows; j++) {
							tile = getTileAt(i,j);
							if(tile != null) tile.x += wrap;
						}
					}
				}
			} // end of horizontal wrap
			// apply vertical wrapping
			if(usesVerticalWrap) {
				for(j = 0; j < _numRows; j++) {
					// find out if this row wraps
					tile = getTileAt(0,j);
					wrap = getWrapFor(tile.y,wrapBounds.top,wrapBounds.bottom);
					// apply the same wrapping to the entire row
					if(wrap != 0) {
						for(i = 0; i < _numColumns; i++) {
							tile = getTileAt(i,j);
							if(tile != null) tile.y += wrap;
						}
					}
				}
			} // end of vertical wrap
		}
		
		/**
		 * @This function sets up the loops panels.
		 * @param		xml		XML 		Guidelines for each panel set added.
		 */
		
		public function buildGrid(xml:XML):void{
			clearGrid();
			// load in the xml data
			if(xml != null) {
				// try building a row list
				var rows:XMLList = xml.row;
				if(rows.length() < 1) return; // no rows
				// find the longest row
				var max:Number = 0;
				var row:XML;
				var cells:XMLList;
				for(var i:int = 0; i < rows.length(); i++) {
					row = rows[i];
					cells = row.children();
					max = Math.max(max,cells.length());
				}
				if(max < 1) return; // no columns
				// set up the grid
				_numRows = rows.length();
				_numColumns = max;
				if("@cellHeight" in xml) _cellHeight = xml.@cellHeight;
				else _cellHeight = 32;
				if("@cellWidth" in xml) _cellWidth = xml.@cellWidth;
				else _cellWidth = 32;
				// cycle through all rows
				var j:int;
				var cell:XML;
				var image:DisplayObject;
				var entry:Object;
				for(i = 0; i < _numRows; i++) {
					row = rows[i];
					cells = row.children();
					// fill in all cells in this row
					for(j = 0; j < _numColumns; j++) {
						// get art for this tile
						if(j < cells.length()) {
							cell = cells[j];
							image = getInstanceOf(cell.localName()) as DisplayObject;
							if(image == null) image = getBlankTile();
						} else image = getBlankTile();
						// add the tile to our contents
						// move the tile to it's proper position
						if(image != null) {
							addChild(image);
							image.x = j * _cellWidth;
							image.y = i * _cellHeight;
							_contents.push(image);
						}
					}
				} // end of grid loop
				// set up bounds
				wrapBounds.x = 0;
				wrapBounds.width = _cellWidth * _numColumns;
				wrapBounds.y = 0;
				wrapBounds.height = _cellHeight * _numRows;
			}
		}
		
		/**
		 * @This removes all cells from the grid.
		 */
		
		public function clearGrid():void {
			var entry:Object;
			while(_contents.length > 0) {
				entry = _contents.pop();
				removeChild(entry.target);
			}
			// reset values
			_cellHeight = 0;
			_cellWidth = 0;
			_numRows = 0;
			_numColumns = 0;
			wrapBounds = new Rectangle();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
