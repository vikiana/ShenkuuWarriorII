package com.neopets.games.inhouse.shootergame
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.abstract.AbstractOverlay;
	import com.neopets.games.inhouse.shootergame.overlays.EndStageOverlay;
	import com.neopets.games.inhouse.shootergame.overlays.MidLevelOverlay;
	import com.neopets.games.inhouse.shootergame.overlays.WarningOverlay;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	
	/**
	 *	The Overlay Manager creates and manages all games overlays (level transitions, etc.)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.25.2009
	 */
	public class OverlayManager
	{

		private var _GAMINGSYSTEM:MovieClip;
		private var _GAME:ShooterGame;
		private var _sl:SharedListener;
		
		private var _oX:Number;
		private var _oY:Number;
		private var _oZ:Number;
		
		private var _midLevelOverlay:MidLevelOverlay;
		private var _warningOverlay:WarningOverlay;
		private var _endStageOverlay:EndStageOverlay;
		
		private var _timer:Timer;
		private var _type:String;
		
		private var _firstTimer:Boolean;
		
		private var _stageNo:Number;
		private var _levelNo:Number;
		/**
		 * 
		 * Constructor
		 * 
		 * @param       game    ShooterGame: The object that creates the overlays
		 * @param		sl		SharedListener 
		 */
		public function OverlayManager(game:ShooterGame, sl:SharedListener=null)
		{
			_GAME = game;
			_GAMINGSYSTEM = game.main.gamingSystem;
			_sl = sl;
			_firstTimer = true;
			_stageNo = 1;
			_levelNo = 1;
		}
		
		
		
		//---------------------------------------------------
		//  PUBLIC METHODS 
		//---------------------------------------------------
		public function createOverlays ():void {
			//START GAME OVERLAY
			var overlayClass:Class = LibraryLoader.getLibrarySymbol("com.neopets.games.inhouse.shootergame.overlays.MidLevelOverlay");
			_midLevelOverlay = new overlayClass(_GAMINGSYSTEM);
			if (_midLevelOverlay.message_txt){
				_midLevelOverlay.setText(_midLevelOverlay.message_txt,"IDS_STARTGAME_MESSAGE", "displayFont");
			}
			_GAME.addChildToGame(_midLevelOverlay, true);
			
			///WARNING OVERLAY: text that appears when events occurs such as the boss is approaching
			overlayClass = LibraryLoader.getLibrarySymbol("com.neopets.games.inhouse.shootergame.overlays.WarningOverlay");
			_warningOverlay = new overlayClass(_GAMINGSYSTEM);
			_GAME.addChildToGame(_warningOverlay, true);
			_warningOverlay.visible = false;
			
			///END LEVEL OVERLAY: text that appears when the stages are passed. TODO: ADD PASS OT NOT PASS OPTION
			overlayClass = LibraryLoader.getLibrarySymbol("com.neopets.games.inhouse.shootergame.overlays.EndStageOverlay");
			_endStageOverlay = new overlayClass(_GAMINGSYSTEM);
			_GAME.addChildToGame(_endStageOverlay, true);
			_endStageOverlay.y = - ShooterGame.STAGE_HEIGHT;
			_endStageOverlay.visible = false;
			
			//EVENT LISTENERS
			addEventListeners();
		}
		
		public function addEventListeners():void {
			_sl.addEventListener (SharedListener.GAME_STARTED, startTimer);
			_sl.addEventListener (SharedListener.WARN_BOSS, openOverlay);
			_sl.addEventListener (SharedListener.DESTROY_TARGET, openOverlay);
			_sl.addEventListener (SharedListener.STAGE_END, openOverlay);
			_sl.addEventListener(SharedListener.DONTSHOOT, openOverlay);
			_sl.addEventListener (SharedListener.GAME_END, openOverlay);
			_sl.addEventListener (SharedListener.LEVEL_END, openOverlay);
		}
	
		
		public function removeEventListeners():void {
			if (_sl.hasEventListener (SharedListener.WARN_BOSS)){
				_sl.removeEventListener (SharedListener.WARN_BOSS, openOverlay);
			};
			if (_sl.hasEventListener (SharedListener.DESTROY_TARGET)){
				_sl.removeEventListener (SharedListener.DESTROY_TARGET, openOverlay);
			}
			if (_sl.hasEventListener (SharedListener.STAGE_END)){
				_sl.removeEventListener (SharedListener.STAGE_END, openOverlay);
			}
			if (_sl.hasEventListener(SharedListener.DONTSHOOT)){
				_sl.removeEventListener(SharedListener.DONTSHOOT, openOverlay);
			}
			if (_sl.hasEventListener (SharedListener.GAME_END)){
				_sl.removeEventListener (SharedListener.GAME_END, openOverlay);
			}
			if (_sl.hasEventListener (SharedListener.LEVEL_END)){
				_sl.removeEventListener (SharedListener.LEVEL_END, openOverlay);
			}
			if (_sl.hasEventListener(SharedListener.STAGE_START)){
				_sl.removeEventListener(SharedListener.STAGE_START, closeOverlay);
			}
			if (_sl.hasEventListener(SharedListener.GAME_STARTED)){
				_sl.removeEventListener (SharedListener.GAME_STARTED, startTimer);
			}
		}
		
		public function cleanUp():void{
			removeEventListeners();
			_GAME.removeChildFromGame(_midLevelOverlay, true);
			_GAME.removeChildFromGame(_warningOverlay, true);
			_GAME.removeChildFromGame(_endStageOverlay, true);
			//
			Tweener.removeTweens(_midLevelOverlay);
			Tweener.removeTweens(_warningOverlay);
			Tweener.removeTweens (_endStageOverlay);
			_midLevelOverlay.cleanUp();
			_warningOverlay.cleanUp();
			_endStageOverlay.cleanUp();
			_midLevelOverlay = null;
			_warningOverlay = null;
			_endStageOverlay = null;
			//
			_GAMINGSYSTEM = null;
			_GAME = null;
			_sl =  null;
			//
			removeTimer ();
		};
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// EVENT HANDLERS
		//--------------------------------------------------------------------------------------------------------------------
		
		
		private function openOverlay (e:CustomEvent):void {
			if (e.oData.type != ""){
				var overlay:AbstractOverlay;
				var score:Number;
				switch (e.oData.type){
					case "MidLevelOverlay":
						overlay = _midLevelOverlay;
						if (e.oData.win=="win"){
							_sl.dispatchEvent(new CustomEvent (null, "hideEndGameButton"));
							score = e.oData.finalscore;
							_midLevelOverlay.setText(_midLevelOverlay.message_txt,"IDS_ENDGAME_WIN", "displayFont");
							Tweener.addTween (overlay, {y:0, time:2, transition:"easeInQuint", onComplete:endL_overlayIsDown, onCompleteParams:[overlay, false, score]})
						} else if (e.oData.win == "loose"){
							_sl.dispatchEvent(new CustomEvent (null, "hideEndGameButton"));
							score = e.oData.finalscore;
							_midLevelOverlay.setText(_midLevelOverlay.message_txt, "IDS_ENDGAME_LOOSE", "displayFont");
							Tweener.addTween (overlay, {y:0, time:2, transition:"easeInQuint", onComplete:endL_overlayIsDown, onCompleteParams:[overlay, false, score]})
						} else if (e.oData.win == "quit"){
							_sl.dispatchEvent(new CustomEvent (null, "hideEndGameButton"));
							score = e.oData.finalscore;
							_midLevelOverlay.setText(_midLevelOverlay.message_txt, "IDS_ENDGAME_QUIT", "displayFont");
							Tweener.addTween (overlay, {y:0, time:2, transition:"easeInQuint", onComplete:endL_overlayIsDown, onCompleteParams:[overlay, false, score]})
						} else if (e.oData.win == "passLevel"){
							_sl.dispatchEvent(new CustomEvent (null, "hideEndGameButton"));
							score = e.oData.finalscore;
							//IDS_ENDLEVEL
							_midLevelOverlay.setText(_midLevelOverlay.message_txt, "IDS_ENDLEVEL", "displayFont");
							Tweener.addTween (overlay, {y:0, time:2, transition:"easeInQuint", onComplete:endL_overlayIsDown, onCompleteParams:[overlay, true, score]})
						}
					break;
					case "WarningOverlay":
						overlay = _warningOverlay;
						overlay.visible = true;
						overlay.setText(_warningOverlay.message_txt,e.oData.message, "displayFont");
						createTimer ();
						_sl.dispatchEvent(new CustomEvent (null, "hideEndGameButton"));
					break;
					case "EndStageOverlay":
						overlay = _endStageOverlay;
						/*var messageVar:String;
						switch(e.oData.stageNo){
							case 2:
								messageVar = "IDS_STAGE1";
							break;
							case 3:
								messageVar = "IDS_STAGE2";
							break;
							case 4:
								messageVar = "IDS_STAGE3";
							break;
						}
						_sl.dispatchEvent(new CustomEvent (null, "hideEndGameButton"));
						overlay.setText(_endStageOverlay.message_txt, messageVar, "displayFont");
						overlay.visible = true;
						_sl.addEventListener (SharedListener.STAGE_START, closeOverlay);
						Tweener.addTween (overlay, {y:0, time:3, transition:"easeInQuint", onComplete:eL_overlayIsDown, onCompleteParams:[overlay]})*/
						//NO MIDSTAGE OVERLAY VERSION ------ to revert, delete the following line an dun comment all there is above-----------------
						_sl.sendCustomEvent (SharedListener.LOAD_STAGE, false, true);
						//-----------------------------------------------------------------------------------------------------------------
					break;
					default:
					//return;
				}
				//code common to all overlays
				if (overlay && e.type != SharedListener.LEVEL_END){
					trace ("OM: removing event listener:"+e.type);
					_sl.removeEventListener(e.type, openOverlay);
					_sl.sendCustomEvent(SharedListener.START_GEARS, null, false, true);
				}
			}
		}
		
		
		
		private function closeOverlay (e:CustomEvent):void {
			var type:String;
			if (e != null){
				type = e.oData.type;
			} else {
				type = _type;
			}
			//Code specific to the overlay
			var overlay:AbstractOverlay;
			switch (type){
				case "MidLevelOverlay":
					overlay = _midLevelOverlay;
					Tweener.addTween (overlay, {y:- overlay.height, time:1, transition:"linear", onComplete:mL_overlayIsUp, onCompleteParams:[overlay]});
					_sl.addEventListener (SharedListener.GAME_END, openOverlay);
				break;
				case "WarningOverlay":
					removeTimer();
					overlay = _warningOverlay;
					_warningOverlay.visible = false;
					_sl.addEventListener(SharedListener.DONTSHOOT, openOverlay);
					_sl.dispatchEvent(new CustomEvent (null, "showEndGameButton"));
				break;
				case "EndStageOverlay":
					overlay = _endStageOverlay;
					Tweener.addTween (overlay, {y:- ShooterGame.STAGE_HEIGHT, time:1, transition:"linear", onComplete:eL_overlayIsUp, onCompleteParams:[overlay]});
					_sl.addEventListener (SharedListener.STAGE_END, openOverlay);
				break;
			}
			//remove the event that triggered the overlay to close
			if (overlay && e){
				_sl.removeEventListener(e.type, closeOverlay);
			}
			_sl.sendCustomEvent(SharedListener.START_GEARS, null, false, true);
		}
		
		
		private function startTimer (e:CustomEvent):void {
			createTimer();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------------------------------------------------
		
		//mid level overlay
		private function mL_overlayIsDown (target:AbstractOverlay):void {
			_sl.sendCustomEvent(SharedListener.STOP_GEARS, null, false, true);
		}

		private function mL_overlayIsUp (target:AbstractOverlay):void {
			_sl.dispatchEvent(new CustomEvent (null, "showEndGameButton"));
			_sl.sendCustomEvent(SharedListener.STOP_GEARS, null, false, true);
			//HERE WHERE THE GAME STARTS FIRST TIME
			_sl.sendCustomEvent (SharedListener.LEVEL_START, {stageNo:_stageNo}, false, true);
		}
		
		
		//end stage overlay
		private function eL_overlayIsDown (target:AbstractOverlay):void{
			_sl.sendCustomEvent(SharedListener.STOP_GEARS, null, false, true);
			_sl.sendCustomEvent (SharedListener.LOAD_STAGE, false, true);
		}
		
		private function eL_overlayIsUp (target:AbstractOverlay):void {
			_sl.sendCustomEvent(SharedListener.STOP_GEARS, null, false, true);
			_sl.sendCustomEvent (SharedListener.START_LAYER, {stageNo:_stageNo}, false, true);
			_sl.dispatchEvent(new CustomEvent (null, "showEndGameButton"));
		}
		
		//mid level overlay - end game 
		private function endL_overlayIsDown (target:AbstractOverlay, endLevel:Boolean, score:Number):void{
			_sl.sendCustomEvent(SharedListener.STOP_GEARS, null, false, true);
			if (!endLevel){
				_sl.sendCustomEvent (SharedListener.CLEAN_UP, null, false, true);
				_sl.sendCustomEvent(SharedListener.ADD_SENDSCORE_PAGE, {finalscore:score}, true, false);
			} else {
				//TODO: add code to start new level
				_firstTimer = true;
				_sl.sendCustomEvent(SharedListener.NEW_LEVEL, true, false);
				createTimer();
			}
		}
		
		
		
		// for timer-closed overlays
		private function createTimer ():void {
			_timer = new Timer (500, 3);
			_timer.addEventListener (TimerEvent.TIMER_COMPLETE, timedCloseOverlay);
			_timer.start();
		}
		
		private function removeTimer():void {
			if (_timer){
				_timer.removeEventListener (TimerEvent.TIMER_COMPLETE, timedCloseOverlay);
				_timer.stop();
				_timer = null;
			}
		}
		
		private function timedCloseOverlay (e:TimerEvent):void {
			if (_firstTimer){
				_type = "MidLevelOverlay";
				_firstTimer = false;
			} else {
				_type = "WarningOverlay";
			} 
			closeOverlay(null);
		}
	}
}