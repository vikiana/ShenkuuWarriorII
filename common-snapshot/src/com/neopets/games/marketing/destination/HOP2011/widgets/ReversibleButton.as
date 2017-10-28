/**
 *	This class uses reversible animation to handle roll over and roll out effects.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.general.MathUtils;
	
	public class ReversibleButton extends CommandButton
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var _playSpeed:int = 0;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ReversibleButton():void {
			super();
			stop();
			// set up mouse behaviour
			addEventListener(Event.ENTER_FRAME,onFrame);
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
		
		// run an animation update each frame
		
		protected function onFrame(ev:Event) {
			if(_playSpeed != 0) {
				var new_frame:int = MathUtils.constrain(0,currentFrame + _playSpeed,totalFrames);
				if(currentFrame != new_frame) gotoAndStop(new_frame);
			}
		}
		
		// start playing forward animation on mouse over.
		
		override protected function onMouseOver(ev:MouseEvent) {
			_playSpeed = 1;
		}
		
		// start playing reversed animation on mouse out.
		
		override protected function onMouseOut(ev:MouseEvent) {
			_playSpeed = -1;
		}

	}
	
}