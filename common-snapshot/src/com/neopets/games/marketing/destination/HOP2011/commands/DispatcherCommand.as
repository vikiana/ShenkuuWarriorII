/**
 *	This command sends out a custom event when executed.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.HOP2011.commands
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import com.neopets.util.events.CustomEvent;
	
	public class DispatcherCommand extends AbsCommand
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var eventType:String;
		public var eventData:Object;
		public var dispatcher:EventDispatcher;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function DispatcherCommand(sender:EventDispatcher=null,tag:String=null,info:Object=null):void {
			dispatcher = sender;
			eventType = tag;
			eventData = info;
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		override public function execute(ev:Event=null):void {
			if(dispatcher != null) {
				var transmission:CustomEvent = new CustomEvent(eventData,eventType);
				dispatcher.dispatchEvent(transmission);
			}
		}
		
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