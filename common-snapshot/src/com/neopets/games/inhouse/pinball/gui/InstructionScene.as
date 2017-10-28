
/* AS3
	Copyright 2009
*/
package com.neopets.games.inhouse.pinball.gui
{
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;


	
	/**
	 *	This is for the HelpScreen
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern gameEngine, PinBall, Ape
	 * 
	 *	@author Clive Henrick
	 *	@since  6.17.2009
	 */
	 
	public class InstructionScene extends GameScene
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const STARTX:Number = 100;
		public const STARTY:Number = 75;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		public var InstructionHelpBtn:NeopetsButton;		//This is on Stage
		public var instructionTF:TextField; //This is on Stage
		public var textBox:TextField;			//This is on Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function InstructionScene()
		{
			super();
			InstructionHelpBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
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
		
		/**
		 * @Note: When a Btn of the Stage is Clicked
		 */
		 
		private function MouseClicked(evt:Event):void
		{
			this.dispatchEvent(new CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_EVENT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	
	}
	
}
