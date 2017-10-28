/**
 *	This class handles pet selection buttons.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.06.2010
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
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	import com.neopets.games.marketing.destination.kidCuisine2.pages.KitchenPage;
	
	public class PetButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const LOCKED_FRAME:String = "locked";
		public static const PET_SELECTED:String = "PetButton_selected";
		// protected variable
		protected var _mainClip:MovieClip;
		protected var _petData:Object;
		protected var _clickable:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PetButton():void {
			super();
			clickable = false;
			mainClip = getChildByName("main_mc") as MovieClip;
			EventHub.addEventListener(FeedButton.FEED_COMPLETED,onFeedCompleted);
			// steal our click sound from the kitchen page
			clickSound = KitchenPage.CLICK_SOUND;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get clickable():Boolean { return _clickable; }
		
		public function set clickable(bool:Boolean) {
			if(_clickable != bool) {
				_clickable = bool;
				if(_clickable) addEventListener(MouseEvent.CLICK,onClick);
				else removeEventListener(MouseEvent.CLICK,onClick);
			}
			if(_clickable) gotoAndPlay(OFF_FRAME);
			else gotoAndPlay(LOCKED_FRAME);
		}
		
		public function get mainClip():MovieClip { return _mainClip; }
		
		public function set mainClip(clip:MovieClip) {
			// clear previous clip
			if(_mainClip != null) {
				_mainClip.removeEventListener(PetSlot.PET_LOADED,onPetLoaded);
			}
			// set new clip
			_mainClip = clip;
			if(_mainClip != null) {
				_mainClip.addEventListener(PetSlot.PET_LOADED,onPetLoaded);
				loadPet();
			}
		}
		
		public function get petData():Object { return _petData; }
		
		public function set petData(info:Object) {
			_petData = info;
			loadPet();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**	
		 *	Loads all pet data into this slot.
		 **/
		
		public function loadPet() {
			if(_mainClip == null || _petData == null) return;
			_mainClip.petData = _petData;
		}
		
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
			if(_clickable) {
				EventHub.broadcast(new Event(PET_SELECTED),this);
			}
			playClick();
		}
		
		/**	
		 *	This functions is triggered when a "feed a pet" attempt succeeds.
		 **/
		
		protected function onFeedCompleted(ev:RelayedEvent) {
			var info:Object = ev.source.sentPet;
			if(info == _petData) clickable = false;
		}
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		override protected function onMouseOut(ev:Event) {
			if(_clickable) gotoAndPlay(OFF_FRAME);
		}
		
		/**	
		 *	This functions triggers the mouse-over animation.
		 **/
		
		override protected function onMouseOver(ev:Event) {
			if(_clickable) gotoAndPlay(OVER_FRAME);
		}
		
		/**	
		 *	This functions triggers after the pet image has finished loading.
		 **/
		
		protected function onPetLoaded(ev:Event) {
			if(_petData != null) clickable = !_petData.fed_recently;
		}
		
	}
	
}