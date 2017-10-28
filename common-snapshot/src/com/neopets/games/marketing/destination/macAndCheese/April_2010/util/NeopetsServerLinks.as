/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.util
{
	import flash.display.DisplayObject;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.marketing.collectorsCase.DebugTracer;
	
	/**
	 *	This class extracts the script server and image server from a display object's root url.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  3.24.2010
	 */
	public class NeopetsServerLinks extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const DEV_SCRIPT_SERVER:String = "http://dev.neopets.com";
		public static const DEV_IMAGE_SERVER:String = "http://images50.neopets.com";
		public static const LIVE_SCRIPT_SERVER:String = "http://www.neopets.com";
		public static const LIVE_IMAGE_SERVER:String = "http://images.neopets.com";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _isOnline:Boolean;
		protected var _imageServer:String;
		protected var _scriptServer:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NeopetsServerLinks(dobj:DisplayObject=null):void{
			super();
			initFrom(dobj);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isOnline():Boolean { return _isOnline; }
		
		public function get imageServer():String { return _imageServer; }
		
		public function get scriptServer():String { return _scriptServer; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function initFrom(dobj:DisplayObject) {
			var url:String = DisplayUtils.getRootURL(dobj);
			//url="http://www.neopets.com/games/arcade.phtml"; // comment this in to test for a given url
			if(url != null) {
				// check for live server prefix
				if(url.indexOf(LIVE_SCRIPT_SERVER) == 0 || url.indexOf(LIVE_IMAGE_SERVER) == 0) {
					_scriptServer = LIVE_SCRIPT_SERVER;
					_imageServer = LIVE_IMAGE_SERVER;
					_isOnline = true;
				} else {
					// check for dev server prefix
					if(url.indexOf(DEV_SCRIPT_SERVER) == 0 || url.indexOf(DEV_IMAGE_SERVER) == 0) {
						_scriptServer = DEV_SCRIPT_SERVER;
						_imageServer = DEV_IMAGE_SERVER;
						_isOnline = true;
					} else useDefaults();
				}
			} else useDefaults();
		}
		
		// This function loads default values.
		
		public function useDefaults():void {
			_scriptServer = DEV_SCRIPT_SERVER;
			_imageServer = DEV_IMAGE_SERVER;
			_isOnline = false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
