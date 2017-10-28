// This class simply adds a waypoint based movement function to the ball blocker class.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{

	import flash.display.DisplayObject;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class MovingBlocker extends BallBlocker {
		protected var path:Array;
		protected var speed:Number;
		protected var curIndex:int;
		
		public function MovingBlocker() {
			curIndex = -1;
			speed = 4;
			super();
		}
		
		// Movement Functions
		
		protected function moveAlongPath(mp:AbstractParticle,hfacing:Boolean=false):void {
			if(mp == null || path == null) return;
			var pt_a:Vector;
			var pt_b:Vector;
			var dist:Number;
			var dv:Vector;
			// check if we have enough points for a line
			if(path.length > 1) {
				// star simulating motion along the path
				if(curIndex < 0) curIndex = 1; // make sure we have a valid starting point
				pt_a = mp.position;
				var len:Number = speed;
				do {
					pt_b = path[curIndex];
					dist = pt_b.distance(pt_a);
					// check distance between points
					if(dist >= 0) {
						if(dist < len) {
							// if our remaining movement is greater than this distance
							// spend movement to go on to the next set of points
							len -= dist;
							pt_a = pt_b;
							curIndex = (curIndex + 1) % path.length;
						} else {
							// if we don't have enough movement to go path this point,
							// get as close to the point as we can.
							dv = pt_b.minus(pt_a);
							mp.velocity = dv.mult(len/dist);
							len = 0;
						}
					} else break;
				} while(len > 0);
			} else {
				if(path.length > 0) {
					// check if we're close enough to snap to the point
					pt_a = mp.position;
					pt_b = path[0];
					dist = pt_b.distance(pt_a);
					if(dist > speed) {
						dv = pt_b.minus(pt_a);
						mp.position = pt_a.plus(dv.mult(speed/dist));
					} else mp.position = pt_b;
				}
			}
			// apply facing effect if applicable
			if(hfacing) {
				var dobj:DisplayObject = mp.sprite;
				if(mp.velocity.x * dobj.scaleX < 0) dobj.scaleX *= -1;
			}
		}
	}
	
}