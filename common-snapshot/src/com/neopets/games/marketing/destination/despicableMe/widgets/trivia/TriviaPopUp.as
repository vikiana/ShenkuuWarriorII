/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.trivia
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.widgets.TriviaCallButton;
	import com.neopets.games.marketing.destination.despicableMe.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.games.marketing.destination.despicableMe.LogInMessage;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class TriviaPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const TRIVIA_ERROR:String = "There's a problem with the trivia question.";
		public static const TRY_AGAIN:String = "Please try again later.";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// global variables
		public static var CAMPAIGN_ID:int = 7;
		public static var SUCCESS_MSG:String = "That is correct! You have earned 200 Neopoints!";
		public static var BAD_ANSWER:String = "That is incorrect.  Please try again tomorrow!";
		// local variables
		protected var _loggedIn:Boolean;
		protected var _messageField:TextField;
		protected var _questionClip:QuestionBlock;
		protected var _loadingIndicator:MovieClip;
		protected var delegate:AmfDelegate;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TriviaPopUp():void {
			super();
			// set up components
			_messageField = getChildByName("main_txt") as TextField;
			questionClip = getChildByName("question_mc") as QuestionBlock;
			_loadingIndicator = getChildByName("loading_mc") as MovieClip;
			// set up amfphp connection
			setupAMFPHP();
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			_loggedIn = (tag != null && tag != AbsView.GUEST_USER);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get questionClip():QuestionBlock { return _questionClip; }
		
		public function set questionClip(clip:QuestionBlock) {
			// clear listeners
			if(_questionClip != null) {
				_questionClip.removeEventListener(QuestionBlock.ANSWER_SELECTED,onAnswerSelected);
			}
			_questionClip = clip;
			// set up listeners
			if(_questionClip != null) {
				_questionClip.addEventListener(QuestionBlock.ANSWER_SELECTED,onAnswerSelected);
			}
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(TriviaCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(TriviaCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.addEventListener(POPUP_SHOWN,onPopUpShown);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// If not logged in show login text.
		
		public function showLogin():void {
			var msg:LogInMessage = new LogInMessage("participate in the daily trivia activity");
			showMessage(msg.toString());
		}
		
		// Use this function to send to show a text message in place of our trivia block.
		
		public function showMessage(msg:String) {
			if(_messageField != null) _messageField.htmlText = msg;
			if(_loadingIndicator != null) _loadingIndicator.visible = false;
			if(_questionClip != null) _questionClip.visible = false;
			visible = true;
		}
		
		// Use this function to start loading the daily trivia question.
		
		public function showTrivia():void {
			if(_messageField != null) _messageField.htmlText = "";
			if(_loadingIndicator != null) _loadingIndicator.visible = true;
			// make amfphp call
			var responder:Responder = new Responder(onQuestionResult,onQuestionFault);
			delegate.callRemoteMethod("TriviaService.getQuestion",responder,CAMPAIGN_ID);
			visible = true;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to establish communication with php.
		
		protected function setupAMFPHP():void {
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function sends a selected answer on php.
		
		protected function onAnswerSelected(ev:CustomEvent) {
			var info:Object = ev.oData;
			if(info == null) return; // abort if no message
			// extract parameters
			var qid:int;
			var hash:String;
			// check for valid question
			var question:Object = info.question;
			if(question != null) {
				qid = question.questionID;
				hash = question.hash;
			} else return; // abort if no question
			// check for valid answer
			var aid:int;
			var answer:Object = info.answer;
			if(answer != null) aid = answer.answerID;
			else return; // abort if no answer
			// make amfphp call
			var responder:Responder = new Responder(onAnswerResult,onAnswerFault);
			delegate.callRemoteMethod("TriviaService.submitAnswer",responder,CAMPAIGN_ID,qid,aid,hash);
		}
		
		// This function is triggered when a character selection event is broadcast.
		
		override protected function onPopUpRequest(ev:BroadcastEvent) {
			// update view
			if(_loggedIn) showTrivia();
			else showLogin();
			broadcast(POPUP_SHOWN);
		}
		
		// AMFPHP Events
		
		/**
		 * Amf success for submitAnswer call
		*/
		public function onAnswerResult(msg:Object):void {
			trace("onAnswerResult: " + msg);
			if("code" in msg) {
				// check for incorrect answer code
				//var code:Number = Number(msg.code);
				//if(code == 1005) runJavaScript(BAD_ANSWER_SCRIPT);
				if("message" in msg) showMessage(msg.message);
				else showMessage(BAD_ANSWER);
			} else {
				//runJavaScript(GOOD_ANSWER_SCRIPT);
				if(msg is String) showMessage(msg as String);
				else showMessage(SUCCESS_MSG);
			}
		}
		
		/**
		 * Amf fault for submitAnswer call
		*/
		public function onAnswerFault(msg:Object):void {
			trace("onAnswerFault: " + msg);
		}
		
		/**
		 * Amf success for getQuestion call
		*/
		public function onQuestionResult(msg:Object):void {
			trace("onQuestionResult: " + msg);
			if(_loadingIndicator != null) _loadingIndicator.visible = false;
			// check if the response has an error code
			if("code" in msg) {
				if("message" in msg) showMessage(msg.message);
				else showMessage(TRIVIA_ERROR + "  " + TRY_AGAIN);
			} else {
				if(_questionClip != null) _questionClip.showQuestion(msg);
			}
		}
		
		/**
		 * Amf fault for getQuestion call
		*/
		public function onQuestionFault(msg:Object):void {
			trace("onQuestionFault: " + msg);
			if(_loadingIndicator != null) _loadingIndicator.visible = false;
		}

	}
	
}