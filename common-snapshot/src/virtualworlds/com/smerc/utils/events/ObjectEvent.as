package virtualworlds.com.smerc.utils.events
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class ObjectEvent extends Event
	{
		private var _obj:Object;
		
		public function ObjectEvent(type:String, a_obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_obj = a_obj;
			
		}//end ObjectEvent() constructor.
		
		public function get obj():Object
		{
			return _obj;
		}//end get obj()
		
		public function set obj(a_obj:Object):void
		{
			_obj = a_obj;
		}//end set obj()
		
		override public function clone():Event
		{
			return new ObjectEvent(this.type, _obj, this.bubbles, this.cancelable);
			
		}//end clone()
		
		override public function toString():String
		{
			return formatToString("ObjectEvent", "type", "obj", "bubbles", "cancelable"); 
			
		}//end toString()
		
	}//end class ObjectEvent
	
}//end package com.smerc.utils.events 
