/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class contains instructions for placing a display object.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class ImagePlacement extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var imageClass:String;
		public var y:Number;
		public var z:Number;
		public var height:Number;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ImagePlacement(id:String=null,py:Number=0,pz:Number=0, h:Number=0):void{
			imageClass = id;
			y = py;
			z = pz;
			height = h;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function toString():String { return String(toXML()); }
		
		// This simply stores our data in xml format.
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<image/>");
			xml["@class"] = imageClass;
			xml["@y"] = y;
			xml["@z"] = z;
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
