// Moving Targets are a type of moving part that reacts when the ball get's close enough.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{

	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.Ball;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class ReactiveCircle extends BallBlocker {
		protected var mainCircle:CircleParticle;
		protected var sensorRadius:Number;
		// constants
		public static const SENSOR_RANGE:Number = 16;
		
		protected function buildCircleFrom(ref:String):void {
			sensorRadius = SENSOR_RANGE;
			if(group != null) {
				mainCircle = getPointPart(ref,true);
				if(mainCircle != null) {
					sensorRadius += mainCircle.radius;
					_group.addParticle(mainCircle);
				}
			}
		}
		
		protected function buildHiddenCircleFrom(ref:String):void {
			sensorRadius = SENSOR_RANGE;
			if(group != null) {
				mainCircle = getPointPart(ref,true);
				if(mainCircle != null) {
					sensorRadius += mainCircle.radius;
					addHiddenParticle(mainCircle);
				}
			}
		}
		
		// Game Cycle Functions
		
		// Call this function to check if any balls are close enough that collision is likely.
		protected function checkBalls():void {
			if(mainCircle != null) {
				var part:Object;
				var ball:Ball;
				var cp:CircleParticle;
				var dist:Number;
				// cycle through all balls
				var lst:Array = _cabinet.parts;
				for(var i:int = 0; i <  lst.length; i++) {
					part = lst[i];
					if(part is Ball) {
						ball = part as Ball;
						if(ball.zLayer == zLayer) {
							cp = ball.ballParticle;
							dist = cp.position.distance(mainCircle.position);
							if(dist <= sensorRadius + cp.radius) onBallClose(ball);
						}
					} //  end of part type check
				} // end of ball loop
			} // end of particle check
		}
		
		// This function is triggered when any ball get close enough for a potential collision 
		// with our target area.
		// This function will be overridden by most sub-classes.
		protected function onBallClose(ball:Ball) {
		}
		
	}
}