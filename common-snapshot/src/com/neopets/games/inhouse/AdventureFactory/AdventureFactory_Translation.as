/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.AdventureFactory
{
	import virtualworlds.lang.TranslationData;
	
	
	/**
	 *	This is a List of All the Text that needs to be Translated by the System
	 *	You can see this File Online http://www.neopets.com/transcontent/flash/game_13000.txt
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Translation System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	dynamic public class AdventureFactory_Translation extends TranslationData 
	{
		
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		//EVENTS
		public var IDS_MSG_PlayAgain:String = "<p align='center'><font size='22'>Would You like to play again?</font></p>";
		public var IDS_MSG_YouWin:String = "<p align='center'><font size='22'>You Won!</font></p>";
		public var IDS_MSG_Result:String = "<p align='center'><font size='22'>The Results are:</font></p>";
		public var IDS_MSG_GAMEOVER:String = "<p align='center'><font size='22'>The Game is Over</font></p>";
		
		//OBJECTS
	
		//TITLES
		public  var IDS_TITLE_NAME:String = "<p align='center'><font size='36'>Vendor Game Example</font></p>";
		
		//BTN TEXT
		public var IDS_BTN_INSTRUCTION:String = "<p align='center'><font size='22'>HOW TO PLAY</font></p>";
		public var IDS_BTN_START:String = "<p align='center'><font size='22'>Start</font></p>";		
		public var IDS_BTN_BACK:String = "<p align='center'><font size='22'>Back</font></p>";
		public var IDS_BTN_SENDSCORE:String = "<p align='center'><font size='22'>Report Score</font></p>";
		public var IDS_BTN_PLAYAGAIN:String = "<p align='center'><font size='22'>Play Again</font></p>";
		public var IDS_BTN_QUIT:String = "<p align='center'><font size='22'>Quit</font></p>";
		
		// Extra Buttons
		public var IDS_BTN_NEXT:String = "<p align='center'><font size='22'>Next</font></p>";
		
		//MISC
		public var IDS_COPYRIGHT_TXT:String = "<p align='right'><font size='10'>Neopets, Inc., &#169; 1999-2009</font></p>";
		public var IDS_INSTRUCTION_TXT:String = "<p align='left'><font size='20'>Along the top of the screen, levers are inscribed with the numbers 1 through 9. Choose to roll either 1 or 2 dice and then push any combination of levers that add up to the sum of the dice.</font></p>";
		
		// Game State Tabs
		public var IDS_STATE_TAB_OPENNER:String = "<p align='left'><font size='10'>";
		public var IDS_GAME_STARTER_TAB:String = "GAME STARTER";
		public var IDS_BACKGROUND_TAB:String = "BACKGROUND";
		public var IDS_HERO_TAB:String = "HERO";
		public var IDS_GOAL_TAB:String = "GOAL";
		public var IDS_LEVEL_DESIGN_TAB:String = "LEVEL DESIGN";
		public var IDS_TEST_TAB:String = "TEST";
		public var IDS_SUBMIT_TAB:String = "SUBMIT LEVEL";
		
		// Starter Option Tabs
		public var IDS_STARTER_OPENNER:String = "<p align='left'><font size='15'>";
		public var IDS_FRESH_STARTER:String = "Start From Scratch";
		public var IDS_LOAD_STARTER:String = "Your Saved Level";
		
		// Tool Set Captions
		public var IDS_TOOL_TAB_OPENNER:String = "<p align='center'><font size='12'>";
		public var IDS_TERRAIN_TAB:String = "Walls & Floors";
		public var IDS_HAZARDS_TAB:String = "Hazards";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AdventureFactory_Translation():void{
			super();
		}
		
	}
	
}
