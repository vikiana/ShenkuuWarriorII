
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchWorld;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	
	import com.neopets.util.display.DisplayUtils;
	
	/**
	 *	This class handles items the player needs to pick up to clear the level.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.13.2010
	 */
	 
	public class SuperSearchCollectedItem extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _itemBounds:Rectangle;
		// chaining variables
		protected var _leader:MovieClip;
		protected var _followDistance:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchCollectedItem():void {
			super();
			hide(); // start hidden until good start position is found
			// try to maximize bitmap caching
			DisplayUtils.cacheImages(this);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get leader():MovieClip { return _leader; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Initialization functions
		
		// Use this reveal the object when it's been properly placed.
		
		public function initItem():void {
			show();
		}
		
		// Collision Functions
		
		public function intersects(clip:MovieClip):Boolean {
			if(clip == null || stage == null) return false;
			// get target's hit area bounds
			var target_bounds:Rectangle;
			if(clip.hitArea != null) {
				target_bounds = clip.hitArea.getBounds(this);
			} else target_bounds = clip.getBounds(this);
			// check our own bounds
			if(_itemBounds == null) _itemBounds = getBounds(this);
			// perform a quick bounding box test
			if(target_bounds.left > _itemBounds.right) return false;
			if(target_bounds.right < _itemBounds.left) return false;
			if(target_bounds.top > _itemBounds.bottom) return false;
			if(target_bounds.bottom < _itemBounds.top) return false;
			// if we got this far, the bounding boxes must be overlapping
			return true;
		}
		
		// Follower Functions
		
		// Use this function to switch to following a new leader.
		
		public function startFollowing(target:MovieClip,spacing:Number=0):void {
			// check for a valid target
			if(target == null || target == this) return;
			// calculate follow distance
			var item_radius:Number = Math.max(width,height) / 2;
			var target_radius:Number = Math.max(target.width,target.height) / 2;
			_followDistance = item_radius + target_radius + spacing;
			// set up a connection to our new leader
			_leader = target;
			// check the leader type to get linkage direction
			var dir:Number = 0;
			if(_leader is SuperSearchPlayer) {
				// use reverse of player's direction
				var player:SuperSearchPlayer = _leader as SuperSearchPlayer;
				dir = -player.radianDirection;
			} else {
				if(_leader is SuperSearchCollectedItem) {
					// use direction from our leader to it's leader
					var lead_item:SuperSearchCollectedItem = _leader as SuperSearchCollectedItem;
					var lead_leader:MovieClip = lead_item.leader;
					if(lead_leader != null) {
						var dx:Number = lead_item.x - lead_leader.x;
						var dy:Number = lead_item.y - lead_leader.y;
						dir = Math.atan2(dy,dx);
					} // end of leader of our leader check
				}
			} // end of leader type checks
			// Use the calculateed direction to set up distance from the target
			var sine:Number = Math.sin(dir);
			var cosine:Number = Math.cos(dir);
			x = _leader.x + _followDistance * cosine;
			y = _leader.y + _followDistance * sine;
		}
		
		// Use this function to break connections to our leader.
		
		public function stopFollowing():void {
			_leader != null; // clear previous leader
		}
		
		// Visibility Functions
		
		public function hide():void {
			alpha = 0.5;
			// don't react to player while hidden
			removeParentListener(SuperSearchWorld,SuperSearchPlayer.MOVEMENT_EVENT,onCollectorMoved);
		}
		
		public function show():void {
			alpha = 1;
			// when shown, start reacting to player movement
			addParentListener(SuperSearchWorld,SuperSearchPlayer.MOVEMENT_EVENT,onCollectorMoved);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function is called each time the player moves while we're in collectible mode
		
		protected function onCollectorMoved(ev:BroadcastEvent) {
			var player:SuperSearchPlayer = ev.sender as SuperSearchPlayer;
			if(player == null) return;
			// check if we intersect the player
			if(intersects(player)) {
				// check if we're following something
				if(_leader == null) {
					// if not, follow the player
					player.addToTail(this);
				} else {
					// if so, the collision costs the player a life
					player.die();
				}
			} else {
				// do a pursuit cycle
				followLeader();
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to keep the item at a constant distance from it's leader.
		
		protected function followLeader():void {
			if(_leader == null) return;
			// get distances from leader
			var dist_x:Number = x - _leader.x;
			var dist_y:Number = y - _leader.y;
			var total_dist:Number = Math.sqrt(Math.pow(dist_x,2) + Math.pow(dist_y,2));
			if(total_dist == 0) return;
			// scale distance to pull toward leader
			var scaling:Number = _followDistance / total_dist;
			x = _leader.x + dist_x * scaling;
			y = _leader.y + dist_y * scaling;
		}
		
	}
	
}
