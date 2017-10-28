/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class adds some extra functionality to a ZoneData based arrays.
	 *  Key functions include the ability to get which zone applies at a given altitude.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class ZoneStack extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _zoneList:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ZoneStack():void{
			super();
			_zoneList = new Array();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get zoneList():Array { return _zoneList; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function adds new zones to the list and ensures zones are kept in ascending order.
		
		public function addZone(zone:ZoneData):void {
			if(_zoneList == null) return;
			if(_zoneList.indexOf(zone) < 0) {
				_zoneList.push(zone);
				_zoneList.sortOn("startingAltitude");
			}
		}
		
		// This function reset our properies to their initial, cleared values.
		
		public function clear():void {
			if(_zoneList != null) {
				while(_zoneList.length > 0) _zoneList.pop();
			} else _zoneList = new Array();
		}
		
		// This function determines which zone applies at a given altitude.
		// The "extend_bottom" paramter lets you cover extremely low altitudes by using
		// the lowest of our zones.
		
		public function getZoneAt(altitude:Number,extend_bottom:Boolean=false):ZoneData {
			if(_zoneList == null || _zoneList.length < 1) return null;
			// work back from the end of the list until we reach a zone that starts
			// below the target altitude.
			_zoneList.sortOn("startingAltitude"); // make sure zones are in ascending order
			var zone:ZoneData;
			for(var i:int = _zoneList.length - 1; i >= 0; i--) {
				zone = _zoneList[i];
				if(zone.startingAltitude <= altitude) return zone;
			}
			// if we got this far, we've gone below our lowest zone
			if(extend_bottom) return _zoneList[0];
			else return null;
		}
		
		// This is just a basic string conversion function.
		
		public function toString():String {
			if(_zoneList != null) return _zoneList.toString();
			else return "-";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
