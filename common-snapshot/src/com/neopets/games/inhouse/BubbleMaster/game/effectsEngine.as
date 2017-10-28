/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.filters.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	import com.neopets.games.inhouse.BubbleMaster.game.particleEvent;
	
	dynamic class effectsEngine extends MovieClip {
		
		private var doc:Object;
		private var scope:Object;
		
		private var colors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFF9900, 0xFFFF00];
		
		public var particles = [];
		private var trails = [];
		private var fizzles = [];
		
		private var timer:Timer = new Timer(20);
		
		public function effectsEngine(_scope:Object):void {
			doc = _scope;
			scope = this;
			
			timer.addEventListener(TimerEvent.TIMER, process, false, 0, true);
			timer.start();
		}
		
		//:::::blasts - single explotion of particles from center over a short period
		private var bnum:int = 0;
		private var blasts = [];
		
		public function createBlast(target:Object, xp:Number, yp:Number, time:int, density:uint, color:uint = 0xFFFFFF):void {
			blasts.push( {lev:target, x:xp, y:yp, ct:0, tt:time, d:density, c:color} );
		}
		
		//:::::comets - creates glowing orb that follows a bazier trajectory to destination point with particle trial
		private var cnum:int = 0;
		private var comets = [];
		
		public function createComet(target:Object, ax:Number, ay:Number, bx:Number, by:Number, color:uint=0xFFFFFF, callback:Function=null, props:Object=null):void {
			this['orb'+cnum] = new MovieClip();
			this['orb'+cnum].id = cnum;
			
			if(callback != null) {
				this['orb'+cnum].handler = callback;
				this['orb'+cnum].props = props;
				this['orb'+cnum].evt = new particleEvent();
				
				this['orb'+cnum].evt.addEventListener(particleEvent.COMPLETE, this['orb'+cnum].handler);
			}
			
			this['orb'+cnum].x = ax;
			this['orb'+cnum].y = ay;
			
			this['orb'+cnum].graphics.beginFill(color, 0.75);
			this['orb'+cnum].graphics.drawCircle(0,0,6);
			this['orb'+cnum].graphics.endFill();
			
			this['orb'+cnum].filters = [ new GlowFilter(0xFFFFFF, 1, 10, 10), new BlurFilter(10, 10) ];
			
			var cx = (ax < bx) ? bx - (bx - ax) / 2 : bx + (ax - bx) / 2;
			var cy = (ay < by) ? ay - (by - ay + 50) : by - (ay - by + 50);
			
			this['orb'+cnum].ptA = new Point(ax, ay);
			this['orb'+cnum].ptB = new Point(bx, by);
			this['orb'+cnum].ptC = new Point(cx, cy);
			
			this['orb'+cnum].t = 0;
			this['orb'+cnum].s = 0.1;
			this['orb'+cnum].color = color;
			
			target.addChild(this['orb'+cnum]);
			
			createTrail('c'+cnum, this['orb'+cnum], target, color);
			
			comets.push(this['orb'+cnum]);
			cnum++;
		}
		
		public function clearComet(comet:MovieClip):void {
			clearTrail('c' + comet.id);
			comets.splice(comets.indexOf(comet), 1);
			
			comet.parent.removeChild(comet);
			delete this['orb'+comet.id];
		}
		
		//:::::fizzels - constant particle generation from center in single location
		public function createFizzle(id:String, object:Object, target:Object, color:uint = 0):void {
			this[id] = { ind:fizzles.length, obj:object, lev:target, clr:color };
			fizzles.push( this[id] );
		}
		
		public function clearFizzle(id:String):void {
			fizzles.splice(this[id].ind, 1);
			delete this[id];
		}
		
		//:::::trails - leaves particle trail following object
		public function createTrail(id:String, object:Object, target:Object, color:uint = 0xFFFFFF):void {
			this[id] = {ind:trails.length, obj:object, lev:target, clr:color, loc:new Point(object.x, object.y)};
			trails.push( this[id] );
		}
		
		public function clearTrail(id:String):void {
			trails.splice(this[id].ind, 1);
			delete this[id];
		}
		
		private function process(e:TimerEvent):void {
			//trails
			for(var t=0; t<trails.length; t++) {
				var curr = new Point(trails[t].obj.x, trails[t].obj.y);
				var prev = new Point(trails[t].loc.x, trails[t].loc.y);
				
				var vector = Math.atan2(curr.y - prev.y, curr.x - prev.x);
				var velocity = Math.round(Point.distance(curr, prev));
				
				var tail = Math.PI + vector;
				
				for(var i=0; i< velocity / 4; i++) {
					var dis = velocity + (Math.random() * velocity);
					var con = (i < velocity / 2 / 2) ? 2 : 4;
					var xp = curr.x + ( dis * Math.cos(tail) ) + ( (Math.random() * (trails[t].obj.width / con)) * Math.cos(Math.random() * 2 * Math.PI) );
					var yp = curr.y + ( dis * Math.sin(tail) ) + ( (Math.random() * (trails[t].obj.height / con)) * Math.sin(Math.random() * 2 * Math.PI) );
					var color:uint = (Math.random() < 0.5) ? trails[t].clr : 0xFFFFFF;
					
					particles.push( new Glitter(trails[t].lev, scope, xp, yp, vector, velocity, color) );
				}
				
				trails[t].loc = curr;
			}
			
			//fizzles
			for(var f=0; f<fizzles.length; f++) {
				for(var fn=0; fn<2; fn++) {
					var fvector = Math.random() * 2 * Math.PI;
					var fvelocity = 10 + Math.round(Math.random() * 20);
					var fxp = (fizzles[f].obj.x) + ((fizzles[f].obj.width / 2) - (Math.random() * fizzles[f].obj.width));
					var fyp = (fizzles[f].obj.y) + ((fizzles[f].obj.height / 2) - (Math.random() * fizzles[f].obj.height));
					
					var fcolor = (fizzles[f].clr == 0) ?	colors[Math.round(Math.random()*colors.length-1)] : fizzles[f].clr;
					
					var fc:uint = (Math.random() < 0.5) ? fcolor : 0xFFFFFF;
					
					particles.push( new Glitter(fizzles[f].lev, scope, fxp, fyp, fvector, fvelocity, fc) );
				}
			}
			
			//comets
			for(var c=0; c<comets.length; c++) {
				var cc = comets[c];
				if(cc.t + cc.s <= 1) {
					cc.t += cc.s;
					
					var px = ( (1 - cc.t) * (1 - cc.t) * cc.ptA.x ) + ( 2 * (1 - cc.t) * cc.t * cc.ptC.x) + ( cc.t * cc.t * cc.ptB.x );
					var py = ( (1 - cc.t) * (1 - cc.t) * cc.ptA.y ) + ( 2 * (1 - cc.t) * cc.t * cc.ptC.y) + ( cc.t * cc.t * cc.ptB.y );
					
					cc.x = px;
					cc.y = py;
				
				}else{
					if(cc.evt != null) {
						cc.evt.position = new Point(cc.x, cc.y);
						cc.evt.color = cc.color;
						cc.evt.props = cc.props;
						cc.evt.dispatch('complete');
						cc.evt.removeEventListener(particleEvent.COMPLETE, cc.handler);
						delete cc.evt;
					}
					clearComet(cc);
				}
			}
			
			//blasts
			for(var b=0; b<blasts.length; b++) {
				for(var bp=0; bp<Math.floor(10 * blasts[b].d); bp++) {
					var bvelocity:Number = Math.random() * (30 * blasts[b].d);
					var bvector:Number = Math.random() * Math.PI * 2;
					var bcolor:uint = (Math.random() < 0.5) ? blasts[b].c : 0xFFFFFF;
					
					particles.push( new Glitter(blasts[b].lev, scope, blasts[b].x, blasts[b].y, bvector, bvelocity, bcolor) );
				}
				
				if(blasts[b].ct == blasts[b].tt) {
					blasts.splice(b, 1); b--;
				}else{
					blasts[b].ct++;
				}
			}
			
			//process all particles in queue
			for(var p=0; p<particles.length; p++) {
				particles[p].process();
			}
			
			//e.updateAfterEvent();
		}
		
		
		public function destroy():void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, process);
			
			delete this;
		}
		
	}
}








