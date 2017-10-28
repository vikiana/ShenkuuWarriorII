/**
 *	This class shows the results of a feed a pet attempt.
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
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	import com.neopets.projects.destination.destinationV3.Parameters;
	
	public class FeedPopUp extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const PET_LOADED:String = "pet_loaded";
		public static const NOT_LOGGED_IN:String = "You must be logged in to feed your pets!";
		public static const LOG_IN_LINKS:String = "Why not <a href='%login'><u>login</u></a> or <br/><a href='%signup'><u>sign-up</u></a>?";
		// protected variables
		protected var _petSlot:MovieClip;
		protected var _messageField:TextField;
		protected var message:String;
		protected var _closeButton:MovieClip;
		protected var feedMessages:Array;
		protected var errorMessage:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedPopUp():void {
			// hide the pop-up
			visible = false;
			// set up component linkages
			_petSlot = getChildByName("pet_mc") as MovieClip;
			_messageField = getChildByName("msg_txt") as TextField;
			closeButton = getChildByName("close_btn") as MovieClip;
			// set up messages
			feedMessages = new Array();
			feedMessages.push("<p>This food is Krazy! What other combos can we try?</p>");
			feedMessages.push("<p>Aw, you're the best. You take good care of me.</p>");
			feedMessages.push("<p>Yum! Do you think we can combine two combos? Krazy, right? Haha!</p>");
			feedMessages.push("<p>This food is so much fun! KC is my hero.</p>");
			feedMessages.push("<p>Arrr, mateys! This food is magical! No, wait, it's Krazy!</p>");
			feedMessages.push("<p>Delicious! Thanks for the food. You're a star.</p>");
			feedMessages.push("<p>Thanks! After this, can we play knights and monsters?</p>");
			feedMessages.push("<p>Haha, I totally eat like a caveman. Rawr!</p>");
			feedMessages.push("<p>Yay, this food rocks. Just like you!</p>");
			feedMessages.push("<p>That really hit the spot. Thanks for bringing me.</p>");
			feedMessages.push("<p>Thanks! I was getting really hungry.</p>");
			feedMessages.push("<p>I want to come and have fun here every day!</p>");
			feedMessages.push("<p>Yum, that was delicious AND fun! Thanks so much!</p>");
			feedMessages.push("<p>This food is a lot more fun than what I usually get.</p>");
			feedMessages.push("<p>That meal rocked! You're super. Let's try more combos!</p>");
			errorMessage = "<p>There was an error.  Please try again later.</p>";
			// set up listeners
			EventHub.addEventListener(FeedButton.FEED_STARTED,onFeedStarted);
			EventHub.addEventListener(FeedButton.FEED_COMPLETED,onFeedCompleted);
			EventHub.addEventListener(FeedButton.FEED_FAILED,onFeedFailed);
			//addEventListener(MouseEvent.CLICK,onCloseRequest); // click anywhere to close
			// check if the user is logged in
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			if(Parameters.userName == null || Parameters.userName == "GUEST_USER_ACCOUNT") {
				var links:String = LOG_IN_LINKS.replace("%login",base_url+"/loginpage.phtml");
				links = links.replace("%signup",base_url+"/signup/index.phtml?");
				message = NOT_LOGGED_IN + "<br/><br/>" + links;
				gotoAndPlay("no_image");
			}
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get closeButton():MovieClip { return _closeButton; }
		
		public function set closeButton(clip:MovieClip) {
			// clear previous
			if(_closeButton != null) {
				_closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			}
			// set up new button
			_closeButton = clip;
			if(_closeButton != null) {
				_closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 * Called when a pop-up button asks for one of our messages.
		*/
		
		public function initMessageFrame() {
			_messageField = getChildByName("msg_txt") as TextField;
			if(_messageField != null) {
				if(message != null) _messageField.htmlText = message;
			}
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
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		protected function onCloseRequest(ev:MouseEvent) {
			visible = false;
		}
		
		/**	
		 *	This functions is triggered when a "feed a pet" attempt starts.
		 **/
		
		protected function onFeedStarted(ev:Event) {
			visible = false;
		}
		
		/**	
		 *	This functions is triggered when a "feed a pet" attempt succeeds.
		 **/
		
		protected function onFeedCompleted(ev:RelayedEvent) {
			var info:Object = ev.source.sentPet;
			if(_petSlot != null) _petSlot.petData = info;
			if(_messageField != null) {
				if(feedMessages.length > 0) {
					if(feedMessages.length > 1) {
						var index:Number = Math.floor(Math.random()*feedMessages.length);
						_messageField.htmlText = feedMessages[index];
					} else _messageField.htmlText = feedMessages[0];
				} else _messageField.htmlText = "Pet Fed";
			}
			visible = true;
		}
		
		/**	
		 *	This functions is triggered when a "feed a pet" attempt fails.
		 **/
		
		protected function onFeedFailed(ev:Event) {
			if(_petSlot != null) _petSlot.petData = null;
			if(_messageField != null) _messageField.htmlText = errorMessage;
			visible = true;
		}
		
	}
	
}