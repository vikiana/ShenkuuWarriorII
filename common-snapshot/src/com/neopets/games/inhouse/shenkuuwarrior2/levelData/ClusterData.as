/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class handles a set of power up placed in close proximity to each other.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class ClusterData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_CLUSTER:String = "combo";
		public static const XML_ATTRIBUTE_MAX_ITEMS:String = "limit";
		public static const XML_ATTRIBUTE_MAX_SPREAD:String = "spread";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var maxItems:int = 1;
		public var maxSpread:Number = 0;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ClusterData(xml:XML=null):void{
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
			maxItems = 1;
			maxSpread = 0;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				maxItems = Number(xml.attribute(XML_ATTRIBUTE_MAX_ITEMS));
				maxSpread = Number(xml.attribute(XML_ATTRIBUTE_MAX_SPREAD));
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_CLUSTER+"/>");
			xml["@"+XML_ATTRIBUTE_MAX_ITEMS] = maxItems;
			xml["@"+XML_ATTRIBUTE_MAX_SPREAD] = maxSpread;
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
