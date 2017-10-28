
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy
{
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.FlagsOfFrenzyCountdown;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.FlagsOfFrenzyShell;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.flags.FloatingFlag;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.flags.PointsFlag;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.flags.PrizeFlag;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.physics.LinearJet;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.ChanceTree;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.MenuClip;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.WeightedList;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 *	This class handles the tools and options available at each stage of game creation.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.23.2010
	 */
	 
	public class FlagsOfFrenzyGame extends MenuClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const GAME_STARTED:String = "game_started";
		public static const GAME_OVER:String = "game_over";
		public static const SCORE_CHANGED:String = "score_changed";
		public static const ITEM_GAINED:String = "item_gained";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _gameBounds:Rectangle;
		protected var _spawnTimer:Timer;
		protected var _spawnChances:ChanceTree;
		// component variables
		protected var _boundingArea:DisplayObject;
		// physics handlers
		protected var _reflectRatio:Number;
		protected var _jet:LinearJet;
		// prize variables
		protected var _NPTotal:NP9_Evar;
		protected var _prizeIDs:WeightedList;
		protected var _PrizeAwarded:Boolean = false;
		protected var _allowPrizeAward:Boolean = false;
		public var timerBox:FlagsOfFrenzyCountdown;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FlagsOfFrenzyGame():void{
			super();
			// initilaize variables
			_NPTotal = new NP9_Evar(0);
			_prizeIDs = new WeightedList();
			initPhysics();
			// initialize spawn timer
			if(_spawnTimer == null) {
				_spawnTimer = new Timer(1000,1);
				_spawnTimer.addEventListener(TimerEvent.TIMER,onSpawnTimer);
			}
			//initSpawnChances();
			// check for components
			boundingArea = getChildByName("bounds_mc");
			if(_boundingArea == null) boundingArea = this;
			// set up listeners
			//addEventListener(MENU_SHOWN,startGame);
			addEventListener(FloatingFlag.FLAG_CAUGHT,onFlagCaught);
			addEventListener(FlagsOfFrenzyCountdown.COUNTDOWN_DONE,onCountdownDone);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get boundingArea():DisplayObject { return _boundingArea; }
		
		public function set boundingArea(dobj:DisplayObject) {
			_boundingArea = dobj;
			// recalculate bounds
			if(_boundingArea != null) {
				_gameBounds = _boundingArea.getBounds(this);
				_jet.position = _gameBounds.bottom;
			}
		}
		
		public function get score():Number
		{
			return _NPTotal.show();
		}
		
		public function get prizeAwardFlag():Boolean
		{
			return _PrizeAwarded;
		}
		
		public function set allowPrizeAward(pFlag:Boolean):void
		{
			_allowPrizeAward = pFlag;	
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to shift the score value.
		
		public function changeScoreBy(val:Number) {
			if(val != 0) {
				_NPTotal.changeBy(val);
				var transmission:CustomEvent = new CustomEvent(_NPTotal.show(),SCORE_CHANGED);
				dispatchEvent(transmission);
			}
		}
		
		// Use this function to force the score to a given value.
		
		public function changeScoreTo(val:Number) {
			var cur_val = _NPTotal.show();
			if(val != cur_val) {
				_NPTotal.changeBy(val);
				var transmission:CustomEvent = new CustomEvent(cur_val,SCORE_CHANGED);
				dispatchEvent(transmission);
			}
		}
		
		// This function creates a new flag and resets the spawn timer.
		
		public function spawnFlag():void {
			// create new flag
			//var flag:MovieClip = new FlagTypesMC();
			var flag_class:String;
			
			var flag_type:XML = _spawnChances.getRandomNode();
			var tflagType:String = flag_type.localName();
			var flag:MovieClip;
			
			if (tflagType.search("PointFlag") != -1)
			{
				flag_class = "PointsFlag";	
			}
			else
			{
				flag_class = "PrizeFlag";
			}
			
			flag = GeneralFunctions.getInstanceOf(flag_class) as MovieClip;
			
			switch (tflagType)
			{
				case "PointFlag10":
					flag.setPointField(10);
					break;
				case "PointFlag20":
					flag.setPointField(20);
					break;
				case "PointFlag50":
					flag.setPointField(50);
					break;
				case "PointFlag100":
					flag.setPointField(100);
					break;
				case "PointFlag500":
					flag.setPointField(500);
					break;
				case "prizeFlag":
					flag.prizeID = tflagType;
					break;
				
				default:
				
				break;
			}
			
			// add flag to stage
			// try to use ths bounding area clip for our target index
			if(_boundingArea != null && _boundingArea.parent == this) {
				var index:int = getChildIndex(_boundingArea) + 1;
				addChildAt(flag,index);
			} else addChild(flag);
			// move flag to random horizontal position
			var flag_bounds:Rectangle = flag.getBounds(this);
			var l_shift:Number = _gameBounds.left - flag_bounds.left + .5;
			var r_shift:Number = _gameBounds.right - flag_bounds.right - .5;
			flag.x += GeneralFunctions.getRandom(l_shift,r_shift);
			// move flage to bottom of screen
			flag.y += _gameBounds.bottom - flag_bounds.bottom - .5;
			// add movement listeners
			flag.addEventListener(FloatingFlag.ON_MOVEMENT,onFlagMovement);
			// try resetting the spawn timer
			var delay:Number = GeneralFunctions.getRandom(750,2500);
			_spawnTimer.delay = delay;
			_spawnTimer.reset();
			_spawnTimer.start();
		}
		
		// When the menu is shown, restart the game.
		
		public function startGame(ev:Event = null):void {
			// reset values
			initSpawnChances();
			changeScoreTo(0);
			_prizeIDs.clearItems();
			// spawn first flag
			spawnFlag();
			// dispatch start event
			dispatchEvent(new Event(GAME_STARTED));
		}
		
		/**
		 * Forces Ending the Game
		 */
		
		public function endGame():void
		{
			_spawnTimer.stop();
			
			// let listeners know the game has ended
			dispatchEvent(new Event(GAME_OVER));	
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the countdown is done, switch to the end game screen.
		
		protected function onCountdownDone(ev:CustomEvent) {
			_spawnTimer.stop();
			//callMenu(FlagsOfFrenzyShell.GAME_OVER_MENU);
			// let listeners know the game has ended
			dispatchEvent(new Event(GAME_OVER));
		}
		
		// When a flag is caught, check it for any prizes.
		
		protected function onFlagCaught(ev:BroadcastEvent) {
			var flag:MovieClip = ev.sender as MovieClip;
			// check if this is a prize flag
			var prize_flag:PrizeFlag = flag as PrizeFlag;
			if(prize_flag != null) {
				changeScoreBy(prize_flag.pointValue);
				// check for a prize id
				var id:String = prize_flag.prizeID;
				if(id == "prizeFlag"){
					_prizeIDs.addItem(id);
					_PrizeAwarded = true;
					var transmission:CustomEvent = new CustomEvent(prize_flag,ITEM_GAINED);
					dispatchEvent(transmission);
				}
			}
		}
		
		// This function lets the container react when a flag moves.
		
		protected function onFlagMovement(ev:Event) {
			var flag:MovieClip = ev.target as MovieClip;
			// check horizontal bounds
			var flag_bounds:Rectangle = flag.getBounds(this);
			var h_shift:Number = 0;
			if(flag_bounds.left <= _gameBounds.left) {
				h_shift = _gameBounds.left - flag_bounds.left + 1;
			} else {
				if(flag_bounds.right >= _gameBounds.right) {
					h_shift = _gameBounds.right - flag_bounds.right - 1;
				}
			}
			if(h_shift != 0) {
				flag.x += h_shift;
				flag.reflectBy(_reflectRatio,0);
			}
			// check vertical bounds
			var v_shift:Number = 0;
			if(flag_bounds.top <= _gameBounds.top) {
				v_shift = _gameBounds.top - flag_bounds.top + 1;
			} else {
				if(flag_bounds.bottom >= _gameBounds.bottom) {
					v_shift = _gameBounds.bottom - flag_bounds.bottom - 1;
				}
			}
			if(v_shift != 0) {
				flag.y += v_shift;
				flag.reflectBy(0,_reflectRatio);
			}
			// apply jets to bottom of flag
			var force:Number = _jet.getForceAt(flag_bounds.bottom);
			flag.applyForce(0,force);
		}
		
		
		
		// When the spawn timer goes off, spawn a new flag.
		
		protected function onSpawnTimer(ev:TimerEvent) {
			spawnFlag();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to initialize physics values.
		
		public function initPhysics():void {
			_reflectRatio = 0.5;
			_jet = new LinearJet(-100,8,1);
		}
		
		// Use this function to set up the spawn chance tree.
		
		protected function initSpawnChances():void {
			_spawnChances = new ChanceTree();
		
			// make points more common than items
			_spawnChances.addChance("PointFlag10",9);
			_spawnChances.addChance("PointFlag20",7);
			_spawnChances.addChance("PointFlag50",5);
			_spawnChances.addChance("PointFlag100",1.5);
			_spawnChances.addChance("PointFlag500",1);
			
		
			if (_allowPrizeAward)
			{
				_spawnChances.addChance("prizeFlag",1);	
			}
			
			
		}
		
	}
	
}
