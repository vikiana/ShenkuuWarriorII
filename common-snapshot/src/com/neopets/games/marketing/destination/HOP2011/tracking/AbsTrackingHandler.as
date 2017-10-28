/**
 *	This class handles general page functions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.HOP2011.tracking
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------/**/
	
	import flash.external.ExternalInterface;
	
	public class AbsTrackingHandler extends Object
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		protected var _initialized:Boolean = false;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AbsTrackingHandler():void
		{
			super();
			init();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function init():void {
			if(!_initialized) {
				// set up tracking listeners
				initListeners();
				// set initialization flag
				_initialized = true;
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this to set up all child objects.
		
		protected function initListeners():void {}
		
		// This function makes javascripts calls quicker and easier
		
		protected function callJavascript(func_name:String, ... rest):void {
			if(ExternalInterface.available) {
				ExternalInterface.call(func_name,rest);
				trace("called " + func_name + " with (" + rest + ")");
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
	}
	
}