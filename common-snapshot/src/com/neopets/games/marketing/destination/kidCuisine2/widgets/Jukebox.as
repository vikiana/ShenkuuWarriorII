/**
 *	The Jukebox class provides a selection of music tracks the user can pick between.
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
	import flash.display.SimpleButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.neopets.util.sound.SoundManager;
	
	public class Jukebox extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		protected static const GREEN_SONG:String = "WiggleAndWobbl_135";
		protected static const YELLOW_SONG:String = "HappyUkuleleKids";
		protected static const RED_SONG:String = "BeachParty_109";
		// protected variables
		protected var _helpPopUp:MovieClip;
		protected var buttons:Array;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Jukebox():void {
			// set up music
			addMusic(GREEN_SONG);
			addMusic(YELLOW_SONG);
			addMusic(RED_SONG);
			// set up buttons
			buttons = new Array();
			initMusicButtons();
			addStopButton("left_stop_btn");
			addStopButton("right_stop_btn");
			// set up listeners
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			// start music
			playRandom();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get helpPopUp():MovieClip { return _helpPopUp; }
		
		public function set helpPopUp(clip:MovieClip) {
			_helpPopUp = clip;
			if(_helpPopUp != null) {
				_helpPopUp.mouseEnabled = false;
				_helpPopUp.visible = false;
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	This function add a new music track to the sound manager.
		 *	param		tag				String		Name of movieclip being added
		 *	param		frame			String		Name of frame to go to when pressed
		 *	param		loop			String		Name of music to be played
		 **/
		
		public function addButton(tag:String,frame:String,loop:String) {
			var clip:MovieClip = getChildByName(tag) as MovieClip;
			if(clip != null) {
				clip.targetFrame = frame;
				clip.musicID = loop;
				clip.useHandCursor = true;
				clip.addEventListener(MouseEvent.MOUSE_DOWN,onButtonClick);
				buttons.push(clip);
			}
		}
		
		/**	
		 *	This set a button so it can turn off the music.
		 *	param		tag				String		Name of movieclip being added
		 **/
		
		public function addStopButton(tag:String) {
			var clip:MovieClip = getChildByName(tag) as MovieClip;
			if(clip != null) {
				clip.useHandCursor = true;
				clip.addEventListener(MouseEvent.CLICK,onStopMusic);
				clip.addEventListener(MouseEvent.MOUSE_OVER,onMuteOver);
				clip.addEventListener(MouseEvent.MOUSE_OUT,onMuteOut);
			}
		}
		
		/**	
		 *	This function add a new music track to the sound manager.
		 *	param		tag				String		Identifer for created sound object
		 **/
		
		public function addMusic(tag:String) {
			var sounds:SoundManager = SoundManager.instance;
			if(!sounds.checkSoundObj(tag)) {
				sounds.loadSound(tag,sounds.TYPE_SND_INTERNAL);
			}
		}
		
		/**	
		 *	Plays a random music loop.
		 **/
		
		public function playRandom() {
			var index:int = Math.floor(Math.random()*buttons.length);
			useButton(buttons[index]);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected function initMusicButtons():void {
			addButton("yellow_btn","yellow over",YELLOW_SONG);
			addButton("green_btn","green over",GREEN_SONG);
			addButton("red_btn","red over",RED_SONG);
		}
		
		/**	
		 *	Uses the target's properties to play a music loop.
		 *	param		clip			MovieClip		Clip to be used.
		 **/
		
		protected function useButton(clip:MovieClip) {
			if(clip != null) {
				if("targetFrame" in clip) gotoAndStop(clip.targetFrame);
				if("musicID" in clip) {
					var sounds:SoundManager = SoundManager.instance;
					sounds.stopAllCurrentSounds();
					sounds.soundPlay(clip.musicID,true);
				}
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**	
		 *	This functions triggers when a button is clicked on.
		 **/
		
		protected function onButtonClick(ev:Event) {
			var clip:DisplayObjectContainer = ev.target as DisplayObjectContainer;
			if(clip != null) {
				var cont:DisplayObjectContainer = clip.parent;
				while(cont != null && cont != root) {
					if(cont == this) {
						if(clip is MovieClip) useButton(clip as MovieClip);
						return;
					}
					clip = cont;
					cont = cont.parent;
				}
			}
		}
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		protected function onMouseOut(ev:Event) {
			if(_helpPopUp != null) _helpPopUp.visible = false;
		}
		
		/**	
		 *	This functions triggers the mouse-over animation.
		 **/
		
		protected function onMouseOver(ev:Event) {
			if(_helpPopUp != null) _helpPopUp.visible = true;
		}
		
		/**	
		 *	This functions triggers the mouse-out animation on the mute buttons.
		 **/
		
		protected function onMuteOut(ev:Event) {
			if(_helpPopUp != null) _helpPopUp.gotoAndPlay("main");
		}
		
		/**	
		 *	This functions triggers the mouse-over animation on the mute buttons.
		 **/
		
		protected function onMuteOver(ev:Event) {
			if(_helpPopUp != null) _helpPopUp.gotoAndPlay("mute");
		}
		
		/**	
		 *	This functions triggers when the user wants to stop the current music.
		 **/
		
		protected function onStopMusic(ev:Event) {
			var sounds:SoundManager = SoundManager.instance;
			sounds.stopAllCurrentSounds();
			gotoAndPlay("off");
		}
		
	}
	
}