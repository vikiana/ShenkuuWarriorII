
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.ScoreManager;
	
	import com.neopets.projects.np9.system.NP9_Evar;
	
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	import com.neopets.games.inhouse.SuperSearch.classes.EndOfLevelPrompt;
	import com.neopets.games.inhouse.SuperSearch.classes.util.keyboard.KeyboardManager;
	
	/**
	 *	This class is an extension of the basic game screen to allow for dispatcher variables.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  3.10.2010
	 */
	 
	public class SuperSearch_GameScreen extends GameScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const GAME_STARTED:String = "game_started";
		public static const RESTART_LEVEL:String = "restart_level";
		public static const GAME_OVER:String = "game_over";
		public static const ITEM_NEEDED:String = "GameScreen_requests_item";
		public static const LEVEL_CLEARED:String = "level_cleared";
		public static const CLEAR_PROMPT:String = "clear_prompt";
		public static const NEXT_LEVEL:String = "next_level";
		public static const SCORE_CHANGED:String = "score_changed";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _livesVar:NP9_Evar;
		protected var _levelVar:NP9_Evar;
		protected var _itemsVar:NP9_Evar;
		protected var _levelDeathsVar:NP9_Evar; // player deaths this level
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearch_GameScreen():void
		{
			super();
			// initialize variables
			_livesVar = new NP9_Evar(0);
			_levelVar = new NP9_Evar(0);
			_itemsVar = new NP9_Evar(0);
			_levelDeathsVar = new NP9_Evar(0);
			// add listeners to menu manager
			var menus:MenuManager = MenuManager.instance;
			menus.addEventListener(menus.MENU_NAVIGATION_EVENT,onMenuNavigation);
			// set up the keyboard listeners when we're added to the stage
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			addEventListener(SuperSearchPlayer.LIFE_LOST,onPlayerDeath);
			addEventListener(SuperSearchPlayer.ITEM_COLLECTED,onItemCollected);
			addEventListener(EndOfLevelPrompt.PROMPT_CLEARED,onLevelPromptDone);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get itemsNeeded():int { return int(Number(_itemsVar.show())); }
		
		public function get levelNumber():int { return int(Number(_levelVar.show())); }
		
		public function get livesNumber():int { return int(Number(_livesVar.show())); }
		
		public function get perfectBonus():int {
			// only return a "perfect game" bonus if there are no deaths.
			if(Number(_levelDeathsVar.show()) <= 0) {
				return 5 * numItemsForLevel(levelNumber);
			}
			return 0;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use these functions to change the score and let listeners know.
		
		public function changeScoreBy(val:Number):void {
			var score_manager:ScoreManager = ScoreManager.instance;
			score_manager.changeScore(val);
			dispatchEvent(new Event(SCORE_CHANGED));
		}
		
		public function changeScoreTo(val:Number):void {
			var score_manager:ScoreManager = ScoreManager.instance;
			score_manager.changeScoreTo(val);
			dispatchEvent(new Event(SCORE_CHANGED));
		}
		
		// Use this function to calculate the number of items needed to complete the target level.
		
		public function numItemsForLevel(lvl_num:int):int {
			return 4 * lvl_num;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When added to stage, set up our keyboard listener.
		
		protected function onAdded(ev:Event) {
			if(ev.target == this) {
				// set up keyboard manager
				var keys:KeyboardManager = KeyboardManager.instance;
				keys.eventSource = stage;
				// remove listeners
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		// When an item is collected, update the number of items still needed.
		
		protected function onItemCollected(ev:Event) {
			// update our score
			changeScoreBy(25);
			// check if we still have items needed
			_itemsVar.changeBy(-1);
			var items_left:Number = Number(_itemsVar.show());
			if(items_left > 0) {
				dispatchEvent(new Event(ITEM_NEEDED));
			} else {
				// apply "perfect" bonus, if any
				changeScoreBy(perfectBonus);
				// let listeners know the level was cleared
				dispatchEvent(new Event(LEVEL_CLEARED));
			}
		}
		
		// When the level prompt clears, start up the next level.
		
		protected function onLevelPromptDone(ev:Event) {
			trace("ON LEVEL PROMPT DONE");
			// update level number
			_levelVar.changeBy(1);
			// update items needed to clear the level
			var level_num:int = int(Number(_levelVar.show()));
			_itemsVar.changeTo(numItemsForLevel(level_num));
			// reset deaths this level
			_levelDeathsVar.changeTo(0);
			// let listeners know the new level is ready
			dispatchEvent(new Event(NEXT_LEVEL));
		}
		
		// When menu navigation happens check if we've moved to this menu.
		
		protected function onMenuNavigation(ev:CustomEvent) {
			var nav_id:String = ev.oData.MENU;
			if(nav_id == mID) {
				trace("NAV TO GAME SCREEN?");
				changeScoreTo(0);
				_livesVar.changeTo(3);
				_levelVar.changeTo(1);
				_itemsVar.changeTo(numItemsForLevel(1));
				_levelDeathsVar.changeTo(0);
				dispatchEvent(new Event(GAME_STARTED));
			} else {				
				dispatchEvent(new Event(CLEAR_PROMPT));
				dispatchEvent(new Event(GAME_OVER));
			}
		}
		
		// When the player loses a life, check for game over.
		
		protected function onPlayerDeath(ev:Event) {
			_livesVar.changeBy(-1);
			_levelDeathsVar.changeBy(1);
			if(_livesVar.show() > 0) {
				dispatchEvent(new Event(RESTART_LEVEL));
			} else gameOver();
		}
		
		// When taken off stage, clear all listeners.
		
		protected function onRemoved(ev:Event) {
			trace("ON REMOVED");
			if(ev.target == this) {
				// remove listeners
				var menus:MenuManager = MenuManager.instance;
				menus.removeEventListener(menus.MENU_NAVIGATION_EVENT,onMenuNavigation);
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
				removeEventListener(SuperSearchPlayer.LIFE_LOST,onPlayerDeath);
				removeEventListener(SuperSearchPlayer.ITEM_COLLECTED,onItemCollected);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Uwe this function to end the game.
		
		protected function gameOver():void {
			dispatchEvent(new Event(GAME_OVER));
			// navigate to game over screen
			var menus:MenuManager = MenuManager.instance;
			menus.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
		}
		 
	}
	
}
