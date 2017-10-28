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
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class ComboIcon extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const CLICK_SOUND:String = "Magic_Spell18";
		public static const OFF_FRAME:String = "off";
		public static const OVER_FRAME:String = "over";
		public static const FADE_IN_FRAME:String = "fade_in";
		public static const FADE_OUT_FRAME:String = "fade_out";
		public static const CLICKED_FRAME:String = "selected";
		public static const MOUSE_OVER:String = "ComboIcon_mouse_over";
		public static const MOUSE_OUT:String = "ComboIcon_mouse_out";
		public static const ICON_SELECTED:String = "ComboIcon_selected";
		public static const ANIMATION_DONE:String = "ComboIcon_animation_done";
		// protected variables
		protected var _clickable:Boolean;
		protected var _comboID:int;
		// public variables
		public var neoContentID:int = -1;
		public var scriptName:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ComboIcon():void {
			clickable = true;
			// set up sounds
			var sounds:SoundManager = SoundManager.instance;
			if(!sounds.checkSoundObj(CLICK_SOUND)) {
				sounds.loadSound(CLICK_SOUND,sounds.TYPE_SND_INTERNAL);
			}
			// set up global listeners
			EventHub.addEventListener(MOUSE_OVER,onIconMouseOver);
			EventHub.addEventListener(MOUSE_OUT,onIconMouseOut);
			EventHub.addEventListener(ICON_SELECTED,onComboStarted);
			EventHub.addEventListener(ComboMachine.ANIMATION_DONE,onComboDone);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get clickable():Boolean { return _clickable; }
		
		public function set clickable(bool:Boolean) {
			if(_clickable != bool) {
				_clickable = bool;
				if(_clickable) {
					// set up listeners
					addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					addEventListener(MouseEvent.CLICK,onClick);
				} else {
					// disable listeners
					removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					removeEventListener(MouseEvent.CLICK,onClick);
				}
			}
		}
		
		public function get comboID():int { return _comboID; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**	
		 *	Use this to signal the end of the selection animation.
		 **/
		
		protected function onSelectionDone() {
			stop();
			EventHub.broadcast(new Event(ANIMATION_DONE),this);
		}
		
		/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		public function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				try
				{ 
					ExternalInterface.call("sendADLinkCall", scriptID) ;
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
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
		 *	This functions triggers the mouse-our animation.
		 **/
		
		protected function onClick(ev:Event) {
			clickable = false;
			EventHub.broadcast(new Event(ICON_SELECTED),this);
			gotoAndPlay(CLICKED_FRAME);
			// play sound
			var sounds:SoundManager = SoundManager.instance;
			sounds.soundPlay(CLICK_SOUND);
			// apply tracking
			if(neoContentID >= 0) NeoTracker.instance.trackNeoContentID(neoContentID);
			if(scriptName != null) runJavaScript(scriptName);
		}
		
		/**	
		 *	This functions synches the mouse-out animation with others in our combo.
		 **/
		
		protected function onIconMouseOut(ev:RelayedEvent) {
			if(ev != null) {
				// make sure the ev is coming in from an outside source
				var src:Object = ev.source;
				if(src != null && src != this) {
					// check if we're part of the combo being triggered
					if(src.comboID == _comboID) gotoAndPlay(OFF_FRAME);
				}
			}
		}
		
		/**	
		 *	This functions synches the mouse-over animation with others in our combo.
		 **/
		
		protected function onIconMouseOver(ev:RelayedEvent) {
			if(ev != null) {
				// make sure the ev is coming in from an outside source
				var src:Object = ev.source;
				if(src != null && src != this) {
					// check if we're part of the combo being triggered
					if(src.comboID == _comboID) gotoAndPlay(OVER_FRAME);
				}
			}
		}
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		protected function onMouseOut(ev:Event) {
			gotoAndPlay(OFF_FRAME);
			EventHub.broadcast(new Event(MOUSE_OUT),this);
		}
		
		/**	
		 *	This functions triggers the mouse-over animation.
		 **/
		
		protected function onMouseOver(ev:Event) {
			gotoAndPlay(OVER_FRAME);
			EventHub.broadcast(new Event(MOUSE_OVER),this);
		}
		
		/**	
		 *	This function is trigger when any combo icon is clicked on.
		 **/
		
		protected function onComboStarted(ev:RelayedEvent) {
			if(ev != null) {
				clickable = false;
				// make sure the ev is coming in from an outside source
				var src:Object = ev.source;
				if(src != null && src != this) {
					// check if we're part of the combo being triggered
					if(src.comboID == _comboID) gotoAndPlay(CLICKED_FRAME);
					else gotoAndPlay(FADE_OUT_FRAME);
				}
			}
		}
		
		/**	
		 *	This function is triggered when the current combo animation ends.
		 **/
		
		protected function onComboDone(ev:Event) {
			gotoAndPlay(FADE_IN_FRAME);
			clickable = true;
		}
		
	}
	
}