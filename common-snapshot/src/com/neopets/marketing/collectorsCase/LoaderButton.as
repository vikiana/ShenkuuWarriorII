/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
	public class LoaderButton extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var imageCentered:Boolean;
		public var loadList:LoaderQueue;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _loaderShell:MovieClip;
		protected var imageLoader:Loader;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LoaderButton():void{
			loaderShell = this["main_mc"];
			imageCentered = false;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set loaderShell(shell:MovieClip) {
			if(_loaderShell != shell) {
				// clear previous listeners
				if(_loaderShell != null) {
				}
				imageLoader = null;
				// set up new listeners
				_loaderShell = shell;
				if(_loaderShell != null) {
					_loaderShell.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					_loaderShell.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					_loaderShell.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownEvent);
					_loaderShell.addEventListener(MouseEvent.MOUSE_UP,onMouseUpEvent);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function loads a new logo.
		 * @param		info		Object 		Data to be loaded
		 */
		 
		public function loadImage(url:String):void {
			if(url == null) return;
			if(_loaderShell != null) {
				// clear previous loader
				if(imageLoader != null) {
					_loaderShell.removeChild(imageLoader);
					imageLoader = null;
				}
				// add a new loader
				imageLoader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
				_loaderShell.addChild(imageLoader);
				// load image
				var full_path:String = FlashVarManager.getURL("image_server",url);
				if(loadList != null) loadList.push(imageLoader,full_path);
				else imageLoader.load(new URLRequest(full_path));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function centers image assets after they're loaded.
		 */
		 
		public function onImageLoaded(ev:Event=null):void {
			if(imageCentered) {
				// get the image
				var info:LoaderInfo = ev.target as LoaderInfo;
				var image:DisplayObject = info.content;
				// center the image
				var bb:Rectangle = image.getBounds(image);
				image.x = (bb.left + bb.right) / -2;
				image.y = (bb.top + bb.bottom) / -2;
			}
		}
		
		// Mouse Event Handlers
		
		public function onMouseOver(ev:MouseEvent) {
			gotoAndStop("on");
		}
		
		public function onMouseOut(ev:MouseEvent) {
			gotoAndStop("off");
		}
		
		public function onMouseDownEvent(ev:MouseEvent) {
			gotoAndStop("down");
		}
		
		public function onMouseUpEvent(ev:MouseEvent) {
			gotoAndStop("on");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}