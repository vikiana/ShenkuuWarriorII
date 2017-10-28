/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.marketing.collectorsCase.ConfirmAddPopUp;
	
	/**
	 *	This class shows the user additional information for the target item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class DetailsPopUp extends PopUp 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const MALL_URL:String = "http://ncmall.neopets.com/mall/shop.phtml?page=collectorhub";
		public static const CAN_NOT_ADD_POP_UP:String = "can_not_add_mc";
		public static const CONFIRMATION_POP_UP:String = "confirm_add_mc";
		public static const ITEM_REMOVED_POP_UP:String = "item_removed_mc";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// components
		protected var _closeButton:SimpleButton;
		protected var _nameField:TextField;
		protected var _descriptionField:TextField;
		protected var imageArea:MovieClip;
		protected var imageLoader:Loader;
		protected var _addItemButton:TextButton;
		protected var _removeItemButton:TextButton;
		protected var _buyItemButton:TextButton;
		// misc. variables
		protected var itemData:Object;
		protected var delegate:AmfDelegate;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function DetailsPopUp():void{
			closeButton = this["close_btn"];
			_nameField = this["name_txt"];
			_descriptionField = this["desc_txt"];
			imageArea = this["image_area_mc"];
			addItemButton = this["add_mc"];
			removeItemButton = this["remove_mc"];
			buyItemButton = this["buy_mc"];
			// set up communication with php
			delegate = new AmfDelegate();
			delegate.gatewayURL = FlashVarManager.getURL("script_server","/amfphp/gateway.php");
		    delegate.connect();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get addItemButton():TextButton { return _addItemButton; }
		
		public function set addItemButton(btn:TextButton) {
			// clear previous button
			if(_addItemButton != null) _addItemButton.removeEventListener(MouseEvent.CLICK,onAddItem);
			// set new button
			_addItemButton = btn;
			if(_addItemButton != null) {
				var trans:TranslationManager = TranslationManager.instance;
				_addItemButton.text = trans.getTranslationOf("IDS_ADD_BUTTON");
				_addItemButton.addEventListener(MouseEvent.CLICK,onAddItem);
			}
		}
		
		public function get buyItemButton():TextButton { return _buyItemButton; }
		
		public function set buyItemButton(btn:TextButton) {
			// clear previous button
			if(_buyItemButton != null) _buyItemButton.removeEventListener(MouseEvent.CLICK,onBuyItem);
			// set new button
			_buyItemButton = btn;
			// set the purchase button
			if(_buyItemButton != null) {
				var trans:TranslationManager = TranslationManager.instance;
				_buyItemButton.text = trans.getTranslationOf("IDS_BUY_BUTTON");
				_buyItemButton.addEventListener(MouseEvent.CLICK,onBuyItem);
			}
		}
		
		public function get closeButton():SimpleButton { return _closeButton; }
		
		public function set closeButton(btn:SimpleButton) {
			// clear previous button
			if(_closeButton != null) _closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			// set new button
			_closeButton = btn;
			if(_closeButton != null) _closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
		}
		
		public function get removeItemButton():TextButton { return _removeItemButton; }
		
		public function set removeItemButton(btn:TextButton) {
			// clear previous button
			if(_removeItemButton != null) _removeItemButton.removeEventListener(MouseEvent.CLICK,onRemoveItem);
			// set new button
			_removeItemButton = btn;
			// set the purchase button
			if(_removeItemButton != null) {
				var trans:TranslationManager = TranslationManager.instance;
				_removeItemButton.text = trans.getTranslationOf("IDS_REMOVE_BUTTON");
				_removeItemButton.addEventListener(MouseEvent.CLICK,onRemoveItem);
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
			if(info == null) return;
			var trans:TranslationManager = TranslationManager.instance;
			var trans_text:String;
			// show item name
			if(_nameField != null) {
				trans_text = trans.getTranslationOf("IDS_NAME_OPEN_TAG");
				trans_text += info.itemName;
				trans_text += trans.getTranslationOf("IDS_CLOSE_TAG");
				_nameField.htmlText = trans_text;
			}
			// show item details
			if(_descriptionField != null) {
				trans_text = trans.getTranslationOf("IDS_DESC_OPEN_TAG");
				trans_text += info.description;
				trans_text += trans.getTranslationOf("IDS_CLOSE_TAG");
				_descriptionField.htmlText = trans_text;
			}
			// load the target image
			loadImage(info.imageURL);
			// set up the remove item button
			if(_removeItemButton != null) _removeItemButton.lockOut = (info.itemTotal <= 0);
			// set the purchase button
			if(_buyItemButton != null) _buyItemButton.visible = info.isForSale;
			// store item data
			itemData = info;
		}
		
		/**
		 * @This function loads a new logo.
		 * @param		url			String 		URL to be loaded
		 */
		 
		public function loadImage(url:String):void {
			if(url == null) return;
			// clear the previous logo
			if(imageLoader != null) {
				removeChild(imageLoader);
			}
			// set up the loader
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
			// move loader to center of area
			if(imageArea != null) {
				var bb:Rectangle = imageArea.getBounds(this);
				imageLoader.x = (bb.left + bb.right) / 2;
				imageLoader.y = (bb.top + bb.bottom) / 2;
			}
			addChild(imageLoader);
			// load image 
			var full_path:String = FlashVarManager.getURL("image_server",url);
			imageLoader.load(new URLRequest(full_path));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Use this function to request removing the item from the case.
		 */
		 
		public function onAddItem(ev:Event=null):void {
			if(itemData != null) {
				var responder : Responder = new Responder(onAddItemResult, onAddItemFault);
				delegate.callRemoteMethod("NcMallCollectorCaseService.canBeAdded",responder,itemData.IDNumber);
			}
		}
		
		/**
		 * Amf success for canBeAdded call
		*/
		public function onAddItemResult(msg:Object):void
		{
			trace("onAddItemResult: event: " + msg);
			var popup:PopUp;
			if(msg.err) {
				popup = PopUpLayer.requestPopUp("MessagePopUpMC","IDS_CAN_NOT_ADD",CAN_NOT_ADD_POP_UP);
			} else {
				if(itemData != null) {
					popup = PopUpLayer.requestPopUp("ConfirmAddPopUpMC",itemData,CONFIRMATION_POP_UP);
					// close this pop-up if the addition is confirmed
					popup.addEventListener(ConfirmAddPopUp.ADD_CONFIRMED,onCloseRequest);
				}
			}
			if(popup != null) popup.centerOver(this);
		}
		
		/**
		 * Amf fault for canBeAdded call
		*/
		public function onAddItemFault(msg:Object):void
		{
			trace("onAddItemFault: event: " + msg);
		}
		
		/**
		 * @Use this function to trigger the "buy item" link.
		 */
		 
		public function onBuyItem(ev:Event=null):void {
			var req:URLRequest = new URLRequest(MALL_URL);
			navigateToURL(req,"_blank");
		}
		
		/**
		 * @Use this function to request removing the item from the case.
		 */
		 
		public function onRemoveItem(ev:Event=null):void {
			if(itemData != null) {
				if(itemData.itemTotal > 0) {
					var responder : Responder = new Responder(onRemoveItemResult, onRemoveItemFault);
					delegate.callRemoteMethod("NcMallCollectorCaseService.removeCollection",responder,itemData.IDNumber);
				}
			}
		}
		
		/**
		 * Amf success for removeCollection call
		*/
		public function onRemoveItemResult(msg:Object):void
		{
			trace("success: event: " + msg);
			if(!msg.err) {
				if(itemData != null) {
					itemData.itemTotal--;
					_removeItemButton.lockOut = (itemData.itemTotal <= 0);
				}
				// let the user know about the removal
				var popup:PopUp = PopUpLayer.requestPopUp("MessagePopUpMC","IDS_ITEM_REMOVED",ITEM_REMOVED_POP_UP);
				if(popup != null) popup.centerOver(this);
			}
		}
		
		/**
		 * Amf fault for removeCollection call
		*/
		public function onRemoveItemFault(msg:Object):void
		{
			trace("fault: event: " + msg);
		}
		
		/**
		 * @This function centers image assets after they're loaded.
		 */
		 
		public function onImageLoaded(ev:Event=null):void {
			// get the image
			var info:LoaderInfo = ev.target as LoaderInfo;
			var image:DisplayObject = info.content;
			// center the image
			var bb:Rectangle = image.getBounds(image);
			image.x = (bb.left + bb.right) / -2;
			image.y = (bb.top + bb.bottom) / -2;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}