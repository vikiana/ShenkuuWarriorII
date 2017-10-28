/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class simply contains the raw data used to create new levels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class BackgroundPanelData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_PANEL:String = "panel";
		public static const XML_ATTRIBUTE_CLASS:String = "class";
		public static const XML_ATTRIBUTE_HEIGHT:String = "height";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var imageClass:String;
		public var imageHeight:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BackgroundPanelData(xml:XML=null):void{
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
			imageClass = "";
			imageHeight = 1;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				imageClass = xml.attribute(XML_ATTRIBUTE_CLASS);
				imageHeight = Number(xml.attribute(XML_ATTRIBUTE_HEIGHT));
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_PANEL+"/>");
			xml["@"+XML_ATTRIBUTE_CLASS] = imageClass;
			xml["@"+XML_ATTRIBUTE_HEIGHT] = imageHeight;
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
