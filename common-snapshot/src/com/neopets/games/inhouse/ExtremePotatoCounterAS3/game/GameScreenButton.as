
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.ExtremePotatoCounterAS3.game
{
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.ExtremePotatoCounterAS3.game.ExtremePotatoCounterGameScreen;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	
	/**
	 *	This class lets textfield clips load their text from the game screen object when added.
	 *  In flash 6 this was handled by attaching the text to root.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  1.05.2010
	 */
	 
	public class GameScreenButton extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _clickID:String;
		protected var clickFunction:Function;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameScreenButton():void {
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get clickID():String { return _clickID; }
		
		public function set clickID(tag:String) {
			_clickID = tag;
			updateClickFunction();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This function tries to set our text from the game screen object.
		 */
		
		public function updateClickFunction():void {
			// clear previous function
			if(clickFunction != null) {
				removeEventListener(MouseEvent.CLICK,clickFunction);
				clickFunction = null;
			}
			// set new function
			var menus:MenuManager = MenuManager.instance;
			var game:MovieClip = menus.getMenuScreen(MenuManager.MENU_GAME_SCR);
			if(game != null && _clickID != null) {
				if(_clickID in game) {
					var prop:Object = game[_clickID];
					if(prop is Function) {
						clickFunction = prop as Function;
						addEventListener(MouseEvent.CLICK,clickFunction);
					}
				} // end of property check
			} // end of null check
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
