
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchLevel;
	
	/**
	 *	This class handles multiple game level types.
	 *  The first frame is often a blank frame used to get the level size.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.12.2010
	 */
	 
	public class LevelSet extends MovieClip
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
		 
		public function LevelSet():void {
			super();
			stop(); // wait at first frame for level change
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get currentLevel():SuperSearchLevel {
			return DisplayUtils.getDescendantInstance(this,SuperSearchLevel) as SuperSearchLevel;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// The function supports cycling back to the first level if the frame index goes past our last level.
		
		public function gotoLevel(level_num:int):void {
			var level_index:int = level_num - 1; // convert to starting at 0
			var frame_index:int = 1 + (level_index % totalFrames);
			gotoAndStop(frame_index);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
