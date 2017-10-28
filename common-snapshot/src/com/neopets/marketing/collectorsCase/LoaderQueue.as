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
	public class LoaderQueue extends EventDispatcher
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
		protected var _queue:Array;
		protected var _loading:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LoaderQueue():void{
			_queue = new Array();
			_loading = false;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function loads a new logo.
		 * @param		index		int 		Number of the row to be cleared
		 */
		 
		public function push(ldr:Loader,url:String):void {
			if(ldr != null) {
				var req:LoadRequest = new LoadRequest(ldr,url);
				req.addEventListener(Event.COMPLETE,onLoadComplete);
				_queue.push(req);
			}
		}
		
		/**
		 * @This function loads a new logo.
		 */
		 
		public function startLoading():void {
			// don't try loading if a load is already in progress
			if(_loading) return;
			// check if we've got anything to load
			if(_queue.length > 0) {
				_loading = true;
				var req:LoadRequest = _queue.shift();
				req.load();
			} else dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function broadcasts when the loader has finished it's load operation.
		 */
		
		public function onLoadComplete(ev:Event) {
			if(_queue.length > 0) {
				var req:LoadRequest = _queue.shift();
				req.load();
			} else {
				_loading = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}