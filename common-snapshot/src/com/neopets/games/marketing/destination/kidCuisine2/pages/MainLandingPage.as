/**
 *	This class handles the first page users should see on entering the destination.
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
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	public class MainLandingPage extends AbsPageWithTracking
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const DOOR_SOUND:String = "Door_MysticalOpen1";
		public static const ROOM_MUSIC:String = "Goofball";
		// protected variables
		protected var welcomePopUp:MovieClip;
		protected var _kitchenDoor:MovieClip;
		protected var _breakDoor:MovieClip;
		protected var _trainingDoor:MovieClip;
		protected var _violatorClip:MovieClip;
		protected var _soundButton:MovieClip;
		protected var loadRecord:SharedObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MainLandingPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			// set up sounds
			addSound(DOOR_SOUND);
			addSound(ROOM_MUSIC);
			// set up component linkages
			welcomePopUp = getChildByName("welcome_mc") as MovieClip;
			kitchenDoor = getChildByName("kitchen_mc") as MovieClip;
			breakDoor = getChildByName("break_mc") as MovieClip;
			trainingDoor = getChildByName("training_mc") as MovieClip;
			violatorClip = getChildByName("violator_mc") as MovieClip;
			soundButton = getChildByName("sound_mc") as MovieClip;
			// check if this swf has been loaded previously
			loadRecord = SharedObject.getLocal("KC_Destination_Record");
			if(loadRecord != null) {
				var info:Object = loadRecord.data;
				if("last_load" in info) {
					// hide the message window
					if(welcomePopUp != null) welcomePopUp.visible = false;
				}
				info.last_load = new Date();
			}
			// finish loading
			DisplayUtils.cacheImages(this);
			neoContentID = 15622;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get breakDoor():MovieClip { return _breakDoor; }
		
		public function set breakDoor(clip:MovieClip) {
			_breakDoor = clip;
			if(_breakDoor != null) {
				_breakDoor.clickSound = DOOR_SOUND;
				_breakDoor.page = "games";
				_breakDoor.dartURL = "http://ad.doubleclick.net/clk;221569902;15177704;h?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=games";
				_breakDoor.neoContentID = 15603;
			}
		}
		
		public function get kitchenDoor():MovieClip { return _kitchenDoor; }
		
		public function set kitchenDoor(clip:MovieClip) {
			_kitchenDoor = clip;
			if(_kitchenDoor != null) {
				_kitchenDoor.clickSound = DOOR_SOUND;
				_kitchenDoor.page = "feed";
				_kitchenDoor.dartURL = "http://ad.doubleclick.net/clk;221570094;15177704;b?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=feed";
				_kitchenDoor.neoContentID = 15604;
			}
		}
		
		public function get soundButton():MovieClip { return _soundButton; }
		
		public function set soundButton(clip:MovieClip) {
			_soundButton = clip;
			if(_soundButton != null) _soundButton.musicLoop = ROOM_MUSIC;
		}
		
		public function get trainingDoor():MovieClip { return _trainingDoor }
		
		public function set trainingDoor(clip:MovieClip) {
			_trainingDoor = clip;
			if(_trainingDoor != null) {
				_trainingDoor.clickSound = DOOR_SOUND;
				_trainingDoor.page = "about";
				_trainingDoor.dartURL = "http://ad.doubleclick.net/clk;221569852;15177704;l?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=about";
				_trainingDoor.neoContentID = 15602;
			}
		}
		
		public function get violatorClip():MovieClip { return _violatorClip; }
		
		public function set violatorClip(clip:MovieClip) {
			_violatorClip = clip;
			if(_violatorClip != null) {
				_violatorClip.dartURL = "http://ad.doubleclick.net/clk;221571987;15177704;n?http://kidcuisine.promo.eprize.com/krazycombos";
				_violatorClip.neoContentID = 15605;
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

	}
	
}