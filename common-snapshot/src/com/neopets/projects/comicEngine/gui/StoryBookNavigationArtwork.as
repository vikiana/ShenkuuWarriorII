
/* AS3
	Copyright 2009
*/

package com.neopets.projects.comicEngine.gui
{
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 *	This is for the MultiFrame Artwork with a Keyframe for each language Used
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.27.2009
	 */
	 
	public class StoryBookNavigationArtwork extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const TRANSLATE_ARTWORK:String = "TranslateThisArtwork";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mSingletonED:MultitonEventDispatcher;

		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookNavigationArtwork():void
		{
			mSingletonED = MultitonEventDispatcher.getInstance(StoryBookNavigation.KEY);
			mSingletonED.addEventListener(StoryBookNavigationArtwork.TRANSLATE_ARTWORK, changeArtworkEvent, false, 0 , true);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

			/**
		 * @Note: This listens for a translation Request
		 *	@Param		evt.oData.lang					String					The Language to be Translated to
		 * */
		 
		
		protected function changeArtworkEvent(evt:CustomEvent):void
		{
			var tCount:int = this.numChildren;
		
			var tLang:String = String(evt.oData.lang).toUpperCase();
			
			var tLabelArray:Array = this.currentLabels;
					
			var tCount2:int = tLabelArray.length;
			
			for (var t:int = 0; t < tCount2; t++)
			{
				if (FrameLabel(tLabelArray[t]).name == tLang)
				{
					gotoAndStop(tLang);
					break;
				}
			}
			
			//mSingletonED.removeEventListener(TRANSLATE_ARTWORK, changeArtworkEvent);
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
