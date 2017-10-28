// This class handles cabinet components that consist of one or more immobile, segmented lines.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{
	
	import flash.display.MovieClip;
	import com.neopets.util.array.ArrayUtils;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class MultiWalled extends BallBlocker {
		// APEngine Variables
		protected var walls:Array;
		
		public function MultiWalled() {
			walls = new Array();
			super();
		}
		
		// Construction Functions
		
		// This function looks for a named series of points in the movie clip and tries to 
		// connect them with solid SpringConstraint.
		// "ref" is the shared name of the point set.  The remaining parameters are taken
		// from the SpringConstraint constructor.
		protected function addWall(ref:String,closed:Boolean=false,grp:Group=null,
								   elasticity:Number=0.3,friction:Number=0):Wall {
			var wall:Wall;
			// check if this wall already exists
			for(var i:int = 0; i < walls.length; i++) {
				wall = walls[i];
				if(wall.id == ref) return wall;
			}
			// if not, create a new wall
			wall = new Wall(ref,this,closed,grp,elasticity,friction);
			walls.push(wall);
			return wall;
		}
		
		// Use this function to attach two vertices with a spring constraint.
		// "ref1" is the index or id of the first wall while "pi1" is the vertex index of the first point.
		// "ref2" is the index or id of the second wall while "pi2" is the vertex index of the second point.
		public function connectPoints(ref1:Object,pi1:int,ref2:Object,pi2:int):SpringConstraint {
			var cp_a:CircleParticle = getVertex(ref1,pi1);
			var cp_b:CircleParticle = getVertex(ref2,pi2);
			if(cp_a != null && cp_b != null) {
				var spr:SpringConstraint = new SpringConstraint(cp_a,cp_b,1,true,cp_a.radius*2);
				addHiddenConstraint(spr);
				return spr;
			} else return null;
		}
		
		// Accessor Functions
		
		// Use this function to fetch a wall entry by either it's index or it's identifier.
		public function getWall(ref:Object):Object {
			var i:int;
			if(ref is String) {
				var wall:Object;
				for(i = 0; i < walls.length; i++) {
					wall = walls[i];
					if(wall.id == ref) return wall;
				}
			} else {
				if(ref is int) {
					i = ArrayUtils.getValidIndex(ref as int,walls);
					return walls[i];
				}
			}
			return null;
		}
		
		// Use this function to get one of the points used to make a given wall.
		// "ref" is the wall index or id and "pi" is the index of circle particle within that wall.
		public function getVertex(ref:Object,pi:int):CircleParticle {
			if(walls.length > 0) {
				var wall:Object = getWall(ref);
				if(wall != null) {
					var pts:Array = wall.points;
					if(pts.length > 0) {
						pi = ArrayUtils.getValidIndex(pi,pts);
						return pts[pi];
					}
				}
			}
			return null;
		}
		
		// Use this function to get one of the line segments that make up a given wall.
		// "wi" is the wall index or id and "si" is the index of spring constraint within that wall.
		public function getSegment(ref:Object,si:int):SpringConstraint {
			if(walls.length > 0) {
				var wall:Object = getWall(ref);
				if(wall != null) {
					var segs:Array = wall.segments;
					if(segs.length > 0) {
						si = ArrayUtils.getValidIndex(si,segs);
						return segs[si];
					}
				}
			}
			return null;
		}
		
	}
}