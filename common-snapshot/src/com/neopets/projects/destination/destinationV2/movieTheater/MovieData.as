﻿/**
 *	singleton class/design pattern
 *	This is an amf php componant class to get all the movie central objects (except for feed a pet)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee 
 *	@since  07.01.2009
 **/


package com.neopets.projects.destination.destinationV2.movieTheater
{

	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------

	import com.neopets.util.events.CustomEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.URLRequest;
	

	public class MovieData extends Sprite{

		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ADDRESS_RECEIVED = "self_HTML_address_received"	//used to determine which page to show
		public static const LOBBY_RECEIVED = "lobby_object_received"
		public static const GAMES_RECEIVED = "games_object_received"
		public static const CINEMA_RECEIVED = "cinmea_object_received"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance : MovieData
		private var mConnection:NetConnection;
		private var userLoggedIn:Boolean;
		private var userName:String;
		private var mActiveIcons:Array;
		private var mInitialized:Boolean = false;	//tells rather this class has been initialized or not
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	Make the connection and retrieve user name to confirm it's login status
		 *	If all things go well, when the (child) class is instantiated,
		 *	it will eventualy dispatch "PET_DATA_IN"
		 *	get username (check for login) --> loadData --> getPetURL (users pet data) --> dispatch event
		 **/
		public function MovieData(pPrivCl : PrivateClass ) 
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
		 *	singleton instance 
		 **/
		public static function get instance( ):MovieData
		{
			if( MovieData.mReturnedInstance == null ) 
			{
				MovieData.mReturnedInstance = new MovieData( new PrivateClass( ) );
				//MovieData.mReturnedInstance.init();		//Not a Good Idea
			}
			return MovieData.mReturnedInstance
		}
		
		/**
		 *	Get the url the swf is in
		 **/
		public function getUrl()
		{
		//	var responder = new Responder(returnURLObj, returnError);
		//	mConnection.call("MovieCentral.getUrl", responder)
		}
		
		
		/**
		 *	Get objected needed for lobby (3 poster images, and links)
		 **/
		public function getLobby()
		{
			var responder = new Responder(returnLobbyObj, returnError);
			mConnection.call("MovieCentral.getLobby", responder)
		}
		
		/**
		 *	Get objected needed to build games room
		 **/
		public function getGames()
		{
			var responder = new Responder(returnGamesObj, returnError);
			mConnection.call("MovieCentral.getGames", responder)
		}

		/**
		 *	Get objected needed to build each theater
		 *	@NOTE:	Based on theater's url, it'll return different objects
		 *	@NOTE:	Instead of checking theatre url, we're now using an id property.
		 * @param			pID			String			The id code of the target cinema.
		 **/
		public function getCinema(pID:String) 
		{
			var responder = new Responder(returnCinemaObj, returnError);
			mConnection.call("MovieCentral.getCinema", responder,pID)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	create initial connection with amfphp 
		 * @param			pPathwayURL			String			The Pathway sent to us from PHP using a FlashVar, by default it should always receive dev address
		 **/
		public function init(pPathwayURL:String = null):void
		{
			trace ("Movie data init called")
			if (!mInitialized)
			{
				mInitialized = true
				mActiveIcons = [];
				mConnection = new NetConnection();
				mConnection.objectEncoding = ObjectEncoding.AMF0;
				
				var tURL:String = pPathwayURL + "/amfphp/gateway.php";
				trace("Using this URL for AMFPHP>", tURL);
				mConnection.connect(tURL);			//Live Version
			
			}
		}
		
		/**
		 *	 return url the swf is in
		 **/
		protected function returnURLObj(pObj:Object) 
		{
			trace ("URL")
			for (var i:String in pObj)
			{
				trace (i, pObj[i])
				trace ("==============================")
			}
			MovieData.mReturnedInstance.dispatchEvent(new CustomEvent({DATA:pObj}, ADDRESS_RECEIVED))
		}
		
		/**
		 *	 return lobby obj (has poster urls, image links, etc.)
		 **/
		protected function returnLobbyObj(pObj:Object) 
		{
			trace ("////LOBBY////")
			for (var i:String in pObj)
			{
				trace (i, pObj[i])
				trace ("==============================")
			}
			
			for (var j:String in pObj.images)
			{
				trace (j, pObj.images[j])
				for (var k:String in pObj.images[j])
				{
					trace (k, pObj.images[j][k])
				}
				
				trace ("----------")
			}
			MovieData.mReturnedInstance.dispatchEvent(new CustomEvent({DATA:pObj},LOBBY_RECEIVED))
		}
		
		/**
		 *	 return game obj (has game urls, image links, etc.)
		 **/
		protected function returnGamesObj(pObj:Object) 
		{
			trace ("/////GAMES//////////////")
			for (var i:String in pObj)
			{
				trace (i, pObj[i])
				for (var j in pObj[i])
				{
					trace ("\nwhat is this", j, pObj[i][j])
					for (var k in pObj[i][j])
					{
						trace (k, pObj[i][j][k])
					}
				}
				trace ("==============================")
			}
			MovieData.mReturnedInstance.dispatchEvent(new CustomEvent({DATA:pObj},GAMES_RECEIVED))
		}
		
		
		/**
		 *	 return cinema obj (all the necessary properties to create a theater)
		 **/
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
			
			trace ("what is my icon", mActiveIcons)
			
			trace ("\n//////////////////////////////")
			trace ("	LEFT BANNER")
			trace ("///////////////////////////////\n")
			
			
			for (var k:String in pObj.leftBanner)
			{
				trace (k, pObj.leftBanner[k])
			}
			
			MovieData.mReturnedInstance.dispatchEvent(new CustomEvent({DATA:pObj},CINEMA_RECEIVED) )
		}
		
	
		/**
		 *	 in case error should occur
		 **/
		protected function returnError(f:Object) 
		{
			trace("ERROR from MovieData: " + f.description);
		}
		
		
	}
}

//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} 
