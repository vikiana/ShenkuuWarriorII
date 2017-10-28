/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
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
	 
	 public class AboutScreen extends AbsMenu {
		
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
		public var returnBtn:NeopetsButton;
		public var about_title_txt:TextField;
		
		public var aboutmc:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AboutScreen():void {
			super();
			setupVars();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function inFocus():void {
			trace("@ About menu");
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
		 * @Note: Setups Variables
		 */
		 
		 private function setupVars():void
		 {
		 	returnBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			returnBtn.tabEnabled = false;
			mID = "AboutScreen";
			
			NPTextData.pushCustomText(this, "about_title_txt", NPTextData.getTranslationOf("IDS_ABOUT_TITLE_TXT"));
			
			_scroller = new MCScroller(this, aboutmc, 75, 140, 480, 360);
		 }
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}