
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.text.TextFunctions;
	
	import com.neopets.util.sound.SoundObj;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This class handles individual world game levels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.17.2010
	 */
	 
	public class EndOfLevelPrompt extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const PROMPT_CLEARED:String = "EndOfLevelPrompt_cleared";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _displayTimer:Timer;
		// components
		protected var _levelField:TextField;
		protected var _mainField:TextField;
		protected var _continueField:TextField;		
		
		protected var clearSound = new YouWinSound();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function EndOfLevelPrompt():void {
			super();
			hide(); // hide prompt by default
			// check for components
			levelField = getChildByName("level_txt") as TextField;
			_mainField = getChildByName("main_txt") as TextField;
			continueField = getChildByName("continue_txt") as TextField;
			// set up display timer
			_displayTimer = new Timer(1000,1);
			_displayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerDone);
			// set up links to game screen
			useParentDispatcher(SuperSearch_GameScreen);
			// set up listeners
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.LEVEL_CLEARED,onLevelCleared);
			addParentListener(SuperSearch_GameScreen,SuperSearch_GameScreen.GAME_OVER,onGameEnded);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get continueField():TextField { return _continueField; }
		
		public function set continueField(txt:TextField) {
			_continueField = txt;
			TextFunctions.setTranslatedText(_continueField,"IDS_FGS_PRESS_ANY_KEY");
		}
		
		public function get gameScreen():SuperSearch_GameScreen {
			if(defaultDispatcher != null && defaultDispatcher is SuperSearch_GameScreen) {
				return defaultDispatcher as SuperSearch_GameScreen;
			}
			return DisplayUtils.getAncestorInstance(this,SuperSearch_GameScreen) as SuperSearch_GameScreen;
		}
		
		public function get levelField():TextField { return _levelField; }
		
		public function set levelField(txt:TextField) {
			_levelField = txt;
			TextFunctions.setTranslatedText(_levelField,"IDS_LEVEL_CLEAR");
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Visibility Functions
		
		public function hide():void {
			visible = false;
		}
		
		public function show():void {
			visible = true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When this function is triggered, close the prompt.
		
		protected function onKeyPress(ev:Event) {
			hide(); // hide the prompt
			// clear the listener
			if(stage != null) {
				stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyPress);
			}
			// let our listeners know
			broadcast(PROMPT_CLEARED);
		}
		
		public function onGameEnded(ev:Event) {
			hide(); // hide the prompt
			// clear the listener
			if(stage != null) {
				stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyPress);
			}
			// let our listeners know
			broadcast(PROMPT_CLEARED);
		}
		
		
		// When the level is cleared, show this prompt.
		
		protected function onLevelCleared(ev:Event) {
			// update and display the end of level scoring
			updateScoring();
			// hide "press any key" text
			if(_continueField != null) _continueField.visible = false;
			// show the prompt
			show();
			// wait a little while before letting the player clear the prompt
			_displayTimer.reset();
			_displayTimer.start();
			clearSound.playSound();
		}
		
		// When the timer finishes, turn on key press checking.
		
		protected function onTimerDone(ev:Event) {
			// reveal "press any key" text
			if(_continueField != null) _continueField.visible = true;
			// Wait for a key press to clear the prompt.
			if(stage != null) {
				stage.addEventListener(KeyboardEvent.KEY_UP,onKeyPress);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to perform end of level scoring.
		
		protected function updateScoring():void {
			// check if we have a field to load the text into
			if(_mainField == null) return;
			// get our game screen
			var screen:SuperSearch_GameScreen = gameScreen;
			if(screen == null) return;
			// store the current score value
			var score_manager:ScoreManager = ScoreManager.instance;
			var final_score:Number = score_manager.getValue();
			// check for a "perfect game" bonus
			var perfect_bonus:int = screen.perfectBonus;
			if(perfect_bonus > 0) {
				// get the base score value
				var base_score:Number = final_score - perfect_bonus;
				// set up base score text
				var translator:TranslationManager = TranslationManager.instance;
				var base_score_str:String = translator.getTranslationOf("IDS_YOUR_SCORE_TXT");
				base_score_str = base_score_str.replace("%1",base_score);
				// set up bonus text
				var bonus_str:String = translator.getTranslationOf("IDS_BONUS_TXT");
				bonus_str = bonus_str.replace("%1",perfect_bonus);
				// set up bonus text
				var final_score_str:String = translator.getTranslationOf("IDS_TOTAL_SCORE_TXT");
				final_score_str = final_score_str.replace("%1",final_score);
				// combine text
				var report_str:String = base_score_str + "<br/>" + bonus_str + "<br/>" + final_score_str;
				translator.setTextField(_mainField,report_str);
			} else {
				// show basic score
				TextFunctions.setTranslatedText(_mainField,"IDS_YOUR_SCORE_TXT",[["%1",final_score]]);
			}
		}
		 
	}
	
}
