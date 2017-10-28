/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.util.xml.XMLUtils;
	
	/**
	 *	This class handles the data used to generate platforms in a level.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class PlaformTypeData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_PLATFORM_TYPE:String = "type";
		public static const XML_ATTRIBUTE_CLASS:String = "class";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var imageClass:String;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _zones:ZoneStack;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PlaformTypeData(xml:XML=null):void{
			super();
			_zones = new ZoneStack();
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
			imageClass = "";
			_zones.clear();
		}
		
		// This function finds this platform's chances of occuring at a given altitude.
		
		public function getOddsAt(altitude:Number):Number {
			// figure out what zone the target is in
			var zone:ChanceZoneData = _zones.getZoneAt(altitude) as ChanceZoneData;
			if(zone != null) return zone.weight;
			return 1;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				imageClass = xml.attribute(XML_ATTRIBUTE_CLASS);
				// load zones
				var list:XMLList = xml.child(ZoneData.XML_TYPE_ZONE);
				var zone:ChanceZoneData;
				for each(var node:XML in list) {
					zone = new ChanceZoneData(node);
					_zones.addZone(zone);
				}
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_PLATFORM_TYPE+"/>");
			xml["@"+XML_ATTRIBUTE_CLASS] = imageClass;
			// show zones
			var node:XML;
			if(_zones != null) {
				for each(var zone:ChanceZoneData in _zones.zoneList) {
					node = zone.toXML();
					xml.appendChild(node);
				}
			}
			// return completed xml
			return xml;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
