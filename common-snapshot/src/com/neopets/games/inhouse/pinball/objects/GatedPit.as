// The launcher chute is a closed tunnel that holds the ball in the launch area.
// This class also set up the blocking rectangle for the side bar and has code 
// for checking when the ball have left the launch area.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	import com.neopets.games.inhouse.pinball.objects.components.SpringSensor;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class GatedPit extends CabinetPart {
		protected var gateGroup:Group;
		protected var wall:Wall;
		protected var gate:Wall;
		protected var sensors:Array;
		protected var exitPoint:Vector;
		protected var heldBalls:Array;
		
		public function GatedPit() {
			heldBalls = new Array();
			sensors = new Array();
			super();
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				// build our back wall
				_group = new Group();
				wall = new Wall("p",this);
				// build our gate
				gateGroup = new Group();
				gate = new Wall("g",this,false,gateGroup);
				if(gate != null) {
					for(var i:int = 0; i < gate.segments.length; i++) addSensor(gate.segments[i]);
				}
				// get our exit point
				exitPoint = getPoint("exit_mc",false);
			}
		}
		
		// Construction Functions
		
		// Use this function to try adding a new spring sensor.
		public function addSensor(spr:SpringConstraint) {
			// check if this sensor already exists
			for(var i:int = 0; i < sensors.length; i++) {
				if(sensors[i].spring == spr) return;
			}
			// if not, add it now
			sensors.push(new SpringSensor(spr));
		}
		
		// Accessor Functions
		
		public function get isOpen():Boolean {
			return (_zLayer == LOWER_LAYER);
		}
		
		public function set isOpen(b:Boolean) {
			if(b) {
				zLayer = LOWER_LAYER; // lower the gate
			} else  {
				zLayer = GROUND_LAYER; // close the gate
				releaseBalls();
			}
		}
		
		// Ball Handling Functions
		
		public function releaseBalls() {
			if(heldBalls == null || exitPoint == null) return;
			// empty the ball array
			var ball:Ball;
			while(heldBalls.length > 0) {
				ball = heldBalls.pop();
				ball.ballParticle.position = exitPoint;
				// randomize position in case there's multiple balls exiting
				ball.ballParticle.px += 4 * (Math.random() - 0.5);
				ball.zLayer = GROUND_LAYER;
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			// only check for balls if the gate is open
			if(_zLayer == LOWER_LAYER) {
				var part:Object;
				var ball:Ball;
				var lst:Array = _cabinet.parts;
				var j:int;
				for(var i:int = 0; i < lst.length; i++) {
					part = lst[i];
					if(part is Ball) {
						ball = part as Ball;
						if(ball.zLayer == GROUND_LAYER) {
							for(j = 0; j < sensors.length; j++) {
								if(sensors[j].intersects(ball.path)) {
									heldBalls.push(ball);
									//############### ADD SOUND PLAYBACK
									ball.zLayer = LOWER_LAYER;
								}
							} // end of sensor loop
						}
					} // end of type check
				} // end of part loop
			} // end of state check
		}
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		public override function checkInteractionsFor(other:CabinetPart):void {
			// we can collide with any other balls in the same zLayer
			if(other is Ball) {
				if(_group != null && other.group != null) {
					if(_zLayer == GROUND_LAYER) {
						// the gate is up
						if(other.zLayer == GROUND_LAYER || other.zLayer == LOWER_LAYER) {
							addCollidable(_group,other.group);
							addCollidable(gateGroup,other.group);
						} else {
							_group.removeCollidable(other.group);
							gateGroup.removeCollidable(other.group);
						}
					} else {
						// the gate is down
						if(other.zLayer == GROUND_LAYER) {
							addCollidable(_group,other.group);
							gateGroup.removeCollidable(other.group);
						} else {
							if(other.zLayer == LOWER_LAYER) {
								addCollidable(_group,other.group);
								addCollidable(gateGroup,other.group);
							} else {
								_group.removeCollidable(other.group);
								gateGroup.removeCollidable(other.group);
							}
						}
					}
				}
			}
		}
		
	}
	
}