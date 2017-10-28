/**
 *	This pop-up handles both the about text and the trivia system.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.08.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	import com.neopets.games.marketing.destination.kidCuisine2.DestinationData;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.events.CustomEvent;
	
	public class TrainingPopUp extends MessagePopUp
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const ABOUT_ID:String = "About_PopUp";
		public static const TRIVIA_ID:String = "Trivia_PopUp";
		public static const SUCCESS_MSG:String = "That is correct! You have earned 200 Neopoints!";
		public static const ABOUT_TEXT_ID:int = 15613; // Neocontent ID for "about text shown"
		public static const ABOUT_TEXT_SCRIPT:String = "Training Room About Text Read";
		public static const GOOD_ANSWER_SCRIPT:String = "Training Room Daily Trivia Answers Correct";
		public static const BAD_ANSWER_SCRIPT:String = "Training Room Daily Trivia Answers Incorrect";
		public static const NOT_LOGGED_IN:String = "You must be logged in to participate in the daily trivia activity!";
		public static const LOG_IN_LINKS:String = "Why not <a href='%login'><u>login</u></a> or <a href='%signup'><u>sign-up</u></a>?";
		// protected variables
		protected var delegate:AmfDelegate;
		protected var triviaResponse:Object;
		protected var message:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TrainingPopUp():void {
			super();
			// hide the pop-up
			visible = false;
			// set up listeners
			EventHub.addEventListener(PopUpCallButton.POPUP_REQUESTED,onPopUpRequest);
			// set up communication with php
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
			// clear close sound
			closeSound = null;
			// check if the user is logged in
			if(Parameters.userName == null || Parameters.userName == "GUEST_USER_ACCOUNT") {
				var links:String = LOG_IN_LINKS.replace("%login",base_url+"/loginpage.phtml");
				links = links.replace("%signup",base_url+"/signup/index.phtml?");
				message = NOT_LOGGED_IN + "<br/><br/>" + links;
				gotoAndPlay("message");
			}
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 * Called when a pop-up button asks for one of our messages.
		*/
		
		public function initMessageFrame() {
			var child:DisplayObject = getChildByName("message_txt");
			if(child != null) {
				if(child is TextField) {
					var txt:TextField = child as TextField;
					if(message != null) txt.htmlText = message;
				} // end of type check
			}
			show();
		}
		
		public function initQuestionFrame() {
			var child:DisplayObject = getChildByName("question_mc");
			if(child != null) {
				if(child is TrivaQuestionClip) {
					var clip:MovieClip = child as MovieClip;
					clip.questionData = triviaResponse;
					clip.addEventListener(AnswerButton.ANSWER_CHOSEN,onAnswerChosen,false,0,true);
				} // end of type check
			}
			show();
		}
		
		/**
		 * Conceals the pop up.
		*/
		
		public function hide():void {
			visible = false;
		}
		
		/**
		 * Brings the pop up back on screen.
		*/
		
		public function show():void {
			visible = true;
		}
		
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
		 * Called when an answer button has been clicked on.
		*/
		
		public function onAnswerChosen(ev:CustomEvent) {
			trace("onAnswerChosen: "+ev);
			var responder:Responder = new Responder(onAnswerResult,onAnswerFault);
			var campaign_id:int = DestinationData.CAMPAIGN_ID;
			if("aid" in ev.oData) {
				var aid:int = ev.oData.aid;
				if("qid" in triviaResponse && "hash" in triviaResponse) {
					var qid:int = triviaResponse.qid;
					var hash:String = triviaResponse.hash;
					delegate.callRemoteMethod("TriviaService.submitAnswer",responder,campaign_id,qid,aid,hash);
				}
			}
		}
		
		/**
		 * Amf success for submitAnswer call
		*/
		public function onAnswerResult(msg:Object):void {
			trace("onAnswerResult: " + msg);
			if("code" in msg) {
				// check for incorrect answer code
				var code:Number = Number(msg.code);
				if(code == 1005) runJavaScript(BAD_ANSWER_SCRIPT);
				message = msg.message;
			} else {
				runJavaScript(GOOD_ANSWER_SCRIPT);
				message = SUCCESS_MSG;
			}
			gotoAndPlay("message");
		}
		
		/**
		 * Amf fault for submitAnswer call
		*/
		public function onAnswerFault(msg:Object):void {
			trace("onAnswerFault: " + msg);
		}
		
		/**
		 * Called when a pop-up button asks for one of our messages.
		*/
		
		public function onPopUpRequest(ev:RelayedEvent) {
			var caller:Object = ev.source;
			if("popUpID" in caller) {
				switch(caller.popUpID) {
					case ABOUT_ID:
						gotoAndPlay("about");
						show();
						// run tracking
						NeoTracker.instance.trackNeoContentID(ABOUT_TEXT_ID);
						runJavaScript(ABOUT_TEXT_SCRIPT);
						break;
					case TRIVIA_ID:
						// make amfphp call
						var responder:Responder = new Responder(onQuestionResult,onQuestionFault);
						delegate.callRemoteMethod("TriviaService.getQuestion",responder,DestinationData.CAMPAIGN_ID);
						break;
					default:
						hide();
				}
			}
		}
		
		/**
		 * Amf success for getQuestion call
		*/
		public function onQuestionResult(msg:Object):void {
			trace("onQuestionResult: " + msg);
			// wait until the textfield has loaded to process the message
			triviaResponse = msg;
			// test values
			//triviaResponse.qid = 0;
			//triviaResponse.hash = 1;
			//triviaResponse.answers = [{answer:"badger, badger, badger",aid:3},{answer:"mushroom! mushroom!",aid:6}];
			// check if the response is a full question
			if("code" in triviaResponse) {
				message = msg.message;
				gotoAndPlay("message");
			} else gotoAndPlay("question");
		}
		
		/**
		 * Amf fault for getQuestion call
		*/
		public function onQuestionFault(msg:Object):void {
			trace("onQuestionFault: " + msg);
		}
		
	}
	
}