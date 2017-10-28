/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.HideTheFart
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
	 
	dynamic public class TranslationGameEngine extends TranslationData 
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
		public  var IDS_TITLE_NAME:String = "<p align='center'><font size='22'>Blind Date Horror</font></p>";
		
		//BTN TEXT
		public var IDS_BTN_INSTRUCTION:String = "<p align='center'><font size='22'>Instructions</font></p>";
		public var IDS_BTN_START:String = "<p align='center'><font size='22'>Start</font></p>";		
		public var IDS_BTN_BACK:String = "<p align='center'><font size='22'>Back</font></p>";
		public var IDS_BTN_SENDSCORE:String = "<p align='center'><font size='22'>Report Score</font></p>";
		public var IDS_BTN_PLAYAGAIN:String = "<p align='center'><font size='22'>Play Again</font></p>";
		public var IDS_BTN_QUIT:String = "<p align='center'><font size='22'>Quit</font></p>";
		
		//MISC
		public var  IDS_COPYRIGHT_TXT:String = "<p align='center'><font size='10'>Neopets, Inc., &#169; 1999-2010</font></p>";
		public var IDS_INSTRUCTION_TXT:String = "<p align='left'><font size='20'>Answer the trivia questions and then move on to the bonus round.\n\nIn the bonus round, use the right arrow key to fart and the left arrow key to reset your fart. You have 10 seconds to fart as many times as you can while the chariot is on the stage. If you fart when the chariot is off the stage, it's game over!</font></p>";

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TranslationGameEngine():void{
			super();
		}
		
	}
	
}
