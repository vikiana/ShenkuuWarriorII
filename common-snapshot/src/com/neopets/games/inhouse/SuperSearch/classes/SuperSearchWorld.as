
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.LevelSet;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchLevel;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	
	/**
	 *	This class is an extension of the basic game screen to allow for dispatcher variables.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  3.10.2010
	 */
	 
	public class SuperSearchWorld extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const LEVEL_READY:String = "world_level_ready";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// view area variables
		protected var _viewBounds:Rectangle;
		protected var _viewCenter:Point;
		// initialization variables
		protected var _playerClass:String;
		// level variables
		protected var _levelClip:LevelSet;
		protected var _scrollLimits:Rectangle;
		protected var _scrollCenter:Point;
		// player variables
		protected var _playerClip:MovieClip;
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchWorld():void {
			super();
			// initialize variables
			_viewCenter = new Point();
			_scrollLimits = new Rectangle();
			_scrollCenter = new Point();
			_playerClass = "PlayerMC";
			// search for components
			viewBounds = getChildBounds("bounds_mc");
			levelClip = getChildByName("levels_mc") as LevelSet;
			// set up links to game screen
			useParentDispatcher(SuperSearch_GameScreen);
			// set up listeners
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.GAME_STARTED,onGameStarted);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.RESTART_LEVEL,onRestartLevel);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.NEXT_LEVEL,onNextLevel);
			addEventListener(SuperSearchPlayer.MOVEMENT_EVENT,onPlayerMoved);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get levelClip():LevelSet { return _levelClip; }
		
		public function set levelClip(clip:LevelSet) {
			_levelClip = clip;
			if(_levelClip != null) {
				// use level bounds to get scroll limits
				calcScrollLimits();
			}
		}
		
		public function get levelNumber():int {
			var screen:SuperSearch_GameScreen = gameScreen;
			if(screen != null) return screen.levelNumber;
			else return 1; // use level 1 as default level.
		}
		
		public function get playerClass():String { return _playerClass; }
		
		public function get gameScreen():SuperSearch_GameScreen {
			if(defaultDispatcher != null && defaultDispatcher is SuperSearch_GameScreen) {
				return defaultDispatcher as SuperSearch_GameScreen;
			}
			return DisplayUtils.getAncestorInstance(this,SuperSearch_GameScreen) as SuperSearch_GameScreen;
		}
		
		public function get viewBounds():Rectangle { return _viewBounds; }
		
		public function set viewBounds(rect:Rectangle) {
			_viewBounds = rect;
			if(_viewBounds != null) {
				_viewCenter.x = (_viewBounds.left + _viewBounds.right) / 2;
				_viewCenter.y = (_viewBounds.top + _viewBounds.bottom) / 2;
				calcScrollLimits();
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function combines getChildByName with getBounds.
		
		public function getChildBounds(id:String):Rectangle {
			var child:DisplayObject = getChildByName(id);
			if(child != null) return child.getBounds(this);
			return null;
		}
		
		// Use this function to move the level and player back to start positions.
		
		public function resetPositions():void {
			if(_levelClip != null) {
				// recenter the level
				_levelClip.x = _scrollCenter.x;
				_levelClip.y = _scrollCenter.y;
				// have the level recenter the player
				var level:SuperSearchLevel = _levelClip.currentLevel;
				if(level != null) level.centerPlayer();
			}
		}
		
		// initilize the next level
		
		public function startLevel() {
			if(_levelClip != null) {
				// go to proper level frame
				_levelClip.gotoLevel(levelNumber);
				// check each frame until the level has initialized
				addEventListener(Event.ENTER_FRAME,onLevelCheck);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the game starts, load our first level.
		
		protected function onGameStarted(ev:Event) {
			startLevel();
		}
		
		// This function sends out a level ready event once the new level has had a frame to load.
		
		protected function onLevelCheck(ev:Event) {
			if(_levelClip != null) {
				// check if the level has loaded yet
				var level:SuperSearchLevel = _levelClip.currentLevel;
				if(level != null) {
					calcScrollLimits(); // recalculate how far the level can be moved
					// move level and player into start positions
					resetPositions();
					// let the level initialize it's player and pick ups
					level.initLevel();
					// let listeners know the level is ready
					broadcast(LEVEL_READY,level);
					// turn off the enter frame listener
					removeEventListener(Event.ENTER_FRAME,onLevelCheck);
				}
			} else {
				// if we somehow lost our level clip, turn off the enter frame listener
				removeEventListener(Event.ENTER_FRAME,onLevelCheck);
			}
		}
		
		// Use this function to move on to the next level.
		
		protected function onNextLevel(ev:Event) {
			startLevel();
		}
		
		// When the player moves, try shifting the level so they stay in the middle of the view area.
		
		protected function onPlayerMoved(ev:BroadcastEvent) {
			// find the player
			var player:SuperSearchPlayer = ev.sender as SuperSearchPlayer;
			if(player == null) return;
			// get the player's position relative to us.
			var player_pt:Point = player.localToGlobal(new Point());
			player_pt = globalToLocal(player_pt);
			// horizontally shift level
			var to_center:Number = _viewCenter.x - player_pt.x;
			if(to_center > 0) {
				// if left of center, move level right
				_levelClip.x = Math.min(_levelClip.x + to_center,_scrollLimits.right);
			} else {
				// if right of center, move level left
				if(to_center < 0) {
					_levelClip.x = Math.max(_levelClip.x + to_center,_scrollLimits.left);
				}
			}
			// vertically shift level
			to_center = _viewCenter.y - player_pt.y;
			if(to_center > 0) {
				// if left of center, move level right
				_levelClip.y = Math.min(_levelClip.y + to_center,_scrollLimits.bottom);
			} else {
				// if right of center, move level left
				if(to_center < 0) {
					_levelClip.y = Math.max(_levelClip.y + to_center,_scrollLimits.top);
				}
			}
		}
		
		// When a level restart is called, restart the level.
		
		protected function onRestartLevel(ev:Event) {
			resetPositions();
			var level:SuperSearchLevel = _levelClip.currentLevel;
			broadcast(LEVEL_READY,level);
			// check each frame until the level has initialized
			//addEventListener(Event.ENTER_FRAME,onLevelCheck);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function is used to update the level's scroll bounds.
		
		protected function calcScrollLimits():void {
			// make sure we have bounds and a level
			if(_levelClip == null || _viewBounds == null) return;
			// get the level's bounds
			var level_bounds:Rectangle;
			var level:SuperSearchLevel = _levelClip.currentLevel;
			if(level != null) {
				var bounding_obj:DisplayObject = level.boundingObject;
				level_bounds = bounding_obj.getBounds(this);
			} else level_bounds = _levelClip.getBounds(this);
			// set up scroll limits
			_scrollLimits.left = _levelClip.x - level_bounds.right + _viewBounds.right; // from x - (lb_right - vb_right)
			_scrollLimits.right = _levelClip.x + _viewBounds.left - level_bounds.left;
			_scrollLimits.top = _levelClip.y - level_bounds.bottom + _viewBounds.bottom; // from y - (lb_bottom - vb_bottom)
			_scrollLimits.bottom = _levelClip.y + _viewBounds.top - level_bounds.top;
			// set scroll center point
			_scrollCenter.x = (_scrollLimits.left + _scrollLimits.right) / 2;
			_scrollCenter.y = (_scrollLimits.top + _scrollLimits.bottom) / 2;
		}
		 
	}
	
}
