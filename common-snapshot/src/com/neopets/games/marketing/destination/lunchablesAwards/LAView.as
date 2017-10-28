/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.lunchablesAwards
{

	
	import com.neopets.projects.destination.destinationV2.AbsView;
	
	import flash.events.Event;
	import flash.net.NetConnection;
	
	
	
	/**
	 *	Main View Class for Golden Luncheables Awards Destination.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  09.11.2009
	 */
	public class LAView extends  AbsView
	{
	
		
		public static const NEOCONTENT_ID:int = 1651;
		
		
		private var mControl:LAControl;
		//private var mUserName:String;
		private var mConnection:NetConnection;
		private var mDatabase:LADatabase;
		
		/**
		* 
		* Constructor
		*  
		*/
		public function LAView()
		{
			super();
			trace (this+": created");
			//
			mControl = new LAControl (this);
			//
			addEventListener(USER_NAME_SET, onUserName);
			init (mControl);
		}
		
		//----------------------------------------------------------------------------
		// PUBLIC AND PROTECTED METHODS
		// ---------------------------------------------------------------------------
		
		//----------------------------------------------------------------------------
		// PRIVATE METHODS
		//----------------------------------------------------------------------------
		/**
		 *	create data base to keep track of trophies found
		 **/
		private function activateDatabase():void
		{
			if (mUserName != "GUEST_USER_ACCOUNT")
			{
				trace ("\n/////////////////////\nplease database kick in\n/////////////")
				trace (mUserName)
				mDatabase = new LADatabase (mUserName, "TYPE14ITEM1651")
				mDatabase.myInit();
			}
		}
		
		/**
		 *	update the database
		 **/
		
		public function updateDatabaseWithTrophy(tName:String):void {
			if (tName && mDatabase){
			trace (this+" - Updating Database with found trophy"+tName);
				mDatabase.updateTrophiesDatabase(tName);	
			}
		}
		
		
		
		
		//----------------------------------------------------------------------------
		// HANDLERS
		//----------------------------------------------------------------------------
		
		private function onUserName(e:Event):void{
			//tells control to load library
			removeEventListener (USER_NAME_SET, onUserName);
			mControl.addEventListener("lib_loaded", onLibLoaded);
			mControl.loadLibrary();
			
		}
		
		private function onLibLoaded (e:Event):void {
			mControl.removeEventListener("lib_loaded", onLibLoaded);
			trace (this+": Library loaded");
			readyForSetup();
			activateDatabase()
		}
			
		//----------------------------------------------------------------------------
		// GETTERS
		//----------------------------------------------------------------------------
	
		public function get control():LAControl{
		 	return mControl;
		}
		
	}
}