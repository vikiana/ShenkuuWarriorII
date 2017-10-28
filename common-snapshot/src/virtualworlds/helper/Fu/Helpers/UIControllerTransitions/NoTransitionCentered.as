package  virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	//import Fu.BaseClasses.UIDisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class NoTransitionCentered extends BasicTransition
	{
		
	
		public override function applyTweenIn(aMessageObject:Object):void{
			var start:Number = -aMessageObject.width /2
			var end:Number = aMessageObject.stage.stageWidth/2
			
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "x", Regular.easeOut, end, end, .0001, true))
			
			
		}
		
		public override function applyTweenOut(aMessageObject:Object):void{
			var start:Number  = aMessageObject.x
			var end:Number = aMessageObject.stage.stageWidth + aMessageObject.width/2
			
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "x", Regular.easeOut, end, end, .0001, true))
		
		}
	}
}