//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.effects.BonusPickupFX;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Bullet;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.ClusterPowerup;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.FlyingPowerUp;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Hook;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Ledge;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.LedgeBreaking;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.LedgeCloud;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.LedgeDissolve;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.LedgeKite;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.LedgesPowerup;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.PointsPowerup;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.PowerUp;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.ScrollingBkg;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.ScrollingLedges;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.ScrollingPowerUps;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Warrior;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.Parameters;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.LevelData;
	import com.neopets.games.inhouse.shenkuuwarrior2.screens.Scoreboard;
	import com.neopets.games.inhouse.shenkuuwarrior2.utils.altitude_meter;
	import com.neopets.games.inhouse.shenkuuwarrior2.utils.control_panel;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.users.vivianab.ClickerControl;
	import com.neopets.util.collision.CollisionManager;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.getClassByAlias;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import virtualworlds.lang.TranslationManager;
	
	

	
	/**
	 * This is the main game class. It includes the game logic and it creates most of the game entities.
	 * This is where the display list is managed.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */

	public class ShenkuuWarrior2_Game extends MovieClip
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * GAME STATES
		 */
		public static var IDLE:String = "idle";
		public static var LAUNCHED:String = "hook is launched";
		public static var HOOKED:String = "hooked";
		public static var FLYING:String = "warrior is flying";
		public static var FREE_FLYING:String = "warrior is free flying";
		public static var RESET_GAME:String = "reset game";
		public static var PP_POWERUP:String = "petpet power up";
		public static var KITE_POWERUP:String = "kite power up";
		public static var END_LEVEL:String = "end level";
		public static var PAUSE:String = "pause game";
		public static var UNPAUSE:String = "unpause game";
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//level description
		private var _levelData:LevelData;
		private var _levelsXML:XML;
		//starts at -1. First level is Level 0.
		private var _levelNo:int = -1;
		//hook 
		private var _hook:Hook; 
		private var _hookDO:MovieClip;
		//rope
		private var _rope:Sprite;
		//warrior
		private var _warriorDO:MovieClip;
		private var _warrior:Warrior;
		//scrolling bkg
		private var _scrollBg:ScrollingBkg;
		private var _scrollBgDO:Sprite;
		//scrolling ledges
		private var _scrollLdgs:ScrollingLedges;
		private var _scrollLdgsDO:Sprite;
		private var _hookedLedge:Ledge;
		private var _hookedX:Number=0;
		//powerups
		private var _scrollPus:ScrollingPowerUps;
		private var _scrollPusDO:Sprite;
		private var _hookedPowerUp:PowerUp;
		//fade screen
		private var _fadeScreen:Sprite;
		//VFX: one only at the time allowed?
		private var _VFXcontainer:Sprite;
		private var _VFX:BonusPickupFX;
		//timer interval
		private var _timer:Timer;
		//celebrationTimer
		private var _endLevelTimer:Timer;
		//gamestate
		private var _gamestate:String = IDLE;
		//flags
		private var _isBulletHook:Boolean = false;
		private var _isReset:Boolean = false;
		private var _levelEnded:Boolean = false;
		private var _levelEnding:Boolean = false;
		private var _isPaused:Boolean = false;
		private var _isLedgesPowerup:Boolean = false;
		private var _isSoundOn:Boolean = true;
		private var _isFailing:Boolean = false;
		//root
		private var _gameroot:MovieClip;
		//scoreboard
		private var _scoreboard:Scoreboard;
		private var _altMeter:altitude_meter;
		
		private var _points:Number=0;
		private var _altitude:Number=0;
		private var _time:Number=0;
		private var _accuracy:Number=0;
		private var _ltotal:Number=0;
		private var _total:Number=0;
		
		private var _clicksNo:Number = 0;
		
		private var _popuptype:String;
		//clicker block
		private var _cBlock:ClickerControl;
		//LEVEL TIMER COUNTER
		private var _lcounter:int;
		private var _ltcount:int;
		//POPUP
		private var _popup:String;
		//game mask
		private var _mask:Sprite;
		//CHEAT
		private var ee:String = GameInfo.EE;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Game instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ShenkuuWarrior2_Game(root:MovieClip)
		{
			super();
			_gameroot = root;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		/**
		 * This is to update the physics parameters when they change with the Control Panel) and is exclusively called by the control_panel class
		 * 
		 * <span class="hide">This is commented out for performance.</span>
		 *
		 * 
		 */
		public function updateParams():void {
			_warrior.updateParameters();
			_hook.updateParameters();
		}
		
		public function quitGame():void {
			_popup = ShenkuuWarrior2_GameEngine.MENU_SCORE_SCR;
			_popuptype = GameInfo.POPUP_FAIL;
			_gamestate = RESET_GAME;
		}
		
		
		
		public function playSoundFX(obj:*=null, sname:String="", loops:int=0):void {
			if (_isSoundOn){
			var soundname:String;
			var volume:Number = 1;
			if (obj){
				if (obj is Warrior){
					soundname = GameInfo.WARRIOR_FAIL_SOUND;
					volume = 0.5;
				} else if (obj is Hook){
					soundname = GameInfo.HOOK_THROW_SOUND;
				}else if (obj is PointsPowerup){
					soundname = String (GameInfo.POINTS_SOUND+String(Mathematic.randRange(1, 3)));
				} else if (getQualifiedClassName(obj) == "px2"){
					soundname = GameInfo.X2_SOUND;
				} else if (obj is LedgeKite){
					soundname = GameInfo.KITE_POWERUP_SOUND;
				}else if (obj is FlyingPowerUp){
					soundname = GameInfo.PP_POWERUP_SOUND;
				}else if (obj is LedgeBreaking){
					if (!LedgeBreaking(obj).broke){
						if (_levelNo<3){
							soundname = GameInfo.BREAK_SOUND;
							volume = 0.5;
						} else {
							//TODO : put cloud break sound
							soundname = GameInfo.HOOK_SOFT;
						}
					} else {
						if (_levelNo<3){
							soundname = GameInfo.HOOK_HARD;
						} else {
							soundname = GameInfo.HOOK_SOFT;
						}
					}
				} else if (obj is Ledge || obj is LedgeKite){
					soundname = GameInfo.HOOK_HARD;
				} else if (obj is LedgeCloud || obj is LedgeDissolve){
					soundname = GameInfo.HOOK_SOFT;
				} 
			} else if (!obj && sname != "") {
				soundname = sname;
			}
			//play it
			if (soundname){
				SoundManager.instance.soundPlay(soundname, false, 0,loops, volume);
			}
			}
		}
		
		public function playSoundLoop (id:int):void {
			if (_isSoundOn){
				if (SoundManager.instance.getSoundObj(GameInfo.AMBIENT+id)){
					SoundManager.instance.soundPlay(String(GameInfo.AMBIENT+id), true);
				}
			}
		}
		
		public function stopMusic ():void {
			var so:String = GameInfo.AMBIENT+String(Number(_levelNo+1));
			if (SoundManager.instance.getSoundObj(so)){
				SoundManager.instance.stopSound(so);
			}
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		//THESE ARE CALLED FROM THE GAME ENGINE CLASS
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 * Sets up the game elements
		 * 
		 * @param  levelsXML  The levels description from the loaded XML config file.
		 * 
		 */
		public function init(levelsXML:XML):void {
			//keyboard input
			_gameroot.stage.addEventListener(KeyboardEvent.KEY_DOWN, processKeyboardInput);
			//LEVELS
			_levelData = new LevelData ();
			//levels description from config.xml
			_levelsXML = levelsXML;
			//SCROLLING BKGS
			_scrollBgDO = new Sprite();
			addChild(_scrollBgDO);
			_scrollBg = new ScrollingBkg (_scrollBgDO);
			//clicker blocker
			_cBlock = new ClickerControl ();
			_cBlock.init (GameInfo.CLICKER_TIMER_LAPSE, "", new Point (GameInfo.STAGE_WIDTH/2, GameInfo.STAGE_HEIGHT/2), this);
			//MASK
			_mask = new Sprite();
			_mask.graphics.beginFill(0xcccccc);
			_mask.graphics.drawRect(0, 0, GameInfo.STAGE_WIDTH, GameInfo.STAGE_HEIGHT);
			_mask.graphics.endFill();
			addChild(_mask);
			_scrollBgDO.mask = _mask;
			//SCROLLING LEDGES
			_scrollLdgsDO = new Sprite();
			//ledges events
			_scrollLdgsDO.addEventListener(GameInfo.LEDGE_BREAK, onLedgeBreaks, false, 0, true);
			addChild(_scrollLdgsDO);
			_scrollLdgs = new ScrollingLedges (_scrollLdgsDO);
			//scrolling ledges mask
			//var msk:Sprite = _scrollLdgs.makeCoverSprite();
			//addChild(msk);
			//USING THE SAME MASK FOR ALL ELEMENTS
			_scrollLdgsDO.mask = _mask;
			//SCROLLING POWERUPS
			_scrollPusDO = new Sprite();
			_scrollPusDO.addEventListener(GameInfo.ADD_POINTS, onAddPoints);
			_scrollPusDO.addEventListener(GameInfo.ENABLE_SPAWN_LEDGES, onSpawnLedgePU);
			addChild(_scrollPusDO);
			_scrollPus = new ScrollingPowerUps (_scrollPusDO);
			//WARRIOR FX CONTAINER
			_VFXcontainer = new Sprite();
			addChild(_VFXcontainer);
			//WARRIOR
			var wclass:Class = Class (getDefinitionByName("warrior_mc"));
			_warriorDO = new wclass();
			_warrior = new Warrior (_warriorDO, this, null, true);
			_warrior.isSoundOn = _isSoundOn;
			//HOOK
			var hclass:Class = Class (getDefinitionByName("hook_mc"));
			_hookDO = new hclass();
			_hook = new Hook (_hookDO, this, null, false);
			hookOnWarrior();
			//ROPE
			_rope = new Sprite ();
			addChild(_rope);
			updateRope();
			//METER::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			_altMeter = new altitude_meter();
			_altMeter.addEventListener(MouseEvent.CLICK, pointAndShoot, false, 0, true);
			_altMeter.x = 488;
			_altMeter.y = 583;
			addChild(_altMeter);
			//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			//FADESCREEN
			makeFadeScreen();
			//SCOREBOARD
			var sclass:Class = Class (getDefinitionByName("scoreboard"));
			_scoreboard = new sclass ();
			_scoreboard.y = 0//GameInfo.STAGE_HEIGHT;
			addChild (_scoreboard);
			_scoreboard.init();
			//SET UP LEVEL
			nextLevel();
			//COLLISON SPACE
			//DEBUG CANVAS FOR COLLISION ENGINE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			//CollisionManager.addCanvas(GameInfo.COLLISION_SPACE, this);	
			//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		}
		
		/**
		 *  This initialize the level. It's called everytime a level is started or re-started. The clean-up function for this is resetGame()
		 * 
		 */
		public function nextLevel():void {
			resetScoreboard();
			//UP LEVEL
			_levelNo++;
			//INIT LEVEL
			_levelData.initFromXML( _levelsXML.level[_levelNo]);
			_scrollBg.init (_levelData, levelNo);
			_scrollBgDO.addEventListener(GameInfo.LEVEL_ENDING, onEndingLevel, false, 0, true);
			_scrollLdgs.init (_levelData, levelNo);
			_scrollPus.init(_levelData);
			//_hook.hasAimLine = true;
			//PARAMETERS
			var params:XMLList = _levelsXML.level[_levelNo]["parameters"];
			Parameters.instance.init (Number(params.@g), Number(params.@drag), Number(params.@bounce),  Number(params.@hookforce),  Number(params.@ropepull), Number(params.@slowdown) );
			dispatchEvent(new Event(control_panel.UPDATEFROMPARAMS));
			//METER (invisible on endless level)
			if (_levelNo<2){
				_altMeter.visible = true;
				_altMeter.init(Number (_levelsXML.level[_levelNo].@height));
			} else {
				_altMeter.visible = false;
			}
			_warrior.updateParameters();
			_hook.updateParameters();
			//CONTROLS
			if (!_scrollLdgsDO.hasEventListener(MouseEvent.MOUSE_DOWN)){
				_scrollLdgsDO.addEventListener(MouseEvent.MOUSE_DOWN, pointAndShoot, false, 0, true);
			}
			_scrollLdgsDO.mouseChildren = true;
			_scrollLdgsDO.useHandCursor = true;
			//LISTENERS
			addEventListener(GameInfo.LOSE_ROPE, clearRope, false, 0, true);
			//TIMER: GAME STARTS
			createTimer();
			playSoundLoop(_levelNo+1);
		}

		/**
		 * Pauses the game.
		 * 
		 * @param  flag  Set to true to pause the game at any time.
		 * 
		 */
		public function pause (flag:Boolean):void {
			_isPaused = flag;
		}
		
		/**
		 * Reset the score to the previous total score if the level is failed. Called after "try again" is called.
		 * 
		 */
		public function resetLevelScore():void {
			_total -= _ltotal;
			_ltotal = 0;
		}
		
		
		/**
		 * Called after "try again" button is pressed.
		 * 
		 */
		public function restartLevel():void {
			resetGame();
			//Tweener.addTween(_fadeScreen, {alpha:0, time:0.5});
			//reset score
			resetLevelScore();
			pause(false);
		}
		
		
		public function resetScore():void {
			_total = 0;
		}
		
		/**
		 * The games cleans conpletely up only when Send Score or Quit Game are called. To restert the game after this, init has to be called abain.
		 * 
		 */
		public function cleanUp ():void {
			trace ("CLEAN UP GAME");
			stopMusic ();
			clearTimer();
			_clicksNo = 0;
			_gamestate = IDLE;
			_fadeScreen.alpha = 0;
			//cleanUpVXF();
			//remove events listeners
			if (_gameroot.stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
				_gameroot.stage.removeEventListener(KeyboardEvent.KEY_DOWN, processKeyboardInput);
			}
			if (hasEventListener(GameInfo.LOSE_ROPE)){
				removeEventListener(GameInfo.LOSE_ROPE, clearRope);
			}
			if (_scrollLdgsDO.hasEventListener(MouseEvent.CLICK)){
				_scrollLdgsDO.removeEventListener(MouseEvent.CLICK, pointAndShoot);
			}
			_scrollLdgsDO.removeEventListener(GameInfo.LEDGE_BREAK, onLedgeBreaks);

			if (_scrollBgDO.hasEventListener(GameInfo.LEVEL_ENDING)){
				_scrollBgDO.removeEventListener(GameInfo.LEVEL_ENDING, onEndingLevel);
			}
			//METER::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			if (_altMeter){
				if (_altMeter.hasEventListener(MouseEvent.CLICK)){
					_altMeter.removeEventListener(MouseEvent.CLICK, pointAndShoot);
				}
			}
			clearEndLevelTimer();
			//cleanup on all class instances
			if(_scrollBg != null) _scrollBg.cleanUp();
			if(_scrollLdgs != null) _scrollLdgs.cleanUp();
			if(_scrollPus != null) _scrollPus.cleanUp();
			if(_warrior != null) _warrior.cleanUp();
			if(_hook != null) _hook.cleanUp();
			if(_altMeter != null) _altMeter.reset();
			
			//remove all children
			for (var i:int = numChildren-1; i>=0; i--){
				removeChildAt(i);
			}
			//set to null all class instances
			_scrollBg = null;
			_scrollLdgs = null;
			_scrollPus = null;
			_warrior = null;
			_hook = null;
			_rope = null;
			_altMeter = null;
			//..and vars
			_levelsXML = null;
			_hookedLedge = null;
			//set flags to starting value
			_isBulletHook = false;
			_isReset = false;
			_levelEnding = false;
			_levelEnded = false;
			_isFailing = false;
			_isPaused = false;
			_isLedgesPowerup = false;
			//clicker control
			if (_cBlock){
				_cBlock.clearClickerTimer();
				_cBlock = null;
			}
			//reset cheat code 
			ee = GameInfo.EE;
		}
		
		//--------------------------------------------------------------------------
		// Private/Protected Methods
		//--------------------------------------------------------------------------
		//GAME ENGINE TIMER
		protected function createTimer ():void{
			//level timer counter 
			_ltcount = 1000/GameInfo.T_INTERVAL;
			_lcounter = 0;
			//timer
			clearTimer();
			_timer = new Timer (GameInfo.T_INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, update);
			_timer.start();
		}
		
		
		
		private function clearTimer():void {
			if (_timer){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, update);
				_timer = null;
			}
		}
		
		
		//ROPE
		protected function clearRope():void {
			for (var i:int = 0;  i < _rope.numChildren; i++){
				_rope.removeChildAt(i);
			}
		}
		
		protected function updateRope():void {
			clearRope();
			var l:Shape = new Shape ();
			l.graphics.lineStyle (2, 0, 1, false,"none"); 
			l.graphics.moveTo (_warriorDO.x, _warriorDO.y);
			l.graphics.lineTo(_hookDO.x, _hookDO.y);
			_rope.addChild (l);
		}
		
		protected function rewindRope():void {
			clearRope();
		}
		
		
		//HOOK
		protected function checkHookCollisions():Ledge {
			if(_hook.proxy == null) return null;
			var collisions:Array = _hook.proxy.colliderList;
			var hit_proxy:CollisionProxy;
			var proxy_owner:DisplayObject;
			for(var i:int = 0; i < collisions.length; i++) {
				hit_proxy = collisions[i] as CollisionProxy;
				if(hit_proxy != null) {
					proxy_owner = hit_proxy.owner;
					if(proxy_owner != null) {
						if(proxy_owner is Ledge) return proxy_owner as Ledge;
					} // end of owner test
				} // end of proxy test
			} // end of collision list loop
			return null;
		}
			
		
		private function isHooked():Boolean {
			var hkd:Boolean = true;
			if (_hookedLedge is LedgeBreaking){
				if (!LedgeBreaking(_hookedLedge).broke){
					var breaktime:Number = _warrior.getReachLedgeTime (_hookedLedge.y)/2;
					LedgeBreaking(_hookedLedge).init(breaktime);
				}
			} else if (_hookedLedge is LedgeDissolve){
				//LedgeDissolve doesn't hook at all
				LedgeDissolve(_hookedLedge).dissolve();
				hkd = false;
			} else if (_hookedLedge is LedgeKite){
				var reachtime:Number = _warrior.getReachLedgeTime (_hookedLedge.y);
				var t:Timer = new Timer (reachtime, 1);
				t.addEventListener(TimerEvent.TIMER_COMPLETE, warriorSpring, false, 0, true);
				t.start();
			}
		
			if (hkd){
				_warrior.hook();
				_hook.hook();
				_hook.clearAimLine();
				//_hook.hasAimLine = false;
				return true;
			} else {
				return false;
			}
		}
		
		
		protected function warriorSpring (e:TimerEvent):void {
			Timer(e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, warriorSpring);
			if (_hookedLedge){
				LedgeKite(_hookedLedge).ledgeHooked();
				playSoundFX(_hookedLedge);
				_gamestate = KITE_POWERUP;
			}
		}
		
		
		protected function hookOnWarrior():void{
			//trace ("hook on warrior");
			_hookDO.x = _warriorDO.x;
			_hookDO.y = _warriorDO.y;
			_hook.proxy.synch();
		}
		
		protected function hookOnLedge ():void {
			_hookDO.x = _hookedLedge.x + _hookedX; 
			_hookDO.y = _hookedLedge.y;
			_hook.proxy.synch();
		}
		
		
		//POWERUPS
		protected function checkPowerups():void {
			if(_warrior.proxy == null) return;
			var collisions:Array = _warrior.proxy.colliderList;
			var hit_proxy:CollisionProxy;
			var proxy_owner:DisplayObject;
			for(var i:int = 0; i < collisions.length; i++) {
				hit_proxy = collisions[i] as CollisionProxy;
				if(hit_proxy != null) {
					proxy_owner = hit_proxy.owner;
					if(proxy_owner != null) {
						if(proxy_owner is PointsPowerup){
							PointsPowerup(proxy_owner).getPowerup();
							//FLYING PU
						} else if(proxy_owner is FlyingPowerUp){
							clearRope();
							_scrollPus.removePU (FlyingPowerUp(proxy_owner));
							_gamestate = PP_POWERUP;
							playSoundFX(GameInfo.PPU_PICKUP);
							playSoundFX(FlyingPowerUp(proxy_owner));
							//powerup w/out VFX
							//startPowerupTimer (endFlyingPowerup, GameInfo.FLYING_POWERUP_SECS);
							//powerup w visual FX
							createVFX(["particle2"], GameInfo.FLYING_POWERUP_SECS, endFlyingPowerup);
							//LEDGES PU
						}	else if(proxy_owner is LedgesPowerup){
							LedgesPowerup(proxy_owner).getPowerup();
						}
					} // end of owner test
				} // end of proxy test
			} // end of collision list loop
		}
		
		
		
		
		//visual FX :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function createVFX(pClasses:Array, timeLapse:int, callBack:Function):void {
			startPowerupTimer (callBack, timeLapse);
			_VFX = new BonusPickupFX ();
			//_VFX.addEventListener(MouseEvent.CLICK, pointAndShoot, false, 0, true);
			_VFX.init(pClasses, _VFXcontainer, 4);
			
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
		
		protected function checkPUCollisions ():PowerUp {
			var b:Bullet = Bullet (_hook);
			return _scrollPus.checkCollisions(b);
		}
		
		private function startPowerupTimer (callBack:Function, secs:int):void {
			var t:Timer = new Timer (1000, secs);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, callBack, false, 0, true);
			t.start();
		}
	
		private function endFlyingPowerup (e:TimerEvent):void {
			Timer(e.target).stop();
			Timer (e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, endFlyingPowerup);
			if (_warrior){
				_warrior.isPowerup = false;
				_gamestate = FREE_FLYING;
			}
			if (_VFX){
				_VFX.active = false;
			}
		}
		
		//VFX ONLY
		private function endLedgesPowerup(e:TimerEvent):void {
			Timer(e.target).stop();
			Timer (e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, endLedgesPowerup);
			_VFX.active = false;
		}
		
	
		//TRAILERS
		private function makeTrailer(trailerClass:Class, followingDO:Sprite):void {
			var trb:Sprite = new trailerClass(); 
			trb.x = followingDO.x;
			trb.y = followingDO.y;
			addChild(trb);
			Tweener.addTween(trb, {alpha:0, time:1, onComplete:removeTrailer, onCompleteParams:[trb]});
		}
		
		private function removeTrailer (trailer_mc:Sprite):void {
			if (contains(trailer_mc)){
				removeChild(trailer_mc);
			}
		}
		
		//BKG AND OTHER ELEMENTS SCROLLING
		protected function scrollBkg (vy:Number):void {
			if (vy){
				_scrollBg.update(vy);
				_scrollLdgs.update(vy);
			}
			_scrollPus.update(vy);
		}
		
		
		//SCORE
		protected function updateScoreboard ():void {
			if (_gamestate != IDLE && _gamestate != RESET_GAME && _gamestate != PAUSE && _gamestate != END_LEVEL){
				_lcounter++;
				if (_lcounter >= _ltcount){
					_time ++;
					_lcounter = 0;
				}
				_altitude = _warrior.altitude;
				_scoreboard.update(_points, _altitude, _time);
				//trace ("update score", _points, _altitude, _time);
			}
		}
		
		protected function addPoints (obj:PowerUp):void {
			//update scoreboard ledges_pu icon
			var p:Number =0;
			if (getQualifiedSuperclassName(obj.parent)== "com.neopets.games.inhouse.shenkuuwarrior2.elements::ClusterPowerup"){				//p = ClusterPowerup (obj).checkPoints();
				p += ClusterPowerup (obj.parent).checkClusterComplete();
				if (p>0){
					doubleRewards ();
				}
			} 
			p += PointsPowerup.assignPointValue(obj);
			playSoundFX(obj);
			_points+= p;
		}
		
		private function doubleRewards():void {
			var drClass:Class = Class (getDefinitionByName("px2"));
			var dr:MovieClip = new drClass ();
			dr.scaleX = dr.scaleY = 0.2;
			dr.alpha = 0.3;
			dr.x = GameInfo.STAGE_WIDTH/2;
			dr.y = GameInfo.STAGE_HEIGHT/2;
			dr.gotoAndStop(TranslationManager.instance.languageCode);
			dr.addEventListener(MouseEvent.CLICK, pointAndShoot, false, 0, true);
			addChild(dr);
			Tweener.addTween(dr, {scaleX:3, scaleY:3, alpha:1, time:0.5, transition:"easeoutquint", onComplete:removePx2, onCompleteParams:[dr]});
			playSoundFX(dr);
		}
		
		private function removePx2 (dr:MovieClip):void {
			if (dr){
				dr.removeEventListener(MouseEvent.CLICK, pointAndShoot)
				removeChild(dr);
			}
		}
		
		//RESET CONDITIONS
		private function isHookOut():Boolean{
			if ( _hookDO.y > GameInfo.MIN_Y){
				_hook.reset();
				_hook.isReset = false;
				 clearRope();
				return true;
			}
			return false;
		}
		
		private function isHookOutOnTop():Boolean{
			if (_hookDO.y < -100){
				clearRope();
				return true;
			}
			return false;
		}
		
		private function isWarriorOut():Boolean{
			//leaves more time for the powerup to kick in if it's caught on at the bottom of the screen
			var xlimit:Number = (_warrior.isPowerup)  ? GameInfo.MIN_Y+100 : GameInfo.MIN_Y;
			if (_warriorDO.y > xlimit){
				_popup = ShenkuuWarrior2_GameEngine.MENU_SCORE_SCR;
				_popuptype = GameInfo.POPUP_FAIL;
				playSoundFX(_warrior);
				return true;
			}
			return false;
		}
		
		private function endlevelTimer(lapse:Number, callback:Function):void {
			_endLevelTimer = new Timer (500, lapse);
			_endLevelTimer.addEventListener(TimerEvent.TIMER_COMPLETE, callback);
			_endLevelTimer.start();
		}

		//SCORE FUNCTIONS
		private function saveLevelScore ():void {			//GameInfo.SCORE_TIME_MULTIPLIER (134) is a chosen multiplier to make time more relevant to the score
			_time  *= GameInfo.SCORE_TIME_MULTIPLIER;
			//trace ("CLICKS NO: ", _clicksNo);
			_accuracy = (GameInfo.ACCURACY_BONUS -  _clicksNo)* GameInfo.SCORE_ACCURACY_MULTIPLIER;
			if (_clicksNo < 3) {_accuracy = 0}
			if (_accuracy <0){_accuracy=0};
			_ltotal = _altitude - _time + _points + _accuracy;
			if (_ltotal < 0){_ltotal = 0};
			_total +=_ltotal;
			//
			ScoreManager.instance.changeScoreTo(_total);
		}

	
		protected function resetScoreboard ():void {
 			_accuracy = 0;
			_points = 0;
			_altitude = 0;
			_time = 0;
			_scoreboard.reset();
		}
		
		
		//RESET is for when the level end or the warrior/hook fall..
		protected function resetGame():void {
			trace ("RESET GAME");
			if (contains(_fadeScreen)){
				removeChild(_fadeScreen);
			}
			//cleanUpVXF();
			_cBlock.resetClickerTimer();
			//stops the end level window from coming down if you quit
			clearEndLevelTimer();
			if (_rope){
				clearRope();
			}
			_warrior.reset();
			_warrior.onGround = true;
			_hookDO.visible = true;
			_hook.reset();
			hookOnWarrior();
			//_hook.hasAimLine = true;
			_scrollBg.reset();
			_scrollLdgs.reset();
			_scrollPus.reset();
			//
			_clicksNo = 0;
			//locks
			_isReset = true;
			_warrior.isReset = false;
			_hook.isReset = false;
			_levelEnded = false;
			_levelEnding = false;
			_isFailing = false;
			_lcounter = 0;
			_isLedgesPowerup = false;
			resetScoreboard();
		}
		
		private function clearEndLevelTimer():void {
			if (_endLevelTimer){
				if (_endLevelTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)){
					_endLevelTimer.removeEventListener (TimerEvent.TIMER_COMPLETE, callEndLevelWindow);
				}
				if (_endLevelTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)){
					_endLevelTimer.removeEventListener (TimerEvent.TIMER_COMPLETE, failedLevel);
				}
				_endLevelTimer = null;
			}
		}
		
		 private function failedLevel(e:TimerEvent):void {
			 //send the score to the shell
			 var scoreData:Object  = getScore();
			 dispatchEvent(new CustomEvent ({screen:_popup, data:scoreData}, GameInfo.GET_POPUP));
			 //if (!_levelEnding){
				//resetGame();
			// }
		 }
		 
		public function getScore ():Object{
			//record score
			saveLevelScore();
		 	return {
				type: _popuptype,
				altitude:_altitude,
				time:	_time,
				points:	_points,
				accuracy: _accuracy,
				ltotal: _ltotal,
				total:	_total
			};
		 }
		
		
		private function makeFadeScreen ():void {
			_fadeScreen = new Sprite ();
			var s:Shape = new Shape();
			s.graphics.beginFill (0x000000);
			s.graphics.drawRect(0, 0, 550, 600);
			s.graphics.endFill(); 
			_fadeScreen.addChild (s);
			_fadeScreen.alpha = 0;
		}
		
		private function fadeOutGame ():void {
			addChildAt(_fadeScreen, numChildren-2)
			Tweener.addTween(_fadeScreen, {alpha:0.8, time:0.4, onComplete:fadedOut});
		}
		
		private function fadedOut():void {
			pause(true);
		}
		
		private function getTopIdx():int{
			if (contains(_fadeScreen)){
				return 3;
			} else {
				return 2;
			}
		}
		
	
		
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Main Engine
		 * 
		 * @param event The <code>TimerEvent</code>
		 * 
		 */
		protected function update (e:TimerEvent):void {
			if (!_isPaused){
				
				if (_VFX && _VFX.active){
					_VFX.update(_warriorDO.x, _warriorDO.y, _warrior.bkgVy);
				}
				
				//hook always on top (under scoreboard and fadescreen, actually)
				swapChildren(_hookDO, getChildAt(numChildren-getTopIdx()));
				//trace ("GAMESTATE", _gamestate);
				//update score
				updateScoreboard();
			
				//update ledges collision space
				_scrollLdgs.updateLedges();
				
				//update all movements
				if (!_levelEnding){
					_hook.update();
					_warrior.update(false);
					scrollBkg(_warrior.bkgVy);
				} else {
					if (_scrollBg.lastBkg.y <=0 && _warriorDO.y <= GameInfo.STAGE_HEIGHT+_warriorDO.height/2){
						_warrior.update(true);
						scrollBkg(- Math.abs(_warrior.bkgVy));
					}  else {
						if (!_levelEnded){
							_levelEnded = true;
							_warriorDO.y = GameInfo.STAGE_HEIGHT+_warriorDO.height/2;
							_gamestate = END_LEVEL;
						}
					}
				}
				//check for events (across the states) that might change the game state
				if (!_isFailing){
					if (!_levelEnding){
						if (isHookOut()){_gamestate = IDLE};	
						if (isHookOutOnTop()){_gamestate = IDLE};
						if (isWarriorOut()){
							_gamestate = RESET_GAME
						};
					} else {
						isHookOutOnTop();
						isHookOut()
					}
					_altMeter.update(_altitude);
				}
			}
			//check for events (gamestate-specific) that might change the game state
			switch (_gamestate){
				case IDLE:
					hookOnWarrior();
					//animate warrior
					if (!_warrior.onGround && _warriorDO.currentLabel != GameInfo.JUMP_ANIMATION){
						_warriorDO.gotoAndStop(GameInfo.AIR_READY);
					}
					break;
				case LAUNCHED:
					//animate warrior
					if (_warriorDO.currentLabel != GameInfo.JUMP_ANIMATION){
						if (_warrior.onGround){
							_warriorDO.gotoAndStop(GameInfo.GROUND_THROW);
							_warrior.aimArm(mouseX, mouseY);
						} else {
							if (_warriorDO.currentLabel == GameInfo.KITE_AIR_MOVING || _warriorDO.currentLabel == GameInfo.KITE_AIR_READY || _warriorDO.currentLabel == GameInfo.KITE_AIR_THROW){
								_warriorDO.gotoAndStop(GameInfo.KITE_AIR_THROW);
							} else {
								_warriorDO.gotoAndStop(GameInfo.AIR_THROW);
							}
							_warrior.aimArm(mouseX, mouseY);
						}
					}
					//animate rope
					updateRope(); 
					//check for ledges collisions 
					if ( _isBulletHook && _hookDO.y < _warriorDO.y){
						_hookedLedge = checkHookCollisions();
						if (_hookedLedge){
							_hookedX = _hookDO.x -_hookedLedge.x;
							//check the type of ledge
							if (isHooked()){_gamestate = HOOKED};
						}
					}
					break;
				case HOOKED:
					//animate rope
					updateRope();
					//play fx
					playSoundFX(_hookedLedge);
					//launch warrior
					_warrior.launch(_hookDO.x, _hookDO.y);
					_gamestate = FLYING;
					break;
				case FLYING:
					//animate warrior
					if (_warriorDO.currentLabel != GameInfo.JUMP_ANIMATION){
						_warriorDO.gotoAndStop(GameInfo.AIR_MOVING);
						_warrior.aimArm(_hookDO.x, _hookDO.y);
					}
					//animate rope
					hookOnLedge();
					updateRope();
					//check for powerups collisions
					checkPowerups();
					//if warrior passed the ledge
					if (_warriorDO.y < _hookDO.y){
						rewindRope();
						_warrior.onGround = false;
						_gamestate = FREE_FLYING;
					}
					break;
				case FREE_FLYING:
					//animate warrior
					if (_warriorDO.currentLabel != GameInfo.JUMP_ANIMATION && _warriorDO.currentLabel != GameInfo.FALLING){
						if (_warriorDO.currentLabel == GameInfo.KITE_AIR_MOVING || _warriorDO.currentLabel == GameInfo.KITE_AIR_READY){
							_warriorDO.gotoAndStop(GameInfo.KITE_AIR_READY);
						} else if (_warriorDO.currentLabel == GameInfo.PETPET_AIR_MOVING || _warriorDO.currentLabel == GameInfo.PETPET_AIR_READY){
							_warriorDO.gotoAndStop(GameInfo.PETPET_AIR_READY);
						} else {
							_warriorDO.gotoAndStop(GameInfo.AIR_READY);
						}
					}
					//animate rope
					hookOnWarrior();
					//check for powerups collisions
					checkPowerups();
					break;
				case RESET_GAME:
					//animate rope
					_hookDO.visible = false;
					clearRope();
					//
					endlevelTimer(1, failedLevel);
					_isFailing = true;
					fadeOutGame();
					_gamestate = IDLE;
					break;
				case PP_POWERUP://IS A STATE
					//animate warrior
					if (_warriorDO.currentLabel != GameInfo.JUMP_ANIMATION){
						_warriorDO.gotoAndStop(GameInfo.PETPET_AIR_MOVING);
					}
					//animate rope
					hookOnWarrior();
					//set flag on warrior
					_warrior.isPowerup = true;
					//catch all powerups TODO: BETTER VISUAL INDICATION
					_scrollPus.catchPUs (_warriorDO);
					break;
				case KITE_POWERUP://IS AN EVENT
					//animate warrior
					if (_warriorDO.currentLabel != GameInfo.JUMP_ANIMATION){
						_warriorDO.gotoAndStop(GameInfo.KITE_AIR_MOVING);
					}
					//animate rope
					hookOnWarrior();
					clearRope();
					//rewindRope();
					//set flag on warrior
					_warrior.isKitePowerup = true;
					_gamestate = FREE_FLYING;
					break;
				case END_LEVEL:
					//animate warrior
					_warrior.finalAnimation();
					//animate rope
					clearRope();
					//set timer for end level screen
					endlevelTimer(4, callEndLevelWindow);
					playSoundFX(null, GameInfo.CELEBRATION);
					//stops sounds
					_gamestate = PAUSE;
					break;
				case PAUSE:
					//_hook.hasAimLine = false;
					_isPaused = true;
					_gamestate = IDLE;
					break;
				case UNPAUSE:
					//_hook.hasAimLine = true;
					_isPaused = false;
					_gamestate = IDLE;
					break;
			} 
		}
		
		
		
		protected function onAddPoints (e:CustomEvent):void {
			addPoints (e.oData.obj);
		}
		

		protected function onSpawnLedgePU (e:CustomEvent):void {
			_isLedgesPowerup = true;
			/*var t:Timer = new Timer (1000, GameInfo.SPAWN_LEDGES_PU_DURATION);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onSpawnLedgePUOff, false, 0, true);
			_warrior.highlite(true);
			t.start();*/
			playSoundFX(null, GameInfo.BPU_PICKUP);
			_scoreboard.updateLedges(GameInfo.SPAWN_LEDGES_NUMBER);
			_scoreboard.ledges_icon.gotoAndStop("enabled");
			//visual FX
			createVFX(["particle1"], GameInfo.LEDGES_POWERUP_SECS, endLedgesPowerup);
		}
		
		//THIS IS IF WE WANT THE SPAWN POWERUP TO BE TIME-SENSITIVE
		/*protected function onSpawnLedgePUOff (e:TimerEvent):void {
			Timer (e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, onSpawnLedgePUOff);
			_gameroot.stage.removeEventListener(KeyboardEvent.KEY_DOWN, spawnLedge);
			_warrior.highlite(false);
		}*/
		
		protected function processKeyboardInput(e:KeyboardEvent):void {
			var ss:Number =  ee.charCodeAt(0);
			if (e.charCode == ss){
				ee = ee.substring(1);
				if (ee == ""){
					dispatchEvent(new Event (GameInfo.GET_LEVELS_SCREEN));
				}
			}
			//space
			if (e.charCode == 32 && _isLedgesPowerup){
				playSoundFX(null, GameInfo.INFLATE, 2);
				_scrollLdgs.spawnExtraLedge();
				if (_scoreboard.updateLedges(-1)<=0){
					_isLedgesPowerup = false;
					_scoreboard.ledges_icon.gotoAndStop("disabled");
				}
			}
		}
		
	
		protected function onLedgeBreaks (e:CustomEvent):void {
			playSoundFX(e.oData.obj);
			rewindRope();
			_hookedLedge = null;
			_warrior.onGround = false;
			_warrior.slowDown();
			_gamestate = FREE_FLYING;
		}
		
	
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::autoclicker cheat block end::::::::::::::::::::::::::::::::::::::
		
		
		protected function pointAndShoot(e:MouseEvent):void {
			trace ("pointAndShoot -  is Paused?", _isPaused, "clicked on", DisplayObject(e.target).name,"click enabled?", _cBlock.clickEnabled, _gamestate);
			if (!_isPaused){
				if (_cBlock.clickEnabled){
					_cBlock.start();
					_isReset = false;
					_clicksNo++;
					if (_gamestate != HOOKED && _gamestate != PP_POWERUP && _gamestate != END_LEVEL && _gamestate != PAUSE && _gamestate != RESET_GAME)
					{
						if (_hook.pointandshoot(_warriorDO)){
							if (_gamestate == LAUNCHED){
								hookOnWarrior();
								trace ("SHOOT");
							} else {
								_gamestate = LAUNCHED;
							}
							playSoundFX(_hook);
							_isBulletHook = true;
						}
					}
				} else {
					//_cBlock.getSlowDownMessage();
				}
			}
		}
		
	
		
		
		
		protected function onEndingLevel (e:Event):void {
			_scrollBgDO.removeEventListener(GameInfo.LEVEL_ENDING, onEndingLevel);
			_levelEnding = true;
		}
		
		
		protected function callEndLevelWindow (e:TimerEvent=null):void {
			if (e){
				_endLevelTimer.removeEventListener (TimerEvent.TIMER_COMPLETE, callEndLevelWindow);
				_endLevelTimer = null;
			}
			stopMusic();
			_popup = ShenkuuWarrior2_GameEngine.MENU_ENDLEVEL_SCR;
			_popuptype = GameInfo.POPUP_LEVEL+String(_levelNo+1);
			_gamestate = RESET_GAME;
		}
		
	
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		//TODO: avoid setting this externally to this class.
		public function set levelNo (value:int):void{
			_levelNo = value;
		}
		
		public function get levelNo ():int{
			return _levelNo;
		}
		
		public function set isSoundOn (value:Boolean):void {
			_isSoundOn = value;
		}
	}
}