package virtualworlds.helper.Fu.BaseEvents
{

	import flash.events.Event;
	
	import virtualworlds.helper.Fu.BaseClasses.IUpdateable;
	
	public class UpdateableEvent extends Event
	{
		
		public static var ENTER:String = "enter"
		public static var EXIT:String = "exit"
		
		public var updateable:IUpdateable
		
		public function UpdateableEvent(aEventType:String, aItem:IUpdateable)
		{
			updateable = aItem
			super(aEventType)
		}

	}
}