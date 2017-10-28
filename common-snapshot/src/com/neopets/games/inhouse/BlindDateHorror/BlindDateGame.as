package com.neopets.games.inhouse.BlindDateHorror {
	
	// IMPORTS
	
	//import com.coreyoneil.collision.CollisionGroup;
	//import com.coreyoneil.collision.CollisionList;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	// CLASS DEFINITION
	public class BlindDateGame extends MovieClip{
		
		//-------------------------------------------------------------
		// PROPERTIES
		//-------------------------------------------------------------
		private var boyDirection:String; // character's starting position
		private var girlDirection:String;
		private var fratBoy:FratBoy;
		private var couple1:Couple1;
		private var couple2:Couple2;
		private var counterBG:CounterBG;
		private var table1:Table;
		private var table2:Table;
		private var table3:Table;
		private var door:Door;
		private var door2:Door;
		private var exitDoor:ExitDoor;
		private var girlOne:GirlOne;
		private var arrow:Arrow;
		private var arrow2:Arrow;
		//private var collisionList:CollisionList; // Detection Kit
		private var gameTimer:Timer;
		private var timeDisplay:TextField; // on stage
		private var timerFormat:TextFormat; // on stage
		private var animationOne:AnimationOne;
		private var registerTimer:Timer;
		private var gotDonut:Boolean; // fratboy got donut before being caught by girl
		
		private var box:Box;
		public var endLevelScreen:EndLevelScreen;
		//-------------------------------------------------------------
		// CONSTRUCTOR
		//-------------------------------------------------------------
		public function BlindDateGame() 
		{
			// initial character boyDirection
			boyDirection = "down"; 
			girlDirection = "down"; 
			initStageObjects();
			createTimerText();	
			endLevelScreen = new EndLevelScreen();
		}
		
		
		//-------------------------------------------------------------
		// METHODS
		//-------------------------------------------------------------
		public function startGame():void
		{
			trace("Blind Date started");	
			// After start game is clicked, you have access to the stage
			initListeners();
			//trace("Num of children: "+numChildren);
			startTimer();	
		}
		
		
		private function initListeners():void
		{
			
			//viv - add listener for additional menu screen button events
			MenuManager.instance.addEventListener(MenuManager.instance.MENU_BUTTON_EVENT, onMenuButtonPressed);
			//
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveFratBoy);
			stage.addEventListener(Event.ENTER_FRAME, moveGirlDown); // basic movement, need to give her real AI
			stage.addEventListener(Event.ENTER_FRAME, scaleFratBoy);
			stage.addEventListener(Event.ENTER_FRAME, scaleGirlOne);
			stage.addEventListener(Event.ENTER_FRAME, reachedRegister); // see if fratboy makes it to the register
			
			//stage.addEventListener(Event.ENTER_FRAME, checkCollisions); // Basic hitTest collision
			//stage.addEventListener(Event.ENTER_FRAME, checkForCollisions); // Collision Detection Kit	
		}
		
		private function createTimerText():void
		{
			// Text field
			timeDisplay = new TextField();
			timeDisplay.x = 40;
			timeDisplay.y = 370;
			addChildAt(timeDisplay,10);
		
			// Text format
			timerFormat = new TextFormat();
			timerFormat.font = "Arial";
			timerFormat.color = 0xFFFFFF;
			timerFormat.size = 14;
			timeDisplay.defaultTextFormat = timerFormat;
			
			timeDisplay.text = "0";
		}
		
		public function startTimer()
		{
			//Initialize timer
			gameTimer = new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, updateTime);
			gameTimer.start();
		}
		
		// Displays timer and ends game after 10 seconds (for testing purposes)
		private function updateTime(event:Event):void
		{
			timeDisplay.text = String(gameTimer.currentCount);
		
			//Stop timer when it reaches 15 seconds
			if (gameTimer.currentCount == 15)
			{
				gameTimer.stop();
				trace('timer stopped - level over');
				gameTimer.removeEventListener(TimerEvent.TIMER, updateTime);
				// stop game
				endLevelOne();
				//play 'lose' animation
				playAnimationOne();	
			}
		}
		
		// Make accessible to BlindDateEngine class
		internal function endTimer():void
		{
			trace("endTimer()");
			gameTimer.removeEventListener(TimerEvent.TIMER, updateTime);
		}

		
		// Girl spanking fratboy animation ------------------------------------------------------------------
		private function playAnimationOne():void
		{
			animationOne = new AnimationOne();
			addChild(animationOne);
			animationOne.addEventListener(Event.ENTER_FRAME, checkFrameLabel);
		}
		
		
		
       // remove after animation completed
		private function checkFrameLabel(e:Event):void
		{
			if(animationOne.currentLabel == "animationEnd")
			{
				trace("End of Animation");
				removeChild(animationOne);
				animationOne.removeEventListener(Event.ENTER_FRAME, checkFrameLabel);
				// remove old instance of game and play again
				resetLevelOne();
				startGame();
			}
		}
		
		internal function endLevelOne():void
		{
			trace("endLevelOne()");
		
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, moveFratBoy);
			stage.removeEventListener(Event.ENTER_FRAME, moveGirlDown); 
			stage.removeEventListener(Event.ENTER_FRAME, moveGirlRight); 
			stage.removeEventListener(Event.ENTER_FRAME, moveGirlUp); 	
			stage.removeEventListener(Event.ENTER_FRAME, reachedRegister);
		}
		
		
		internal function resetLevelOne():void
		{
			trace("resetLevelOne()");
			// remove and add again
			removeChild(fratBoy);
			removeChild(girlOne);
			
			// Girl
			girlOne = new GirlOne;
			addChildAt(girlOne,7);
			girlOne.x = 165;
			girlOne.y = 225;
			//girlOne.gotoAndStop("down"); 
			
			
			// Fratboy
			fratBoy = new FratBoy;
			addChildAt(fratBoy,10);
			fratBoy.x = 250;
			fratBoy.y = 400;
			fratBoy.scaleX = .4;
			fratBoy.scaleY = .4;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveFratBoy);
			stage.addEventListener(Event.ENTER_FRAME, moveGirlDown); 
			
			boyDirection = "down"; 
			girlDirection = "down"; 
			
		}
		
	
