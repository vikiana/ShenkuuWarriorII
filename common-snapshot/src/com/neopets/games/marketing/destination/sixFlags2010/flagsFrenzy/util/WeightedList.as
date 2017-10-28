
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util
{
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.ItemCount;
	
	/**
	 *	This class handles lists where multiple additions of a given item are
	 *  stored under the same entry.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class WeightedList extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _itemList:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function WeightedList():void{
			super();
			_itemList = new Array();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get itemList():Array { return _itemList; }
		
		public function get uniqueItems():Array {
			var list:Array = new Array();
			var entry:ItemCount;
			for(var i:int = 0; i < _itemList.length; i++) {
				entry = _itemList[i] as ItemCount;
				list.push(entry.item);
			}
			return list;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to add new items to the list.
		
		public function addItem(info:Object):void {
			if(info == null) return;
			// check if the item is already in our list
			var entry:ItemCount = getItem(info);
			if(entry != null) {
				// if the item was found, increment the count.
				entry.count++;
			} else {
				// if the item wasn't found, add a new entry.
				entry = new ItemCount(info);
				_itemList.push(entry);
			}
		}
		
		// Use this function to wipe the item list.
		
		public function clearItems():void {
			while(_itemList.length > 0) {
				_itemList.pop();
			}
		}
		
		// Use this function to get our entry for the target item.
		
		public function getItem(info:Object):ItemCount {
			if(info == null) return null;
			var entry:ItemCount;
			for(var i:int = 0; i < _itemList.length; i++) {
				entry = _itemList[i] as ItemCount;
				if(entry.item == info) return entry;
			}
			return null;
		}
		
		// Use this function to take a single instance of the item off the list.
		
		public function removeItem(info:Object):void {
			if(info == null) return;
			// check if the item is already in our list
			var entry:ItemCount = getItem(info);
			if(entry != null) {
				// if the item was found, decrement the count.
				entry.count--;
				// if this drops the count to 0, remove the item
				if(entry.count <= 0) {
					var index:int = _itemList.indexOf(entry);
					_itemList.splice(index,1);
				}
			}
		}
		
		public function toString():String {
			return _itemList.toString();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
