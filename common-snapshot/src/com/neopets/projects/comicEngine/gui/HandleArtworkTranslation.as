
/* AS3
	Copyright 2008
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
	 *	@since  9.04.2009
	 */
	 
	public class HandleArtworkTranslation extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const TRANSLATE_ARTWORK:String = "TranslateThisArtwork";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mSingletonED:MultitonEventDispatcher;
		protected var mKey:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function HandleArtworkTranslation():void
		{
			this.root.addEventListener(StoryBookPage.SENDKEY_EVENT, setupEventDispatcher, false, 0, true);
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
		 * 	@Param		evt.oData.key					 	String					The Key for the Shared Listener	
		 * */
		 
		 protected function setupEventDispatcher (evt:CustomEvent):void
		 {
		 	mKey = evt.oData.key;	
		 	mSingletonED = MultitonEventDispatcher.getInstance(mKey);
			mSingletonED.addEventListener(HandleArtworkTranslation.TRANSLATE_ARTWORK, changeArtworkEvent, false, 0 , true);
		 }
		 
		 
			/**
		 * @Note: This listens for a translation Request
		 *	@Param		evt.oData.lang					String					The Language to be Translated to
		 *  @Param		evt.oData.id						String					The Language ID for TranslationManager
		 * 	@Param		evt.oData.TransData			TranslationData		Translation Data for the Pannel
		 * 	@Param		evt.oData.transFrontID		String					The Front End of the String for Translation	
		 * 	@Param		evt.oData.useTranslation 	Boolean					The Front End of the String for Translation
		 * 	@Param		evt.oData.key					 	String					The Key for the Shared Listener	
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
