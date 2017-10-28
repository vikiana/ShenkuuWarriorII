
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.options
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.ImageTab;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.tools.ItemBrushTool;
	
	/**
	 *	This class candles tabs that change the map brush when clicked on.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  09.07.2010
	 */
	 
	public class BrushTab extends ImageTab
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
		
		public function BrushTab():void{
			super();
			selectionEvent = MapGrid.CHANGE_TOOL;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get selectionData():Object {
			return new Array(ItemBrushTool,_imageID);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
