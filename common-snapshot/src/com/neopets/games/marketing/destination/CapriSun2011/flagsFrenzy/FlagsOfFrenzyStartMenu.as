
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.util.MenuClip;
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.FlagsOfFrenzyShell;
	
	/**
	 *	This class handles the "start the game" screen.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.23.2010
	 */
	 
	public class FlagsOfFrenzyStartMenu extends MenuClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _startButton:InteractiveObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FlagsOfFrenzyStartMenu():void{
			super();
			// set up buttons
			setAsStartButton(getChildByName("start_btn") as InteractiveObject);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to make an interactive object act as a start button.
		
		public function setAsStartButton(dobj:InteractiveObject) {
			if(dobj == null) return;
			dobj.addEventListener(MouseEvent.CLICK,onStartButtonClick);
			dobj.addEventListener(Event.REMOVED,onStartButtonRemoved);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function is triggered when a designated start button is clicked on.
		
		protected function onStartButtonClick(ev:Event) {
			callMenu(FlagsOfFrenzyShell.GAME_MENU);
		}
		
		// This function removes listeners from a start button when it's taken off stage.
		
		protected function onStartButtonRemoved(ev:Event) {
			var dobj:InteractiveObject = ev.target as InteractiveObject;
			if(dobj != null) {
				dobj.removeEventListener(MouseEvent.CLICK,onStartButtonClick);
				dobj.removeEventListener(Event.REMOVED,onStartButtonRemoved);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
