
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.events.Event;
	
	import com.neopets.util.general.GeneralFunctions;
	
	/**
	 *	This class contains and handles multiple menus.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  05.04.2010
	 */
	 
	public class MenuShell extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _menus:Array;
		protected var _currentMenu:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function MenuShell():void{
			_menus = new Array();
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get currentMenu():DisplayObject { return _currentMenu; }
		
		public function set currentMenu(menu:DisplayObject) {
			// check if the target is one of our menus
			if(_menus.indexOf(menu) < 0) return;
			// hide the previous menu
			var clip:MovieClip;
			if(_currentMenu != null) callHideFor(_currentMenu);
			// show the new menu
			_currentMenu = menu;
			if(_currentMenu != null) callShowFor(_currentMenu);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to add a new menu of the given class to this shell.
		// param		class_name		String		Name of the class for the new menu.
		
		public function addMenu(class_name:String):DisplayObject {
			if(class_name == null || class_name.length < 1) return null;
			// check if the menu already exists
			var menu:DisplayObject = getMenu(class_name);
			if(menu != null) return menu;
			// if not, add an new instance of the class
			menu = GeneralFunctions.getDisplayInstance(class_name);
			_menus.push(menu);
			// add listeners to new menu
			menu.addEventListener(Event.REMOVED,onMenuRemoved);
			// add menu to stage
			addChild(menu);
			// if no menu has been selected, show this one
			if(_currentMenu == null) currentMenu = menu;
			else callHideFor(menu);
			return menu;
		}
		
		// Use this function to add a new menu of the given class to this shell.
		// param		class_name		String		Name of the class for the new menu.
		
		public function getMenu(class_name:String):DisplayObject {
			if(class_name == null || class_name.length < 1) return null;
			// extract class definition
			var domain:ApplicationDomain = ApplicationDomain.currentDomain;
			if(!domain.hasDefinition(class_name)) return null;
			var class_def = domain.getDefinition(class_name);
			// cycle through our menu list
			var menu:DisplayObject;
			for(var i:int = 0; i < _menus.length; i++) {
				menu = _menus[i];
				if(menu is class_def) return menu;
			}
			return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function clears linkages and listeners when a menu is taken off stage.
		
		protected function onMenuRemoved(ev:Event) {
			var menu:DisplayObject = ev.target as DisplayObject;
			if(menu == null) return;
			// remove ourselves from the menu list
			var index:int = _menus.indexOf(menu);
			if(index < 0) return; // abort if the target isn't on our menu list
			_menus.splice(index,1);
			// if we're the current menu, clear the link
			if(_currentMenu == menu) _currentMenu = null;
			// remove our listeners
			menu.removeEventListener(Event.REMOVED,onMenuRemoved);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function tries to hide a given display object.
		
		protected function callHideFor(dobj:DisplayObject):void {
			if(dobj == null) return;
			var clip:MovieClip = dobj as MovieClip;
			if(clip != null && "hide" in clip) clip.hide();
			else dobj.visible = false;
		}
		
		// This function tries to show a given display object.
		
		protected function callShowFor(dobj:DisplayObject):void {
			if(dobj == null) return;
			var clip:MovieClip = dobj as MovieClip;
			if(clip != null && "show" in clip) clip.show();
			else dobj.visible = true;
		}
		
	}
	
}
