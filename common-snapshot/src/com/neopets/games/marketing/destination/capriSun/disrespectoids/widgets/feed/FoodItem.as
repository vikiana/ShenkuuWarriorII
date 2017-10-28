/**
 *	This class listens provides the UI for "feed a pet" requests.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.feed
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
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	
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
		}
	}
	
}