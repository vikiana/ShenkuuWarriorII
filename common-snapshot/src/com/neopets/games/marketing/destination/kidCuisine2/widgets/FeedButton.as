/**
 *	This class hands the "feed a pet" button and functionality.
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
	import com.neopets.games.marketing.destination.kidCuisine2.DestinationData;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.feedAPet.DefaultAMFPHP;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.games.marketing.destination.kidCuisine2.pages.KitchenPage;
	
	public class FeedButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const FEED_STARTED:String = "feed_pet_requested";
		public static const FEED_COMPLETED:String = "feed_pet_completed";
		public static const FEED_FAILED:String = "feed_pet_failed";
		// public variables
		public var chosenPet:SelectedPetSlot;
		public var chosenMeal:SelectedMeal;
		// protected variables
		protected var amfphp:DefaultAMFPHP;
		protected var _sentPet:Object;
		protected var sendingRequest:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedButton():void {
			super();
			sendingRequest = false;
			// set up amf system
			amfphp = new DefaultAMFPHP(DestinationData.FEED_CODE);
			amfphp.addEventListener(amfphp.PET_FED,onPetFed);
			amfphp.addEventListener(amfphp.ERROR_OCCURED,onFeedFail);
			// set up selection links
			chosenPet = DisplayUtils.getSiblingInstance(this,SelectedPetSlot) as SelectedPetSlot;
			chosenMeal = DisplayUtils.getSiblingInstance(this,SelectedMeal) as SelectedMeal;
			// set up listeners
			addEventListener(MouseEvent.CLICK,onClick);
			// steal our click sound from the kitchen page
			clickSound = KitchenPage.CLICK_SOUND;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get sentPet():Object { return _sentPet; }
		
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
			// make sure a request isn't already in process
			if(sendingRequest) return;
			// check if we're linked to a pet and meal display
			if(chosenPet == null || chosenMeal == null) return;
			// make sure the user has selected a pet and a meal
			if(chosenPet.petData != null && chosenMeal.mealID >= 0) {
				_sentPet = chosenPet.petData;
				sendingRequest = true;
				amfphp.feedPet(chosenPet.petName);
				EventHub.broadcast(new Event(FEED_STARTED),this);
			}
			playClick();
		}
		
		/**	
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		protected function onPetFed(ev:Event) {
			sendingRequest = false;
			EventHub.broadcast(new Event(FEED_COMPLETED),this);
		}
		
		/**	
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		protected function onFeedFail(ev:Event) {
			sendingRequest = false;
			EventHub.broadcast(new Event(FEED_FAILED),this);
		}
		
	}
	
}