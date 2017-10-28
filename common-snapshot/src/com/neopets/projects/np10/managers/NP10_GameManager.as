//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.managers
{
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.np10.NP10_Document;
	import com.neopets.projects.np10.data.vo.GameShellConfigVO;
	import com.neopets.projects.np10.data.vo.GameStatesVO;
	import com.neopets.projects.np10.data.vo.PreloaderConfigVO;
	import com.neopets.projects.np10.data.vo.PrizeVO;
	import com.neopets.projects.np10.data.vo.StateVO;
	import com.neopets.projects.np10.statemachine.StateMachine;
	import com.neopets.projects.np10.statemachine.events.NP10_GamingSystemEvent;
	import com.neopets.projects.np10.statemachine.events.StateEvent;
	import com.neopets.projects.np10.statemachine.interfaces.IGameState;
	import com.neopets.projects.np10.statemachine.interfaces.INeopetsGame;
	import com.neopets.projects.np10.ui.screens.PreloaderScreen;
	import com.neopets.projects.np10.util.EncryptedVar;
	import com.neopets.projects.np10.util.Logging.NeopetsLogger;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.flashvars.FlashVarsFinder;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.Responder;
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.logging.Logger;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;

	/**
	 * public class NP10_GameManager
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NP10_GameManager 
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * This is a fixed value for games
		 */
		public static const TYPE_ID:int = 4;
		
		public static const PRELOADER_SCREEN:String = "preloader";
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------		
		public static var instance:NP10_GameManager = new NP10_GameManager (SingletonEnforcer);

		//
		private var _docClass:NP10_Document;
		//managers
		private var _CM:NeopetsConnectionManager;
		private var _TM:TranslationManager;
		private var _MM:NP10_ScreenManager;
		//state machine
		private var _SM:StateMachine;
		//Logger
		protected var _logger:Logger;
		//data
		protected var _gameShellConfig:GameShellConfigVO;
		
		//translation data
		protected var _td:TranslationData;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class NP10_GameManager instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function NP10_GameManager(lock:Class)
		{
			super();
			if(lock != SingletonEnforcer)
			{
				throw new Error( "Invalid Singleton access.  Use NP9_ConnectionManager.instance." ); 
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * INitial configuration
		 * @param  docClass  of type <code>NP10_Document</code> 
		 */
		public function init (docClass:NP10_Document, isVendor:Boolean=false):void {
			_docClass = docClass;
			
			//get connection manager
			_CM = NeopetsConnectionManager.instance;
			_CM.init(_docClass, isVendor);
			_CM.connect(_docClass);
			
			//get screen manager
			_MM = NP10_ScreenManager.instance;
			
			//register VOs
			GameShellConfigVO.register("GameShellConfigVO");
			PreloaderConfigVO.register("PreloaderConfigVO");
			PrizeVO.register("PrizeVO");
			GameStatesVO.register("GameStatesVO");
			StateVO.register("StateVO");
			
			//CREATE STANDARD STATES
			//The state machine will initialize with the standard states that are set by default in the GameStatesVO.
			//Then, when I call the AMFPHP, the result obj will replace the one in use, adding the extra states if necessary.
			_SM = new StateMachine ();
			
			//GET FLASHVARS OR ASSIGN DEFAULTS
			var fvr:FlashVarManager = FlashVarManager.instance;
			if (_CM.isOnline){
				//get flashvars from page
				fvr.initVars(docClass);
			} else {
				//set defaults from doc class
				fvr.setDefault("username", docClass.USERNAME)
				fvr.setDefault("lang", docClass.LANGUAGE);
				fvr.setDefault("gameID", docClass.GAMEID);
				fvr.setDefault("loglevel", docClass.LOGLEVEL);
				fvr.setDefault("country", docClass.COUNTRY);
			}
			
			//Parse initial config values. 
			//LOGIC: I create a new GameShellConfigVO; then, when I call the configuration from AMFPHP, I will replace it with the object that comes from the backend.
			_gameShellConfig = new GameShellConfigVO ();
			_gameShellConfig.userName = String(fvr.getVar("username"));
			_gameShellConfig.lang = String(fvr.getVar("lang"));
			_gameShellConfig.gameID = int(fvr.getVar("gameID"));
			_gameShellConfig.country = String (fvr.getVar("country"));
			
			//logger
			_logger = new NeopetsLogger ((fvr.getVar("loglevel")).toString());
			
			//SET INIITAL STATE
			_SM.setInitialState ();
		}
		
		public function nextState ():void{
			_SM.nextState();
		}
		
		//STATES TRANSITIONS
		public function getShellConfig():void
		{
			var responder:Responder = new Responder (getConfigSuccess, getConfigFail);
			_CM.callRemoteMethod("CapriSun2011.testCall", responder, _gameShellConfig.userName, _gameShellConfig.gameID, _gameShellConfig.lang, _gameShellConfig.country);
		}
		
		public function loadTranslation():void {
			//TODO rewrite translation manager to include preloader translation/game translation allowing for multiple files
			_td = new TranslationData ();
			_TM = TranslationManager.instance;
			_TM.addEventListener(Event.COMPLETE, onTranslationLoaded, false, 0, true);
			_TM.init(_gameShellConfig.lang, _gameShellConfig.gameID,TYPE_ID,_td);
		}
		
		public function setupPreloader():void{
			_MM.init (_docClass, _td);
			_MM.createScreen(PRELOADER_SCREEN, PreloaderScreen);
			_MM.getScreen(PRELOADER_SCREEN).addEventListener(StateEvent.COMPLETE, onPreloaderSetup, false, 0, true);
			_MM.getScreen(PRELOADER_SCREEN).addEventListener(StateEvent.ERROR, onPreloaderError, false, 0, true);
			_MM.getScreen(PRELOADER_SCREEN).init();
		}
		
		
		public function loadGame ():void {
			var path:String = _gameShellConfig.gameURL;
			//var ld:Loader
		}
		
		public function setUpGame ():void {
			addGameListeners();
			//
			_docClass.initGame();
		}	
		
		
		public function configGame ():void {
		
		
		}
		
		//CLEAN UP
		public function cleanUp():void  {
			//game listeners
			removeListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.PROGRESS_LOADING, showLoadingProgress);
			removeListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.DONE_LOADING, doneLoadingGame);
			removeListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.GAME_ENDED, gameHasEnded);
			removeListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.GAME_STARTED, gameHasStarted);
			removeListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.LEVEL_PASSED, passedLevel);
			//connection manager
			_CM = null;
			//_SM.cleanUp();
			_SM = null;
			_logger = null;
			//
			_docClass = null;
		}
		
		//UTILS
		public static function addListener (target:EventDispatcher, event:String, handler:Function):void {
			if (!target.hasEventListener(event)){
				target.addEventListener(event, handler, false, 0, true);
			}
		}
		public static function removeListener (target:EventDispatcher, event:String, handler:Function):void {
			if (target.hasEventListener(event)){
				target.removeEventListener(event, handler);
			}
		}

		
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function addGameListeners ():void {
			//game loading listeners
			addListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.PROGRESS_LOADING, showLoadingProgress);
			addListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.DONE_LOADING, doneLoadingGame);
			addListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.GAME_STARTED, gameHasStarted);
			addListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.GAME_ENDED, gameHasEnded);
			addListener(_docClass.game as EventDispatcher, NP10_GamingSystemEvent.LEVEL_PASSED, passedLevel);
		}
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		private function onPreloaderSetup(e:StateEvent):void {
			nextState();
		}
		
		private function onPreloaderError(e:StateEvent):void {
			_logger.debug ("Error setting up preloader: ", e.errorMsg, [this]);
			nextState();
		}
		
		
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		private function getConfigSuccess (msg:Object):void {
			_logger.debug("Call to getShellConfig success - configuring shell", [this]);
			_gameShellConfig = msg.result;
			_gameShellConfig.init();
			nextState();
		}
		
		
		private function getConfigFail (msg:Object):void {
			_logger.debug("Call to getShellConfig failed - using default values - configuring shell", [this]);
			_gameShellConfig.init();
			nextState();
		}
		
		private function onTranslationLoaded (e:Event):void {
			nextState();
		}
		
		//GAME LISTENERS
		private function showLoadingProgress (e:NP10_GamingSystemEvent):void {
			_logger.info("Loading game: "+e.bytesLoaded+" bytes loaded", [this]);
		}
		private function doneLoadingGame (e:NP10_GamingSystemEvent):void {
			removeListener(_docClass.game as EventDispatcher,NP10_GamingSystemEvent.PROGRESS_LOADING, showLoadingProgress);
			removeListener(_docClass.game as EventDispatcher,NP10_GamingSystemEvent.DONE_LOADING, doneLoadingGame);
			_logger.info("Game Loaded", [this]);
		}
		private function gameHasStarted (e:NP10_GamingSystemEvent):void {
			_logger.info("Game Started ", [this]);
		}
		private function gameHasEnded (e:NP10_GamingSystemEvent):void {
			_logger.info("Game Ended with score:"+e.score.show(), [this]);
		}
		private function passedLevel (e:NP10_GamingSystemEvent):void {
			_logger.info("Level Passed :"+e.levelNo, [this]);
		}
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------\
	
		
		public function get logger ():Logger {
			return _logger;
		}
		
		public function get gameShellConfig ():GameShellConfigVO{
			return _gameShellConfig;
		}
		
		public function set gameShellConfig (value:GameShellConfigVO):void {
			_gameShellConfig = value;
		}	
	}
}

internal class SingletonEnforcer {};