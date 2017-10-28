package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	//import Fu.BaseClasses.IUIDisplayObject;
	//import Fu.BaseClasses.UIDisplayObject;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class FadeInFadeOut extends BasicTransition
	{
		
		public function FadeInFadeOut(){
			
			
		}	
	
		
		public override function applyTweenIn(aMessageObject:Object):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "alpha", None.easeOut, 0, 1, 1, true))
		}
		
		public override function applyTweenOut(aMessageObject:Object):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "alpha", None.easeOut, aMessageObject.alpha, 0, 1, true))
		}
		
		
	}
}