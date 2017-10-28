/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.pinball
{
	import com.neopets.games.inhouse.pinball.gui.GameScene;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.input.KeyManager;
	import com.neopets.util.input.KeyStatus;
	import com.neopets.util.loading.LoadingEngineXML;
	import com.neopets.util.support.PauseHandler;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import org.cove.ape.APEngine;
	
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	// This class handles all the game data and functions not specific to a single game level.
	// Author: David Cary with Updates from Clive Hernick
	// Last Updated: April 2008
	 * 
	 *	@system	PinBall, Ape, Neopets GameEngine
	 *	@since  3.04.2009
	 */
	 
	public class GameShell extends GameScene 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const PAUSE_CMD:String = "pause";
		public static const PULL_CMD:String = "pull";
		public static const LEFT_CMD:String = "left";
		public static const RIGHT_CMD:String = "right";
		public static const OPEN_BIN:String = "open_bin";
		public static const NEW_BALL_READY:String = "new_ball_ready";
		public static const BALL_LEFT_PLAY:String = "ball_left_play";
		public static const OUT_OF_BALLS:String = "out_of_balls";
		public static const BOARD_FINISHED:String = "board_finished";
		public static const SCORE_CHANGED:String = "score_changed";
		public static const BOARD_BONUS:Number = 100;
		public static const SCREEN_WIDTH:Number = 650;
		public static const SCREEN_HEIGHT:Number = 600;
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		// Loader Variables
		protected var xmlLoader:URLLoader;
		protected var xmlData:XML;

		protected var curBoard:PinballCabinet;
		protected var prevBoard:PinballCabinet;
		protected var curNode:XML;
		protected var nextNode:XML;
		// Transition Variables
		protected var upperTween:Tween;
		protected var lowerTween:Tween;
		protected var _score:NP9_Evar;
		// Initialization variables
	
		protected var _series:String;
		// Control Variables
		protected var keys:KeyManager;
		protected var _updater:PauseHandler;
		
		protected var mDelayTimer:Timer;
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		// Initialization variables
		public var showWires:Boolean; // should constraints without assigned graphics be shown?
		//public var baseURL:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameShell (pMainTimeLine:Object = null)
		 {
			super();
			mDelayTimer = new Timer(1000);
			mDelayTimer.addEventListener(TimerEvent.TIMER,delayTimer,false,0,true);
			//series = "heroes";
			   
			showWires = false;
			_score = new NP9_Evar(0);
			
			// set up pause handler
			_updater = new PauseHandler(pMainTimeLine as MovieClip);
			// load keys
			keys = new KeyManager(pMainTimeLine.stage);
			keys.addKey(PAUSE_CMD,80); // "P" key
			keys.getCommand(PAUSE_CMD).addEventListener(KeyStatus.KEY_PRESSED,_updater.toggle);
			keys.addKey(PULL_CMD,Keyboard.DOWN);
			keys.addKey(PULL_CMD,Keyboard.SPACE);
			keys.addKey(LEFT_CMD,Keyboard.LEFT);
			keys.addKey(LEFT_CMD,Keyboard.CONTROL,KeyLocation.LEFT);
			keys.addKey(RIGHT_CMD,Keyboard.RIGHT);
			keys.addKey(RIGHT_CMD,Keyboard.CONTROL,KeyLocation.RIGHT);
			// add event listeners
			addEventListener(OUT_OF_BALLS,onOutOfBalls);
			addEventListener(BOARD_FINISHED,onBoardFinished);
			
			// This code sets up the "skip a level" cheat
			//keys.addKey("next_level",78); // "N" key
			//keys.getCommand("next_level").addEventListener(KeyStatus.KEY_PRESSED,onBoardFinished);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		public function get series():String { return _series; }
		
		public function set series(id:String) {
			_series = id;
			if(xmlData != null) startSeries();
		}
		
		public function get updater():PauseHandler { return _updater; }
		
		public function getKey(ref:String) {
			return keys.getCommand(ref);
		}
		
		public function get score():Number { return _score.show(); }
		
		public function set score(val:Number) {
			_score.changeTo(val);
			dispatchEvent(new Event(SCORE_CHANGED));
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @NOTE: New version is to get the preloaded assets and make instances of Objects
		 */
		
		
		public function loadData():void {
			
			var tConfigData:XML = controller.configXML;
			xmlData = tConfigData.GAMEINFO[0];	
			
			if(_series != null) startSeries();
		}
		
		public function changeScoreBy(val:Number):void
		 {
			_score.changeBy(val);
			dispatchEvent(new Event(SCORE_CHANGED));
		}
		
		
		
			// The "success" parameter tells us whether they cleared the game or failed it.
		public function gameOver(success:Boolean):void 
		{
			if(curBoard != null) {
				if(curBoard.parent == this) {
					curBoard.disable();
					removeChild(curBoard);
					curBoard = null;
				}
			}
			if(prevBoard != null) {
				if(prevBoard.parent == this) {
					prevBoard.disable();
					removeChild(prevBoard);
					prevBoard = null;
				}
			}
			controller.gotoScene(controller.GAMEOVER_SCENE);
			controller.stopAllSoundFiles();
		}
		
	
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onOutOfBalls(ev:Event) {
			gameOver(false);
		}
		
		protected function onBoardFinished(ev:Event) {
			changeScoreBy(BOARD_BONUS);
			controller.playSound(SoundIDs.MOVEUP_LEVEL);	
			
			_updater.paused = true;
			if(curNode != null && nextNode == null) {
				// check if there's another board in this level
				var lvl:XML = curNode.parent();
				var boards:XMLList = lvl.board;
				var i:int = curNode.childIndex() + 1;
				if(i < boards.length()) nextNode = boards[i];
				else {
					// check if there's another level to move on to
					var series:XML = lvl.parent();
					var lvls:XMLList = series.level;
					i = lvl.childIndex() + 1;
					if(i < lvls.length()) {
						lvl = lvls[i];
						boards = lvl.board;
						if(boards.length() > 0) nextNode = boards[0];
					}
					
				}
				// if we have a new board available, load it
				if(nextNode != null) onCabinetLoaded(nextNode);
				else gameOver(true);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function startSeries() {
			if(xmlData == null || _series == null) return;
			var series:XMLList = xmlData.series.(@name == _series);
			if(series.length() > 0) {
				var lvls:XMLList = series[0].level;
				if(lvls.length() > 0) {
					var boards:XMLList = lvls[0].board;
					//if(boards.length() > 0) startBoard(boards[0]);
					if(boards.length() > 0) onCabinetLoaded(boards[0]);
				}
			}
		}
		
		/**
		 * @NOTE: This Function is used to start the process of the other functions
		 */
		 
		protected function onCabinetLoaded(pXML:XML) {
			// check if this is the first level we've loaded
			
			nextNode = pXML; // was previously set in startBoard
			
			var loadingEngine:LoadingEngineXML = controller.loadingEngine;
			var NameofAsset:String =  pXML.@path;
			
			if(curBoard != null) {
				prevBoard = curBoard;
			} 
			else 
			{
				prevBoard = null;
			}
			
			
			// set the new board as our current board
			var ldr:LoadedItem = loadingEngine.getLoaderObjmID(NameofAsset);
			curBoard = ldr.getObjectOutofLibrary(NameofAsset) as PinballCabinet;
			
			// init Actionscript Physics Engine
			APEngine.init(1/10);

			
			APEngine.container = curBoard;
			curBoard.initXML = nextNode; // pass the board's xml data into the cabinet
			addChild(curBoard); // add the board to the stage

			// set up the transition to the new board
			if(prevBoard != null) {
				prevBoard.disable();
				// check if both boards are part of the same level
				if(curNode.parent() == nextNode.parent()) {
					// if so, transition from one to the other
					curBoard.y = prevBoard.y - SCREEN_HEIGHT;
					// set up tweens
					mDelayTimer.start();
				} else {
					//Have the InGame Message Screen Appear
					controller.inGameMessager("Level1to2");
					
					removeChild(prevBoard); // otherwise, take the previous board off stage
					prevBoard = null;
					_updater.paused = false;
				}
			} else _updater.paused = false;
			// update our node references
			curNode = nextNode;
			nextNode = null;
			
			//####################### ADD TRANSLATION PER LEVEL ########################
			
		}
		
		/**
		 * @NOTE: This starts a delayed tween transition to the next level
		 */
		
		protected function delayTimer(evt:TimerEvent):void
		{
			mDelayTimer.stop();
			mDelayTimer.reset();
			upperTween = new Tween(curBoard,"y",Regular.easeInOut,curBoard.y,0,1,true);
			lowerTween = new Tween(prevBoard,"y",Regular.easeInOut,0,SCREEN_HEIGHT,1,true);
			lowerTween.addEventListener(TweenEvent.MOTION_FINISH,removeTweenedClip);
		}
		
		/**
		 * @NOTE: This Function cleans up the previous level after it's tweened off the 
		 * bottom of the screen.
		 */
		
		protected function removeTweenedClip(ev:TweenEvent) {
			var tw:Tween = ev.target as Tween;
			var obj:Object = tw.obj;
			if(obj != null) {
				var p:Object = obj.parent;
				if(p != null) {
					p.removeChild(obj);
					if(obj == prevBoard) prevBoard = null;
				}
			}
			tw.removeEventListener(TweenEvent.MOTION_FINISH,removeTweenedClip);
			_updater.paused = false;
		}
		
	}
	
}


	
	
	
	