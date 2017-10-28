
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.util.ListenerTextClip;
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.FlagsOfFrenzyGame;
	
	import com.neopets.util.events.CustomEvent;
	
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
	 
	public class FlagsOfFrenzyPointDisplay extends ListenerTextClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const IDS_BASE_TEXT:String = "IDS_NP_TOTAL";
		public static const IDS_DEFAULT_TEXT:String = "%p NP";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _shownValue:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FlagsOfFrenzyPointDisplay():void{
			super();
			// set up base text
			setBaseText(IDS_BASE_TEXT,IDS_DEFAULT_TEXT);
			// set up listeners
			addParentListener(FlagsOfFrenzyGame,FlagsOfFrenzyGame.SCORE_CHANGED,onScoreChange);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the score changes, update our text.
		
		protected function onScoreChange(ev:CustomEvent) {
			_shownValue = int(ev.oData);
			updateText();
		}
		
		//	This function makes sure our displayed bitmap matches our text.
		
		override public function updateText(ev:Event=null):void {
			if(_textField == null) return;
			// check if we have base text
			if(_baseText != null && _baseText.length > 0) {
				_textField.htmlText = _baseText.replace("%p",_shownValue);
			} else {
				_textField.htmlText = String(_shownValue);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
