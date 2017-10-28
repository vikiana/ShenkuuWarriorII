/**
 *	YOU MAY IGNORE THIS 
 *
 *	(this portion was for my development purposes)
 *  sUsername.toUpperCase() == "GUEST_USER_ACCOUNT"
 *	objRoot.loaderInfo.parameters;
 *
 * 	EXAMPLE OF WHAT PHP WILL RETURN:
 *
 * 	<message success="1" text="">
 *		<action>RECEIVE_VARS</action>
 * 		<callCount>9</callCount>
 * 		<game_id>TYPE:14ITEM:1581</game_id>
 * 		<username>breeze79</username>
 * 		<queries>2</queries>
 * 		<data>item1=1&item2=0<data/>
 *	</message>
 *
 **/

 
////////////////////////////////////////
//	START HERE
////////////////////////////////////////

/**
 *	DESCRIPTION
 *
 *	-This is a simple version of PersistanceManager (as2.np.manager) written in AS3
 *	-It interacts with Database via php calls
 *	-Mainly it stores "user name", "project ID", callCount and "data"
 *	-user name and project ID is used to locate the table in the database (as unique identifier)
 *	-In essence, you are manipulating URLVariable "data" for all purposes.  
 *	-Uses mDataObj (Object) to create necessary data.  it'll turn the object properties into a string and store it in URLVariable "data"
 *	-ULRVariable "action" determins how it'll affect the database
 *		SEND_VARS		sets data
 *		RECEIVE_VARS 	retrieves data
 *		RESET_VARS		resets data
 *	-Data is a long sting of information (check for URLVarables below) and you can virtually store any info
 *
 *	IMPORTANT 
 *	-for this was only meant to be used within destination thus,
 *	this does not have an ERROR checking system to see if a user is logged in
 *	It automatically assumes one is logged in.
 *	This is largely because previous programmer wrote the php script and return error (when not logged in or improper format is submitted,
 *
 * 
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *
 **/

package com.neopets.projects.destination
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	
	
	public class AbstractDatabase extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		//These consts are set on PHP side so DON'T change ANYTHING 
		public static const TYPE_GAME:int = 4		
		public static const TYPE_OTHER:int = 14	
		protected const ACTION_SEND_DATA:String = "SEND_VARS"
		protected const ACTION_RECEIVE_DATA:String = "RECEIVE_VARS"
		protected const ACTION_RESET_DATA:String = "RESET_VARS"
		protected const DATABASE_URL:String = "http://www.neopets.com/games/process_flash_database.phtml"
		protected const GUEST_USER:String = "GUEST_USER_ACCOUNT"
		
		/**
		 *	NOTE
		 *	To store any data, it must have unique ID (first by user name then by projectID)
		 *	VAR mProjectID example:
		 *
		 *	A) 	FOR GAMES:  	"TYPE:4ITEM:9999"  
		 *  B) 	ALL OTHERS:  	"TYPE:14ITEM:9999"
		 *
		 *	TYPE 4 (see above TYPE_GAME) means it's a game, ITEM is the game id
		 *	TYPE 14 means it's none game (collection quest, etc.) and ITEM is the NEO CONTENT PROJECT ID
		 **/
		
		public const ACTION_CONFIRMED:String = "action has been accomplished"
		
		private var myLoader:URLLoader;
		protected var mUserName:String;
		private var mProjectID:String;
		protected var mDataObj:Object;		//any custom data you want to store in Database
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function AbstractDatabase(pUserName:String = "GUEST_USER_ACCOUNT", pProjectID:String = "TYPE14ITEM0000"):void


		{
			trace (this+" Database created");
			mDataObj = new Object ();
			mUserName = pUserName;
			mProjectID = pProjectID
			init();
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function get objData():Object
		{
			return mDataObj;
		}
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//Receives user's stored data
		public function receiveVars():void
		{
			callScript(ACTION_RECEIVE_DATA)
		}
		
		//reset's user data  this will never be called in general except for testing purposes
		public function resetVars():void
		{
			callScript(ACTION_RESET_DATA)
		}
		
		//send user data
		public function setVars():void
		{
			callScript(ACTION_SEND_DATA)
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//upon starting it receives data. 
		//so its child should always check the object data and set neccessary defult values
		private function init():void
		{
			trace ("database init called")
			callScript(ACTION_RECEIVE_DATA)
		}
		
		/**
		 *	The core function to send and receive data 
		 *	
		 *	@PARAM		pAction 		commend to either receive, reset or set data
		 **/
		private function callScript(pAction:String):void
		{
			var variables:URLVariables = new URLVariables();
			var myRequest:URLRequest = new URLRequest(DATABASE_URL);
			var loader:URLLoader = new URLLoader();

			variables.action = pAction
			variables.callCount = 0
			variables.game_id = mProjectID
			variables.username = mUserName
			variables.data = dataObjToString(mDataObj)
			
			myRequest.method = URLRequestMethod.POST;
			myRequest.data = variables;
 
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, onComplete_Handler, false, 0, true);
			loader.load(myRequest);
		}
		
		
		/**
		 *	Takes the custom made data (ex. collection quest stamps, items, etc.) into string
		 *	@PARAM			dataObj			Object			custom made data
		 **/
		
		private function dataObjToString(dataObj:Object = null):String
		{
			var dataString:String = "";
			if (dataObj != null)
			{
				for (var i:String in dataObj)
				{
					dataString += String (i + "=" + dataObj[i] + "&");
				}
			}
			dataString = dataString.substring(0,dataString.length-1); //trim last '&'
			return dataString;
		}

		
		/**
		 *	Takes stored data string from database and turns into an object with properties
		 *	dataString example:	"Treature=false&Game=false&Movie=true&Webpage=false"
		 *	@PARAM			dataString			Stirng			what is returned form php call
		 **/
		
		private function parseStringToDataObj(dataString:String):Object
		{
			var dataObj = new Object();
			var data_array:Array = dataString.split("&"); //"&amp;" if its not encoded/decoded
			
			for (var i:String in data_array) 
			{
				var dataPair:Array = data_array[i].split("=");
				dataObj[dataPair[0]] = dataPair[1];
			}
			
			return dataObj;
		}

		
		//once dta is retrieved, it'll reassing values to specified data		  
		private function parceXML(xml:XML):void
		{
			var xmlList:XMLList = new XMLList(xml)
			if (xmlList.@success) mDataObj = parseStringToDataObj(xml.data.children().toString());
			//trace ("callCount:", xml.callCount)
			//trace ("data:", xml.data.children().toString())
		}
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
				
		//when callScript function is carried out, it'll return xml and this function will parce the data
		private function onComplete_Handler (evt:Event):void
		{
			evt.target.removeEventListener(Event.COMPLETE, onComplete_Handler)
			var vars:URLVariables = new URLVariables(evt.target.data);
			var myXML = new XML(unescape(evt.target.data))
			parceXML(myXML)
			dispatchEvent(new Event (ACTION_CONFIRMED))
		}
		
	}
	
}