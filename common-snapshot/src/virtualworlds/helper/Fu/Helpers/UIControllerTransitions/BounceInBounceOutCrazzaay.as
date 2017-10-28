package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	import Fu.BaseClasses.UIDisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class BounceInBounceOutCrazzaay extends BasicTransition
	{
		
		public function BounceInBounceOutCrazzaay(){
			
			
		}	
	
		public override function applyTweenIn(aMessageObject:UIDisplayObject):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX", Elastic.easeOut, 0, 1, .5, true))
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleY", Elastic.easeOut, 0, 1, .5, true))
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "alpha", Elastic.easeOut, 0, 1, .5, true))
			
		}
		
		public override function applyTweenOut(aMessageObject:UIDisplayObject):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX", Regular.easeOut, aMessageObject.scaleX, 0.01, .25, true))
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleY", Regular.easeOut, aMessageObject.scaleY, 0.01, .25, true))
		}
		
	}
}