/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.utils.Timer;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	// NP added 3/2010
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID; // new sound files for BubbleMaster
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	
	public class bubbleField extends MovieClip {
		private var doc:Object;
		
		public var rows = [];
		public var field:MovieClip = new MovieClip();
		public var effects:Sprite = new Sprite();
		
		public var action:Boolean = false;
		
		private var dropBubble:MovieClip;
		
		private var bubbles:Array = [bubble_red, bubble_green, bubble_blue, bubble_orange, bubble_yellow];
		private var bubbleColors:Array = [0xFF0000, 0x00FF00, 0x0000FF, 0xFF6600, 0xFFFF00];
		private var bubbleBevel = new BevelFilter(4, 45, 0xFFFFFF, 1, 0x000000, 1, 6, 6, 0.3);
		private var bubbleDrop = new DropShadowFilter(2, 45, 0x000000, 0.6, 4, 4);
		
		private var popArray = [];
		private var popColor:ColorTransform = new ColorTransform();
		
		private var popTimer:Timer;
		private var setFieldTimer:Timer;
		private var addBubbleTimer:Timer;
		
		private var rnum:Number = 0;
		private var pnum:Number = 0;
		
		private var time:Number;
		private var speed:Number;
		private var tID:Number = 0;
		
		// NP
		public var mSoundManager:SoundManager;
		private var mMenuManager:MenuManager = MenuManager.instance; // this is needed to access the quit button on the game screen
		
		//private var mSoundManager = new SoundManager();
		
		// -------------------------
		// Constructor
		// -------------------------
		public function bubbleField(scope) {
			doc = scope;
			buildBubbleField();
			mSoundManager = SoundManager.instance; // NP sound manager
		}
		
		public function initField():void {
			createBubbleField();
			doc.cannon.initCannon();
			
			/* 
				This fixes a bug that happened when the game was integrated with the NP system -
				When hitting the quit button before the bubbles filled the screen, restarting
				the game would show that the old bubbles hadn't been cleared from the stage.
				
				Hiding the quit btn until all the bubbles are added to the stage fixes this.
			*/
			var tGameScreen:GameScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			tGameScreen.quitGameButton.visible = false;
		}
		
		public function resetField():void {
			//trace("resetField() in bubbleField.as");
			//stop all running timers
			if(setFieldTimer && setFieldTimer.running) setFieldTimer.stop();
			if(setFieldTimer && setFieldTimer.hasEventListener(TimerEvent.TIMER)) setFieldTimer.removeEventListener(TimerEvent.TIMER, setBubbleField);
			
			if(addBubbleTimer && addBubbleTimer.running) addBubbleTimer.stop();
			if(addBubbleTimer && addBubbleTimer.hasEventListener(TimerEvent.TIMER)) addBubbleTimer.removeEventListener(TimerEvent.TIMER, addBubble);
			
			if(popTimer && popTimer.running) popTimer.stop();
			if(popTimer && popTimer.hasEventListener(TimerEvent.TIMER)) popTimer.removeEventListener(TimerEvent.TIMER, popBubble);
			
			//reset bubbles & arrays
			for(var r=0; r<rows.length; r++) {
				for(var p=0; p<rows[r].length; p++) {
					rows[r][p].mc = null;
					rows[r][p].bc = null;
					rows[r][p].hook = false;
				}
			}
			
			//catch any field bubbles that are not in the valid field array
			while(field.numChildren > 0) {
				field.removeChildAt(0);
			}
		}
		
		private function buildBubbleField():void {
			//:::::set field
			field.x = 70;
			field.y = 60;
			doc.addChild(field);
			
			//:::::set effects
			effects.x = 70;
			effects.y = 60;
			doc.addChild(effects);
			
			//:::::set field data objects
			for(var r=0; r<24; r++) {
				var row = [ ];
				var offset = (r%2==0) ? 0 : 1;
				for(var p=0; p<(25-offset); p++) {
					var xp = 10 + (offset * 10) + (p * 20);
					var yp = 10 + (r * 18);
					row[p] = {x:xp, y:yp, mc:null, bc:null, br:r, bp:p, hook:false};
				}
				rows.push(row);
			}
		}
		
		private var bnum:int;
		
		// NP - creates 5 rows, alternating 24 and 25 bubbles
		// More rows are added each level and the bubbles also get added quicker
		private function createBubbleField():void {
			bnum = 4 + doc.viewport.level;
			
			//:::::construct field bubbles
			for(var r=0; r<bnum; r++) {
				var offset = (r%2==0) ? 0 : 1;
				for(var p=0; p<(25-offset); p++) {
					var type = Math.round(Math.random() * (bubbles.length-1));
					var bubble = new bubbles[type]();
					bubble.x = rows[r][p].x;
					bubble.y = rows[r][p].y;
					bubble.filters = [ bubbleBevel, bubbleDrop ];
					rows[r][p].mc = bubble;
					rows[r][p].bc = type;
					
				}
				
				// NP Test
				/*trace(r);
				if(r>=4)
				{
				   trace("bubble field done");
				}
				*/
			}
			
			//:::::add field bubbles - effect handling
			setFieldTimer = new Timer(20);
			setFieldTimer.addEventListener(TimerEvent.TIMER, setBubbleField, false, 0, true);
			setFieldTimer.start();
			//
			
		}
		
		private function setBubbleField(e:TimerEvent):void {
			if( rnum < bnum ) {
				if(pnum < rows[rnum].length) {
					field.addChild(rows[rnum][pnum].mc);
					//doc.sound.playSound('blip', 0.1);
					//mSoundManager.changeSoundVolume(BubbleMaster_SoundID.BLIP,1);
					mSoundManager.soundPlay(BubbleMaster_SoundID.BLIP, false,0,0,.2);
					//trace("add bubble----------");
					pnum++;
					
				}else{
					rnum++; pnum=0;
				}
				
			}else{
				setFieldTimer.stop();
				setFieldTimer.removeEventListener(TimerEvent.TIMER, setBubbleField);
				rnum=pnum=0;
				
				//begin gameplay here
				startBubbleField();
			}
		}
		
		public function resetLevelField():void {
			resetField();
			createBubbleField();
			doc.cannon.initCannon();
		}
		
		private var masterRate:int = 750;  //[ 700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 200, 150, 100]
		private var levelRate:int = 50;
		
		public function startBubbleField():void {
			
			//make button visible here - NP 3/2010
			var tGameScreen:GameScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
			tGameScreen.quitGameButton.visible = true;
			
			time = (masterRate - (doc.viewport.level * levelRate) > 100) ? masterRate - (doc.viewport.level * levelRate) : 100;
			speed = Math.ceil(time / 33.34);
			
			addBubbleTimer = new Timer(time);
			addBubbleTimer.addEventListener(TimerEvent.TIMER, addBubble, false, 0, true);
			addBubbleTimer.start();
				
			doc.cannon.loadCannon();
		}
		
		public function pauseControl():void {
			if(doc.paused) { if(addBubbleTimer) addBubbleTimer.stop(); }else{ if(addBubbleTimer) addBubbleTimer.start(); }
		}
		
		
		//:::::bubble handling
		private function addBubble(e:TimerEvent) {
			if(!action) {
				var bp = Math.round(Math.random() * 24);
				var type = Math.round(Math.random() * (bubbles.length-1));
				
				dropBubble = new bubbles[type]();
				dropBubble.x = 10 + (bp * 20);
				dropBubble.y = -10;
				dropBubble.c = type;
				dropBubble.filters = [ bubbleBevel, bubbleDrop ];
				field.addChild(dropBubble);
				
				field['t'+tID++] = new Tween(dropBubble, 'y', Back.easeOut, -10, 10, speed, false);
				pushBubble(bp);
			}
		}
		
		private function pushBubble(p) {
			var pos = p;
			var chain = [rows[0][p]];
			
			for(var i=0; i<chain.length; i++) {
				if(chain[i].mc == null) { 
					if(chain.length ==1) {
						rows[0][pos].mc = dropBubble; 
						rows[0][pos].bc = dropBubble.c; 
					}
					break; 
				}
				
				var p1:Number;
				var p2:Number;
				
				if(i%2==0) { p1=p-1; p2=p; }else{ p1=p; p2=p+1; }
				
				var a:Number;
				var b:Number;
				
				if(p>0 && p<24) {
					a = (rows[i+1][p1].mc == null) ? 0 : 1;
					b = (rows[i+1][p2].mc == null) ? 0 : 1;
					
				}else if(p==0) {
					
					if(i%2==0) {
						a = 2;
						b = (rows[i+1][p2].mc == null) ? 0 : 1;
					}else{
						a = (rows[i+1][p1].mc == null) ? 0 : 1;
						b = (rows[i+1][p2].mc == null) ? 0 : 1;
					}
					
				}else if(p==24) {
					
					if(i%2==0) {
						a = (rows[i+1][p1].mc == null) ? 0 : 1;
						b = 2;
					}else{
						a = (rows[i+1][p1].mc == null) ? 0 : 1;
						b = (rows[i+1][p2].mc == null) ? 0 : 1;
					}
				}
				
				if(a!=2  && b!=2) {
					var choice:Boolean;
					
					if(a==0 && b==0) { choice = Boolean(Math.round(Math.random())); }
					else if(a==1 && b==1) { choice = Boolean(Math.round(Math.random())); }
					else if(a==0 && b==1) { choice = true; }
					else if(a==1 && b==0) { choice = false; }
					
					if(choice) { chain.push(rows[i+1][p1]); p=p1; }else{ chain.push(rows[i+1][p2]); p=p2; }
				
				}else if(a==2) {
					chain.push(rows[i+1][p2]); p=p2;
					
				}else if(b==2) {
					chain.push(rows[i+1][p1]); p=p1;
				}
				
			}
			
			for(var j=chain.length-1; j>0; j--) {
				field['t'+tID++] = new Tween(chain[j-1].mc, 'x', Back.easeOut, chain[j-1].x, chain[j].x, speed, false);
				field['t'+tID++] = new Tween(chain[j-1].mc, 'y', Back.easeOut, chain[j-1].y, chain[j].y, speed, false);
			}
			
			for(var k=chain.length-1; k>0; k--) {
				rows[chain[k].br][chain[k].bp].mc = chain[k-1].mc;
				rows[chain[k].br][chain[k].bp].bc = chain[k-1].bc;
				
				if(k==1) {
					rows[0][pos].mc = dropBubble;
					rows[0][pos].bc = dropBubble.c;
				}
			}
			
			if(gameCheck()) gameComplete();
			
		}
		
		private function removeBubbles(bArray:Array):void {
			action = true;
			popArray = bArray;
			
			popTimer = new Timer(100);
			popTimer.addEventListener(TimerEvent.TIMER, popBubble, false, 0, true);
			popTimer.start();
		}
		
		private function popBubble(e:TimerEvent) {
			if(popArray.length >0) {
				//doc.sound.playSound('pop', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.POP, false);
				
				var val:int = 0;
				switch(shotType) {
					case 0:		val = 10;		break;
					case 1:		val = 50;		break;
					case 2:		val = 50;		break;
					case 10:		val = 25;		break;
					case 11:		val = 100;	break;
					case 12:		val = 100;	break;
				}
				
				new bubbleBlast(effects, popArray[0].bc, popArray[0].x, popArray[0].y, val);
				
				if(shotType == 1 || shotType == 11) doc.effects.createComet(doc.viewport.viewEffects, popArray[0].x+70, popArray[0].y+60, doc.viewport.turtleMark.x,  doc.viewport.turtleMark.y, bubbleColors[popArray[0].bc]);
				if(shotType == 2 || shotType == 12) doc.effects.createComet(doc.viewport.viewEffects, popArray[0].x+70, popArray[0].y+60, doc.viewport.bunnyMark.x,  doc.viewport.bunnyMark.y, bubbleColors[popArray[0].bc]);
				
				doc.viewport.addScore(doc.cannon.shotType, val);
				
				for(var r=0; r<rows.length; r++) {
					for(var p=0; p<rows[r].length; p++) {
						if(rows[r][p] == popArray[0]) {
							field.removeChild(rows[r][p].mc);
							delete rows[r][p].mc;
							rows[r][p].mc = null;
							rows[r][p].bc = null;
							rows[r][p].hook = false;
							break;
						}
					}
				}
				
				popArray.shift();
				
			}else{
				popTimer.stop();
				popTimer.removeEventListener(TimerEvent.TIMER, popBubble);
				orphanCheck();
			}
		}
		
		
		//:::::shot impact handling
		public var shotType:int = 0;
		
		public function locatePosition(bubble:Object, snum:int):void {
			shotType = snum;
			
			//find contacted bubble in the array
			var b:Object;
			
			main:for(var r=0; r<rows.length; r++) {
				for(var p=0; p<rows[r].length; p++) {
					if(rows[r][p].mc == bubble) {
						b = rows[r][p];
						break main;
					}
				}
			}
			
			//find impact data - determine bubble position
			var impactAngle = Math.atan2(doc.cannon.shooter.y - bubble.y, doc.cannon.shooter.x - bubble.x) * 180 / Math.PI;
			var pos:int;
			var newPos:Object;
			var offset = (b.br % 2 == 0) ? 0 : 1;
			
			//trace(impactAngle);
			if(impactAngle >= -30 && impactAngle < 30) pos = 0;
			if(impactAngle >= 30 && impactAngle < 90) pos = 1;
			if(impactAngle >= 90 && impactAngle < 150) pos = 2;
			if(impactAngle >= 150 || impactAngle < -150) pos = 3;
			if(impactAngle < -90 && impactAngle >= -150) pos = 4;
			if(impactAngle < -30 && impactAngle >= -90) pos = 5;
			
			//catch left bounds instance
			if(pos == 2 || pos == 4) { if(b.bp == 0) offset = 1; }
			
			switch(pos) {
				case 0:	newPos = rows[b.br][b.bp+1];						break;
				case 1:	newPos = rows[b.br+1][b.bp+offset];			break;
				case 2:	newPos = rows[b.br+1][b.bp-(1-offset)];		break;
				case 3:	newPos = rows[b.br][b.bp-1];						break;
				case 4:	newPos = rows[b.br-1][b.bp-(1-offset)];		break;
				case 5:	newPos = rows[b.br-1][b.bp+offset];			break;
			}
			
			//assign
			doc.cannon.shooter.x = newPos.x;
			doc.cannon.shooter.y = newPos.y;
			newPos.mc = doc.cannon.shooter;
			newPos.bc = doc.cannon.type;
			
			//***** run match check here*****//
			matchCheck(newPos);
			
		}
		
		public function bouncePop(bubble:Object):void {
			//find contacted bubble in the array
			var b:Object;
			
			main:for(var r=0; r<rows.length; r++) {
				for(var p=0; p<rows[r].length; p++) {
					if(rows[r][p].mc == bubble) {
						b = rows[r][p];
						break main;
					}
				}
			}
			
			//doc.sound.playSound('pop', 0.5);
			mSoundManager.soundPlay(BubbleMaster_SoundID.POP, false);
			
			new bubbleBlast(effects, b.bc, b.x, b.y, 50);
				
			doc.effects.createComet(doc.viewport.viewEffects, b.x+70, b.y+60, doc.viewport.bunnyMark.x,  doc.viewport.bunnyMark.y, bubbleColors[b.bc]);
			
			doc.viewport.addScore(2, 50);
			
			field.removeChild(b.mc);
			delete b.mc;
			b.mc = null;
			b.bc = null;
			b.hook = false;
		}
		
		public function twistyPop(bubble:Object):void {
			//find contacted bubble in the array
			var b:Object;
			
			main:for(var r=0; r<rows.length; r++) {
				for(var p=0; p<rows[r].length; p++) {
					if(rows[r][p].mc == bubble) {
						b = rows[r][p];
						break main;
					}
				}
			}
			
			//doc.sound.playSound('pop', 0.5);
			mSoundManager.soundPlay(BubbleMaster_SoundID.POP, false);
			
			new bubbleBlast(effects, b.bc, b.x, b.y, 50);
				
			doc.effects.createComet(doc.viewport.viewEffects, b.x+70, b.y+60, doc.viewport.turtleMark.x,  doc.viewport.turtleMark.y, bubbleColors[b.bc]);
			
			doc.viewport.addScore(1, 50);
			
			field.removeChild(b.mc);
			delete b.mc;
			b.mc = null;
			b.bc = null;
			b.hook = false;
		}
		
		private function matchCheck(pos:Object):void {
			var match:Array = [pos];
			
			for(var i=0; i<match.length; i++) {
				var r:Number = match[i].br;
				var p:Number = match[i].bp;
				
				if(r % 2 == 1) {
					if(r-1>=0 && rows[r-1][p].bc == match[i].bc) exclude(rows[r-1][p]);
					if(r-1>=0 && p+1<=24 && rows[r-1][p+1].bc == match[i].bc) exclude(rows[r-1][p+1]);
					if(p-1>=0 && rows[r][p-1].bc == match[i].bc) exclude(rows[r][p-1]);
					if(p+1<=23 && rows[r][p+1].bc == match[i].bc) exclude(rows[r][p+1]);
					if(r+1<=18 && rows[r+1][p].bc == match[i].bc) exclude(rows[r+1][p]);
					if(r+1<=18 && p+1<=24 && rows[r+1][p+1].bc == match[i].bc) exclude(rows[r+1][p+1]);
					
				}else{
					if(r-1>=0 && p<=23 && rows[r-1][p].bc == match[i].bc) exclude(rows[r-1][p]);
					if(r-1>=0 && p-1>=0 && rows[r-1][p-1].bc == match[i].bc) exclude(rows[r-1][p-1]);
					if(p-1>=0 && rows[r][p-1].bc == match[i].bc) exclude(rows[r][p-1]);
					if(p+1<=24 && rows[r][p+1].bc == match[i].bc) exclude(rows[r][p+1]);
					if(r+1<=18 && p<=23 && rows[r+1][p].bc == match[i].bc) exclude(rows[r+1][p]);
					if(r+1<=18 && p-1>=0 && rows[r+1][p-1].bc == match[i].bc) exclude(rows[r+1][p-1]);
					
				}
			}
			
			function exclude(ref):void {
				var ex:Boolean = false;
				for(var m=0; m<match.length; m++) { if(ref == match[m]) { ex=true; break; } }
				if(!ex) match.push(ref);
			}
			
			if(match.length >= 3) { removeBubbles(match); }else{ orphanCheck(); }
			
		}
		
		public function orphanCheck():void {
			var orphans = [ ];
			var r:int = 0;
			var p:int = 0;
			
			for(r=0; r<rows.length; r++) {
				for(p=0; p<rows[r].length; p++) {
					rows[r][p].hook = false;
					if(r == 0) rows[0][p].hook = true;
				}
			}
			
			for(r=0; r<rows.length; r++) {
				for(p=0; p<rows[r].length; p++) {
					if(rows[r][p].mc != null) setHook(r, p);
				}
			}
			
			for(r=rows.length-1; r>=0; r--) {
				for(p=rows[r].length-1; p >= 0; p--) {
					if(rows[r][p].mc != null) setHook(r, p);
				}
			}
			
			for(r=0; r<rows.length; r++) {
				for(p=0; p<rows[r].length; p++) {
					if(rows[r][p].mc != null && !rows[r][p].hook) orphans.push(rows[r][p]);
				}
			}
			
			
			if(orphans.length > 0) {
				shotType += 10;
				removeBubbles(orphans);
			}else{
				levelCheck();
			}
			
		}
		
		private function setHook(r, p):void {
			if(rows[r][p].hook) {
				if(r % 2 == 1) {
					if(r-1>=0 && rows[r-1][p].mc != null) rows[r-1][p].hook = true;
					if(r-1>=0 && p+1<=24 && rows[r-1][p+1].mc != null) rows[r-1][p+1].hook = true;
					if(p-1>=0 && rows[r][p-1].mc != null) rows[r][p-1].hook = true;
					if(p+1<=23 && rows[r][p+1].mc != null) rows[r][p+1].hook = true;
					if(r+1<=18 && rows[r+1][p].mc != null) rows[r+1][p].hook = true;
					if(r+1<=18 && p+1<=24 && rows[r+1][p+1].mc != null) rows[r+1][p+1].hook = true;
					
				}else{
					if(r-1>=0 && p<=23 && rows[r-1][p].mc != null) rows[r-1][p].hook = true;
					if(r-1>=0 && p-1>=0 && rows[r-1][p-1].mc != null) rows[r-1][p-1].hook = true;
					if(p-1>=0 && rows[r][p-1].mc != null) rows[r][p-1].hook = true;
					if(p+1<=24 && rows[r][p+1].mc != null) rows[r][p+1].hook = true;
					if(r+1<=18 && p<=23 && rows[r+1][p].mc != null) rows[r+1][p].hook = true;
					if(r+1<=18 && p-1>=0 && rows[r+1][p-1].mc != null) rows[r+1][p-1].hook = true;
					
				}
			}
		}
		
		private function levelCheck():void {
			action = false;
			
			if(gameCheck()) {
				gameComplete();
				return;
			}
			
			if(doc.viewport.levelCount >= doc.viewport.levelGoal) {
				addBubbleTimer.stop();
				addBubbleTimer.removeEventListener(TimerEvent.TIMER, addBubble);
				
				doc.viewport.completeLevel();
				
			}else{
				doc.cannon.loadCannon();
			}
		}
		
		private function gameCheck():Boolean {
			for(var i=0; i<rows[18].length; i++) {
				if(rows[18][i].mc != null) return true;
			}
			return false;
		}
		
		private function gameComplete():void {
			//trace("gameComplete() in bubbleField");
			addBubbleTimer.stop();
			addBubbleTimer.removeEventListener(TimerEvent.TIMER, addBubble);
			
			//if(doc.cannon.live || doc.cannon.flight) field.removeChild(doc.cannon.shooter);
			doc.cannon.resetCannon();
			
			doc.viewport.completeGame();
		}
		
	}
}








