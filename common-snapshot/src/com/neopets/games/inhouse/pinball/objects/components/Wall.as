// Use this class to add a multi-segment wall to a cabinet part.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.components
{
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.util.events.CustomEvent;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class Wall extends EventDispatcher {
		protected var owner:CabinetPart;
		protected var group:Group;
		protected var prefix:String;
		protected var _points:Array;
		protected var _segments:Array;
		
		// The "ref" parameter is used to set the prefix property, which doubles as the wall's identifier.
		// The remaining parameters are passed on to buildWall
		public function Wall(ref:String,cab:CabinetPart=null,closed:Boolean=false,
							 grp:Group=null,elasticity:Number=0.3,friction:Number=0) {
			prefix = ref;
			owner = cab;
			group = grp;
			_segments = new Array();
			if(owner != null) buildWall(closed,elasticity,friction);
			else _points = new Array();
		}
		
		// Construction Functions
		
		// Use this function to connect points within the target movieclip with spring constraints.
		// "owner" is the name of the cabinet part where the points are located.
		// "closed" tells the function to connect the last point to the first one, making a closed loop.
		// "elasticity" and "friction" are passed into the owner's getPointParts function.
		// "grp" is the Group the particles should be added to.  If left null, the owner's default group is used.
		public function buildWall(closed:Boolean=false,elasticity:Number=0.3,friction:Number=0):void {
			if(owner == null) return;
			_points = owner.getPointParts(prefix,true,1,elasticity,friction);
			if(_points.length > 0) {
				// load first point
				var cp_a:CircleParticle = _points[0];
				cp_a.addEventListener(CollisionEvent.COLLIDE,onCollision);
				owner.addHiddenParticle(cp_a);
				// cycle through and connect the remaining points
				var cp_b:CircleParticle;
				for(var i:int = 1; i < _points.length; i++) {
					cp_b = points[i];
					cp_b.addEventListener(CollisionEvent.COLLIDE,onCollision);
					
					owner.addHiddenParticle(cp_b);
					linkPoints(cp_a,cp_b);
					cp_a = cp_b;
				}
				// if this is a closed wall, join the first and last points
				if(closed) {
					cp_b = _points[0];
					linkPoints(cp_a,cp_b);
				}
			}
		}
		
		// The class uses this function to connect two vertices with a spring constraint.
		protected function linkPoints(cp_a:CircleParticle,cp_b:CircleParticle) {
			if(cp_a != null && cp_b != null) {
				var spr:SpringConstraint = new SpringConstraint(cp_a,cp_b,1,true,cp_a.radius*2);
				spr.addEventListener(CollisionEvent.COLLIDE,onCollision);
				
				owner.addHiddenConstraint(spr,group);
				_segments.push(spr);
			}
		}
		
		// Walls can broadcast a collision event whenever any of their members are hit.
		protected function onCollision(ev:CollisionEvent):void
		{
			// Wrap the original collision data in a custom event so it's properties
			// aren't modified by dispatchEvent.
			dispatchEvent(new CustomEvent(ev,CollisionEvent.COLLIDE));
		}
		
		// Accessor Functions
		
		public function get id():String { return prefix; }
		
		public function get points():Array { return _points; }
		
		public function get segments():Array { return _segments; }
		
		public function get length():Number {
			var len:Number = 0;
			var spr:SpringConstraint;
			for(var i:int = 0; i < _segments.length; i++) {
				spr = _segments[i];
				len += spr.restLength;
			}
			return len;
		}
		
	}
	
}