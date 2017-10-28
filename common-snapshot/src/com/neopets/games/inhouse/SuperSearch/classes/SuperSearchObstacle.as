
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchLevel;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchPlayer;
	
	
	/**
	 *	This class handles in world obstacles for the player.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.13.2010
	 */
	 
	public class SuperSearchObstacle extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearchObstacle():void {
			super();
			// set up listeners
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to check for collision with the target object.
		
		public function collideWithPlayer(player:SuperSearchPlayer):Boolean {
			
			if(player == null) return false;
			// convert to global coordinates
			var player_pt:Point = player.localToGlobal(new Point());
			// check if the player's origin overlaps our bounds
			if(hitTestPoint(player_pt.x,player_pt.y,true)) {
				
				player.die();
				return true;
			}
			return false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When added to stage, try to register us with our containing game level.
		
		protected function onAdded(ev:Event) {
			if(ev.target == this) {
				var level:SuperSearchLevel = DisplayUtils.getAncestorInstance(this,SuperSearchLevel) as SuperSearchLevel;
				if(level != null) level.registerObstacle(this);
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
