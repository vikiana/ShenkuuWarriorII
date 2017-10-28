/**
 *	This sub-class automatically updates when a pet is selected.
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
	import flash.text.TextField;
	import flash.events.Event;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	
	public class SelectedPetSlot extends PetSlot
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const NO_PET_CAPTION:String = "<b>Pet</b>";
		// protected variables
		protected var _nameField:TextField;
		protected var _petName:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SelectedPetSlot():void {
			EventHub.addEventListener(PetButton.PET_SELECTED,onPetSelected);
			EventHub.addEventListener(FeedButton.FEED_COMPLETED,onFeedCompleted);
			super();
			_nameField = getChildByName("name_txt") as TextField;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get petName():String { return _petName; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		override public function set petData(info:Object) {
			_petData = info;
			if(_petData != null) {
				_petName = _petData.name; // stored separately as it seems be getting nulled
			}
			loadPet();
		}
		
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
			petData = null;
			if(_nameField != null) _nameField.htmlText = NO_PET_CAPTION;
		}
		
		/**	
		 * @This function is trigger when the target pet's image has loaded.
		 **/
		
		override protected function onPetLoaded(ev:Event) {
			// blank the name field
			if(_nameField != null) _nameField.htmlText = "";
			// inherited code
			if(_loadIndicator != null) _loadIndicator.visible = false;
			if(petClip != null) _loadingArea.addChild(petClip);
			dispatchEvent(new Event(PET_LOADED));
		}
		
		/**	
		 * @This function simply passed the given parameter to the dispatcher function of the same name.
		 **/
		
		protected function onPetSelected(ev:RelayedEvent) {
			var info:Object = ev.source.petData;
			if(_petData != info) {
				petData = info;
				if(_nameField != null) _nameField.htmlText = "<b>"+_petName+"</b>";
			}
		}
		
	}
	
}