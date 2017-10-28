
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
	 
	public class GameOverScene extends GameScene
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		public var sendScoreBtn:NeopetsButton;		//This is on Stage
		public var restartGameBtn:NeopetsButton;		//This is on Stage
		public var textBox:TextField 		//This is on Stage
		public var scoreBox:TextField		// is on stage
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function GameOverScene()
		{
			super();
			sendScoreBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			restartGameBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
	
	
		public function showScore(pScore:int):void
		{
			scoreBox.text = pScore.toString();
		}
	
	/**
	 * @Note: Hides the Interface Buttons
	 */
	 
		public function hideButtons():void
		{
			sendScoreBtn.displayFlag = false;
			restartGameBtn.displayFlag = false;
		}
		
	/**
	 * @Note: Shows the Interface Buttons
	 */
	 
		public function showButtons():void
		{
			
			sendScoreBtn.displayFlag = true;
			restartGameBtn.displayFlag = true;
		}
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
