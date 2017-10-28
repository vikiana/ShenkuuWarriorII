
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.MenuShell;
	
	/**
	 *	This class lets a movie clip take advantage of the menu shell structure.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  05.04.2010
	 */
	 
	public class MenuClip extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static var MENU_SHOWN:String = "menu_shown";
		public static var MENU_HIDDEN:String = "menu_hidden";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function MenuClip():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to request another menu from our menu shell.
		
		public function callMenu(class_name:String):void {
			// check for a menu shell
			var shell:MenuShell = DisplayUtils.getAncestorInstance(this,MenuShell) as MenuShell;
			if(shell == null) return;
			// check if the requested menu exists
			var menu:DisplayObject = shell.getMenu(class_name);
			if(menu != null) shell.currentMenu = menu;
		}
		
		// Use this function to conceal this clip.
		
		public function hide():void {
			visible = false;
			var ev:Event = new Event(MENU_HIDDEN);
			dispatchEvent(ev);
		}
		
		// Use this function to reveal this clip.
		
		public function show():void {
			visible = true;
			var ev:Event = new Event(MENU_SHOWN);
			dispatchEvent(ev);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
