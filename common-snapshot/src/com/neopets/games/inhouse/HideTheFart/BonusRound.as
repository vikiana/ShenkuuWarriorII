/* Nov 3, 2010 


	- If chariot is on stage, character can fart and get points
	
	- If character farts while chariot is on stage, game will end
	
	- End message will either say "Time's Up, Game Over", or "You Got Caught"
	
	- Check to make sure all necessary listeners have been removed
	
	- Add soundtrack back in


*/


package com.neopets.games.inhouse.HideTheFart
{

	// IMPORTS
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.games.inhouse.HideTheFart.HideTheFartGame;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	// Specific Trivia game imports
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	//import flash.utils.getTimer;
	
	

	// CLASS DEFINITION
	public class BonusRound extends MovieClip
	{
		
		
		//-------------------------------------------------------------
		// PROPERTIES
		//-------------------------------------------------------------
		public var playerOne:PlayerOne;
		public var playerTwo:PlayerTwo;
		private var chariotLeft:ChariotLeft;
		private var chariotRight:ChariotRight;
		private var bonusGameSprite:Sprite;// contains everything
		private var hideTheFart:HideTheFartGame;
		
		//Sound
		private var fart:Fart;
		private var chariotSound:ChariotSound;
		private var soundChannel:SoundChannel;
		private var playFart:Boolean;
		
		private var mainFormat:TextFormat;
		private var bonusScoreField:TextField;
		private var messageField:TextField;
		private var gameButton:GameButton;// generic button
		
		// Timer
		//private var gameStartTime:uint;
		//private var gameTime:uint;
		private var gameTimeField:TextField;
		private var timer:Timer;
		private var chariotTimer:Timer;
		
		private var mainTimerOver:Boolean;
		private var chariotOnStage:Boolean;
		
		
		//-------------------------------------------------------------
		// CONSTRUCTOR
		//-------------------------------------------------------------
		public function BonusRound()
		{
			trace("BonusRound Constructor");
		}
	
		// Called in HideTheFartGames.as
		public function initBonusRound()
		{
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, rightKeyCheck);
			stage.addEventListener(KeyboardEvent.KEY_UP, leftKeyCheck);
		
			// Sounds
			fart = new Fart();
			chariotSound = new ChariotSound();
		
			// Text
			bonusScoreField = new TextField();
			bonusScoreField.text = "Score: "+ ScoreManager.instance.getValue();// score from Trivia round
			bonusScoreField.selectable = false;
			
			mainFormat = new TextFormat();
			mainFormat.font = "Arial";
			mainFormat.size = 18;
			mainFormat.bold = true;
			bonusScoreField.setTextFormat(mainFormat);
			
			addChild(bonusScoreField);
			bonusScoreField.width = 150;
			bonusScoreField.x = 15;
			bonusScoreField.y = 575;
			
			// Time text field
			gameTimeField = new TextField();
			gameTimeField.x = 15;
			gameTimeField.y = 550;
			gameTimeField.width = 150;
			addChild(gameTimeField);
			gameTimeField.selectable = false;
			gameTimeField.text = "Time: ";
			gameTimeField.setTextFormat(mainFormat);
			
			// Start button
			gameButton = new GameButton();
			gameButton.btn_txt.text = "Begin Bonus Round";
			gameButton.x = 225;
			gameButton.y = 450;
			addChild(gameButton);
			gameButton.addEventListener(MouseEvent.CLICK,startBonusRound);
			
			// when clicking the Next Question button
			gameButton.btn_txt.mouseEnabled = false;
			gameButton.buttonMode = true;
			
			mainTimerOver = false; //reset
			
		}
		
		private function startBonusRound(event:MouseEvent):void
		{
			trace("--- startBonusRound() ---");
			
			removeChild(gameButton);
			addCharacters();
			MainTimer();
			
			// necessary - otherwise the stage needs to be clicked for the keyboard events to work
			stage.focus = stage; 
			
			
			
			
		
		}
		
		private function MainTimer()
		{
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onUpdateTime);
			timer.start();
		}
		
		private function onUpdateTime(event:Event):void
		{
			gameTimeField.text = "Time: "+String(timer.currentCount);
			gameTimeField.setTextFormat(mainFormat);
			
			//End Game and reset timer when it reaches 10 
			if(timer.currentCount >= 10)
			{
				trace("Main Timer over");
				mainTimerOver = true;
				timer.reset();
				soundChannel.stop(); // turn off any sounds
				
				// Add message text field
				messageField = new TextField();
				messageField.setTextFormat(mainFormat);
				addChild(messageField);
				messageField.x = 220;
				messageField.y = 435;
				messageField.width = 300;
				messageField.text = "Time's up. Game over!";
				messageField.setTextFormat(mainFormat);
				messageField.selectable = false;
				
				// Move score text field
				bonusScoreField.x = 250;
				bonusScoreField.y = 465;
				bonusScoreField.text = "Final Score: "+ ScoreManager.instance.getValue();// score from Trivia round
				bonusScoreField.setTextFormat(mainFormat);
				
				// remove timer text
				removeChild(gameTimeField);
				
				// add game over stuff here
				cleanUpBonusRound();
				//removeEventListener(Event.ENTER_FRAME, onLeftChariotEnterFrame)
			}
			
			//TODO reset timer if quit btn is pressed?
		}
		
		// End the game if the character farts at the wrong time
		private function endGameLose()
		{
			    mainTimerOver = true; // will stop chariot in updateChariotTimer()
				timer.reset();
				soundChannel.stop(); // turn off any sounds
				
				// Add message text field
				messageField = new TextField();
				messageField.setTextFormat(mainFormat);
				addChild(messageField);
				messageField.width = 300;
				messageField.x = 180;
				messageField.y = 435;
				messageField.text = "You've been caught. Game over!";
				messageField.setTextFormat(mainFormat);
				messageField.selectable = false;
				
				// Move score text field
				bonusScoreField.x = 250;
				bonusScoreField.y = 465;
				bonusScoreField.text = "Final Score: "+ ScoreManager.instance.getValue();// score from Trivia round
				bonusScoreField.setTextFormat(mainFormat);
				
				// remove timer text
				removeChild(gameTimeField);
				
				// add game over stuff here
				cleanUpBonusRound();
		}
		
		
	
		private function addCharacters():void
		{
			// create main characters in sprite
			bonusGameSprite = new Sprite();
			addChild(bonusGameSprite);
			
			playChariotLeft(); // first time, play chariot without a delay
			
			
			//character on right
			playerOne = new PlayerOne();
			bonusGameSprite.addChildAt(playerOne,1); 
			playerOne.x = 350;
			playerOne.y = 200;
			playerOne.scaleX = .7;
			playerOne.scaleY = .7;
			
			playerTwo = new PlayerTwo();
			bonusGameSprite.addChildAt(playerTwo,2); 
			playerTwo.x = 50;
			playerTwo.y = 200;
			playerTwo.scaleX = .7;
			playerTwo.scaleY = .7;
			playerTwo.scaleY = .7;
		
		}
		
		private function playChariotLeft():void
		{
			chariotLeft = new ChariotLeft()
			bonusGameSprite.addChildAt(chariotLeft,0);
			chariotLeft.x = 570;
			chariotLeft.y = 400;
			chariotLeft.scaleX = .7;
			chariotLeft.scaleY = .7;
			chariotLeft.gotoAndPlay("distract");
			
			trace("Sound Channel: " +soundChannel)
			soundChannel = new SoundChannel();
			soundChannel = chariotSound.play(); 
			
			trace("playChariotLeft()");
			//play chariot again 
			checkLeftChariotFrame(null);
			
		}
		
		/*
			checkLeftChariotFrame(null); // check if chariot is on stage
			soundChannel = chariotSound.play();
		*/
				
		
		private function checkLeftChariotFrame(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onLeftChariotEnterFrame)
		}
	
		private function onLeftChariotEnterFrame(event:Event):void
		{
			//trace("Label: "+chariotLeft.currentLabel);
			
			if(chariotLeft.currentLabel == "animationOver")
			{
				// play again
				playChariotTimer(); // chariot will now play every 3 seconds 
				removeEventListener(Event.ENTER_FRAME, onLeftChariotEnterFrame)
				
				//Boolean if chariot not on stage
				chariotOnStage = false;
			}
			
			if(chariotLeft.currentLabel == "distract")
			{
				//Boolean if chariot not on stage
				chariotOnStage = true;
			}
		}
		
		private function playChariotTimer():void
		{
			// play chariot every 4 seconds
			chariotTimer = new Timer(4000);
			chariotTimer.addEventListener(TimerEvent.TIMER, updateChariotTimer);
			chariotTimer.start();
		}
		
		private function updateChariotTimer(event:Event):void
		{
			// If there is still time left, play again
			if(!mainTimerOver)
			{
				trace("Play chariot again");
				playChariotLeft();
			}
		}
		
	
		private function rightKeyCheck(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.RIGHT)
			{
				//trace("right key");
				playerOne.gotoAndStop("startFarting");
				if(!playFart)
				{
					soundChannel = fart.play();
					playFart = true;
					
					if(chariotOnStage)
					{
						trace("Farting while chariot on stage - add points");
						// Update score after farts
						ScoreManager.instance.changeScore(25); 
						trace("New score: "+ScoreManager.instance.getValue());
					
						bonusScoreField.text = "Score: "+ ScoreManager.instance.getValue();
						bonusScoreField.setTextFormat(mainFormat); // needs to be reset
					}
					
					if(!chariotOnStage)
					{
						trace("------- END GAME HERE ----");
						endGameLose(); 
					}
				}
				
				
			}
			
			
		}
		
		
		private function leftKeyCheck(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.LEFT)
			{
				//trace("left key");
				playerOne.gotoAndStop("stopFarting");
				playFart = false;
			}
		}
		
		public function cleanUpBonusRound()
		{
			trace("---- Clean up Bonus Round ----");
			if(bonusGameSprite != null && this.contains(bonusGameSprite))
			{
				removeChild(bonusGameSprite);
				bonusGameSprite = null;
			}
			
			if(playerOne != null && this.contains(playerOne))
			{
				playerOne = null;
			}
			
			if(playerTwo != null && this.contains(playerTwo))
			{
				playerTwo = null;
			}
			
			if(chariotLeft != null && this.contains(chariotLeft))
			{
				chariotLeft = null;
			}
			
			// Remove listeners
			//trace("Stage: "+stage);  - stage is null once trivia game starts over
			if(stage != null && stage.hasEventListener(KeyboardEvent.KEY_DOWN))
			 {
				 stage.removeEventListener(KeyboardEvent.KEY_DOWN, rightKeyCheck);  
			 }
			 
			if(stage != null && stage.hasEventListener(KeyboardEvent.KEY_UP))
			 {
				
				stage.removeEventListener(KeyboardEvent.KEY_UP, leftKeyCheck);
			 }
			
			
			// Removing these listeners causes errors when quitting the game
			/*
			if(this.hasEventListener(Event.ENTER_FRAME))
			 {
				removeEventListener(Event.ENTER_FRAME,  onLeftChariotEnterFrame) 
			 }
			
			
			if (timer.hasEventListener(TimerEvent.TIMER))
			{
				timer.removeEventListener(TimerEvent.TIMER, onUpdateTime);
			}
			
			if(chariotTimer.hasEventListener(TimerEvent.TIMER))
			   {
				   chariotTimer.removeEventListener(TimerEvent.TIMER, updateChariotTimer);
			   }
			   
			*/
			
			//gameButton.remove(MouseEvent.CLICK,startBonusRound);
			
			
			
		}
		
		
		
	} // End of Class
	
}