package com.neopets.utils.display {

	//IMPORTS
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.system.System;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.neopets.events.MemoryEvent;
	
	//CLASS-SPECIFIC METADATA (VARIABLE/METHOD/EVENT METADATA GOES INLINE BELOW...)

	
	/**
	* CLASS DESCRIPTION: 
	*/	
	public class MemoryManagementMonitor extends EventDispatcher {
		
			
		//*********************************
		//PROPERTIES
		//*********************************	
		
		//PUBLIC API
		private var showWarning_boolean:Boolean;
		public function set showWarning (aArgument:Boolean): void {  showWarning_boolean = aArgument; }
		public function get showWarning ():Boolean { return showWarning_boolean; }
		
		private var warningMemory_uint:uint;
		public function set warningMemory (aArgument:uint): void {  warningMemory_uint = aArgument; }
		public function get warningMemory ():uint { return warningMemory_uint; }
		
		private var abortMemory_uint:uint;
		public function set abortMemory (aArgument:uint): void {  abortMemory_uint = aArgument; }
		public function get abortMemory ():uint { return abortMemory_uint; }	
	
		private var totalMemory_uint:uint;
		public function get totalMemory ():uint { return totalMemory_uint; }		
	
		//PRIVATE
		private var timer:Timer;	
		
		
		//*********************************
		//CONSTRUCTOR
		//*********************************	
		public function MemoryManagementMonitor () {
			
			//DEFAULTS
			showWarning_boolean = true;
			warningMemory_uint = 1000*1000*500;
			abortMemory_uint = 1000*1000*625;
			
			//TIMER
			timer = new Timer (1000);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,onCheckMemoryUsage);

			
		}
		
		
		//*********************************
		//METHODS
		//*********************************	
	
		//PUBLIC API
		
		//PRIVATE
		
		
		//*********************************
		//EVENTS
		//*********************************	
		
		//OUTGOING
		[Event(name="update", type="com.neopets.events.MemoryEvent")]
		public function dispatchUpdate () : void {	
			dispatchEvent(new MemoryEvent(MemoryEvent.UPDATE));
		}	
		
		
		[Event(name="warning", type="com.neopets.events.MemoryEvent")]
		public function dispatchWarning () : void {	
			dispatchEvent(new MemoryEvent(MemoryEvent.WARNING));
		}	
		
		[Event(name="error", type="com.neopets.events.MemoryEvent")]
		public function dispatchError () : void {	
			dispatchEvent(new MemoryEvent(MemoryEvent.ERROR));
		}	
		
		//INCOMING
		public function onCheckMemoryUsage(aEvent:TimerEvent): void {
			totalMemory_uint = System.totalMemory;
		   	if (totalMemory_uint > warningMemory_uint && showWarning) {
		      	dispatchWarning();
		      	showWarning = false; // so we don't show an error every second
		    } else if (totalMemory_uint > abortMemory_uint) {
		      	dispatchError();
		    } else {
		    	dispatchUpdate();
		    }
		}
	
	}
}