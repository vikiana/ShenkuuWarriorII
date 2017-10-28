/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.util.array.ArrayUtils;
	import com.neopets.util.xml.XMLUtils;
	
	/**
	 *	This class simply contains the raw data used to create new levels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class LevelData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_LEVEL:String = "level";
		public static const XML_TYPE_GROUND:String = "ground";
		public static const XML_ATTRIBUTE_CLASS:String = "class";
		public static const XML_ATTRIBUTE_HEIGHT:String = "height";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var groundClass:String;
		public var height:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _background:BackgroundData;
		protected var _platforms:PlatformSetData;
		protected var _powerups:PowerupsSetData;
		

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LevelData(xml:XML=null):void{
			super();
			// create data structures
			_background = new BackgroundData();
			_powerups = new PowerupsSetData();
			_platforms = new PlatformSetData();
			// initialize data
			initFromXML(xml);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get background():BackgroundData { return _background; }
		
		public function get powerups():PowerupsSetData { return _powerups; }
		
		public function get platforms():PlatformSetData { return _platforms; }


		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function reset our properies to their initial, cleared values.
		
		public function clear():void {
			_background.clear();
			_platforms.clear();
			_powerups.clear();
		}
		
		// This function tries to generate a blue print for the level over a given range of altitudes.
		// The min and max parameters refer to the minimum and maximum altitudes covered by the blue print.
		
		public function generateLayout(min:Number=0,max:Number=0):LevelLayout {
			var layout:LevelLayout = new LevelLayout();
			// set up default range if needed
			if(max <= min) max = height;
			layout.height = max - min;
			// set up backgrounds
			layout.backgrounds = _background.generateLayout(min,max);
			// set ground type
			//layout.groundClass = groundClass;
			// populate level with platforms
			layout.platforms = _platforms.generateLayout(min,max);
			// populate level with powerups
			layout.powerups = _powerups.generateLayout(min,max);
			return layout;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				// set up background
				_background.initFromXML(xml[BackgroundData.XML_TYPE_BACKGROUND]);
				// extract ground type
				var node:XML = XMLUtils.getLastChild(xml,XML_TYPE_GROUND);
				if(node != null) groundClass = node.attribute(XML_ATTRIBUTE_CLASS);
				// extract level height
				if("@"+XML_ATTRIBUTE_HEIGHT in xml) height = Number(xml.attribute(XML_ATTRIBUTE_HEIGHT));
				// set up platforms
				node = XMLUtils.getLastChild(xml,PlatformSetData.XML_TYPE_PLATFORM_SET);
				_platforms.initFromXML(node);
				// set up powerups
				node = XMLUtils.getLastChild(xml,PowerupsSetData.XML_TYPE_POWERUPS_SET);
				_powerups.initFromXML(node);
			}
		}
		
		// This simply stores our data in xml format.
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_LEVEL+"/>");
			xml["@"+XML_ATTRIBUTE_HEIGHT] = height;
			// add backgrounds
			var node:XML;
			if(_background != null){
				node = _background.toXML();
				xml.appendChild(node);
			}
			// set ground property
			node = new XML("<"+XML_TYPE_GROUND+" "+XML_ATTRIBUTE_CLASS+"='"+groundClass+"'/>");
			xml.appendChild(node);
			// add platforms
			if(_platforms != null){
				node = _platforms.toXML();
				xml.appendChild(node);
			}
			// add platforms
			if(_powerups != null){
				node = _powerups.toXML();
				xml.appendChild(node);
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
