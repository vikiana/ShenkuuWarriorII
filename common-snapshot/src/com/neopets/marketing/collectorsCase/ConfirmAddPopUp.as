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
	import flash.geom.Rectangle;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	This class is used to ask the user if they want to finish adding the item to their collection.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class ConfirmAddPopUp extends PopUp 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ADD_CONFIRMED:String = "AddItem_Confirmed";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// components
		protected var _messageField:TextField;
		protected var _confirmButton:TextButton;
		protected var _cancelButton:TextButton;
		// misc. variables
		protected var itemData:Object;
		protected var delegate:AmfDelegate;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ConfirmAddPopUp():void{
			messageField = this["msg_txt"];
			confirmButton = this["yes_mc"];
			cancelButton = this["no_mc"];
			// set up communication with php
			delegate = new AmfDelegate();
			delegate.gatewayURL = FlashVarManager.getURL("script_server","/amfphp/gateway.php");
		    delegate.connect();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get cancelButton():TextButton { return _cancelButton; }
		
		public function set cancelButton(btn:TextButton) {
			// clear previous button
			if(_cancelButton != null) _cancelButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			// set new button
			_cancelButton = btn;
			// set the purchase button
			if(_cancelButton != null) {
				var trans:TranslationManager = TranslationManager.instance;
				_cancelButton.text = trans.getTranslationOf("IDS_NO");
				_cancelButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			}
		}
		
		public function get confirmButton():TextButton { return _confirmButton; }
		
		public function set confirmButton(btn:TextButton) {
			// clear previous button
			if(_confirmButton != null) _confirmButton.removeEventListener(MouseEvent.CLICK,onConfirmed);
			// set new button
			_confirmButton = btn;
			// set the purchase button
			if(_confirmButton != null) {
				var trans:TranslationManager = TranslationManager.instance;
				_confirmButton.text = trans.getTranslationOf("IDS_YES");
				_confirmButton.addEventListener(MouseEvent.CLICK,onConfirmed);
			}
		}
		
		public function get messageField():TextField { return _messageField; }
		
		public function set messageField(tf:TextField) {
			_messageField = tf;
			// set the purchase button
			if(_messageField != null) {
				var trans:TranslationManager = TranslationManager.instance;
				var tagged:String  = trans.getTranslationOf("IDS_DESC_OPEN_TAG");
				tagged += trans.getTranslationOf("IDS_CONFIRM_ADD");
				tagged += trans.getTranslationOf("IDS_CLOSE_TAG");
				_messageField.htmlText = tagged;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to set up the pop up using the given information.
		 * @param		info		Object 		Initialization values for the pop up
		 */
		 
		override public function loadData(info:Object):void {
			itemData = info;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Use this function to request removing the item from the case.
		 */
		 
		public function onConfirmed(ev:Event=null):void {
			if(itemData != null) {
				var responder : Responder = new Responder(onAddItemResult, onAddItemFault);
				delegate.callRemoteMethod("NcMallCollectorCaseService.addCollection",responder,itemData.IDNumber);
			}
		}
		
		/**
		 * Amf success for addCollection call
		*/
		public function onAddItemResult(msg:Object):void
		{
			trace("success: event: " + msg);
			if(!msg.err) {
				if(itemData != null) itemData.itemTotal++;
			}
			onCloseRequest();
			// let our listeners know
			dispatchEvent(new Event(ADD_CONFIRMED));
		}
		
		/**
		 * Amf fault for addCollection call
		*/
		public function onAddItemFault(msg:Object):void
		{
			trace("fault: event: " + msg);
			onCloseRequest();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}