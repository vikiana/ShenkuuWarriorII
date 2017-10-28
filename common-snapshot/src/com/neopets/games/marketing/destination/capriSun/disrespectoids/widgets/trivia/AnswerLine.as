/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.trivia
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AnswerLine extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// components
		protected var _answerField:TextField;
		// stored variables
		protected var _lineID:String;
		protected var _answerText:String;
		protected var _answerID:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AnswerLine():void {
			super();
			// set up components
			_answerField = getChildByName("main_txt") as TextField;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get answerID():int { return _answerID; }
		
		public function get answerText():String { return _answerText; }
		
		public function set answerText(str:String) {
			_answerText = str;
			updateLine();
		}
		
		public function get lineID():String { return _lineID; }
		
		public function set lineID(id:String) {
			_lineID = id;
			updateLine();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to process trivia answer retrieved from php.
		
		public function showAnswer(answer:Object):void {
			if(answer == null) return; //  abort if there's no answer
			// store answer ID
			if("aid" in answer) _answerID = int(Number(answer.aid));
			// show answer text
			if("answer" in answer) answerText = String(answer.answer);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to set up our textfield.
		
		protected function updateLine():void {
			if(_answerField != null) {
				var str:String;
				// start with line identifier
				if(_lineID != null && _lineID.length > 0) str = _lineID + ". ";
				else str = " - ";
				// add main text
				if(_answerText != null) _answerField.htmlText = str + _answerText;
				else _answerField.htmlText = str;
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}