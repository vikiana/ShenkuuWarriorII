/**
 *	This class handles basic pop up behaviour.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  06.22.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.EventFunctions;
	
	dynamic public class BasicPopUp extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const POPUP_OPENED:String = "BasicPopUp_opened";
		public static const POPUP_CLOSED:String = "BasicPopUp_closed";
		public static const POPUP_REQUESTED:String = "BasicPopUp_requested";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _closeButton:DisplayObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BasicPopUp():void {
			super();
			// set up components
			closeButton = getChildByName("close_btn");
			// hide pop ups by default
			visible = false;
			// set up parent listeners
			addParentListener(MovieClip,POPUP_REQUESTED,onPopUpRequest);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get closeButton():DisplayObject { return _closeButton; }
		
		public function set closeButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_closeButton,dobj,MouseEvent.CLICK,onCloseRequest);
			// store new component
			_closeButton = dobj;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function close():void {
			if(visible) {
				visible = false;
				broadcast(POPUP_CLOSED);
			}
		}
		
		public function open():void {
			if(!visible) {
				visible = true;
				broadcast(POPUP_OPENED);
			}
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
		
		// When a close request comes in, hide this pop up.
		
		protected function onCloseRequest(ev:Event=null) { close(); }
		
		// When a pop up is requested, check if this is the target pop up.
		
		protected function onPopUpRequest(ev:CustomEvent) {
			// Open this pop up if it's the one requested.
			// If another pop up is being requested, close this pop up.
			if(ev.oData == this) open();
			else close();
		}

	}
	
}