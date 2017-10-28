
/* AS3
	Copyright 2008
*/
package com.neopets.util.text
{
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This contains useful functions and Methods
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.18.2010
	 */
	 
	public class TextFunctions
	{
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TextFunctions():void{}
	
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to combine the TranslationManager's getTranslationOf call with a setTextField call.
		// param	txt				TextField		Textfield where the translated text is being loaded.
		// param	id				String			Property name of the translation string.
		// param	replacements	Array			This optional parameter can be used to pass in replacement pairs.
		//											These pairs are used in replacement calls.
		
		public static function setTranslatedText(txt:TextField,id:String,replacements:Array=null) {
			if(txt == null) return;
			// extract translated text
			var translator:TranslationManager = TranslationManager.instance;
			var translation:String = translator.getTranslationOf(id);
			// perform replacement calls
			if(replacements != null) {
				// cycle through all replacement pairs
				var params:Array;
				for(var i:int = 0; i < replacements.length; i++) {
					params = replacements[i] as Array;
					// check for a valid pair
					if(params != null && params.length >= 2) {
						translation = translation.replace(params[0],params[1]);
					}
				} // end of pair checking loop
			}
			// apply translated text
			translator.setTextField(txt,translation);
		}
		
	}
	
}
