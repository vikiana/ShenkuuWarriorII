/**
 *	This class handles sending out ECards.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.widgets.TriviaCallButton;
	import com.neopets.games.marketing.destination.despicableMe.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.despicableMe.LogInMessage;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.util.general.GeneralFunctions;
	
	public class InstructionsPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// global variables
		public static var INSTRUCTION_HEADER:String = "Instructions:"; 
		public static var INSTRUCTION_TEXT:String;
		public static var LOGIN_HEADER:String = "Please Log In:"; 
		// components
		protected var _titleField:TextField;
		protected var _messageField:TextField;
		// local variables
		protected var _loggedIn:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function InstructionsPopUp():void {
			INSTRUCTION_TEXT = "It looks like the pouches have gotten fed up with being disrespected and have hidden throughout the Disrespectoids Clubhouse. Can you find each wayward pouch?  All you have to do is check your Task List for hints of each pouch's location. Once you've cracked the clue and found the pouch, you'll be awarded Neopoints. Completing more tasks will earn you extra prizes. Plus, an extra-special virtual prize awaits those who can finish the quest.  Now show those pouches some respect and get going!";
			super();
			// set up components
			_titleField = getChildByName("title_txt") as TextField;
			_messageField = getChildByName("main_txt") as TextField;
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			loggedIn = (tag != null && tag != AbsView.GUEST_USER);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get loggedIn():Boolean { return _loggedIn; }
		
		public function set loggedIn(bool:Boolean) {
			_loggedIn = bool;
			if(!_loggedIn) showLogin();
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(InstructionCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(InstructionCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.addEventListener(POPUP_SHOWN,onPopUpShown);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// If not logged in show login text.
		
		public function showLogin():void {
			var msg:LogInMessage = new LogInMessage("earn Neopoints and win prizes");
			showMessage(LOGIN_HEADER,msg.toString());
		}
		
		// Use this function to send to show a text message in place of our trivia block.
		
		public function showMessage(header:String,msg:String) {
			if(_titleField != null) _titleField.htmlText = header;
			if(_messageField != null) _messageField.htmlText = msg;
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
		
		// This function is triggered when a character selection event is broadcast.
		
		override protected function onPopUpRequest(ev:Event) {
			showMessage(INSTRUCTION_HEADER,INSTRUCTION_TEXT);
			broadcast(POPUP_SHOWN);
		}

	}
	
}