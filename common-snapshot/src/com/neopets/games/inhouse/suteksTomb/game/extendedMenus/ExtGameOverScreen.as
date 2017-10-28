
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.suteksTomb.game.extendedMenus
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
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
	 *
	 *	@NOTE: 	Modified BY Abraham Lee
	 *			This class simply has extended features: has text boxes to show final score
	 *	@since 10.21.2009
	 *	
	 */
	 
	dynamic public class ExtGameOverScreen extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var playAgainBtn:NeopetsButton; 		//On Stage
		public var reportScoreBtn:NeopetsButton; 	//On Stage
		public var finalScoreText:TextField;		//On Stage
		public var finalScore:TextField;			//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ExtGameOverScreen():void
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
		
		/**
		 * @Note Turns the Interface Buttons on and off
		 * @param		pFlag		Boolean		On/Off
		 */
		 
		public function toggleInterfaceButtons(pFlag:Boolean):void
		{
			playAgainBtn.visible = pFlag;
			reportScoreBtn.visible = pFlag;
		}
		
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
		 	playAgainBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			reportScoreBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "GameOverScreen";
		 }
		 
		
		 
		 
	}
	
}
