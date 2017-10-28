// The launcher chute is a closed tunnel that holds the ball in the launch area.
// This class also set up the blocking rectangle for the side bar and has code 
// for checking when the ball have left the launch area.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class LauncherChute extends CabinetPart {
		protected var wall:Wall;
		protected var upperRect:RectangleParticle;
		protected var lowerRect:RectangleParticle;
		protected var baseGroup:Group;
		protected var baseRect:RectangleParticle;
		protected var leftEdge:Number;
		protected var exitRect:Rectangle;
		protected var flipper:Flipper;
		
		public function LauncherChute() {
			super();
			zLayer = LAUNCH_LAYER;
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				wall = new Wall("p",this);
				// extend upper wall
				var pts:Array = wall.points;
				var cp:CircleParticle = pts[0];
				var rw:Number;
				var ry:Number;
				if(cp != null) {
					rw = 2 * cp.radius;
					ry = cp.py / 2;
					upperRect = new RectangleParticle(cp.px,ry,rw,cp.py,0,true,1,0.5,0);
					addHiddenParticle(upperRect);
				}
				// extend lower wall
				cp = pts[pts.length-1];
				var rh:Number;
				if(cp != null) {
					rw = 2 * cp.radius;
					ry = (cp.py + GameShell.SCREEN_HEIGHT) / 2;
					rh = GameShell.SCREEN_HEIGHT - cp.py;
					lowerRect = new RectangleParticle(cp.px,ry,rw,rh,0,true,1,0.5,0);
					addHiddenParticle(lowerRect);
					// add the base the launcher rests on
					baseGroup = new Group();
					leftEdge = cp.px - cp.radius;
					var rx:Number = (leftEdge + GameShell.SCREEN_WIDTH) / 2;
					rw = GameShell.SCREEN_WIDTH - leftEdge;
					baseRect = new RectangleParticle(rx,GameShell.SCREEN_HEIGHT/2,rw,GameShell.SCREEN_HEIGHT,0,true,1,0.5,0);
					addHiddenParticle(baseRect,baseGroup);
					APEngine.addGroup(baseGroup);
				}
				// add our exit area clip if applicable
				if("exit_mc" in this) {
					var emc:MovieClip = this["exit_mc"] as MovieClip;
					exitRect = emc.getRect(_cabinet);
					emc.visible = _cabinet.game.showWires;
				}
				enableUpdates();
			}
		}
		
		// Removal Functions
		
		// Put the object's clean up code here.
		protected override function onRemoval():void  {
			if(baseGroup != null) APEngine.removeGroup(baseGroup);
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			// cycle through all balls
			var ball:Ball;
			var cp:CircleParticle;
			var part:Object;
			var lst:Array = _cabinet.parts;
			for(var i:int = 0; i < lst.length; i++) {
				part = lst[i];
				if(part is Ball) {
					ball = part as Ball;
					if(ball.zLayer == _zLayer) {
						if(particleIsOutside(ball.ballParticle)) {
							ball.resetPoint = ball.ballParticle.position;
							if(flipper != null) ball.moveToLayerOf(flipper);
							else ball.zLayer = GROUND_LAYER;
						}
					}
				} // end of ball check
			} // end of part loop
		}
		
		// Use this function to check if an APEngine particle is out of bounds.
		public function particleIsOutside(pt:AbstractParticle) {
			if(pt.py < 0 || pt.py > GameShell.SCREEN_HEIGHT) return true;
			if(pt.px > GameShell.SCREEN_WIDTH) return true;
			if(pt.px < leftEdge) {
				if(exitRect != null) {
					if(pt.py < exitRect.top || pt.py > exitRect.bottom) return true;
					if(pt.px < exitRect.left) return true;
					else return false;
				} else return true;
			}
			return false;
		}
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		public override function checkInteractionsFor(other:CabinetPart):void {
			// we can collide with any other balls in the same zLayer
			if(other is Ball) {
				// The pit is only collidable if the ball is under ground level
				if(_group != null && other.group != null) {
					if(other.zLayer == zLayer) {
						addCollidable(_group,other.group);
						baseGroup.removeCollidable(other.group);
					} else {
						_group.removeCollidable(other.group);
						if(other.zLayer < _zLayer) addCollidable(baseGroup,other.group);
						else baseGroup.removeCollidable(other.group);
					}
				}
			} else {
				// track at least one flipper so we can move balls to it's drawing layer
				if(other is Flipper) flipper = other as Flipper;
			}
		}
		
	}
}