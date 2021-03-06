﻿/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.util.xml.XMLUtils;
	
	/**
	 *	This class handles the data used to generate powerups in a level.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class PowerupsSetData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_POWERUPS_SET:String = "powerups";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _zones:ZoneStack;
		protected var _types:Array;
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PowerupsSetData(xml:XML=null):void{
			super();
			// create data structures
			_zones = new ZoneStack();
			_types = new Array();
			// initialize data
			initFromXML(xml);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function reset our properies to their initial, cleared values.
		
		public function clear():void {
			_zones.clear();
			while(_types.length > 0) _types.pop();
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				// get spacing values
				var list:XMLList = xml.child(ZoneData.XML_TYPE_ZONE);
				var node:XML;
				var zone:SpacingZoneData;
				for each(node in list) {
					zone = new SpacingZoneData(node);
					_zones.addZone(zone);
				}
				// load types
				list = xml.child(PlaformTypeData.XML_TYPE_PLATFORM_TYPE);
				var type:PlaformTypeData;
				for each(node in list) {
					type = new PlaformTypeData(node);
					_types.push(type);
				}
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_POWERUPS_SET+"/>");
			// show spacing
			var node:XML;
			if(_zones != null) {
				for each(var zone:SpacingZoneData in _zones) {
					node = zone.toXML();
					xml.appendChild(node);
				}
			}
			// show platform types
			if(_types != null) {
				for each(var type:PlaformTypeData in _types) {
					node = type.toXML();
					xml.appendChild(node);
				}
			}
			// return completed xml
			return xml;
		}
		
		/* Level Creation Functions */
		
		// This funcion returns a random list of platform placements over the target altitude range.
		
		public function generateLayout(min:Number,max:Number):Vector.<ImagePlacement> {
			var list:Vector.<ImagePlacement> = new Vector.<ImagePlacement>();
			var altitude:Number = min;
			// keep going until we hit the provided limit
			var zone:SpacingZoneData;
			var cluster:Array;
			var type:PlaformTypeData;
			var placement:ImagePlacement;
			var i:int;
			var pos:Number;
			while(altitude < max) {
				// find current zone
				zone = _zones.getZoneAt(altitude,true) as SpacingZoneData;
				// get a set of item position offsets
				cluster = zone.getRandomCluster();
				//trace("@@@"+cluster);
				// place an item at each of these positions
				for(i = 0; i < cluster.length; i++) {
					type = getRandomPlatform(altitude);
					// push placement data to list
					if(type != null) {
						pos = altitude + cluster[i];
						placement = new ImagePlacement(type.imageClass,-pos);
						list.push(placement);
					}
				}
				// shift altitude to next position
				if(cluster.length > 0) {
					cluster.sort(Array.DESCENDING);
					altitude += cluster[0];
				} else altitude += 100;
			}
			return list;
		}
		
		// This function randomly selects the proper platform for a given altitude based on it's type data.
		
		public function getRandomPlatform(altitude:Number):PlaformTypeData {
			if(_types == null || _types.length < 1) return null;
			// get the total weight for all our types at this altitude
			var total:Number = 0;
			for each(var type:PlaformTypeData in _types) {
				total += type.getOddsAt(altitude);
			}
			// random select a type
			var distance:Number = Math.random() * total;
			for each(type in _types) {
				distance -= type.getOddsAt(altitude);
				if(distance <= 0) return type;
			}
			return _types[_types.length - 1]; // if random value goes to far, use last entry
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
