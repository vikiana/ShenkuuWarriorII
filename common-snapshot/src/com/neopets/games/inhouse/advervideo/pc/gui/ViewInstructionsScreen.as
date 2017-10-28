/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.neopets.games.inhouse.advervideo.pc.tools.MCScroller;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;
	

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
	 
	 public class ViewInstructionsScreen extends InstructionScreen {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _scroller:MCScroller;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		// on stage
		public var instructions_title_txt:TextField;
		
		public var instructionsmc:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ViewInstructionsScreen():void {
			super();
			setupExtendedVars();
			
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function inFocus():void {
			trace("@ View instructions menu");
		}
		
		public function outFocus():void {
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Setups Extended Variables
		 */ 
		private function setupExtendedVars():void {
			returnBtn.tabEnabled = false;
			NPTextData.pushCustomText(this, "instructions_title_txt", NPTextData.getTranslationOf("IDS_INSTRUCTIONS_TITLE_TXT"));
			NPTextData.pushCustomText(instructionsmc, "content_txt", NPTextData.getTranslationOf("IDS_INSTRUCTIONS_CONTENT_TXT"));
			
			_scroller = new MCScroller(this, instructionsmc, 90, 125, 540, 330);
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}