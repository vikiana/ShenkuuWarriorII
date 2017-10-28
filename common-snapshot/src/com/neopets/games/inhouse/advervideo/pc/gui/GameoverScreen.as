/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;
	import com.neopets.games.inhouse.advervideo.pc.PCGameEngine;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  7.20.2009
	 */	
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		
	 
	 public class GameoverScreen extends GameOverScreen {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var yourscore_txt:TextField;
		public var yourscore_val:TextField;
		public var rewardBtn:MovieClip;
		public var visitWebsiteButton:MovieClip;
		//public var visitWebsiteButton2:NeopetsButton;	//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function GameoverScreen():void {
			super();
			setupExtendedVars();
			NPTextData.pushCustomText(this, "yourscore_txt", NPTextData.instance.GAMEOVER_YOURSCORE_TXT);
			updateScore();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function inFocus():void {
			trace("@ Game over menu");
 			toggleInterfaceButtons(true);
			updateScore();
		}
		
		public function outFocus():void {
		}
		
		/**
		 * @Note Turns the Interface Buttons on and off
		 * @param		pFlag		Boolean		On/Off
		 */
		 
		public override function toggleInterfaceButtons(pFlag:Boolean):void
		{
			playAgainBtn.visible = pFlag;
			reportScoreBtn.visible = pFlag;
			if (visitWebsiteButton) visitWebsiteButton.visible = !pFlag;
			//if (visitWebsiteButton2) visitWebsiteButton2.visible = !pFlag;
			if (yourscore_txt) yourscore_txt.visible = pFlag;
			if (yourscore_val) yourscore_val.visible = pFlag;
		}
		
		public function simulateSendScoreButtonClick():void {
			this.dispatchEvent(new  CustomEvent({TARGETID:"reportScoreBtn"},BUTTON_PRESSED));
		}

		public function updateScore():void {
			var str:String = NPTextData.replaceToken(NPTextData.instance.GAMEOVER_YOURSCORE_VAL, "%0", PCGameEngine.instance.score.toString());
			NPTextData.pushCustomText(this, "yourscore_val", str);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/*private function destinationHandler(e:MouseEvent):void {
			PCGameEngine.openNCLink(15858);
			PCGameEngine.instance.playSound("MouseClick");
		}*/

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/*private function clickHandler(evt:MouseEvent){
			switch(evt.currentTarget){
				case rewardBtn: 
							PCGameEngine.openNCLink(14948); // added by Neopets
							break;
			}
		}*/
		
		private function overHandler(evt:MouseEvent){
			evt.currentTarget.gotoAndStop("OVER");
		}
		
		private function outHandler(evt:MouseEvent){
			evt.currentTarget.gotoAndStop("UP");
		}
		
		private function downHandler(evt:MouseEvent){
			evt.currentTarget.gotoAndStop("DOWN");
		}

		/**
		 * @Note: Setups Extended Variables
		 */ 
		private function setupExtendedVars():void {
			playAgainBtn.tabEnabled = false;
			reportScoreBtn.tabEnabled = false;
			if (visitWebsiteButton) {
				visitWebsiteButton.addEventListener(MouseEvent.MOUSE_UP, MouseClicked, false, 0, true);
				visitWebsiteButton.tabEnabled = false;
			}
			
			/*if (visitWebsiteButton2) {
				visitWebsiteButton2.setText(NPTextData.getTranslationOf("IDS_MENU_WEBSITE2"));
				
				visitWebsiteButton2.addEventListener(MouseEvent.MOUSE_UP, destinationHandler, false, 0, true);
				visitWebsiteButton2.tabEnabled = false;
			}*/
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}