/*  Objects dynamically added to stage since declaring and accessing movieclips in 
	BlindDateHorrorGameScreen.as wasn't working.
	Used addChildAt to help with depth sorting
*/
		
		private function initStageObjects():void
		{
			// counter
			counterBG = new CounterBG;
			addChildAt(counterBG,0);
			counterBG.x = 40;
			counterBG.y = 175;
			
			// arrow
			arrow = new Arrow;
			addChildAt(arrow,1);
			arrow.rotation = 90;
			arrow.x = 230;
			arrow.y = 3;
			
			// Tables
			table1 = new Table;
			table2 = new Table;
			table3 = new Table;
			addChildAt(table1,2);
			addChildAt(table2,3);
			addChildAt(table3,4);
			
			table1.x = 45;
			table1.y = 275;
			
			table2.x = 255;
			table2.y = 300;
			
			table3.x = 395;
			table3.y = 245;
			
			//Couple 1
			couple1 = new Couple1;
			addChildAt(couple1,5);
			couple1.x = 60;
			couple1.y = 360;
		
			//Couple 2
			couple2 = new Couple2;
			addChildAt(couple2,6);
			couple2.x = 360;
			couple2.y = 360;
			
			// Girl
			girlOne = new GirlOne;
			addChildAt(girlOne,7);
			girlOne.x = 165;
			girlOne.y = 225;
			
			// Exit Door
			exitDoor = new ExitDoor;
			addChildAt(exitDoor, 8);
			exitDoor.x = 525;
			exitDoor.y = 165;
			
			// Fratboy
			fratBoy = new FratBoy;
			addChildAt(fratBoy,9);
			fratBoy.x = 250;
			fratBoy.y = 400;
			fratBoy.scaleX = .4;
			fratBoy.scaleY = .4;
			
			// Door 
			door = new Door;
			addChildAt(door, 10);
			door.x = 452;
			door.y = 400;
			
			
			/* Collision Detection Kit
			collisionList = new CollisionList(fratBoy); 
			
			collisionList.addItem(fratBoy);
			collisionList.addItem(counterBG);
			collisionList.addItem(table1);
			collisionList.addItem(table2);
			collisionList.addItem(table3);
			collisionList.addItem(couple1);
			collisionList.addItem(couple2);
			collisionList.addItem(girlOne);
			collisionList.addItem(door);
			
			*/
		}
		
