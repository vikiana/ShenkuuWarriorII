// Use this class for objects that react when a ball get close enough to some of their walls.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{
	
	import com.neopets.games.inhouse.pinball.objects.Ball;
	import com.neopets.games.inhouse.pinball.objects.components.SpringSensor;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class ReactiveWall extends MultiWalled {
		protected var sensors:Array;
		// constants
		public static var SENSOR_RANGE:Number = 16;
		
		public function ReactiveWall() {
			sensors = new Array();
			super();
		}
		
		// Construction Functions
		
		// Use this function to set up sensors for all segments of a given wall.
		public function addSensorsToWall(ref:Object) {
			var wall:Object = getWall(ref);
			if(wall != null) {
				for(var i:int = 0; i < wall.segments.length; i++) addSensor(wall.segments[i]);
			}
		}
		
		// Use this function to try adding a new spring sensor.
		public function addSensor(spr:SpringConstraint) {
			// check if this sensor already exists
			for(var i:int = 0; i < sensors.length; i++) {
				if(sensors[i].spring == spr) return;
			}
			// if not, add it now
			sensors.push(new SpringSensor(spr));
		}
		
		// Sensor Functions
		
		// Use this function to check if any balls are near the sensor.
		public function get ballIsClose():Boolean {
			var lst:Array = _cabinet.parts;
			var part:Object;
			var ball:Ball;
			var cp:CircleParticle;
			var sensor:SpringSensor;
			var sd:Number;
			var j:int;
			// cycle through all sensors
			for(var i:int = 0; i < sensors.length; i++) {
				sensor = sensors[i];
				sd = SENSOR_RANGE + sensor.spring.rectHeight/2;
				// cycle through all balls
				for(j = 0; j < lst.length; j++) {
					part = lst[j];
					if(part is Ball) {
						ball = part as Ball;
						if(ball.zLayer == zLayer) {
							cp = ball.ballParticle;
							if(sensor.distanceTo(cp.position) <= sd + cp.radius) return true;
						}
					}
				} // end of ball loop
			} // end of sensor loop
			return false;
		}
		
		// Use this function to check which balls overlap which sensors.
		public function get collisionPredictions():Array {
			var preds:Array = new Array();
			var lst:Array = _cabinet.parts;
			var part:Object;
			var ball:Ball;
			var cp:CircleParticle;
			var sensor:SpringSensor;
			var sd:Number;
			var j:int;
			// cycle through all sensors
			for(var i:int = 0; i < sensors.length; i++) {
				sensor = sensors[i];
				sd = SENSOR_RANGE + sensor.spring.rectHeight/2;
				// cycle through all balls
				for(j = 0; j < lst.length; j++) {
					part  = lst[j];
					if(part is Ball) {
						ball = part as Ball;
						if(ball.zLayer == zLayer) {
							cp = ball.ballParticle;
							if(sensor.distanceTo(cp.position) <= sd + cp.radius) {
								preds.push({ball:ball,sensor:sensor});
							}
						}
					}
				} // end of parts loop
			} // end of sensor loop
			return preds;
		}
		
	}
}