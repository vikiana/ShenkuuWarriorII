
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.util.display.DisplayUtils;
	
	/**
	 *	This class simply makes the movieclip search for it's containing gamescreen when added to the stage and 
	 *  clear it's listeners when taken off stage.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  10.12.2010
	 */
	 
	public class GameScreenClip extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _gameScreen:AdventureFactory_GameScreen;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameScreenClip():void{
			super();
			// set up listeners
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get gameScreen():AdventureFactory_GameScreen { return _gameScreen; }
		
		public function set gameScreen(screen:AdventureFactory_GameScreen) {
			_gameScreen = screen;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Use this function to find our game screen when we're added to the stage.
		
		protected function onAdded(ev:Event) {
			if(ev.target == this) {
				gameScreen = DisplayUtils.getAncestorInstance(this,AdventureFactory_GameScreen) as AdventureFactory_GameScreen;
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		// Clear listeners when we go off stage.
		
		protected function onRemoved(ev:Event) {
			if(ev.target == this) {
				gameScreen = null;
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
				removeEventListener(Event.ADDED_TO_STAGE,onRemoved);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
