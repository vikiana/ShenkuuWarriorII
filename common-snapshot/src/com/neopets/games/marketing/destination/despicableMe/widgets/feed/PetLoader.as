/**
 *	This class handles loading pet images.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.06.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.feed
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.games.marketing.destination.kidCuisine2.feedAPet.DefaultPet;
	import com.neopets.games.marketing.destination.despicableMe.widgets.ImagePane;
	
	public class PetLoader extends ImagePane
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _petData:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PetLoader():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set contentArea(clip:MovieClip) {
			_contentArea = clip;
			loadPet();
		}
		
		public function get petData():Object { return _petData; }
		
		public function set petData(info:Object) {
			_petData = info;
			loadPet();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	Loads all pet data into this slot.
		 **/
		
		public function loadPet() {
			// let the user know we're loading
			if(_petData != null) {
				// turn on loading indicator
				if(_loadIndicator != null) _loadIndicator.visible = true;
				// add the pet loader
				var local:Boolean = !Parameters.onlineMode;
				var pet:DefaultPet = new DefaultPet(_petData.name,_petData.pngurl,_petData.swfurl,_petData.fed_recently,local);
				pet.addEventListener(pet.PET_LOADED,onPetLoaded);
			} else content = null;
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
		
		// When a new pet loads, set it as our content.
		
		protected function onPetLoaded(ev:Event) {
			// turn of loading indicator
			if(_loadIndicator != null) _loadIndicator.visible = false;
			// set the loaded pet as our content
			content = ev.target as DefaultPet;
		}
		
	}
	
}