// make the fratboy Swap depths when he moves around objects
		private function sortZ ():void {
			for (var i:int = 0; i< numChildren; i++){
				for (var j:int =0; j < numChildren; j++){
					// Check fratboy.y
					if (getChildAt(j).y > getChildAt(i).y){
						swapChildrenAt(j, i);
					}
				}
			}
		}
		
// Once fratboy reaches invisible register hitspot - disable fratboy movement for a few seconds
		private function reachedRegister(event:Event):void
		{
			if(fratBoy.sensor.hitTestObject(counterBG.hitSpot))
				{
					trace("hit register");
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, moveFratBoy);
					stage.removeEventListener(Event.ENTER_FRAME, reachedRegister);
					startRegisterTimer();
					counterBG.clerk.play();
				}	
		}
		
		private function startRegisterTimer():void
		{
			trace('register timer');
			registerTimer = new Timer(1000);
			registerTimer.addEventListener(TimerEvent.TIMER, onTimer);
			registerTimer.start();	
		}
		
		// Make Fratboy unable to move for 2 seconds - if girl doesn't catch him, arrow appears near the exit door
		private function onTimer(event:TimerEvent):void
		{
			trace("count: "+registerTimer.currentCount);
			if(registerTimer.currentCount >= 2)
			{
				trace("timer complete");
				registerTimer.stop();
				registerTimer.reset();
				registerTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, moveFratBoy);
				
				// play register animation and sound
				counterBG.register.play();
				var regSound:Register = new Register();
				regSound.play();
				// remove first arrow then add the second arrow
				removeChild(arrow);
				arrow2 = new Arrow;
				addChild(arrow2); 
				arrow2.x = 400;
				arrow2.y = 185;
				arrow2.width = 80;
				
				// make door and end of level accesible
				//gotDonut = true;
				stage.addEventListener(Event.ENTER_FRAME, checkExitDoor);
			}
			
		}
		
		
		private function checkExitDoor(event:Event):void
		{
			if(fratBoy.sensor.hitTestObject(exitDoor.hitSpot))
			{
				trace("exit Door");
				stage.removeEventListener(Event.ENTER_FRAME, checkExitDoor);
				
				// remove all other items on stage since addChildAt(highest level) won't work because of the sortZ method
				removeStageObjects();
				
				// popup end of level
				MenuManager.instance.menuNavigation(BlindDateEngine.MENU_ENDLEVEL_SCR);
				
				gameTimer.removeEventListener(TimerEvent.TIMER, updateTime); // keeps 'lose' animation from happening
				
				//endLevelScreen.nextLevelBtn.label_txt.text = "Go to level 2";
				//endLevelScreen.endGameBtn.label_txt.text = "Quit Game";
			}	
		}
		
		private function removeStageObjects():void	
		{
			removeChild(counterBG);
			removeChild(arrow2);
		
			removeChild(table1);
			removeChild(table2);
			removeChild(table3);
		
			removeChild(couple1);
			removeChild(couple2);
			
			removeChild(girlOne);
			removeChild(exitDoor);
			removeChild(door);
			removeChild(fratBoy);
			
			removeChild(timeDisplay);
		}
		
		/*
		private function levelTwo(evt:MouseEvent):void	
		{
			trace("Go to level two");
			// Use menu manager to go to next level
		}
		
		private function endGame(evt:MouseEvent):void	
		{
			trace("Quit game");
		// Use menu manager to go to next level
			
		}
		*/
		
