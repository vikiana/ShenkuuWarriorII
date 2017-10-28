/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class handles numeric ranges from a minimum to a given maximum value.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class RangeData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_RANGE:String = "range";
		public static const XML_ATTRIBUTE_MINIMUM:String = "min";
		public static const XML_ATTRIBUTE_MAXIMUM:String = "max";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var min:Number;
		public var max:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function RangeData(xml:XML=null):void{
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
			min = 0;
			max = 0;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				min = Number(xml.attribute(XML_ATTRIBUTE_MINIMUM));
				max = Number(xml.attribute(XML_ATTRIBUTE_MAXIMUM));
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_RANGE+"/>");
			xml["@"+XML_ATTRIBUTE_MINIMUM] = min;
			xml["@"+XML_ATTRIBUTE_MAXIMUM] = max;
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
