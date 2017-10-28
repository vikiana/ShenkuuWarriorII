/* AS3
	Copyright 2009
*/

package com.neopets.vendor.animax.slarg.translation
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
	 *	@since  8.12.2009
	 */
	 
	dynamic public class TranslationInfo extends TranslationData 
	{
		
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		public var IDS_btnEnd:String = "<p align='center'>END<BR>GAME</p>";
		
		/* Intro Screen */
		public var IDS_txtTitleMC:String = "<p align='center'>EPIC<BR>SLORG<BR>BATTLE</p>";
		public var IDS_btnStart_play_GameIntro:String = "<p align='center'><FONT size='16'>START GAME</FONT></p>";
		public var IDS_btnInstructions_play_Instructions:String = "<p align='center'><font size='15'>INSTRUCTIONS</font></p>";
		
		/* Instructions Screen */
		public  var IDS_txtInstructionsTitle:String = "<p align='center'><font size='36'>Instructions</font></p>";
		public var IDS_btnMainMenu_play_Intro:String = "<p align='center'><font size='22'>MAIN MENU</font></p>";
		public var IDS_txtInstructions:String = "<p align='center'><font size='14'>Use your mouse to aim the crosshairs and line up your shot, and then click to shoot the Slorg!  Make groups of three or more Slorgs of the same colour to disintegrate them.  You'll also receive bonus points for taking out multiple groups of Slorgs in a row.\n\nThere are also power-ups to help you along the way.  The rainbow power-up can turn into any colour of Slorg you shoot it at.  The slow-down power-up must be shot to be earned, but it will slow down the Slorg horde a bit.  Clear the screen of Slorgs to move on to the next level!</font></p>";		
		
		/* Game Screen (with next button) */
		
		
		public var IDS_txtLevelLabel:String = "<p align='center'><font size='40'>STAND BY FOR</font></p>";		
		public var IDS_txtLevelTitle:String = "<p align='center'><font size='70'>Level %1</font></p>";
		public var IDS_btnGame_next:String = "<p align='center'><font size='25'>NEXT</font></p>";		
		
		/* Game Screen (playing) */
		
		
		/* Game Over Screen */
		public var IDS_textGameOverMC:String = "<p align='center'><font size='96'>GAME OVER</font></p>";
		public var IDS_textFinalScoreMC:String = "<p align='center'><font size='36'>FINAL SCORE</font></p>";
		public var IDS_btnRestart_play_Intro:String = "<p align='center'><font size='18'>RESTART<BR>GAME</font></p>";
		//custom btn
		public var IDS_btnSendScore_play_Intro:String = "<p align='center'><font size='18'>SEND<BR>SCORE</font></p>";
		
		//MISC
		//public var  IDS_COPYRIGHT_TXT:String = "<p align='right'><font size='10'>Neopets, Inc., &#169; 1999-2009</font></p>";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TranslationInfo():void{
			super();
		}
		
	}
	
}
