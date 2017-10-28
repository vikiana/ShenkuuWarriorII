package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	import Fu.BaseClasses.IUIDisplayObject;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class FadeInThenMoveUpAndFadeOut extends BasicTransition
	{
		
		public function FadeInThenMoveUpAndFadeOut(){
			
		}	
	
		
		public override function applyTweenIn(aMessageObject:Object):void {
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "alpha", None.easeOut, 0, 1, .6, true));
		}
		
		public override function applyTweenOut(aMessageObject:Object):void {
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "y", None.easeOut, aMessageObject.y, aMessageObject.y - 30, 1, true))
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "alpha", None.easeOut, aMessageObject.alpha, 0, 1, true))
		}
		
		
	}
}