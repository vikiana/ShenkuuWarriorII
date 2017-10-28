/**
 *	Class that contains tutorial info, each step is contained in object form in "courseStep" class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since Nov. 2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;

	
	
	public class Course
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		
		private var popupMC:MovieClip;
		private var curStep:Number;
		private var aSteps:Array;
		private var maxSteps:Number;
		private var popupSaveX:Number;
		private var popupSaveY:Number;
		protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------

		// -------------------------------------------------- //	
		// this class holds information for each step of the
		// instruction course
		// -------------------------------------------------- //	
		
		public function Course():void
		{
			// popup window movie clip
			popupMC = undefined;
			
			// current course step
			curStep = 0;
			
			// the course steps array holding the step objects
			aSteps = [];
			
			
			//mTranslationData.IDS_gamestart
			// step  1 : goal of the game I
			
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_1, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			//trace ("came here")
			// step  1b : the top row
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_1b, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step  2 : more game play
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_2, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step  3 : aiming
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_3, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step  4 : shooting explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_4, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step  5 : shooting test
			aSteps.push( new CourseStep( false, "no popup - no text!", [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_2;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_BALLSTOPPED;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step  6 : different bubble types blahblah
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_5, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step  7 : Fire Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_6, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step  8 : Fire Bubble Test
			aSteps.push( new CourseStep( false, "no popup - no text!", [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_NEXTLEVEL;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_CHECKEMPTYLEVEL;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step 9 : after Fire bubble - explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_7, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 10 : Water Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_8, [1,1,1] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 11 : Water Bubble Test
			aSteps.push( new CourseStep( false, "no popup - no text!", [2,2,2] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_NEXTLEVEL;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_CHECKEMPTYLEVEL;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step 12 : Light Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_9, [3,3,3] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 13 : Light Bubble Test
			aSteps.push( new CourseStep( false, "no popup - no text!", [3,3,3] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_NEXTLEVEL;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_CHECKEMPTYLEVEL;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step 13b : Light Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_9b, [4,4,4] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 14 : Earth Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_10, [4,4,4] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 15 : Earth Bubble Test
			aSteps.push( new CourseStep( false, "no popup - no text!", [4,4,4] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_NEXTLEVEL;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_CHECKEMPTYLEVEL;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step 16 : Air Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_11, [5,5,5] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 17 : Air Bubble Test
			aSteps.push( new CourseStep( false, "no popup - no text!", [5,5,5] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_NEXTLEVEL;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_CHECKEMPTYLEVEL;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step 18 : Dark Faerie Bubble explanation
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_12, [6,6,6] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 19 : Dark Bubble Test
			aSteps.push( new CourseStep( false, "no popup - no text!", [6,6,6] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_NEXTLEVEL;
			aSteps[ aSteps.length-1 ].trigger_next_step = GameStates.ST_CHECKEMPTYLEVEL;
			aSteps[ aSteps.length-1 ].helptext = mTranslationData.IDS_spacebar;
			//_root.progressButtonThing.setHtmlText(mTranslationData.IDS_spacebar);
			// step 20 : Last explanations
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_13, [12,11] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			// step 21 : end course screen
			aSteps.push( new CourseStep( true, mTranslationData.IDS_instructiontext_14, [12,11] ) );
			aSteps[ aSteps.length-1 ].game_state = GameStates.ST_COURSE_1;
			
			// course steps
			maxSteps = aSteps.length;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function initPopup(pClip:MovieClip):void
		{
			popupMC = pClip;
		}
		
		public function removePopup(pClip):void
		{
			trace ("remove course popup")
			if (popupMC != null ) 
			{
				//fromwhere???removeChild(popupMC);
				popupMC = null;
			}
			//trace("remove course popup mc: "+this.popupMC);
		}
		
		public function showPopup(px:Number ,  py:Number):void
		{
			popupMC.x = px;
			popupMC.y = py;
		}
		
		public function hidePopup():void
		{
			popupMC.x = 1000;
			popupMC.y = 1000;
		}
		
		public function savePopupPos():void
		{
			popupSaveX = popupMC.x;
			popupSaveY = popupMC.y;
		}
		
		public function restorePopupPos():void
		{
			popupMC.x = popupSaveX;
			popupMC.y = popupSaveY;
		}
		
		public function getNextStep():CourseStep
		{
			var obj:CourseStep;
		
			if ( curStep < maxSteps )
				obj = aSteps[ curStep ];
				
			curStep++;
			return ( obj );
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}

