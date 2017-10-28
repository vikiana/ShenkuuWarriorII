/*
 Neopets adaption - 2/2010 
 NP Game engine also has a class named GameOverScreen, so this one was renamed since it caused conflicts when both classes were imported in Bubblemaster_SetUp
 
 
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	// NP
	import com.neopets.util.sound.SoundManager;
	import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID; // new sound files for BubbleMaster
	import com.neopets.games.inhouse.BubbleMaster.game.bubbleMaster;
	import com.neopets.games.inhouse.BubbleMaster.Bubblemaster_SetUp;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	
	public class BMGameOverScreen extends MovieClip {
		private var scope:Object;
		private var gameTimer:Timer;
		private var gameEvent:Function;
		
		// added 2/2010
		public var hsBar:MovieClip;
		public var goBtn:MovieClip;
		public var scoreField:TextField;
		public var gsBar:MovieClip;
		public var gameComment:TextField;
		public var mSoundManager:SoundManager;
		
		
		
		// -------------------------
		// Constructor
		// -------------------------
		public function BMGameOverScreen(viewport:Object):void {
			scope = viewport;
			x = 320;
			y = 225;
			
			hsBar.visible = false;
			
			goBtn.addEventListener( MouseEvent.ROLL_OVER, GOrollover, false, 0, true );
			goBtn.addEventListener( MouseEvent.ROLL_OUT, GOrollout, false, 0, true );
			//goBtn.addEventListener( MouseEvent.CLICK, GOrestartGame );
			goBtn.mouseEnabled = false;
			
			//NP - 3/2010
			mSoundManager = SoundManager.instance;
			
		}
		
		//::::::public methods
		public function initGameOver():void {
			setGameTimer(2200, viewGameOver);
			//trace("Game Over in BMGameOverScreen");
		}
		
		//:::::timer handling
		private function setGameTimer(time:int, method:Function):void {
			gameEvent = method;
			gameTimer = new Timer(time, 1);
			gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetGameTimer, false, 0, true);
			gameTimer.start();
		}
		
		private function resetGameTimer(e:TimerEvent):void {
			gameTimer.stop();
			gameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetGameTimer);
			gameEvent();
		}
		
		//:::::sequence methods
		private var gamescore:Number;
		private var gameroll:Number;
		
		private function viewGameOver():void {
			scope.addChildAt(this, 0);
			
			gsBar.gotoAndPlay('flash');
			
			gamescore = scope.score;
			trace("gamescore in BMGameOver viewGameOver() : "+gamescore); // Use ScoreManager? ----- Done in LevelScreen.as
			gameroll = Math.round(gamescore * 0.05);
			scoreField.text = '0';
			
			setGameTimer(1000, rollGameScore);
			
		}
		
		private function rollGameScore():void {
			if(gamescore > 0) {
				gamescore -= gameroll;
				scoreField.text = String(Number(scoreField.text) + gameroll);
				
				//scope.doc.sound.playSound('bell', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);	
				//trace("Bell sound - BMGameOver");
				
				var px = 320 + (150 - Math.random() * 300);
				var py = 200 + (20 - Math.random() * 40);
				scope.doc.effects.createBlast(scope.viewEffects, px, py, 2, 2, 0x00FF00);
				
				setGameTimer(100, rollGameScore);
				
			}else{
				scoreField.text = scope.score.toString();
				gsBar.gotoAndStop('on');
				
				if(scope.score > scope.highscore) {
					setGameTimer(1000, viewGameHighscore);
				}else{
					goBtn.gotoAndPlay('flash');
					goBtn.addEventListener( MouseEvent.CLICK, GOrestartGame, false, 0, true );
					goBtn.mouseEnabled = true;
				}
				
			}
		}
		
		public function rollGameBlast(e:Event):void {
			//scope.doc.sound.playSound('bell', 0.5);
			mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);	
			//trace("Bell sound - BMGameOver");
			
			var pt = e.target.position;
			scope.doc.effects.createBlast(scope.viewEffects, pt.x, pt.y, 1, 1, e.target.color);
		}
		
		//:::::highscore roll in methods
		public function viewGameHighscore():void {
			hsBar.bar.gotoAndPlay('flash');
			hsBar.visible = true;
			setGameTimer(100, rollGameHighscore);
		}
		
		private var hsCount:int = 0;
		public function rollGameHighscore():void {
			var px = 320 + (150 - Math.random() * 300);
			var py = 250 + (20 - Math.random() * 40);
			
			scope.doc.effects.createBlast(scope.viewEffects, px, py, 2, 2, 0xFFFF00);
			
			if(hsCount > 20) {
				hsCount = 0;
				hsBar.bar.gotoAndStop('on');
				
				scope.saveScoreData();
				
				goBtn.gotoAndPlay('flash');
				goBtn.addEventListener( MouseEvent.CLICK, GOrestartGame, false, 0, true );
				goBtn.mouseEnabled = true;
			}else{
				hsCount++;
				//scope.doc.sound.playSound('bell', 0.5);
				mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);	
				
				setGameTimer(100, rollGameHighscore);
			}
		}
		
		
		//:::::button handlers
		private function GOrollover(e:MouseEvent):void {
			if(e.target.mouseEnabled) e.target.gotoAndStop('on');
		}
		
		private function GOrollout(e:MouseEvent):void {
			if(e.target.mouseEnabled) e.target.gotoAndPlay('flash');
		}
		
		public function GOrestartGame(e:MouseEvent):void {
			trace("restart game BMGameOver");
			goBtn.removeEventListener( MouseEvent.CLICK, GOrestartGame );
			e.target.mouseEnabled = false;
			e.target.gotoAndStop('off');
			hsBar.bar.gotoAndStop('off');
			hsBar.visible = false;
			
			parent.removeChild(this);
			scope.doc.restartGame();
			
			// 3/2010 - go to NP game end screen
			MenuManager.instance.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
		}
	}
	
}