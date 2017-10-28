/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase.loadedData
{
	
	/**
	 *	This class stores the data for a given collection.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class CollectionData
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const LOGO_DIRECTORY:String = "/ncmall/collectibles/case/logos/";
		public static const TAB_DIRECTORY:String = "/ncmall/collectibles/case/buttons/";
		public static const SIDEBAR_DIRECTORY:String = "/ncmall/collectibles/case/collections/";
		public static const MIN_ITEMS:int = 6;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _name:String;
		protected var _tabURL:String;
		protected var _logoURL:String;
		protected var _sidebarURL:String;
		protected var _entries:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollectionData(tag:String=null):void{
			name = tag;
			_entries = new Array();
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get entries():Array { return _entries; }
		
		public function get logoURL():String { return _logoURL; }
		
		public function get name():String { return _name; }
		
		public function set name(tag:String) {
			if(_name != tag) {
				_name = tag;
				if(name != null) {
					_tabURL = TAB_DIRECTORY + name;
					_logoURL = LOGO_DIRECTORY + name;
					_sidebarURL = SIDEBAR_DIRECTORY + name + ".png";
				} else {
					_tabURL = TAB_DIRECTORY;
					_logoURL = LOGO_DIRECTORY;
					_sidebarURL = SIDEBAR_DIRECTORY;
				}
			}
		}
		
		public function get sidebarURL():String {
			var rand:int = Math.floor(Math.random()*1000000);
			return _sidebarURL + "?r=" + rand;
		}
		
		public function get startDate():Date {
			if(_entries.length > 0) return _entries[0].releaseDate;
			else return new Date();
		}
		
		public function get tabURL():String { return _tabURL; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function provides default values for offline testing.
		 */
		
		public function useTestValues():void {
			_tabURL = "/ncmall/collectibles/case/buttons/heroes_and_villains";
			_logoURL = "/games/ngc/ngclogo";
			_sidebarURL = "/games/clicktoplay/ctp_1155.gif";
			_entries = new Array();
			// add x item entries
			var entry:Object;
			for(var i:int = 0; i < 6; i++) {
				entry = new ItemData();
				entry.useTestValues();
				entries.push(entry);
			}
			entries.sortOn("releaseDate",Array.NUMERIC);
		}
		
		/**
		 * @This function updates our values for a given user.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function initUser(info:Object):void {
			if(info == null) return;
			if("ncCollectibles" in info) {
				var list:Array = info.ncCollectibles;
				// cycle through the list
				var list_itm:Object;
				var entry:Object;
				var j:int;
				var itm_id:int;
				for(var i:int = 0; i < list.length; i++) {
					list_itm = list[i];
					// check if the entry modifies our item data
					for(j = 0; j < _entries.length; j++) {
						entry = _entries[j];
						itm_id = int(Number(list_itm.objInfoId));
						if(entry.IDNumber == itm_id) entry.initUser(list_itm);
					} // end of entry loop
				} // end of info checking loop
			}
		}
		
		/**
		 * @This function tries to add a new entry to this collection using the given data.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function addEntry(info:Object):void {
			if(info == null) return;
			var entry:ItemData = new ItemData();
			var collectionName:String = info.collectionName;
			//entry.useTestValues();
			entry.initFrom(info, collectionName);
			//if it is not a bonus item...
			if (entry.monthName != "Bonus"){//if (entry.releaseDate){
				// ...add new entries in chronological order
				var target_date:Date = entry.releaseDate;
				var cur_entry:ItemData;
				for(var i:int = 0; i < _entries.length; i++) {
					cur_entry = _entries[i];
					if(cur_entry.releaseDate >= target_date) {
						_entries.splice(i,0,entry);
						return;
					}
				}
			} 
			// ....otherwise, just tack the entry to the end of the list
			_entries.push(entry);
		}
		
		/**
		 * @This function tries to pad the collection by adding extra dummy entries.
		 */
		 
		public function addExtraEntries():void {
			// get last date
			var last_date:Date;
			if(_entries.length > 0) {
				var last_entry:Object = _entries[_entries.length-1];
				last_date = last_entry.releaseDate;
			} else last_date = new Date();
			// pad our entries list
			var year:Number = last_date.fullYear;
			var month:Number = last_date.month;
			var info:Object;
			var last_index:int = MIN_ITEMS - 1;
			for(var i:int = _entries.length; i < MIN_ITEMS; i++) {
				// increment month
				if(month >= 11) {
					month = 0;
					year++;
				} else month++;
				// create new entry
				info = {name:"",objInfoId:0,buyable:false,active:false,objDescription:"",totalCount:0};
				info.month = month + 1; // convert to starting at month 1
				info.year = year % 100; // convert to '## format (ex. 2008 -> '08)
				info.isBonus = (i >= last_index);
				addEntry(info);
			}
		}
		
		/**
		 * @This function tries to retrieve the entry with the target name.
		 * @param		tag		String 		Name of the collection.
		 */
		 
		public function getEntry(tag:String):ItemData {
			var entry:ItemData;
			for(var i:int = 0; i < _entries.length; i++) {
				entry = _entries[i];
				if(entry.itemName == tag) return entry;
			}
			return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}