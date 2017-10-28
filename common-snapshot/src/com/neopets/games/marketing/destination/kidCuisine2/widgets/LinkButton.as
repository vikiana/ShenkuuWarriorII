/**
 *	This class lets you attach a link url to a button.
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
	
	public class LinkButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const PAGE_PATH:String = "/sponsors/kidcuisine/index.phtml";
		// public variable
		public var clickURL:String;
		public var dartURL:String;
		public var neoContentID:int = -1;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LinkButton():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
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
			playClick();
			// apply Dart tracking
			if(dartURL != null) NeoTracker.instance.trackURL(dartURL);
			// check if we have an associated url
			if(clickURL != null) {
				var req:URLRequest = new URLRequest(clickURL);
				navigateToURL(req,"_blank");
				// apply NeoContent tracking
				if(neoContentID >= 0) NeoTracker.instance.trackNeoContentID(neoContentID);
			} else {
				// try using neocotent id as link
				if(neoContentID >= 0) NeoTracker.processClickURL(neoContentID,"_blank");
			}
		}
		
	}
	
}