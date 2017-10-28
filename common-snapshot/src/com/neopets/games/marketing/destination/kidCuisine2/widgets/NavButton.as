/**
 *	This class lets a movieclip mimic the mouse-over behaviour of a button.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.tracker.NeoTracker;
	
	public class NavButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const PAGE_PATH:String = "/sponsors/kidcuisine/index.phtml";
		// protected variable
		protected var _pageID:String;
		protected var _clickURL:String;
		// public variables
		public var dartURL:String;
		public var neoContentID:int = -1;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function NavButton():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get clickURL():String { return _clickURL; }
		
		public function get page():String { return _pageID; }
		
		public function set page(tag:String) {
			_pageID = tag;
			// set up click url
			if(Parameters.onlineMode) {
				_clickURL = Parameters.baseURL + PAGE_PATH;
				if(_pageID != null) _clickURL += "?page=" + _pageID;
			} else _clickURL = null;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**	
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		override protected function onClick(ev:MouseEvent) {
			// apply tracking
			if(dartURL != null) NeoTracker.instance.trackURL(dartURL);
			if(neoContentID >= 0) NeoTracker.instance.trackNeoContentID(neoContentID);
			// play click sound
			playClick();
			// go to target page
			if(_clickURL != null) {
				var req:URLRequest = new URLRequest(_clickURL);
				navigateToURL(req,"_top");
			}
		}
		
	}
	
}