/*
Neopets ada[topms 2/2010
The viewport is the main scene used in the game. 
We are using the viewport bg in all of the scenes.

*/

package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.net.*;
	import com.neopets.util.managers.ScoreManager; // NP
	import com.neopets.util.sound.SoundManager;
	import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID; // new sound files for BubbleMaster
	
	public class viewportEngine extends MovieClip {
		public var doc:Object;
		
		public var hsData:SharedObject;
		public var highscore:int = 0;
		
		public var level:int;
		public var levelGoal:int;
		public var levelCount:int;
		public var levelBubbles:int = 50;
		public var levelBonus:int = 500;
		
		//public var startscreen:MovieClip; // removed 3/2010
		public var levelscreen:MovieClip;
		public var gamescreen:MovieClip;
		
		public var score:int;
		public var tscore:int;
		public var bscore:int;
		
		public var tmax:int;
		public var bmax:int;
		
		public var viewEffects:Sprite = new Sprite();
		
		// added 2/2010 - these vars are necessary since the movieclips are inside the Viewport MC linked to viewportEngine
		public var fieldBG:MovieClip;
		public var turtleBar:MovieClip;
		public var bunnyBar:MovieClip;
		public var scoreBar:MovieClip;
		public var levelBar:MovieClip;
		public var levelBtn:MovieClip;
		
		public var bunnyMark:MovieClip;
		public var turtleMark:MovieClip;
		
		public var bunnyLight:MovieClip;
		public var turtleLight:MovieClip;
		public var bonusClip:MovieClip;
		
		public var muteBtn:MovieClip;
		public var pauseBtn:MovieClip;
		
		public var bCounter:MovieClip;
		public var twisty:MovieClip;
		public var bouncy:MovieClip;
		public var paused:Boolean;
		
		public var mSoundManager:SoundManager;
		
		//public var musicToggleBtn:MovieClip;
		
		public function viewportEngine(scope:Object):void {
			doc = scope;
		
			// startscreen = new StartScreen(this); 
			levelscreen = new LevelScreen(this); 
			gamescreen = new BMGameOverScreen(this); 
			
			initScoreData();
			setBGHandlers();
			resetViewport();
			setButtons();
			
			addChild(viewEffects);
			
			doc.addChildAt(fieldBG, 0);
			doc.addChild(this);
			
			//NP - 3/2010
			mSoundManager = SoundManager.instance;
			
		}
		
		
		
		//:::::button handling
		private function setButtons():void {
			
			// removed - using NP sound instead
			//muteBtn.addEventListener(MouseEvent.ROLL_OVER, function(){muteBtn.gotoAndStop('over');});
			//muteBtn.addEventListener(MouseEvent.ROLL_OUT, function(){muteBtn.gotoAndStop('up');});
			//muteBtn.addEventListener(MouseEvent.CLICK, doc.sound.muteHandler);
			
			
		   // set up the pause button that controls the animal animations
		   pauseBtn.chrome.gotoAndPlay("on");	
		   pauseBtn.gotoAndPlay("on");
		   pauseBtn.addEventListener(MouseEvent.CLICK, pauseAnimation,false,0,true);
		   pauseBtn.buttonMode = true;
		   pauseBtn.addEventListener(MouseEvent.ROLL_OVER, function(){ pauseBtn.gotoAndStop('over') } );
		   pauseBtn.addEventListener(MouseEvent.ROLL_OUT, function(){ pauseBtn.gotoAndStop('up') } );
		
			
			//agBtn.addEventListener(MouseEvent.CLICK, agNav);
		}
		
		 private function pauseAnimation(evt:Event):void
		 {	
		    //trace("pause btn");
			pauseBtn.chrome.gotoAndPlay("off");	
			if(paused) 
			{
				paused = false;
				twisty.play();
				bouncy.play();
			}
			else
			{
				paused = true;
				twisty.stop();
				bouncy.stop();
			}
			
		 }
		
		/*
		// old AG URL
		private function agNav(e:MouseEvent):void {
			var re:URLRequest = new URLRequest('http://www.addictinggames.com/');
			navigateToURL(re, '_blank');
		}
		*/
		
		// Get the user's previous highscore - not used in NP game
		//:::::score data handling
		private function initScoreData():void {
			hsData = SharedObject.getLocal('AGbubblemaster');
			highscore = hsData.data.highscore;
			fieldBG.hsBtn.hsNum.text = String(highscore);
		}
		
		public function saveScoreData():void {
			highscore = score;
			fieldBG.hsBtn.hsNum.text = String(highscore);
			
			hsData.data.highscore = highscore;
			hsData.flush();
		}
		
		
		//:::::public access methods
		/*
		public function initStartScreen():void {
			addChild(startscreen);
		}
		*/
		
		public function completeLevel():void {
			// add later using NP sound manager?
			//doc.sound.playSound('crash', 1);
			mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);
			levelscreen.initLevelScreen();
			trace("completeLevel()");
		}
		
		public function completeGame():void {
			//doc.sound.playSound('crash', 1);
			mSoundManager.soundPlay(BubbleMaster_SoundID.BELL, false);
			gamescreen.initGameOver();
			trace("completeGame()");
		}
		
		public function resetViewport():void {
			score = 0;
			level = 1;
			
			fieldBG.hsBtn.hsNum.text = String(highscore);
			setLevel(1);
		}
		
		
		//:::::level progression handling
		public function setLevel(newLevel:int):void {
			level = newLevel;
			levelGoal = levelBubbles * level;
			levelCount = 0;
			
			fieldBG.levelBtn.levelNum.text = 'level ' + String(level);
			fieldBG.levelBtn.bubbleNum.text = 'bubbles ' + String(levelGoal);
			fieldBG.levelBtn.levelNum.setTextFormat(numFmt, 5, fieldBG.levelBtn.levelNum.length);
			fieldBG.levelBtn.bubbleNum.setTextFormat(numFmt, 7, fieldBG.levelBtn.bubbleNum.length);
			
			tmax = levelBonus * level;
			bmax = levelBonus * level;
			
			tscore = 0;
			bscore = 0;
			turtleBar.bar.scaleY = tscore / tmax;
			bunnyBar.bar.scaleY = bscore / tmax;
			
			turtleMark.y = turtleBar.y;
			bunnyMark.y = bunnyBar.y;
			
			turtleLight.visible = false;
			bunnyLight.visible = false;
			
			levelBar.bar.scaleX = 0;
			scoreBar.scoreField.text = String(score);
			
			
		}
		
		
		//:::::score handling
		// Use NP ScoreManager 3/2010
		public function addScore(type:int, value:int):void {
			
			switch(type) {
				
				// Bubble score
				case 0:
				score += value;
				//trace("score in addScore case 0: "+score);
				ScoreManager.instance.changeScore(value);  // NP Scoring
				scoreBar.scoreField.text = String(score);
				break;
				
				// Twisty score
				case 1:
				score += value;
				ScoreManager.instance.changeScore(value);  // NP Scoring
				
				scoreBar.scoreField.text = String(score);
				tscore += value;
				turtleBar.bar.scaleY = (tscore / tmax < 1) ? Math.floor((tscore / tmax * 100) / 10) * 0.1 : 1;
				turtleMark.y = turtleBar.y - ( 10 * Math.floor((300 * turtleBar.bar.scaleY) / 10) );
				break;
				
				// Bunny Score
				case 2:
				score += value;
				ScoreManager.instance.changeScore(value);  // NP Scoring
				;
				scoreBar.scoreField.text = String(score);
				bscore += value;
				bunnyBar.bar.scaleY = (bscore / bmax < 1) ? Math.floor((bscore / bmax * 100) / 10) * 0.1 : 1;
				bunnyMark.y = bunnyBar.y - ( 10 * Math.floor((300 * bunnyBar.bar.scaleY) / 10) );
				break;
			}
			
			levelCount++;
			levelBar.bar.scaleX = (levelCount / levelGoal < 1) ? levelCount / levelGoal : 1;
			//levelBtn.bubbleNum.text =  'bubbles ' + String(levelGoal - levelCount);
			//levelBtn.bubbleNum.setTextFormat(numFmt, 7, fieldBG.levelBtn.bubbleNum.length);
		}
		
		
		//:::::set bg buttons
		private var numFmt:TextFormat = new TextFormat();
		
		private function setBGHandlers():void {
			numFmt.size = 10;
			
			fieldBG.levelBtn.addEventListener(MouseEvent.ROLL_OVER, levelBtnHandler, false, 0, true);
			fieldBG.levelBtn.addEventListener(MouseEvent.ROLL_OUT, levelBtnHandler , false, 0, true);
			
			fieldBG.hsBtn.addEventListener(MouseEvent.ROLL_OVER, hsBtnHandler, false, 0, true);
			fieldBG.hsBtn.addEventListener(MouseEvent.ROLL_OUT, hsBtnHandler, false, 0, true);
		}
		
		private function levelBtnHandler(e:MouseEvent):void {
			e.target.levelNum.visible = !e.target.levelNum.visible;
			e.target.bubbleNum.visible = !e.target.bubbleNum.visible;
		}
		
		private function hsBtnHandler(e:MouseEvent):void {
			e.target.hsText.visible = !e.target.hsText.visible;
			e.target.hsNum.visible = !e.target.hsNum.visible;
		}
		
		
		
	}//end class
	
}