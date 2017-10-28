
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchWorld;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchCollectedItem;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.keyboard.KeyboardManager;
	import com.neopets.games.inhouse.SuperSearch.classes.util.keyboard.KeyID;
	import com.neopets.games.inhouse.SuperSearch.classes.LevelReadyPrompt;
	
	import com.neopets.util.sound.SoundObj;
	
	import com.neopets.util.display.DisplayUtils;
	
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
	 
	public class SuperSearchPlayer extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const MOVEMENT_EVENT:String = "Player_moved";
		public static const LIFE_LOST:String = "Player_lost";
		public static const ITEM_COLLECTED:String = "Player_collected_item";
		// math constants
		public static const DOUBLE_PI:Number = Math.PI * 2; // ~360 degrees in radians
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _isActive:Boolean;
		protected var _collectedItems:Array;
		protected var _numDirections:int;
		protected var _facingFrame:String;
		// control variables
		protected var _leftKey:KeyID;
		protected var _rightKey:KeyID;
		// movement variables
		protected var _radianDirection:Number;
		protected var _turnRate:Number;
		protected var _maxSpeed:Number;
		protected var _velocity:Point;
		
		protected var collectSound = new ClickSound();
		protected var collideSound = new TryAgainSound();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchPlayer():void
		{
			super();
			// start in off state
			isActive = false;
			_collectedItems = new Array();
			// check for hit area child clip
			hitArea = getChildByName("hitbox_mc") as MovieClip;
			// initialize keys
			leftKey = new KeyID(Keyboard.LEFT);
			rightKey = new KeyID(Keyboard.RIGHT);
			// initialize variables
			_radianDirection = 0;
			_turnRate = Math.PI / 36; // ~5 degrees
			_maxSpeed = 5;
			_velocity = new Point(_maxSpeed,0);
			_numDirections = 8;
			// set up links to game screen
			useParentDispatcher(SuperSearchWorld);
			// set up listeners
			addParentListener(SuperSearch_GameScreen,LevelReadyPrompt.PROMPT_DONE,onLevelReady);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.LEVEL_CLEARED,onLevelCleared);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.NEXT_LEVEL,onNextLevel);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.GAME_OVER,onGameOver);
			// try to maximize bitmap caching
			DisplayUtils.cacheImages(this);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get facingFrame():String { return _facingFrame; }
		
		public function set facingFrame(id:String) {
			if(_facingFrame != id) {
				_facingFrame = id;
				gotoAndStop(id);
				// try to maximize bitmap caching
				DisplayUtils.cacheImages(this);
			}
		}
		
		public function get isActive():Boolean { return _isActive; }
		
		public function set isActive(bool:Boolean) {
			if(_isActive != bool) {
				_isActive = bool;
				if(_isActive) {
					// start movement and animations
					startMoving();
					resumeAnimations();
				} else {
					// stop movement and animations
					stopMoving();
					stopAnimations();
				}
			}
		}
		
		public function get leftKey():KeyID { return _leftKey; }
		
		public function set leftKey(id:KeyID) {
			_leftKey = id;
			if(_leftKey != null) {
				// make sure the key manager is tracking this key
				var keys:KeyboardManager = KeyboardManager.instance;
				keys.trackKey(_leftKey.keyCode,_leftKey.keyLocation);
			}
		}
		
		public function get radianDirection():Number { return _radianDirection; }
		
		public function set radianDirection(val:Number) {
			if(_radianDirection != val) {
				_radianDirection = val;
				// get angle components
				var sine:Number = Math.sin(_radianDirection);
				var cosine:Number = Math.cos(_radianDirection);
				// set velocity
				_velocity.x = _maxSpeed * cosine;
				_velocity.y = _maxSpeed * sine;
				// synch model direction
				synchFacing();
			}
		}
		
		public function get rightKey():KeyID { return _rightKey; }
		
		public function set rightKey(id:KeyID) {
			_rightKey = id;
			if(_rightKey != null) {
				// make sure the key manager is tracking this key
				var keys:KeyboardManager = KeyboardManager.instance;
				keys.trackKey(_rightKey.keyCode,_rightKey.keyLocation);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to add collectibles to our tail
		
		public function addToTail(item:SuperSearchCollectedItem):void {
			if(item == null) return;
			// check if we already have the item
			if(_collectedItems.indexOf(item) >= 0) return;
			// if not make the target follow our current tail.
			if(_collectedItems.length > 0) {
				var index:int = _collectedItems.length - 1;
				var tail:SuperSearchCollectedItem = _collectedItems[index];
				item.startFollowing(tail);
			} else {
				item.startFollowing(this,8);
			}
			// add item to our list
			_collectedItems.push(item);
			// let the rest of the game know
			var screen:DisplayObject = DisplayUtils.getAncestorInstance(this,SuperSearch_GameScreen);
			broadcast(ITEM_COLLECTED,item,screen);
			collectSound.playSound();
		}
		
		// Use this function to remove all items from our tail.
		
		public function clearTail():void {
			var item:DisplayObject;
			var container:DisplayObjectContainer;
			while(_collectedItems.length > 0) {
				item = _collectedItems.pop();
				container = item.parent;
				if(container != null) container.removeChild(item);
			}
		}
		
		// Use this function to dispatch our death event
		
		public function die():void {
			// check if we're already dead
			if(_isActive) {				
				isActive = false;
				collideSound.playSound();
				// drop all items from our tail
				clearTail();
				// let our listeners know
				var screen:DisplayObject = DisplayUtils.getAncestorInstance(this,SuperSearch_GameScreen);
				broadcast(LIFE_LOST,this,screen);
			}
		}
		
		//bounce off the walls:
		
		public function bounceBack(_pDir: String):void {
			// check if we're dead
			if(_isActive) {
				//trace("BOUNCEBACK: " + _pDir);
				switch (_pDir) {
					case "left" : 					
						radianDirection = Math.PI - radianDirection;
						x += 2*_maxSpeed;
						break;
					case "right" : 
						radianDirection = Math.PI - radianDirection;
						x -= 2*_maxSpeed;
						break;	
					case "top" : 
						radianDirection = Math.PI + Math.PI - radianDirection;
						y += 2*_maxSpeed;
						break;		
					case "bottom" : 
						radianDirection = Math.PI + Math.PI - radianDirection;
						y -= 2*_maxSpeed;
						break;	
				}
			}
		}
		
		// Start child animations back up.
		
		public function resumeAnimations():void {
			var clip:MovieClip;
			for(var i:int = 0; i < numChildren; i++) {
				clip = getChildAt(i) as MovieClip;
				if(clip != null) clip.play();
			}
		}
		
		// Use this function to initialize our movement checking functions.
		
		public function startMoving():void {
			addEventListener(Event.ENTER_FRAME,onMovementFrame);
		}
		
		// Stop all child animations.
		
		public function stopAnimations():void {
			var clip:MovieClip;
			for(var i:int = 0; i < numChildren; i++) {
				clip = getChildAt(i) as MovieClip;
				if(clip != null) clip.stop();
			}
		}
		
		// Use this function to turn off our movement checking functions.
		
		public function stopMoving():void {
			removeEventListener(Event.ENTER_FRAME,onMovementFrame);
		}
		
		// Use this function to change our character facing to match our movement direction.
		// This can be overriden if subclasses don't have 8 facings.
		
		public function synchFacing():void {
			//trace("_numDirections = " + _numDirections);
			_numDirections = 8;
			if(_numDirections >= 8) synchEightWayFacing();
			else synchFourWayFacing();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the game ends, stop moving.
		
		protected function onGameOver(ev:Event) {
			isActive = false;
		}
		
		// When the level is cleared, disable the player.
		
		protected function onLevelCleared(ev:Event) {
			isActive = false;
		}
		
		// When the level prompt ends, start moving this clip.
		
		protected function onLevelReady(ev:Event) {
			isActive = true;
		}
		
		// Check if the turn keys are down.
		
		protected function onMovementFrame(ev:Event) {
			// check key states
			var keys:KeyboardManager = KeyboardManager.instance;
			// check left turn
			var turn:Number;
			if(_leftKey != null && keys.keyIsDown(_leftKey.keyCode,_leftKey.keyLocation)) {
				turn = -_turnRate;
			} else turn = 0;
			// check right turn
			if(_rightKey != null && keys.keyIsDown(_rightKey.keyCode,_rightKey.keyLocation)) {
				turn += _turnRate;
			}
			// apply turn to our movement direction and facing
			if(turn != 0) radianDirection = _radianDirection + turn;
			// apply velocity
			x += _velocity.x;
			y += _velocity.y;
			// let listeners know we moved
			broadcast(MOVEMENT_EVENT);
		}
		
		// When a new level starts, clear our tail.
		
		protected function onNextLevel(ev:Event) {
			clearTail();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to change our character facing to match our movement direction.
		// This version handles up to 8 different facing directions.
		
		protected function synchEightWayFacing():void {
			// convert angle to between 0 and 360 degrees (in radians)
			var angle:Number = _radianDirection % DOUBLE_PI;
			if(angle < 0) angle = DOUBLE_PI + angle;
			// get size of each facing arc
			var half_arc:Number = Math.PI / 8;
			var arc_size:Number = half_arc + half_arc;
			// find out how many facing thresholds we pass going from angle 0 to our target angle
			var threshold:Number = half_arc;
			for(var passed:int = 0; threshold < DOUBLE_PI; passed++) {
				// check if we passed this threshold
				if(angle >= threshold) {
					// if we did, move to the next threshold
					threshold += arc_size;
				} else break; // if not, stop cycling
			}
			// convert thresholds passed to frame labels
			switch(passed) {
				case 1: 
					facingFrame = "front_right";
					break;
				case 2: 
					facingFrame = "front";
					break;
				case 3: 
					facingFrame = "front_left";
					break;
				case 4: 
					facingFrame = "left";
					break;
				case 5: 
					facingFrame = "back_left";
					break;
				case 6: 
					facingFrame = "back";
					break;
				case 7: 
					facingFrame = "back_right";
					break;
				default:
					facingFrame = "right";
			}
			//trace("8. facingFrame = " + facingFrame);
		}
		
		// Use this function to change our character facing to match our movement direction.
		// This version handles up to 4 different facing directions.
		
		protected function synchFourWayFacing():void {
			// check if horizontal movement is dominant
			if(Math.abs(_velocity.x) >= Math.abs(_velocity.y)) {
				// check if we're facing left or right
				if(_velocity.x >= 0) facingFrame = "right";
				else facingFrame = "left";
			} else {
				// check if we're facing up or down
				if(_velocity.y >= 0) facingFrame = "front";
				else facingFrame = "back";
			}
			//trace("4. facingFrame = " + facingFrame);
		}
		
	}
	
}
