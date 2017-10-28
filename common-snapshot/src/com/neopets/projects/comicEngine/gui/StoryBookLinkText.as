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
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This will Translate the TextField for a User for the StoryEngine and allow for URL Events to be dispatched.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.17.2009
	 */
	 
	public class StoryBookLinkText extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const TRANSLATE_ARTWORK:String = "TranslateThisArtwork";
		public static const SEND_URL_MESSAGE:String = "SendingURLRequest";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		protected var mTranslationManager:TranslationManager;
		protected var mSingletonED:MultitonEventDispatcher;
		protected var mKey:String;
		
		public var link_txt:TextField;				// On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookLinkText():void
		{
			this.root.addEventListener(StoryBookPage.SENDKEY_EVENT, setupEventDispatcher, false, 0, true);
			
			addEventListener(MouseEvent.MOUSE_DOWN, sendURLMessage ,false ,0, true);
		}
		
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
			mSingletonED.addEventListener(HandleArtworkTranslation.TRANSLATE_ARTWORK, changeArtworkEvent);
		}
		 
		/**
		 * 	@Note: Send a Message to go to a URL Link
		 */
		 
		 protected function sendURLMessage(evt:MouseEvent):void
		 {
		 		mSingletonED.dispatchEvent(new CustomEvent({objectName:this.name}, 	StoryBookLinkPanel.SEND_URL_MESSAGE));
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
					mTranslationManager = TranslationManager.instance;
					var tTransData:TranslationData = TranslationData(evt.oData.transData);
					
					var tID:String = evt.oData.transFrontID +  this.name + "_" + link_txt.name;
					var tTransStr:String;
					
					
					if (tTransData.hasOwnProperty(tID))
					{
						tTransStr	= tTransData[tID];
						
					}
					else
					{
						tTransStr = "Error in Translation System";	
					}
							
					mTranslationManager.setTextField(link_txt, tTransStr);	
				
			}
			
			mSingletonED.removeEventListener(HandleArtworkTranslation.TRANSLATE_ARTWORK, changeArtworkEvent);
		
	
		}
		
	
	}
	
}
