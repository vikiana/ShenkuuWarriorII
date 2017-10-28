
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.flags
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.flags.FloatingFlag;
	
	/**
	 *	This class add prize awarding behaviour to a flag.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class PrizeFlag extends FloatingFlag
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _pointValue:int;
		protected var _prizeID:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PrizeFlag():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get pointValue():int { return _pointValue; }
		
		public function get prizeID():String { return _prizeID; }
		
		public function set prizeID(pID:String) { _prizeID = pID; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
