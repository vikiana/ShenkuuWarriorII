
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.ScoreManager;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This is a Simple Menu for the GameOver Screen
	 *	The Button Click Commands are not handled at this level but at the Insantiation of this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	dynamic public class SuperSearch_GameOverScreen extends GameOverScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _reportField:TextField;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearch_GameOverScreen():void
		{
			super();
			// check for components
			_reportField = getChildByName("gameOverTextField") as TextField;
			// add listeners to menu manager
			var menus:MenuManager = MenuManager.instance;
			menus.addEventListener(menus.MENU_NAVIGATION_EVENT,onMenuNavigation);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When menu navigation happens check if we've moved to this menu.
		
		protected function onMenuNavigation(ev:CustomEvent) {
			var nav_id:String = ev.oData.MENU;
			if(nav_id == mID) {
				// if so, try updating our score text
				if(_reportField != null) {
					// get game over text
					var translator:TranslationManager = TranslationManager.instance;
					var header:String = translator.getTranslationOf("IDS_MSG_GAMEOVER");
					// get score text
					var score_manager:ScoreManager = ScoreManager.instance;
					var score_str:String = translator.getTranslationOf("IDS_YOUR_SCORE_TXT");
					score_str = score_str.replace("%1",score_manager.getValue());
					// set textfield text
					var report_str:String = header + "\n<br>" + score_str;
					translator.setTextField(_reportField,report_str);
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
