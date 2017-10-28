/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	
	/**
	 *	This class attachs background panel data to a zone.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class BackgroundZoneData extends ZoneData 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		//public var panelData:BackgroundPanelData;
		
		public var panelData:Vector.<BackgroundPanelData>;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BackgroundZoneData(xml:XML=null):void{
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
			// set up panel data
			if(panelData != null){
				for each (var i:BackgroundPanelData in panelData){
					i.clear();
				}
				panelData = null;
			}
			else panelData = new Vector.<BackgroundPanelData>();
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		override public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				startingAltitude = Number(xml.attribute(XML_ATTRIBUTE_START_AT));
				
				// use last panel definition
				//var list:XMLList = xml.child(BackgroundPanelData.XML_TYPE_PANEL);
				//var list_size:int = list.length();
				
				//use all panel definitions available
				var list:XMLList = xml.child(BackgroundPanelData.XML_TYPE_PANEL);
				var list_size:int = list.length();
				if(list_size > 0) {
					var node:XML;
					for (var i:int = 0; i< list_size; i++){
						node = list[i];
						panelData.push (new BackgroundPanelData(node));
					}
				}
			}
		}
		
		override public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_ZONE+"/>");
			xml["@"+XML_ATTRIBUTE_START_AT] = startingAltitude;
			//add panel data
			var node:XML;
			for (var i:int = 0; i< panelData.length; i++){
				node = panelData[i].toXML();
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
