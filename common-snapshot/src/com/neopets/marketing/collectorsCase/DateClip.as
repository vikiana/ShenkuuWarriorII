/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This class will display how many of a given item the player has.
	 *  The counter is hidden if the player has one or fewer instances of the item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class DateClip extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _monthName:String;
		protected var _year:Number;
		protected var _dateTxt:TextField;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function DateClip():void{
			_dateTxt = this["date_txt"];
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get monthName():String { return _monthName; }
		
		public function set monthName(tag:String) {
			_monthName = tag;
			refreshDate();
		}
		
		public function get caption():String {
			if(_dateTxt != null) return _dateTxt.htmlText;
			else return null;
		}
		
		public function set caption(tag:String) {
			if(_dateTxt != null) {
				var trans:TranslationManager = TranslationManager.instance;
				var trans_text:String = trans.getTranslationOf("IDS_DATE_OPEN_TAG");
				trans_text += tag;
				trans_text += trans.getTranslationOf("IDS_CLOSE_TAG");
				_dateTxt.htmlText = trans_text;
			}
		}
		
		public function get year():Number { return _year; }
		
		public function set year(val:Number) {
			_year = val;
			refreshDate();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function upates the label when the month or year changes.
		 */
		 
		public function refreshDate():void {
			if(_dateTxt != null) {
				// build translated text
				var trans:TranslationManager = TranslationManager.instance;
				var trans_text:String = trans.getTranslationOf("IDS_DATE_OPEN_TAG");
				if(_monthName != null) trans_text += _monthName + " ";
				trans_text += _year;
				trans_text += trans.getTranslationOf("IDS_CLOSE_TAG");
				_dateTxt.htmlText = trans_text;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}