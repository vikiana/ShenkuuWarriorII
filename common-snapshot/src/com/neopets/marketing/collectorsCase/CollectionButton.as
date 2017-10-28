/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *	This class simply add button behaviour to a movieclip while maintaining the flexibility
	 *  and responsiveness of the movieclip class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  12.15.2009
	 */
	public dynamic class CollectionButton extends ButtonClip
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
		protected var _baseClip:MovieClip;
		protected var _overClip:MovieClip;
		protected var _collectionData:Object;
		protected var _loadList:LoaderQueue;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollectionButton():void{
			baseClip = this["off_mc"];
			overClip = this["on_mc"];
			addListeners();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get baseClip():MovieClip { return _baseClip; }
		
		public function set baseClip(clip:MovieClip) {
			_baseClip = clip;
			if(_baseClip != null) _baseClip.loadList = _loadList;
		}
		
		public function get overClip():MovieClip { return _overClip; }
		
		public function set overClip(clip:MovieClip) {
			_overClip = clip;
			if(_overClip != null) _overClip.loadList = _loadList;
		}
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			_loadList = list;
			if(_baseClip != null) _baseClip.loadList = _loadList;
			if(_overClip != null) _overClip.loadList = _loadList;
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
			// get our starting path
			var path:String = info.tabURL;
			// check the language
			var lang:String = FlashVarManager.getVar("language") as String;
			if(lang == null || lang == 'en') {
				if(_baseClip != null) _baseClip.load(path+".png");
				if(_overClip != null) _overClip.load(path+"_ov.png");
			} else {
				if(_baseClip != null) _baseClip.load(path+"_"+lang+".png");
				if(_overClip != null) _overClip.load(path+"_ov_"+lang+".png");
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