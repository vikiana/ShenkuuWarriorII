
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.GameScreenClip;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.MapGrid;
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.HeroClip;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.GoalClip;
	import com.neopets.games.inhouse.AdventureFactory.editor.grid.tools.ItemStickerTool;
	import com.neopets.games.inhouse.AdventureFactory.editor.states.GameStatePanel;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	This class acts as the container for the game world.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.10.2010
	 */
	 
	public class LevelPane extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		// action request constants
		public static const SET_BACKGROUND:String = "LevelPane_set_background";
		public static const CHANGE_HERO:String = "LevelPane_change_hero";
		public static const CHANGE_GOAL:String = "LevelPane_change_goal";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var gridStates:Array;
		protected var _gridShown:Boolean;
		// component variables
		protected var _world:GameWorld;
		protected var _grid:MapGrid;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LevelPane():void{
			super();
			// check for components
			world = getChildByName("world_mc") as GameWorld;
			grid = getChildByName("grid_mc") as MapGrid;
			// set up grid states
			initGridStates();
			gridShown = false; // start hidden by default
			// listen for game screen events
			addParentListener(AdventureFactory_GameScreen,GameStatePanel.STATE_SELECTED,onStateChange);
			addParentListener(AdventureFactory_GameScreen,SET_BACKGROUND,onSetBackground);
			addParentListener(AdventureFactory_GameScreen,CHANGE_HERO,onChangeHero);
			addParentListener(AdventureFactory_GameScreen,CHANGE_GOAL,onChangeGoal);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get grid():MapGrid { return _grid; }
		
		public function set grid(map:MapGrid) {
			_grid = map;
			if(_grid != null) {
				_grid.world = _world;
			}
		}
		
		public function get gridShown():Boolean { return _gridShown; }
		
		public function set gridShown(bool:Boolean) {
			if(_gridShown != bool) {
				_gridShown = bool;
				if(_gridShown) gotoAndPlay("show_grid");
				else gotoAndPlay("hide_grid");
			}
		}
		
		public function get world():GameWorld { return _world; }
		
		public function set world(gw:GameWorld) {
			_world = gw;
			if(_world != null) {
				if(_grid != null) _grid.world = _world;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onChangeGoal(ev:CustomEvent) {
			if(_world != null) {
				var class_id:String = String(ev.oData);
				// if the world already has a goal, swap it
				if(_world.goalClass != null) _world.goalClass = class_id;
				else {
					// otherwise, set up a one-shot item placement tool
					if(_grid != null) _grid.setTool(ItemStickerTool,class_id);
				}
			}
		}
		
		protected function onChangeHero(ev:CustomEvent) {
			if(_world != null) {
				var class_id:String = String(ev.oData);
				// if the world already has a hero, swap it
				if(_world.heroClass != null) _world.heroClass = class_id;
				else {
					// otherwise, set up a one-shot item placement tool
					if(_grid != null) _grid.setTool(ItemStickerTool,class_id);
				}
			}
		}
		
		protected function onSetBackground(ev:CustomEvent) {
			if(_world != null) { _world.backgroundClass = String(ev.oData); }
		}
		
		protected function onStateChange(ev:CustomEvent) {
			if(ev == null) return;
			// check whether the grid should be shown
			gridShown = (gridStates.indexOf(ev.oData) >= 0);
			// reset the grid tool
			_grid.useDefaultTool();
			// check if the game should be started
			if(_world != null) {
				if(ev.oData == GameStatePanel.TEST_STATE) {
					_world.recordState();
					_world.restart();
				} else _world.reset();
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Initialization Functions
		
		public function initGridStates():void {
			gridStates = new Array();
			gridStates.push(GameStatePanel.HERO_STATE);
			gridStates.push(GameStatePanel.GOAL_STATE);
			gridStates.push(GameStatePanel.LEVEL_DESIGN_STATE);
		}
		
	}
	
}