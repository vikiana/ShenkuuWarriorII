/**
 *	This class handles ECard request buttons.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.CapriSun2011.ecard
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	
	public class ECardButton extends BroadcasterClip
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const BROADCAST_EVENT:String = "ECard_requested";
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ECardButton():void {
			super();
			// set up broadcasts
			useParentDispatcher(AbsPage);
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
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
		
		// Relay click through shared dispatcher.
		
		protected function onClick(ev:MouseEvent) {
			broadcast(BROADCAST_EVENT);
		}

	}
	
}