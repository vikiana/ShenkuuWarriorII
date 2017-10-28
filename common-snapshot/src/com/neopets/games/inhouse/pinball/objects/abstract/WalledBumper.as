// This class handles bumpers made of flat surfaces.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.util.events.CustomEvent;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	public class WalledBumper extends MultiWalled {
		protected var mainClip:MovieClip;
		protected var reboundMin:Number;
		protected var reboundRange:Number;
		protected var hitValue:Number = 5;	//TEMP
		
		public function WalledBumper() {
			setRebound(260,360);
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
		
		// Listener Functions
		
		// When something hits the bumper try to bounce it away.
		protected function onCollision(ev:CustomEvent) {
			// don't apply force if the bumper is expended
			
			trace("onCollision WalledBumper");
			
			playAssignedSound();
			cabinet.game.changeScoreBy(hitValue);
			
			if(mainClip.currentFrame <= 1) {
				var surface:Object = ev.oData.target;
				var collider:AbstractParticle = ev.oData.collidingItem;
				if(surface is SpringConstraint) {
					var spr:SpringConstraint = surface as SpringConstraint;
					// build first projection
					var angle_a:Number = spr.radian + Math.PI / 2;
					var vec_a:Vector = new Vector(Math.cos(angle_a),Math.sin(angle_a));
					var proj_a:Vector = spr.center.plus(vec_a);
					// build second projection
					var angle_b:Number = angle_a + Math.PI;
					var vec_b:Vector = new Vector(Math.cos(angle_b),Math.sin(angle_b));
					var proj_b:Vector = spr.center.plus(vec_b);
					// use the projection closest to the collider
					var vec_c:Vector;
					var pos:Vector = collider.position;
					if(pos.distance(vec_a) < pos.distance(vec_b)) vec_c = vec_a.mult(getRebound());
					else vec_c = vec_b.mult(getRebound());
					// now that we have our rebound vector, apply that force
					collider.addForce(new VectorForce(true,vec_c.x,vec_c.y));
				} else {
					if(surface is CircleParticle) {
						var cp:CircleParticle = surface as CircleParticle;
						var dv:Vector = collider.position.minus(cp.position);
						var r:Number = getRebound() / dv.magnitude();
						collider.addForce(new VectorForce(true,dv.x * r,dv.y * r));
					}
				}
				// run our bumper animation
				mainClip.gotoAndPlay(2);
			}
		}
		
		/**
		 * @NOTE: This is to be OVERRIDED in the Child Classes, This is mostly for Sound PlayBackS
		 */
		 
		protected function playAssignedSound():void
		{
			cabinet.game.controller.playSound(SoundIDs.BUMPER_SND1);	
		}
		
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