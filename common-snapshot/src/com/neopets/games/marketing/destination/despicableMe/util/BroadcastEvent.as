/**
 *	This class adds shared dispatcher functionality to movie clips.  This lets these objects
 *  send out event to any object with the same shared dispatcher.
 *  You can also have the object check the display list for a containing clip of a given class
 *  to use as a shared dispatcher.  This helps if with want contents within a given type of
 *  container communicating with each other.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.despicableMe.util
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	
	public class BroadcastEvent extends CustomEvent
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _sender:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BroadcastEvent(caller:Object, type:String, srcData:Object=null, bubbles:Boolean=false, 
									   cancelable:Boolean=false):void {
			super(srcData,type,bubbles,cancelable);
			_sender = caller;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get sender():Object { return _sender; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}