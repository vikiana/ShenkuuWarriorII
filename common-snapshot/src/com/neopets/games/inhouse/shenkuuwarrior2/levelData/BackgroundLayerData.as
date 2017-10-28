/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	
	/**
	 *	This class holds the data used to build each layer of the background.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class BackgroundLayerData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_LAYER:String = "layer";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//-------------------------------------
		protected var _ground:BackgroundPanelData;
		protected var _top:BackgroundPanelData;
		protected var _zones:ZoneStack;
		protected var _height:Number = 0;
		//flags
		private var _bgLayerCount:int = 1;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BackgroundLayerData(xml:XML=null):void{
			super();
			_zones = new ZoneStack();
			initFromXML(xml);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		//
		public function get backLayerPanelHeight ():Number { return _height;};
		
		public function get groundPanelHeight ():Number {
			if (_ground){
				return _ground.imageHeight;
			} else {
				return 0;
			}
		}
		
		public function set bgLayerCount (value:int):void {
			_bgLayerCount = value;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function reset our properies to their initial, cleared values.
		
		public function clear():void {
			_zones.clear();
		}
		
		// This function unpackages our data into a list of image placements for the target alitude range.
		// The layer_index parameter lets you set the z value of all resulting image placements.
		
		public function generateLayout(min:Number,max:Number,layer_index:int=0):Vector.<ImagePlacement>{
			// step throught the altitude range until we go past the maximum
			var list:Vector.<ImagePlacement> = new Vector.<ImagePlacement>();
			var altitude:Number = min;
			var zone:BackgroundZoneData;
			var panel:BackgroundPanelData;
			var image:ImagePlacement;
			var top:ImagePlacement;
			//GROUND PANEL
			//trace (this, _bgLayerCount);
			if (_ground && _bgLayerCount<=1 ){
				//trace ("ground bkg");
				image = new ImagePlacement(_ground.imageClass,-altitude,layer_index, _ground.imageHeight)
				altitude += _ground.imageHeight;
				list.push(image);
			}
		
			if (_top){
				//adjust the range to include the top
				max -= _top.imageHeight;
			}
			
			var iClass:String;
			while(altitude < max) {
				// find the next panel
				zone = _zones.getZoneAt(altitude,true) as BackgroundZoneData;
				if(zone != null) {
					panel = getPanelData (zone);
					if(panel != null) {
						altitude += panel.imageHeight;
						//if it's the  bg layer
						if (_height>0){
							iClass = panel.imageClass+_bgLayerCount;
						} else {
							iClass = panel.imageClass;
						}
						image = new ImagePlacement(iClass,-altitude,layer_index, panel.imageHeight);
						list.push(image);
					} else break;
				} else break;
			}
				
			
			//TOP PANEL
			if (_top){
				altitude += _top.imageHeight;
				top = new ImagePlacement(_top.imageClass,-altitude,layer_index, _top.imageHeight);
				list.push(top);
			}
			//debug///////////////////////////////////////////
			//for (var i:int=0; i<list.length; i++){
			//	trace ( ImagePlacement(list[i]).imageClass)
			//}
			////////////////////////////////////////////////////////
			return list;
		}
		

		
		//randomly chooses between all available panels in a set zone
		protected function getPanelData (zone:BackgroundZoneData):BackgroundPanelData {
		 	var i:Number = Mathematic.randRange(0, zone.panelData.length-1);
			return zone.panelData[i];
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(xml:XML):void {
			clear();
			if(xml != null) {
				var list:XMLList = xml.child(ZoneData.XML_TYPE_ZONE);
				var zone:BackgroundZoneData;
				for each(var node:XML in list) {
					zone = new BackgroundZoneData(node);
					_zones.addZone(zone);
				}
			}
			

			if (xml.hasOwnProperty("ground")){
			_ground = new BackgroundPanelData (new XML(xml.ground));
			}
			if (xml.hasOwnProperty("top")){
			_top = new BackgroundPanelData (new XML(xml.top));
			}
	
			//this is used on the last layer to calculate the parallax multipliers
			if (Number (xml.attribute("height"))){
				_height = Number (xml.attribute("height"));
			}
		}
		
		
		//TODO fix this to reflect latest changes
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_LAYER+"/>");
			// show zones
			var node:XML;
			if(_zones != null) {
				for each(var zone:BackgroundZoneData in _zones.zoneList) {
					node = zone.toXML();
					xml.appendChild(node);
				}
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
