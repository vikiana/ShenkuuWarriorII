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
	import com.neopets.util.general.GeneralFunctions;
	
	public class TabClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const TAB_SELECTED:String = "TabClip_selected";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _selected:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TabClip():void {
			super();
			// set up broadcaster listeners
			useParentDispatcher(MovieClip);
			// set up listeners
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(TAB_SELECTED,onTabSelected);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(TAB_SELECTED,onTabSelected);
			}
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(bool:Boolean) {
			if(_selected != bool) {
				_selected = bool;
				if(_selected) {
					gotoAndPlay("on");
					dispatchEvent(new Event(Event.SELECT));
					// if we've been selected let all other tabs in our group know
					if(_sharedDispatcher != null) broadcast(TAB_SELECTED);
				} else gotoAndPlay("off");
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
		
		// Select this tab when clicked on.
		
		protected function onClick(ev:MouseEvent) {
			selected = true;
		}
		
		// This function lets the pop up react to any other pop up openning.
		
		protected function onTabSelected(ev:BroadcastEvent) {
			if(ev != null && ev.sender != this) selected = false;
		}
		
		// Clean up our listeners when we're removed from the stage.
		
		override protected function onRemoved(ev:Event) {
			if(ev != null && ev.target == this) {
				sharedDispatcher = null;
				removeEventListener(MouseEvent.CLICK,onClick);
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			}
		}

	}
	
}