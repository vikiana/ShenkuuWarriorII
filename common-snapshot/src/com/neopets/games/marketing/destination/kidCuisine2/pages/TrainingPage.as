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
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.games.marketing.destination.kidCuisine2.DestinationData;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	
	public class TrainingPage extends AbsPageWithTracking
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const ROOM_MUSIC:String = "suchawhim";
		public static const REMOTE_SOUND:String = "Magic_Spell_Heal4";
		public static const INFO_SOUND:String = "Magic_Poof3";
		// protected variables
		protected var _backButton:MovieClip;
		protected var _soundButton:MovieClip;
		protected var _violatorClip:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TrainingPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			// finish loading
			DisplayUtils.cacheImages(this);
			neoContentID = 15623;
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
				_violatorClip.dartURL = "http://ad.doubleclick.net/clk;221572200;15177704;s?http://kidcuisine.promo.eprize.com/krazycombos";
				_violatorClip.neoContentID = 15614;
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
			addSound(REMOTE_SOUND);
			addSound(INFO_SOUND);
			// set up component linkages
			backButton = getChildByName("back_btn") as MovieClip;
			soundButton = getChildByName("sound_mc") as MovieClip;
			violatorClip = getChildByName("violator_mc") as MovieClip;
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}