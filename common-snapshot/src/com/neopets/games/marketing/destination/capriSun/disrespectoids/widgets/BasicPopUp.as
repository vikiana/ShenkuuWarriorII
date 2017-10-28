/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	
	public class BasicPopUp extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const POPUP_SHOWN:String = "pop_up_shown";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _closeButton:InteractiveObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BasicPopUp():void {
			super();
			visible = false; // hide by default
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// search for components
			closeButton = getChildByName("close_btn") as InteractiveObject;
		
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get closeButton():InteractiveObject { return _closeButton; }
		
		public function set closeButton(btn:InteractiveObject) {
			// clear listeners
			if(_closeButton != null) {
				_closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			}
			// set button
			_closeButton = btn;
			// set listeners
			if(_closeButton != null) {
				_closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			}
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(POPUP_SHOWN,onPopUpShown);
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
		
		// This function is triggered when a character selection event is broadcast.
		
		protected function onPopUpRequest(ev:BroadcastEvent) {
			visible = true;
			broadcast(POPUP_SHOWN);
		}
		
		// This function lets the pop up react to any other pop up openning.
		
		protected function onPopUpShown(ev:BroadcastEvent) {
			if(ev.sender != this) onCloseRequest();
		}
		
		// This function hides the pop up when the close button is clicked.
		
		public function onCloseRequest(ev:Event=null) {
			visible = false;
		}

	}
	
}