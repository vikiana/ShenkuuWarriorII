/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	This class can be used to display a simple text message.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  1.13.2010
	 */
	public class MessagePopUp extends PopUp 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// components
		protected var _message:String;
		protected var _messageID:String;
		protected var _messageField:TextField;
		protected var _closeButton:TextButton;
		// misc. variables
		protected var itemData:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MessagePopUp():void{
			messageField = this["msg_txt"];
			closeButton = this["close_mc"];
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get closeButton():TextButton { return _closeButton; }
		
		public function set closeButton(btn:TextButton) {
			// clear previous button
			if(_closeButton != null) _closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			// set new button
			_closeButton = btn;
			// set the purchase button
			if(_closeButton != null) {
				var trans:TranslationManager = TranslationManager.instance;
				_closeButton.text = trans.getTranslationOf("IDS_CLOSE");
				_closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			}
		}
		
		public function get message():String { return _message; }
		
		public function get messageID():String { return _messageID; }
		
		public function set messageID(str:String) {
			_messageID = str;
			// get translation
			var trans:TranslationManager = TranslationManager.instance;
			var tagged:String  = trans.getTranslationOf("IDS_DESC_OPEN_TAG");
			tagged += trans.getTranslationOf(str);
			tagged += trans.getTranslationOf("IDS_CLOSE_TAG");
			_message = tagged;
			// show the message
			if(_messageField != null && _message != null) _messageField.htmlText = _message;
		}
		
		public function get messageField():TextField { return _messageField; }
		
		public function set messageField(tf:TextField) {
			_messageField = tf;
			// show the message
			if(_messageField != null && _message != null) _messageField.htmlText = _message;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to set up the pop up using the given information.
		 * @param		info		Object 		Initialization values for the pop up
		 */
		 
		override public function loadData(info:Object):void {
			if(info is String) messageID = info as String;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}