
/* AS3
	Copyright 2008
*/
package com.neopets.projects.gameEngine.gui.Interface
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
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
	 
	public class OpeningScreen extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var txtFld_title:TextField;							//On Stage
		
		public var txtFld_copyright:TextField;  					//On Stage
		
		public var startGameButton:NeopetsButton; 		//On Stage
		
		public var instructionsButton:NeopetsButton;		//On Stage
		
		public var musicToggleBtn:SelectedButton; 			//On Stage
		
		public var soundToggleBtn:SelectedButton; 			//On Stage
		
		public var mcTransLogo:MovieClip;						//On Stage > The Translation Movie Clip
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function OpeningScreen():void
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
		 	soundToggleBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		 	musicToggleBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		 	startGameButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			instructionsButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "IntroScene";
			
			mButtonArray = new Array();
			//mButtonArray = new Vector.<NeopetsButton>(); // Vector not supported by Flash Player 9
			mButtonArray.push (soundToggleBtn,musicToggleBtn,startGameButton,instructionsButton);
				
			
		 }
		 
		 
	}
	
}
