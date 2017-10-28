// Moving Targets are a type of moving part that reacts when the ball get's close enough.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{

	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.Ball;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class MovingTarget extends MovingBlocker {
		protected var targetCircle:CircleParticle;
		protected var applyFacing:Boolean;
		// constants
		public static const SENSOR_RANGE:Number = 4;
		
		public function MovingTarget() {
			applyFacing = false;
			super();
		}
		
		protected function buildTargetFrom(ref:String):void {
			if(group != null) {
				targetCircle = getPointPart(ref);
				if(targetCircle != null) {
					targetCircle.addEventListener(CollisionEvent.COLLIDE,onCollision);
					_group.addParticle(targetCircle);
				}
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			moveAlongPath(targetCircle,applyFacing);
		}
		
		// This function is triggered when something hits the target.
		// This function will be overridden by most sub-classes.
		protected function onCollision(ev:CollisionEvent) {
		}
		
	}
}