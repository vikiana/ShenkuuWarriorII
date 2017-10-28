package  virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	//import Fu.BaseClasses.IUIDisplayObject;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class BounceInBounceOut extends BasicTransition
	{
		
		public function BounceInBounceOut(){
			
			
		}	
	
		public override function applyTweenIn(aMessageObject:Object):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX", Elastic.easeOut, 0, 1, .5, true))
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleY", Elastic.easeOut, 0, 1, .5, true))
			
		}
		
		public override function applyTweenOut(aMessageObject:Object):void{
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleX", Regular.easeOut, aMessageObject.scaleX, 0.01, .25, true))
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "scaleY", Regular.easeOut, aMessageObject.scaleY, 0.01, .25, true))
		}
		
	}
}