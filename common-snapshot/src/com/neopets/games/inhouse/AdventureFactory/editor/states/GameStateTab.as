
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.editor.states.GameStatePanel;
	import com.neopets.games.inhouse.AdventureFactory.editor.GameScreenTab;
	
	import com.neopets.util.display.DisplayUtils;
	
	/**
	 *	This class lets the player control what stage of game creation they're at.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.23.2010
	 */
	 
	public class GameStateTab extends GameScreenTab
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _mainButton:NeopetsButton;
		protected var _translatedLabel:String;
		protected var _numField:TextField;
		protected var _tabNumber:Number;
		protected var _stateID:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameStateTab():void{
			super();
			_mainButton = getChildByName("button_mc") as NeopetsButton;
			_numField = getChildByName("num_txt") as TextField;
			selectionEvent = GameStatePanel.STATE_SELECTED;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get tabNumber():Number { return _tabNumber; }
		
		public function set tabNumber(val:Number) {
			_tabNumber = val;
			if(_numField != null) _numField.text = String(_tabNumber);
		}
		
		override public function get selectionData():Object { return _stateID; }
		
		public function get stateID():String { return _stateID; }
		
		public function set stateID(id:String) {
			_stateID = id;
			// get translated text
			if(_stateID != null) {
				var translator:TranslationManager = TranslationManager.instance;
				_translatedLabel = translator.getTranslationOf("IDS_STATE_TAB_OPENNER");
				_translatedLabel += translator.getTranslationOf("IDS_"+_stateID+"_TAB");
				_translatedLabel += "</font></p>";
			} else _translatedLabel = "";
			// apply translation to button
			if(_mainButton != null) _mainButton.setText(_translatedLabel);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