// FRATBOY MOVEMENT -----------------------------------------------------------------
		private function moveFratBoy(event:KeyboardEvent):void
		{
			
			if (event.keyCode == Keyboard.LEFT)
			{
			fratBoy.x -=5; 
				if (boyDirection != "left") 
				{
					fratBoy.gotoAndStop("left"); 
					boyDirection = "left";
				}
				else 
				{
					fratBoy.nextFrame(); 
					
					if (fratBoy.x < 30)
					{
						fratBoy.x = 30;
					}
					
					if (fratBoy.currentFrame == 34)
					{
						fratBoy.gotoAndStop("left");
					}
				}
				
				sortZ();
					
			}
			
			if (event.keyCode == Keyboard.RIGHT)
			{
				fratBoy.x +=5; 
				if (boyDirection != "right") 
				{
					fratBoy.gotoAndStop("right"); 
					boyDirection = "right";
				}
				else 
				{
				fratBoy.nextFrame();
					if (fratBoy.x > 505)
					{
						fratBoy.x = 505;
					}
					if (fratBoy.currentFrame == 22)
					{
						fratBoy.gotoAndStop("right");
					}
				}
				sortZ();
			}
			
			if (event.keyCode == Keyboard.UP)
			{
				fratBoy.y -=5; 
				if (boyDirection != "up") 
				{
					fratBoy.gotoAndStop("up"); 
					boyDirection = "up";
				}
				else 
				{
					fratBoy.nextFrame(); 
					if (fratBoy.y < 150)
					{
						fratBoy.y = 150;
					}
					if (fratBoy.currentFrame == 45)
					{
						fratBoy.gotoAndStop("up");
					}
					
					
				}
				sortZ();
			}
			
			if (event.keyCode == Keyboard.DOWN)
			{
				fratBoy.y +=5; 
				if (boyDirection != "down") 
				{
					fratBoy.gotoAndStop("down"); 
					boyDirection = "down";
				}
				else 
				{
					fratBoy.nextFrame(); 
					if (fratBoy.y > 400)
					{
						fratBoy.y = 400;
					}
					if (fratBoy.currentFrame == 11)
					{
						fratBoy.gotoAndStop("down");
					}
				}
				
				sortZ();
			}
		}
		
// Basic scaling of fratboy and girl - Needs to be revised to make more realistic
// Resize fratboy as he moves forward and back, his feet = registration point
		public function scaleFratBoy(event:Event):void
		{
			// The fratboy was scaled down to .4 when added to stage, so we have to shrink it more
			if (fratBoy.y <=275)
			{
				fratBoy.scaleX = .385;
				fratBoy.scaleY = .385;
				
				//fratBoy.scaleX -= 0.02; // do gradual scaling later?
				
			
			}
			else if (fratBoy.y > 275)
			{
				fratBoy.scaleX = .4;
				fratBoy.scaleY = .4;
			}
			
			
			// x - make sure fratboy doesn't move into right side of wall
			if (fratBoy.y <=250 && fratBoy.x >= 475)
			{
				trace("make fratboy move to the left");
				fratBoy.x = 498;
			}
			
			if (fratBoy.y <=250 && fratBoy.x <= 30)
			{
				trace("make fratboy move to the right");
				fratBoy.x = 45;
			}
		}
		
		
		public function scaleGirlOne(event:Event):void
		{
			//trace("y: "+girlOne.y);
			//trace("x: "+girlOne.x);
			// y
			if (girlOne.y <=275)
			{
				girlOne.scaleX = .95;
				girlOne.scaleY = .95;	
				
			}
			else if (girlOne.y > 275)
			{
				girlOne.scaleX = 1;
				girlOne.scaleY = 1;
			}
			
			// x - make sure girl appears to stay in room 
			if (girlOne.y <=250 && girlOne.x >= 475)
			{
				//trace("make girl move to the left");
				//girlOne.x = 495;
			}
		}
		
		
