package virtualworlds.helper.Fu.BaseClasses
{
	import org.spicefactory.lib.logging.*;
	
	import virtualworlds.helper.Fu.BaseEvents.UpdateableEvent;
	
	// a bridge class to link all class types to a updateable class this way a class and a object can be seen as the same thing
	public class UpdateableClass extends BasicClass implements IUpdateable
	{
		
		public function UpdateableClass()
		{
			super();
		}
		
		public function enter():void{
			var enterEvent:UpdateableEvent = new UpdateableEvent(UpdateableEvent.ENTER, this);
			this.dispatchEvent(enterEvent);
		}
		
		public function execute(aStep:uint = 0):void{
			
		}
		
		public function exit():void{
			var exitEvent:UpdateableEvent = new UpdateableEvent(UpdateableEvent.EXIT, this)
			this.dispatchEvent(exitEvent)
		}

	}
}