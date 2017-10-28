/**
 *	This class listens provides the UI for "feed a pet" requests.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.feed
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import flash.external.ExternalInterface;
	
	public class FoodItem extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const FOOD_SELECTED:String = "food_selected";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var ADLinkID:String;
		public var neoContentID:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FoodItem():void {
			super();
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set clickable status
			clickable = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get clickable():Boolean { return buttonMode; }
		
		public function set clickable(bool:Boolean) {
			if(bool != buttonMode) {
				buttonMode = bool;
				if(buttonMode) addEventListener(MouseEvent.CLICK,onClick);
				else removeEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// This function tries to set our neocontent id using the country code flash var and
		// the provided list of id numbers (indexed by country code).
		
		public function setNeoContentByCC(ids:Object):void {
			var id:Object = DestinationView.getEntryByCC(ids);
			if(id != null) neoContentID = int(Number(id));
			else neoContentID = 0;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Relay click through shared dispatcher.
		
		protected function onClick(ev:MouseEvent) {
			broadcast(FOOD_SELECTED);
			if(ADLinkID != null) broadcast(DestinationView.ADLINK_REQUEST,ADLinkID);
			if(neoContentID > 0) broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,neoContentID);
			
			//trace('food item: '+ev.currentTarget.name);
			// tracking based on what item is clicked
			switch(ev.currentTarget.name)
			{
				case "cornDog_mc":
					//omniture, google tracking
					if (ExternalInterface.available)
					{
						ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Feed-A-Pet Corn Dog'");
					}
					else
					{
						trace("ExternalInterfaceCall Not Available");
					}
				break;
				
				case "candyApple_mc":
					if (ExternalInterface.available)
					{
						ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Feed-A-Pet Candy Apple'");
					}
					else
					{
						trace("ExternalInterfaceCall Not Available");
					}
					break;
				
				case "cottonCandy_mc":
					if (ExternalInterface.available)
					{
						ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Feed-A-Pet Cotton Candy'");
					}
					else
					{
						trace("ExternalInterfaceCall Not Available");
					}
					break;
			}
				
				
				
		}
	}
	
}