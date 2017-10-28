/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.shop
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.ImagePane;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.events.CustomEvent;
	
	public class ShopItemClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const PURCHASE_REQUEST:String = "ShopItem_purchase_request";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _itemData:Object;
		protected var _IDNumber:Number;
		public var costTextTemplate:String = "cost:<br/>%1 pts";
		// components
		protected var _imagePane:ImagePane;
		protected var _costField:TextField;
		protected var _nameField:TextField;
		protected var _buyButton:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ShopItemClip():void {
			super();
			initID();
			// check for componets
			_imagePane = getChildByName("image_mc") as ImagePane;
			_costField = getChildByName("cost_txt") as TextField;
			_nameField = getChildByName("name_txt") as TextField;
			buyButton = getChildByName("buy_mc") as MovieClip;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get buyButton():MovieClip { return _buyButton; }
		
		public function set buyButton(btn:MovieClip) {
			// clear previous listeners
			if(_buyButton != null) {
				_buyButton.removeEventListener(MouseEvent.CLICK,onBuyRequest);
			}
			// set up new listeners
			_buyButton = btn;
			if(_buyButton != null) {
				_buyButton.addEventListener(MouseEvent.CLICK,onBuyRequest);
			}
		}
		
		public function get IDNumber():Number { return _IDNumber; }
		
		public function get itemBuyable():Boolean {
			if(_itemData == null) return false;
			if("available" in _itemData) {
				if(!_itemData.available) return false;
			}
			if("purchased" in _itemData) {
				if(_itemData.purchased) return false;
			}
			return true;
		}
		
		public function get itemData():Object { return _itemData; }
		
		public function set itemData(info:Object) {
			_itemData = info;
			if(_itemData != null) {
				// show item's name
				if("name" in _itemData) showName(_itemData.name);
				// display item's cost
				if("value" in _itemData) showCost(_itemData.value);
				// load item's image
				if("url" in _itemData) loadImage(_itemData.url);
				// show buyable status
				if(_buyButton != null) {
					if(itemBuyable) _buyButton.gotoAndPlay("on");
					else _buyButton.gotoAndPlay("off");
				}
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to add the target image to the item display.
		
		public function loadImage(url:String):void {
			if(url == null) return;
			// create new image loader
			var img_loader:Loader = new Loader();
			img_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
			// start loading new image
			var req:URLRequest = new URLRequest(url);
			img_loader.load(req);
		}
		
		// display the item's cost
		
		public function showCost(cost:Number) {
			if(_costField == null) return;
			if(costTextTemplate != null) {
				_costField.htmlText = costTextTemplate.replace("%1",cost);
			} else _costField.htmlText = String(cost);
		}
		
		// display the item's cost
		
		public function showName(id:String) {
			if(_nameField == null) return;
			if(id != null) _nameField.htmlText = id;
			else _nameField.htmlText = "";
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to try extracting out ID number from our name.
		
		protected function initID():void {
			// extract numeric string from our name
			if(name == null) return;
			var num_list:Array = name.match(/\d+/);
			// use last number in list as our ID number
			if(num_list.length > 0) {
				var last_index:int = num_list.length - 1;
				_IDNumber = Number(num_list[last_index]);
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When the buy button is pressed, let listeners know about the purchase request.
		
		protected function onBuyRequest(ev:Event) {
			if(itemBuyable) broadcast(PURCHASE_REQUEST);
		}
		
		// When an image is loaded, try pushing it to our image pane.
		
		protected function onImageLoaded(ev:Event) {
			if(_imagePane != null) {
				var info:LoaderInfo = ev.target as LoaderInfo;
				_imagePane.content = info.loader;
			}
		}

	}
	
}