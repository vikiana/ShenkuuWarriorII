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
	 *	This class simply acts as a movie clip shell for loaded assets.
	 *  This lets the developer add placeholder content areas to library objects.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  12.15.2009
	 */
	public class LoaderPane extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var bounds:Rectangle;
		public var loadList:LoaderQueue;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _loader:Loader;
		protected var _centerContents:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LoaderPane():void{
			bounds = getBounds(this);
			_centerContents = true;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get centerContents():Boolean { return _centerContents; }
		
		public function set centerContents(bool:Boolean) {
			_centerContents = bool;
			alignContents();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to enforce our alignment.
		 */
		
		public function alignContents():void {
			// make sure we have something to load
			if(_loader != null) {
				var image:DisplayObject = _loader.content;
				if(_centerContents) {
					// center the loader
					_loader.x = (bounds.left + bounds.right) / 2;
					_loader.y = (bounds.top + bounds.bottom) / 2;
					// center the image
					if(image != null) {
						var bb:Rectangle = image.getBounds(image);
						image.x = (bb.left + bb.right) / -2;
						image.y = (bb.top + bb.bottom) / -2;
					}
				} else {
					// edge align the loader
					_loader.x = 0;
					_loader.y = 0;
					// edge align the image
					if(image != null) {
						image.x = 0;
						image.y = 0;
					}
				}
			}
		}
		
		/**
		 * @This function loads a new logo.
		 * @param		info		Object 		Data to be loaded
		 */
		 
		public function load(url:String):void {
			if(url == null) return;
			// clear previous loader
			if(_loader != null) {
				removeChild(_loader);
				_loader = null;
			}
			// add a new loader
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
			addChild(_loader);
			// load image
			var full_path:String = FlashVarManager.getURL("image_server",url);
			if(loadList != null) loadList.push(_loader,full_path);
			else _loader.load(new URLRequest(full_path));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function centers image assets after they're loaded.
		 */
		 
		public function onLoadComplete(ev:Event=null):void {
			alignContents();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}