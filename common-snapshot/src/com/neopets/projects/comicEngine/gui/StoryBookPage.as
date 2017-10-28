
﻿
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.gui
{
	import com.neopets.projects.comicEngine.objects.StoryBookCallObject;
	import com.neopets.projects.comicEngine.objects.StoryBookClickObject;
	import com.neopets.projects.comicEngine.objects.StoryBookPanelObject;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.events.SingletonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  3.04.2009
	 */
	 
	public class StoryBookPage extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const  LANG_UPDATE_EVENT:String = "UpdateTheLanguage";

		public static const  TOGGLE_POPUP_VISIBILITY_EVENT:String = "TogglePopupVisibility";
		
		public static const SENDKEY_EVENT:String = "SendKeyEvent";
		
		public static const RESET_PAGE_EVENT:String = "ResetArtworkOnPage";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var mKey:String;
		
		public var mLang:String;
		protected var mSetupTranslation:Boolean;
		
		protected var mTranslationManager:TranslationManager;
		protected var mSingletonED:MultitonEventDispatcher;
		protected var mTranslationData:TranslationData;
		protected var mTranslationFrontID:String;
		protected var mPanelDataObject:StoryBookPanelObject;
		
		public var mInterface:MovieClip;		//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function StoryBookPage():void{
			super();
			setupVars();
			addEventListener(LANG_UPDATE_EVENT,updateArtwork);
			addEventListener(RESET_PAGE_EVENT,resetArtwork);
		}
		

		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Clear the Artwork to starting locations
		 */
		 
		 protected function resetArtwork(evt:Event):void
		 {
		 	mSingletonED.dispatchEvent(new CustomEvent({id:"ALL",amount:StoryBookPanel.DEFAULT_BRIGHTNESS},StoryBookPanel.CHANGE_VISIBILITY_EVENT));
		 }
		
		
		/**
		 * @Note: This listens for a translation Request
		 *	@Param	evt.oData.lang							String					The Language to be Translated to
		 *  @Param	evt.oData.projectId						String					The Language ID for TranslationManager
		 * 	@Param	evt.oData.transData					TranslationData			Translation Data for the Pannel
		 *  @Param	evt.oData.transURL						String					Translation URL (Dev or Live)
		 *  @Param	evt.oData.transFrontID				String					The Starting of the URL String for Translation;
		 * 	@Param	evt.oData.setUpTranslation 		Boolean					If True it will go and get the Translation, if false it will use passed in translation from the StoryEngine (External)	
		 *  @Param	evt.oData.hash							String					THis is an Optional Flag for Extra Security
		 *  @Param	evt.oData.dataObject			 		Object					Holds the Info from the AMFPHP PANEL Object
		 *  @Param	evt.oData.externalTransLoading	Boolean					If it is being loaded from the Chapter Player
		 *  */
		 
		protected function updateArtwork(evt:CustomEvent = null):void
		{
	
			if (evt != null)
			{
				if (evt.oData.hasOwnProperty("dataObject"))
				{
					mPanelDataObject =  StoryBookPanelObject(evt.oData.dataObject);
					mKey = mPanelDataObject.name;
				}
				else
				{
					mKey = evt.oData.transFrontID; 		//This is Just to put something for the value
				}
				
				//Send the Key for the EventDispatcher
				setupEventDispatcher(mKey);
				
				var tExternalLoadedFlag:Boolean = false;
				
				if (evt.oData.hasOwnProperty("externalTransLoading"))
				{
					tExternalLoadedFlag = Boolean(evt.oData.externalTransLoading);	
				}
				
				if (evt.oData.hasOwnProperty("setUpTranslation"))
				{
					mSetupTranslation = Boolean(evt.oData.setUpTranslation);	
				}
				
				mTranslationFrontID = evt.oData.transFrontID;
				mLang = String(evt.oData.lang).toUpperCase();
				
				if  (mSetupTranslation)
				{
					var tHash:String = (evt.oData.hasOwnProperty("hash")) ? evt.oData.hash : null;
					
					mTranslationManager.init(mLang,evt.oData.projectId,14,evt.oData.transData,evt.oData.transURL,tHash);
				}
				else
				{
					var tOverrideTranslation:Boolean = false;
					
					if (tExternalLoadedFlag)
					{
						tOverrideTranslation = true;	
					}
		
					
					mTranslationData = evt.oData.transData;
					mSingletonED.dispatchEvent(new CustomEvent({lang:mLang, transData:mTranslationData, transFrontID:mTranslationFrontID, useTranslation:tOverrideTranslation},HandleArtworkTranslation.TRANSLATE_ARTWORK));
				}
				
			
			}
			
			removeEventListener(LANG_UPDATE_EVENT,updateArtwork);

		}
		
		
		
		/** 
		 * @Note When TranslationManager has contected to PHP and Translation is Complete.
		 * @Note: If you Have In game Items Needed for Translation, You should have them in them translated after this event
		 */
		 
		private function translationComplete(evt:Event):void
		{
		 	mTranslationData = TranslationData(mTranslationManager.translationData);
		 	
			mSingletonED.dispatchEvent(new CustomEvent({lang:mLang, transData:mTranslationData, transFrontID:mTranslationFrontID, useTranslation:true},HandleArtworkTranslation.TRANSLATE_ARTWORK));
		} 
		
		/**
		 * @Note Only used when there is a Link Object in a Panel
		 * @param		evt.oData.objectName		String		The Name of The URL Link Object
		 */
		
		private function onURLMessageCheck (evt:CustomEvent):void
		{
			var tObjectName:String = evt.oData.	objectName;

			
			var tCount:int = mPanelDataObject.clickable_objects.length;
			var tURL:String;
			
			for (var z:uint = 0; z < tCount; z++)
			{
				if (mPanelDataObject.clickable_objects[z] is StoryBookClickObject)
				{
					
					var tClickObject:StoryBookClickObject = mPanelDataObject.clickable_objects[z];
					trace("onURLMessageCheck > is StoryBookClickObject: ", tClickObject.attach_symbol);
					if (tClickObject.attach_symbol == tObjectName)
					{
						trace("onURLMessageCheck > is calling the Following:", tClickObject.click_url);
						//sendToURL(new URLRequest(tClickObject.click_url));	
						navigateToURL(new URLRequest(tClickObject.click_url),"_self");	
					}	
				}
				else if (mPanelDataObject.clickable_objects[z] is StoryBookCallObject)
				{
					trace("onURLMessageCheck > is StoryBookCallObject");
					
					var tCallObject:StoryBookCallObject = mPanelDataObject.clickable_objects[z];
					
					if (tCallObject.attach_symbol == tObjectName)
					{
						ExternalInterface.call(tCallObject.call_function, tCallObject.call_params[0], tCallObject.call_params[1], tCallObject.call_params[2]);	
					}		
				}
				
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mSetupTranslation = true;
			mTranslationManager = TranslationManager.instance;
			mTranslationManager.addEventListener(Event.COMPLETE, translationComplete, false, 0, true);
		}
		
		/**
		 * @Note: Setting up the EventDispatcher to a Key
		 * @param		pKey			String			The Key Used for the Shared Event Dispatcher
		 */
		 
		protected function setupEventDispatcher(pKey:String):void
		{
			mSingletonED = MultitonEventDispatcher.getInstance(pKey);
			mSingletonED.addEventListener(StoryBookLinkPanel.SEND_URL_MESSAGE, onURLMessageCheck,false,0,true);
			root.dispatchEvent(new CustomEvent({key:mKey}, StoryBookPage.SENDKEY_EVENT));	
		}
		
	}
	
}