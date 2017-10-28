/**
 *	This class shows the ecard sender if logged in or an error message if logged out.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.sixFlags2010.ecard
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.LogInMessage;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.sixFlags2010.ecard.ECardButton;
	import com.neopets.games.marketing.destination.sixFlags2010.ecard.ECardSender;

	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.general.GeneralFunctions;
	

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ECardPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ECARD_RESULT_TEXT:String = "Your ECard has been sent!";
		public static const ECARD_FAULT_TEXT:String = "Sorry, your ECard could not be sent.  Please try again later.";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _loggedIn:Boolean;
		protected var _messageField:TextField;
		protected var _sender:ECardSender;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ECardPopUp():void {
			super();
			// set up components
			_messageField = getChildByName("main_txt") as TextField;
			sender = getChildByName("sender_mc") as ECardSender;
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			_loggedIn = (tag != null && tag != AbsView.GUEST_USER);
			_messageField.visible = false;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(ECardButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(ECardButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.addEventListener(POPUP_SHOWN,onPopUpShown);
			}
		}
		
		public function get sender():com.neopets.games.marketing.destination.sixFlags2010.ecard.ECardSender {return _sender;}
		
		//public function get sender():ECardSender { return _sender; }
		
		public function set sender(clip:ECardSender) {
			// clear listeners
			if(_sender != null) {
				_sender.removeEventListener(ECardSender.ECARD_RESULT,onCardResult);
				_sender.removeEventListener(ECardSender.ECARD_FAULT,onCardFault);
			}
			_sender = clip;
			// set up listeners
			if(_sender != null) {
				_sender.addEventListener(ECardSender.ECARD_RESULT,onCardResult);
				_sender.addEventListener(ECardSender.ECARD_FAULT,onCardFault);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// If not logged in show login text.
		
		public function showLogin():void {
			var msg:LogInMessage = new LogInMessage("send an e-card");
			showMessage(msg.toString());
		}
		
		// Use this function to send to show a specified text message with header.
		
		public function showMessage(msg:String):void {
			if(_messageField != null) _messageField.htmlText = msg;
			if(_sender != null) _sender.visible = false;
			_messageField.visible = true;
			visible = true;
			broadcast(POPUP_SHOWN);
		}
		
		// Use this function to send to show a specified text message with header.
		
		public function showSender():void {
			if(_messageField != null) _messageField.htmlText = "";
			if(_sender != null) _sender.visible = true;
			_messageField.visible = false;
			visible = true;
			broadcast(POPUP_SHOWN);
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
		
		override protected function onPopUpRequest(ev:BroadcastEvent) {
			if(_loggedIn) showSender();
			else showLogin();
		}
		
		// This function checks if our child card send got a fault on the send card attempt.
		
		protected function onCardFault(ev:Event) {
			showMessage(ECARD_FAULT_TEXT);
		}
		
		// This function checks if our child card sender has finished sending the ecard.
		
		protected function onCardResult(ev:Event) {
			showMessage(ECARD_RESULT_TEXT);
		}

	}
	
}