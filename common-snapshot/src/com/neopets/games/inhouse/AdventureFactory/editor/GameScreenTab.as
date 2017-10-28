
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.games.inhouse.AdventureFactory.util.TabButton;
	
	/**
	 *	This class simply set the tab to relay messages through the game screen by taking advantage of it's 
	 *  BroadcasterClip inheritance.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  10.12.2010
	 */
	 
	public class GameScreenTab extends TabButton
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var selectionEvent:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameScreenTab():void{
			super();
			// broadcast events through the game screen
			useParentDispatcher(AdventureFactory_GameScreen);
			// broadcast the target selection event when this tab is selected
			addEventListener(Event.SELECT,onSelect);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get selectionData():Object { return this; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onSelect(ev:Event) {
			if(selectionEvent != null) broadcast(selectionEvent,selectionData);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
