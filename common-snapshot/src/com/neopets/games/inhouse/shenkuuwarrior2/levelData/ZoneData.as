/* AS3
	Copyright 2010
*/
package  com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class handles basic zone definitions.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class ZoneData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_ZONE:String = "zone";
		public static const XML_ATTRIBUTE_START_AT:String = "start";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var startingAltitude:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ZoneData(xml:XML=null):void{
			super();
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
			startingAltitude = 0;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				startingAltitude = Number(xml.attribute(XML_ATTRIBUTE_START_AT));
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_ZONE+"/>");
			xml["@"+XML_ATTRIBUTE_START_AT] = startingAltitude;
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
