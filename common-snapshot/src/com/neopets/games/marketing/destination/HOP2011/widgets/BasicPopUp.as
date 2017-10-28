/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.BroadcastEvent;
	
	import virtualworlds.lang.TranslationManager;
	
	public class BasicPopUp extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const POPUP_SHOWN:String = "BasicPopUp_shown";
		public static const POPUP_CLOSED:String = "BasicPopUp_closed";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BasicPopUp():void {
			super();
			visible = false; // hide by default
			// set up broadcaster listeners
			useParentDispatcher(MovieClip);
			addParentListener(MovieClip,POPUP_SHOWN,onPopUpShown);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function close():void {
			if(visible) {
				visible = false;
				broadcast(POPUP_CLOSED);
			}
		}
		
		public function show():void {
			if(!visible) {
				visible = true;
				broadcast(POPUP_SHOWN);
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
		
		// This function is triggered when a pop up request is broadcast through the pop up's parent.
		
		protected function onPopUpRequest(ev:Event) {
			show();
		}
		
		// This function lets the pop up react to any other pop up openning.
		
		protected function onPopUpShown(ev:BroadcastEvent) {
			if(ev.sender != this) onCloseRequest();
		}
		
		// This function hides the pop up when the close button is clicked.
		
		public function onCloseRequest(ev:Event=null) {
			close();
		}

	}

	
}