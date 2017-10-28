
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import com.neopets.games.inhouse.SuperSearch.SuperSearch_GameScreen;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchWorld;
	import com.neopets.games.inhouse.SuperSearch.classes.SuperSearchLevel;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcasterClip;
	import com.neopets.games.inhouse.SuperSearch.classes.util.BroadcastEvent;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This class handles individual world game levels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  3.10.2010
	 */
	 
	public class LevelReadyPrompt extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const PROMPT_DONE:String = "LevelReadyPrompt_done";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _mainField:TextField;
		protected var _readyField:TextField;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function LevelReadyPrompt():void {
			super();
			// check for default components
			_mainField = getChildByName("main_txt") as TextField;
			_readyField = getChildByName("ready_txt") as TextField;
			// hide this prompt by default
			visible = false;
			// wait on first frame
			gotoAndStop(1);
			// set up links to game screen
			useParentDispatcher(SuperSearch_GameScreen);
			// set up listeners
			addParentListener(SuperSearch_GameScreen,SuperSearchWorld.LEVEL_READY,onLevelReady);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Call this function when the prompt's animation ends.
		
		public function endPrompt():void {
			// stop animation
			stop();
			// hide prompt
			visible = false;
			// let listeners know the prompt finished
			broadcast(PROMPT_DONE);
		}
		
		// Use this function to set our "ready, set, go" text from translation.
		
		public function setTranslatedText(txt:TextField,id:String) {
			if(txt == null) return;
			// extract translated text;
			var translator:TranslationManager = TranslationManager.instance;
			var translation:String = translator.getTranslationOf(id);
			// apply translated text
			translator.setTextField(txt,translation);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the level is ready, show the new text.
		
		protected function onLevelReady(ev:BroadcastEvent) {
			// set our main text based on the level
			if(_mainField != null) {
				var level:SuperSearchLevel = ev.oData as SuperSearchLevel;
				var id_str:String = level.promptID;
				setTranslatedText(_mainField,id_str);
			}
			// start prompt animation from first frame
			gotoAndPlay(1);
			// show the prompt
			visible = true;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
