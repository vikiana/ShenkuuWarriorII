/**
 *	Course step contains information for each step
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since Nov. 2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class CourseStep
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var bPopUp:Boolean;
		public var stext:String;
		public var pipeLine:Array;
		public var game_state:Number;
		public var trigger_next_step:Number;
		public var helptext:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CourseStep(bPop:Boolean, t:String, pl:Array):void
		{
			// show popup?
			bPopUp     = bPop;
			// text for popup window
			stext      = t;
			// the cannon bubble pipeline
			pipeLine   = pl;
		
			// game_state to switch to
			game_state = -1;
			// game_state that will trigger the next course step
			trigger_next_step = -1;
			// show some text while the popup is hidden
			helptext = "";
			//do something...??
			//_root.progressButtonThing.setHtmlText("");

		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}