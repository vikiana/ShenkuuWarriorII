/**
 *	This class attaches a text field to a ButtonClip.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.14.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.sound.SoundManager;
	
	public class SoundButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const SOUND_OFF_FRAME:String = "sound_off";
		// protected variables
		protected var _musicLoop:String;
		protected var _soundEnabled:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SoundButton():void {
			super();
			soundEnabled = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get musicLoop():String { return _musicLoop; }
		
		public function set musicLoop(str:String) {
			_musicLoop = str;
			playMusic();
		}
		
		public function get soundEnabled():Boolean { return _soundEnabled; }
		
		public function set soundEnabled(bool:Boolean) {
			_soundEnabled = bool;
			// set sound levels
			var sounds:SoundManager = SoundManager.instance;
			if(_soundEnabled) sounds.globalSoundLevel = 1;
			else {
				sounds.globalSoundLevel = 0;
				sounds.stopAllCurrentSounds();
			}
			sounds.soundOverRide = false;
			playMusic();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	This functions plays our click sound.
		 **/
		
		protected function playMusic() {
			if(_musicLoop != null) {
				var sounds:SoundManager = SoundManager.instance;
				if(_soundEnabled) sounds.soundPlay(_musicLoop,true);
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
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		override protected function onMouseOut(ev:Event) {
			if(_soundEnabled) gotoAndPlay(OFF_FRAME);
		}
		
		/**	
		 *	This functions triggers the mouse-over animation.
		 **/
		
		override protected function onMouseOver(ev:Event) {
			if(_soundEnabled) gotoAndPlay(OVER_FRAME);
		}
		
		/**	
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		override protected function onClick(ev:MouseEvent) {
			var sounds:SoundManager = SoundManager.instance;
			if(_soundEnabled) {
				soundEnabled = false;
				gotoAndPlay(SOUND_OFF_FRAME);
			} else  {
				soundEnabled = true;
				playClick();
				gotoAndPlay(OVER_FRAME);
			}
		}
		
	}
	
}