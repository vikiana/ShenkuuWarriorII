
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.util
{
	
	/**
	 *	This class handles extracting a random entry from an xml tree.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class ChanceTree extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const WEIGHT_ATTRIBUTE:String = "weight";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _tree:XML;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ChanceTree():void{
			super();
			tree = null; // start with empty default tree
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get tree():XML { return _tree; }
		
		public function set tree(info:XML) {
			if(info != null) _tree = info;
			else _tree = new XML("<chance/>");
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function as a quick way to add a weighted node to our tree.
		// param	path		String		"." separated reference to location of target node
		// param	weight		Number		target node's weight
		
		public function addChance(path:String,weight:Number=1):XML {
			if(path == null) return null;
			// break the path down into node names
			var names:Array = path.split(".");
			// iterate through each step in the path
			var target_id:String;
			var nodes:XMLList;
			var target_node:XML;
			var prev_node:XML = _tree;
			for(var i:int = 0; i < names.length; i++) {
				target_id = names[i];
				// check if the node already exists
				nodes = prev_node.child(target_id);
				if(nodes.length() > 0) {
					// if so, use the first node found
					target_node = nodes[0];
				} else {
					// if not, create a new node
					target_node = new XML("<"+target_id+"/>");
					prev_node.appendChild(target_node);
				}
				// move onto next node
				prev_node = target_node;
			}
			// if we've got a target node, set it's weight
			if(target_node != null) {
				target_node["@"+WEIGHT_ATTRIBUTE] = String(weight);
			}
			return target_node;
		}
		
		// Use this function to extract the weight value for the target XML node.
		
		public function getNodeWeight(xml:XML):Number {
			if(xml == null) return 0;
			// check for the weight attribute
			var list:XMLList = xml.attribute(WEIGHT_ATTRIBUTE);
			var num_attr:int = list.length();
			// if the weight attribut doesn't occur, use a default weight of 1.
			if(num_attr < 1) return 1;
			// otherwise, use the last instance of weight attribute
			var attr_xml:XML = list[num_attr-1];
			var attr_val:Number = Number(attr_xml.toString());
			// if the trait is not a number, use the default weight.
			if(isNaN(attr_val)) return 1;
			else return attr_val;
		}
		
		// Use this function to retrieve a random terminal node from our tree.
		
		public function getRandomNode():XML {
			return getRandomNodeFrom(_tree);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to recurse through an xml tree, making random selections 
		// at every branch, until we hit a terminal node.
		
		protected function getRandomNodeFrom(xml:XML):XML {
			if(xml == null) return xml;
			// check if this node has any children
			var list:XMLList = xml.children();
			var num_nodes:int = list.length();
			if(num_nodes > 0) {
				// if if does have children, check if there's more than one.
				if(num_nodes > 1) {
					// if there are multiple children, pick one at random
					// start by getting the total weight of all nodes.
					var sum:Number = 0;
					var item:XML;
					for(var i:int = 0; i < num_nodes; i++) {
						item = list[i];
						sum += getNodeWeight(item);
					}
					// pick a random point along that total
					var rand:Number = Math.random() * sum;
					// map the random value to a node
					var odds:Number;
					for(i = 0; i < num_nodes; i++) {
						item = list[i];
						odds = getNodeWeight(item);
						// if the remaining value is less than our odds, pick this item
						if(rand < odds) return getRandomNodeFrom(item);
						// if not, reduce the random value by our odds
						rand -= odds;
					}
					// if we got this far without breaking, just use the last item.
					return getRandomNodeFrom(item);
				} else {
					// if there was only one child, ask that child for a random node.
					return getRandomNodeFrom(list[0]);
				}
			}
			// if the node had no children, return the node itself.
			return xml;
		}
		
	}
	
}
