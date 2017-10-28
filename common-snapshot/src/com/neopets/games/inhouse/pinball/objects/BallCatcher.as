// Ball Catchers hold onto any balls that fall into it for a little while before popping them back out.
// They also open ball bins, allowing multiple balls to enter play.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class BallCatcher extends CabinetPart {
		protected var wall:Wall;
		protected var centerPoint:Vector;
		protected var rimPoint:Vector;
		protected var exitPoint:Vector;
		protected var exitVelocity:Vector;
		protected var radius:Number;
		protected var heldBall:Ball;
		protected var exitTime:int;
		protected var hitValue:Number;
		// constants
		public static var HOLD_TIME:int = 5000;
		public static var EXIT_SPEED:int = 8;
		
		public function BallCatcher() {
			radius = -1;
			hitValue = 5;
			super();
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				// set up our walls, if any
				wall = new Wall("p",this,true);
				// set up our tracking points
				centerPoint = getPoint("center_pt",false);
				rimPoint = getPoint("rim_pt",false);
				if(centerPoint != null && rimPoint != null) {
					radius = centerPoint.distance(rimPoint);
					// set up our exit point 2 pixels past our rim
					exitPoint = new Vector(centerPoint.x,centerPoint.y);
					var r:Number = (radius + 2) / radius;
					var dx:Number = rimPoint.x - centerPoint.x;
					var dy:Number = rimPoint.y - centerPoint.y;
					exitPoint.x += dx * r;
					exitPoint.y += dy * r;
					// setp our exit velocity based on whereour rim point is
					r = EXIT_SPEED / radius;
					exitVelocity = new Vector(dx * r,dy * r);
				} else radius = -1;
				// start the updater
				enableUpdates();
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			if(radius < 0) return; // abort if not fully initialized
			// check if a ball is in the pit
			if(heldBall == null) {
				// if not, try to catch any ball the goes past our rim
				var part:Object;
				var ball:Ball;
				var lst:Array = _cabinet.parts;
				for(var i:int = 0; i < lst.length; i++) {
					part = lst[i];
					if(part is Ball) {
						ball = part as Ball;
						if(ball.zLayer == zLayer) {
							if(ball.ballParticle.position.distance(centerPoint) < radius) {
								// move the ball into storage
								cabinet.game.controller.playSound(SoundIDs.TARGET_BIG_WHOOSH);	
								trace("Ball SOUND");
								ball.zLayer = LOWER_LAYER;
								heldBall = ball;
								exitTime = getTimer() + HOLD_TIME;
								cabinet.game.changeScoreBy(hitValue);
								broadcast(new Event(GameShell.OPEN_BIN));
								break;
							}
						}
					}
				} // end of ball loop
			} else {
				// check if it's time to pop the ball out yet
				if(exitTime < getTimer()) {
					cabinet.game.controller.playSound(SoundIDs.LOSE_BALL);	
					heldBall.ballParticle.position = exitPoint;
					heldBall.ballParticle.velocity = exitVelocity;
					heldBall.zLayer = zLayer;
					heldBall = null;
				} else {
					// keep the ball fixed over our center point
					heldBall.ballParticle.position = centerPoint;
				}
			}
		}
		
	}
}