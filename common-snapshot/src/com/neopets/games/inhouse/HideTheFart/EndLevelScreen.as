package com.neopets.games.inhouse.HideTheFart 
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	//import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.button.NeopetsButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;

	dynamic public class EndLevelScreen extends AbsMenu
	{
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public var endGameBtn:NeopetsButton; // on stage
		public var nextLevelBtn:NeopetsButton;
		
		// -------------------------
		// Constructor
		// -------------------------
		public function EndLevelScreen()
		{
			super();
			setupVars();
		}
		
		// 
		private function setupVars():void
		 {
			trace("End Button: "+endGameBtn); //[object NavButton]
			// Get null Error #1009 here with either of the buttons:
			//endGameBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			//nextLevelBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "EndLevelScreen";
		 }
		
		
		
		
	}
}