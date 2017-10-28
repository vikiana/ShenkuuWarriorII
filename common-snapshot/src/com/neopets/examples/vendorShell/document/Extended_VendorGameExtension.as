
/* AS3
	Copyright 2008
*/
package com.neopets.examples.vendorShell.document
{
	import com.neopets.examples.vendorShell.menus.NewMenuManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.np9.vendorInterface.NP9_VendorGameExtension;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This is some Neopets Functions that you will need for translation and Menu Control
	 *	You Should Have your Main Game Engine Extend this Class
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Neopets Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.10.2009
	 */
	 
	public class Extended_VendorGameExtension extends NP9_VendorGameExtension 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mNewMenuManager:NewMenuManager;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Extended_VendorGameExtension():void{
			setVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public override  function getMenuManager():MenuManager
		{
			return mNewMenuManager;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		 
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
			/**
		 * @Note: This is all the Startup Vars
		 */
		 
		protected override  function setVars():void
		{	
			mNewMenuManager = new NewMenuManager();
			mNewMenuManager.addEventListener(mNewMenuManager.MENU_EVENT, onMenuEvent, false, 0, true);
			mNewMenuManager.addEventListener(mNewMenuManager.MENU_BUTTON_EVENT, onMenuButtonEvent, false, 0, true);
			mNewMenuManager.addEventListener(mNewMenuManager.MENU_MANAGER_READY, onMenuManagerReady,false,0,true);
		}
		 
	}
	
}
