/**
 *	This class handles loading pet images.
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
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.games.marketing.destination.kidCuisine2.feedAPet.DefaultPet;
	
	public class PetSlot extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const PET_LOADED:String = "pet_loaded";
		// protected variables
		protected var _loadingArea:MovieClip;
		protected var _petData:Object;
		protected var petClip:DefaultPet;
		protected var _loadIndicator:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PetSlot():void {
			loadingArea = getChildByName("loader_mc") as MovieClip;
			loadIndicator = getChildByName("loading_mc") as MovieClip;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get loadingArea():MovieClip { return _loadingArea; }
		
		public function set loadingArea(clip:MovieClip) {
			_loadingArea = clip;
			loadPet();
		}
		
		public function get loadIndicator():MovieClip { return _loadIndicator; }
		
		public function set loadIndicator(clip:MovieClip) {
			_loadIndicator = clip;
			_loadIndicator.visible = false;
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
			if(_loadingArea == null) return;
			// remove the previous pet loader
			if(petClip != null) {
				_loadingArea.removeChild(petClip);
				petClip = null;
			}
			// let the user know we're loading
			if(_petData != null) {
				if(_loadIndicator != null) _loadIndicator.visible = true;
				// add the pet loader
				var local:Boolean = !Parameters.onlineMode;
				petClip = new DefaultPet(_petData.name,_petData.pngurl,_petData.swfurl,_petData.fed_recently,local);
				//_loadingArea.addChild(petClip);
				petClip.addEventListener(petClip.PET_LOADED,onPetLoaded);
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
		
		protected function onPetLoaded(ev:Event) {
			if(_loadIndicator != null) _loadIndicator.visible = false;
			if(petClip != null) _loadingArea.addChild(petClip);
			dispatchEvent(new Event(PET_LOADED));
		}
		
	}
	
}