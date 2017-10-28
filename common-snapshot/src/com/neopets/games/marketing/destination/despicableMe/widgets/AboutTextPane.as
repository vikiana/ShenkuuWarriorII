/**
 *	This class shows the client's about text.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	public class AboutTextPane extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var _mainField:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AboutTextPane():void {
			super();
			mainField = getChildByName("main_txt") as TextField;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get mainField():TextField { return _mainField; }
		
		public function set mainField(txt:TextField) {
			_mainField = txt;
			setTranslation(_mainField,"IDS_ABOUT_CLIENT");
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function setTranslation(txt:TextField,id:String) {
			if(txt != null) {
				// load translated text
				var translator:TranslationManager = TranslationManager.instance;
				if(translator.translationData != null) {
					txt.htmlText = translator.getTranslationOf(id);
				} else txt.text = id;
			}
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