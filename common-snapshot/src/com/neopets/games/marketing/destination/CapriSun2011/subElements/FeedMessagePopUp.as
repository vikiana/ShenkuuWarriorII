/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.CapriSun2011.subElements
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.LogInMessage;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.FeedAPetPage;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.feed.PetLoader;
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class FeedMessagePopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const FEED_ERROR:String = "Oops, this pet could not be fed.";
		public static const FEED_FAILED:String = "I've already been fed.  Please try again tomorrow.";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _mainText:TextField;
		protected var _thanksMessages:Array;
		protected var _petClip:PetLoader;
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedMessagePopUp():void {
			super();
			initThanks(); // set up our "thanks" message list
			// set up components
			_mainText = getChildByName("main_txt") as TextField;
			_petClip = getChildByName("pet_mc") as PetLoader;
			// check login status
			var tag:String = Parameters.userName;
			
			//tag = "Grue"; // comment in to test logged in status locally 
			if(tag == null || tag == AbsView.GUEST_USER || tag == "false") 
				showLogIn();
			
			if (Parameters.loggedIn == false)
			{
				showLogIn();
			}
			//onPetFed(); // comment this is to test "thank you" messages
			MovieClip(_closeButton).buttonMode = true;
			MovieClip(_closeButton).mouseEnabled = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_REQUESTED,onFeedRequest);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_COMPLETED,onPetFed);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_FAILED,onFeedFail);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(POPUP_SHOWN,onPopUpShown);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_REQUESTED,onFeedRequest);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_COMPLETED,onPetFed);
				_sharedDispatcher.addEventListener(FeedAPetPage.FEED_FAILED,onFeedFail);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function showLogIn():void {
			if(_mainText != null) {
				var msg:LogInMessage = new LogInMessage("feed your Neopets");
				_mainText.htmlText = msg.toString();
			}
			if(_petClip != null) {
				_petClip.content = GeneralFunctions.getInstanceOf("LogInSpeaker") as DisplayObject;
			}
			visible = true; // show message
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// This function set up our list of possible "thanks for feeding me" messages.
		// This function is meant to overriden by subclasses.
		
		protected function initThanks():void {
			_thanksMessages = new Array();
			_thanksMessages.push("Thanks for a fun snack, I'm ready for another ride!");
			_thanksMessages.push("This is so much FUN! I love trying the food around here!");
			_thanksMessages.push("Thanks, that was the most exciting snack I've ever had!");
			_thanksMessages.push("Yum! That snack was so tasty. I'm thrilled we could come here!");
			_thanksMessages.push("What a delicious treat! Let's come again tomorrow!");
			_thanksMessages.push("Thanks! I want to play some games after this. They look fun!");
			_thanksMessages.push("Aw, you're the best owner. We always get to do exciting stuff.");
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// If feed fails, show error message.
		
		protected function onFeedFail(ev:Event) {
			if(_mainText != null) _mainText.htmlText = FEED_ERROR;
			visible = true; // show message
		}
		
		// Change our pet image when a feed is requested.
		
		protected function onFeedRequest(ev:CustomEvent) {
			if(_petClip != null) {
				var info:Object = ev.oData;
				if(info != null) _petClip.petData = info;
			}
			visible = false; // hide pop up until processing is done
		}
		
		// If feed succeeds, show thanks.
		
		protected function onPetFed(ev:Event=null) {
			if(_mainText != null) {
				var index:int = Math.floor(Math.random() * _thanksMessages.length);
				_mainText.htmlText = _thanksMessages[index];
			}
			visible = true; // show message
		}

	}
	
}