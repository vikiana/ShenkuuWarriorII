/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.text.TextField;
	import flash.events.Event;
	import com.neopets.util.button.NeopetsButton;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This class is simply a subclass of NeopetsButton that stores the label text if there's no 
	 *  textfield in place to receive it.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class TextButton extends NeopetsButton 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _text:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TextButton():void{
			super();
			if(label_txt == null) addEventListener(Event.ENTER_FRAME,onLabelCheck);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function set lockOut(pFlag:Boolean):void {
			mLockout = pFlag;
			if(mLockout) {
				useHandCursor = false;
				gotoAndStop("locked");
			} else {
				useHandCursor = true;
				gotoAndStop("off");
			}
		}
		
		public function get text():String { return _text; }
		
		public function set text(str:String) {
			var trans:TranslationManager = TranslationManager.instance;
			_text = trans.getTranslationOf("IDS_BUTTON_OPEN_TAG");
			_text += str;
			_text += trans.getTranslationOf("IDS_CLOSE_TAG");
			if(_text != null) setText(_text);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries assigning an initializing the target text field as our label.
		 * @param		txt			TextField 		TextField to be used
		 */
		
		public function setLabel(txt:TextField) {
			label_txt = txt;
			if(_text != null) setText(_text);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is called each frame until our label is found.
		 */
		
		public function onLabelCheck(ev:Event) {
			if(label_txt == null) setLabel(this["main_txt"]);
			if(label_txt != null) removeEventListener(Event.ENTER_FRAME,onLabelCheck);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}