// This class handles circular bumpers that animate when hit.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class RoundBumper extends BallBlocker {
		protected var mainCircle:CircleParticle;
		protected var mainClip:MovieClip;
		protected var hitValue:Number;
		protected var reboundMin:Number;
		protected var reboundRange:Number;
		// constants
		public static const BASE_VALUE:Number = 25;
		
		public function RoundBumper() {
			setRebound(260,360);
			hitValue = 5; // set default value
			super();
		}
		
		// Accessor Functions
		
		public function setRebound(min:Number,max:Number) {
			reboundMin = min;
			reboundRange = max - min;
		}
		
		public function getRebound():Number {
			return reboundMin + Math.random() * reboundRange;
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				// build bounding circle
				mainCircle = getPointPart("bounds_mc",true);
				mainCircle.addEventListener(CollisionEvent.COLLIDE,onCollision);
				addHiddenParticle(mainCircle);
				// check for animation clip
				if("img_mc" in this) {
					mainClip = this["img_mc"];
					hitValue = Math.ceil(BASE_VALUE*mainClip.totalFrames/mainCircle.radius);
				}
				// turn on game cycle updates
				enableUpdates();
			}
			if(mainClip != null) mainClip.gotoAndStop(1);
		}
		
		// Listener Functions
		
		// When something hits the bumper try to bounce it away.
		protected function onCollision(ev:CollisionEvent) {
			
			cabinet.game.controller.playSound(SoundIDs.BUMPER_SCIFI);
			cabinet.game.changeScoreBy(hitValue);
			
			// don't apply force if the bumper is expended
			if(mainClip.currentFrame <= 1) {
				var surface:Object = ev.target;
				var collider:Object = ev.collidingItem;
				if(surface is CircleParticle) {
					var cp:CircleParticle = surface as CircleParticle;
					var dv:Vector = collider.position.minus(cp.position);
					var r:Number = getRebound() / dv.magnitude();
					collider.addForce(new VectorForce(true,dv.x * r,dv.y * r));
				}
				// run our bumper animation
				mainClip.gotoAndPlay(2);
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			if(mainClip == null) return;
			// check if the bumper is animation
			if(mainClip.currentFrame > 1) {
				// check if we've reached the end of the animation.
				if(mainClip.currentFrame >= mainClip.totalFrames) mainClip.gotoAndStop(1);
			}
		}
		
	}
}