/**
 *	This class attaches a text field to a ButtonClip.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.14.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.neopets.util.events.CustomEvent;
	
	public class AnswerButton extends TextButton
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const ANSWER_CHOSEN:String = "answer_chosen";
		// public variables
		public var answerData:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AnswerButton():void {
			super();
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
		
		override protected function onClick(ev:MouseEvent) {
			var new_event:CustomEvent = new CustomEvent(answerData,ANSWER_CHOSEN);
			dispatchEvent(new_event);
			playClick();
		}
		
	}
	
}