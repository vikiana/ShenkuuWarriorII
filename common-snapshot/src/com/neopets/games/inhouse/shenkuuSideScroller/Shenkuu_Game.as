/**
 *	Main Class that runs the gams
 *	Over all game flow:
 *	1. start game ==> sets game variables and such
 *	2. continue game ==> reset all the game elements
 * 	3. level prologue ==> play the count down
 *	4. on level ==> actual interactive game part
 *	5. level epilogue or player epilogue ==> finish the level or player dies not completing the level
 *	6. feedback popup ==> show the progress of the game
 *	7. continue button pressed from popup ==> advanc to next level (step 2) or to send score page if you died or finished enitre game
 *	
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *	@Pattern Translation System
 * 
 *	@author Abraham Lee
 *	@since  Aug 2009
 */


package com.neopets.games.inhouse.shenkuuSideScroller
{

	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
		
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import flash.utils.getTimer;
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	
	import com.coreyoneil.collision.CollisionList;
	import com.neopets.games.inhouse.shenkuuSideScroller.canvas.*;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.*;
	import com.neopets.games.inhouse.shenkuuSideScroller.characters.*;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.*;
	import com.neopets.games.inhouse.shenkuuSideScroller.levelInfo.LevelInfo;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.scrolling.ScrollingClip;
	import com.neopets.util.sound.GameSoundManager;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.AssetTool;
		
	
	public class Shenkuu_Game extends Sprite
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		public const OBJECT_CONTACT:String = "on_object_contact"

		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private var mStats:Stats;	//this is for memory, frame rate testing function leave it in
		
		private var mCurrentLevelInfo:Array; 	//level info array to be used for current level
		private var mContToNextLevel:Boolean;	//if false, all leves are cleared
		private var mMemorySaveMode:Boolean = false	//show less render if true
		private var mRunFunction:Function  = normalRun; //based on memory preference
		private var mTempLevel:Number = 1;		//only used for QA cheats/tests.  leave it in
		
		//used for preventing cheating against frame rate manipulation
		private var enterFrameCounter:Number = 0;
		private var tickCounter:Number = 5000;
		private var avgFrameRate:Number;
		private var currTime:int;
		private var startTime:int;
		
		private var totalScore:Number = 0	// this is just to figure out the total possible points


		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		

		/**
		 *	does initial set up for the game
		 *	@PARAM		pRootMC		Object		the document class of the game, called in Shenkuu_engine
		 **/
		public function Shenkuu_Game(pRootMC:Object = null):void 
		{
			GameData.rootMC = pRootMC == null ? this: pRootMC;
			setVars();
			initialSetup();
			addGameComponent();
			GameData.rootMC.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			if (pRootMC == null) startGame();//this class is document class then just start the game
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		/**
		 *	This is only called to start the game anew
		 **/
		public function startGame():void
		{
			totalScore = 0
			GameData.gameLevel = 1;		// for real game
			//GameData.gameLevel = mTempLevel;		//for testing/cheating function on
			GameData.score = 0;
			ScoreManager.instance.changeScoreTo (GameData.score);
			GameData.player.life = 100;
			continueGame();
			
			addEventListener(Event.ENTER_FRAME, onCheckFrame, false, 0, true)
		}
		
		
		/**
		 *	call it to continue to next level
		 **/
		public function continueGame():void
		{
			setupTimeVars();
			GameData.particleSprite2.filters = GameData.BaseFilter;
			GameSoundManager.stopAllCurrentSounds();
			CanvasManager.gage = 100;
			GameData.currSpeed = GameData.movingSpeed;
			UI.updatePenGage(CanvasManager.gage/100);
			UI.updateLifeGage(GameData.player.life/100);
			CanvasManager.decayRate = GameData.canvasDecay;
			GameDataManager.resetWeather();
			handleWeather();
			GameData.mainTimer.delay = GameData.SPEED_NORMAL;
			GameData.mainTimer.start();
			LevelInfo.init();
			levelSetup();
			scrollBackgrounds();
			updateScore();
			levelPrologue();
			accountSpeed();
			GameData.speedFactor = GameData.currSpeed/GameData.movingSpeed;
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		/**
		 *	set variables
		 **/
		private function setVars():void
		{
			GameData.collisionP = new CollisionList(CanvasManager.instance);
			GameData.collisionA = new CollisionList(CanvasManager.instance);
			mContToNextLevel = true;
		}
		
		
		/**
		 *	initialize various game entities
		 **/
		private function initialSetup():void
		{

			//add listener for player/enemy & player/item collision
			addEventListener(OBJECT_CONTACT, onObjectContact, false, 0, true);
			//set up game data
			GameDataManager.initialSetup(); 
			//set up player
			GameData.player = new MainCharacter (); 
			GameData.player.init(AssetTool.getMC("Boat"),GameData.dftPos,new Point (0,0), new Point(0,0.1));
			GameData.collisionP.addItem(MovieClip(GameData.player.image).core);
			//set up UI
			UI.init(AssetTool.getMC("UI_Panel"));
			UI.instance.addEventListener(UI.UI_ACTIVITY,handleUIClick, false, 0, true);
			//set up popup
			Popup.init (AssetTool.getMC("PopupA"));
			Popup.instance.addEventListener(Popup.POPUP_ACTIVITY,handlePopupClick, false, 0, true);
			//set up particle
			ParticleBridge.prepParticles();
			//set canvas properties
			CanvasManager.moveAmount = -GameData.currSpeed;	
			CanvasManager.decayRate = GameData.canvasDecay;
			CanvasManager.myTarget = MovieClip(GameData.player.image).coreBuffer;
		}
		
		
		/**
		 *	add bunch of display objects
		 **/
		private function addGameComponent():void
		{
			//add child in various places
			GameData.objsSprite.addChild (GameData.player.image);
			GameData.uiSprite.addChild(UI.image);
			GameData.fbSprite.addChild(Popup.image);
			//add child to game stage
			addChild (GameData.bdSprite);
			addChild (GameData.bgSprite);
			addChild (GameData.mgSprite);
			addChild (GameData.particleSprite);
			addChild (CanvasManager.instance);
			addChild (GameData.objsSprite);
			addChild (GameData.particleSprite2);
			addChild (GameData.fgSprite);
			addChild (GameData.uiSprite);
			addChild (GameData.fbSprite);
			CanvasManager.instance.visible = false;
			//leave this in for memory,frame rate testing
			/*
			mStats = new Stats()
			mStats.x = 580;
			mStats.y = 50;
			addChild( mStats )
			*/
		}
		
		
		/**
		 *	set up count down popup before string the game
		 **/
		private function levelPrologue():void
		{
			Popup.showPopup(Popup.COUNTER);
			GameData.timeCount = GameData.PRE_LEVEL_DURATION; //set how long count down will last
			GameData.mainTimer.addEventListener(TimerEvent.TIMER, prologueCountDown, false, 0, true);
			accountDist();
			GameData.player.manageDepth();
		}
		
		/**
		 *	run the game
		 **/
		private function onLevel():void
		{
			GameSoundManager.soundPlay(GameSoundManager.musicOn, Sounds.SND_BG1, true);
			CanvasManager.init(GameData.rootMC.stage);	//canvas set up for line drawing
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, prologueCountDown);
			GameData.mainTimer.addEventListener(TimerEvent.TIMER, updateScene, false, 0, true);
		}
		
		/**
		 *	After hitting the marker, fun the closing animation
		 **/
		private function levelEpilogue():void
		{
			GameData.player.closingSetting();
			GameData.timeCount = GameData.END_LEVEL_DURATION;
			GameData.mainTimer.delay = GameData.SPEED_NORMAL;
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, updateScene);
			GameData.mainTimer.addEventListener(TimerEvent.TIMER, closeScene, false, 0, true);
			GameDataManager.clearObjs();
			CanvasManager.resetCanvas();
			ParticleBridge.resetHolders();
		}
		
		/**
		 *	when game is completed, run this sequence
		 **/
		private function gameEpilogue():void
		{
			GameData.player.closingSetting();
			GameData.timeCount = GameData.END_LEVEL_DURATION;
			var ang:Number = Math.atan2(GameData.player.landingPt.y - GameData.player.py, GameData.player.landingPt.x - GameData.player.px);
			var yDist:Number = GameData.player.landingPt.y - GameData.player.py;
			var xDist:Number = GameData.player.landingPt.x - GameData.player.px;
			var dist:Number = Math.sqrt(yDist * yDist + xDist * xDist);
			var unit:Number = dist /GameData.timeCount * 1.5;
			var xvel:Number = unit * Math.cos(ang);
			var yvel:Number = unit * Math.sin(ang);
			GameData.player.vel = new Point (xvel, yvel);
			GameData.player.grav = new Point (0, 0);
			//update timer function
			GameData.mainTimer.delay = GameData.SPEED_NORMAL;
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, updateScene);
			GameData.mainTimer.addEventListener(TimerEvent.TIMER, endScene, false, 0, true);
			GameDataManager.clearObjs();
			CanvasManager.resetCanvas();
			ParticleBridge.resetHolders();
		}
		
		/**
		 *	should player die in the middle of the game, show the sad ending
		 **/
		private function playerEpilogue():void
		{
			GameData.player.deathSetting();
			GameData.timeCount = GameData.END_LEVEL_DURATION;
			GameData.mainTimer.delay = GameData.SPEED_NORMAL;
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, updateScene);
			GameData.mainTimer.addEventListener(TimerEvent.TIMER, deathScene, false, 0, true);
			GameDataManager.clearObjs();
			CanvasManager.resetCanvas();
			ParticleBridge.resetHolders();
			mContToNextLevel = false;
			GameSoundManager.fadeOutSound(Sounds.SND_BG1);
		}
		
		
		
		
		
		
		/**
		 * 	Set up foreground, midground, background for each level
		 * 	Set up mCurrentLevel Info
		 **/
		private function levelSetup():void
		{
			var groundImages:Array;
			switch (GameData.gameLevel)
			{
				case 1:
					groundImages = returnImages(LevelInfo.mLevelOneElements);
					mCurrentLevelInfo = LevelInfo.mLevelOne;
					break;
				case 2:
					groundImages = returnImages(LevelInfo.mLevelTwoElements);
					mCurrentLevelInfo = LevelInfo.mLevelTwo;
					break;
				case 3:
					groundImages = returnImages(LevelInfo.mLevelThreeElements);
					mCurrentLevelInfo = LevelInfo.mLevelThree;
					break
			}
			GameDataManager.setupGameGrounds(groundImages[0], groundImages[1], groundImages[2], groundImages[3]);
		}
		
		
		/**
		 * 	Takes array of display object class names and retuns an array with instances
		 *	@PARAM		pArray		Array 		Array of class names in library ["Circle", "Tree", "whatever"]
		 **/
		private function returnImages(pArray:Array):Array
		{
			var tempArray:Array = [];
			for (var i:String in pArray[0])
			{
				if (pArray[0][i] == "null" || pArray[0][i] == null)
				{
					tempArray[tempArray.length] = null;
				}
				else
				{
					var tempClass:Class = getDefinitionByName(pArray[0][i]) as Class;
					tempArray[tempArray.length] = new tempClass ();
				}
			}
			return tempArray;
		}
		
		/**
		 *	move the backgrounds for parallax effects
		 **/
		private function scrollBackgrounds():void
		{
			//side scrolling
			ScrollingClip(GameData.bgSprite.getChildAt(0)).scrollBy(GameData.bgSpeed,0);
			ScrollingClip(GameData.mgSprite.getChildAt(0)).scrollBy(GameData.mgSpeed,0);
			ScrollingClip(GameData.fgSprite.getChildAt(0)).scrollBy(GameData.fgSpeed,0);
			//parallax affect in y-axis
			GameData.bgSprite.y = (300 - GameData.player.py) / 50;
			GameData.mgSprite.y = (300 - GameData.player.py) / 10;
			GameData.fgSprite.y = (300 - GameData.player.py) / 4;
			//control overlap
			fgControl();
			
		}
		
		/** 
		 *	When player overlaps with forground item(s), the item changes alpha to show the player
		 **/	
		private function fgControl():void 
		{
			var bg:MovieClip = MovieClip(GameData.fgSprite.getChildAt(0));
			var num:int = bg.numChildren;
			for (var i:int = 0; i < num; i++)
			{
				if (MovieClip(GameData.player.image).core.hitTestObject(bg.getChildAt(i)))
				{
					if (MovieClip(bg.getChildAt(i)).alpha > .4)
					{
						MovieClip(bg.getChildAt(i)).alpha -= .2;
					}
				}
				else 
				{
					if (MovieClip(bg.getChildAt(i)).alpha < 1)
					{
						MovieClip(bg.getChildAt(i)).alpha += .2;
					}
				}
			}
		}
		
		
		
		/**
		 *	Calculate arbitrary distance the player has covered
		 **/
		private function updateDist():void
		{
			GameData.dist += GameData.currSpeed;
		}

		
		/**
		 *	Based on player's traveled distance objects should show up accordingly
		 **/
		private function accountDist():void
		{
			if (mCurrentLevelInfo.length > 0)
			{
				var objInfo:Array = mCurrentLevelInfo[0];
				var distMark:Number = mCurrentLevelInfo[0][0];
				if (distMark <= GameData.dist)
				{
					showObj(mCurrentLevelInfo.shift());
					accountDist();
				}
			}
		}
		
		
		
		/**
		 *	Place various objects (enemies, helpers, etc.) on to stage
		 *	@PARAM		pObjArray		Array		each array contains info on an object to be shown
		 **/
		private function showObj(pObjArray:Array):void
		{
			
			var objKind:String = pObjArray[1];
			if (objKind == "weather")
			{
				handleWeather(pObjArray);
			}
			else
			{
				var imageClass:Class = AssetTool.getClass(pObjArray[2]);
				var px:Number = pObjArray[3];
				var py:Number;
				var vx:Number = pObjArray[5];
				var vy:Number = pObjArray[6];
				var gx:Number = pObjArray[7];
				var gy:Number = pObjArray[8];
				var behavior:String = behavior = pObjArray[9];
				var vel:Point = new Point (vx, vy);
				
				py = pObjArray[4] == "r" ? Math.random() * (GameData.stageWidth -200) + 100 : pObjArray[4];
			
				switch (objKind)
				{
					case "enemy":
						var enemy:Enemy = GameData.enemies.length > 0 ? GameData.enemies.shift() : new Enemy ();
						enemy.init (new imageClass (), new Point (px, py), vel, new Point (gx, gy), this);
						enemy.myTarget = GameData.player;
						GameData.objsSprite.addChild(enemy.image);
						enemy.behavior = Enemy[behavior];
						enemy.unbreakable ? GameData.activeUnbreakables.push(enemy):GameData.activeEnemies.push(enemy);
						if (pObjArray[10] != null) enemy.damage = pObjArray[10];
						if (pObjArray[2] == "Missile") GameData.collisionA.addItem(enemy.image);

						totalScore += enemy.score
						break;
					
					case "helper":
						var helper:Helper = GameData.helpers.length > 0 ? GameData.helpers.shift() : new Helper ();
						helper.init (new imageClass (), new Point (px, py), vel, new Point (gx, gy), this);
						helper.myTarget = GameData.player;
						GameData.objsSprite.addChild(helper.image);
						GameData.activeHelpers.push(helper);
						helper.behavior = Helper[behavior];
						totalScore += helper.score
						break;
					
					case "marker":
						GameData.marker.init (new imageClass (), new Point (px, py),vel, new Point (gx, gy), this);
						GameData.marker.myTarget = GameData.player;
						GameData.objsSprite.addChild(GameData.marker.image);
						GameData.marker.behavior = Marker[behavior];
						break;
				}
				
				trace ("TotalScore:",totalScore)
			}
		}
		
		
		
		
		/**
		 *	change the weather (in all essence just change the gravity on player)
		 **/
		private function handleWeather(pObjArray:Array = null):void
		{
			if (pObjArray != null)
			{
				var speed:Number = pObjArray[3];
				GameData.weather = pObjArray[2];
			}
			if (GameData.weather == "none")
			{
				GameSoundManager.stopSound(Sounds.SND_WIND);
				GameData.currSpeed = GameData.movingSpeed
			}
			else
			{
				GameData.currSpeed = speed
				if (!GameSoundManager.checkSoundState(Sounds.SND_WIND))
				{
					trace ("\nWIND SOUND KICKING IN\n");
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_WIND, true, 0, 0, 0);
					GameSoundManager.fadeInSound(GameSoundManager.soundOn, Sounds.SND_WIND, .5);
				}
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_THUNDER);
			}
			accountSpeed();
		}
		
		/**
		 *	visual change according to current weather
		 **/	
		private function badWeatherControl():void
		{
			if (GameData.bdSprite.getChildByName("backdrop") != null)
			{
				var bd:MovieClip = MovieClip(GameData.bdSprite.getChildByName("backdrop"));
				if (bd.hasOwnProperty("badWeather"))
				{
					if (GameData.weather == "none") 
					{
						if (bd.badWeather.alpha > 0)
						{
							bd.badWeather.alpha -= .05;
						}
					}
					else
					{
						if (bd.badWeather.alpha < 1)
						{
							bd.badWeather.alpha += .05;
						}
					}
				}
			}
		}
		
		
		
		/**
		 *	control canvas (line drawing and fading)
		 **/
		private function controlCanvas():void
		{
			CanvasManager.canvasFade();
			CanvasManager.canvasUpdate();
			CanvasManager.drawLine();
			UI.updatePenGage(CanvasManager.gage/100);
		}
		
		
		
		/**
		 *	move objs in array (active anemies and active items)
		 **/
		private function moveObjs(pArray:Array):void
		{
			for ( var i:String in pArray)
			{
				pArray[i].run();
			}
		}
		

		
		/**
		 *	move Marker
		 **/
		private function moveMarker():void
		{
			if (GameData.marker.myTarget != null)
			{
				GameData.marker.run();
			}
		}
		
		
		
		
		/**
		 *	accounts for dying condition
		 **/
		private function deathControl():void
		{
			if (GameData.player.px < -30)
			{
				bouncePlayer(0, 15, 1);
			}
			else if (GameData.player.px > 680)
			{
				bouncePlayer(Math.PI, 15, 1);
			}
			else if (GameData.player.py < 30)
			{
				bouncePlayer(Math.PI * 0.5, 15, 1);
			}
			else if (GameData.player.py > 600)
			{
				bouncePlayer(Math.PI * 1.5, 15, 1);
			}
			
			if (GameData.player.life <= 0)
			{
				UI.updateLifeGage(0);
				playerEpilogue();
			}
		}
		
		/**
		 *	force player to be bounced when out of bound
		 **/
		private function bouncePlayer(ang:Number, time:int, damage:Number):void
		{
			GameData.player.pushback(ang, time);
			GameData.player.changeLifeBy( - damage);
			GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_POOF);
			GameData.player.setBuffer();
		}
		
		
		/**
		 *	update the score (the real score as well as the score text)
		 **/
		private function updateScore(pNum:int = 0):void
		{
			var score:int = Boolean(GameData.player.doublePoint) ? pNum * 2 : pNum;
			GameData.score += score;
			ScoreManager.instance.changeScoreTo (GameData.score);
			UI.updateScoreText (GameData.score);
		}
				
		
		
		/**
		 *	show game end popup prompt
		 **/
		private function endPrompt():void
		{
			Popup.showPopup(Popup.MESSAGE);
			GameData.mainTimer.stop();
			setupTimeVars()
		}
		
		
		/**
		 *	show popup report
		 *	@PARAM		pBg		String		background you want to show (built in lib MC)
		 *	@PARAM		pMssg	Number		type of message to show if applicable (only used for report)
		 **/
		private function showReport(pBg:String = null, pMssg:Number = -1):void
		{
			Popup.showPopup(Popup.REPORT, pBg, pMssg);
		}
		
		
		
		/**
		 *	ends the level and resets player, marker, canvas, particles, etc.
		 **/
		private function endLevel():void
		{
			removeTimerListeners();
			GameData.mainTimer.stop();
			GameDataManager.cleanupMarker();
			GameDataManager.resetPlayer();				
			UI.updateLifeGage(GameData.player.life/100);
			CanvasManager.resetCanvas();
			ParticleBridge.resetHolders();
		}
		
		
		/**
		 *	ends entire game
		 **/
		private function quitGame():void
		{
			removeEventListener(Event.ENTER_FRAME, onCheckFrame)
			endLevel();
			GameSoundManager.stopAllCurrentSounds();
			GameDataManager.clearObjs();
			
			MenuManager.instance.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
		}
		
		/**
		 *	It removes all possible timer listeners
		 **/
		private function removeTimerListeners():void
		{
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, prologueCountDown);
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, updateScene);
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, closeScene);
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, endScene);
			GameData.mainTimer.removeEventListener(TimerEvent.TIMER, deathScene);
		}
		
		/**
		 *	toggle between what function to run based on memory save preference
		 **/
		private function memoryToggle():void
		{
			if (mMemorySaveMode)
			{
				GameData.impactArray = [];
				ParticleBridge.resetHolders();
				mMemorySaveMode = false;
				GameData.bgSprite.visible = true;
				GameData.mgSprite.visible = true;
				GameData.particleSprite.visible = true;
				GameData.particleSprite2.visible = true;
				GameData.fgSprite.visible = true;
				CanvasManager.instance.visible = false;
				mRunFunction = normalRun;
			}
			else
			{
				GameData.impactArray = [];
				ParticleBridge.resetHolders();
				mMemorySaveMode = true;
				GameData.bgSprite.visible = false;
				GameData.mgSprite.visible = false;
				GameData.particleSprite.visible = false;
				GameData.particleSprite2.visible = false;
				GameData.fgSprite.visible = false;
				CanvasManager.instance.visible = true;
				mRunFunction = fasterRun;
			}
		}
		
		/**
		 *	normal run function
		 **/
		private function normalRun():void
		{
			updateDist();
			accountDist();
			GameDataManager.speedCounter();
			UI.controlLifeBar();
			scrollBackgrounds();
			controlCanvas();
			GameData.player.run();
			GameData.player.accountCollision();
			ParticleBridge.showParticle(mouseX, mouseY);
			deathControl();
			moveObjs(GameData.activeUnbreakables);
			moveObjs(GameData.activeEnemies);
			moveObjs(GameData.activeHelpers);
			moveMarker();
			badWeatherControl();
		}
		

		/**
		 *	save memory run function
		 **/
		private function fasterRun():void
		{
			updateDist();
			accountDist();
			GameDataManager.speedCounter();
			UI.controlLifeBar();
			controlCanvas();
			GameData.player.run();
			GameData.player.accountCollision();
			deathControl();
			moveObjs(GameData.activeUnbreakables);
			moveObjs(GameData.activeEnemies);
			moveObjs(GameData.activeHelpers);
			moveMarker();
			badWeatherControl();
		}

		/**
		 *	adjust all the elements in the game to a new moving speed
		 **/
		private function accountSpeed():void
		{
			GameDataManager.setSpeeds();
			CanvasManager.moveAmount = -GameData.currSpeed;
			ParticleBridge.speed = -GameData.currSpeed;
		}
				
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function keyPressed(e:KeyboardEvent):void
		{
			if(e.keyCode == 70)
			{
				froggy();
			}
			//do not delete this is for cheating/testing for QA
			/*
			switch (e.keyCode)
			{
				
				case 49:
					mTempLevel = 1;
					GameData.gameLevel = 1
					break;
				case 50:
					mTempLevel = 2;
					GameData.gameLevel = 2
					break;
				case 51:
					mTempLevel = 3;
					GameData.gameLevel = 3
					break;
				
				case 70:
					froggy();
					break;
			}
			
			var currSpeedFactor:Number = GameData.speedFactor
			if(e.keyCode == Keyboard.DOWN)
			{
				trace ("slow")
				GameData.currSpeed = GameData.movingSpeed;
			}
			if(e.keyCode == Keyboard.UP)
			{
				trace("fast")
				GameData.currSpeed += 10;
			}
			
			GameData.speedFactor = GameData.currSpeed/GameData.movingSpeed
			trace (GameData.movingSpeed, GameData.speedFactor)
			if (currSpeedFactor != GameData.speedFactor)
			{
				accountSpeed();
			}
			
			*/
		}
		
		private function froggy():void
		{
			if (GameData.dist > 200 && GameData.dist < 1000)
			{
				if (GameData.bdSprite.getChildByName("backdrop") != null)
				{
					var bd:MovieClip = MovieClip(GameData.bdSprite.getChildByName("backdrop"))
					if (bd.hasOwnProperty("frog"))
					{
						bd.frog.activate()
					}
				}
			}
		}
		
		
		/**
		 *	Runs the initial count down popup screen before staring the game
		 **/
		private function prologueCountDown(e:TimerEvent):void
		{
			if (MovieClip(Popup.image).countDown.text != Math.ceil(GameData.timeCount /20 ).toString())
			{
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_BTN_1);
			}
			MovieClip(Popup.image).countDown.text = Math.ceil(GameData.timeCount /20 ).toString();
			GameData.timeCount -- ;
			if  (GameData.timeCount <= 0)
			{
				Popup.hide();
				GameData.timeCount = GameData.PRE_LEVEL_DURATION;
				onLevel();
			}
		}
		
		
		/**
		 *	Runs the game
		 **/
		private function updateScene(e:TimerEvent):void
		{
			mRunFunction();
			//checkFrameRate();
		}
	
		/**
		 *	Runs flying off animation with fireworks upon clearing a level
		 **/
		private function closeScene(e:TimerEvent):void
		{
			if (GameData.timeCount %4 ==0 &&  GameData.timeCount > 30)
			{
				ParticleBridge.showFireWorks();
			}
			GameData.timeCount -- ;
			GameData.player.run();
			ParticleBridge.showParticle();

			if  (GameData.timeCount <= 0)
			{
				showReport("pass", GameData.gameLevel);
				endLevel();
			}
		}
		
		
		/**
		 *	Runs docking animation for completeing the game
		 **/
		private function endScene(e:TimerEvent):void
		{
			if (GameData.timeCount %4 ==0 &&  GameData.timeCount > 30)
			{
				ParticleBridge.showFireWorks();
			}
			GameData.timeCount -- ;
			ParticleBridge.showParticle();
			var yDist:Number = GameData.player.landingPt.y - GameData.player.py;
			var xDist:Number = GameData.player.landingPt.x - GameData.player.px;
			var dist:Number = Math.sqrt(yDist * yDist + xDist * xDist);
			if (dist < 8)
			{
				GameData.player.vel = new Point (xDist/2, yDist/2);
				GameData.player.run();
			}
			else
			{
				GameData.player.run();
			}
			if  (GameData.timeCount <= 0)
			{
				showReport("pass", GameData.gameLevel);
				endLevel();
			}
		}
		
		
		/**
		 *	Runs flying off animation with fireworks upon clearing a level
		 **/
		private function deathScene(e:TimerEvent):void
		{
			if (GameData.timeCount %6 ==0 &&  GameData.timeCount > 30)
			{
				GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_FIRE);
				ParticleBridge.showMissileShoot(GameData.player.px, GameData.player.py);
			}
			GameData.timeCount --;
			GameData.player.run();
			ParticleBridge.showParticle();
			if  (GameData.timeCount <= 0)
			{
				showReport("fail", 0);
			}
		}
		
		/**
		 *	CustomEvent is dispatched when objs (enemy, items, markers, etc.) collides with player
		 *	The follow up action is determined based on type of the obj.
		 *	@NOTE:	[case:"missille"] is a special case.  
		 *			It's dispatched when cannon enemy fires a missile and a missile needs to be created
		 *			The created "missile" is counted as another "enemy"
		 *
		 **/
		private function onObjectContact (e:CustomEvent):void
		{
			if (e.oData.SCORE != null) updateScore(e.oData.SCORE);
			switch (e.oData.TYPE)
			{
				case "enemy":
		 			if (!mMemorySaveMode)GameData.impactArray[GameData.impactArray.length] = e.oData.POS;
					GameData.player.setBuffer();
					if (!Boolean(GameData.player.invincible))
					{
						GameData.player.changeLifeBy( -e.oData.DAMAGE);
					}
					else
					{
						GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_POOF2);
					}
					handleBounce(e.oData.KIND, e.oData.ANGLE);
					break;
					
				case "missileExp":
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_POOF2);
					if (!mMemorySaveMode)GameData.impactArray[GameData.impactArray.length] = e.oData.POS;
					break;
				
				case "missile":	
					var pos:Point = e.oData.POS;
					var vel:Point = e.oData.VEL;
					var enemyArray = [0, "enemy", "Missile",pos.x, pos.y, vel.x, vel.y, 0, 0, "MISSILE",5];
					showObj(enemyArray);
					break;
				
				case Helper.HEAL:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_MAGIC);
					GameData.player.changeLifeBy( e.oData.HEAL);					
					break;
				
				case Helper.SPEED_UP:
					// it's supported but the current game does not use it so left here for future development;
					break;
				
				case Helper.SPEED_DOWN:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_SPEED_DOWN);
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_MAGIC);
					GameData.speedCount = e.oData.TIME;
					GameData.mainTimer.delay = GameData.SPEED_NORMAL;
					GameData.slowOn = true;
					
					break;
				
				
				case Helper.KILL:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_FIRE);
					for (var i:String in GameData.activeEnemies)
					{
						if (!mMemorySaveMode)GameData.impactArray[GameData.impactArray.length] = GameData.activeEnemies[i].pos;
					}
					GameDataManager.resetObjs(GameData.activeEnemies);
					break;
				
				case Helper.SCORE:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_MAGIC);
					break;
				
				case Helper.MORPH:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_MAGIC);
					for (var j:String in GameData.activeEnemies)
					{
						var helper:Helper = GameData.helpers.length > 0 ? GameData.helpers.shift() : new Helper ();
						helper.init (AssetTool.getMC("Helper_Score"), GameData.activeEnemies[j].pos, GameData.itemVel, GameData.itemGrav, this);
						helper.myTarget = GameData.player;
						GameData.objsSprite.addChild(helper.image);
						GameData.activeHelpers.push(helper);
						helper.behavior = Helper.SCORE
					}
					GameDataManager.resetObjs(GameData.activeEnemies);
					break;
					
				case Helper.INVINCIBLE:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_MAGIC);
					GameData.player.setInvincible();
					break;
				
				case Helper.DOUBLE:
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_MAGIC);
					GameData.player.setDoublePoint();
					break;
				
				case Marker.LEVEL_END:
					GameSoundManager.fadeOutSound(Sounds.SND_BG1);
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_WIN);
					mContToNextLevel = true;
					GameData.marker.myTarget = null;
					levelEpilogue();
					break;
				
				case Marker.GAME_END:
					GameSoundManager.fadeOutSound(Sounds.SND_BG1);
					GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_WIN);
					mContToNextLevel = false;
					GameData.player.landingPt = GameData.marker.pos;
					GameData.marker.myTarget = null;
					gameEpilogue();
					break;
			}
		}
		
		/**
		 *	Should player bounce off of an enemy, handle bounc
		 *	@PARAM		pKind		String		Type of enemy
		 *	@PARAM		pAngle		Number		collision angle
		 **/
		 private function handleBounce(pKind:String, pAngle:Number):void
		 {
			switch (pKind)
			{
				case Enemy.BLOCKER:
					GameData.player.pushback(pAngle, 10);
					break;
				case Enemy.WALL:
					GameData.player.pushback(pAngle, 12);
					break;
				case Enemy.WALL_H:
					GameData.player.pushback(pAngle, 12);
					break;
				case Enemy.WALL_V:
					GameData.player.pushback(pAngle, 12);
					break;
				case Enemy.DESTROYER:
					GameData.player.pushback(pAngle, 12);
					break;
			}
		 }

		/**
		 *	A popup dispatches an event when user clicks on any of the buttons that belongs to popup class
		 **/
		private function handlePopupClick (e:CustomEvent):void
		{
			switch (e.oData.TYPE)
			{
				case Popup.GAME_END_YES:
					quitGame();
					break;
				
				case Popup.GAME_END_NO:
					setupTimeVars()
					GameData.mainTimer.start();					
					break;
				
				case Popup.GAME_CONTINUE:
					if (mContToNextLevel)
					{
						GameData.gameLevel ++;
						continueGame();
					}
					else 
					{
						quitGame();
					}
					break;
			}
			
		}
		
		
		/**
		 *	A UI dispatches an event when user clicks on any of the buttons that belongs to UI class
		 **/
		private function handleUIClick (e:CustomEvent):void
		{
			switch (e.oData.TYPE)
			{
				case UI.GAME_END:
					endPrompt();
					break;
					
				case UI.MEMORY_TOGGLE:
					memoryToggle();
					break;
			}
			
		}
		
		
		//----------------------------------------
		//	CHEAT PREVENTION METHODS
		//----------------------------------------
		
		/*
		 *	for each level, set up framerate vars to calculate avg fram rate
		 */
		private function setupTimeVars():void
		{
			enterFrameCounter = 0;
			tickCounter = 5000;
			startTime = getTimer();
		}
		
		/*
		 *	Should frame rate fall below certain count, it should quit the game
		 */
		private function checkFrameRate():void
		{
			enterFrameCounter++;			
			currTime = getTimer()-startTime;
			if (currTime > tickCounter) {
				tickCounter+=5000; 
				avgFrameRate = enterFrameCounter/currTime;
				trace (avgFrameRate)
				if (avgFrameRate < (Math.random() * .004) + .004) 
				{ 
					//should frame rate fall below .016 (below 16 fps to 0.8 fps, the game will quit)
					quitGame();
				}
			}
		}
		
		private function onCheckFrame(evt:Event):void 
		{
			checkFrameRate();
		}
	}
}