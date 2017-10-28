/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase.loadedData
{
	
	/**
	 *	This class stores the data for a given collection.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class AlbumData
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _collections:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AlbumData():void{
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get collections():Array { return _collections; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function provides default values for offline testing.
		 */
		
		public function useTestValues():void {
			_collections = new Array();
			// add x collections
			var entry:Object;
			for(var i:int = 0; i < 5; i++) {
				entry = new CollectionData();
				entry.useTestValues();
				_collections.push(entry);
			}
			// sort our collections by starting date
			_collections.sortOn("startDate",Array.NUMERIC|Array.DESCENDING);
		}
		
		/**
		 * @This function initializes our values from those of an unspecified data object.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function initFrom(info:Object):void {
			if(info is Array) {
				var list:Array = info as Array;
				// clear the collections array
				if(_collections != null) {
					while(_collections.length > 0) _collections.pop();
				} else _collections = new Array();
				// fill the array with our new values
				var entry:Object;
				var collection:CollectionData;
				for(var i:int = 0; i < list.length; i++) {
					entry = list[i];
					// try to fetch the target collection
					collection = getCollection(entry.collectionName);
					// if we failed, create a new collection
					if(collection == null) {
						collection = new CollectionData(entry.collectionName);
						if(collection != null) _collections.push(collection);
					}
					// add the entry to the target collection
					if(collection != null) collection.addEntry(entry);
				}
				// sort our collections by starting date
				_collections.sortOn("startDate",Array.NUMERIC);
				// pad out our collections to the minimum length
				for(i = 0; i < _collections.length; i++) {
					_collections[i].addExtraEntries();
				}
			}
		}
		
		/**
		 * @This function updates our values for a given user.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function initUser(info:Object):void {
			// pass processing on to our collections
			for(var i:int = 0; i < _collections.length; i++) {
				_collections[i].initUser(info);
			}
		}
		 
		/**
		 * @This function tries to retrieve the collection with the target name.
		 * @param		tag		String 		Name of the collection.
		 */
		 
		public function getCollection(tag:String):CollectionData {
			var collection:CollectionData;
			for(var i:int = 0; i < _collections.length; i++) {
				collection = _collections[i];
				if(collection.name == tag) return collection;
			}
			return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}