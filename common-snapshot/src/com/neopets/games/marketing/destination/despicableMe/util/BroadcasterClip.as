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
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	
	public class BroadcasterClip extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _sharedDispatcher:EventDispatcher;
		protected var _dispatcherClass:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BroadcasterClip():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get sharedDispatcher():EventDispatcher { return _sharedDispatcher; }
		
		public function set sharedDispatcher(disp:EventDispatcher) {
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to route a message through our shared dispatcher.
		// param	type		String		Event type indentifier.
		// param	info		Object		Optional parameter for passing out extra data.
		// param	bubbles		Boolean		As per the Event constructor.
		// param	cancelable	Boolean		As per the Event constructor.
		
		public function broadcast(type:String,info:Object=null,bubbles:Boolean=false,cancelable:Boolean=false):void {
			if(_sharedDispatcher != null) {
				var transmission:BroadcastEvent = new BroadcastEvent(this,type,info,bubbles,cancelable);
				_sharedDispatcher.dispatchEvent(transmission);
			}
			
		}
		
		// Use this function to use a containing display object of the target class as 
		// our shared dispatcher.
		// param	class_def		Class		Class definition for the target object.
		
		public function useParentDispatcher(class_def:Class):void {
			_dispatcherClass = class_def;
			// check if this object has been added to the stage
			if(stage != null) {
				sharedDispatcher = DisplayUtils.getAncestorInstance(this,class_def);
			} else {
				addEventListener(Event.ADDED_TO_STAGE,onParentCheck);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// This function is called when added to stage to use a containing display object as 
		// our shared dispatcher.
		
		protected function onParentCheck(ev:Event) {
			if(ev.target ==  this) {
				sharedDispatcher = DisplayUtils.getAncestorInstance(this,_dispatcherClass as Class);
				removeEventListener(Event.ADDED,onParentCheck);
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}