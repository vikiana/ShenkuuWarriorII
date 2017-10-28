// This class handles all the game data and functions not specific to a single game level.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.util.input.KeyCommand;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	import com.neopets.util.general.MathUtils;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	import com.neopets.games.inhouse.pinball.SoundIDs;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class Flipper extends BallBlocker {
		// APEngine Variables
		protected var pivotCircle:CircleParticle;
		protected var tipCircle:CircleParticle; 
		protected var mainLine:SpringConstraint;
		protected var stopGroup:Group;
		protected var lowerStop:RectangleParticle;
		protected var upperStop:RectangleParticle;
		protected var tipRect:RectangleParticle;
		protected var tipSpring:SpringConstraint;
		protected var prevTipPosition:Vector;
		// Construction Variables
		protected var lowPoint:Vector;
		protected var peakPoint:Vector;
		protected var rimPoint:Vector;
		// Animation Variables
		protected var mainImage:DisplayObject;
		protected var angleOffset:Number;
		// Control System Variables
		protected var flipSpeed:Number;
		protected var trigger:KeyCommand;
		// shared variables
		protected static var flipFrames:Number = 4;
		protected static var maxSpeed:Number = 16;
		// Constants
		protected static const STOP_HEIGHT:Number = 64;
		protected static const REPULSION:Number = 8;
		
		// staring pionts
		protected var startingX:Number;
		protected var startingY:Number;
		
		
		public function Flipper() {
			super();
		}
		
		// Initialization functions
		

		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			// set up APEngine Group
			if(_group == null) {
				_group = new Group();
				// add our pivot
				pivotCircle = getPointPart("pivot_pt",true, 1, 0, 0);
				pivotCircle.addEventListener(CollisionEvent.COLLIDE,onCollision);
				addHiddenParticle(pivotCircle);
				// find our point markers
				lowPoint = getPoint("low_pt",false);
				peakPoint = getPoint("peak_pt",false);
				rimPoint = getPoint("rim_pt",false);
				// add a tip particle to our group
				tipCircle = createTip();
				if(tipCircle != null) {
					tipCircle.addEventListener(CollisionEvent.COLLIDE,onCollision);
					addHiddenParticle(tipCircle);
					prevTipPosition = tipCircle.position;
					// connect the tip to the pivot
					mainLine = new SpringConstraint(pivotCircle,tipCircle,1,true,2*pivotCircle.radius);
					mainLine.addEventListener(CollisionEvent.COLLIDE,onCollision);
					addHiddenConstraint(mainLine);
					// add a box to the tip to interrupt ball wrapping
					var side:Number = tipCircle.radius * 1.8; // set between 1.4 and 2 x radius
					tipRect = new RectangleParticle(tipCircle.px,tipCircle.py+0.1,side,side,Math.PI/4);
					addHiddenParticle(tipRect);
					tipSpring = new SpringConstraint(tipCircle,tipRect,1);
					addHiddenConstraint(tipSpring);
					// check for paddle art to animate
					if("img" in this) {
						mainImage = this["img"] as DisplayObject;
						if(mainImage != null) angleOffset = mainImage.rotation - flipperAngle;
					}
				}
				// add in stops to keep the flipper under control
				createStops();
			}
			// link controls to keyboard input
			if(trigger == null) {
				if(pivotCircle != null && tipCircle != null) {
					if(tipCircle.px > pivotCircle.px) trigger = _cabinet.game.getKey(GameShell.LEFT_CMD);
					else trigger = _cabinet.game.getKey(GameShell.RIGHT_CMD);
					enableUpdates();
				}
			}
		}
		
		protected function createTip():CircleParticle {
			if(pivotCircle == null || lowPoint == null || rimPoint == null) return null;
			var dx:Number = pivotCircle.px - rimPoint.x;
			var dy:Number = pivotCircle.py - rimPoint.y;
			startingX = lowPoint.x + dx
			startingY = lowPoint.y + dy
			return new CircleParticle(startingX,startingY,10,false,10,0,0);
		}
		
		protected function createStops():void {
			if(stopGroup == null) {
				stopGroup = new Group();
				// add lower stop
				var sw:Number = 3 * tipCircle.position.distance(pivotCircle.position);
				var hh:Number = STOP_HEIGHT / 2;
				var sy:Number = tipCircle.py + (pivotCircle.py - rimPoint.y) + hh;
				lowerStop = new RectangleParticle(pivotCircle.px,sy,sw,STOP_HEIGHT,0,true);
				addHiddenParticle(lowerStop,stopGroup);
				// add upper stop
				sy = peakPoint.y - hh;
				upperStop = new RectangleParticle(pivotCircle.px,sy,sw,STOP_HEIGHT,0,true);
				addHiddenParticle(upperStop,stopGroup);
				// make stops block the flipper
				stopGroup.addCollidable(_group);
				APEngine.addGroup(stopGroup);
				// set up the flipper speed
				flipSpeed = 34//Math.min((tipCircle.py - peakPoint.y) / flipFrames,maxSpeed);
			}
		}
		
		// Accessor Functions
		
		public function get flipperAngle():Number {
			var diff:Vector = tipCircle.position.minus(pivotCircle.position);
			var rad:Number = Math.atan2(diff.y,diff.x);
			return MathUtils.radiansToDegrees(rad);
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			// check if our key is being pressed
			if(trigger != null) {
				if(trigger.keyIsDown) 
				{
					if(tipCircle != null) 
					{
						tipCircle.velocity = new Vector(0,-flipSpeed);
						//To get to the gameEngine Area!
						//cabinet.game.controller.soundManager.soundPlay(SoundIDs.FLIPPER_RELEASE);
					}
				} else {
					if(tipCircle != null) 
					{
						//tipCircle.velocity =  new Vector(0,16);// new Vector(0,flipSpeed);
						tipCircle.px = startingX;
						tipCircle.py = startingY;
					}
				}
			}
			// update rotatation
			if(tipCircle != null) {
				if(mainImage != null) mainImage.rotation = flipperAngle + angleOffset;
				prevTipPosition = tipCircle.position;
			}
		}
		
		// Collision Functions
		
		// When something hits the bumper try to bounce it away.
		protected function onCollision(ev:CollisionEvent) {
			// don't apply force if the bumper is expended
			var surface:Object = ev.target;
			var collider:AbstractItem = ev.collidingItem;
			if(collider is CircleParticle) {
				trace("onCollision Flipper");
				var fvel:Vector = tipCircle.position.minus(prevTipPosition);
				var push:Number = REPULSION + fvel.magnitude();
				var cc:CircleParticle = collider as CircleParticle;
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
					var pos:Vector = cc.position;
					if(pos.distance(vec_a) < pos.distance(vec_b)) vec_c = vec_a.mult(REPULSION);
					else vec_c = vec_b.mult(push);
					// now that we have our rebound vector, apply that force
					cc.addForce(new VectorForce(true,vec_c.x,vec_c.y));
				} else {
					if(surface == tipCircle) {
						var cp:CircleParticle = surface as CircleParticle;
						var dv:Vector = cc.position.minus(cp.position);
						var r:Number = push / dv.magnitude();
						cc.addForce(new VectorForce(true,dv.x * r,dv.y * r));
					}
				}
			}
		}
		
	}
	
}