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
	
	/**
	 *	This class displays a single page of collector's case items.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class CollectionPage extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const GRID_COLUMNS:int =  3;
		public static const GRID_ROWS:int = 2;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _collectionData:Object;
		protected var _startIndex:int;
		protected var logoArea:DisplayObject;
		protected var logoLoader:Loader;
		protected var sidebarArea:DisplayObject;
		protected var sidebarLoader:Loader;
		protected var gridArea:DisplayObject;
		protected var grid:ItemGrid;
		protected var _loadList:LoaderQueue;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollectionPage():void{
			logoArea = this["logo_area_mc"];
			sidebarArea = this["side_area_mc"];
			// set up the grid
			gridArea = this["item_area_mc"];
			grid = new ItemGrid(GRID_COLUMNS,GRID_ROWS,gridArea);
			addChild(grid);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get collectionData():Object { return _collectionData; }
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			// set new loading list
			_loadList = list;
			// pass on this property to our components
			if(grid != null) grid.loadList = _loadList;
		}
		
		public function get maxItems():int {
			if(grid != null) return grid.maxCells;
			else return 0;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function loads a new logo.
		 * @param		info		Object 		Data to be loaded
		 * @param		index		int 		Where should we start reading the entries list?
		 */
		 
		public function setCollection(info:Object,index:int=0):void {
			if(info == null) return;
			// store values
			_collectionData = info;
			_startIndex = index;
		}
			
		/**
		 * @This function loads a new logo.
		 */
		 
		public function loadImages():void {
			// check the language
			var lang:String = FlashVarManager.getVar("language") as String;
			if(_collectionData != null) {
				if(lang == null || lang == 'en') loadLogo(_collectionData.logoURL+".png");
				else loadLogo(_collectionData.logoURL+"_"+lang+".png");
				// load remaining elements
				loadSidebar(_collectionData.sidebarURL);
				var list:Array = _collectionData.entries;
				grid.loadItems(list.slice(_startIndex));
			}
		}
		
		/**
		 * @This function loads a new logo.
		 * @param		url			String 		URL to be loaded
		 */
		 
		public function loadLogo(url:String):void {
			if(url == null) return;
			// clear the previous logo
			if(logoLoader != null) {
				removeChild(logoLoader);
			}
			// set up the loader
			logoLoader = new Loader();
			logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
			// move loader to center of area
			if(logoArea != null) {
				var bb:Rectangle = logoArea.getBounds(this);
				logoLoader.x = (bb.left + bb.right) / 2;
				logoLoader.y = (bb.top + bb.bottom) / 2;
			}
			addChild(logoLoader);
			// load image 
			var full_path:String = FlashVarManager.getURL("image_server",url);
			if(_loadList != null) _loadList.push(logoLoader,full_path);
			else logoLoader.load(new URLRequest(full_path));
		}
		
		/**
		 * @This function loads our sidebar art
		 * @param		url			String 		URL to be loaded
		 */
		 
		public function loadSidebar(url:String):void {
			if(url == null) return;
			// clear the previous logo
			if(sidebarLoader != null) {
				removeChild(sidebarLoader);
			}
			// set up the loader
			sidebarLoader = new Loader();
			sidebarLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
			// move loader to center of area
			if(sidebarArea != null) {
				var bb:Rectangle = sidebarArea.getBounds(this);
				sidebarLoader.x = (bb.left + bb.right) / 2;
				sidebarLoader.y = (bb.top + bb.bottom) / 2;
			}
			addChild(sidebarLoader);
			// load image 
			var full_path:String = FlashVarManager.getURL("image_server",url);
			if(_loadList != null) _loadList.push(sidebarLoader,full_path);
			else sidebarLoader.load(new URLRequest(full_path));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Center the logo and start loading the sidebar.
		 */
		 
		public function onImageLoaded(ev:Event=null):void {
			// center the image
			var info:LoaderInfo = ev.target as LoaderInfo;
			var image:DisplayObject = info.content;
			var bb:Rectangle = image.getBounds(image);
			image.x = (bb.left + bb.right) / -2;
			image.y = (bb.top + bb.bottom) / -2;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}