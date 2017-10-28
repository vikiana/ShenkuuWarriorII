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
	public class PlatformSetData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_PLATFORM_SET:String = "platforms";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _types:Array;
		protected var _spacingData:SpacingGradientData;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PlatformSetData(xml:XML=null):void{
			super();
			// create data structures
			_spacingData = new SpacingGradientData();
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
			_spacingData.clear();
			while(_types.length > 0) _types.pop();
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				// get spacing values
				var node:XML = XMLUtils.getLastChild(xml,SpacingGradientData.XML_TYPE_SPACING);
				if(node != null) _spacingData.initFromXML(node);
				// load types
				var list:XMLList = xml.child(PlaformTypeData.XML_TYPE_PLATFORM_TYPE);
				var type:PlaformTypeData;
				for each(node in list) {
					type = new PlaformTypeData(node);
					_types.push(type);
				}
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_PLATFORM_SET+"/>");
			// show spacing
			var node:XML = _spacingData.toXML();
			xml.appendChild(node);
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
			var altitude:Number = min + Math.round(_spacingData.getRandomSpacing(min));
			// keep cycling until we pass our top altitude
			var type:PlaformTypeData;
			var placement:ImagePlacement;
			while(altitude < max) {
				// determine what kind of platform should go here
				type = getRandomPlatform(altitude);
				// push placement data to list
				if(type != null) {
					placement = new ImagePlacement(type.imageClass,-altitude);
					list.push(placement);
				}
				// move on to next position
				altitude += Math.max(1,Math.round(_spacingData.getRandomSpacing(altitude)));
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
