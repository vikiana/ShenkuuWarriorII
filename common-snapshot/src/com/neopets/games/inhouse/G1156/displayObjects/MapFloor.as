/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.G1156.displayObjects 
{
	import flash.display.MovieClip;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	
	/**
	 *	The LandingZone for the Playersr
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Game Engine G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.05.2009
	 */
	 
	public class MapFloor extends AbsInteractiveDisplayObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const COLLISION_TYPE:String = "MapFloor";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MapFloor():void
		{
			super();
			setupVars();
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
		
		protected function setupVars():void
		{
			mCollisionDisplayArray = [this];
			mType = MapFloor.COLLISION_TYPE;
			registerEventDispatcher(GameCore.KEY);
		}
	}
	
}
