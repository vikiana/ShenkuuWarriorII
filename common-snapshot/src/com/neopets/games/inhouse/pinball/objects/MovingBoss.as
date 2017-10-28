// The basic wall is just a cabinet part with a single wall component.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.MovingTarget;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class MovingBoss extends MovingTarget {
		protected var coolDown:int;
		protected var hits:int;
		protected var mainClip:MovieClip;
		protected var hitValue:Number;
		// constants
		public static const BASE_COOLDOWN:int = 16;
		
		public function MovingBoss() {
			hits = 0;
			coolDown = 0;
			hitValue = 20;
			super();
			applyFacing = true;
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group();
				buildTargetFrom("img_mc");
				path = getPoints("p",false);
				if("img_mc" in this) mainClip = this["img_mc"];
				enableUpdates();
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			if(coolDown <= 0) {
				moveAlongPath(targetCircle,applyFacing);
			} else {
				targetCircle.velocity = new Vector(0,0);
				coolDown--;
			}
		}
		
		// This function is triggered when something hits the target.
		protected override function onCollision(ev:CollisionEvent) {
			if(coolDown <= 0) {
				coolDown = BASE_COOLDOWN;
				cabinet.game.controller.playSound(SoundIDs.POWER_UP);
				// increase hit count
				hits++;
				cabinet.game.changeScoreBy(hitValue);
				// run hit animation
				if(mainClip != null) {
					if("onHit" in mainClip) mainClip.onHit();
					mainClip.gotoAndPlay("hit");
				}
				// check for max hits reached
				if(hits >= 3) {
					cabinet.game.controller.playSound(SoundIDs.WIN_BOSS);
					broadcast(new Event(GameShell.BOARD_FINISHED));
				}
			}
		}
		
	}
}