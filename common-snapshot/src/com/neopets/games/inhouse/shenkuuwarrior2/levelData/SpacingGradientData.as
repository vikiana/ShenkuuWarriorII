/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.util.xml.XMLUtils;
	
	/**
	 *	This class handles the platform spacing as it increases over the course of the level.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class SpacingGradientData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_SPACING:String = "spacing";
		public static const XML_ATTRIBUTE_END_AT:String = "end";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var initialRange:RangeData;
		public var finalRange:RangeData;
		public var distance:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SpacingGradientData(xml:XML=null):void{
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
			distance = 1;
			// set up intial range
			if(initialRange != null) initialRange.clear();
			else initialRange = new RangeData();
			// set up final range
			if(finalRange != null) finalRange.clear();
			else finalRange = new RangeData();
		}
		
		// This function return a randomized spacing value for the target altitude.
		
		public function getRandomSpacing(altitude:Number):Number {
			// calculate percentage toward the end of our scale
			var percent:Number = Math.min(Math.max(0,altitude/distance),1);
			var inverse:Number = 1 - percent;
			// calcute range for this altitude
			var min:Number = initialRange.min * inverse + finalRange.min * percent;
			var max:Number = initialRange.max * inverse + finalRange.max * percent;
			// calculate delta
			var diff:Number = max - min;
			// return randomized range
			return min + Math.random() * diff;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				// get initial range
				var node:XML = XMLUtils.getFirstChild(xml,RangeData.XML_TYPE_RANGE);
				if(node != null) initialRange.initFromXML(node);
				// get final range
				node = XMLUtils.getLastChild(xml,RangeData.XML_TYPE_RANGE);
				if(node != null) finalRange.initFromXML(node);
				// get distance
				distance = Number(xml.attribute(XML_ATTRIBUTE_END_AT));
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_SPACING+"/>");
			// show ranges
			var node:XML = initialRange.toXML();
			xml.appendChild(node);
			node = finalRange.toXML();
			xml.appendChild(node);
			// show distance
			xml["@"+XML_ATTRIBUTE_END_AT] = distance;
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
