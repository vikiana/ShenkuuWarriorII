
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
	 
	public class FlagsOfFrenzyPrizesDisplay extends ListenerTextClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const IDS_BASE_TEXT:String = "IDS_ITEMS_TOTAL";
		public static const IDS_DEFAULT_TEXT:String = "%p Items";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _shownValue:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FlagsOfFrenzyPrizesDisplay():void{
			super();
			// set up base text
			setBaseText(IDS_BASE_TEXT,IDS_DEFAULT_TEXT);
			// set up listeners
			addParentListener(FlagsOfFrenzyGame,FlagsOfFrenzyGame.GAME_STARTED,onGameShown);
			addParentListener(FlagsOfFrenzyGame,FlagsOfFrenzyGame.ITEM_GAINED,onItemGained);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get shownValue():int { return _shownValue; }
		
		public function set shownValue(val:int) {
			if(_shownValue != val) {
				_shownValue = val;
				updateText();
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the menu is shown, reset our count.
		
		protected function onGameShown(ev:Event) {
			shownValue = 0;
		}
		
		// When the menu is shown, reset the countdown.
		
		protected function onItemGained(ev:CustomEvent) {
			shownValue = _shownValue + 1;
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
