
/* AS3
	Copyright 2008
*/
package com.neopets.projects.gameEngine.gui.Interface
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This is a Simple Menu for the InGame Sceen
	 *	The Button Click Commands are not handled at this level but at the Insatiation of this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	public class GameScreen extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var quitGameButton:NeopetsButton; 		//On Stage
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameScreen():void
		{
			super();
			setupVars();
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
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Setups Variables
		 */
		 
		 private function setupVars():void
		 {
		 	quitGameButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		
			mID = "GameScene";
		 }
		 
		 
	}
	
}
