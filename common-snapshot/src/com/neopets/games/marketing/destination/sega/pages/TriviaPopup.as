/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/ Viviana Baldarelli
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.sega.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------

	import com.mtvnet.vworlds.util.events.CustomEvent;
	import com.neopets.games.marketing.destination.altadorbooths.common.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.altadorbooths.common.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.sega.widgets.QuestionBlock;
	import com.neopets.games.marketing.destination.sega.widgets.TriviaCallButton;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.Responder;
	import flash.text.TextField;
	
	import virtualworlds.net.AmfDelegate;
	
	public class TriviaPopup extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const TRIVIA_ERROR:String = "There's a problem with the trivia question.";
		public static const TRY_AGAIN:String = "Please try again later.";
		public static const POPUP_SHOWN:String = "pop_up_shown";
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// global variables
		public static var CAMPAIGN_ID:int = 12;
		public static var SUCCESS_MSG:String = "That is correct! You have earned 200 Neopoints!";
		public static var BAD_ANSWER:String = "That is incorrect.  Please try again tomorrow!";
		
		// local variables
		protected var _loggedIn:Boolean;
		protected var _delegate:AmfDelegate;
		protected var _selectedAnswer:Object;
		public var question_mc:QuestionBlock;
		
		//objects on stage 
		public var triviaclose_btn:MovieClip;
		public var triviasubmit_btn:MovieClip;
		//public var triviahint_btn:MovieClip;
		public var message_text:TextField;
		public var loading_mc:MovieClip;
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TriviaPopup(pName:String=null):void {
			super();
			triviasubmit_btn.label_txt.htmlText = "SUBMIT";
			//triviahint_btn.label_txt.htmlText = "Hint";
			//triviaclose_btn.label_txt.htmlText = "Close";
			triviasubmit_btn.gotoAndStop(1);
			//triviahint_btn.gotoAndStop(1);
			triviaclose_btn.gotoAndStop(1);
			//triviahint_btn.visible = false;
			triviasubmit_btn.visible = false;
			//triviaclose_btn.x = 205;

			//set up vars and listeners
			if (pName){
				name = pName
			}
			questionClip = question_mc;
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true)
			triviasubmit_btn.addEventListener(MouseEvent.CLICK, submitAnswer, false, 0, true);
			//set up initial layout
			message_text.visible = false;
			// set up amfphp connection
			//setupAMFPHP();
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			//_loggedIn = (tag != null && tag != AbsView.GUEST_USER);
		}
	
		
		//TODO : add this to submit button
		/*// make amfphp call
		var responder:Responder = new Responder(onAnswerResult,onAnswerFault);
		_delegate.callRemoteMethod("TriviaService.submitAnswer",responder,CAMPAIGN_ID,qid,aid,hash);
		*/
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get questionClip():QuestionBlock { return question_mc; }
		
		public function set questionClip(clip:QuestionBlock) {
			// clear listeners
			if(question_mc != null) {
				question_mc.removeEventListener(QuestionBlock.ANSWER_SELECTED,onAnswerSelected);
			}
			question_mc = clip;
			// set up listeners
			if(question_mc != null) {
				question_mc.addEventListener(QuestionBlock.ANSWER_SELECTED,onAnswerSelected);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to send to show a text message in place of our trivia block.
		public function showMessage(msg:String) {
			if(message_text != null) message_text.htmlText = msg;
			message_text.visible = true;
			if(loading_mc != null) loading_mc.visible = false;
			if(question_mc != null) question_mc.visible = false;
			visible = true;
		}
		
		// Use this function to start loading the daily trivia question.
		public function showTrivia():void {
			if(message_text != null) message_text.htmlText = "";
			if(loading_mc != null) loading_mc.visible = true;
			// make amfphp call
			trace("Show Trivia: Campaign ID: " + CAMPAIGN_ID);
			var responder:Responder = new Responder(onQuestionResult,onQuestionFault);
			Parameters.connection.call("TriviaService.getQuestion",responder,CAMPAIGN_ID);
			visible = true;
		}
		
		
		//from absPageWithButtonState
		//Clean up is called when it is the page is removed from the stage by DestinationControl
		public function cleanup():void 
		{
			if (Parameters.view != null && Parameters.view.hasEventListener(AbsView.OBJ_CLICKED))
			{
				Parameters.view.removeEventListener(AbsView.OBJ_CLICKED, handleObjClick);
			}
			removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut)
			question_mc.cleanup();
			//removeAllChildren(this)
		}		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to establish communication with php.
		/*protected function setupAMFPHP():void {
			_delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			_delegate.gatewayURL = base_url + "/amfphp/gateway.php";
			_delegate.connect();
		}*/
		
		
		//The following functions are some basic behaviours ported from AnsPageWithButtonState that this page cannot extend since it's extending something else
		protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnAreaLink")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndPlay (2)
			}
		}
		
		
		/**
		 *	Default is set have no filter on the display object when MouseOut.
		 *	For different effects, child class should override this function
		 *
		 *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		 *	@NOTE: If the display Object has a "out" state (as frame lable) it'll stop at that state
		 **/
		protected function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnAreaLink")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop(1)
			}
		}
		
		//clicks are all handled by the control class
		protected function handleObjClick(e:CustomEvent):void{};
		
		
		
		protected function removeAllChildren(displayObj:DisplayObject):void
		{
			while ((displayObj as Sprite).numChildren) 
			{
				(displayObj as Sprite).removeChildAt(0)
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function submitAnswer (e:MouseEvent):void {
			if (_selectedAnswer){
				triviasubmit_btn.visible = false;
				//triviaclose_btn.x = 205;
				var responder:Responder = new Responder(onAnswerResult,onAnswerFault);
				Parameters.connection.call("TriviaService.submitAnswer",responder,CAMPAIGN_ID,_selectedAnswer.qid,_selectedAnswer.aid,_selectedAnswer.hash);
				//quest record
				Parameters.connection.call("AltadorAlley2010Service.popRecordActivity", null , "trivia");
			} 
		}
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		//sets the answer to be sent with the submit button
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
			_selectedAnswer = {qid:qid, aid:aid, hash:hash}
		}
		
		// This function is triggered when a character selection event is broadcast.
		/*protected function onPopUpRequest(ev:BroadcastEvent):void {
			// update view
			if(_loggedIn) showTrivia();
			else showLogin();
			broadcast(POPUP_SHOWN);
		}*/
		
		// AMFPHP Events
		/**
		 * Amf success for submitAnswer call
		 */
		public function onAnswerResult(msg:Object):void {
			//tracking
			TrackingProxy.sendReportingCall('Daily Trivia Played','SonicColors2010');
			trace("onAnswerResult: " + msg);
			if("code" in msg) {
				trace ("code", msg.code);
				// check for incorrect answer code
				//var code:Number = Number(msg.code);
				//if(code == 1005) runJavaScript(BAD_ANSWER_SCRIPT);
				if("message" in msg) {
					showMessage(msg.message);
					trace ("message", msg.message);
				}
				else{ showMessage(BAD_ANSWER)};
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
			if(loading_mc != null) loading_mc.visible = false;
			// check if the response has an error code
			if("code" in msg) {
				if("message" in msg) showMessage(msg.message);
				else showMessage(TRIVIA_ERROR + "  " + TRY_AGAIN);
				//triviahint_btn.visible = false;
				//triviasubmit_btn.visible = false;
				//triviaclose_btn.x = 205;
			} else {
				if(question_mc != null) question_mc.showQuestion(msg);
				//triviahint_btn.visible = true;
				triviasubmit_btn.visible = true;
				//triviaclose_btn.x = 136;
			}
		}
		
		/**
		 * Amf fault for getQuestion call
		 */
		public function onQuestionFault(msg:Object):void {
			trace("onQuestionFault: " + msg);
			if(loading_mc != null) loading_mc.visible = false;
			//triviahint_btn.visible = false;
			//triviasubmit_btn.visible = false;
			//triviaclose_btn.x = 205;
		}
		
	}
	
}