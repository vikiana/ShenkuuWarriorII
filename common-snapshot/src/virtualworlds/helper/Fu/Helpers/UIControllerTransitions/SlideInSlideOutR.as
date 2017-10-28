package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;	
	public class SlideInSlideOutR extends BasicTransition
	{
		
		public function SlideInSlideOutR(){
			
			
		}	
	
		public override function applyTweenIn(aMessageObject:Object):void{
			
			var start:Number = -aMessageObject.width /2
			var end:Number = aMessageObject.stage.stageWidth/2
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "x", Regular.easeOut, start, end, .5, true))
			
			/* if (aMessageObject is DisplayObject)
			{
				var target:DisplayObject = DisplayObject(aMessageObject);
				var stage:Stage = Stage(target.stage);
				var rect:Rectangle = target.getBounds(target);
				
				var start:Number = (rect.width + rect.left) * -1;
				var end:Number = (stage.stageWidth - rect.width) / 2 + Math.abs(rect.left);
				
				aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "x", Regular.easeOut, start, end, .5, true));
			}	 */		
		}
		
		public override function applyTweenOut(aMessageObject:Object):void{
			var start:Number  = aMessageObject.x
			var end:Number = aMessageObject.stage.stageWidth + aMessageObject.width/2
			aMessageObject.activeTweenArray.push(new Tween(aMessageObject, "x", Regular.easeOut, start, end, .5, true))
		}
		
	}
}