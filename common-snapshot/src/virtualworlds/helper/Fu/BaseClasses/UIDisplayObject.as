package virtualworlds.helper.Fu.BaseClasses
{
	import virtualworlds.helper.Fu.BaseEvents.UIEvent;
	
	// this is a handy class for making Tscreens and messages, us it with the UIController
	public class UIDisplayObject extends UpdateableObject implements IUIDisplayObject
	{
		// the controller that this UIDisplay object is inside
		private var _controller:IUIController;
		public function get controller ():IUIController { return _controller }
		public function set controller (value:IUIController):void
		{
			_controller = value;
		}
		
		//the array of tweens that a UIController uses to manipulate this obejct
		private var _activeTweenArray:Array = [];
		public function get activeTweenArray ():Array { return _activeTweenArray };
		public function set activeTweenArray (value:Array):void
		{
			_activeTweenArray = value
		}
		
		public function UIDisplayObject ()
		{
			
		}
		
		// is this UIDisplayobject being displayed
		private var _active:Boolean;
		public function get active():Boolean { return _active }
		public function set active(aBool:Boolean):void
		{
			_active = aBool
		}
		
		// dispatched as soon as this screen is shown
		public function activated():void{
			var event:UIEvent = new UIEvent(UIEvent.ACTIVATED, this)
			this.dispatchEvent(event)
			
		}
		
		/**
		 * dispatched as soon as this screen is finished tweening
		 */
		public function animatedIn():void{
			var event:UIEvent = new UIEvent(UIEvent.ANIMATEDIN, this)
			this.dispatchEvent(event)
			
		}
		
		// dispatched as soon as this screen is told to tween out
		public function deactivated():void{
			var event:UIEvent = new UIEvent(UIEvent.DEACTIVATED, this)
			this.dispatchEvent(event)
			
		}
		
		/**
		 * dispatched as soon as this screen has finished tweening out
		 */
		public function animatedOut():void{
			var event:UIEvent = new UIEvent(UIEvent.ANIMATEDOUT, this)
			this.dispatchEvent(event)
			
		}
		

	}
}