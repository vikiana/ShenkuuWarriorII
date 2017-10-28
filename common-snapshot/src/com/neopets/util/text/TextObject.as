
/* AS3
	Copyright 2008
*/
package com.neopets.util.text
{
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.translation.TranslationObject;
	
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *	This for creating Dynamic TextFields Wrapped in a Spite Shell.
	 *	The Incomming Data needs to be an Object, XML
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.27.2009
	 */
	 
	public class TextObject extends Sprite
	{
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mID:String;
		protected var mLanguage:String;
		protected var mDefaultFormat:TextFormat;
		protected var mTextField:TextField;
		protected var mTranslationObject:TranslationObject;
		protected var mConstructionData:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TextObject()
		{
			setVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get language():String
		{
			return mLanguage;
		}
		
		public function get ID():String
		{
			return mID;
		}
		
		public function get text():String
		{
			return mTextField.htmlText;
		}
		public function set text(pString:String):void
		{
			mTextField.htmlText = pString;
			mTextField.setTextFormat(mDefaultFormat);
		}
		
		public function get txt_Fld():TextField
		{
			return mTextField;
		}
		
		public function set txt_Fld(pString:TextField):void
		{
			mTextField = pString;
		}
		
		public function get translationObject():TranslationObject
		{
			return mTranslationObject;
		}
		
		public function get constructXML():Object
		{
			return mConstructionData;
		}
		
		public function get textFormat():TextFormat
		{
			return mDefaultFormat;
		}
		
		public function set textFormat(pTextF:TextFormat):void
		{
			mTextField.setTextFormat(pTextF);
			mDefaultFormat = pTextF;	
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is the Setup for an TextObject
		 * @param		pConstructData			Object			The Object can be XML or an Object 	
		 */
		 
		public function init(pConstructData:Object):void
		{
			mConstructionData = pConstructData;
			
			//Setup the Sprite
		
			mID = mConstructionData.id;
			mLanguage = mConstructionData.language;

		
			if (mConstructionData.hasOwnProperty("TEXTFIELD"))
			{
				GeneralFunctions.setParamatersList(mTextField,mConstructionData.TEXTFIELD);
			}
			
			if (mConstructionData.hasOwnProperty("FORMAT"))
			{
				GeneralFunctions.setParamatersList(mDefaultFormat,mConstructionData.FORMAT);
			}
			
			if (checkFont(mConstructionData.font))
			{
				mDefaultFormat.font = mConstructionData.font;
				
				if (mConstructionData.hasOwnProperty("translationId"))
				{
					mTranslationObject = new TranslationObject(mConstructionData.translationId,mConstructionData.font,mTextField);	
				}	
			}
			else
			{
				mTextField.embedFonts = false;	
			}
			
			mTextField.setTextFormat(mDefaultFormat);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		protected function setVars():void
		{
			mDefaultFormat = new TextFormat();
			mTextField = new TextField();
			mTextField.multiline = true;
			mTextField.wordWrap = true;
			mTextField.embedFonts = true;
			addChild(mTextField);	
		}
		
		/**
		* @Note: Checks to see if the font is embedded
		* @param		pFontName		String			The Name of the Font to Check
		*/
		
	 	protected function checkFont(pFontName:String):Boolean
	 	{
	 		var tFontArray:Array = Font.enumerateFonts(false);
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
	}
	
}
