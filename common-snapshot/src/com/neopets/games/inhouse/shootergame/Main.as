package com.neopets.games.inhouse.shootergame
{
	import com.neopets.games.inhouse.shootergame.gameshell.InstructionsPage;
	import com.neopets.games.inhouse.shootergame.gameshell.IntroPage;
	import com.neopets.games.inhouse.shootergame.gameshell.ScoringPage;
	import com.neopets.games.inhouse.shootergame.gameshell.SendScorePage;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.events.*;
	import com.neopets.util.sound.*;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 *	This the main game class. This handles all business until the game has started.  Once  Shootergame has been instantiated
 	 *	This class is only responsible for music and sound on
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli/Clive Henrick
	 *	@since  05.22.2009
	 */
	public class Main extends GameEngine
	{
		
		//-------------------------------------------------------------------------------------------------
		// PRIVATE VARS
		//--------------------------------------------------------------------------------------------------
		
		private var _GAME:ShooterGame;
		
		private var _introPage:IntroPage;
		private var	_instructionsPage:InstructionsPage;
		private var _sendscorePage:SendScorePage;
		private var _scoringPage:ScoringPage;
		
		private var	_soundOn:Boolean;
		private var	_musicOn:Boolean;
		
		private  var _sl:SharedListener;
		
		/**
		 * 
		 * Constructor
		 * 
		 * @param		sl		SharedListener: if it is not passed by the outer shell, it's created.
		 */
		public function Main(sl:SharedListener=null)
		{
			super();
			if (sl){
				_sl = sl;
			} else {
				_sl = new SharedListener();
			}
		}
		
		/**
		 * @Note: This is called by GameEngine once:
		 * 		>All soundFiles are loaded, 
		 * 		>Congfig file is ready,
		 * 		>All external assets are loaded and can be in this ApplicationDomain (Depends on the Config.xml)
		 * @Note: This is the start of your Games Setup
		 */
		override protected function initChild():void 
		  {	
		  	if (mRootMC){
		  		
				_soundOn = true;
				_musicOn = true;
		  		
		  		//create game scenes
		  		_GAME = new ShooterGame ();
		  		_GAME.init(this, mRootMC, _sl);
		  		_introPage = new IntroPage (this, _sl);
				_instructionsPage = new InstructionsPage(this, _sl);
				_sendscorePage = new SendScorePage(this, _sl);
				_scoringPage = new ScoringPage (this);
				
				//black  bar on bottom  - for online glitch that doesn't resize the 650x600 window.
				var mc:MovieClip = new MovieClip ();
				var s:Shape = new  Shape();
				s.graphics.drawRect(0, 0, 650, 100);
				s.graphics.beginFill (0xFFFFFF);
				s.graphics.endFill(); 
				mc.addChild (s);
				mc.y = 500;
				
				mViewContainer.addChildAt(_introPage, 0);
				mViewContainer.addChildAt(_scoringPage, 1);
				mViewContainer.addChildAt (_GAME, 2);
				mViewContainer.addChildAt (_instructionsPage, 3);
				mViewContainer.addChildAt (_sendscorePage, 4);
				
				mViewContainer.addChildAt (mc, 5);
				
				//output(String(mViewContainer.getChildAt(0)));
				getIntroPage (null);
				
				soundManager.soundPlay("IntroLoop", true);
				
				addEventListeners();
		  		setupFonts();
		  		completedSetup();
		  	}
		  }
		  
		override protected function completedSetup():void {
			mRootMC.addChild(mViewContainer);
			trace("GameEngine has completedSetup: mViewContainer has this number of Children>", mViewContainer.numChildren, " ROOT NumChildren>", mRootMC.numChildren);
			mGameShell_Events.dispatchEvent(new CustomEvent({CMD:mGameShell_Events.CMD_PRELOADER_DONE},mGameShell_Events.ACTION_SEND_CMD_SHELL));
			dispatchEvent(new CustomEvent({CMD:mGameShell_Events.CMD_PRELOADER_DONE},SEND_THROUGH_CMD));
		}
		  
		//-----------------------------------------------------------------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------------------------------------------------------------
		
		public function setTransText( fontName:String, tf:TextField, str:String):void {
			if (mGamingSystem != null) {
				var translated:String = mGamingSystem.getTranslation (str);
				translated = translated == null ? "********" : translated;
				mGamingSystem.setFont( fontName );
				mGamingSystem.setTextField( tf, translated );
			}
		}
		
		public function setFormattedText( fontName:String, tf:TextField, str:String):void {
			if (mGamingSystem != null) {
				//var translated:String = mGamingSystem.getTranslation (str);
				str = str == null ? "********" : str;
				mGamingSystem.setFont( fontName );
				mGamingSystem.setTextField( tf, str );
			}
		}
		
		//-----------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------------------------------------------------------------
		
		private function setupFonts ():void {
			var headerFontClass:Class = LibraryLoader.getLibrarySymbol ("DisplayFont");
			var bodyFontClass:Class = LibraryLoader.getLibrarySymbol ("BodyFont");
			gamingSystem.addFont (new headerFontClass(), "displayFont");
			gamingSystem.addFont (new bodyFontClass(), "bodyFont");
		}
		
		private function addEventListeners ():void {
			_sl.addEventListener(SharedListener.ADD_SENDSCORE_PAGE, getSendScorePage);
			_sl.addEventListener(SharedListener.GOTO_GAME, getGamePage);
			_sl.addEventListener(SharedListener.GOTO_INSTRUCTIONS, getInstructionsPage);
			_sl.addEventListener(SharedListener.BACK_TO_INTRO, getIntroPage);
			_sl.addEventListener(SharedListener.GAME_RESTART, restartGame);
			_sl.addEventListener(SharedListener.SEND_SCORE, getScoringPage);
			_sl.addEventListener(SharedListener.CHANGE_MUSIC, changeMusicMode);
			_sl.addEventListener(SharedListener.CHANGE_SOUNDS, changeSoundsMode);
		}
		
		
		public function changeMusicMode (e:CustomEvent = null):void {
			soundManager.stopAllCurrentSounds();
			if (_musicOn){
				_musicOn = false;
			} else {
				_musicOn = true;
				if (e.oData.fromUI){
					soundManager.soundPlay("GameLoop", true);
				} else {
					soundManager.soundPlay("IntroLoop", true);
				}
			}
		}
		
		public function changeSoundsMode (e:CustomEvent = null):void {
			if (_soundOn){
				_soundOn = false;
			} else {
				_soundOn = true;
			}
		}
	
		private function getSendScorePage (e:CustomEvent):void {
			_sendscorePage.score = e.oData.finalscore;
		  	_introPage.visible = false;
			_instructionsPage.visible = false;
			_sendscorePage.visible = true;
			_scoringPage.visible = false;
		}
		
		private function getInstructionsPage (e:Event):void {
			_introPage.visible = false;
			_instructionsPage.visible = true;
			_sendscorePage.visible = false;
			_scoringPage.visible = false;
			
		}
		
		private function getGamePage (e:Event):void {
			if (_musicOn){
				soundManager.stopSound("IntroLoop");
				soundManager.soundPlay("GameLoop", true);
			}
			_GAME.visible = true;
			_introPage.visible = false;
			_instructionsPage.visible = false;
			_sendscorePage.visible = false;
			_scoringPage.visible = false;
			//THIS TELLS THE GAME OVERLAY TO START THE TIMER AND, AFTER 2 SECONDS, THE GAME
			_sl.sendCustomEvent(SharedListener.GAME_STARTED, false, true);
		}
		
		private function getIntroPage (e:Event):void {
			_GAME.visible = false;
			_introPage.visible = true;
			_instructionsPage.visible = false;
			_sendscorePage.visible = false;
			_scoringPage.visible = false;
		}
		
		private function getScoringPage(e:CustomEvent):void {
			_GAME.visible = false;
			_GAME.cleanUp();
			_introPage.visible = false;
			_instructionsPage.visible = false;
			_sendscorePage.visible = false;
			_scoringPage.visible = true;
		}
		
		
		private function restartGame (e:CustomEvent):void {
			if (_musicOn){
				soundManager.stopSound("GameLoop");
				soundManager.soundPlay("IntroLoop", true);
			}
			_instructionsPage.visible = false;
			_sendscorePage.visible = false;
			_scoringPage.visible = false;
			mViewContainer.removeChild(_GAME);
			//QUICK FIX for cleanup problems: RELOADS THE WHOLE GAME ON RESTART
			/*if(ExternalInterface.available){
				var pageURL:String=ExternalInterface.call('window.location.href.toString');
					 navigateToURL(new URLRequest(pageURL),'_self'); 
			}
			*/
			_GAME = new ShooterGame ();
		  	_GAME.init(this, mRootMC, _sl);
			mViewContainer.addChildAt (_GAME, 2);
			getIntroPage (null);
		}
		
		//-----------------------------------------------------------------------------------------------------
		// GETTERS/SETTERS
		//-----------------------------------------------------------------------------------------------------
		
		public function get soundOn():Boolean
		{
			return _soundOn;
		}
		public function set soundOn(b:Boolean):void
		{
			_soundOn = b
		}
		
		public function get musicOn():Boolean
		{
			return _musicOn;
		}
		
		public function set musicOn(b:Boolean):void
		{
			_musicOn = b
		}
	}
}