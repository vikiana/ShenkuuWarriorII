
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.states
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.BroadcasterClip;
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.editor.ImageRow;
	import com.neopets.games.inhouse.AdventureFactory.editor.options.SelectionPane;
	import com.neopets.games.inhouse.AdventureFactory.editor.states.GameStateTab;
	
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
	 
	public class GameStatePanel extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		// Editor State Constants
		public static const STATE_SELECTED:String = "GameStatePanel_state_selected";
		public static const GAME_STARTER_STATE:String = "GAME_STARTER";
		public static const BACKGROUND_STATE:String = "BACKGROUND";
		public static const HERO_STATE:String = "HERO";
		public static const GOAL_STATE:String = "GOAL";
		public static const LEVEL_DESIGN_STATE:String = "LEVEL_DESIGN";
		public static const TEST_STATE:String = "TEST";
		public static const SUBMIT_STATE:String = "SUBMIT";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _tabs:ImageRow;
		protected var _nextButton:NeopetsButton;
		protected var _previousButton:NeopetsButton;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameStatePanel():void{
			super();
			// set up tabs
			tabs = new ImageRow();
			loadTabs();
			// set up buttons
			nextButton = getChildByName("next_mc") as NeopetsButton;
			previousButton = getChildByName("prev_mc") as NeopetsButton;
			// send broadcasts through game screen
			useParentDispatcher(AdventureFactory_GameScreen);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get nextButton():NeopetsButton { return _nextButton; }
		
		public function set nextButton(btn:NeopetsButton) {
			// clear previous button
			if(_nextButton != null) {
				_nextButton.removeEventListener(MouseEvent.CLICK,onNextTab);
			}
			// set new button
			_nextButton = btn;
			if(_nextButton != null) {
				var translation:String = TranslationManager.instance.getTranslationOf("IDS_BTN_NEXT");
				_nextButton.setText(translation);
				_nextButton.addEventListener(MouseEvent.CLICK,onNextTab);
			}
		}
		
		public function get previousButton():NeopetsButton { return _previousButton; }
		
		public function set previousButton(btn:NeopetsButton) {
			// clear previous button
			if(_previousButton != null) {
				_previousButton.removeEventListener(MouseEvent.CLICK,onPreviousTab);
			}
			// set new button
			_previousButton = btn;
			if(_previousButton != null) {
				var translation:String = TranslationManager.instance.getTranslationOf("IDS_BTN_BACK");
				_previousButton.setText(translation);
				_previousButton.addEventListener(MouseEvent.CLICK,onPreviousTab);
			}
		}
		
		public function get tabNumber():int {
			// search for the currently selected tab
			if(_tabs != null && _tabs.numChildren > 0) {
				var tab:GameStateTab;
				for(var i:int = 0; i < _tabs.numChildren; i++) {
					tab = _tabs.getChildAt(i)  as GameStateTab;
					if(tab != null && tab.selected) return i;
				}
			}
			return -1;
		}
		
		public function set tabNumber(val:int) {
			if(_tabs == null) return;
			// search for new tab
			if(val >= 0 && val < tabs.numChildren) {
				var tab:GameStateTab = tabs.getChildAt(val) as GameStateTab;
				if(tab != null) tab.selected = true;
			}
		}
		
		public function get tabs():ImageRow { return _tabs; }
		
		public function set tabs(row:ImageRow) {
			if(_tabs != row) {
				_tabs = row;
				if(_tabs != null) {
					addChild(_tabs);
					var tab_mask:DisplayObject = getChildByName("tab_mask_mc");
					_tabs.alignWith(tab_mask);
					_tabs.mask = tab_mask;
					_tabs.spacing = 8;
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public function onNextTab(ev:Event=null) {
			if(tabs == null) return; // make sure we have tabs
			// try moving to next index
			var ni:int = tabNumber + 1;
			if(ni < tabs.numChildren) tabNumber = ni;
		}
		
		public function onPreviousTab(ev:Event=null) {
			if(tabs == null) return; // make sure we have tabs
			// try moving to next index
			var ni:int = tabNumber - 1;
			if(ni >= 0) tabNumber = ni;
		}
		
		// Tab Listener Functions
		
		public function onFreshStart(ev:Event=null) {
			onNextTab(ev);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function sets up our state tabs.  Overwrite this to get a different set of tabs.
		 * @param	id		String		Game State ID of new tab.
		 */
		 
		protected function addTab(id:String) {
			if(_tabs == null) return; // make sure we have a place to add tabs
			// create the tab
			var tab:MovieClip = new GameStateTabMC();
			// add tab to container
			_tabs.addChild(tab);
			// set tab properties
			tab.stateID = id;
			tab.tabNumber = _tabs.numChildren;
		}
		
		/**
		 * @This function sets up our state tabs.  Overwrite this to get a different set of tabs.
		 */
		 
		protected function loadTabs() {
			if(_tabs == null) return; // make sure we have a place to add tabs
			// create tabs
			addTab(GAME_STARTER_STATE);
			addTab(BACKGROUND_STATE);
			addTab(HERO_STATE);
			addTab(GOAL_STATE);
			addTab(LEVEL_DESIGN_STATE);
			addTab(TEST_STATE);
			addTab(SUBMIT_STATE);
		}
		
	}
	
}
