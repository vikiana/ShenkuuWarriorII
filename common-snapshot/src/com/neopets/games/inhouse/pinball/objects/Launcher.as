// The "launcher" is the spring loaded device that shoots the ball into play.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.neopets.util.input.KeyCommand;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	public class Launcher extends BallBlocker {
		// APEngine Variables
		protected var handleRect:RectangleParticle;
		protected var handlePos:Vector; // stores intial handle position
		// Animation Variables
		protected var coils:Array;
		protected var springLength:Number;
		// Control System Variables
		protected var pullVector:VectorForce;
		protected var pullRate:Number;
		protected var maxPull:Number;
		protected var trigger:KeyCommand;
		
		public function Launcher() {
			pullRate = 200;
			maxPull = 3000;
			pullVector = new VectorForce(false,0,0);
			coils = new Array();
			super();
			zLayer = LAUNCH_LAYER;
			
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			trace("Launcher INIT");
			// set up APEngine Group
			if(_group == null) {
				_group = new Group();
				// add handle
				handleRect = getRectPart("handle_mc",false,8,0.1);
				if(handleRect != null) {
					_group.addParticle(handleRect);
					handlePos = handleRect.position;
				}
				// add spring supports for handle
				addAnchor(0,-handleRect.height,0.5);
				addAnchor(0,handleRect.height,0.5);
				// add springs
				var coil:MovieClip;
				var i:int = 1;
				var base_y:int;
				do {
					coil = this["s"+i] as MovieClip;
					if(coil != null) {
						if(coils.length > 0) base_y = coils[0].base_y;
						else base_y = coil.y;
						coils.push({mc:coil,base_y:base_y,dy:coil.y-base_y,ir:coil.rotation});
					} else break;
					i++;
				} while(coil != null);
				addEventListener(Event.ENTER_FRAME,afterAddedToGame); // update spring art next frame
			}
			// link controls to keyboard input
			if(trigger == null) {
				trigger = _cabinet.game.getKey(GameShell.PULL_CMD);
				enableUpdates();
			}
		}
		
		// This function handles initialization that happen one frame after the
		// launcher has been added to the game.
		protected function afterAddedToGame(ev:Event=null):void {
			if(handleRect != null) {
				// move our front coils in front of the handle
				var cp:Object;
				var hp:Object = handleRect.sprite.parent;
				var index:int = hp.getChildIndex(handleRect.sprite) + 1;
				var clip:MovieClip;
				var bb:Rectangle;
				for(var i:int = 0; i < coils.length; i += 2) {
					clip = coils[i].mc;
					// reposition coil
					cp = clip.parent;
					while(cp != null && cp != hp) {
						clip.x += cp.x;
						clip.y += cp.y;
						coils[i].base_y += cp.y;
						cp = cp.parent;
					}
					// move coil into drawing layer
					hp.addChild(clip);
					hp.setChildIndex(clip,index);
				}
			}
			// this function should only trigger once
			removeEventListener(Event.ENTER_FRAME,afterAddedToGame);
		}
		
		// Use this function to connect the handle to a fixed point through a spring constraint.
		// "dx is the x position relative to the handle while "dy" is the y position.
		// "stiffness" is as per the spring constraint property of the same name.
		public function addAnchor(dx:Number,dy:Number,stiffness:Number) {
			if(handleRect == null) return;
			// create the anchor point
			var cp:CircleParticle = new CircleParticle(handleRect.px+dx,handleRect.py+dy,4,true);
			cp.collidable = false;
			addHiddenParticle(cp);
			// create the spring constraint
			var sc:SpringConstraint = new SpringConstraint(cp,handleRect,stiffness);
			addHiddenConstraint(sc);
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void 
		{
			if(handleRect != null) 
			{
				// check if the handle is being pulled
				if(trigger != null) 
				{
				
  				var val:Vector = pullVector.getValue(1);
  				
 				 if(trigger.keyIsDown) 
 				 {
  					pullVector.vy = Math.min(val.y + pullRate,maxPull);
  					handleRect.addForce(pullVector);
 				}
 				 else
 				{
	  				// if we just stopped pulling transfer force to the push vector
	  				if(val.y != 0)
	  				{
	  					cabinet.game.controller.playSound(SoundIDs.KICKOUT_BALL);	
	  					//pushVector.vy = -val.y;
	  					pullVector.vy = 0;
					}
 				}
					
					
					
					/*
					if(trigger.keyIsDown) {
						var val:Vector = pullVector.getValue(1);
						pullVector.vy = Math.min(val.y + pullRate,maxPull);
						handleRect.addForce(pullVector);
					} else pullVector.vy = 0;
					*/
				}
				
				// keep the handle from sliding sideways
				handleRect.px = handlePos.x;
				// update the springs
				stretchCoils(handleRect.py - handlePos.y);
			}
		}
		
		// Use this function to handle the animations for stretching out the launcher's 
		// spring graphics.
		// "dy" is the distance the spring should be stretched.
		protected function stretchCoils(dy:Number) {
			if(coils.length > 0) {
				var li:int = coils.length - 1;
				var len:Number = coils[li].dy;
				var ratio:Number = (len + dy) / len;
				// cycle through all coils
				var entry:Object;
				var clip:MovieClip;
				for(var i:int = 0; i < coils.length; i++) {
					entry = coils[i];
					clip = entry.mc;
					clip.y = entry.base_y + entry.dy * ratio;
					clip.rotation = entry.ir * ratio;
				}
			}
		}
		
		// Removal Functions
		
		// Put the object's clean up code here.
		protected override function onRemoval():void  {
			if(trigger != null) trigger = null;
		}
		
	}
	
}