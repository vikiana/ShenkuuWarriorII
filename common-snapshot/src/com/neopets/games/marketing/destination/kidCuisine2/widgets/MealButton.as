/**
 *	This class handle meal selection buttons.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.07.2010
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
	import com.neopets.games.marketing.destination.kidCuisine2.pages.KitchenPage;
	import com.neopets.util.tracker.NeoTracker;
	
	public class MealButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const MEAL_SELECTED:String = "MealButton_selected";
		// protected variables
		protected var _mealID:int = -1;
		protected var _neoContentID:int;
		protected var _scriptName:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MealButton():void {
			super();
			addEventListener(MouseEvent.CLICK,onClick);
			// steal our click sound from the kitchen page
			clickSound = KitchenPage.CLICK_SOUND;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get mealID():int { return _mealID; }
		
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
			EventHub.broadcast(new Event(MEAL_SELECTED),this);
			playClick();
			// apply tracking
			if(_neoContentID >= 0) NeoTracker.instance.trackNeoContentID(_neoContentID);
			if(_scriptName != null) runJavaScript(_scriptName);
		}
		
	}
	
}