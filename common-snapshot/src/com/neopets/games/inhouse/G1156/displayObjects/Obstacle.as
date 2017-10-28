/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.G1156.displayObjects 
{
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	
	import flash.display.MovieClip;
	
	/**
	 *	Basic Class for Obstacle that Does Damage for a Player
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Game Engine G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.05.2009
	 */
	 
	public class Obstacle extends AbsInteractiveDisplayObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const COLLISION_TYPE:String = "Obstacle";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var mBaseType:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Obstacle():void
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
			mType = Obstacle.COLLISION_TYPE;
			registerEventDispatcher(GameCore.KEY);
		}
	}
	
}
