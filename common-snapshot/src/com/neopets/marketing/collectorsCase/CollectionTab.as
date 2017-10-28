/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	
	/**
	 *	This class displays the info for a single collector's case item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class CollectionTab extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _collectionData:Object;
		protected var _tabButton:MovieClip;
		protected var _loadList:LoaderQueue;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollectionTab():void{
			tabButton = this["btn_mc"];
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get collectionData():Object { return _collectionData; }
		
		public function set highlight(bool:Boolean) {
			if(bool) gotoAndStop("highlight");
			else gotoAndStop("normal");
		}
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			_loadList = list;
			if(_tabButton != null) _tabButton.loadList = _loadList;
		}
		
		public function set tabButton(btn:MovieClip) {
			// set up new button
			_tabButton = btn;
			if(_tabButton != null) _tabButton.loadList = _loadList;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function loads a new logo.
		 * @param		info		Object 		Data to be loaded
		 */
		 
		public function loadCollection(info:Object):void {
			if(info == null) return;
			// store values
			_collectionData = info;
			// load assets
			if(_tabButton != null) _tabButton.loadCollection(info);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}