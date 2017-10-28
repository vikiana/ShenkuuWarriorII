/**
 *	This class shows the currently selected meal.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.08.2010
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
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	
	public class SelectedMeal extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const FRAME_PREFIX:String = "meal_";
		public static const NO_MEAL:String = "no_meal";
		// protected variables
		protected var _mealID:int = -1;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SelectedMeal():void {
			EventHub.addEventListener(MealButton.MEAL_SELECTED,onMealSelected);
			EventHub.addEventListener(FeedButton.FEED_COMPLETED,onFeedCompleted);
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
		 *	This functions is triggered when a "feed a pet" attempt succeeds.
		 **/
		
		protected function onFeedCompleted(ev:RelayedEvent) {
			_mealID = -1;
			gotoAndPlay(NO_MEAL);
		}
		
		/**	
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		protected function onMealSelected(ev:RelayedEvent) {
			_mealID = ev.source.mealID;
			gotoAndPlay(FRAME_PREFIX+_mealID);
		}
		
	}
	
}