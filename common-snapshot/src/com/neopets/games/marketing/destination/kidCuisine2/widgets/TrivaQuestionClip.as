/**
 *	This handles linking answer buttons to a trivia question.
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
	
	public class TrivaQuestionClip extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// protected variables
		protected var _questionField:TextField;
		protected var answers:Array;
		protected var _questionData:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TrivaQuestionClip():void {
			_questionField = getChildByName("question_txt") as TextField;
			answers = new Array();
			mouseEnabled = false;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get questionData():Object { return _questionData; }
		
		public function set questionData(info:Object) {
			if(info == null) return;
			// load question
			var clip_y:Number
			if(_questionField != null) {
				_questionField.text = info.question;
				clip_y = _questionField.y + _questionField.height;
			} else clip_y = 0;
			// clear previous answers
			var clip:MovieClip;
			while(answers.length > 0) {
				clip = answers.pop();
				removeChild(clip);
			}
			// load new answers
			if("answers" in info) {
				// get character code of first slot
				var line:String = "A";
				var code:Number = line.charCodeAt();
				// cycle through all entries
				var list:Array = info.answers;
				var entry:Object;
				for(var i:int = 0; i < list.length; i++) {
					entry = list[i];
					clip = new AnswerButtonMC();
					clip.text = String.fromCharCode(code + i) + ". " + entry.answer;
					clip.y = clip_y;
					clip.answerData = entry;
					clip.addEventListener(AnswerButton.ANSWER_CHOSEN,onAnswerChosen);
					addChild(clip);
					clip.name = "ans_"+i;
					answers.push(clip);
					clip_y += clip.height;
				}
			}
		}
		
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
		
		/**
		 * Relay the chosen answer to our listeners.
		*/
		
		public function onAnswerChosen(ev:CustomEvent) {
			if(ev != null) dispatchEvent(new CustomEvent(ev.oData,ev.type));
		}
		
	}
	
}