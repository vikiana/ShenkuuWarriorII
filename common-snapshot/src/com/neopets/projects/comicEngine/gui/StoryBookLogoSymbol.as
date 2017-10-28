
/* AS3
	Copyright 2008
*/

package com.neopets.projects.comicEngine.gui
{
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 *	This is for the StoryBook Logo
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryBook Engine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.28.2009
	 */
	 
	public class StoryBookLogoSymbol extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const UPDATE_LOADING_SCREEN:String = "UpdateTheLoadingScreen";
		public static const UPDATE_LOGO_LANG:String = "LogoEventUpdate";
		public static const KEY:String = "StoryBookLogo";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var txt_Fld:TextField; 			//On Stage
		protected var mSingletonED:MultitonEventDispatcher;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookLogoSymbol():void
		{
			super();
			mSingletonED = MultitonEventDispatcher.getInstance(StoryBookLogoSymbol.KEY);
			addEventListener(UPDATE_LOADING_SCREEN, updateLoadingScreen,false,0,true);
			addEventListener(StoryBookLogoSymbol.UPDATE_LOGO_LANG, updateNavigation, false, 0, true);
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
			/**
		 * @Note this is for the StoryEngine to Update the TextFields and such
		 * @param			evt.oData.lang				String			The Language Code for this NavBar
		 */
		 
		public function updateNavigation (evt:CustomEvent):void
		{
			var tLang:String = "en";
			
			if (evt.oData.hasOwnProperty("lang"))
			{
				tLang = String(evt.oData.lang).toUpperCase();
			}
			else
			{
				tLang = tLang.toUpperCase();	
			}
			
			mSingletonED.dispatchEvent(new CustomEvent({lang:tLang}, StoryBookAbsArtwork.TRANSLATE_ARTWORK));
			
		}
		
		/**
		 * @Note: This is an example
		 * @param		evt.oData.chapter					int 			The Number of current Chapter
		 * @param		evt.oData.numChapters					int				The Number of Chapters
		 */
		 
		 private function updateLoadingScreen(evt:CustomEvent):void
		 {
		 	var tTxt:String = 	String(evt.oData.chapter) + " /  " + String(evt.oData.numChapters) ;
			txt_Fld.htmlText = tTxt;
			
		}
		
	}
	
}
