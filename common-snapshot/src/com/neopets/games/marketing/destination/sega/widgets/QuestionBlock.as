/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.sega.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.mtvnet.vworlds.util.events.CustomEvent;
	import com.neopets.games.marketing.destination.altadorbooths.common.widgets.SimpleRadioButton;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.display.ListPane;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class QuestionBlock extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ANSWER_SELECTED:String = "trivia_answer_selected";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// stored question values
		protected var _questionID:int;
		protected var _hash:String;
		protected var _questionText:String;
		// components
		protected var _answerPane:ListPane;
		
		protected var _answersArray:Array = new Array();
		
		public var question_txt:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestionBlock():void {
			super();
			visible = false; // hide by default
			// create answer pane
			initAnswerPane();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get questionID():int { return _questionID; }
		
		public function get hash():String { return _hash; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to process trivia questions retrieved from php.
		
		public function showQuestion(question:Object):void {
			if(question == null) return; //  abort if there's no question
			// store question properties
			if("qid" in question) _questionID = int(Number(question.qid));
			if("hash" in question) _hash = String(question.hash);
			// show question text
			if("question" in question) {
				_questionText = String(question.question);
				if(question_txt != null) question_txt.htmlText = _questionText;
			}
			// show answers
			_answerPane.clearItems();
			if("answers" in question) {
				var list:Array = question.answers as Array;
				if(list != null) {
					// get character code of first line id
					var first_char:String = "A";
					var char_code:Number = first_char.charCodeAt();
					// cycle through the answer list
					var answer:AnswerLine;
					for(var i:int = 0; i < list.length; i++) {
						//first_char = String.fromCharCode(code + i);
						answer = new AnswerLine();
						answer.lineID = String.fromCharCode(char_code + i);
						answer.showAnswer(list[i]);
						answer.addEventListener(MouseEvent.CLICK,onAnswerClick);
						answer.x = 20;
						_answerPane.addItem(answer,1,1);
						//
						_answersArray.push (answer);
					}
				} // end of list check
			}
			// show ourselves
			visible = true;
		}
		
		public function cleanup():void {
			//TODO: implement
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this to add an area for loading answer lines.
		
		public function initAnswerPane():void {
			var bounds:Rectangle = getBounds(this)
			_answerPane = new ListPane();
			_answerPane.x = bounds.left;
			if(question_txt != null) {
				_answerPane.y = question_txt.y + question_txt.height;
			}
			_answerPane.alignment = ListPane.LEFT_ALIGN;
			addChild(_answerPane);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When an answer line is clicked on, let our listeners know.
		
		protected function onAnswerClick(ev:MouseEvent) {
			trace ("TRIVIA", this, "onAnswerClick");
			var caller:InteractiveObject = ev.target as InteractiveObject;
			if(caller != null) {
				// get answerline click was called from
				var answer:AnswerLine;
				if(caller is AnswerLine) answer = caller as AnswerLine;
				else answer = DisplayUtils.getAncestorInstance(caller,AnswerLine) as AnswerLine;
				// broadcast event
				var info:Object = {question:this,answer:answer};
				var transmission:CustomEvent = new CustomEvent(info,ANSWER_SELECTED);
				dispatchEvent(transmission);
			}
			for each (var item in _answersArray){
				if (item is AnswerLine && item != ev.target.parent){
					AnswerLine (item).toggleRadioButton(false);
				}
			}
		}
		
	}
	
}