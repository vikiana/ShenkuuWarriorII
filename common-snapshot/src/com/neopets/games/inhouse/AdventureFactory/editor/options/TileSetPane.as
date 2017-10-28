
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.options
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.util.general.GeneralFunctions;
	
	/**
	 *	This class holds rows of tiles for use in the level editor.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  07.12.2010
	 */
	 
	public class TileSetPane extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _captionField:TextField;
		protected var _tileArea:DisplayObject;
		protected var _tiles:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TileSetPane():void{
			super();
			_tiles = new Array();
			// check for components
			_captionField = getChildByName("caption_txt") as TextField;
			_tileArea = getChildByName("tile_area_mc");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to place tiles into proper grid positions.
		
		public function alignTiles():void {
			// check for tiles
			if(_tiles == null || _tiles.length < 1) return;
			// calculate alignment values
			var tile:DisplayObject = _tiles[0];
			var left_edge:Number;
			var right_edge:Number;
			var tile_y:Number;
			if(_tileArea != null) {
				// calculate minimum width layout
				var max_rows:Number = Math.ceil(_tileArea.height / tile.height);
				var min_width:Number = tile.width * Math.ceil(_tiles.length / max_rows);
				// calculate layout bounds
				left_edge = _tileArea.x;
				right_edge = left_edge + Math.max(min_width,_tileArea.width);
				tile_y = _tileArea.y;
			} else {
				left_edge = 0;
				right_edge = tile.width * _tiles.length;
				tile_y = 0;
			}
			// place new tiles in ordered rows
			var tile_x:Number = left_edge;
			for(var i:int = 0; i < _tiles.length; i++) {
				tile = _tiles[i];
				// set tile at target position
				tile.x = tile_x;
				tile.y = tile_y;
				// set up next position
				tile_x += tile.width;
				if(tile_x > right_edge) {
					tile_x = left_edge;
					tile_y += tile.height;
				}
			}
		}
		
		// This function wipes all our tiles.
		
		public function clearTiles():void {
			var tile:DisplayObject;
			while(_tiles.length > 0) {
				tile = _tiles.pop();
				removeChild(tile);
			}
		}
		
		// Use this function to set up the button from a given data source.
		
		public function initFrom(info:Object) {
			if(info is XML) {
				translateCaption(info.@id);
				loadTiles(info.children());
			}
		}
		
		// This function tries to create tiles using the provided image list.
		
		public function loadTiles(list:Object):void {
			clearTiles();
			// load entry images into shells
			var shell:Object;
			var i:Object;
			for(i in list) {
				// create a new shell
				shell = GeneralFunctions.getInstanceOf("TileSlotMC");
				// make sure the shell is a valid display object
				if(shell != null && shell is DisplayObject) {
					// add shell to our contents
					_tiles.push(shell);
					addChild(shell as DisplayObject);
					// check if shell can be initialized
					if("initFrom" in shell) shell.initFrom(list[i]);
					// check if the shell uses a shared dispatcher
					if("sharedDispatcher" in shell) shell.sharedDispatcher = parent;
				} else return;
			}
			alignTiles();
		}
		
		// This function uses the translation system to set the pane's caption.
		
		public function translateCaption(id:String):void {
			if(_captionField == null) return;
			// get translated text with opening and closing tags
			var translator:TranslationManager = TranslationManager.instance;
			var translation:String = translator.getTranslationOf("IDS_TOOL_TAB_OPENNER");
			translation += translator.getTranslationOf(id) + "</p>";
			// push translation to textfield
			_captionField.htmlText = translation;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
