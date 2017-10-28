
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy
{
	import flash.display.MovieClip;
	
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.MenuShell;
	
	/**
	 *	This class loads and manages the menus used by the game.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  05.04.2010
	 */
	 
	public class FlagsOfFrenzyShell extends MenuShell
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const START_MENU:String = "StartMenuMC";
		public static const GAME_MENU:String = "GameMenuMC";
		public static const GAME_OVER_MENU:String = "GameOverMenuMC";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FlagsOfFrenzyShell():void{
			super();
			addMenu(START_MENU);
			addMenu(GAME_MENU);
			addMenu(GAME_OVER_MENU);
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
