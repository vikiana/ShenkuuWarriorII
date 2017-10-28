package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	//import Fu.BaseClasses.IUIDisplayObject;
	//import Fu.BaseClasses.UIDisplayObject;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class AvatarMessageTransition extends BasicTransition
	{
		private var _timeIn:int;
		public function AvatarMessageTransition(timeIn:int = 2){
			_timeIn = timeIn;			
		}	
	
		
		public override function applyTweenIn(aMessageObject:Object):void {
			  aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX", Elastic.easeOut, 0,1, .7, true))			  
			  aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleY", Elastic.easeOut, 0,1, .7, true))
			  aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "y", None.easeOut, aMessageObject.y, aMessageObject.y - 10, _timeIn, true))
		}
		
		public override function applyTweenOut(aMessageObject:Object):void {
			
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "alpha", None.easeOut, aMessageObject.alpha, 0, 1, true))
		}
		
		
	}
}