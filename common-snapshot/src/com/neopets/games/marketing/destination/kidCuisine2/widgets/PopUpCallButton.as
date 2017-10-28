/**
 *	This class broadcasts a request for the target pop up to show themselves.
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
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	
	public class PopUpCallButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const POPUP_REQUESTED:String = "pop_up_requested";
		// public variables
		public var popUpID:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopUpCallButton():void {
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
			EventHub.broadcast(new Event(POPUP_REQUESTED),this);
			playClick();
		}
		
	}
	
}