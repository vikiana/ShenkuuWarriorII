/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
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
	public class LoadRequest extends EventDispatcher
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
		protected var _loader:Loader;
		protected var _request:URLRequest;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		num_cols		int 		Number of columns in the grid
		 *  @param		num_cols		int 		Number of columns in the grid
		 */
		public function LoadRequest(ldr:Loader,url:String):void{
			_loader = ldr;
			if(_loader != null) {
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
			}
			_request = new URLRequest(url);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get loader():Loader { return _loader; }
		
		public function get request():URLRequest { return _request; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function triggers our loader's load function.
		 */
		
		public function load():void {
			if(_loader != null) _loader.load(request);
			else dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function broadcasts when the loader has finished it's load operation.
		 */
		
		public function onLoadComplete(ev:Event) {
			if(_loader != null) {
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}