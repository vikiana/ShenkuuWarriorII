/**
 *  Keeps track of the trophies found tin the collection quest 
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli/ Abraham Lee
 *	@since  09.22.2009
 **/

package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsDatabase;
	
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.events.Event;
	
	public class LADatabase extends AbsDatabase
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public const TROPHY_FOUND:String = "a_trophy_found";
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	@PARAM		pUserName		String		info is pulled in from KidControl class
		 *	@PARAM		pProjectID		String		unique identifier, pulled from LAControl class
		 **/
		public function LADatabase(pUserName:String = "GUEST_USER_ACCOUNT", pProjectID:String = "TYPE14ITEM0000"):void
		{
			super(pUserName, pProjectID)
			
			//TESTING: resets db
			//resetVars();
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------

		/**
		 *	Initialize the database init() will set up the database
		 *	setupObjData is eventually called and populates the database data (property) with initial setup
		 **/
		public function myInit():void
		{
			init();
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//---------------------------------------
		public function updateTrophiesDatabase(trophyName:String):void
		{
			trace (this+"UPDATE TROPHY NAME: ",trophyName);
			switch (trophyName)
			{
				case "t1":
					objData.t1 = "t1";
					NeoTracker.instance.trackNeoContentID(15099);
				break;
				case "t2":
					objData.t2 = "t2";
					NeoTracker.instance.trackNeoContentID(15095);
				break;
				case "t3":
					objData.t3 = "t3";
					NeoTracker.instance.trackNeoContentID(15098);
				break;
				case "t4":
					objData.t4 = "t4";
					NeoTracker.instance.trackNeoContentID(15096);
				break;
				case "t5":
					objData.t5 = "t5";
					NeoTracker.instance.trackNeoContentID(15097);
				break;
			}
			objData.trophyFound = "true";
			setVars();
		}
		
		//call this to reset the trophyFound var on the DB to false
		public function resetTrophyFound ():void {
			objData.trophyFound = "false";
			setVars();
		}
		
		
		public function endQuestSetup():void {
			objData.trophyFound = "finished"
			setVars();
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
}