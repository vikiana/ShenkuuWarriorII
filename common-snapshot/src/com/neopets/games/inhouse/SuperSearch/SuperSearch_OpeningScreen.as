
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.util.button.NeopetsButton;
	
	
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
	 
	dynamic public class SuperSearch_OpeningScreen extends OpeningScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public var aboutButton:NeopetsButton;		//On Stage
		public var visitSiteButton:NeopetsButton;		//On Stage
		
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SuperSearch_OpeningScreen():void
		{
			super();
			// add listeners for new buttons
			if(visitSiteButton != null) {
				visitSiteButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			}
			if(aboutButton != null) {
				aboutButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			}
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

		 
	}
	
}
