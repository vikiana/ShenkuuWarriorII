package com.neopets.games.inhouse.shootergame.assets.ginterface
{
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.ShooterGame;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	/**
	 *	This the interface class.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.28.2009
	 */
	public class UI extends MovieClip
	{
		
		private static const BONUS_TARGETS_NO:Number = 10;
		//-------------------------------------------------------------------------------------------------
		// PRIVATE VARS
		//--------------------------------------------------------------------------------------------------
		//references
		private var _sl:SharedListener;
		private var _GAME:ShooterGame;
		private var _hitTargets:Number;
		//counters
		private var _sN:Number;
		private var _lN:Number;
		private var _lCount:Object;
		//score evar
		private var _score:Object;
		//flags
		private var _first100:Boolean = true;
		
		/**
		 * 
		 * Constructor
		 * 
		 * @param		sl		SharedListener
		 * @param       game    ShooterGame. To access the gamingsystem.
		 */
		public function UI(sl:SharedListener, game:ShooterGame)
		{
			super();
			_sl = sl;
			_GAME = game;
			//EVARS
			_score = _GAME.main.gamingSystem.createEvar (0);
			_lCount = _GAME.main.gamingSystem.createEvar (3);
			//events Listeners
			_sl.addEventListener(SharedListener.GAME_STARTED, setSoundButtons);
			_sl.addEventListener(SharedListener.START_GEARS, startGears);
			//_sl.addEventListener(SharedListener.STAGE_START, displayStage);
			_sl.addEventListener(SharedListener.NEW_LEVEL, displayLevel)
			_sl.addEventListener(SharedListener.LOOSE_LIFE, updateLives);
			_sl.addEventListener(SharedListener.DONTSHOOT, displayScore);
			_sl.addEventListener(SharedListener.BOSS_DEAD, winGame);
			_sl.addEventListener(SharedListener.ADD_SCORE, displayScore);
			_sl.addEventListener(SharedListener.INIT_STAGE_END, endStage);
			//buttons
			stopSoundsBut.init(_GAME.main);
			stopSoundsBut.addEventListener (MouseEvent.CLICK, stopGameSounds);
			stopMusicBut.init(_GAME.main);
			stopMusicBut.addEventListener (MouseEvent.CLICK, stopGameMusic);
			
			endGame_btn.init (_GAME.main, "FGS_GAME_MENU_END_GAME");
			endGame_btn.addEventListener (MouseEvent.CLICK, quitGame);
			_sl.addEventListener("hideEndGameButton", hideEGButton);
			_sl.addEventListener("showEndGameButton", showEGButton);
			//misc
			_hitTargets = 1;
			_sN = 1;
			_lN = 1;
			//
			displayStage();
			//TESTING ==========================================================
			passLevel_btn.init(_GAME.main, "DNT_TESTING_SKIPLEVEL");
			passLevel_btn.addEventListener (MouseEvent.CLICK, forcePassLevel);
			passStage_btn.init(_GAME.main, "DNT_TESTING_SKIPSTAGE");
			passStage_btn.addEventListener (MouseEvent.CLICK, forcePassStage);
			winGame_btn.init(_GAME.main, "DNT_TESTING_WINGAME");
			winGame_btn.addEventListener (MouseEvent.CLICK, forceWinGame);
			//===================================================================
		}
		
		//TESTING ===============================================================================================================
		private function forcePassLevel(e:MouseEvent):void {
			trace ("FORCE PASS LEVEL");
			_sl.sendCustomEvent(SharedListener.LEVEL_END, {type:"MidLevelOverlay", win:"passLevel", finalscore:333}, false, true);
		}
		private function forcePassStage(e:MouseEvent):void {
			trace("FORCE PASS STAGE");
			if (_sN<=1){
				_sl.sendCustomEvent(SharedListener.INIT_STAGE_END, null, false, true);
			} else {
				forcePassLevel(null);
			}
		}
		private function forceWinGame(e:MouseEvent):void {
			trace ("FORCE WIN GAME");
			_sl.sendCustomEvent(SharedListener.GAME_END, {type:"MidLevelOverlay", win:"win", finalscore:333}, false, true);
		}
		//=======================================================================================================================
		//-------------------------------------------------------------------------------------------------
		// PUBLIC METHODS
		//--------------------------------------------------------------------------------------------------
		public function cleanUp ():void{
			removeEventListeners();
			//
			_GAME = null;
			_sl = null;
		}
		
		//this is called at new level
		public function reInit ():void {
			_sN = 1;
			_sl.addEventListener(SharedListener.BOSS_DEAD, winGame)
		}
		
		//-------------------------------------------------------------------------------------------------
		// EVENT HANDLERS
		//--------------------------------------------------------------------------------------------------
		public function startGears(e:CustomEvent=null):void {
			_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"menu_reveal", loop:false}, false, true);
			if (_sl.hasEventListener(SharedListener.START_GEARS)){
				_sl.removeEventListener(SharedListener.START_GEARS, startGears);
			}
			gear1.startMoving ();
			gear2.startMoving ();
			slit1.startMoving ();
			_sl.addEventListener(SharedListener.STOP_GEARS, stopGears);
		}
		
		public function stopGears(e:CustomEvent=null):void {
			if (_sl.hasEventListener(SharedListener.STOP_GEARS)){
				_sl.removeEventListener(SharedListener.STOP_GEARS, stopGears);
			}
			gear1.stopMoving ();
			gear2.stopMoving ();
			slit1.stopMoving ();
			_sl.addEventListener(SharedListener.START_GEARS, startGears);
		}
		
		
		private function displayScore(e:CustomEvent):void {
			if (!e.oData.dontshoot){
			 	if (_hitTargets+1 > BONUS_TARGETS_NO && _first100){
					scoreclock.advanceOne ("00");
					_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"bonus_100", loop:false}, false, true);
					_score.changeBy (100);
					_first100 = false;
				} else {
					if (e.oData.value >2){
						scoreclock.advanceOne (String(_hitTargets++));
					}
				}
				_score.changeBy (e.oData.value);
				scoreclock.score_txt.text = _score.show();
			} else {
				if (_score.show() >5){
					_score.changeBy (-5)
					scoreclock.score_txt.text = _score.show();
				}
			}
		}
		
		private function displayStage(e:CustomEvent=null):void {
			if (!e){
				_sN = 1;
			} else {
				_sN = Number (level.level_txt.text)+1;
			}
			level.level_txt.text = String (_sN);
			if (Number(level.level_txt.text)>1){
				level.level_txt.x = -10.5;
			}
		}
		
		private function displayLevel(e:CustomEvent=null):void {
			if (!e){
				_lN = 1;
			} else {
				_lN = Number (level.level_txt.text)+1;
			}
			level.level_txt.text = String (_lN);
			//adjust position of number to center it
			if (Number(level.level_txt.text)>1){
				level.level_txt.x = -10.5;
			}
		}
		
		private function updateLives (e:CustomEvent):void {
				//_lCount.changeBy(-1);
			switch (_lCount.show()){
				case 2:
					life3.glow.visible = false;
				break;
				case 1:
					life2.glow.visible = false;
				break;
				case 0:
					life1.glow.visible = false;
					_win = "loose";
					endTheGame(_win);
					if (_sl.hasEventListener(SharedListener.BOSS_DEAD)){
						_sl.removeEventListener(SharedListener.BOSS_DEAD, winGame);
					}
				break;
			}
		}
		
		private function endStage (e:CustomEvent):void {
			trace ("UI: endStage: _sN =", _sN);
			_sN++;
			if (_sN>3){
				_sl.sendCustomEvent(SharedListener.SEND_BOSS, {stageNo:_sN}, false, true);
			} else {
				_sl.sendCustomEvent(SharedListener.STAGE_END, {target:this, type:"EndStageOverlay", stageNo:_sN}, false, true);
			}
		}
		
		
		private function winGame (e:CustomEvent):void {
			if (_sl.hasEventListener(SharedListener.BOSS_DEAD)){
				_sl.removeEventListener(SharedListener.BOSS_DEAD, winGame);
			}
			var score:Number = _score.show();
			_score.changeBy (score);
			score = _score.show ();
			scoreclock.score_txt.text = score;
			if (_GAME.levelNo <=2){
				_sl.sendCustomEvent(SharedListener.LEVEL_END, {type:"MidLevelOverlay", win:"passLevel", finalscore:score}, false, true);
			} else {
				_sl.sendCustomEvent(SharedListener.GAME_END, {type:"MidLevelOverlay", win:"win", finalscore:score}, false, true);
			}
			endGame_btn.visible = false;
		}
		
		private function quitGame (e:MouseEvent):void {
			endTheGame ("quit");
		}
		
		private function showEGButton (e:CustomEvent):void {
			endGame_btn.visible = true;
		}
		private function hideEGButton (e:CustomEvent):void {
			endGame_btn.visible = false;
		}
		
		private function stopGameSounds (e:MouseEvent):void {
			_sl.sendCustomEvent(SharedListener.CHANGE_SOUNDS, {fromUI:true});
		}
		
		private function stopGameMusic (e:MouseEvent):void{
			_sl.sendCustomEvent(SharedListener.CHANGE_MUSIC, {fromUI:true});
		}
		
		private function setSoundButtons (e:CustomEvent):void {
			if (!_GAME.main.soundOn){
				stopSoundsBut.gotoAndStop("off");
				stopSoundsBut.isOff = true;
			}
			if (!_GAME.main.musicOn){
				stopMusicBut.gotoAndStop("off");
				stopMusicBut.isOff = true;
			}
		}
		
		private function removeEventListeners ():void {
			if (_sl.hasEventListener(SharedListener.GAME_STARTED)){_sl.removeEventListener(SharedListener.GAME_STARTED, setSoundButtons);}
			if (_sl.hasEventListener(SharedListener.START_GEARS)){_sl.removeEventListener(SharedListener.START_GEARS, startGears);}
			//if (_sl.hasEventListener(SharedListener.STAGE_START)){_sl.removeEventListener(SharedListener.STAGE_START, displayStage);}
			if (_sl.hasEventListener(SharedListener.NEW_LEVEL)){_sl.removeEventListener(SharedListener.NEW_LEVEL, displayLevel);}
			if (_sl.hasEventListener(SharedListener.LOOSE_LIFE)){_sl.removeEventListener(SharedListener.LOOSE_LIFE, updateLives);}
			if (_sl.hasEventListener(SharedListener.DONTSHOOT)){_sl.removeEventListener(SharedListener.DONTSHOOT, displayScore);}
			if (_sl.hasEventListener(SharedListener.BOSS_DEAD)){_sl.removeEventListener(SharedListener.BOSS_DEAD, winGame);}
			if (_sl.hasEventListener(SharedListener.ADD_SCORE)){_sl.removeEventListener(SharedListener.ADD_SCORE, displayScore);}
			if (_sl.hasEventListener(SharedListener.INIT_STAGE_END)){_sl.removeEventListener(SharedListener.INIT_STAGE_END, endStage);};
			if (_sl.hasEventListener(SharedListener.STOP_GEARS)){_sl.removeEventListener(SharedListener.STOP_GEARS, stopGears);}
			//
			_sl.removeEventListener("hideEndGameButton", hideEGButton);
			_sl.removeEventListener("showEndGameButton", showEGButton);
		}
		//-------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		//-------------------------------------------------------------------------------------------------
		
		private function endTheGame (win:String):void {
			var score:Number = _score.show();
			_sl.sendCustomEvent(SharedListener.GAME_END, {type:"MidLevelOverlay", win:win, finalscore:score}, false, true);
			endGame_btn.visible = false;
		}
		

	}
}