
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchCollectedItem;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchLevel;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchWorld;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	
	/**
	 *	This class handles items the player needs to pick up to clear the level.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.13.2010
	 */
	 
	public class SuperSearchCompass extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const DEGREES_PER_RADIAN:Number = 180 / Math.PI;
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _needleClip:MovieClip;
		protected var _currentPlayer:SuperSearchPlayer;
		protected var _currentItem:SuperSearchCollectedItem;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchCompass():void {
			super();
			// check for components
			_needleClip = getChildByName("needle_mc") as MovieClip;
			// set up listeners
			addParentListener(SuperSearch_GameScreen,SuperSearchPlayer.MOVEMENT_EVENT,onPlayerMoved);
			addParentListener(SuperSearch_GameScreen,SuperSearchLevel.ITEM_PLACED,onItemPlaced);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function tries to align our compass with both the player and the target item.
		
		public function updateDirection():void {
			// check for valid properties
			if(_needleClip == null) return;
			if(_currentPlayer == null || _currentItem == null) return;
			// get the direct from the player to the target item
			var dx:Number = _currentItem.x - _currentPlayer.x;
			var dy:Number = _currentItem.y - _currentPlayer.y;
			var radians:Number = Math.atan2(dy,dx);
			// apply rotation to needle
			_needleClip.rotation = DEGREES_PER_RADIAN * radians;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When an item is placed, update our direction.
		
		protected function onItemPlaced(ev:BroadcastEvent) {
			_currentItem = ev.oData as SuperSearchCollectedItem;
			updateDirection();
		}
		
		// If the player moves, update our direction.
		
		protected function onPlayerMoved(ev:BroadcastEvent) {
			_currentPlayer = ev.oData as SuperSearchPlayer;
			updateDirection();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
