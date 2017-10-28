/* AS3
	Copyright 2008
*/
package com.neopets.games.marketing.destination.despicableMe.widgets
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This movie sub-class simply adds translation support.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Translation System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	dynamic public class TranslationShell extends MovieClip 
	{
		
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TranslationShell():void{
			super();
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
		
	}
	
}
