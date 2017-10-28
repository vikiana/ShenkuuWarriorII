
// This class currently isn't doing anything, but it may be used for the A.I. later on
package com.neopets.games.inhouse.BlindDateHorror {
	
	// IMPORTS
	import com.neopets.games.inhouse.BlindDateHorror.BlindDateGame;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.util.display.DisplayUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	// CLASS DEFINITION
	public class GirlOne extends MovieClip{
		
		//-------------------------------------------------------------
		// PROPERTIES
		//-------------------------------------------------------------
		
		
		//-------------------------------------------------------------
		// CONSTRUCTOR
		//-------------------------------------------------------------
		public function GirlOne() 
		{
			trace("Girl Movement");
			//addEventListener(Event.ENTER_FRAME, moveGirl);
		}
		
		
		//-------------------------------------------------------------
		// METHODS
		//-------------------------------------------------------------
		private function moveGirl(event:Event):void
		{
			//x += .5;
		}
		
		
					
		
		
	}
}