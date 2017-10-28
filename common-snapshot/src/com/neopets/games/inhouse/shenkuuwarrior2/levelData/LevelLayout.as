/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class contains instructions for building a section of the game level.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class LevelLayout extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var groundClass:String;
		public var height:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _backgrounds:Vector.<Vector.<ImagePlacement>>;
		protected var _platforms:Vector.<ImagePlacement>;
		protected var _powerups:Vector.<ImagePlacement>;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LevelLayout():void{
			super();
			_platforms = new Vector.<ImagePlacement>();
			_backgrounds = new Vector.<ImagePlacement>();
			_powerups = new Vector.<ImagePlacement>();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get backgrounds():Vector.<Vector.<ImagePlacement>> { return _backgrounds; }
		
		public function get platforms():Vector.<ImagePlacement> { return _platforms; }
		
		public function get powerups():Vector.<ImagePlacement> { return _powerups; }
		
		public function set backgrounds(value:Vector.<Vector.<ImagePlacement>>):void { _backgrounds = value }
		
		public function set platforms(value:Vector.<ImagePlacement>):void { _platforms = value }
		
		public function set powerups(value:Vector.<ImagePlacement>):void { _powerups = value }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function toString():String { return String(toXML()); }
		
		// This simply stores our data in xml format.
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+LevelData.XML_TYPE_LEVEL+"/>");
			xml["@"+LevelData.XML_ATTRIBUTE_HEIGHT] = height;
			// add backgrounds
			for each(var image:ImagePlacement in _backgrounds) {
				node = image.toXML();
				node.setName("background");
				xml.appendChild(node);
			}
			// set ground property
			var node:XML = new XML("<"+LevelData.XML_TYPE_GROUND+" "+LevelData.XML_ATTRIBUTE_CLASS+"='"+groundClass+"'/>");
			xml.appendChild(node);
			// add platforms
			for each(image in _platforms) {
				node = image.toXML();
				node.setName("platform");
				xml.appendChild(node);
			}
			// add powerups
			for each(image in _powerups) {
				node = image.toXML();
				node.setName("powerup");
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
