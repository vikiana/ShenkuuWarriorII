/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class attachs odds to a zone.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class ChanceZoneData extends ZoneData 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_ATTRIBUTE_ODDS:String = "weight";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var weight:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ChanceZoneData(xml:XML=null):void{
			super(xml);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function reset our properies to their initial, cleared values.
		
		override public function clear():void {
			startingAltitude = 0;
			weight = 1;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		override public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				startingAltitude = Number(xml.attribute(XML_ATTRIBUTE_START_AT));
				weight = Number(xml.attribute(XML_ATTRIBUTE_ODDS));
			}
		}
		
		override public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_ZONE+"/>");
			xml["@"+XML_ATTRIBUTE_START_AT] = startingAltitude;
			xml["@"+XML_ATTRIBUTE_ODDS] = weight;
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
