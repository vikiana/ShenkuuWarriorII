/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.events.BroadcastEvent;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.BasicPopUp;
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.AnswerClip;
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.LandingPage;
	
	public class TriviaPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static var SUCCESS_MSG:String = "That's correct! You have earned 250 Neopoints and 250 team points!";
		public static var BAD_ANSWER:String = "Oops! That's not quite right. Please try again.";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		protected var _lastAnswer:AnswerClip;
		// default parameters
		public var campaignID:int;
		public var noQuestionMessage:String;
		// stored question values
		protected var _questionID:int;
		protected var _hash:String;
		protected var _questionText:String;
		// components
		protected var _questionField:TextField;
		protected var _answerClips:Array;
		protected var _submissionButton:DisplayObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TriviaPopUp():void {
			super();
			// set default values
			noQuestionMessage = "There's a problem with the trivia question.  Please try again later.";
			// check for components
			_questionField = getChildByName("question_txt") as TextField;
			findAnswerClips();
			submissionButton = getChildByName("submit_btn");
			// set up amfphp connection
			setupAMFPHP();
			// set up linkage to parent
			useParentDispatcher(MovieClip);
			// start loading the daily trivia question
			campaignID = 10;
			loadQuestion();
			// record the last answer clip selected
			addEventListener(AnswerClip.ANSWER_SELECTED,onAnswerSelected);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get submissionButton():DisplayObject { return _submissionButton; }
		
		public function set submissionButton(dobj:DisplayObject) {
			// clear listeners
			if(_submissionButton != null) {
				_submissionButton.removeEventListener(MouseEvent.CLICK,onSubmission);
			}
			// reset listeners
			_submissionButton = dobj;
			if(_submissionButton != null) {
				_submissionButton.addEventListener(MouseEvent.CLICK,onSubmission);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to check for child answer clips.
		
		public function findAnswerClips():void {
			// clear previous clips
			if(_answerClips != null) {
				while(_answerClips.length > 0) _answerClips.pop();
			} else _answerClips = new Array();
			// check all children
			var child:DisplayObject;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is AnswerClip) _answerClips.push(child);
			}
			// sort entries from top to bottom
			_answerClips.sortOn("y",Array.NUMERIC);
		}
		
		// Use this function to start loading the daily trivia question.
		
		public function loadQuestion():void {
			var responder:Responder = new Responder(onQuestionResult,onQuestionFault);
			_delegate.callRemoteMethod("TriviaService.getQuestion",responder,campaignID);
		}
		
		// This function loads the target message into our main text block.
		
		public function showMessage(msg:String) {
			if(_questionField != null) _questionField.htmlText = msg;
			setAnswerVisiblity(false);
		}
		
		// Use this function to process trivia questions retrieved from php.
		
		public function showQuestion(question:Object):void {
			if(question == null) return; //  abort if there's no question
			// store question properties
			if("qid" in question) _questionID = int(Number(question.qid));
			if("hash" in question) _hash = String(question.hash);
			// show question text
			if("question" in question) {
				_questionText = String(question.question);
				if(_questionField != null) _questionField.htmlText = _questionText;
			}
			// show answers
			if("answers" in question) {
				var list:Array = question.answers as Array;
				if(list != null) {
					// cycle through our answer clips
					var clip:AnswerClip;
					for(var i:int = 0; i < _answerClips.length; i++) {
						if(i < list.length) {
							clip = _answerClips[i];
							clip.showAnswer(list[i]);
						} else break;
					}
				} // end of list check
			}
			// clear last answer
			_lastAnswer = null;
			setAnswerVisiblity(true);
		}
		
		// This function can be used to show or hide our answers and submission button.
		
		public function setAnswerVisiblity(bool:Boolean) {
			// cycle through all registered answer clips
			var clip:AnswerClip;
			for(var i:int = 0; i < _answerClips.length; i++) {
				clip = _answerClips[i];
				clip.visible = bool;
			}
			// change submission button visibility
			_submissionButton.visible = bool;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to establish communication with php.
		
		protected function setupAMFPHP():void {
			// find out which server we should call
			if(_servers == null) _servers = new NeopetsServerFinder(this);
			// set up the amf delegate
			if(_delegate == null) _delegate = new AmfDelegate();
			// point the delegate at the target server
			_delegate.gatewayURL = _servers.scriptServer + "/amfphp/gateway.php";
		    _delegate.connect();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When an answer is selected, record it.
		
		protected function onAnswerSelected(ev:BroadcastEvent) {
			_lastAnswer = ev.sender as AnswerClip;
		}
		
		/**
		 * Amf success for getQuestion call
		*/
		protected function onQuestionResult(msg:Object):void {
			trace("onQuestionResult: " + msg);
			//if(_loadingIndicator != null) _loadingIndicator.visible = false;
			// check if the response has an error code
			if("code" in msg) {
				if("message" in msg) showMessage(msg.message);
				else showMessage(noQuestionMessage);
			} else {
				showQuestion(msg);
			}
		}
		
		/**
		 * Amf fault for getQuestion call
		*/
		protected function onQuestionFault(msg:Object):void {
			trace("onQuestionFault: " + msg);
			//if(_loadingIndicator != null) _loadingIndicator.visible = false;
		}
		
		// This function is triggered when the submission button is clicked.
		
		protected function onSubmission(ev:Event) {
			if(_lastAnswer == null) return; // abort if no answer was chosen
			// make amfphp call
			var responder:Responder = new Responder(onAnswerResult,onAnswerFault);
			var aid:int = _lastAnswer.answerID;
			_delegate.callRemoteMethod("TriviaService.submitAnswer",responder,campaignID,_questionID,aid,_hash);
		}
		
		/**
		 * Amf success for submitAnswer call
		*/
		public function onAnswerResult(msg:Object):void {
			trace("onAnswerResult: " + msg);
			// check for error code
			var award_info:Object = {activity:"trivia",score:250};
			if("code" in msg) {
				award_info.correct = false;
				// check for incorrect answer code
				//var code:Number = Number(msg.code);
				//if(code == 1005) runJavaScript(BAD_ANSWER_SCRIPT);
				if("message" in msg) showMessage(msg.message);
				else showMessage(BAD_ANSWER);
				// call tracking
				broadcast(LandingPage.SEND_NEOCONTENT,16144);
			} else {
				award_info.correct = true;
				//runJavaScript(GOOD_ANSWER_SCRIPT);
				if(msg is String) showMessage(msg as String);
				else showMessage(SUCCESS_MSG);
				// call tracking
				broadcast(LandingPage.SEND_NEOCONTENT,16143);
			}
			// award team points
			broadcast(LandingPage.AWARD_POINTS,award_info);
		}
		
		/**
		 * Amf fault for submitAnswer call
		*/
		public function onAnswerFault(msg:Object):void {
			trace("onAnswerFault: " + msg);
		}

	}
	
}