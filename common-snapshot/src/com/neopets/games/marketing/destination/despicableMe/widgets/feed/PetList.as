/**
 *	This class listens for pet list updates and relays them to the pet displays.
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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.projects.destination.destinationV3.feedapet.AbsFeedAPetAMFPHP;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.marketing.destination.despicableMe.pages.FeedAPetPage;
	
	public class PetList extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const PET_SELECTED:String = "pet_selected";
		// Imported from AbsFeedAPetAMFPHP as these were not made global
		public static const PET_DATA_IN:String = "pet_date_in";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var amfphp:DefaultAMFPHP;
		protected var _loaders:Array;
		protected var _petData:Array;
		protected var _petBeingFed:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PetList():void {
			super();
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// wait one frame to check for pet loaders
			_loaders = new Array();
			addEventListener(Event.ENTER_FRAME,checkLoaders);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(PET_DATA_IN,onPetDataIn);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_REQUESTED,onFeedRequest);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_COMPLETED,onPetFed);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(PET_DATA_IN,onPetDataIn);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_REQUESTED,onFeedRequest);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_COMPLETED,onPetFed);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// This function loads pending data into any open pet loader slots.
		
		public function loadData():void {
			if(_petData == null) return; // abort if no data is pending
			// cycle through all pending data
			var slot:PetLoader;
			for(var i:int = 0; i < _petData.length; i++) {
				if(i < _loaders.length) {
					slot = _loaders[i] as PetLoader;
					if(slot != null) slot.petData = _petData[i];
				} else break;
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function check every frame until our loaders are found.
		
		protected function checkLoaders(ev:Event) {
			if(_loaders.length <= 0) {
				// search for pet loaders
				var slot:PetLoader;
				for(var i:int = 0; i < numChildren; i++) {
					slot = getChildAt(i) as PetLoader;
					if(slot != null) {
						// add listeners
						slot.addEventListener(Event.CHANGE,onLoaderChange);
						// store slot
						_loaders.push(slot);
					}
				}
				// if we found some, sort them into a column and stop the search
				if(_loaders.length > 0) {
					_loaders.sortOn("y",Array.NUMERIC);
					removeEventListener(Event.ENTER_FRAME,checkLoaders);
					loadData();
				}
			}
		}
		
		// Use this function to turn off one of our pet loader slots.
		
		protected function disableLoader(slot:PetLoader) {
			if(slot == null || slot.parent != this) return;
			slot.alpha = 0.5;
			slot.removeEventListener(MouseEvent.CLICK,onPetSelected);
			slot.buttonMode = false;
		}
		
		// Use this function to turn off one of our pet loader slots.
		
		protected function enableLoader(slot:PetLoader) {
			if(slot == null || slot.parent != this) return;
			slot.alpha = 1;
			slot.addEventListener(MouseEvent.CLICK,onPetSelected);
			slot.buttonMode = true;
		}
		
		// When a pet feed is requested, make a note of which pet is requested.
		
		protected function onFeedRequest(ev:CustomEvent) {
			_petBeingFed = ev.oData;
		}
		
		// When the pet data comes in, show the pets.
		
		protected function onPetDataIn(ev:CustomEvent):void {
			_petData = ev.oData as Array;
			loadData();
		}
		
		// If feed succeeds, disable the requested pet option.
		
		protected function onPetFed(ev:Event) {
			if(_petBeingFed == null) return;
			var slot:PetLoader;
			for(var i:int = 0; i < _loaders.length; i++) {
				slot = _loaders[i];
				if(slot.petData == _petBeingFed) disableLoader(slot);
			}
		}
		
		// This function broadcasts a pet selection event when a pet image is clicked on.
		
		protected function onPetSelected(ev:MouseEvent) {
			// check for the containing pet loader for the mouse clip
			var slot:PetLoader = ev.target as PetLoader;
			if(slot == null) {
				var dobj:DisplayObject = ev.target as DisplayObject;
				slot = DisplayUtils.getAncestorInstance(dobj,PetLoader) as PetLoader;
			}
			// broad cast that loader's pet data
			if(slot != null) {
				var info:Object = slot.petData;
				if(info != null) broadcast(PET_SELECTED,info);
			}
		}
		
		// When a loader's content changes, update its clickable status.
		
		protected function onLoaderChange(ev:Event) {
			var slot:PetLoader = ev.target as PetLoader;
			if(slot != null) {
				// check if the slot has a loaded image
				if(slot.content != null) {
					// check if the loaded pet has been fed recently
					var info:Object = slot.petData;
					if(info != null && info.fed_recently) disableLoader(slot);
					else enableLoader(slot);
				} else disableLoader(slot);
			}
		}

	}
	
}