//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.gamedata
{
	import virtualworlds.lang.TranslationData;
	
	
	/**
	 * public class SW2_TranslationData extends TranslationData
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public dynamic class SW2_TranslationData extends TranslationData
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public  var TRANSLATION_TITLE:String = "";
		//TITLES
		public  var IDS_TITLE_NAME:String = "<p align='center'><font size='36'>Shenkuu Warrior 2</font></p>";
		
		//public var IDS_SLOW_DOWN_MESSAGE:String = "<p align='center'><font size='33'>SLOW DOWN!</font></p>";
		
		//BTN TEXT
		public var IDS_BTN_INSTRUCTION:String = "<p align='center'><font size='22'>HOW TO PLAY</font></p>";
		public var IDS_BTN_START:String = "<p align='center'><font size='22'>Start</font></p>";		
		public var IDS_BTN_BACK:String = "<p align='center'><font size='22'>Back</font></p>";
		public var IDS_BTN_SENDSCORE:String = "<p align='center'><font size='22'>Send Score</font></p>";
		public var IDS_BTN_PLAYAGAIN:String = "<p align='center'><font size='22'>Play Again</font></p>";
		public var IDS_BTN_TRYAGAIN:String = "<p align='center'><font size='22'>Try Again</font></p>";
		public var IDS_BTN_NEXTLEVEL:String = "<p align='center'><font size='22'>Next Level</font></p>";
		public var IDS_BTN_QUIT:String = "<p align='center'><font size='14'>Quit</font></p>";
		
		// Extra Buttons
		public var IDS_BTN_MODE1:String = "<p align='center'><font size='22'>TRAINING</font></p>";
		public var IDS_BTN_MODE2:String = "<p align='center'><font size='22'>ZEN MASTER</font></p>";
		public var IDS_BTN_NEXT:String = "<p align='center'><font size='22'>Next</font></p>";
		
		//choose screen
		public var IDS_CHOOSEMODE_TITLE:String=  "<p align='center'><font size='32'>CHOOSE MODE</font></p>";
		public var IDS_TMODE_COPY:String=  "<p align='left'><font size='14'>Are you ready to begin your training? Your first challenge is the forest. Good luck!</font></p>";
		public var IDS_ZENMODE_COPY:String=  "<p align='left'><font size='14'>Are the skies the limit to your skills? Or have you learned enough to climb through the clouds themselves? Find out in the Zen Master level!</font></p>";
	
		
		///instructions screen
		public var IDS_INSTRUCTIONS_TITLE:String=  "<p align='center'><font size='32'>HOW TO PLAY</font></p>";
		public var IDS_INSTRUCTIONS_COPY:String=  "<p align='left'><font size='14'>Use your mouse to aim your grappling hook at a platform, then click the mouse button to shoot your hook. As soon as you've hit the platform, start aiming for the next one! <BR><BR>You can train the princess in Training Mode, in which she'll hone her warrior skills in the forest and on the mountain. Or she can put those skills to the test in Zen Master Mode, where she'll use her grappling hook to soar from cloud to cloud in the skies above Shenkuu!</font></p>";
		public var IDS_INSTRUCTIONS_COPY3:String= "<p align='left'><font size='11'>Keep an eye out for family crest bonuses (single or clustered in formations) and powerups. You can collect the powerups by hovering over them with your mouse as you guide the princess upward, or the princess can pick them up as she passes them. Be careful not to use your grappling hook too often, because your score is based on speed as well as accuracy.</font></p>";
		public var IDS_INSTRUCTIONS_COPY1:String=  "<p align='left'><font size='14'>POWERUPS:</font></p><p align='left'><font size='12'>Kite: lifts the princess up for a short amount of time without using the grappling hook.  You'll collect the powerup when you grip on its ledge with your hook.<br>Petpet: gives the princess a super-lift and lets her automatically collect all the crests she passes.<br>Balloon: In the Sky level, allows the princess to create an inflatable ledge by pressing the spacebar. Each balloon awards 5 ledges.</font></p>";
		public var IDS_INSTRUCTIONS_COPY2:String=  "<p align='left'><font size='14'>FAMILY CRESTS:</font></p><p align='left'><font size='12'>The crests will boost your score, and if you collect all of the crests in a cluster, you'll double your points. </font></p>";
		
		
		//extra screen
		public var IDS_BTN_CHOOSEMODE:String = "<p align='center'><font size='22'>Choose Level</font></p>";
		public var IDS_BTN_FIRSTLEVEL:String = "<p align='center'><font size='22'>FOREST</font></p>";
		public var IDS_BTN_SECONDLEVEL:String = "<p align='center'><font size='22'>HIGH MOUNTAIN</font></p>";
		public var IDS_BTN_THIRDLEVEL:String = "<p align='center'><font size='22'>ICED MOUNTAIN</font></p>";
		public var IDS_BTN_FOURTHLEVEL:String = "<p align='center'><font size='22'>SKY</font></p>";

		
		//SCOREBOARD
		public var ALTITUDE_TITLE:String = "<p align='center'><font size='12'>ALTITUDE</font></p>";
		public var TIME_TITLE:String = "<p align='center'><font size='12'>TIME</font></p>";
		public var POINTS_TITLE:String = "<p align='center'><font size='12'>POINTS</font></p>";
		
		//SCORE POPUP
		public var IDS_SCORE_TITLE:String = "<p align='center'><font size='30'>RESULTS</font></p>";

		public var IDS_SCORE_ALTITUDE:String = "<p align='center'><font size='22'>ALTITUDE:</font></p>";
		public var IDS_SCORE_TIME:String = "<p align='center'><font size='22'>TIME:</font></p>";
		public var IDS_SCORE_POINTS:String = "<p align='center'><font size='22'>POINTS:</font></p>";
		public var IDS_SCORE_ACCURACY:String = "<p align='center'><font size='24'>ACCURACY:</font></p>";
		public var IDS_SCORE_LSCORE:String = "<p align='center'><font size='22'>LEVEL SCORE:</font></p>";
		public var IDS_SCORE_SCORE:String = "<p align='center'><font size='24'>TOTAL SCORE:</font></p>";

		//it'll be 'meters' for all other countries :P
		public var IDS_UNIT:String = "feet";
		
		
		//FAIL LEVEL POPUP
		public var IDS_POPUP_FAIL_COPY:String = "<p align='center'><font size='20'>Sorry, but the princess has failed to complete her training.</font></p>";
		public var IDS_POPUP_FAIL_SKY_COPY:String = "<p align='center'><font size='18'>You reached $altitude. A true warrior never gives up, so why not try again? You'll be flying in no time!</font></p>";
		//END LEVEL POPUP
		public var IDS_ENDLEVEL_TITLE:String = "<p align='center'><font size='30'>CONGRATULATIONS!</font></p>";
		public var IDS_ENDLEVEL_COPY1:String = "<p align='center'><font size='20'>You've found your way through the forest. Time to conquer the mountain!</font></p>";
		public var IDS_ENDLEVEL_COPY2:String = "<p align='center'><font size='20'>You've scrambled up the high mountain. Let your will carry you to the icy mountain top!</font></p>";
		public var IDS_ENDLEVEL_COPY3:String = "<p align='center'><font size='20'>Congratulations, your warrior training is complete! Now let your spirit soar through the skies of Shenkuu!</font></p>";
		//QUIT LEVEL POPUP
		public var IDS_POPUP_QUIT_COPY:String = "<p align='center'><font size='14'>Sorry to see you go.<br>Come back soon for more warrior's training!</font></p>";

		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class SW2_TranslationData extends TranslationData instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function SW2_TranslationData()
		{
			super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}