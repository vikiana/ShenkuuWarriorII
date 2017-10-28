
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchCollectedItem;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchObstacle;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchWorld;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.general.GeneralFunctions;
	
	/**
	 *	This class handles individual world game levels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  3.10.2010
	 */
	 
	public class SuperSearchLevel extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ITEM_PLACED:String = "Level_placed_item";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public var promptID:String;
		protected var _boundingObject:DisplayObject;
		protected var _levelBounds:Rectangle;
		protected var _pickUpTypes:Array;
		// added content variables
		protected var _playerClip:SuperSearchPlayer;
		protected var _obstacles:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchLevel():void {
			super();
			// initialize variables
			_pickUpTypes = new Array("Collectible_A","Collectible_B","Collectible_C");
			if(_obstacles == null) _obstacles = new Array();
			// check for a bounding area clip
			boundingObject = getChildByName("bounds_mc");
			// set up links to game screen
			useParentDispatcher(SuperSearch_GameScreen);
			// set up listeners
			addParentListener(SuperSearchWorld,SuperSearchPlayer.MOVEMENT_EVENT,onPlayerMoved);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.ITEM_NEEDED,onItemRequest);
			// try to maximize bitmap caching
			DisplayUtils.cacheImages(this);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get boundingObject():DisplayObject { return _boundingObject; }
		
		public function set boundingObject(dobj:DisplayObject) {
			// if the target is null, act as our own bounding area
			if(dobj != null) _boundingObject = dobj;
			else _boundingObject = this;
			// get the area's initial bounds
			_levelBounds = _boundingObject.getBounds(this);
		}
		
		public function get levelBounds():Rectangle { return _levelBounds; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function just returns a list of of names that follow a "prefix + number" convention.
		// It's primarily used to make it easier to build the pickUpTypes list when you have a lot 
		// of collectible item types.
		// param	prefix			String		Common prefix used by all elements in the series
		// param	first_val		int			Start of the series range
		// param	last_val		int			End of the series range
		
		public function buildNameSeries(prefix:String,first_val:int,last_val:int):Array {
			// check max and min values
			var max:int = Math.max(first_val,last_val);
			var min:int = Math.min(first_val,last_val);
			// build array
			var list:Array = new Array();
			for(var i:int = min; i <= max; i++) {
				list.push(prefix +  i);
			}
			return list;
		}
		
		// use this function to move the player to the center of the level.
		
		public function centerPlayer():void {
			if(_playerClip == null || _levelBounds == null) return;
			_playerClip.x = (_levelBounds.left + _levelBounds.right) / 2;
			_playerClip.y = (_levelBounds.top + _levelBounds.bottom) / 2;
			_playerClip.radianDirection = 0;
		}
		
		// This function removes any pre-existing collectible items from the level.
		
		public function clearItems():void {
			var item:SuperSearchCollectedItem;
			for(var i:int = numChildren - 1; i >= 0; i--) {
				item = getChildAt(i) as SuperSearchCollectedItem;
				if(item != null) {
					item.removeEventListener(Event.ENTER_FRAME,onPlacementFrame);
					removeChild(item);
				}
			}
		}
		
		// Use this function to add a player if one is missing.
		
		public function initPlayer():void {
			// if the player doesn't exist, try creating it now.
			if(_playerClip == null) {
				// try retrieving the player class from our world
				var class_name:String;
				var world:SuperSearchWorld = DisplayUtils.getAncestorInstance(this,SuperSearchWorld) as SuperSearchWorld;
				if(world != null) class_name = world.playerClass;
				else class_name = "PlayerMC";
				// create the new player instance
				_playerClip = GeneralFunctions.getDisplayInstance(class_name) as SuperSearchPlayer;
				if(_playerClip != null) addChild(_playerClip);
			}
			// if the player exists, finish initializing them.
			if(_playerClip != null) centerPlayer();
		}
		
		// Use this function to set up our player and items.
		
		public function initLevel() {
			initPlayer(); // add a player to the level
			clearItems(); // remove all previously created items
			spawnItem(); // spawn first pick up item
		}
		
		// This function adds the target obstacle to our list for later collision tests.
		
		public function registerObstacle(obstacle:SuperSearchObstacle):void {
			if(obstacle == null) return; // make sure this is a valid obstacle
			if(_obstacles == null) _obstacles = new Array(); // make sure we have an obstacle list
			if(_obstacles.indexOf(obstacle) < 0) _obstacles.push(obstacle);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When an item is requested, spawn a new item.
		
		protected function onItemRequest(ev:Event) {
			spawnItem();
		}
		
		// This function check if the attached pick up item is in a valid start position.
		
		protected function onPlacementFrame(ev:Event) {
			// check for a valid pick up item
			var item:SuperSearchCollectedItem = ev.target as SuperSearchCollectedItem;
			if(item == null) return;
			// check if the item overlaps the player
			if(item.intersects(_playerClip)) {
				randomizeChildPosition(item);
				return;
			}
			// check if the item overlaps an obstacle
			var obstacle:SuperSearchObstacle;
			for(var i:int = 0; i < _obstacles.length; i++) {
				obstacle = _obstacles[i];
				if(item.intersects(obstacle)) {
					randomizeChildPosition(item);
					return;
				}
			}
			// if we got this far, assume this is a safe placement location.
			item.show();
			item.removeEventListener(Event.ENTER_FRAME,onPlacementFrame);
			// let listeners know
			broadcast(ITEM_PLACED,item);
		}
		
		// If the player is in this level and moves out of bounds, they lose a life.
		
		protected function onPlayerMoved(ev:BroadcastEvent) {
			var player:SuperSearchPlayer = ev.sender as SuperSearchPlayer;
			// make sure we have a player and bounds
			if(player == null || _levelBounds == null) return;
			// relay the event to the game screen
			broadcast(SuperSearchPlayer.MOVEMENT_EVENT,player);
			// check if the target is a child of this level
			if(player.parent == this) {
				if(!_levelBounds.contains(player.x,player.y)) {
					//player.die();
					if (_levelBounds.bottom < player.y) {
						player.bounceBack("bottom");
					} 
					if (_levelBounds.top > player.y) {
						player.bounceBack("top");
					} 
					if (_levelBounds.right < player.x) {
						player.bounceBack("right");
					} 
					if (_levelBounds.left > player.x) {
						player.bounceBack("left");
					} 					
					return;
				}
			}
			// if we got this far the player is still in bounds, so check for collision
			// with obstacles.
			var obstacle:SuperSearchObstacle;
			for(var i:int = 0; i < _obstacles.length; i++) {
				obstacle = _obstacles[i];
				// let the obstacle do it's collision checking
				obstacle.collideWithPlayer(player);
				// if the collision deactivates the player, stop checking
				if(!player.isActive) return;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to place the target at a random point within our bounds.
		
		protected function randomizeChildPosition(dobj:DisplayObject) {
			if(dobj == null || _levelBounds == null) return;
			if(dobj.parent != this) return;
			// get target bounds
			var bbox:Rectangle = dobj.getBounds(this);
			// randomize x coordinate
			var span:Number = _levelBounds.width - bbox.width;
			var edge:Number = _levelBounds.left + Math.random() * span;
			dobj.x += edge - bbox.left;
			// randomize y coordinate
			trace("LEVELBOUNDS HEIGHT = " + _levelBounds.height + "    BBOX HEIGHT = " + bbox.height);
			span = _levelBounds.height - bbox.height;
			edge = _levelBounds.top + Math.random() * span;
			dobj.y += edge - bbox.top;
		}
		
		// Use this function to add a new pick up item to the level.
		
		protected function spawnItem():void {
			// pick a random item class
			if(_pickUpTypes == null || _pickUpTypes.length < 1) return;
			var class_name:String;
			var index:int;
			if(_pickUpTypes.length > 1) {
				index = Math.floor(Math.random() * _pickUpTypes.length);
				class_name = String(_pickUpTypes[index]);
			} else class_name = String(_pickUpTypes[0]);
			// try creating an instance of the target class
			var inst:DisplayObject = GeneralFunctions.getDisplayInstance(class_name);
			if(inst != null) {
				// add beneath player
				if(_playerClip != null) {
					index = getChildIndex(_playerClip);
					addChildAt(inst,index);
				} else addChild(inst);
				// check each frame to see if the item is in a valid position
				if(inst is SuperSearchCollectedItem) {
					randomizeChildPosition(inst);
					inst.addEventListener(Event.ENTER_FRAME,onPlacementFrame);
				}
			}
		}
		 
	}
	
}