// Basic hitTestObject collision checking -------------------------------------------------
		private function checkCollisions(event:Event):void
		{
			
			switch(boyDirection)
			{
				case "up": 
					while ( fratBoy.sensor.hitTestObject(table1) || fratBoy.sensor.hitTestObject(table2) || fratBoy.sensor.hitTestObject(table3)
					|| fratBoy.sensor.hitTestObject(counterBG) || fratBoy.sensor.hitTestObject(couple1) || fratBoy.sensor.hitTestObject(couple2))
					{ 
						fratBoy.y +=1; // stops the boy from moving through the objects
					} 
					break;
				
				case "down": 
					while (fratBoy.sensor.hitTestObject(table1) || fratBoy.sensor.hitTestObject(table2) || fratBoy.sensor.hitTestObject(table3)
					|| fratBoy.sensor.hitTestObject(counterBG) || fratBoy.sensor.hitTestObject(couple1) || fratBoy.sensor.hitTestObject(couple2))
					{ 
						fratBoy.y -=1; 
					}
					break;
				
				case "left": 
					while (fratBoy.sensor.hitTestObject(table1) || fratBoy.sensor.hitTestObject(table2) || fratBoy.sensor.hitTestObject(table3)
					|| fratBoy.sensor.hitTestObject(counterBG) || fratBoy.sensor.hitTestObject(couple1) || fratBoy.sensor.hitTestObject(couple2))
					{ 
						fratBoy.x +=1; 
					}
					break;
				
				case "right": 
					while (fratBoy.sensor.hitTestObject(table1) || fratBoy.sensor.hitTestObject(table2) || fratBoy.sensor.hitTestObject(table3)
					|| fratBoy.sensor.hitTestObject(counterBG) || fratBoy.sensor.hitTestObject(couple1) || fratBoy.sensor.hitTestObject(couple2))
					{ 
						fratBoy.x -=1; 
					}
					break;
			}
		}
		
		// Detection Kit - not working correctly yet
		/*
		private function checkForCollisions(e:Event):void
		{
			var hits:Array = collisionList.checkCollisions();
			
			for(var i:uint = 0; i < hits.length; i++)
			{
				table1 = hits[i].object1;
				trace("Collision detected on " + table1); 
			}
		}
		*/
		
		
		/* 
			Basic Girl Movement - Down and Right 
		    Need to follow Fratboy and add collision detection
		*/
		
		
// GIRL MOVEMENT ----------------------------------------------------------------------	
		
		private function moveGirlDown(event:Event):void
		{
			// set direction
			if (girlDirection != "down") 
			{
				girlOne.gotoAndStop("down"); 
				girlDirection = "down";
			}
			
			// move
			girlOne.y +=2;
			girlOne.nextFrame();
			
			// keep girl walk loop happening
			if (girlOne.currentFrame == 12)
			{
				girlOne.gotoAndStop("down");
			}
			
			// stop once bottom of screen is hit
			if (girlOne.y > 395)
			{
				//girlOne.y =400;
				stage.removeEventListener(Event.ENTER_FRAME, moveGirlDown);
				stage.addEventListener(Event.ENTER_FRAME, moveGirlRight);
			}
			
			sortZ();
		}
		
		
		private function moveGirlRight(event:Event):void
		{
			// set direction
			if (girlDirection != "right") 
			{
				girlOne.gotoAndStop("right"); 
				girlDirection = "right";
			}
			
			// move
			girlOne.x +=2;
			girlOne.nextFrame();
			
			// keep girl walk loop happening
			if (girlOne.currentFrame == 36)
			{
				girlOne.gotoAndStop("right");
			}
			
			// stop once right side of screen is hit
			if (girlOne.x > 505)
			{
				//girlOne.x =500;
				stage.removeEventListener(Event.ENTER_FRAME, moveGirlRight);
				stage.addEventListener(Event.ENTER_FRAME, moveGirlUp);
			}
			
			sortZ();
		}
		
		private function moveGirlUp(event:Event):void
		{
			// set direction
			if (girlDirection != "up") 
			{
				girlOne.gotoAndStop("up"); 
				girlDirection = "up";
			}
			
			// move
			girlOne.y -=2;
			girlOne.nextFrame();
			
			// keep girl walk loop happening
			if (girlOne.currentFrame == 46)
			{
				girlOne.gotoAndStop("up");
			}
			
			// stop once right side of screen is hit
			if (girlOne.y < 140)
			{
				//girlOne.x =500;
				stage.removeEventListener(Event.ENTER_FRAME, moveGirlUp);
				
			}
			
			sortZ();
		}
		
		
		
		//NAVIGATION
		private function onMenuButtonPressed (e:CustomEvent):void {
			trace  ("targte"+e.oData.TARGETID);
			switch (e.oData.TARGETID)
			{
				case "nextLevelBtn" :
					trace ("The Next Level Button has been pressed");
					
					break;
				case "endGameBtn" :
					trace ("The End Game Button has been pressed");
					break;
				default:
					break;
			}
		}
		
							
	}
}