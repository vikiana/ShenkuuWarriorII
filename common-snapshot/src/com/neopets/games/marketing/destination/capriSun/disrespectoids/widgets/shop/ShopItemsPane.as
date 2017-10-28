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
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.PrizeShopPage;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.shop.ShopItemClip;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.servers.NeopetsAmfManager;
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class ShopItemsPane extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ShopItemsPane():void {
			super();
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// get the user's point total
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
			var responder:Responder = new Responder(onItemsResult,onItemsFault);
			delegate.callRemoteMethod("CapriSun2010Service.prizeShopItemInfo",responder);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to return a list of all children
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
				
		// "Item Info" Response Listeners
		
		protected function onItemsResult(msg:Object):void {
			trace("onItemsResult: " + msg);
			// extract item list from response
			var entries:Array
			if("items" in msg) {
				entries = msg["items"] as Array;
				if(entries == null) return;
			}
			// get all children who are also item handlers
			var slots:Array = DisplayUtils.getChildInstances(this,ShopItemClip);
			if(slots == null) return; // cancel if we have no where to put the data
			// sort slots by name
			slots.sortOn("name");
			// load each entry into the appropriate item slot
			var entry:Object;
			var slot:Object;
			for(var i:int = 0; i < entries.length; i++) {
				if(i < slots.length) {
					entry = entries[i];
					slot = slots[i];
					slot.itemData = entry;
				} else break;
			}
		}
		
		protected function onItemsFault(msg:Object):void {
			trace("onItemsFault: " + msg);
		}

	}
	
}