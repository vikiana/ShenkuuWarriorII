// This clip gathers up all the balls initially on the stage and releases them as needed.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class BallBin extends BallBlocker {
		protected var wall:Wall;
		protected var launcher:Launcher;
		protected var entryVector:Vector;
		protected var entryPath:Vector;
		protected var exitPoint:Vector;
		protected var exitRadius:Number;
		protected var isOpen:Boolean;
		
		public function BallBin() {
			isOpen = false;
			super();
			zLayer = BIN_LAYER;
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				wall = new Wall("p",this);
			}
			// set up entry
			var pts:Array = wall.points;
			var cp_a:CircleParticle = pts[0];
			var cp_b:CircleParticle = pts[pts.length-1];
			if(cp_a != null && cp_b != null) {
				entryVector = new Vector((cp_a.px + cp_b.px)/2,(cp_a.py + cp_b.py)/2);
				cp_b = pts[1];
				if(cp_b != null) entryPath = cp_b.position.minus(cp_a.position);
				else entryPath = new Vector(0,height/2);
			} else {
				var bb:Rectangle = getRect(_cabinet);
				entryVector = new Vector((bb.left + bb.right)/2,(bb.top + bb.bottom)/2);
				entryPath = new Vector(0,bb.height/2);
			}
			// set up exit
			exitPoint = getPoint("exit_pt",_cabinet.game.showWires);
			if(exitPoint == null) {
				// find the two lowest points
				cp_a = null;
				cp_b = null;
				var cp:CircleParticle;
				for(var i:int = 0; i < pts.length; i++) {
					cp = pts[i];
					if(cp_a != null) {
						if(cp.py > cp_a.py) {
							cp_b = cp_a;
							cp_a = cp;
						} else {
							if(cp.py > cp_b.py) cp_b = cp;
						}
					} else {
						cp_a = cp;
						cp_b = cp;
					}
				}
				exitPoint = new Vector((cp_a.px + cp_b.px)/2,(cp_a.py + cp_b.py)/2 - 16);
			}
			if("exit_pt" in this) exitRadius = this["exit_pt"].width / 2;
			else exitRadius = 8;
			// set up cabinet listeners
			_cabinet.addEventListener(GameShell.BALL_LEFT_PLAY,onBallLost);
			_cabinet.addEventListener(GameShell.OPEN_BIN,onOpenBin);
			// wait 1 frame to gather balls so they have time to register
			addEventListener(Event.ENTER_FRAME,afterAddedToGame);
			enableUpdates();
		}
		
		// This function handles initialization that happen one frame after the
		// bin has been added to the game.
		protected function afterAddedToGame(ev:Event=null):void {
			// search the part list for balls
			var balls:Array = new Array();
			var lst:Array = _cabinet.parts;
			var part:Object;
			for(var i:int = 0; i < lst.length; i++) {
				part = lst[i];
				if(part is Ball) balls.push(part);
			}
			// calculate the distane between balls
			var div:Number = balls.length + 1;
			var dx:Number = entryPath.x / div;
			var dy:Number = entryPath.y / div;
			// move all balls into the bin
			var px:Number = entryVector.x + dx;
			var py:Number = entryVector.y + dy;
			var ball:Ball;
			var cp:CircleParticle;
			for(i = 0; i < balls.length; i++) {
				ball = balls[i];
				cp = ball.ballParticle;
				ball.zLayer = zLayer;
				cp.px = px;
				cp.py = py;
				// set up next ball position
				px += dx;
				py += dy;
			}
			// this function should only trigger once
			removeEventListener(Event.ENTER_FRAME,afterAddedToGame);
			// open the bin so it can spit out a ball next update
			isOpen = true;
		}
		
		// Removal Functions
		
		// Put the object's clean up code here.
		protected override function onRemoval():void  {
			_cabinet.removeEventListener(GameShell.BALL_LEFT_PLAY,onBallLost);
			_cabinet.removeEventListener(GameShell.OPEN_BIN,onOpenBin);
		}
		
		// Listener Functions
		
		// When this event triggers, the bin checks to see if there are any balls left.
		// If there are, it will pop out that ball.  If not, the level ends.
		protected function onBallLost(ev:Event):void {
			// check if there are any balls still in play
			var ball:Ball;
			var part:Object;
			var lst:Array = _cabinet.parts;
			var br:int = 0; // track balls still in the bin
			for(var i:int = 0; i < lst.length; i++) {
				part = lst[i];
				if(part is Ball) {
					ball = part as Ball;
					if(ball.isInPlay) return; // don't do anything if there's a ball in play
					
					/* PLAY SOUND FILE */
					_cabinet.game.controller.playSound(SoundIDs.LOSE_BALL);
					
					if(ball.zLayer == zLayer)
					{
						br++; // update bin count	
					} 
				}
			}
			// if we got this far, there are no balls in play, so check if there are any in the bin
			if(br > 0) isOpen = true;
			else broadcast(new Event(GameShell.OUT_OF_BALLS));
		}
		
		// This function just catches an "open bin" request broadcast by another cabinet part.
		protected function onOpenBin(ev:Event):void { isOpen = true; }
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			// if the bin is open see if there are any balls near the exit.
			if(isOpen) {
				// cycle through all balls
				var part:Object;
				var ball:Ball;
				var cp:CircleParticle;
				var dx:Number;
				var dy:Number;
				var dist:Number;
				var lst:Array = _cabinet.parts;
				for(var i:int = 0; i < lst.length; i++) {
					part = lst[i];
					if(part is Ball) {
						ball = part as Ball;
						cp = ball.ballParticle;
						// find the distance between the ball and the exit
						dx = cp.px - exitPoint.x;
						dy = cp.py - exitPoint.y;
						dist = Math.sqrt(dx*dx + dy*dy);
						// if the ball is close enough, drop it through the exit
						if(dist <= exitRadius) {
							if(launcher != null) ball.moveToLayerOf(launcher);
							else ball.zLayer = GROUND_LAYER;
							isOpen = false;
							break;
						}
					} // end of type check
				} // end of ball loop
			} // end of state check
		}
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		public override function checkInteractionsFor(other:CabinetPart):void {
			// we can collide with any other balls in the same zLayer
			if(other is Ball) {
				// The pit is only collidable if the ball is under ground level
				if(_group != null && other.group != null) {
					if(other.zLayer == zLayer) addCollidable(_group,other.group);
					else _group.removeCollidable(other.group);
				}
			} else {
				// track the launcher so we can move balls to it's drawing layer
				if(other is Launcher) launcher = other as Launcher;
			}
		}
		
	}
}