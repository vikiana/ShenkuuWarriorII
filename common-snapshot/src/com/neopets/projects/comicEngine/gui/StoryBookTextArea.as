
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.gui
{
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.events.SingletonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This will Translate the TextField for a User for the StoryEngine
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  8.25.2009
	 */
	 
	public class StoryBookTextArea extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const TRANSLATE_ARTWORK:String = "TranslateThisArtwork";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mTranslationManager:TranslationManager;
		protected var mSingletonED:MultitonEventDispatcher;
		protected var mKey:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookTextArea():void
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
			mSingletonED.addEventListener(StoryBookPage.TOGGLE_POPUP_VISIBILITY_EVENT, toggleVisibility, false,0, true);
		 }
		
		
		/**
		 * @Note: This listens for a translation Request
		 *  @Param		evt.oData.id					String					The Language ID for TranslationManager
		**/
		
		protected function toggleVisibility(evt:CustomEvent):void
		{
			var tEndID:String;
			
			if (this.name.charAt(this.name.length-2) == "_")
			{
				tEndID = this.name.charAt(this.name.length-1)
			}
			else
			{
				tEndID = this.name.charAt(this.name.length-2) + this.name.charAt(this.name.length-1);
			}
			
			
			
			if (tEndID == String(evt.oData.id))
			{
				this.visible = true;
			}
			else
			{
				this.visible = false;	
			}
		}
				
		/**
		 * @Note: This listens for a translation Request
		 *	@Param		evt.oData.lang					String					The Language to be Translated to
		 *  @Param		evt.oData.id						String					The Language ID for TranslationManager
		 * 	@Param		evt.oData.TransData			TranslationData		Translation Data for the Pannel
		 * 	@Param		evt.oData.transFrontID		String					The Front End of the String for Translation	
		 * 	@Param		evt.oData.useTranslation 	Boolean					The Front End of the String for Translation	
		 * */
		
		protected function changeArtworkEvent(evt:CustomEvent):void
		{
			if (Boolean(evt.oData.useTranslation ))
			{
					var tCount:int = this.numChildren;
					mTranslationManager = TranslationManager.instance;

					for (var t:int = 0; t < tCount; t++)
					{
						if (getChildAt(t) is TextField)
						{
							var tID:String = evt.oData.transFrontID + this.name + "_" + TextField(getChildAt(t)).name;
							
							//Error Checking
							var tTransStr:String = "";
							var tTransData:TranslationData = TranslationData(evt.oData.transData);
							
							if (tTransData.hasOwnProperty(tID))
							{
								tTransStr	= tTransData[tID];
								
							}
							else
							{
								tTransStr = "Error in Translation System";	
							}
							
							mTranslationManager.setTextField(TextField(getChildAt(t)), tTransStr);
				
						}
					}	
				}
		
				
				this.visible = false;
				
				mSingletonED.removeEventListener(HandleArtworkTranslation.TRANSLATE_ARTWORK, changeArtworkEvent);
		
			}
			
			
			
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}
	
}
