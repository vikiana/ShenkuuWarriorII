
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.game.objects
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	
	/**
	 *	This class just lays out child clips in a horizontal line.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.26.2010
	 */
	 
	public class WorldEnitity extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function WorldEnitity():void{
			super();
			// set up listeners
			addParentListener(AdventureFactory_GameScreen.)
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
