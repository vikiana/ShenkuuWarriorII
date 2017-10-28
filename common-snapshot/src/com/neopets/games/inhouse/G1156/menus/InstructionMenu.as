
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.G1156.menus
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *	This is a Simple Menu for the Opening Screen
	 *	The Button Click Commands are not handled at this level but at the Insatiation of this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	public class InstructionMenu extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var returnBtn:NeopetsButton; 		//On Stage
		
		public var instructionTextField:TextField; //On Stage
		
		public var instructionTextField2:TextField; // On Stage - Time
		public var instructionTextField3:TextField; // On Stage - Score
		public var instructionTextField4:TextField; // On Stage - Health
		public var instructionTextField5:TextField; // On Stage - Gem
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function InstructionMenu():void
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
		 	returnBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		
			mID = "GameScene";
		 }
		 
		
		 
		 
	}
	
}
