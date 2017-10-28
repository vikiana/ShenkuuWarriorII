package com.neopets.games.inhouse.AdventureFactory.util
{
	import flash.events.*;

	public class ValueChangeEvent extends Event
	{
		public var previousValue:Object;
		public var newValue:Object;
		
		public function ValueChangeEvent(type:String,val:Object=null,prev:Object=null,bubbles:Boolean=false,
										 cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			previousValue = prev;
			newValue = val;
		}
		
	}
}
