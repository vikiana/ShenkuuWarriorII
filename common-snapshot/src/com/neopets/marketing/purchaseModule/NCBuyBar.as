/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import com.neopets.util.events.EventFunctions;
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.marketing.purchaseModule.NCPurchasePopUp;
	
	/**
	 *	This class handles the buy button and associated password field.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.12.2010
	 */
	public class NCBuyBar extends BroadcasterClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const PURCHASE_REQUEST:String = "purchase_request";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		// components
		protected var _helpField:TextField;
		protected var _passwordField:TextField;
		protected var _buyButton:MovieClip;
		
		/**
		 *	@Constructor
		 */
		public function NCBuyBar():void{
			super();
			// initialize components
			helpField = getChildByName("help_txt") as TextField;
			passwordField = getChildByName("password_txt") as TextField;
			buyButton = getChildByName("buy_btn") as MovieClip;
			// send buy request out ot to the main module
			useParentDispatcher(NCPurchasePopUp);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get buyButton():MovieClip { return _buyButton; }
		
		public function set buyButton(dobj:MovieClip) {
			// set up listeners
			EventFunctions.transferListener(_buyButton,dobj,MouseEvent.CLICK,onBuyClick);
			// store new component
			_buyButton = dobj;
			if(_buyButton != null) {
				var translator:TranslationManager = TranslationManager.instance;
				var translation:String = translator.getTranslationOf("IDS_BUY");
				_buyButton.setText(translation);
				_buyButton.tabIndex = 1001;
				_buyButton.lockOut = true;
			}
		}
		
		public function get helpField():TextField { return _helpField; }
		
		public function set helpField(dobj:TextField) {
			// store new component
			_helpField = dobj;
			if(_helpField != null) {
				var translator:TranslationManager = TranslationManager.instance;
				_helpField.htmlText = translator.getTranslationOf("IDS_ENTER_PASSWORD");
			}
		}
		
		public function get lockOut():Boolean {
			if(_buyButton != null) return _buyButton.lockOut;
			else return false;
		}
		
		public function set lockOut(bool:Boolean):void {
			if(_buyButton != null) _buyButton.lockOut = bool;
		}
		
		public function get password():String {
			if(_passwordField != null) return _passwordField.text;
			else return "";
		}
		
		public function get passwordField():TextField { return _passwordField; }
		
		public function set passwordField(dobj:TextField) {
			// set up listeners
			EventFunctions.transferListener(_passwordField,dobj,Event.CHANGE,onPasswordChange);
			EventFunctions.transferListener(_passwordField,dobj,MouseEvent.CLICK,onTextClick);
			EventFunctions.transferListener(_passwordField,dobj,KeyboardEvent.KEY_DOWN,onTextKey);
			// store new component
			_passwordField = dobj;
			if(_passwordField != null) {
				_passwordField.displayAsPassword = true;
				_passwordField.tabIndex = 1000;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the buy button is clicked on, make a purchase request.
		
		protected function onBuyClick(ev:Event) {
			if(!lockOut) {
				var transmission:Event = new Event(PURCHASE_REQUEST);
				dispatchEvent(transmission);
			}
		}
		
		// When the textfield is clicked on, clear the password instuctions.
		
		protected function onTextClick(ev:Event) {
			if(_helpField != null) _helpField.htmlText = "";
		}
		
		// Treat pressing the enter key while entering a password as clicking on the buy button.
		
		protected function onTextKey(ev:KeyboardEvent) {
			if(ev.keyCode == Keyboard.ENTER) onBuyClick(ev);
		}
		
		// When the password field changes, update our helper text.
		
		protected function onPasswordChange(ev:Event) {
			if(_passwordField == null || _helpField == null) return;
			if(_passwordField.length <= 0) {
				var translator:TranslationManager = TranslationManager.instance;
				//_helpField.htmlText = translator.getTranslationOf("IDS_ENTER_PASSWORD");
				_buyButton.lockOut = true;
			} else {
				//_helpField.htmlText = "";
				_buyButton.lockOut = false;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
