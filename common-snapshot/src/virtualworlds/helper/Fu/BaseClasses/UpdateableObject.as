package virtualworlds.helper.Fu.BaseClasses
{
	import virtualworlds.helper.Fu.BaseEvents.UpdateableEvent; 

	// a bridge class to link all class types to a updateable class this way a class and a object can be seen as the same thing
	public class UpdateableObject extends BasicObject implements IUpdateable
	{
		
		public function UpdateableObject()
		{
			super();
		}
		
		public function enter():void{
			var enterEvent:UpdateableEvent = new UpdateableEvent(UpdateableEvent.ENTER, this)
			this.dispatchEvent(enterEvent)
		}
		
		public function execute(aStep:uint = 0):void{
			
		}
		
		public function exit():void{
			var exitEvent:UpdateableEvent = new UpdateableEvent(UpdateableEvent.EXIT, this)
			this.dispatchEvent(exitEvent)
		}
		
		/**
		 * 
		 */
		public function destroy():void{
			if(this.parent){
				this.parent.removeChild(this)
				delete this
			}
		}

	}
}