
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.util
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	Tabs are a variant of toggle buttons that are automatically deselected when another
	 *  tab in the same set is selected.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.23.2010
	 */
	 
	public class TabButton extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const TAB_SELECTED:String = "tab_selected"; // called when any member of set is selected
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _sharedDispatcher:EventDispatcher;
		protected var _selected:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TabButton():void{
			super();
			// set up listeners
			addEventListener(MouseEvent.CLICK,onClick);
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			// enable roll over effect
			buttonMode = true;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get sharedDispatcher():EventDispatcher { return _sharedDispatcher; }
		
		public function set sharedDispatcher(caller:EventDispatcher) {
			// clear previous listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(TAB_SELECTED,onTabSelected);
			}
			// we can not be set as our own shared dispatcher
			if(_sharedDispatcher != this) {
				// set up new listeners
				_sharedDispatcher = caller;
				if(_sharedDispatcher != null) {
					_sharedDispatcher.addEventListener(TAB_SELECTED,onTabSelected);
				}
			} else _sharedDispatcher = null;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(bool:Boolean) {
			if(_selected != bool) {
				_selected = bool;
				if(_selected) {
					gotoAndPlay("on");
					dispatchEvent(new Event(Event.SELECT));
					// if we've been selected let all other tabs in our group know
					if(_sharedDispatcher != null) {
						var ev:CustomEvent = new CustomEvent(this,TAB_SELECTED);
						_sharedDispatcher.dispatchEvent(ev);
					}
				} else gotoAndPlay("off");
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to force the selection state independant of linked tabs.
		
		public function initSelected(bool:Boolean) {
			_selected = bool;
			if(_selected) gotoAndPlay("on");
			else gotoAndPlay("off");
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Set our parent as our default dispatcher when added to the stage.
		
		protected function onAdded(ev:Event) {
			if(parent != null) {
				if(_sharedDispatcher == null) sharedDispatcher = parent;
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		// Select this tab when clicked on.
		
		protected function onClick(ev:MouseEvent) {
			selected = true;
		}
		
		// When a tab in our group is selected, deselect this one.
		
		protected function onTabSelected(ev:CustomEvent) {
			if(ev != null && ev.oData != this) selected = false;
		}
		
		// Clean up our listeners when we're removed from the stage.
		
		override protected function onRemoved(ev:Event) {
			if(ev != null && ev.target == this) {
				defaultDispatcher = null;
				sharedDispatcher = null;
				// strip out all recorded parent listeners
				clearParentListener();
				// remove all other listeners
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
				removeEventListener(MouseEvent.CLICK,onClick);
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
