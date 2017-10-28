/**
 *	AMFPHP: Singleton design pattern
 *	This Allows you to have/keep a single connection with amfphp thoughout the live span of yoru applicaiton
 *
 *	@NOTE: init function must be called first before making calls via connection
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee 
 *	@since  08.12.2009
 **/
 
 
package com.neopets.util.amfphp
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------

	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	

	public class Amfphp extends Sprite{

		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance : Amfphp
		private var mConnection:NetConnection;
		private var mInitialized:Boolean = false;
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	make in instance for singleton
		 **/
		public function Amfphp(pPrivCl : PrivateClass ) 
		{
			trace ("from util")
		}
		
		//----------------------------------------
		//	GETTER AND SETTER
		//----------------------------------------
		
		/**
		 *	singleton instance 
		 **/
		public static function get instance():Amfphp
		{
			if( Amfphp.mReturnedInstance == null ) 
			{
				Amfphp.mReturnedInstance = new Amfphp( new PrivateClass( ) );
			}
			return Amfphp.mReturnedInstance
		}
		
		/**
		 *	get netconnection to make calls
		 **/
		public function get connection():NetConnection
		{
			if (mConnection == null)
			{
				trace ("\nPLEASE CALL Amfphp.intance.init() FIRST TO ESTABLISH A CONNECTION\n")
			}
			return mConnection
		}
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
				
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	create initial connection with amfphp, this should be called before anything else
		 *	@NOTE:	Unless spedified, it will try to make a connection with dev.neopets.com by default
		 * 	@param			pPathwayURL			String			The Pathway should come via FlashVar
		 **/
		public function init(pPathwayURL:String = "http://dev.neopets.com"):void
		{
			if (!mInitialized)
			{
				mInitialized = true
				mConnection = new NetConnection();
				mConnection.objectEncoding = ObjectEncoding.AMF0;
				
				var tURL:String = pPathwayURL + "/amfphp/gateway.php";
				trace("\nUsing this URL for AMFPHP>", tURL, "\n");
				mConnection.connect(tURL);
			}
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

 
