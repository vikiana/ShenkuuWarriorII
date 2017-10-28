// This class handles the actual pinball object.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	import com.neopets.games.inhouse.pinball.geom.LineSegment;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class Ball extends BallBlocker {
		public var resetPoint:Vector;
		protected var _path:LineSegment;
		// APEngine Variables
		protected var myCircle:CircleParticle;
		// shared variables
		protected static var maxSpeed:Number = 24;
		
		public function Ball() {
			var vec:Vector = new Vector(0,0);
			_path = new LineSegment(vec,vec);
			super();
		}
		
		// Accessor Functions
		
		public function get ballParticle():CircleParticle { return myCircle; }
		
		public function get path():LineSegment { return _path; }
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				// find our main image
				var dobj:DisplayObject;
				if("img" in this) dobj = this["img"] as DisplayObject;
				else dobj = getChildAt(0);
				// build a circle particle from that image
				if(dobj != null) {
					var r:Number;
					// check if we have a bounding circle
					var b:DisplayObject;
					if("bounds_mc" in this) {
						b = this["bounds_mc"] as DisplayObject;
						b.visible = _cabinet.game.showWires;
						r = b.width / 2;
					} else r = dobj.width / 2;
					// create the circle particle
					myCircle = new CircleParticle(x,y,r,false,1,0.3,0);
					dobj.addEventListener(MouseEvent.CLICK,onMouseClick);
					myCircle.setDisplay(dobj);
					//myCircle.multisample = 2;
					_group.addParticle(myCircle);
					// initialize path
					var pos:Vector;
					pos = myCircle.position;
					_path.setPoints(pos,pos);
					// initialize reset point
					resetPoint = myCircle.position;
				}
			}
			enableUpdates();
		}
		
		// Removal Functions
		
		// Put the object's clean up code here.
		protected override function onRemoval():void  {
			myCircle.sprite.removeEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		// Derived Values
		
		// This function tells other objects if the ball is on the playfield as opposed 
		// to being in an storage area.
		public function get isInPlay():Boolean {
			return (zLayer > PIT_LAYER && zLayer < BIN_LAYER);
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			if(_cabinet != null) _cabinet.applyGravityTo(myCircle);
			// update the ball's path
			_path.setPoints(_path.pointB,myCircle.position);
			// apply the speed cap
			var vel:Vector = myCircle.velocity;
			var spd:Number = vel.magnitude();
			if(spd > maxSpeed) {
				myCircle.velocity = vel.mult(maxSpeed/spd);
			}
		}
		
		// Listener Functions
		
		// This function reacts to mouse click events.
		protected function onMouseClick(ev:Event) {
			// If the ball has stopped moving, let the user click on the ball to force movement.
			// This was added to let the user free the ball if it gets stuck in another object.
			if(PIT_LAYER < _zLayer && _zLayer < LAUNCH_LAYER) {
				if(_path.length < 8) {
					myCircle.position = resetPoint;
				}
			}
		}
		
		// Movement Functions
		
		// use this function to put this part on the same z layer and one drawing layer
		// above the target part.
		public function moveToLayerOf(other:CabinetPart):void {
			if(ballParticle == null || other == null) return;
			zLayer = other.zLayer; // set zLayer
			// try to find the new target index
			var bp:Object = ballParticle.sprite.parent;
			var op:Object = other;
			while(op != null && op.parent != bp) op = op.parent;
			if(op.parent == bp) {
				var index:int = bp.getChildIndex(op);
				bp.setChildIndex(ballParticle.sprite,index + 1);
			}
		}
		
	}
}