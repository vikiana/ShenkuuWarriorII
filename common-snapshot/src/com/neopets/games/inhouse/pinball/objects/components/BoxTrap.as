// BoxTraps store incoming balls by hiding them under the surface.  Only one side of box is left open.
// Balls coming in from any other sides will bounce off the box's walls.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.components
{
	
	import flash.utils.getTimer;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class BoxTrap extends Wall {
		// public variables
		public var zLayer:int;
		public var captureLayer:int;
		public var ballsVisible:Boolean;
		public var exitSpeed:Number;
		public var upSpeed:Number; // boosts upward exit velocity
		public var speedVariance:Number;
		// protected variables
		protected var sensor:SpringSensor;
		protected var balls:Array;
		protected var pendingReleases:Array;
		protected var sine:Number;
		protected var cosine:Number;
		
		public function BoxTrap(ref:String,owner:CabinetPart=null,grp:Group=null,elasticity:Number=0.3,friction:Number=0) {
			// initialize variables
			zLayer = CabinetPart.GROUND_LAYER;
			captureLayer = CabinetPart.LOWER_LAYER;
			ballsVisible = false;
			exitSpeed = 8;
			upSpeed = 8;
			speedVariance = 1;
			balls = new Array();
			pendingReleases = new Array();
			super(ref,owner,false,grp,elasticity,friction);
			// if there are enough points, set up our sensor line
			if(_points.length > 1) {
				var li:int = _points.length - 1;
				var spr:SpringConstraint = new SpringConstraint(_points[0],_points[li]);
				owner.addHiddenConstraint(spr);
				sensor = new SpringSensor(spr);
				if(points.length > 3) {
					var dist:Number = _points[0].position.distance(_points[1].position);
					sine = (_points[0].py - _points[1].py) / dist;
					cosine = (_points[0].px - _points[1].px) / dist;
				} else {
					sine = -1;
					cosine = 0;
				}
			}
		}
		
		// Ball Handling Functions
		
		// Use this function to try capturing a ball.  This function return true if the ball is 
		// captured and false if it isn't.
		public function catchBall(ball:Ball):Boolean {
			if(sensor == null) return false; // we can't check without a sensor
			if(ball == null) return false; // we can't catch what's not there
			if(ball.zLayer != zLayer) return false; // don't catch anything on a different layer
			if(balls.indexOf(ball) >= 0) return true; // no need to check if we already caught it
			// if we've gotten this far, check the sensor
			var cp:CircleParticle = ball.ballParticle;
			if(sensor.distanceTo(cp.position) <= points[0].radius + cp.radius) {
				storeBall(ball);
				return true;
			} else return false;
		}
		
		public function storeBall(ball:Ball):void {
			if(ball == null) return;
			if(balls.indexOf(ball) >= 0) return;
			// move the ball into it's capture location
			ball.zLayer = captureLayer;
			ball.ballParticle.sprite.visible = ballsVisible;
			balls.push(ball);
		}
		
		// Use this function to return a captured ball to play.
		public function releaseBall(ball:Ball):void {
			var dist:Number;
			var cp:CircleParticle;
			var vec:Vector;
			if(balls.indexOf(ball) >= 0) {
				cp = ball.ballParticle;
				// move the ball into the right position
				dist = points[0].radius + cp.radius + 2;
				vec = new Vector(cosine * dist,sine * dist); // get the displacement vector
				cp.position = sensor.spring.center.plus(vec);
				// redirect the balls velocity
				vec.x = exitSpeed * (cosine + speedVariance * (Math.random() - 0.5));
				vec.y = exitSpeed * (sine + speedVariance * (Math.random() - 0.5));
				if(sine < 0) vec.y += sine * upSpeed;
				cp.velocity = vec;
				// put the ball back into play
				ball.zLayer = zLayer
				cp.sprite.visible = true;
				removeBall(ball);
			}
		}
		
		// Use this function to move a ball between catchers.
		public function transferBall(ball:Ball,other:BoxTrap):void {
			removeBall(ball);
			other.addBall(ball);
		}
		
		// Use this function to add a ball to our list if it's not already there.
		// This should only be used for transfers between boxtraps.  For other additions,
		// use storeBall.
		protected function addBall(ball:Ball):void {
			if(balls.indexOf(ball) >= 0) return;
			balls.push(ball);
		}
		
		// Use this function to remove a ball from our list.
		protected function removeBall(ball:Ball):void {
			var i:int = balls.indexOf(ball);
			if(i >= 0) balls.splice(i,1);
		}
		
		// Timed Functions
		
		public function releaseBallAfter(ball:Ball,sec:Number):void {
			// check if the event already exists
			var fuse:Object;
			for(var i:int = 0; i < pendingReleases.length; i++) {
				fuse = pendingReleases[i];
				if(fuse.ball == ball) return;
			}
			// if not, add it now
			var et:int = getTimer() + Math.round(sec*1000);
			pendingReleases.push({ball:ball,time:et});
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		public function update():void  {
			// make sure our balls don't go anywhere
			if(sensor != null) {
				var ball:Ball;
				for(i = 0; i < balls.length; i++) {
					ball = balls[i];
					ball.position = sensor.spring.center;
				}
			}
			// check if any of our pending releases are done
			var ct:int = getTimer();
			var fuse:Object;
			for(var i:int = pendingReleases.length - 1; i >= 0; i--) {
				fuse = pendingReleases[i];
				if(fuse.time <= ct) {
					releaseBall(fuse.ball);
					// remove the scheduled event
					pendingReleases.splice(i,1);
				}
			}
		}
		
	}
	
}