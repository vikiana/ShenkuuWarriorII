package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	public class NoTransition extends BasicTransition
	{
		
	
		public override function applyTweenIn(aMessageObject:Object):void{
			
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX", None.easeNone, 1, 1, .0001, true))
		}
		
		public override function applyTweenOut(aMessageObject:Object):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX",  None.easeNone, 1, 1, .0001, true))
		}
	}
}