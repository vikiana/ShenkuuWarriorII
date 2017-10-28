/**
 *	This class handles the "kitchen" location in the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.games.marketing.destination.kidCuisine2.DestinationData;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	
	public class KitchenPage extends AbsPageWithTracking
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const ROOM_MUSIC:String = "Song8";
		public static const CLICK_SOUND:String = "bell";
		// protected variables
		protected var amfphp:DefaultAMFPHP;
		protected var petsClip:MovieClip;
		protected var _backButton:MovieClip;
		protected var _soundButton:MovieClip;
		protected var _violatorClip:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function KitchenPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			// finish loading
			DisplayUtils.cacheImages(this);
			neoContentID = 15625;
			//DebugTracer.addTextfieldTo(this,width,height);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get backButton():MovieClip { return _backButton; }
		
		public function set backButton(clip:MovieClip) {
			_backButton = clip;
			if(_backButton != null) _backButton.page = null;
		}
		
		public function get soundButton():MovieClip { return _soundButton; }
		
		public function set soundButton(clip:MovieClip) {
			_soundButton = clip;
			if(_soundButton != null) _soundButton.musicLoop = ROOM_MUSIC;
		}
		
		public function get violatorClip():MovieClip { return _violatorClip; }
		
		public function set violatorClip(clip:MovieClip) {
			_violatorClip = clip;
			if(_violatorClip != null) {
				_violatorClip.dartURL = "http://ad.doubleclick.net/clk;221572736;15177704;g?http://kidcuisine.promo.eprize.com/krazycombos";
				_violatorClip.neoContentID = 15621;
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			// set up sounds
			addSound(ROOM_MUSIC);
			addSound(CLICK_SOUND);
			// set up amf-php
			setupAMFPHP();
			// set up component linkages
			petsClip = getChildByName("pets_mc") as MovieClip;
			backButton = getChildByName("back_btn") as MovieClip;
			soundButton = getChildByName("sound_mc") as MovieClip;
			violatorClip = getChildByName("violator_mc") as MovieClip;
		}
		
		private function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP(DestinationData.FEED_CODE);
			amfphp.addEventListener(amfphp.PET_DATA_IN, onPetDataIn, false, 0, true);
			amfphp.addEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem, false, 0, true);
		}
		
		protected function onPetDataIn(evt:Event):void
		{
			trace ("\n=========	SETUP PETS =======\n")
			if(petsClip != null) petsClip.petData = amfphp.petDataArray;
			var info:Object = amfphp.petDataArray;
		}
		
		protected function onNoneErrorProblem(evt:CustomEvent):void
		{
			trace (amfphp.NONE_ERROR_PROBLEM)
			//var popup:PopupSimple = new PopupSimple(evt.oData.MESSAGE, 80, 100);
			//addChild(popup)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}