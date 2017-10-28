/**
 *	This class is a specialized button that automatically links to the client's page.
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
	import com.neopets.games.marketing.destination.kidCuisine2.DestinationData;
	import com.neopets.util.tracker.NeoTracker;
	
	public class ViolatorButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// public variables
		public var dartURL:String;
		public var neoContentID:int = -1;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ViolatorButton():void {
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
			// apply tracking
			if(dartURL != null) NeoTracker.instance.trackURL(dartURL);
			if(neoContentID >= 0) NeoTracker.instance.trackNeoContentID(neoContentID);
			// play click sound
			playClick();
			// trigger client page
			var req:URLRequest = new URLRequest(DestinationData.VIOLATOR_URL);
			navigateToURL(req,"_blank");
		}
		
	}
	
}