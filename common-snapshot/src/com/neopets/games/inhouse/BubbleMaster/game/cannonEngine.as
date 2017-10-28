/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.filters.*;
	import flash.geom.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	// NP
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID; // new sound files for BubbleMaster
	
	public class cannonEngine extends MovieClip {
		private var doc:Object;
		
		public var type:int;
		public var shooter:MovieClip;
		
		public var onDeck:int;
		
		public var tBubble:Boolean = false;
		public var bBubble:Boolean = false;
		
		private var bubbles:Array = [bubble_red, bubble_green, bubble_blue, bubble_orange, bubble_yellow];
		private var bubbleColor = [0xFF0000, 0x00FF00, 0x0000FF, 0xFF9900, 0xFFFF00];
		private var bubbleBevel = new BevelFilter(4, 45, 0xFFFFFF, 1, 0x000000, 1, 6, 6, 0.3);
		private var bubbleDrop = new DropShadowFilter(2, 45, 0x000000, 0.6, 4, 4);
		
		public var shotType:int = 0;
		
		public var live:Boolean = false;
		public var flight:Boolean = false;
		public var flightAngle:Number;
		public var flightRate:Number = 5;
		public var flightSpeed:Number = 10;
		private var flightTimer:Timer;
		
		public var tSpeed:Number = 0;
		public var tAngle:Number = 0;
		public var tRate:Number = 0;
		public var tDir:Number = 1;
		
		private var bounceTimer:Timer = new Timer(500);
		public var bounceComplete:Boolean = false;
		
		// added 2/2010
		public var deckhole:MovieClip;
		public var mSoundManager:SoundManager;
		
		public function cannonEngine(scope:MovieClip):void {
			doc = scope;
			
			x = 320;
			y = 440;
			mSoundManager = SoundManager.instance; // NP sound manager
			doc.addChild(this);
		}
		
		private function updateCannon(e:Event):void {
			if(!doc.paused) {
				rotation = Math.atan2(doc.bubblefield.field.mouseY - 380, doc.bubblefield.field.mouseX - 250) * 180 / Math.PI;
				
				if(rotation < 180 && rotation > 90) { rotation = 180; }
				else if(rotation > 0 && rotation < 90 ) { rotation = 0; }
				
				if(shooter != null && !flight) {
					shooter.x = 250 + (10 * Math.cos(rotation * Math.PI / 180));
					shooter.y = 380 + (10 * Math.sin(rotation * Math.PI / 180));
				}
			}
		}
		
		private function triggerCannon(e:MouseEvent) :void {
			if(live && !doc.paused) { if(e.stageY < 440) fireCannon(); }
		}
		
		public function initCannon():void {
			bounceTimer.addEventListener(TimerEvent.TIMER, bounceTick, false, 0, true);
			doc.addEventListener(MouseEvent.MOUSE_DOWN, triggerCannon, false, 0, true);
			addEventListener(Event.ENTER_FRAME, updateCannon, false, 0, true);
		}
		
		
		public function resetCannon():void {
			// trace("bounceTimer: "+bounceTimer);  - ok
			if(bounceTimer.running) bounceTimer.stop();
			
			// trace("flightTimer: "+flightTimer); - error 
			if(flightTimer != null)
			{
			  if(flightTimer.running) flightTimer.stop();
			}
			
			if(bounceTimer.hasEventListener(TimerEvent.TIMER)) bounceTimer.removeEventListener(TimerEvent.TIMER, bounceTick);
			
			doc.removeEventListener(MouseEvent.MOUSE_DOWN, triggerCannon);
			
			removeEventListener(Event.ENTER_FRAME, updateCannon);
			
			live = false;
			
			flight = false;
			
		}
		
		public function loadCannon():void {
			//initilize new bubble
			shotType = 0;
			type = onDeck;
			
			shooter = new bubbles[type]();
			shooter.x = 250 + (10 * Math.cos(rotation * Math.PI / 180));
			shooter.y = 380 + (10 * Math.sin(rotation * Math.PI / 180));
			shooter.filters = [bubbleBevel, bubbleDrop];
			doc.bubblefield.field.addChild(shooter);
			
			//ondeck color change
			onDeck = Math.round(Math.random() * (bubbles.length-1));
			var dcolor = new ColorTransform();
			dcolor.color = bubbleColor[onDeck];
			deckhole.bg.transform.colorTransform = dcolor;
			
			//bonus determination
			var bubbleBonus = (Math.round(Math.random() * 100) < 15) ? true : false;
			//var bubbleBonus = false; //testing without bonus
			
			if(bubbleBonus) {
				var tBonus = Math.round(Math.random());
				switch(tBonus) {
					case 0: 	
					tBubble = true;  
					shotType = 1;  
					doc.viewport.turtleLight.visible = true;		
					tRate = 0.05 + (Math.random() * 0.05);
					tDir = (Math.random() > 0.5) ? -1 : 1;
					showBonusTitle(1);
					break;
					
					case 1:	
					bBubble = true;  
					shotType = 2; 	
					doc.viewport.bunnyLight.visible = true;
					showBonusTitle(2);
					break;
				}
				
				var strobe = new bubble_strobe();
				strobe.name = 'strobe';
				shooter.addChild(strobe);
				
				//doc.sound.playSound('bell', 0.5); // old sound engine // bell = GLASSBELL
				mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);	
				
				doc.effects.createTrail('bonusTrail', shooter, doc.bubblefield.effects, bubbleColor[type]);
				doc.effects.createFizzle('bonusFizzle', shooter, doc.bubblefield.effects, bubbleColor[type]);
			}
			
			//set ready state
			flight = false;
			live = true;
		}
		
		public function fireCannon():void {
			live = false;
			flight = true;
			doc.bubblefield.action = true;
			
			flightAngle = Math.atan2(doc.bubblefield.field.mouseY - 380, doc.bubblefield.field.mouseX - 250) * 180 / Math.PI;
			
			if(tBubble || bBubble) {
				doc.effects.clearFizzle('bonusFizzle');
			}
			
			flightRate = (tBubble) ? 20 : 5;
			
			//if(tBubble) doc.sound.playSound('slidewhistle', 1);
			if(tBubble) mSoundManager.soundPlay(BubbleMaster_SoundID.SLIDE_WHISTLE, false);	
			
			if(bBubble) {
				var c = new ColorTransform();
				c.color =  bubbleColor[type];
				doc.viewport.bCounter.count.bg.transform.colorTransform = c;
				doc.viewport.bCounter.count.bg.alpha = 0.7;
				
				bounceTimer.start();
			}
			
			flightTimer = new Timer(flightRate);
			flightTimer.addEventListener(TimerEvent.TIMER, flightCheck, false, 0, true);
			flightTimer.start();
			
			//doc.sound.playSound('thwang', 0.5);
			mSoundManager.soundPlay(BubbleMaster_SoundID.THWANG, false);	
			
		}
		
		public function flightControl():void {
			if(doc.paused) { if(flightTimer.hasEventListener(TimerEvent.TIMER)) flightTimer.stop(); }else{ if(flightTimer.hasEventListener(TimerEvent.TIMER)) flightTimer.start(); }
		}
		
		
		//:::::bounce timer handling
		public function bounceTick(e:TimerEvent):void {
			if(e.target.currentCount == 6) {
				bounceComplete = true;
				bounceTimer.stop();
				bounceTimer.reset();
				
			}else{
				doc.viewport.bCounter.count.gotoAndStop(6 - e.target.currentCount);
				doc.viewport.bCounter.gotoAndPlay('go');
				
			}
		}
		
		
		//:::::bonus title animation handling
		private function showBonusTitle(n:int):void {
			doc.viewport.bonusClip.bonusTitle.gotoAndStop(n);
			doc.viewport.bonusClip.play();
		}
		
		
		//:::::retreive bubble location data - surrounding field quadrants
		private var rmax = 19;
		private function getQuads(xp, yp):Array {
			var quadrants = [ ];
				
			var srows = doc.bubblefield.rows;
			
			var sr = Math.floor(yp / 18);
			var so = (sr % 2 == 0) ? 0 : 10;
			var sp = Math.floor((xp-so) / 20);
			
			//if(sr >= 19) return [ ];
			if(sp < 0) sp=0;
			
			if(sr % 2 == 1) {
				if(sr-1>=0 && srows[sr-1][sp].mc != null) quadrants.push(srows[sr-1][sp].mc);
				if(sr-1>=0 && sp+1<=24 && srows[sr-1][sp+1].mc != null) quadrants.push(srows[sr-1][sp+1].mc);
				if(sp-1>=0 && srows[sr][sp-1].mc != null) quadrants.push(srows[sr][sp-1].mc);
				
				if(sr>=0 && sp<=23 && srows[sr][sp].mc != null) quadrants.push(srows[sr][sp].mc);
				
				if(sp+1<=23 && srows[sr][sp+1].mc != null) quadrants.push(srows[sr][sp+1].mc);
				if(sr+1<=rmax && srows[sr+1][sp].mc != null) quadrants.push(srows[sr+1][sp].mc);
				if(sr+1<=rmax && sp+1<=24 && srows[sr+1][sp+1].mc != null) quadrants.push(srows[sr+1][sp+1].mc);
				
			}else{
				if(sr-1>=0 && sp<=23 && srows[sr-1][sp].mc != null) quadrants.push(srows[sr-1][sp].mc);
				if(sr-1>=0 && sp-1>=0 && srows[sr-1][sp-1].mc != null) quadrants.push(srows[sr-1][sp-1].mc);
				if(sp-1>=0 && srows[sr][sp-1].mc != null) quadrants.push(srows[sr][sp-1].mc);
				
				if(sr>=0 && sp<=24 && srows[sr][sp].mc != null) quadrants.push(srows[sr][sp].mc);
				
				if(sp+1<=24 && srows[sr][sp+1].mc != null) quadrants.push(srows[sr][sp+1].mc);
				if(sr+1<=rmax && sp<=23 && srows[sr+1][sp].mc != null) quadrants.push(srows[sr+1][sp].mc);
				if(sr+1<=rmax && sp-1>=0 && srows[sr+1][sp-1].mc != null) quadrants.push(srows[sr+1][sp-1].mc);
				
			}
			
			return quadrants;
		}
		
		private function checkNormal():MovieClip {
			
			for(var f=1; f <= flightSpeed; f++) {
				
				var nx = shooter.x + (f * Math.cos(flightAngle * Math.PI / 180));
				var ny = shooter.y + (f * Math.sin(flightAngle * Math.PI / 180));
				
				if(checkBounds(nx, ny)) return null;
				
				var proximity = getQuads(nx, ny);
				var range = [ ];
				
				for(var i=0; i<proximity.length; i++) {
					var distA = Point.distance(new Point(shooter.x, shooter.y), new Point(proximity[i].x, proximity[i].y));
					if(distA <= 20) { range.push( { d:distA, mc:proximity[i] } ); }  //return proximity[i]; }
				}
				
				if(range.length > 0) {
					range.sortOn('d', Array.NUMERIC);
					return range[0].mc;
				}
				
			}
			
			return null;
		}
		
		private function checkBounce():MovieClip {
			
			main:for(var f=1; f <= flightSpeed; f++) {
				
				var nx = shooter.x + (f * Math.cos(flightAngle * Math.PI / 180));
				var ny = shooter.y + (f * Math.sin(flightAngle * Math.PI / 180));
				
				if(checkBounds(nx, ny)) return null;
				
				var proximity = getQuads(nx, ny);
				
				for(var i=0; i<proximity.length; i++) {
					var b:MovieClip = proximity[i];
					
					var distC = Point.distance(new Point(nx, ny), new Point(b.x, b.y));
					
					if(distC <= 20 ) {
						//doc.sound.playSound('boing', 1);
						// sound when 'twisty turtle or 'bouncy bunny' shows up
						mSoundManager.soundPlay(BubbleMaster_SoundID.BOING, false);	
						
						var aa = Math.atan2(ny - b.y, nx - b.x);  //trace('aa: '+(aa * 180 / Math.PI));
						nx = b.x + (20 * Math.cos(aa));
						ny = b.y + (20 * Math.sin(aa));
						
						var ba = Math.atan2(b.y - ny, b.x - nx); //trace('ba: ' +(ba * 180 / Math.PI));
						
						var vp = ((nx - shooter.x) * Math.cos(ba)) + ((ny - shooter.y) * Math.sin(ba));
						var vn = -((nx - shooter.x) * Math.sin(ba)) + ((ny - shooter.y) * Math.cos(ba));
						
						var vpp = (1 * (1 - 2)) / (1 + 1);
						
						var vpx = (vpp * Math.cos(ba)) - (vn * Math.sin(ba));
						var vpy = (vpp * Math.sin(ba)) + (vn * Math.cos(ba));
						
						var na = Math.atan2((ny + vpy) - ny, (nx + vpx) - nx);  //trace(na * 180 / Math.PI);
						
						flightAngle = na * 180 / Math.PI;
						shooter.x = nx;
						shooter.y = ny;
						
						doc.bubblefield.bouncePop(b);
						
						break main;
					}
				}
				
			}//end main
			
			return null;
		}
		
		private function checkTwist():MovieClip {
			
			main:for(var t=1; t <= 20; t++) {
				//var range = [ ];
				
				var tsplit = tSpeed / 20;
				var rad = 2 + (0.5 * tAngle);
				var nx = shooter.x + ( (t * tsplit) * Math.cos(flightAngle * Math.PI / 180)) + (rad * Math.cos(tAngle));
				var ny = shooter.y + ( (t * tsplit) * Math.sin(flightAngle * Math.PI / 180)) + (rad * Math.sin(tAngle));
				
				//if(checkBounds(nx, ny)) return null;
				
				//new check bounds for twisty instances - remove shooter once outside bounds
				if(nx < 0 || nx > 500 || ny < 0 || ny > 400) {
					flightTimer.stop();
					doc.effects.clearTrail('bonusTrail');
					
					// NEED TO FIX?
					//doc.sound.stopTwisty();
					
					doc.viewport.turtleLight.visible = false;
					tBubble=false; tSpeed=0; tAngle=0;
					
					shooter.removeChild(shooter.getChildByName('strobe'));
					doc.bubblefield.field.removeChild(shooter);
					
					doc.bubblefield.shotType = 1;
					doc.bubblefield.orphanCheck();
					break main;
				}
				
				var proximity = getQuads(nx, ny);
				
				for(var i=0; i<proximity.length; i++) {
					var distA = Point.distance(new Point(nx, ny), new Point(proximity[i].x, proximity[i].y));
					//if(distA <= 20) { range.push( { d:distA, mc:proximity[i] } ); } //return proximity[i];
					
					//new function - remove all bubbles from twisty path
					if(distA <= 10) doc.bubblefield.twistyPop(proximity[i]);
				}
				
				/*
				if(range.length > 0) {
					range.sortOn('d', Array.NUMERIC);
					return range[0].mc;
				}else{
					return null;
				}
				*/
			}
			
			return null;
		}
		
		private function checkBounds(xp, yp):Boolean {
			var acos:Number = Math.cos(flightAngle*Math.PI / 180);
			var asin:Number = Math.sin(flightAngle*Math.PI / 180);
			
			//var bounceX:Boolean = (shooter.x+(10 * acos) < 10 || shooter.x+(10 * acos) > 490) ? true : false;
			//var bounceY:Boolean = (shooter.y+(10 * asin) < 10 || shooter.y+(10 * asin) > 390) ? true : false;
			
			//bounceX
			//if(xp+(10 * acos) < 10 || xp+(10 * acos) > 490) {
			if(xp - 10 < 0 || xp + 10 > 500) {
				var xd:Number;
				//if(xp+(10 * acos) < 10) { xd = xp - 10; shooter.x = 10; }
				//if(xp+(10 * acos) > 490) { xd = 490 - xp; shooter.x = 490; }
				if(xp - 10 < 0) { xd = xp - 10; shooter.x = 10; }
				if(xp + 10 > 500) { xd = 490 - xp; shooter.x = 490; }
				
				shooter.y -= Math.tan(flightAngle * Math.PI / 180) * xd;
				
				flightAngle = (-180) - flightAngle;
				
				//doc.sound.playSound('boing', 1);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BOING, false);	
				return true;
			}
			
			//bounceY
			//if(yp+(10 * asin) < 10 || yp+(10 * asin) > 390) {
			if(yp - 10 < 0 || yp + 10 > 400) {
				var yd:Number;
				//if(yp+(10 * asin) < 10) { yd = yp - 10; shooter.y = 10; }
				//if(yp+(10 * asin) > 390) { yd = 390 - yp; shooter.y = 390; }
				if(yp - 10 < 0) { yd = yp - 10; shooter.y = 10; }
				if(yp + 10 > 400) { yd = 390 - yp; shooter.y = 390; }
				
				shooter.x -= (1 / (Math.tan(flightAngle * Math.PI / 180))) * yd;
				
				flightAngle =  -flightAngle;
				
				//doc.sound.playSound('boing', 1);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BOING, false);	
				return true;
			}
			
			return false;
		}
		
		//  Error #2007: Parameter child must be non-null.
		public function flightCheck(e:TimerEvent):void {
			if(doc.paused) return;
			
			var contact:MovieClip = null;
			
			//normal
			if(!tBubble && !bBubble) contact = checkNormal();
			
			//bBubble
			if(bBubble) (bounceComplete) ? contact = checkNormal() : checkBounce();
			
			//tBubble
			if(tBubble) contact = checkTwist();
			
			if(contact == null) {
				if(!tBubble) {
					shooter.x += flightSpeed * Math.cos(flightAngle * Math.PI / 180);
					shooter.y += flightSpeed * Math.sin(flightAngle * Math.PI / 180);
				}
					
				if(tBubble) {
					var r = 2 + (0.5 * tAngle);
					shooter.x += (tSpeed * Math.cos(flightAngle * Math.PI / 180)) + (r * Math.cos(tAngle));
					shooter.y += (tSpeed * Math.sin(flightAngle * Math.PI / 180)) + (r * Math.sin(tAngle));
					tAngle +=  tDir * (Math.PI / 10);
					tSpeed += tRate;
				}
			}
			
			if(contact) {
				flightTimer.stop();
				
				if(bBubble) { 
					doc.effects.clearTrail('bonusTrail');
					
					shooter.removeChild(shooter.getChildByName('strobe'));
					
					doc.viewport.turtleLight.visible = false;
					doc.viewport.bunnyLight.visible = false;
				}
				
				if(bBubble) { bBubble=false; bounceComplete = false; }
				
				doc.bubblefield.locatePosition(contact, shotType);
			}
			
		}
		
		
	}//end class
}//end package








