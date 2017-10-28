package com.neopets.utils.display
 {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	
	//METADATA
	[Event(name="sampleEvent", type="mx.events.Event")]
	
	/**
	* Class Description: This is a quick setup to traceObject (not working?) and to put
	 * a bunch of traces in a class and easily togglet the off with the enabled value
	*/	
	public class Logger extends EventDispatcher {
		
			
		//*********************************
		//PROPERTIES
		//*********************************	
		
		//PUBLIC API

		//SETTERS/GETTERS
		//PUBLIC API
		private var enabled_boolean : Boolean;
		public function set enabled (aValue : Boolean) : void { enabled_boolean = aValue; }
		public function get enabled () : Boolean { return enabled_boolean; }
		
		//PRIVATE	
		
		
		//*********************************
		//CONSTRUCTOR
		//*********************************	
		public function Logger (aEnabled_boolean: Boolean = true) {
			enabled_boolean = aEnabled_boolean;
		}
		
		
		//*********************************
		//METHODS
		//*********************************	
	
		//PUBLIC API
		//KEEP NOT STATIC SO YOU CAN toggle enabled LOGGERs PER CLASS (GLOBAL FUNCTIONALITY MAY BE NEEDED LATER?) SAMR - 10/05/07
		public function traceString (aMessage_str:String = "") : void {
			if (enabled_boolean) {
				trace (aMessage_str);
			}
		}
		
		
		
		
		//THIS FAILS SO FAR -SAMR 
		public static function traceObject (aObject:Object,spaces_num:Number=0,aIsHeaderShown_boolean:Boolean = true) : void {
			
			
			var spaces_str:String = "";
			for (var s:Number = 0; s < spaces_num; s++) {
				spaces_str += " ";
			}
			if (aIsHeaderShown_boolean) {
				trace (spaces_str + "Logger.traceObject("+ aObject +")");
			}
			spaces_str += " ";
			for (var i:String in aObject) {
				trace (spaces_str + "> " + i + " = " + aObject[i]);		
				Logger.traceObject(aObject[i], spaces_num++,false);	
			}	

			
		}
		
		//PRIVATE
		
		
		//*********************************
		//EVENTS
		//*********************************	
		
		//INCOMING
		public function onSomeOtherEvent (aEvent:Event) : void {	
			
		}
		
		//OUTGOING
		public function dispatchSampleEvent (aArgument:Object) : void {	
			dispatchEvent(new Event("Event", false, false));	
			
		}	
	}
}



