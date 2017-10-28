/**
 *	Translation date only used for the time being
 *	
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  nov.2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class _level0
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		/*
		public static var IDS_playgame = "<p align='center'><font size='24'>xxxxPlay Game</font></p>";
		public static var IDS_help = "<p align='center'><font size='24'>xxxxTutorial</font></p>";
		public static var IDS_continue = "<p align='center'><font color='#555555' size='14'>xxxxClick here or press <font color='#990099'>Space</font> to continue</font></p>";
		public static var IDS_continue2 = "<p align='center'><font color='#990099' size='14'>xxxxClick here or press Space to continue</font></p>";
		public static var IDS_spacebar = "<p align='center'><font size='16'>xxxxUse the Spacebar to shoot a bubble</font></p>";
		//font size for instructiosn is 16!
		public static var IDS_instructiontext_1 = "<font size='16'><font color='#990099'>xxxxGoal of the game</font><br><br>Clear the screen by connecting 3 or more bubbles of the same type.<br><br>Once the screen is cleared you will proceed to the next level.<br><br>Beat all the levels to finish the game and get a special bonus.</font>";
		public static var IDS_instructiontext_1b = "<font size='16'><font color='#990099'>xxxxBut...</font><br><br>...don't waste too many shots - the top row will drop down row by row after a certain number of shots.<br><br>The less shots you use to clear a level, the higher your level bonus!</font>";
		public static var IDS_instructiontext_2 = "<font size='16'><font color='#990099'>xxxxAnd there is more:</font><br><br>Connect 4 or more bubbles to trigger a special Faerie Combo.<br><br>Not only can Faerie Combos be very useful, they also give you a nice bonus!<br><Br>More about the Faerie Bubbles<br>a little later!</font>";
		public static var IDS_instructiontext_3 = "<font size='16'><font color='#990099'>xxxxAiming the cannon</font><br><br>Let's practice your aiming skills:<br><br>Use the Left and Right cursor keys to aim the cannon.<br>Use the Up cursor key to bring the cannon back to the center position.<br><br>Go ahead and give it a try...</font>";
		public static var IDS_instructiontext_4 = "<font size='16'><font color='#990099'>xxxxShooting a bubble</font><br><br>Use the space bar to shoot a bubble out of the cannon.<br><br>Click on the button below or press Space and give it a shot...</font>";
		public static var IDS_instructiontext_5 = "<font size='16'><font color='#990099'>xxxx...pretty simple, eh?</font><br><br>Now let's talk about those mysterious bubbles.<br><br>There are 3 <font color='#006600'>good</font> and 3 <font color='#990000'>bad</font> types of bubbles in the game!<br><br>Let's talk about the good ones first...</font>";
		public static var IDS_instructiontext_6 = "<font size='16'><font color='#006600'>xxxxThe Fire Faerie Bubble<br><br>Connect 4 or more Fire bubbles and they will destroy all their neighbour bubbles!<br><br>Click on the button below or press Space, shoot a bubble and see for yourself...</font>";
		public static var IDS_instructiontext_7 = "<font size='16'><font color='#990099'>xxxxHeya...</font><br><br>Have you noticed that all bubbles except the Water bubbles were destroyed by the fire?<br><br>Water bubbles are resistant against fire!</font>";
		public static var IDS_instructiontext_8 = "<font size='16'><font color='#006600'>xxxxThe Water Faerie Bubble<br><br>4 or more connected Water bubbles are very powerful. They will destroy every other Water bubble on the screen.<br><br>Check it out...</font>";
		public static var IDS_instructiontext_9 = "<font size='16'><font color='#006600'>xxxxThe Light Faerie Bubble<br><br>A combo of 4 or more Light bubbles turns all the neighbour bubbles into the same random type of bubble.<br><br>Like this...</font>";
		public static var IDS_instructiontext_9b = "<font size='16'><font color='#990099'>xxxxSo good so far...</font><br><br>Are you ready for some bad news?<br><br>Let's see what those <font color='#990000'>bad</font> Faerie bubbles can do to your game...</font>";
		public static var IDS_instructiontext_10 = "<font size='16'><font color='#990000'>xxxxThe Earth Faerie Bubble<br><br>Connect 4 or more Earth bubbles and a new row of bubbles will appear on top of the screen. All other bubbles will drop down one row!<br><br>This is what it looks like...</font>";
		public static var IDS_instructiontext_11 = "<font size='16'><font color='#990000'>xxxxThe Air Faerie Bubble<br><br>Very mean! 4 or more connected Air bubbles will fill up their rows with other random bubbles.<br><br>Not very nice...</font>";
		public static var IDS_instructiontext_12 = "<font size='16'><font color='#990000'>xxxxThe Dark Faerie Bubble<br><br>Connect 4 or more Dark bubbles and they will turn into random types of other bubbles!<br><br>See for yourself...</font>";
		public static var IDS_instructiontext_13 = "<font size='16'>xxxxLast but not least there are two bubbles that are very rare:<br><br>The <font color='#990099'>Nova Bubble</font> which destroys all bubbles around it and the <font color='#990099'>Rainbow Bubble</font> which turns into the bubble that it first touches!</font>";
		public static var IDS_instructiontext_14 = "<font size='16'>xxxxClick on the button on the top left side of the play field to <font color='#990099'>pause the game</font>, <font color='#990099'>send your score</font> or to <font color='#990099'>turn the sound off</font>.<br><br>Now go ahead and have some fun with the bubbles.<br><br>By the way, you can <font color='#990099'>skip this tutorial by clicking the key 's' on your keyboard</font> :)</font>";
		public static var IDS_firecombo = "<p align='center'><font size='16'>xxxxFire Combo</font></p>";
		public static var IDS_watercombo = "<p align='center'><font size='16'>xxxxWater Combo</font></p>";
		public static var IDS_lightcombo = "<p align='center'><font size='16'>xxxxLight Combo</font></p>";
		public static var IDS_earthcombo = "<p align='center'><font size='16'>xxxxEarth Combo</font></p>";
		public static var IDS_aircombo = "<p align='center'><font size='16'>xxxxAir Combo</font></p>";
		public static var IDS_darkcombo = "<p align='center'><font size='16'>xxxxDark Combo</font></p>";
		public static var IDS_gamestart = "<p align='center'><font size='16'>xxxxGame has started</font></p>";
		public static var IDS_course = "<p align='center'><font size='20'>xxxxTutorial</font></p>";
		public static var IDS_level = "<p align='center'><font size='20'>xxxxLevel</font></p>";
		public static var IDS_gamefinished = "<p align='center'><font size='18'>xxxxGAME FINISHED</font></p>";
		public static var IDS_gameover = "<p align='center'><font size='18'>xxxxGAME OVER</font></p>";
		public static var IDS_gamepaused = "<p align='center'><font size='18'>xxxxGAME PAUSED</font></p>";
		public static var IDS_coursepaused = "<p align='center'><font size='18'>xxxxTUTORIAL PAUSED</font></p>";
		public static var IDS_sound_on = "<p align='center'><font size='18'>xxxxTurn sound on</font></p>";
		public static var IDS_sound_off = "<p align='center'><font size='18'>xxxxTurn sound off</font></p>";
		public static var IDS_sound = "<p align='center'><font size='18'>xxxxTurn sound off</font></p>";
		public static var IDS_restart = "<p align='center'><font size='18'>xxxxRestart Game</font></p>";
		public static var IDS_resumecourse = "<p align='center'><font size='18'>xxxxResume Tutorial</font></p>";
		public static var IDS_resume = "<p align='center'><font size='18'>xxxxResume Game</font></p>";
		public static var IDS_sendscore = "<p align='center'><font size='18'>xxxxSend Score</font></p>";
		//----------------
		public static var IDS_leveltext_01 = "<p align='right'><font size='16'>xxxxBubble Points</font></p>";
		public static var IDS_leveltext_03 = "<p align='right'><font size='16'>xxxxShots Total</font></p>";
		public static var IDS_leveltext_06 = "<p align='center'><font size='16'>xxxxTotal Points for this Level</font></p>";
		public static var IDS_leveltext_04 = "<p align='rght'><font size='16'>xxxxBonus</font></p>";
		public static var IDS_leveltext_05 = "<p align='right'><font size='16'>xxxxGame Bonus</font></p>";
		public static var IDS_levelhead_01 = "<p align='center'><font size='18'>xxxxLevel Completed</font></p>";
		public static var IDS_levelhead_02 = "<p align='center'><font size='18'>xxxxGame Finished</font></p>";
		public static var IDS_levelhead_03 = "<p align='center'><font size='18'>xxxxGame Over</font></p>";
		//--------
		
		//------unused?
		public static var IDS_leveltext_02 = "xxxxFaerie Combo Points";
		public static var IDS_helptext = "xxxxFAERIE BUBBLE HELP\n\njust play the game...";
		public static var IDS_back = "xxxxBack";

		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function _level0():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		*/
	}
	
}