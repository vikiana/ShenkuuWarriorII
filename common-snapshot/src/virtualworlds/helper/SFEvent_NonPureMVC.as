package virtualworlds.helper
{
	import flash.events.Event;

	public class SFEvent_NonPureMVC extends Event
	{
		public function get params():Object { return _params; };
		public function set params(value:Object):void { _params = value; };
		private var _params:Object;
		
		public function SFEvent_NonPureMVC(type:String, dataObject:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_params = dataObject;
		}
		
	}
}