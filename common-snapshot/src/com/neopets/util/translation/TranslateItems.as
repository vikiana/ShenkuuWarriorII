
/* AS3
	Copyright 2008
*/
package com.neopets.util.translation 
{
	//import TextManagerPkg.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.unescapeMultiByte;
	
	
	/**
	 *	This is based on the Smerc TextManager but more open to expansion for outside Vendors
	 * @################# NOT USING THIS CLASS ANYMORE USE translationManager instead #######################
	 * 	
	 *  You create an TranslateItem on a as needed basis, with one Returned XML from neopets per
	 *  Instance of this Class.
	 *
	 *  ############## TO DO ###################
	 *  > Load the XML from Neopets
	 *  > Translate the XML
	 *  > Update the Graphic
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick
	 *	@since  01.12.2009
	 */
	 
	public class TranslateItems extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const LABEL_ID:String = "txtFld";  	//All the DisplayObjects TextFields should be Called This
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		/* Instance Name Dictionary to hold instance names with pair classes */
		
		protected var mInDictionary:Dictionary;
		protected var mTranslationXMLData:XML;
		protected var mTranslationStorage:Object;
		
		protected var mLoader:URLLoader;
		protected var mLangCode:String;
		protected var mGame_ID:int = 0;
		protected var mType_ID:int = 0;
		protected var mEmbedFlag:Boolean;
		
		protected var mExternalURLforTranslation:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TranslateItems(target:IEventDispatcher=null)
		{
			setupVars();
			super(target);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set externalURLforTranslation(pURL:String):void
		{
			mExternalURLforTranslation = pURL;
		}
		
		public function get translationXMLData():XML
		{
			return mTranslationXMLData;
		}
		
		public function get translationStorage():Object
		{
			return mTranslationStorage;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/** 
		 * @Note This is the Setup for this Object
		 * @param	pLang 					String			A Language Code (See LanguageID Class)
		 * @Param	pGame_id				int				The Game Code
		 * @Param	pLocalDictionary		Dictionary		The Passed in list of translationObjects to be proceesed 
		 * @Param	pType_id				uint			// 14 Application , 4 Game Content 
		 */
		 
		 public function init ( pLang:String,pGame_id:int,pLocalDictionary:Dictionary, pType_id:uint = 4):void
		 {
		 	mLangCode = pLang;
		 	mGame_ID = pGame_id;
		 	mType_ID = pType_id;
		 	mInDictionary = pLocalDictionary;
		 	
		 	if (pLang == LanguageID.CHINESE)
		 	{
		 		mEmbedFlag = false;	
		 	}
		 	
		 	loadExternalTranslationData();
		 }
		
		/**
		 * 	@NOTE: This is for a one off translation of an Item.
		 * 		@param		pTranslationObj		TranslationObject	If you use a TranslationObject then you do not need the other Parameters
		 * 		@param		pResourceName		String				The resname in the Neopets returned XML
		 * 		@param		pFontName			String				The Name of the Font you want the TextField Mapped to
		 *		@param		pTextField			TextField			The TextField That you want to be Translated 
		 */
		 
		public function translateOneItem(pTranslationObj:TranslationObject = null, pResourceName:String = null, pFontName:String = null, pTextField:TextField = null):void
		{
			
			var tTextField:TextField = (pTranslationObj == null) ? pTextField : pTranslationObj.textField;
			var tResName:String = (pTranslationObj == null) ? pResourceName : pTranslationObj.resourceName;
			var tFontName:String = (pTranslationObj == null) ? pFontName : pTranslationObj.fontName;
			
			var tFontFormat:TextFormat = tTextField.getTextFormat();
			tTextField.embedFonts = mEmbedFlag;
			
			tTextField.multiline = true;
			tTextField.wordWrap = true;
			
			//Translates the Text
			var tTranslatedText:String = mTranslationStorage[tResName];
			
			if (!tTranslatedText)
			{
				tTranslatedText = 	tTextField.toString();
				trace("Translation is Missing on> " + tResName);
			}
			
			tTextField.htmlText = tTranslatedText;
			
			if (checkFont(tFontName))
			{
				tFontFormat.font = tFontName;
			}
			else
			{
				tTextField.embedFonts = false;	
			}
			
			tTextField.setTextFormat(tFontFormat);
		}
		/**
		 * 	@NOTE: This is for just the translated Text
		 * 		@param		pResourceName		String				The resname in the Neopets returned XML
		 */
		 
		public function getTranslationString(pResourceName:String = null):String
		{
			//Translates the Text
			var tTranslatedText:String = mTranslationStorage[pResourceName];
			
			return tTranslatedText;
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note the Neopets XML has been returned, so now it processes it.
		 */
		 
		private function onCompleteHandler(a_evt:Event = null):void
		{
			mTranslationXMLData = new XML(mLoader.data);
			
			if(mTranslationXMLData.hasOwnProperty("errors"))
			{
				trace(mTranslationXMLData.errors);
			}
			
			var transUnitList:XMLList;
			transUnitList = mTranslationXMLData.file.body.child("trans-unit");
			var	total:int = transUnitList.length();
			var i:int = 0;
			
			while(i < total)
			{
				var transUnit:XML = transUnitList[i];
				var resName:XMLList = transUnit.attribute("resname");
				var source:String = unescapeMultiByte(transUnit.source);	
				mTranslationStorage[(resName.toString())] = source;
				i++;
			}
			
			completeTranslation();
			
		}
		
		private function catchIO(e:IOErrorEvent):void 
		{
			trace("IOError " + e.text);
		}
		
		private function onSecurityErrorHandler(a_evt:SecurityErrorEvent):void
		{
			trace("TextManager::onSecurityErrorHandler " + a_evt.text);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mExternalURLforTranslation = "http://www.neopets.com/transcontent/gettranslationxml.phtml";
			mEmbedFlag = true;
			mTranslationStorage = [];
		}
		
		/**
		* @Note: Checks to see if the font is embedded
		* @param		pFontName		String			The Name of the Font to Check
		*/
		
	 	private function checkFont(pFontName:String):Boolean
	 	{
	 		var tFontArray:Array = Font.enumerateFonts(true);
	 		var tCount:uint = tFontArray.length;
	 		
	 		for (var t:uint = 0; t < tCount; t++)
	 		{
	 			if (tFontArray[t].fontName == pFontName)
	 			{
	 				return true;
	 			}
	 		}
	 		
	 		return false;
	 	}
	 	
		/**
		 * Request the Game's XML depending on
		 * language code from Neopet's server.
		 */
		 
		private function loadExternalTranslationData():void
		{
			mLoader = new URLLoader();
			mLoader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, catchIO);
			mLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			
			var vars:URLVariables = new URLVariables();
	
			vars.lang = mLangCode;
			vars.type_id = mType_ID;
			vars.item_id = mGame_ID;
			vars.r = (Math.random() * mGame_ID);
			
			var request:URLRequest= new URLRequest();
			request.url = mExternalURLforTranslation;
			request.data = vars;
			request.method = URLRequestMethod.POST;
			
			mLoader.load(request);
		}
		
		/**
		 * Once the Data is Loaded, this cycles through the dictionary and translates each TextField
		 */
		 
		protected function completeTranslation():void
		{
			
			for each (var tTranslationObj:TranslationObject in mInDictionary)
			{
				//Setting up the TextField
				var tTextField:TextField = tTranslationObj.textField;
				var tFontFormat:TextFormat = tTextField.getTextFormat();
				tTextField.embedFonts = mEmbedFlag;
				
				//Translates the Text
				var tTranslatedText:String = mTranslationStorage[tTranslationObj.resourceName];
				
				if (!tTranslatedText)
				{
					tTranslatedText = 	tTranslationObj.textField.toString();
					trace("Translation is Missing on> " + tTranslationObj.resourceName);
				}
				
				tTextField.htmlText = tTranslatedText;
				
				if (checkFont(tTranslationObj.fontName))
				{
					tFontFormat.font = tTranslationObj.fontName;
				}
				else
				{
					tTextField.embedFonts = false;	
				}
				
				tTextField.setTextFormat(tFontFormat);
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		
	}
	
}
