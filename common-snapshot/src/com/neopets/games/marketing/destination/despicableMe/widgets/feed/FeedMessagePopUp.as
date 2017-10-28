/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.feed
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.games.marketing.destination.despicableMe.pages.FeedAPetPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.marketing.destination.despicableMe.widgets.BasicPopUp;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.games.marketing.destination.despicableMe.LogInMessage;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	
	public class FeedMessagePopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _mainText:TextField;
		protected var _petClip:PetLoader;
		public var thanksCount:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedMessagePopUp():void {
			super();
			thanksCount = 11;
			// set up components
			_mainText = getChildByName("main_txt") as TextField;
			_petClip = getChildByName("pet_mc") as PetLoader;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(DestinationView.SHOW,onPageShown);
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_REQUESTED,onFeedRequest);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_COMPLETED,onPetFed);
				_sharedDispatcher.removeEventListener(FeedAPetPage.FEED_FAILED,onFeedFail);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(DestinationView.SHOW,onPageShown);
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
				var msg:LogInMessage = new LogInMessage("IDS_FEED_LOG_IN");
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
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// If feed fails, show error message.
		
		protected function onFeedFail(ev:Event) {
			if(_mainText != null) setTranslation(_mainText,"IDS_FEED_FAILED");
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
		
		// When the page is shown, check our login status.
		
		protected function onPageShown(ev:Event) {
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			if(tag == null || tag == AbsView.GUEST_USER) showLogIn();
			else visible = false;
			//onPetFed(); // comment this is to test "thank you" messages
		}
		
		// If feed succeeds, show thanks.
		
		protected function onPetFed(ev:Event=null) {
			if(_mainText != null) {
				var index:int = Math.floor(Math.random() * thanksCount) + 1;
				setTranslation(_mainText,"IDS_FEED_THANKS_" + index);
			}
			visible = true; // show message
		}

	}
	
}