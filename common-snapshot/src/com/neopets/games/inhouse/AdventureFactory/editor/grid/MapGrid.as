
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.grid
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.GameScreenClip;
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.GridCell;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.CellCluster;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.tools.GridTool;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.tools.ItemDragTool;
	
	/**
	 *	This class applies a grid overlay to the game world
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.10.2010
	 */
	 
	public class MapGrid extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static var CHANGE_TOOL:String = "change_grid_tool";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		// cell properties
		protected var _cellWidth:Number;
		protected var _cellHeight:Number;
		protected var _grid:Array;
		protected var _columnLength:int;
		// game world linkage
		protected var _world:GameWorld;
		protected var _gridBounds:Rectangle;
		// dynamically added components
		protected var _currentTool:GridTool;
		protected var _toolMask:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function MapGrid():void{
			// initialize variables
			_cellWidth = 31;
			_cellHeight = 31;
			_grid = new Array();
			_columnLength = 0;
			_gridBounds = new Rectangle();
			super();
			// set up listeners
			addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			addParentListener(AdventureFactory_GameScreen,CHANGE_TOOL,onToolChange);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get cellHeight():Number { return _cellHeight; }
		
		public function set cellHeight(val:Number) {
			if(_cellHeight != val) {
				// apply change to columns
				var cy:Number;
				var col:Array;
				var cell:MovieClip;
				var j:int;
				for(var i:int = 0; i < _grid.length; i++) {
					col = _grid[i];
					cy = _gridBounds.top;
					for(j = 0; j < col.length; j++) {
						cell = col[j];
						cell.y = cy;
						cy += val;
					}
				}
				// store new value
				_cellHeight = val;
				_gridBounds.bottom = cy;
				initMask();
			}
		}
		
		public function get cellWidth():Number { return _cellWidth; }
		
		public function set cellWidth(val:Number) {
			if(_cellWidth != val) {
				// apply change to columns
				var cx:Number = _gridBounds.left;
				var col:Array;
				var cell:MovieClip;
				var j:int;
				for(var i:int = 0; i < _grid.length; i++) {
					col = _grid[i];
					for(j = 0; j < col.length; j++) {
						cell = col[j];
						cell.x = cx;
					}
					cx += val;
				}
				// store new value
				_cellWidth = val;
				_gridBounds.right = cx;
				initMask();
			}
		}
		
		public function get columnLength():int { return _columnLength; }
		
		public function get gridBounds():Rectangle { return _gridBounds; }
		
		public function get rowLength():int {
			if(_grid != null) return _grid.length;
			else return 0;
		}
		
		public function get world():GameWorld { return _world; }
		
		public function set world(gw:GameWorld) {
			if(_world != gw) {
				_world = gw;
				buildGrid(_world.getBounds(this));
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to try adding an image to the target area of the grid.
		
		public function addInstanceAt(class_name:String,px:Number,py:Number):void {
			// abort if anything we need is missing
			if(class_name == null || class_name.length <= 0) return;
			if(_world == null) return;
			// create the new instance
			var inst:DisplayObject = GeneralFunctions.getDisplayInstance(class_name);
			// tentatively add instance to world
			if(inst != null) {
				inst.x = px;
				inst.y = py;
				_world.addChild(inst);
				// validate placement
				if(validPlacement(inst,inst.x,inst.y)) {
					claimCellsFor(inst); // link cells to new instance
				} else {
					_world.removeChild(inst); // if placement is bad, undo addition
				}
			}
		}
		
		// Use this function to create a new grid over the given area.
		// param	rect		Rectangle		Target area for the new grid.
		
		public function buildGrid(rect:Rectangle=null):void {
			clearGrid();
			// check if an area has been defined
			if(rect != null) {
				// reposition our grid
				_gridBounds.x = rect.x
				_gridBounds.y = rect.y;
				// fill that area with clips
				var cx:Number;
				var cy:Number;
				var col:Array;
				var cell:MovieClip;
				for(cx = _gridBounds.left; cx < rect.right; cx += _cellWidth) {
					col = new Array();
					// fill column
					for(cy = _gridBounds.top; cy < rect.bottom; cy += _cellHeight) {
						cell = new GridCellMC();
						// move cell into position
						cell.x = cx;
						cell.y = cy;
						// store target position in grid array
						cell.gridX = _grid.length;
						cell.gridY = col.length;
						// add cell to grid
						col.push(cell);
						addChild(cell);
						// make sure cell dimensions are defined
						if(_cellHeight <= 0) {
							_cellHeight = cell.height;
							_cellWidth = cell.width;
						}
					} // end of column fill
					_grid.push(col);
				} // end of column looop
				// recalculate variables
				if(col != null) _columnLength = col.length;
				_gridBounds.right = cx;
				_gridBounds.bottom = cy;
				initMask();
			}
		}
		
		// This function links cells in the target's area to the target.
		
		public function claimCellsFor(dobj:DisplayObject):Array {
			if(dobj == null) return null; // abort if there's no object
			// get the target's area
			var img_bounds:Rectangle = dobj.getBounds(this);
			// find all cells within that target area
			var cells:Array = getCellsWithIn(img_bounds);
			// make sure no cells are already claimed
			var cell:Object;
			for(var i:int = 0; i < cells.length; i++) {
				cell = cells[i];
				if(cell.linkedImage != null) return null;
			}
			// claim all cells for the target
			for(i = 0; i < cells.length; i++) {
				cell = cells[i];
				cell.linkedImage = dobj;
			}
			return cells;
		}
		
		// This function removes all cell clips from the grid.
		
		public function clearGrid():void {
			var col:Array;
			var cell:GridCell;
			while(_grid.length > 0) {
				col = _grid.pop();
				if(col != null) {
					while(col.length > 0) {
						cell = col.pop();
						removeChild(cell);
					}
				} // end of column check
			} // end of column loop
			// reset variables
			_gridBounds.width = 0;
			_gridBounds.height = 0;
			_columnLength = 0;
			initMask();
		}
		
		// Use this function to get the cell at the target grid coordinates.
		
		public function getCell(gx:int,gy:int):GridCell {
			if(gx < 0 || gx >= _grid.length) return null;
			var col:Array = _grid[gx];
			if(gy < 0 || gy > col.length) return null;
			return col[gy] as GridCell;
		}
		
		// This function retrieves all cells that fall within the target area.
		
		public function getCellsWithIn(rect:Rectangle):Array {
			var cells:Array = new Array();
			// Find first column in rect
			var grid_rect:Rectangle = new Rectangle();
			grid_rect.left = Math.round((rect.left - _gridBounds.left) / _cellWidth);
			grid_rect.left = Math.min(Math.max(0,grid_rect.left),_grid.length); // constraint to array limits
			// Find last column in rect
			grid_rect.right = Math.round((rect.right - _gridBounds.left) / _cellWidth) - 1;
			grid_rect.right = Math.min(Math.max(0,grid_rect.right),_grid.length); // constraint to array limits
			// Find first row in rect
			grid_rect.top = Math.round((rect.top - _gridBounds.top) / _cellWidth);
			grid_rect.top = Math.min(Math.max(0,grid_rect.top),_columnLength); // constraint to array limits
			// Find last row in rect
			grid_rect.bottom = Math.round((rect.bottom - _gridBounds.top) / _cellWidth) - 1;
			grid_rect.bottom = Math.min(Math.max(0,grid_rect.bottom),_columnLength); // constraint to array limits
			// fill array with target cells
			var col:Array;
			var cell:Object;
			var i:int;
			var j:int;
			for(i = grid_rect.left; i <= grid_rect.right; i++) {
				col = _grid[i];
				for(j = grid_rect.top; j <= grid_rect.bottom; j++) {
					cell = col[j];
					cells.push(cell);
				}
			}
			return cells;
		}
		
		// Use this function to check for a grid tool of the appropriate type.
		
		public function hasTool(tool_class:Class,cursor_id:String=null):Boolean {
			if(_currentTool == null) return false;
			if(_currentTool is tool_class) {
				var cursor:DisplayObject = _currentTool.cursor;
				// if we have a cursor check of a class name match
				if(cursor != null) return (cursor_id == getQualifiedClassName(cursor));
				else return (cursor_id == null); // if not, this is only a match if no cursor is requested
			}
			return false;
		}
		
		// Use this function to match the toolCursor mask to our grid bounds.
		
		public function initMask():void {
			// create mask if not present
			if(_toolMask == null) {
				_toolMask = new MovieClip();
				_toolMask.graphics.beginFill(0);
				_toolMask.graphics.drawRect(0,0,100,100);
				addChild(_toolMask);
			}
			// resize mask to grid bounds
			if(_gridBounds != null) {
				_toolMask.x = _gridBounds.x;
				_toolMask.y = _gridBounds.y;
				_toolMask.width = _gridBounds.width;
				_toolMask.height = _gridBounds.height;
			}
			// apply mask to cursor if present
			if(_currentTool != null) {
				_toolMask.visible = true;
				_currentTool.mask = _toolMask;
			} else _toolMask.visible = false;
		}
		
		// Use this function to change the map's currently active tool.
		
		public function setTool(tool_class:Class,cursor_id:String=null):void {
			// check if we alreay have a tool that matches these parameters
			if(hasTool(tool_class,cursor_id)) return;
			// if not, clear the previous tool
			var prev_tool:GridTool;
			if(_currentTool != null) {
				prev_tool = _currentTool;
				removeChild(_currentTool);
			}
			// create the new tool
			_currentTool = new tool_class() as GridTool;
			if(_currentTool != null) {
				// initialize tool properties
				_currentTool.grid = this;
				_currentTool.setCursor(cursor_id);
				if(_toolMask != null) {
					_toolMask.visible = true;
					_currentTool.mask = _toolMask;
				}
				// move to previous tool
				if(prev_tool != null) {
					_currentTool.x = prev_tool.x;
					_currentTool.y = prev_tool.y;
					_currentTool.visible = prev_tool.visible;
				} else _currentTool.visible = false;
				// add tool to stage
				addChildAt(_currentTool,0);
			}
		}
		
		// This function switched the grid back to it's starting tool.
		
		public function useDefaultTool():void {
			setTool(ItemDragTool,"DragCursorMC");
		}
		
		// Use this function to see if a display object could be moved into the target location
		// without going out of bounds or overlapping cell contents.
		
		public function validPlacement(dobj:DisplayObject,tx:Number,ty:Number):Boolean {
			if(dobj == null) return false;
			// get object bounds
			var img_bounds:Rectangle = dobj.getBounds(this);
			// shift bounds to new position
			if(tx != dobj.x) img_bounds.x += tx - dobj.x;
			if(ty != dobj.y) img_bounds.y += ty - dobj.y;
			// check if area is too far out of bounds
			var half_width:Number = _cellWidth * 0.4;
			if(img_bounds.left <= _gridBounds.left - half_width) return false;
			if(img_bounds.right >= _gridBounds.right + half_width) return false;
			var half_height:Number = _cellHeight * 0.4;
			if(img_bounds.top <= _gridBounds.top - half_height) return false;
			if(img_bounds.bottom >= _gridBounds.bottom + half_height) return false;
			// check if any if the target cells are already claimed
			var cells:Array = getCellsWithIn(img_bounds);
			var cell:Object;
			for(var i:int = 0; i < cells.length; i++) {
				cell = cells[i];
				if(cell.linkedImage != null) return false;
			}
			// if all tests are passed, return true
			return true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function is triggered when the user rolls off the grid.
		
		protected function onRollOut(ev:MouseEvent) {
			if(_currentTool != null) _currentTool.visible = false;
		}
		
		// This function is triggered when the user rolls off the grid.
		
		protected function onRollOver(ev:MouseEvent) {
			if(_currentTool != null) _currentTool.visible = true;
		}
		
		// When a tool change request comes in, redirect it to our setTool function.
		
		protected function onToolChange(ev:BroadcastEvent) {
			var params:Array = ev.oData as Array;
			if(params != null && params.length > 0) {
				if(params.length > 1) setTool(params[0],params[1]);
				else setTool(params[0]);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to extract an the instance of a map cell within a mouse event.
		
		protected function getEventCell(ev:Event):GridCell {
			if(ev == null) return null;
			var targ:Object = ev.target;
			var disp:DisplayObject = targ as DisplayObject;
			if(disp != null) {
				if(disp is GridCell) return disp as GridCell;
				else return DisplayUtils.getAncestorInstance(disp,GridCell) as GridCell;
			}
			return null;
		}
		
	}
	
}