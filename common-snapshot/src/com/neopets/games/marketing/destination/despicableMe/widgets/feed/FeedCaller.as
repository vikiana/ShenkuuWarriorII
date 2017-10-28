/**
 *	This class listens provides the UI for "feed a pet" requests.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.feed
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.marketing.destination.despicableMe.pages.FeedAPetPage;
	
	public class FeedCaller extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _petClip:PetLoader;
		protected var _foodClip:PetLoader;
		protected var _feedButton:InteractiveObject;
		protected var _locked:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedCaller():void {
			super();
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up components
			_locked = false;
			_petClip = getChildByName("pet_mc") as PetLoader;
			_foodClip = getChildByName("food_mc") as PetLoader;
			feedButton = getChildByName("feed_btn") as InteractiveObject;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get feedButton():InteractiveObject { return _feedButton; }
		
		public function set feedButton(btn:InteractiveObject) {
			// clear listeners
			if(_feedButton != null) {
				_feedButton.removeEventListener(MouseEvent.CLICK,onFeedRequest);
			}
			_feedButton = btn;
			// set up listeners
			if(_feedButton != null) {
				var clip:MovieClip = _feedButton as MovieClip;
				if(clip != null) clip.buttonMode = true;
				_feedButton.addEventListener(MouseEvent.CLICK,onFeedRequest);
			}
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(PetList.PET_SELECTED,onPetSelected);
				_sharedDispatcher.removeEventListener(FoodItem.FOOD_SELECTED,onFoodSelected);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_COMPLETED,onFeedDone);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_FAILED,onFeedDone);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(PetList.PET_SELECTED,onPetSelected);
				_sharedDispatcher.addEventListener(FoodItem.FOOD_SELECTED,onFoodSelected);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_COMPLETED,onFeedDone);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_FAILED,onFeedDone);
			}
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
		
		// If a feed fails, make sure this clip unlocks for another request.
		
		protected function onFeedDone(ev:Event) {
			// clear pet
			if(_petClip != null) _petClip.petData = null;
			// amf call is done, so open up for another request
			_locked = false;
		}
		
		// Use this function to try sending out a feed request to php.
		
		protected function onFeedRequest(ev:Event=null) {
			if(_locked) return; // abort if we're locked down
			// check if a pet has been selected
			if(_petClip == null) return null;
			var pet_data:Object = _petClip.petData;
			if(pet_data == null) return;
			// check if we've got a selected food item
			if(_foodClip == null || _foodClip.content == null) return;
			// lock down the caller until the request has been processed.
			_locked = true;
			// If we've gotten this far, broadcast the request
			broadcast(FeedAPetPage.FEED_REQUESTED,pet_data);
		}
		
		// This function shows the newly selected food.
		
		protected function onFoodSelected(ev:BroadcastEvent) {
			if(_locked) return; // abort if we're locked down
			if(_foodClip != null) {
				// clone the sender for use in our "selected food" slot
				var dupe:FoodItem = GeneralFunctions.cloneObject(ev.sender) as FoodItem;
				if(dupe != null) {
					dupe.clickable = false; // don't let the copy dispatch selection events
					_foodClip.content = dupe;
				}
			}
		}
		
		// This function shows the newly selected pet.
		
		protected function onPetSelected(ev:BroadcastEvent) {
			if(_locked) return; // abort if we're locked down
			if(_petClip != null) _petClip.petData = ev.oData;
		}

	}
	
}