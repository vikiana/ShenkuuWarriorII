// Use spring sensors to handle collision prediction for spring constraints.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.components
{
	
	import com.neopets.games.inhouse.pinball.geom.LineSegment;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class SpringSensor extends LineSegment {
		protected var _spring:SpringConstraint;
		
		public function SpringSensor(spr:SpringConstraint=null) {
			spring = spr;
		}
		
		// Accessor Functions
		
		public function get spring():SpringConstraint { return _spring; }
		
		public function set spring(spr:SpringConstraint):void {
			_spring = spr;
			if(_spring != null) {
				// find end points
				var cv:Vector = _spring.center;
				var hl:Number = _spring.currLength / 2
				var dy:Number = Math.sin(_spring.radian) * hl;
				var dx:Number = Math.cos(_spring.radian) * hl;
				_pointA = new Vector(cv.x + dx,cv.y + dy);
				_pointB = new Vector(cv.x - dx,cv.y - dy);
				recalculate();
			}
		}
		
	}
	
}