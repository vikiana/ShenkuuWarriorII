// Coverd chutes pull the pinball off screen when it enters one end and shoots it out
// the other end after a slight delay.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.components.BoxTrap;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class CoveredChute extends BallBlocker {
		// APEngine Variables
		protected var ports:Array;
		protected var hitValue:Number;
		
		public function CoveredChute() {
			hitValue = 10;
			ports = new Array();
			super();
		}
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				ports.push(new BoxTrap("a",this));
				ports.push(new BoxTrap("b",this));
				enableUpdates();
			}
		}
		
		// Game Cycle Functions
		
		// This function is called every frame while the game isn't paused.
		protected override function update(ev:Event):void  {
			// cycle through our ports
			var port_a:Object;
			var port_b:Object;
			var j:int;
			var part:Object;
			var ball:Ball;
			var lst:Array = _cabinet.parts;
			for(var i:int = 0; i < ports.length; i++) {
				port_a = ports[i];
				port_b = ports[(i+1)%ports.length];
				// check if any balls have entered this openning
				for(j = 0; j < lst.length; j++) {
					part = lst[j];
					if(part is Ball) {
						ball = part as Ball;
						if(port_a.catchBall(ball)) {
							cabinet.game.changeScoreBy(hitValue);
							port_a.transferBall(ball,port_b);
							port_b.releaseBallAfter(ball,1);
						}
					}
				}
				// let the openning see if it's ready to release a ball yet
				port_a.update();
			}
		}
		
	}
	
}