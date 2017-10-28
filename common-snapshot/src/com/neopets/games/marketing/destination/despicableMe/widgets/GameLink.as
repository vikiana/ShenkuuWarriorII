/**
 *	This class handles links to games in our game's room.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.15.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	
	public class GameLink extends BroadcasterClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const DEFAULT_BASE_URL:String = "http://www.neopets.com";
		public static const GAME_PATH:String = "/games/play.phtml?game_id=";
		public static const GAMES_ROOM:String = "/games/arcade.phtml";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _gameID:int = -1;
		public var ADLinkID:String;
		public var neoContentID:int;
		// The game ids are inside the movieclip that is clicked on the main stage
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GameLink():void {
			super();
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
			
			// This class is no longer used in the Despicable Me destination - tracking was 
			// easier to implement using the LandingPage class
			
			// new rollover functionality
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function onRollOver(e:Event):void
		{
			//trace("ROLL");
			this.gotoAndStop("on");
		}
		
		private function onRollOut(e:Event):void
		{
			this.gotoAndStop("off");
		}
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Navigate to page
		
		protected function onClick(ev:MouseEvent) {
			// get server url
			var url:String = Parameters.baseURL;
			if(url == null) url = DEFAULT_BASE_URL;
			// check if we have a game id
			if(_gameID >= 0) url += GAME_PATH + String(_gameID);
			else url += GAMES_ROOM;
			// navigate to page
			var req:URLRequest = new URLRequest(url);
			navigateToURL(req);
			//
			if(ADLinkID != null) broadcast(DestinationView.ADLINK_REQUEST,ADLinkID);
			if(neoContentID > 0) broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,neoContentID);
		}

	}
	
}