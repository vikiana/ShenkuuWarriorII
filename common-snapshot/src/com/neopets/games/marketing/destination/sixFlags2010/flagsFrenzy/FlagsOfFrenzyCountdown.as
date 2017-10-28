
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.ListenerTextClip;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.FlagsOfFrenzyGame;
	
	/**
	 *	This class handles the countdown to the end of the game.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class FlagsOfFrenzyCountdown extends ListenerTextClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const IDS_BASE_TEXT:String = "IDS_COUNTDOWN";
		public static const IDS_DEFAULT_TEXT:String = "30";
		public static const COUNTDOWN_DONE:String = "FlagsOfFrenzyCountdown_done";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _countdownTimer:Timer;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FlagsOfFrenzyCountdown():void{
			// initialize timer
			_countdownTimer = new Timer(1000,30);
			_countdownTimer.addEventListener(TimerEvent.TIMER,updateText);
			_countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerDone);
			// set up base text
			super();
			setBaseText(IDS_BASE_TEXT,IDS_DEFAULT_TEXT);
			// set up listeners
			addParentListener(FlagsOfFrenzyGame,FlagsOfFrenzyGame.GAME_STARTED,onGameShown);
			useParentDispatcher(FlagsOfFrenzyGame);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get countdownTimer():Timer { return _countdownTimer; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the menu is shown, reset the countdown.
		
		protected function onGameShown(ev:Event) {
			_countdownTimer.reset();
			_countdownTimer.start();
		}
		
		//	This function makes sure our displayed bitmap matches our text.
		
		override public function updateText(ev:Event=null):void {
			if(_textField == null) return;
			// check time left
			var sec_left:int = _countdownTimer.repeatCount - _countdownTimer.currentCount;
			
			
			// check if we have base text
			
			if(_baseText != null && _baseText.length > 0)
			{
				_textField.htmlText = String(sec_left);
			}
			/*
			if(_baseText != null && _baseText.length > 0) {
				_textField.htmlText = _baseText.replace("%t",sec_left);
			} else {
				_textField.htmlText = String(sec_left);
			}
			*/
		}
		
		// When our timer finishes, let listneres know.
		
		protected function onTimerDone(ev:Event) {
			broadcast(COUNTDOWN_DONE);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
