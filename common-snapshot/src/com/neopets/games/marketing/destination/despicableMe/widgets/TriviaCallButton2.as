/**
 *	This class handles trivia pop up request buttons.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */
 
 // This old version of this class had a bug and caused a #1034 error

package com.neopets.games.marketing.destination.despicableMe.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;// added 4/23
	
	public class TriviaCallButton2 extends BroadcasterClip
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const BROADCAST_EVENT:String = "TriviaPopUp_requested";
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TriviaCallButton2():void {
			//super();
			trace('test');
			
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