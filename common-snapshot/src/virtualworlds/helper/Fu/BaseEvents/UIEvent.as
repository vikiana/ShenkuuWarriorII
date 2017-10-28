package virtualworlds.helper.Fu.BaseEvents
{
	import flash.events.Event;
	
	import virtualworlds.helper.Fu.BaseClasses.IUIDisplayObject;
	
	public class UIEvent extends Event
	{
		
		public var UIObject:IUIDisplayObject;
		public var params:*
		
		public static const ACTIVATED:String = "Activated"
		public static const ANIMATEDIN:String = "AnimatedIn"
		public static const DEACTIVATED:String = "Deactivated"
		public static const ANIMATEDOUT:String = "AnimatedOut"
		
		public function UIEvent(aEventType:String, aItem:IUIDisplayObject, aParamObject:* = null)
		{
			UIObject = aItem
			params = aParamObject
			super(aEventType)
		}

	}
}