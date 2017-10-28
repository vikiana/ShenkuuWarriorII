
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.BroadcastEvent;
	
	/**
	 *	This class lets you send an event up the display object tree.
	 *  This can also be used to attach event listeners to an ancestor in the 
	 *  display object tree.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  05.04.2010
	 */
	 
	public class BroadcasterClip extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var defaultDispatcher:EventDispatcher;
		protected var _pendingClass:Class;
		protected var _pendingListeners:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BroadcasterClip():void{
			super();
			_pendingListeners = new Array();
			// set up listeners
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to route a message through our shared dispatcher.
		// param	type		String				Event type indentifier.
		// param	info		Object				Optional parameter for passing out extra data.
		// param	dispatcher	EventDispatcher		Target dispatcher the event is sent through.
		// param	bubbles		Boolean				As per the Event constructor.
		// param	cancelable	Boolean				As per the Event constructor.
		
		public function broadcast(type:String,info:Object=null,dispatcher:EventDispatcher=null,
								  bubbles:Boolean=false,cancelable:Boolean=false):void {
			// build broadcast
			var transmission:BroadcastEvent = new BroadcastEvent(this,type,info,bubbles,cancelable);
			// redirect through target
			if(dispatcher != null) {
				dispatcher.dispatchEvent(transmission);
			} else {
				// if no dispatcher was provided, try using our default.
				if(defaultDispatcher != null) {
					defaultDispatcher.dispatchEvent(transmission);
				} else {
					// otherwise, send the event out ourselves
					dispatchEvent(transmission);
				}
			} // end of target dispatcher check
		}
		
		// Display Object Tree Functions
		
		// Use this function to attach an event listener to the first member of the target class
		// in our parent list.
		// param	class_def		Class		Class definition for the target object.
		
		public function addParentListener(class_def:Class,type:String,listener:Function,useCapture:Boolean=false,
										  priority:int=0,useWeakReference:Boolean=true):void {
			// check if this object has been added to the stage
			if(stage != null) {
				var dispatcher:EventDispatcher = DisplayUtils.getAncestorInstance(this,class_def) as EventDispatcher;
				if(dispatcher != null) {
					dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
				}
			} else {
				// push listener request
				_pendingListeners.push(arguments);
				addEventListener(Event.ADDED,onParentCheck);
			}
		}
		
		// Use this function to use a containing display object of the target class as 
		// our default dispatcher.
		// param	class_def		Class		Class definition for the target object.
		
		public function useParentDispatcher(class_def:Class):void {
			// check if this object has been added to the stage
			if(stage != null) {
				defaultDispatcher = DisplayUtils.getAncestorInstance(this,class_def);
			} else {
				_pendingClass = class_def;
				addEventListener(Event.ADDED,onParentCheck);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function is called when added to stage to use a containing display object as 
		// our shared dispatcher.
		
		protected function onParentCheck(ev:Event) {
			if(ev.target ==  this) {
				// check for a default dispatcher request
				if(_pendingClass != null) {
					defaultDispatcher = DisplayUtils.getAncestorInstance(this,_pendingClass);
				}
				// check for listener requests
				var params:Object;
				var dispatcher:EventDispatcher;
				for(var i:int = 0; i < _pendingListeners.length; i++) {
					params = _pendingListeners[i];
					dispatcher = DisplayUtils.getAncestorInstance(this,params[0]) as EventDispatcher;
					// if the dispatcher is found, use the passed in parameters to set up a listener
					if(dispatcher != null) {
						dispatcher.addEventListener(params[1],params[2],params[3],params[4],params[5]);
					}
				}
				// remove listener
				removeEventListener(Event.ADDED,onParentCheck);
			}
		}
		
		// This function cleans up our links when we're taken off stage.
		
		protected function onRemoved(ev:Event) {
			if(ev != null && ev.target == this) {
				defaultDispatcher = null;
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			}
		}
		
	}
	
}
