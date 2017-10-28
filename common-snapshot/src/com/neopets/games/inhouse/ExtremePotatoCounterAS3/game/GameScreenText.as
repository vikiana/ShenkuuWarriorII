
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.ExtremePotatoCounterAS3.game
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
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
	 
	dynamic public class GameScreenText extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _textField:TextField;
		protected var _textID:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameScreenText():void {
			// search for a child textfield
			var child:DisplayObject;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is TextField) {
					_textField = child as TextField;
					break;
				}
			}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get textID():String { return _textID; }
		
		public function set textID(tag:String) {
			_textID = tag;
			updateText();
		}
		
		public function get textField():TextField { return _textField; }
		
		public function set textField(txt:TextField) {
			_textField = txt;
			updateText();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This function tries to set our text from the game screen object.
		 */
		
		public function updateText():void {
			// validate variables
			if(_textField == null || _textID == null) return;
			// try checking for the target property
			var menus:MenuManager = MenuManager.instance;
			var game:MovieClip = menus.getMenuScreen(MenuManager.MENU_GAME_SCR);
			if(game != null) {
				if(_textID in game) {
					_textField.htmlText = String(game[_textID]);
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
