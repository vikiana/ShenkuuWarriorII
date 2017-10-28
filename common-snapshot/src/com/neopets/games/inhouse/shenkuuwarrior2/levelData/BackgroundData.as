/* AS3
	Copyright 2010
*/
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import com.neopets.util.array.ArrayUtils;
	
	/**
	 *	This class holds the data used to create complex backgrounds.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  10.18.2010
	 */
	public class BackgroundData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const XML_TYPE_BACKGROUND:String = "background";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _layers:Array;
		
		protected var _pMultipliers:Vector.<Number> = new Vector.<Number>();
		
		//flag
		private var _bgLayerCount:int = 1;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BackgroundData(list:XMLList=null):void{
			super();
			initFromXML(list);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function set bgLayerCount (value:int):void {
			_bgLayerCount = value;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function reset our properies to their initial, cleared values.
		
		public function clear():void {
			if(_layers != null) {
				while(_layers.length > 0) _layers.pop();
			} else _layers = new Array();
		}
		
		// This function unpackages our data into a list of image placements for the target alitude range.
		//ADDED BY VIV -  min and max values are provided by the XML as
		//ADDED BY VIV - the result of this is an array of arrays (each array includes the bkg info for one layer)
		public function generateLayout(min:Number,max:Number):Vector.<Vector.<ImagePlacement>> {
			if(_layers == null) return null;			
			
			var list:Vector.<Vector.<ImagePlacement>> = new Vector.<Vector.<ImagePlacement>>();
			var sub_list:Vector.<ImagePlacement>;
			var layer:BackgroundLayerData;
			
			//get first layer generated:
			layer = _layers[0];
			layer.bgLayerCount = _bgLayerCount;
			//trace ("BATCH", _bgLayerCount);
			sub_list = layer.generateLayout(min,max,i);
			list.push (sub_list);
			//create multipliers for other layers
			var multipliers:Vector.<Number> = getMultipliers(max-min);
			var nmax:Number
			var nmin:Number
			//build our list by cycling through all layers (but the first one)
			for(var i:int = 1; i < _layers.length; i++) {
				layer = _layers[i];
				
				nmin = min/multipliers[i];
				nmax = max/multipliers[i];
				
				layer.bgLayerCount = _bgLayerCount
				
				sub_list = layer.generateLayout(nmin,nmax,i);
				list.push (sub_list);
			}
			
			//only three different bgs in sky level
			if (_bgLayerCount+1 <= 3){
				_bgLayerCount++;
			}
			
			return list;
		}
		
		public function getMultipliers (max:Number):Vector.<Number>{
			var multipliers:Vector.<Number> = new Vector.<Number> ();
			//calculate the parallax speed multipliers: PROBABLY MOVE THIS TO THE BACKGROUND DATA CLASS
			//divide total level height per bottomest layer height to find its multiplier
			var h:Number = BackgroundLayerData(_layers[_layers.length-1]).backLayerPanelHeight;
			var m:Number = max / h;
			//'distance' between multiplier values (equals to distance between layers)
			var step:Number = m /(_layers.length-1);
			multipliers[0] = 1;
			//generates all multipliers
			for (var i:int = 1; i< _layers.length; i++){
				multipliers[i] = step*i;//*2;
			}
			return multipliers;
		}
		
		/* XML Functions */
		
		// This function sets our properties from an XML file.
		
		public function initFromXML(list:XMLList):void {
			clear();
			if(list != null) {
				var layer_list:XMLList = list.child(BackgroundLayerData.XML_TYPE_LAYER);
				var layer:BackgroundLayerData;
				for each(var node:XML in layer_list) {
					layer = new BackgroundLayerData(node);
					_layers.push(layer);
				}
			}
		}
		
		public function toXML():XML {
			// create base node
			var xml:XML = new XML("<"+XML_TYPE_BACKGROUND+"/>");
			// show layers
			var node:XML;
			if(_layers != null) {
				for each(var layer:BackgroundLayerData in _layers) {
					node = layer.toXML();
					xml.appendChild(node);
				}
			}
			// return completed xml
			return xml;
		}
		
		
		//UTILS FUNCTIONS
		
		//I use this to position the ledges properly on the first screen
		public function getGroundPanelHeight ():Number {
			return BackgroundLayerData(_layers[0]).groundPanelHeight;
		}
		
		//I use this to generate the "batch height" for the endless level
		public function getBackLayerPanelHeight ():Number {
			return BackgroundLayerData(_layers[_layers.length-1]).backLayerPanelHeight;
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
