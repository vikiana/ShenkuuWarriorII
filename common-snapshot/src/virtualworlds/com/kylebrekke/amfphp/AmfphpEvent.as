package virtualworlds.com.kylebrekke.amfphp
{
	import flash.events.Event;
	import flash.display.Loader;
	
	public class AmfphpEvent extends Event
	{
		public static const	AMFPHPRESULT:String = "AmfphpResult";
		
		private var _params:Object = new Object();
		public function AmfphpEvent(aEventType:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{	
			super(aEventType, bubbles, cancelable)
		}
		
		public function get params():Object { return _params; }
		
		public function set params(value:Object):void 
		{
			_params = value;
		}
		
		/**
		 * This override is necessary for re-dispatching of this Event.
		 * 
		 * @return a cloned ClientEvent instance.
		 */
		override public function clone():Event
		{
			var newEvt:AmfphpEvent = new AmfphpEvent (this.type, this.bubbles, this.cancelable);
			newEvt.params = this.params;
			return newEvt;
		}//end clone()
		
	}//end class ClientEvent
	
}