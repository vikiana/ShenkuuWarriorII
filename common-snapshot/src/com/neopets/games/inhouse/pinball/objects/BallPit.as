// This class controls the cut off point where balls are lost.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.CabinetWalls;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.SoundIDs;
		
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class BallPit extends BallBlocker {
		protected var blocker:RectangleParticle;
		
		public function BallPit() {
			super();
			zLayer = PIT_LAYER;
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			// set up APEngine Group
			if(_group == null) {
				_group = new Group(false);
				var px:Number = GameShell.SCREEN_WIDTH / 2;
				var py:Number = GameShell.SCREEN_HEIGHT - (CabinetWalls.WALL_THICKNESS/2);
				blocker = new RectangleParticle(px,py,GameShell.SCREEN_WIDTH,CabinetWalls.WALL_THICKNESS,0,true);
				addHiddenParticle(blocker);
				enableUpdates();
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			var part:Object;
			var ball:Ball;
			var lst:Array = _cabinet.parts;
			for(var i:int = 0; i < lst.length; i++) {
				part = lst[i];
				if(part is Ball) {
					ball = part as Ball;
					if(ball.zLayer >= GROUND_LAYER) {
						var cp:CircleParticle = ball.ballParticle;
						if(cp.py - cp.radius > GameShell.SCREEN_HEIGHT) {
							ball.zLayer = zLayer;
							broadcast(new Event(GameShell.BALL_LEFT_PLAY));
						
							_cabinet.game.controller.playSound(SoundIDs.ZAP_UP);	
						}
					}
				}
			} // end of part loop
		}
		
	}
}