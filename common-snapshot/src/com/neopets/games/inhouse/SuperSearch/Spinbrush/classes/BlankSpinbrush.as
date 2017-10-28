
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.Spinbrush.classes
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	import com.neopets.games.inhouse.SuperSearch.classes.util.ClipCopier;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	
	/**
	 *	This class handles showing the spinbrush with a set of collected stickers when the level ends.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.24.2010
	 */
	 
	public class BlankSpinbrush extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _attachPoints:Array;
		protected var _collectedItems:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function BlankSpinbrush():void {
			super();
			// initialize variables
			findAttachPoints();
			_collectedItems = new Array();
			// set up listeners
			addParentListener(SuperSearch_GameScreen,SuperSearchPlayer.ITEM_COLLECTED,onItemCollected);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.LEVEL_CLEARED,onLevelCleared);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.GAME_STARTED,onGameStarted);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function findAttachPoints():Array {
			// clear previous array
			if(_attachPoints != null) {
				while(_attachPoints.length > 0) _attachPoints.pop();
			} else _attachPoints = new Array();
			// rebuild list
			var child:DisplayObject;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is ClipCopier) {
					_attachPoints.push(child);
				}
			}
			return _attachPoints;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the game starts, clear our collected item list.
		
		protected function onGameStarted(ev:Event) {
			while(_collectedItems.length > 0) _collectedItems.pop();
		}
		
		// This function updated our collected item list when the playe picks up a new item.
		
		protected function onItemCollected(ev:BroadcastEvent) {
			var item:Object = ev.oData;
			if(item != null) _collectedItems.push(item);
		}
		
		// When the level ends, load copies of the collected item onto this spinbrush.
		
		protected function onLevelCleared(ev:Event) {
			// wait on frame for the last item collection event to come in.
			addEventListener(Event.ENTER_FRAME,onLoadFrame);
		}
		
		protected function onLoadFrame(ev:Event){
			// cycle through all our attach points
			var slot:ClipCopier;
			var index:int;
			var removed:Array;
			var item:Object;
			for(var i:int = 0; i < _attachPoints.length; i++) {
				slot = _attachPoints[i] as ClipCopier;
				// get random collected item
				if(_collectedItems.length > 0) {
					if(_collectedItems.length > 1) {
						index = Math.floor(Math.random() * _collectedItems.length);
						removed = _collectedItems.splice(index,1);
						item = removed[0];
					} else item = _collectedItems.pop();
					// load collected item into attach point
					if(slot != null) slot.copy(item as DisplayObject);
				} else break;
			}
			// clear the remaining collected items
			while(_collectedItems.length > 0) _collectedItems.pop();
			// clear the frame listener
			removeEventListener(Event.ENTER_FRAME,onLoadFrame);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
