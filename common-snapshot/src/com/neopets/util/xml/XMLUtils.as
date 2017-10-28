// This class holds useful functions for dealing with Arrays.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.xml
{
	
	public class XMLUtils {
		
		// This function automatically trims the list from an XML:child call down to it's first entry.
		
		public static function getFirstChild(xml:XML,child_type:String):XML {
			if(xml == null || child_type == null) return null;
			var nodes:XMLList = xml[child_type];
			if(nodes != null) {
				var num_nodes = nodes.length();
				if(num_nodes > 0) return nodes[0];
			}
			return null;
		}
		
		// This function automatically trims the list from an XML:child call down to it's last entry.
		
		public static function getLastChild(xml:XML,child_type:String):XML {
			if(xml == null || child_type == null) return null;
			var nodes:XMLList = xml[child_type];
			if(nodes != null) {
				var num_nodes = nodes.length();
				if(num_nodes > 0) return nodes[num_nodes - 1];
			}
			return null;
		}
		
	}
}