/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.sound.SoundManager;
	
	public class MusicToggle extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _isActive:Boolean = true;
		protected var _music:Array = new Array();
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MusicToggle():void {
			super();
			// set up mouse listeners
			addEventListener(MouseEvent.CLICK,onMouseClick);
			buttonMode = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get isActive():Boolean { return _isActive; }
		
		public function set isActive(bool:Boolean) {
			if(_isActive != bool) {
				_isActive = bool;
				// check which state we shifted into
				var audio:SoundManager = SoundManager.instance;
				if(_isActive) {
					gotoAndStop("on");
					// play all our music tracks
					for(var i:int = 0; i < _music.length; i++) {
						audio.soundPlay(_music[i],true);
					}
				} else {
					gotoAndStop("off");
					audio.stopAllCurrentSounds();
				}
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function addMusic(id:String):void {
			if(id == null) return;
			// check if we already have the sound
			if(_music.indexOf(id) >= 0) return;
			// otherwise add it to our list now
			_music.push(id);
			// check if the track already exists
			var audio:SoundManager = SoundManager.instance;
			if(!audio.checkSoundObj(id)) {
				audio.loadSound(id,audio.TYPE_SND_INTERNAL);
			}
			// try playing the track
			audio.soundPlay(id,true);
		}
		
		public function removeMusic(id:String):void {
			if(id == null) return;
			// check if we have the sound
			var index:int = _music.indexOf(id);
			if(index < 0) return;
			// check if sound manager knows about the sound
			var audio:SoundManager = SoundManager.instance;
			if(audio.checkSoundObj(id)) {
				audio.stopSound(id);
			}
			// take the sound out of our list
			_music.splice(index,1);
		}
		
		public function toggle():void {
			isActive = !_isActive;
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
		
		protected function onMouseClick(ev:MouseEvent) {
			toggle();
		}

	}

	
}