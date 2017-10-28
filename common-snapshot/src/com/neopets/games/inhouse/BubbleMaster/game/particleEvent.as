/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import flash.geom.*;
	
	public class particleEvent extends EventDispatcher {
		
		public static var COMPLETE:String = 'complete';
		
		public var position:Point = new Point();
		public var color:uint = 0xFFFFFF;
		public var props:Object = new Object();
		
		public function dispatch(type:String):void {
			
			switch(type) {
				case 'complete':
				dispatchEvent(new Event(particleEvent.COMPLETE));
				break;
			}
			
		}
		
	}
	
}