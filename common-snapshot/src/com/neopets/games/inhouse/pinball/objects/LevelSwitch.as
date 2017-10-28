// Hit all switches of this type in a level to beat the level.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.ReactiveWall;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class LevelSwitch extends ReactiveWall {
		protected var _active:Boolean;
		protected var otherSwitches:Array;
		protected var mainClip:MovieClip;
		protected var lights:MovieClip;
		protected var hitValue:Number;
		
		public function LevelSwitch() {
			_active = true;
			otherSwitches = new Array();
			hitValue = 20;
			super();
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				addWall("p");
				addWall("r");
				addSensorsToWall("r");
				enableUpdates();
			}
			// check for our main animation clip
			if("img_mc" in this) mainClip = this["img_mc"];
			// check for linked lights.
			if("lights_mc" in this) lights = this["lights_mc"];
		}
		
		// Accessor Functions
		
		public function get isActive():Boolean { return _active; }
		
		public function set isActive(b:Boolean) {
			if(_active != b) {
				_active = b;
				if(b) {
					// update art
					if(mainClip != null) mainClip.gotoAndPlay("on");
					if(lights != null) lights.gotoAndPlay(1);
				} else {
					cabinet.game.changeScoreBy(hitValue);
					// update art
					if(mainClip != null) mainClip.gotoAndPlay("off");
					if(lights != null) lights.gotoAndStop(1);
					// if this was the last active switch, end the level
					for(var i:int = 0; i < otherSwitches.length; i++) {
						if(otherSwitches[i].isActive) return;
					}
					broadcast(new Event(GameShell.BOARD_FINISHED));
				}
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			// don't react if the switch is already off
			if(_active) {
				// if the ball gets close enough, flip the switch
				if(ballIsClose) isActive = false;
			}
		}
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		public override function checkInteractionsFor(other:CabinetPart):void {
			// we can collide with any other balls in the same zLayer
			if(other is Ball) {
				if(_group != null && other.group != null) {
					if(other.zLayer == zLayer) addCollidable(_group,other.group);
					else _group.removeCollidable(other.group);
				}
			} else {
				// note any other switches in this cabinet
				if(other is LevelSwitch) {
					if(otherSwitches.indexOf(other) < 0) otherSwitches.push(other);
				}
			} // end of type checking
		}
		
	}
}