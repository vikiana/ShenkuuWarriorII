package  virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	import fl.transitions.easing.*;
	
	import virtualworlds.helper.Fu.BaseClasses.BasicClass;
	
	// use this class to write transitions for the various fu helpers
	public class BasicTransition extends BasicClass
	{
		
		public function BasicTransition(){
			
		}	
		
		public function applyTweenIn(aMessageObject:Object):void{
			error("You must give a ui object at least 1 tween!")
		}
		
		public function applyTweenOut(aMessageObject:Object):void{
			error("You must give a ui object at least 1 tween!")
		}
		
		public function finishIn(aMessageObject:Object):void{
			
		}
		
		public function finishOut(aMessageObject:Object):void{
			
		}
	}
}