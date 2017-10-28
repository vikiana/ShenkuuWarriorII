/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.marketing.collectorsCase.loadedData.ItemData;
	
	/**
	 *	This class displays the info for a single collector's case item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class ItemSlot extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const DETAILS_POP_UP:String = "details_mc";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _nameText:TextField;
		protected var _dateClip:MovieClip;
		protected var _counter:MovieClip;
		protected var iconArea:MovieClip;
		protected var iconClip:MovieClip;
		protected var itemData:Object;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var loadList:LoaderQueue;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ItemSlot():void{
			_nameText = this["name_txt"];
			_counter = this["counter_mc"];
			_dateClip = this["date_mc"];
			iconArea = this["icon_area_mc"];
			// add a place where the new icon can be loaded.
			iconClip = new MovieClip();
			addChild(iconClip);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function loads item information into this slot.
		 * @param		info		Object 		Item data being loaded
		 */
		 
		public function loadData(info:Object):void {
			if(info == null) return;
			// store data
			itemData = info;
			itemData.addEventListener(ItemData.TOTAL_CHANGED,onTotalChanged);
			updateIcon(true);
			// load the item's name
			var trans:TranslationManager = TranslationManager.instance;
			var trans_text:String;
			if(_nameText != null) {
				trans_text = trans.getTranslationOf("IDS_NAME_OPEN_TAG");
				trans_text += itemData.itemName;
				trans_text += trans.getTranslationOf("IDS_CLOSE_TAG");
				_nameText.htmlText = trans_text;
			}
			// show the item's release date
			if(_dateClip != null) {
				if(itemData.isBonusItem) {
					_dateClip.caption = trans.getTranslationOf("IDS_BONUS");
				} else {
					_dateClip.monthName = itemData.monthName;
					_dateClip.year = itemData.releaseDate.fullYear;
				}
			}
			// If there are multiple items, show them
			if(_counter != null) {
				_counter.count = info.itemTotal;
			}
			if(info.itemTotal > 1) gotoAndPlay("multiple");
			else gotoAndPlay("one");
		}
		
		/**
		 * @This function loads the target icon based on the given url.
		 * @param		url			String 		Relative url of the icon being loaded
		 * @param		wait		Boolean 	Use this flag to load through our loadList
		 */
		 
		public function loadIcon(url:String,wait:Boolean=false):void {
			// clear previous icon
			while(iconClip.numChildren > 0) iconClip.removeChildAt(0);
			// was a valid url provided?
			var bb:Rectangle;
			if(url != null) {
				// load a new icon
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onIconLoaded);
				// move loader to center of area
				if(iconArea != null) {
					bb = iconArea.getBounds(this);
					loader.x = (bb.left + bb.right) / 2;
					loader.y = (bb.top + bb.bottom) / 2;
				}
				iconClip.addChild(loader);
				// load image 
				var full_path:String = FlashVarManager.getURL("image_server",url);
				if(wait && loadList != null) loadList.push(loader,full_path);
				else loader.load(new URLRequest(full_path));
				// enable mouse clicks on the new icon
				iconClip.addEventListener(MouseEvent.CLICK,onIconClicked);
				iconClip.buttonMode = true;
			} else {
				// decide whether to show bonus item marker
				var marker:MovieClip;
				if(itemData != null && itemData.isBonusItem) {
					marker = new BonusIcon();
				} else {
					marker = new UnknownIcon();
				}
				// move marker to center of area
				if(iconArea != null) {
					bb = iconArea.getBounds(this);
					marker.x = (bb.left + bb.right) / 2;
					marker.y = (bb.top + bb.bottom) / 2;
				}
				iconClip.addChild(marker);
				// turn off pop up calls
				iconClip.removeEventListener(MouseEvent.CLICK,onIconClicked);
				iconClip.buttonMode = false;
			}
		}
		
		/**
		 * @Call this function to synch the icon with our item data.
		 * @param		wait		Boolean 		Use this flag to load through our loadList
		 */
		 
		public function updateIcon(wait:Boolean=false):void {
			if(itemData == null) return;
			// does the user have the item?
			if(itemData.itemTotal > 0) {
				loadIcon(itemData.iconURL,wait);
			} else {
				// Is the item available yet?
				if(itemData.isForSale){// || itemData.isBonusItem) {
					loadIcon(itemData.imprintURL,wait);
				} else {
					// should we show the teaser preview anyway?
					if(itemData.teaserShown) loadIcon(itemData.imprintURL,wait);
					else loadIcon(null,wait);
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is trigger when our icon has been fully loaded.
		 */
		
		public function onIconLoaded(ev:Event) {
			// center the image
			var info:LoaderInfo = ev.target as LoaderInfo;
			var image:DisplayObject = info.content;
			var bb:Rectangle = image.getBounds(image);
			image.x = (bb.left + bb.right) / -2;
			image.y = (bb.top + bb.bottom) / -2;
		}
		
		/**
		 * @This function broadcasts an icon click event.
		 */
		
		public function onIconClicked(ev:Event) {
			var popup:PopUp = PopUpLayer.requestPopUp("DetailsPopUpMC",itemData,DETAILS_POP_UP);
			if(popup != null) {
				popup.centerOver(this,false,true);
				popup.moveLeftOf(this);
				if(!popup.isInStageBounds) popup.moveRightOf(this);
			}
		}
		
		/**
		 * @This function is trigger when our item count is changed.
		 */
		
		public function onTotalChanged(ev:Event) {
			updateIcon();
			if(_counter != null) {
				_counter.count = itemData.itemTotal;
			}
			if(itemData.itemTotal > 1) gotoAndPlay("multiple");
			else gotoAndPlay("one");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}