
/* AS3
	Copyright 2008
*/
package com.neopets.examples.vendorShell.menus
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *	This is a Simple Menu for the Opening Screen
	 *  @Note this is an example of extending a Menu
	 *	The Button Click Commands are not handled at this level but at the Insatiation of this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	dynamic public class NewGameOverScreen extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var playAgainBtn:NeopetsButton; 		//On Stage
		public var reportScoreBtn:NeopetsButton; 		//On Stage
		
		public var txtField_finalTime:TextField;		// On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NewGameOverScreen():void
		{
			super();
			setupExtendedVars();
	
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
		
		/**
		 * Sets the TextField
		 * @param		finalTime		Number 		The Text you want in the TextField
		 */
		 
		public function setFinalTime(finalTime:Number):void {
			txtField_finalTime.text = String(finalTime);
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
		 
		 private function setupExtendedVars():void
		 {

			reportScoreBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			playAgainBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "NewGameOverScreen";
		 }
		 
		
		 
		 
	}
	
}
