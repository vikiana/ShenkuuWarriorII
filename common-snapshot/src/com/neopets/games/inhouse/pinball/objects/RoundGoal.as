// This class handles circular bumpers that animate when hit.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class RoundGoal extends BallBlocker {
		protected var mainCircle:CircleParticle;
		protected var mainClip:MovieClip;
		protected var coolDown:int;
		protected var hits:int;
		public var isOpen:Boolean;
		protected var hitValue:Number;
		// constants
		public static const BASE_COOLDOWN:int = 16;
		
		public function RoundGoal() {
			hits = 0;
			coolDown = 0;
			isOpen = true;
			hitValue = 20;
			super();
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
				if("img_mc" in this) mainClip = this["img_mc"];
				// turn on updates
				enableUpdates();
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			if(coolDown > 0) coolDown--;
		}
		
		// Listener Functions
		
		// When something hits the bumper try to bounce it away.
		protected function onCollision(ev:CollisionEvent) {
			if(coolDown <= 0) {
				coolDown = BASE_COOLDOWN;
				cabinet.game.controller.playSound(SoundIDs.POWER_UP);
				cabinet.game.changeScoreBy(hitValue);
				hits++;
				// run hit animation
				if(mainClip != null) {
					if("onHit" in mainClip) mainClip.onHit();
					mainClip.gotoAndPlay("hit");
				}
				// check for max hits reached
				if(hits >= 3) 
				{
					cabinet.game.controller.playSound(SoundIDs.WIN_BOSS);
					broadcast(new Event(GameShell.BOARD_FINISHED));
				}
			}
		}
		
	}
}