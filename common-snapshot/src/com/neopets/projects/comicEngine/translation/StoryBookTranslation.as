
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.translation
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
	 *	@since  9.08.2009
	 */
	 
	dynamic public class StoryBookTranslation extends TranslationData 
	{
		
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		//MISC
		public var TRANSLATION_TITLE:String = "<p align='center'><font size='22'>Comic Pages: Neopets 10th Anniversary</font></p>";
		public var IDS_PREVIOUS_PAGE:String = "<p align='center'><font size='22'>Back</font></p>";
		public var IDS_NEXT_PAGE:String = "<p align='center'><font size='22'>Next</font></p>";
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function StoryBookTranslation():void{
			super();
		}
		
	}
	
}
