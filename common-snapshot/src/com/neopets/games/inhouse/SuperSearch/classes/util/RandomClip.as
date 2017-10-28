
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.SuperSearch.classes.util
{
	import flash.display.MovieClip;
	
	/**
	 *	This class simply jumps to a random frame when it's initialized.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.21.2010
	 */
	 
	public class RandomClip extends MovieClip
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
		
		public function RandomClip():void{
			super();
			gotoRandomFrame();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this funtion to jump to a a random frame.
		
		public function gotoRandomFrame():void {
			var index:int = Math.floor(Math.random() * totalFrames) + 1;
			gotoAndStop(index);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
