
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.util
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.util.BroadcasterClip;
	
	import com.neopets.util.display.DisplayUtils;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This class attaches broad listener functionality to a textfield.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class ListenerTextClip extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _baseText:String;
		// components
		protected var _textField:TextField;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ListenerTextClip():void{
			super();
			// check the translation manager for translated text
			// search for textfield
			textField = DisplayUtils.getDescendantInstance(this,TextField) as TextField;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get textField():TextField { return _textField; }
		
		public function set textField(txt:TextField) {
			if(txt != _textField) {
				_textField = txt;
				updateText();
			}
		}
		
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to try setting up our base text. 
		
		public function setBaseText(ids:String,default_text:String=null) {
			var translator:TranslationManager = TranslationManager.instance;
			if(translator.translationData != null) {
				_baseText = translator.getTranslationOf(ids);
			}
			if(_baseText == null) _baseText = default_text;
			updateText();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//	This function makes sure our displayed bitmap matches our text.
		
		public function updateText(ev:Event=null):void {
			if(_textField == null) return;
			// check if we have base text
			if(_baseText != null && _baseText.length > 0) {
				_textField.htmlText = _baseText;
			} else {
				_textField.htmlText = "?";
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
