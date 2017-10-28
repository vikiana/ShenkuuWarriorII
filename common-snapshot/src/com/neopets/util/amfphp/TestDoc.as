/**
 *	This is a test/example file to start Amfphp class.
 *	To test it, simply make an as3 fla file and make this as its document class and run it.
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
	import flash.net.Responder;
	import flash.display.LoaderInfo;
	
	public class TestDoc extends Sprite{

		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	make an instance for singleton
		 **/
		public function TestDoc() 
		{	
			var baseURL:String = "http://dev.neopets.com"
			
			//this is to get flashvar(baseURL)
			try {
				var paramObj:Object = LoaderInfo(this.stage.root.loaderInfo).parameters;
				//"baseurl" is arbitrary flashvar property.  Set it to whatever php person calls it.
				if (paramObj["baseurl"] != undefined || paramObj["baseurl"] != null)
				{
					 baseURL = paramObj["baseurl"]	
				}
			} catch (error:Error) {
				trace(error.toString());
			}
			
			Amfphp.instance.init(baseURL)  // Where to connect to
			// like an event listener params (true|false)
			var responder = new Responder(returnLobbyObject, returnError);	//make an appropriate responder 
			Amfphp.instance.connection.call("MovieCentral.getLobby", responder)	//make a call to php method
		}
		
		/**
		 *	if amfphp call is sucessfull
		 **/
		private function returnLobbyObject(obj:Object):void
		{
			trace ("Lobby obj of MovieCentral received:")
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i])
			}
		}
		
		/**
		 *	if amfphp call has failed
		 **/
		private function returnError(obj:Object):void
		{
			trace ("Error occured in receiving amfphp data:")
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i])
			}
		}
		
	}
}

