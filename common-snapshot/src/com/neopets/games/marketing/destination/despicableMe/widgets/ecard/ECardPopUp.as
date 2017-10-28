/**
 *	This class shows the ecard sender if logged in or an error message if logged out.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.ecard
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
	
	import com.neopets.games.marketing.destination.despicableMe.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.despicableMe.widgets.ecard.ECardButton;
	import com.neopets.games.marketing.destination.despicableMe.widgets.ecard.ECardSender;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.games.marketing.destination.despicableMe.LogInMessage;
	
	public class ECardPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _sender:ECardSender;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ECardPopUp():void {
			super();
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			if(tag != null && tag != AbsView.GUEST_USER) {
				gotoAndPlay("logged_in");
				addEventListener(Event.ENTER_FRAME,findSender);
			} else {
				gotoAndPlay("logged_out");
				addEventListener(Event.ENTER_FRAME,findErrorText);
			}
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
		
		public function get sender():ECardSender { return _sender; }
		
		public function set sender(clip:ECardSender) {
			// clear listeners
			if(_sender != null) {
				_sender.removeEventListener(Event.COMPLETE,onCardSent);
			}
			_sender = clip;
			// set up listeners
			if(_sender != null) {
				_sender.addEventListener(Event.COMPLETE,onCardSent);
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
		
		// This function is called each frame to find the ecard sender.
		
		protected function findErrorText(ev:Event=null) {
			var txt:TextField = DisplayUtils.getDescendantInstance(this,TextField) as TextField;
			if(txt != null) {
				var msg:LogInMessage = new LogInMessage("send an e-card");
				txt.htmlText = msg.toString();
				removeEventListener(Event.ENTER_FRAME,findErrorText);
			}
		}
		
		// This function is called each frame to find the ecard sender.
		
		protected function findSender(ev:Event=null) {
			sender = DisplayUtils.getDescendantInstance(this,ECardSender) as ECardSender;
			if(_sender != null) removeEventListener(Event.ENTER_FRAME,findSender);
		}
		
		// This function checks if our child card send has finished sending the ecard.
		
		protected function onCardSent(ev:Event) {
			visible = false;
		}

	}
	
}