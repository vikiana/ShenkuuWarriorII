
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util
{
	
	/**
	 *	This class simply attaches an number to a given piece of data.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class ItemCount extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var count:int;
		public var item:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ItemCount(info:Object=null,val:int=1):void{
			super();
			item = info;
			count = val;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function toString():String {
			return "[" + count + " " + item + "]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
