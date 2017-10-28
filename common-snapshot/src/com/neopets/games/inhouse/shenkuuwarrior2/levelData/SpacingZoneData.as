/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.util.xml.XMLUtils;
	
	/**
	 *	This class attachs handles zones that generate random spacing values.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class SpacingZoneData extends ZoneData 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var range:RangeData;
		public var clustering:ClusterData;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SpacingZoneData(xml:XML=null):void{
			range = new RangeData();
			clustering = new ClusterData();
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
			range.clear();
		}
		
		// This function returns a set of positions using this zone's clustering data.
		
		public function getRandomCluster():Array {
			var cluster:Array = new Array();
			var base_pos:Number = getRandomSpacing();
			// get items in cluster
			var num_items:int;
			if(clustering.maxItems > 1) num_items = 1 + Math.floor(Math.random() * clustering.maxItems);
			else num_items = 1;
			// populate cluster
			var item_pos:Number;
			if(num_items > 1) {
				for(var i:int = 0; i < num_items; i++) {
					item_pos = base_pos + Math.random() * clustering.maxSpread;
					cluster.push(item_pos);
				}
			} else cluster.push(base_pos);
			return cluster;
		}
		
		// This function return a randomized spacing value for the target altitude.
		
		public function getRandomSpacing():Number {
			// calculate delta
			var diff:Number = range.max - range.min;
			// return randomized range
			return range.min + Math.random() * diff;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		override public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				startingAltitude = Number(xml.attribute(XML_ATTRIBUTE_START_AT));
				// extract spacing range for this zone
				var node:XML = XMLUtils.getFirstChild(xml,RangeData.XML_TYPE_RANGE);
				if(node != null) range.initFromXML(node);
				// extract clustering for this zone
				node = XMLUtils.getFirstChild(xml,ClusterData.XML_TYPE_CLUSTER);
				if(node != null) clustering.initFromXML(node);
			}
		}
		
		override public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_ZONE+"/>");
			xml["@"+XML_ATTRIBUTE_START_AT] = startingAltitude;
			// show range
			var node:XML = range.toXML();
			xml.appendChild(node);
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
