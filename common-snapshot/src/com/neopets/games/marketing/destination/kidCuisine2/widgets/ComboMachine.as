/**
 *	This class lets a movieclip mimic the mouse-over behaviour of a button.
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
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class ComboMachine extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const ANIMATION_DONE:String = "ComboMachine_animation_done";
		public static const SWIRL_SOUND:String = "Magic_Spell_Light1";
		public static const COMBO_SOUND:String = "fanfare";
		// protected variables
		protected var _comboID:int;
		protected var waitTimer:Timer;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ComboMachine():void {
			EventHub.addEventListener(ComboIcon.ANIMATION_DONE,onComboReady);
			// set up sounds
			var sounds:SoundManager = SoundManager.instance;
			if(!sounds.checkSoundObj(SWIRL_SOUND)) {
				sounds.loadSound(SWIRL_SOUND,sounds.TYPE_SND_INTERNAL);
			}
			if(!sounds.checkSoundObj(COMBO_SOUND)) {
				sounds.loadSound(COMBO_SOUND,sounds.TYPE_SND_INTERNAL);
			}
			// set up wait time
			waitTimer = new Timer(3000,1);
			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onWaitDone);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get comboID():int { return _comboID; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	This functions plays the combo completion sound effect.
		 **/
		
		public function playCombo() {
			var sounds:SoundManager = SoundManager.instance;
			sounds.soundPlay(COMBO_SOUND);
		}
		
		/**	
		 *	This functions plays the swirling liquid sound effect.
		 **/
		
		public function playSwirl() {
			var sounds:SoundManager = SoundManager.instance;
			sounds.soundPlay(SWIRL_SOUND);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**	
		 *	Use this to signal the end of the combination animation.
		 **/
		
		protected function onComboDone() {
			stop();
			// broadcast the event
			EventHub.broadcast(new Event(ANIMATION_DONE),this);
			// hold the character image for a while
			waitTimer.start();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		protected function onComboReady(ev:RelayedEvent) {
			if(ev != null) {
				waitTimer.reset();
				gotoAndPlay("play");
				// extract the combo type
				var targ:Object = ev.source;
				if(targ != null) _comboID = targ.comboID;
			}
		}
		
		/**	
		 *	This functions is triggered when we're done showing off the new combo.
		 **/
		
		protected function onWaitDone(ev:Event) {
			waitTimer.reset();
			gotoAndStop("hold");
		}
		
	}
	
}