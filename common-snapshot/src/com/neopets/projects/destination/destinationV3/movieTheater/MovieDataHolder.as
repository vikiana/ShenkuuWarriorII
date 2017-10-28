/**
 *	singleton class/design pattern
 *	This is an amf php componant class to get all the movie central objects (except for feed a pet)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee 
 *	@since  07.01.2009
 **/


package com.neopets.projects.destination.destinationV3.movieTheater
{

	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------

	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	

	public class MovieDataHolder extends EventDispatcher{

		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const DATA_READY: String  = "static_movie_data_is_ready"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance : MovieDataHolder
		private var mDataObj:Object//object that'll hold all the movie data objects
		private var mLobbyReady:Boolean = false //set to true once lobby obj is received via amfphp
		private var mGamesReady:Boolean = false //set to true once lobby obj is received via amfphp
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	Make the connection and retrieve user name to confirm it's login status
		 *	If all things go well, when the (child) class is instantiated,
		 *	it will eventualy dispatch "PET_DATA_IN"
		 *	get username (check for login) --> loadData --> getPetURL (users pet data) --> dispatch event
		 **/
		public function MovieDataHolder(pPrivCl : PrivateClass ) 
		{
			
		}
		
		//----------------------------------------
		//	GETTER AND SETTER
		//----------------------------------------
	
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	singleton instance 
		 **/
		public static function get instance( ):MovieDataHolder
		{
			if( MovieDataHolder.mReturnedInstance == null ) 
			{
				MovieDataHolder.mReturnedInstance = new MovieDataHolder( new PrivateClass( ) );
			}
			
			return MovieDataHolder.mReturnedInstance
		}

		
		/**
		 *	This should be called first.  It basically retrieves ampphp data and does initial set up
		 * @param			pPathwayURL			String			The Pathway sent to us from PHP using a FlashVar
		 **/
		public function init(pPathwayURL:String = null):void
		{
			mDataObj = new Object ();
			MovieData.instance.init(pPathwayURL)
			MovieData.instance.addEventListener(MovieData.LOBBY_RECEIVED, onLobbyReady, false, 0, true);
			MovieData.instance.addEventListener(MovieData.GAMES_RECEIVED, onGamesReady, false, 0, true);
			MovieData.instance.getGames();
			MovieData.instance.getLobby();
		}
		
		
		/**
		 *	return lobby obj if it's there. otherwise return lobby obj but it'll be set to null
		 **/
		public function getLobby ():Object
		{
			if (!mDataObj.hasOwnProperty("lobby"))
			{
				trace ("mDataObj.lobby is empty")
				mDataObj.lobby = null
			}
			return mDataObj.lobby
		}
		
		/**
		 *	return lobby obj if it's there. otherwise return lobby obj but it'll be set to null
		 **/
		public function getGames ():Object
		{
			if (!mDataObj.hasOwnProperty("games"))
			{
				trace ("mDataObj.games is empty")
				mDataObj.games= null
			}
			return mDataObj.games
		}
		
		
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
				
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function checkDataHolder():void
		{
			if (mLobbyReady && mGamesReady)
			{
				MovieDataHolder.mReturnedInstance.dispatchEvent( new Event (MovieDataHolder.DATA_READY))
			}
		}
		

		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	set the lobby obj.  Then check if all static data is set
		 **/
		private function onLobbyReady(evt:CustomEvent):void
		{
			MovieData.instance.removeEventListener(MovieData.LOBBY_RECEIVED, onLobbyReady);
			mDataObj.lobby = evt.oData.DATA
			mLobbyReady = true
			checkDataHolder()
		}
		
		/**
		 *	set the games obj.  Then check if all static data is set
		 **/
		private function onGamesReady(evt:CustomEvent):void
		{
			MovieData.instance.removeEventListener(MovieData.GAMES_RECEIVED, onGamesReady);
			mDataObj.games = evt.oData.DATA
			mGamesReady = true
			checkDataHolder()
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
