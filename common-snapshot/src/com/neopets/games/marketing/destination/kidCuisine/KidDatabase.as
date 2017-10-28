/**
 *	There is a one time popup (instructional message) per each user for collection quest.
 *	This keeps track of it. (whether it's their first time or not)
 *	When the database is first created, a property "objData.firstTimeVisit" does not exist
 *	Which means it's their first time logging in, so it pops up the window.
 *	Once the property is set, it's set to false automatically
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  06.01.2009
 **/

package com.neopets.games.marketing.destination.kidCuisine
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsDatabase;
	import com.neopets.util.events.CustomEvent;
	
	public class KidDatabase extends AbsDatabase
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
					
		private var mFirstTimeVisit:String = "false" 
		private var mFirstTimeMain:String = "false"
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	@PARAM		pUserName		String		info is pulled in from KidControl class
		 *	@PARAM		pProjectID		String		unique identifier, pulled from KidControl class
		 **/
		public function KidDatabase(pUserName:String = "GUEST_USER_ACCOUNT", pProjectID:String = "TYPE14ITEM0000"):void
		{
			super(pUserName, pProjectID)
			addEventListener(ACTION_CONFIRMED, setupObjData)
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function get firstTime(): String
		{
			return objData.firstTimeVisit		
		}
		
		public function get firstTimeMain():String
		{
			return objData.firstTimeMain
		}
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------

		/**
		 *	Initialize the database init() will set up the database
		 *	setupObjData is eventually called and populates the database data (property) with initial setup
		 **/
		public function myInit():void
		{
			init()
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		

		//when user status is changed, updtate the database as well
		public function updateDatabase():void
		{
			if (mUserName != GUEST_USER) 
			{
				objData.firstTimeVisit = mFirstTimeVisit
				setVars();
			}
			else 
			{
				trace ("USER NOT LOGGEDIN: databse update avoided")
			}
		}
		
		public function updateDatabaseMain():void
		{
			if (mUserName != GUEST_USER) 
			{
				objData.firstTimeMain = mFirstTimeMain
				setVars();
			}
			else 
			{
				trace ("USER NOT LOGGEDIN: databse update avoided")
			}
		}
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	For initial set up, if the objData is empty, 
		 *	it creates the appropriate properties and corresponding values
		 **/
		private function setupObjData(evt:Event):void
		{
			removeEventListener(ACTION_CONFIRMED, setupObjData)
			if (objData.firstTimeMain == undefined) objData.firstTimeMain = "true";
			if (objData.firstTimeVisit == undefined) objData.firstTimeVisit = "true";
			
			setVars();
		}
	}
}