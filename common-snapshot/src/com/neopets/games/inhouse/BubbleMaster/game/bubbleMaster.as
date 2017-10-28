/*
 Neopets adaption - 2/2010
*/

package com.neopets.games.inhouse.BubbleMaster.game {
	import flash.display.*;
	import flash.events.*;
	
	
	public class bubbleMaster extends MovieClip {
		
		public var bubblefield:bubbleField;
		public var cannon:cannonEngine;
		public var viewport:viewportEngine;
		public var effects:effectsEngine;
		
		// added 2/2010
		public var paused:Boolean;
		//public var sound:soundEngine; // use Neopets sound engine instead
		public var bouncy:MovieClip;
		public var twisty:MovieClip;
		
		
		public function bubbleMaster():void {
			trace("bubbleMaster constructor -----------------");
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//sound = new soundEngine(this); // use neopets class instead
			
			
			effects = new effectsEngine(this); 
			bubblefield = new bubbleField(this);
			viewport = new viewportEngine(this); 
			cannon = new cannonEngine(this);
			//sound.playLoop();
			// viewport.initStartScreen(); removed 3/2010
			
		}
		
		public function restartGame():void {
			trace("restart game in bubbleMaster.as");
			bubblefield.resetField(); 
			viewport.resetViewport();
			 
			
			//viewport.initStartScreen(); // NP - removed
			
			
		}
		
		public function startGame():void {
			//trace("bubble master started");
			bubblefield.initField();
		}
		
		
		public function pauseGame(e:MouseEvent):void {
			//trace("Pause btn");
			viewport.pauseBtn.chrome.gotoAndStop( (viewport.pauseBtn.chrome.currentLabel == 'on') ? 'off' : 'on' );
			
			if(paused) {
				paused = false;
				//sound.playLoop(); // controlled in Bubblemaster_SetUp.as now
				bubblefield.pauseControl();
				cannon.flightControl();
				
				viewport.twisty.play();
				viewport.turtleLight.play();
				viewport.turtleMark.play();
				
				viewport.bouncy.play();
				viewport.bunnyLight.play();
				viewport.bunnyMark.play();
				
			}else{
				paused = true;
				bubblefield.pauseControl();
				//cannon.flightControl();
				//sound.stopSound();
				
				viewport.twisty.stop();
				viewport.turtleLight.stop();
				viewport.turtleMark.stop();
				
				viewport.bouncy.stop();
				viewport.bunnyLight.stop();
				viewport.bunnyMark.stop();
			}
		}
		
		
		
	}
	
}