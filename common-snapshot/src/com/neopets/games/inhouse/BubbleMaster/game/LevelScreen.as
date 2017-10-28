/*
 Neopets adaption - 2/2010
 The level screen that appears after each level
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	import com.neopets.games.inhouse.BubbleMaster.game.effectsEngine;
	
	
	// NP
	import com.neopets.util.sound.SoundManager;
	import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID; // new sound files for BubbleMaster
	import com.neopets.util.managers.ScoreManager; 
	
	public class LevelScreen extends MovieClip {
		private var doc:Object;
		private var scope:Object;
		
		private var levelTimer:Timer;
		private var levelEvent:Function;
		
		private var levelscoreT:int = 0;
		private var levelscoreB:int = 0;
		
		private var bonusRate:int = 100;
		
		// added vars 2/2010
		public var  goBtn:MovieClip;
		public var  bbar:MovieClip;
		public var  bBonusField:TextField;
		public var  tBonusField:TextField;
		public var  tbar:MovieClip;
		public var  levelField:TextField;
		public var  turtleBar:MovieClip;
		public var  turtleMark:MovieClip;
		public var mSoundManager:SoundManager;
		
		
		public function LevelScreen(viewport:Object):void {
			scope = viewport;
			doc = scope.doc;
			
			this.x = 320; // added 'this'
			this.y = 225;
			goBtn.addEventListener( MouseEvent.ROLL_OVER, GBrollover, false, 0, true );
			goBtn.addEventListener( MouseEvent.ROLL_OUT, GBrollout, false, 0, true );
			//goBtn.addEventListener( MouseEvent.CLICK, GBbeginNextLevel );
			goBtn.mouseEnabled = false;
			mSoundManager = SoundManager.instance;
			
		}
		
		//:::::public methods
		public function initLevelScreen():void {
			setLevelTimer(2200, viewLevel);
		}
		
		
		//:::::initiate levelscreen sequence
		private function viewLevel():void {
			scope.level++;
			levelField.text = 'next level ' + scope.level;
			
			tbar.gotoAndStop('off');
			bbar.gotoAndStop('off');
			goBtn.gotoAndStop('off');
			goBtn.mouseEnabled = false;
			
			levelscoreT = scope.tscore;
			levelscoreB = scope.bscore;
			tBonusField.text = '0';
			bBonusField.text = '0';
			
			scope.addChildAt(this, 0);
			
			tbar.gotoAndPlay('flash');
			setLevelTimer(1000, tscoreLevel);
		}
		
		
		//:::::tscore rollout  - 
		// NP - this is the Twisty Turtle score that gets gets added to the Level Screen
		private function tscoreLevel():void {
			
			//trace(" ----------  tscoreLevel() -------------");
			if(levelscoreT > 0) {
				//doc.sound.playSound('pop', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.POP, false);	
				//trace("Pop sound - Level Screen");
				
				levelscoreT -= scope.tscore / 10;
				if(levelscoreT < 0) levelscoreT = 0;
				
				tBonusField.text = String( (scope.tscore - levelscoreT) * 10 );
				
				
				// NP - Turtle Score - use score in scoreBlast() instead
				// var tScore:Number = (scope.tscore - levelscoreT) * 10;
				// ScoreManager.instance.changeScore(tScore);
				//trace( "tBonusField: " +tScore);
				
				var bx = 320 + (150 - Math.random() * 300);
				doc.effects.createComet(scope.viewEffects, scope.turtleMark.x+30, scope.turtleMark.y-30, bx, 200, 0x00FF00, tscoreBlast);
				doc.effects.createBlast(scope.viewEffects, scope.turtleMark.x, scope.turtleMark.y+30, 2, 2, 0x00FF00);
				 
				scope.turtleBar.bar.scaleY = (levelscoreT > 0) ? Math.floor((levelscoreT / scope.tscore * 100) / 10) * 0.1 : 0;
				scope.turtleMark.y = scope.turtleBar.y - ( 10 * Math.floor((300 * scope.turtleBar.bar.scaleY) / 10) );
				
				setLevelTimer(100, tscoreLevel);
				
			}else{
				if(scope.tscore > 0) {tbar.gotoAndStop('on');}
				//else{ doc.sound.playSound('buzzer', 0.25); tbar.gotoAndPlay('zip'); }
				
				else { mSoundManager.soundPlay(BubbleMaster_SoundID.BUZZER, false); tbar.gotoAndPlay('zip'); }
					
				
				if(scope.tscore >= scope.tmax) {
					setLevelTimer(1000, tscoreMAX);
					
				}else{
					bbar.gotoAndPlay('flash');
					setLevelTimer(1000, bscoreLevel);
				}
				
			}
		}
		
		public function tscoreBlast(e:Event):void {
			var pt = e.target.position;
			doc.effects.createBlast(scope.viewEffects, pt.x, pt.y, 2, 2, e.target.color);
		}
		
		private var tnum:int = 0;
		
		private function tscoreMAX():void {
			if(tnum == 0) {
				var tm = new turtleMedal();
				tm.name = 'tmedal';
				tm.x = 170;
				tm.y = -25;
				addChild(tm);
			}
			
			if(tnum <5) {
				//doc.sound.playSound('bell', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);
				
				var bx = 320 + (150 - Math.random() * 300);
				var by = 200 + (20 - Math.random() * 40);
				doc.effects.createBlast(scope.viewEffects, bx, by, 2, 2, 0x00FF00);
				tnum++;
				setLevelTimer(100, tscoreMAX);
				
			}else if(tnum >4 && tnum <10) {
				tnum++;
				setLevelTimer(100, tscoreMAX);
			
			}else{
				//doc.sound.playSound('blip', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BLIP, false);
				
				for(var i=0; i<5; i++) {
					var b2x = 410 + (20 - Math.random() * 40);
					var b2y = 200 + (10 - Math.random() * 20);
					doc.effects.createBlast(scope.viewEffects, b2x, b2y, 2, 2, 0xFFFFFF);
				}
				
				scope.tscore *=2;
				tBonusField.text  = String(scope.tscore * 10);
				tnum=0;
				
				bbar.gotoAndPlay('flash');
				setLevelTimer(1000, bscoreLevel);
				
			}
		}
		
		
		//:::::bscore rollout
		// NP - this is the bouncy bunny score that gets gets added to the Level Screen
		private function bscoreLevel():void {
			
			//trace(" ----------  bscoreLevel() -------------");
			if(levelscoreB > 0) {
				//doc.sound.playSound('pop', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.POP, false);
				
				levelscoreB -= scope.bscore  / 10;
				if(levelscoreB < 0) levelscoreB = 0;
				
				bBonusField.text = String( (scope.bscore - levelscoreB) * 10 );
				//trace( "bBonusField: " +(scope.bscore - levelscoreB) * 10 );
				
				// NP Bunny Score - use score in scoreBlast() instead
				//var bScore:Number = (scope.bscore - levelscoreB) * 10;
				//ScoreManager.instance.changeScore(bScore);
				
				var bx = 320 + (150 - Math.random() * 300);
				doc.effects.createComet(scope.viewEffects, scope.bunnyMark.x-30, scope.bunnyMark.y-30, bx, 250, 0xFFFF00, bscoreBlast);
				doc.effects.createBlast(scope.viewEffects, scope.bunnyMark.x, scope.bunnyMark.y+30, 2, 2, 0xFFFF00);
				 
				scope.bunnyBar.bar.scaleY = (levelscoreB > 0) ? Math.floor((levelscoreB / scope.bscore * 100) / 10) * 0.1 : 0;
				scope.bunnyMark.y = scope.bunnyBar.y - ( 10 * Math.floor((300 * scope.bunnyBar.bar.scaleY) / 10) );
				
				setLevelTimer(100, bscoreLevel);
				
			}else{
				
				if(scope.bscore > 0) { bbar.gotoAndStop('on') }
				//else{ doc.sound.playSound('buzzer', 0.25); bbar.gotoAndPlay('zip'); }
				else { mSoundManager.soundPlay(BubbleMaster_SoundID.BUZZER, false); tbar.gotoAndPlay('zip'); }
				
				if(scope.bscore >= scope.bmax) {
					setLevelTimer(1000, bscoreMAX);
					
				}else{
					setLevelTimer(1000, scoreLevelA);
				}
				
			}
		}
		
		public function bscoreBlast(e:Event):void {
			var pt = e.target.position;
			doc.effects.createBlast(scope.viewEffects, pt.x, pt.y, 2, 2, e.target.color);
		}
		
		private var bnum:int = 0;
		
		private function bscoreMAX():void {
			if(bnum == 0) {
				var bm = new bunnyMedal();
				bm.name = 'bmedal';
				bm.x = 170;
				bm.y = 25;
				addChild(bm);
			}
			
			if(bnum < 5) {
				//doc.sound.playSound('bell', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false); 
				//trace("Bell sound - Level Screen");
				
				var bx = 320 + (150 - Math.random() * 300);
				var by = 250 + (20 - Math.random() * 40);
				doc.effects.createBlast(scope.viewEffects, bx, by, 2, 2, 0xFFFF00);
				bnum++;
				setLevelTimer(100, bscoreMAX);
				
			}else if(bnum >4 && bnum<10) {
				bnum++;
				setLevelTimer(100, bscoreMAX);
				
			}else{
				//doc.sound.playSound('blip', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BLIP, false); 
				//trace("Blip sound - Level Screen");
				for(var i=0; i<5; i++) {
					var b2x = 410 + (20 - Math.random() * 40);
					var b2y = 250 + (10 - Math.random() * 20);
					doc.effects.createBlast(scope.viewEffects, b2x, b2y, 2, 2, 0xFFFFFF);
				}
				
				scope.bscore *=2;
				bBonusField.text  = String(scope.bscore * 10);
				bnum=0;
				
				setLevelTimer(1000, scoreLevelA);
				
			}
		}
		
		
		//:::::score addition rollout
		private function scoreLevelA():void {
			if(scope.tscore > 0) {
				//doc.sound.playSound('thwang', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.THWANG, false); 
				
				
				doc.effects.createBlast(scope.viewEffects, 390, 200, 2, 2, 0xFFFFFF);
				doc.effects.createComet(scope.viewEffects, 390, 200, 460, 465, 0xFFFFFF, scoreBlast, {type:'tscore'} );
				
			}else{ scoreLevelB(); }
		}
		
		private function scoreLevelB():void {
			if(scope.bscore > 0) {
				//doc.sound.playSound('thwang', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.THWANG, false); 
				
				
				doc.effects.createBlast(scope.viewEffects, 390, 250, 2, 2, 0xFFFFFF);
				doc.effects.createComet(scope.viewEffects, 390, 250, 460, 465, 0xFFFFFF, scoreBlast, {type:'bscore'} );
				
			}else{ scoreLevelC(); }
		}
			
		private function scoreLevelC():void {
			goBtn.gotoAndPlay('flash');
			goBtn.mouseEnabled = true;
			goBtn.addEventListener( MouseEvent.CLICK, GBbeginNextLevel, false, 0, true );
		}
		
		private var scoreNum:int = 0;
		
		public function scoreBlast(e:Event):void {
			//trace(e.target.props.type);
			
			//doc.sound.playSound('bell', 0.5);
			mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false); 
			
			for(var i=0; i<5; i++) {
				var xp = Math.round(460 + (30 - Math.random() * 60));
				var yp = Math.round(465 + (15 - Math.random() * 30));
				doc.effects.createBlast(scope.viewEffects, xp, yp, 2, 2, 0xFFFFFF);
			}
			
			if(e.target.props.type == 'tscore') {
				scope.score += (scope.tscore * 10);
				scope.scoreBar.scoreField.text = String(scope.score);
				
				trace("scope.score1: " +scope.score);
				ScoreManager.instance.changeScoreTo(scope.score); // NP 3/2010
				setLevelTimer(1000, scoreLevelB);
				
			}else if(e.target.props.type == 'bscore') {
				scope.score += (scope.bscore * 10);
				scope.scoreBar.scoreField.text = String(scope.score); 
				
				trace("scope.score2: " +scope.score);
				ScoreManager.instance.changeScoreTo(scope.score); // NP
				
				setLevelTimer(1000, scoreLevelC);
			}
			
		}
		
		
		//:::::timer handlers
		private function setLevelTimer(time:int, method:Function):void {
			levelEvent = method;
			levelTimer = new Timer(time, 1);
			levelTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetLevelTimer, false, 0, true);
			levelTimer.start();
		}
		
		private function resetLevelTimer(e:TimerEvent):void {
			levelTimer.stop();
			levelTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetLevelTimer);
			
			levelEvent();
		}
		
		
		//:::::button handlers
		private function GBrollover(e:MouseEvent):void {
			if(e.target.mouseEnabled) e.target.gotoAndStop('on');
		}
		
		private function GBrollout(e:MouseEvent):void {
			if(e.target.mouseEnabled) e.target.gotoAndPlay('flash');
		}
		
		private function GBbeginNextLevel(e:MouseEvent):void {
			goBtn.removeEventListener( MouseEvent.CLICK, GBbeginNextLevel );
			e.target.mouseEnabled = false;
			e.target.gotoAndStop('off');
			
			if(getChildByName('tmedal') != null) removeChild(getChildByName('tmedal'));
			if(getChildByName('bmedal') != null) removeChild(getChildByName('bmedal'));
			parent.removeChild(this);
			
			scope.setLevel(scope.level);
			//doc.bubblefield.startBubbleField();
			doc.bubblefield.resetLevelField();
		}
		
	}
}