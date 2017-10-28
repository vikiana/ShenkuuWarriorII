/*
 Neopets adaption - 2/2010

*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	
	public class bubbleBlast extends MovieClip {
		private var scope:Sprite;
		private var trans = new ColorTransform();
		private var bcolors:Array = [0xFF0000, 0x00FF00, 0x0000FF, 0xFF6600, 0xFFFF00];
		private var spatters = [];
		
		// added 2/2010
		public var ring:MovieClip;
		public var score:MovieClip;
		
		public function bubbleBlast(clip, color, xp, yp, points) {
			scope = clip;
			
			trans.color = bcolors[color];
			ring.innerRing.transform.colorTransform = trans;
			
			score.scoreTxt.text = points;
			score.scoreTxt.textColor = bcolors[color];
			
			x = xp;
			y = yp;
			alpha = 0.75;
			filters = [new GlowFilter(0xFFFFFF, 0.6, 8, 8), new DropShadowFilter(8, 45, 0x000000, 0.3, 4, 4)];
			
			scope.addChild(this);
			
			spatter(bcolors[color]);
			addEventListener(Event.ENTER_FRAME, explode, false, 0, true);
		}
		
		private function spatter(color):void { 
			for(var i=0; i<100; i++) {
				var s = new MovieClip();
				var a = 1;
				var angle = (Math.random()*360) * Math.PI / 180;
				var mass = 1; //Math.random() * 2;
				var dist = 1+ Math.random() * 5;
				
				s.xd = dist * Math.cos(angle);
				s.yd = dist * Math.sin(angle);
				s.durr = Math.ceil(Math.random() * 9);
				s.time = 0;
				
				if(Math.random() < 0.05) { color = 0xFFFFFF; a = 0.25; mass = 0.1; }
				s.graphics.beginFill(color, a);
				s.graphics.drawCircle(0, 0, mass);
				s.graphics.endFill();
				
				s.cacheAsBitmap = true;
				spatters.push(s);
				addChild(s);
			}
		}
		
		private function explode(e:Event):void {
			for(var i=0; i<spatters.length; i++) {
				if(spatters[i].durr != spatters[i].time) {
					spatters[i].x += spatters[i].xd;
					spatters[i].y += spatters[i].yd;
					spatters[i].time++;
				}else{
					removeChild(spatters[i]);
					delete spatters[i];
					spatters.splice(i, 1);
				}
			}
			
			if(spatters.length == 0) removeEventListener(Event.ENTER_FRAME, explode);
		}
		
		public function remove():void {
			scope.removeChild(this);
			delete this;
		}
		
	}
}