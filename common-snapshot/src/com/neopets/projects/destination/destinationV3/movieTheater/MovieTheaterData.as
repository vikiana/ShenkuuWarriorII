/**
 *
 *	
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee 
 *	@since  07.26.2009
 **/


package com.neopets.projects.destination.destinationV3.movieTheater{

	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------

	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	

	public class MovieTheaterData extends Sprite{

		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public const LOBBY_RECEIVED = "lobby_object_received"
		public const GAMES_RECEIVED = "games_object_received"
		public const CINEMA_RECEIVED = "cinmea_object_received"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mConnection:NetConnection;
		private var userLoggedIn:Boolean;
		private var userName:String;
		private var mActiveIcons:Array
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	Make the connection and retrieve user name to confirm it's login status
		 *	If all things go well, when the (child) class is instantiated,
		 *	it will eventualy dispatch "PET_DATA_IN"
		 *	get username (check for login) --> loadData --> getPetURL (users pet data) --> dispatch event
		 **/
		public function MovieTheaterData() 
		{
		}
		
		//----------------------------------------
		//	GETTER AND SETTER
		//----------------------------------------
		public function get activeIcons(): Array
		{
			return mActiveIcons
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	Get objected needed for lobby (3 poster images, and links)
		 **/
		public function getLobby()
		{
			var responder = new Responder(returnLobbyObj, returnError);
		}
		
		/**
		 *	Get objected needed to build games room
		 **/
		public function getGames()
		{
			var responder = new Responder(returnGamesObj, returnError);
		}

		/**
		 *	Get objected needed to build each theater
		 *	@NOTE:	Based on theater's url, it'll return different objects
		 **/
		public function getCinema() 
		{
			trace ("get cinema")
			var responder = new Responder(returnCinemaObj, returnError);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		public function init():void
		{
			mActiveIcons = [];
			mConnection = new NetConnection();
			mConnection.objectEncoding = ObjectEncoding.AMF0;
			//mConnection.connect("/amfphp/gateway.php");
			mConnection.connect("http://dev.neopets.com/amfphp/gateway.php");
			trace ("init movie theater data")
		}
		
		
		protected function returnLobbyObj(pObj:Object) 
		{
			dispatchEvent(new CustomEvent({DATA:pObj},LOBBY_RECEIVED))
		}
		
		protected function returnGamesObj(pObj:Object) 
		{
			dispatchEvent(new CustomEvent({DATA:pObj},GAMES_RECEIVED))
		}
		
		
		
		protected function returnCinemaObj(pObj:Object) 
		{
			for (var i:String in pObj)
			{
				trace (i, pObj[i])
				trace ("==============================")
			}
			
			
			trace ("\n//////////////////////////////")
			trace ("	SCREENINGS")
			trace ("///////////////////////////////\n")
			for (var sc:String in pObj.screenings)
			{
				trace (sc, pObj.screenings[sc])
				for (var sub:String in pObj.screenings[sc])
				{
					trace (sub, pObj.screenings[sc][sub]);
				}
			}
			
			trace ("\n//////////////////////////////")
			trace ("	movie")
			trace ("///////////////////////////////\n")
			for (var mv:String in pObj.movie)
			{
				trace (mv, pObj.movie[mv])
			}
			
			trace ("\n//////////////////////////////")
			trace ("	NAVIGATION")
			trace ("///////////////////////////////\n")
			for (var j:String in pObj.nav)
			{
				trace (j, pObj.nav[j], pObj.nav[j].active)
				if (pObj.nav[j].active) mActiveIcons[mActiveIcons.length] = pObj.nav[j];
				mActiveIcons[mActiveIcons.length] = pObj.nav[j];
				for (var l:String in pObj.nav[j])
				{
					trace (l, pObj.nav[j][l])
				}
				trace ("------------------------------")
			}
			
			
			trace ("\n//////////////////////////////")
			trace ("	LEFT BANNER")
			trace ("///////////////////////////////\n")
			
			
			for (var k:String in pObj.leftBanner)
			{
				trace (k, pObj.leftBanner[k])
			}
			trace ("dispatch cinema received")
			dispatchEvent(new CustomEvent({DATA:pObj},CINEMA_RECEIVED) )
		}
		
	
		protected function returnError(f:Object) 
		{
			trace("ERROR: " + f.description);
		}
		
		
	}
}