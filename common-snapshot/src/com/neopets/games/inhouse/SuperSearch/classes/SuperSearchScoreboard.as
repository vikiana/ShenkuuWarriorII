
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.text.TextFunctions;
	
	/**
	 *	This class handles individual world game levels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.17.2010
	 */
	 
	public class SuperSearchScoreboard extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// components
		protected var _levelField:TextField;
		protected var _livesField:TextField;
		protected var _itemsField:TextField;
		protected var _scoreField:TextField;
		// counts
		protected var _currentItems:int;
		protected var _maxItems:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchScoreboard():void {
			super();
			// check for components
			_levelField = getChildByName("level_txt") as TextField;
			_livesField = getChildByName("lives_txt") as TextField;
			_itemsField = getChildByName("items_txt") as TextField;
			_scoreField = getChildByName("score_txt") as TextField;
			// set up listeners
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.GAME_STARTED,onGameStarted);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.NEXT_LEVEL,onNextLevel);
			addParentListener(SuperSearch_GameScreen,SuperSearchPlayer.LIFE_LOST,onPlayerDeath);
			addParentListener(SuperSearch_GameScreen,SuperSearchPlayer.ITEM_COLLECTED,onItemCollected);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.SCORE_CHANGED,onScoreChange);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get currentItems():int { return _currentItems; }
		
		public function set currentItems(val:int) {
			_currentItems = val;
			updateItemCount();
		}
		
		public function get gameScreen():SuperSearch_GameScreen {
			if(defaultDispatcher != null && defaultDispatcher is SuperSearch_GameScreen) {
				return defaultDispatcher as SuperSearch_GameScreen;
			}
			return DisplayUtils.getAncestorInstance(this,SuperSearch_GameScreen) as SuperSearch_GameScreen;
		}
		
		public function get maxItems():int { return _maxItems; }
		
		public function set maxItems(val:int) {
			_maxItems = val;
			updateItemCount();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//  Textfield Functions
		
		// Use this funcion to set our level text.
		
		public function setLevel(val:int):void {
			TextFunctions.setTranslatedText(_levelField,"IDS_LEVEL_NUMBER",[["%1",val]]);
		}
		
		// Use this funcion to set our lives text.
		
		public function setLives(val:int):void {
			TextFunctions.setTranslatedText(_livesField,"IDS_LIVES_NUMBER",[["%1",val]]);
		}
		
		// Use this funcion to keep our item counts up to date.
		
		public function updateItemCount():void {
			var replacements:Array = [["%1",_currentItems],["%2",_maxItems]];
			TextFunctions.setTranslatedText(_itemsField,"IDS_ITEMS_COLLECTED",replacements);
		}
		
		// Use this funcion to keep our score field up to date.
		
		public function updateScore():void {
			var score_manager:ScoreManager = ScoreManager.instance;
			var score_val:Number = score_manager.getValue();
			TextFunctions.setTranslatedText(_scoreField,"IDS_SCORE_VALUE",[["%1",score_val]]);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the game starts, update our fields.
		
		protected function onGameStarted(ev:Event) {
			var screen:SuperSearch_GameScreen = gameScreen;
			if(screen != null) {
				setLevel(screen.levelNumber);
				setLives(screen.livesNumber);
				_currentItems = 0;
				maxItems = screen.itemsNeeded;
			}
		}
		
		// When an item is collected, update our counts.
		
		protected function onItemCollected(ev:Event) {
			currentItems = _currentItems + 1;
		}
		
		// When the level changes, update our level text.
		
		protected function onNextLevel(ev:Event) {
			var screen:SuperSearch_GameScreen = gameScreen;
			if(screen != null) {
				setLevel(screen.levelNumber);
				_currentItems = 0;
				maxItems = screen.itemsNeeded;
			}
		}
		
		// When the player loses a life, update our lives text.
		
		protected function onPlayerDeath(ev:Event) {
			var screen:SuperSearch_GameScreen = gameScreen;
			if(screen != null) {
				setLives(screen.livesNumber);
			}
		}
		
		// When the score changes, update our text.
		
		protected function onScoreChange(ev:Event) {
			updateScore();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
