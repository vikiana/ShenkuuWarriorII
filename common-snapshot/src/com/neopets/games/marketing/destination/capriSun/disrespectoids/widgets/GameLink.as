/**
 *	This class handles links to games in our game's room.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.15.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
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
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
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
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GameLink():void {
			super();
			// set up broadcasts
			useParentDispatcher(AbsPage);
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
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
			// call tracking
			if(ADLinkID != null) broadcast(DestinationView.ADLINK_REQUEST,ADLinkID);
			if(neoContentID > 0) broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,neoContentID);
		}

	}
	
}