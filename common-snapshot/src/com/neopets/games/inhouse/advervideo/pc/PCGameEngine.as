/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc {
	
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.console.Console;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.projects.np9.system.NP9_Evar;
	
	import com.neopets.games.inhouse.advervideo.pc.gui.*;
	import com.neopets.games.inhouse.advervideo.game.Game;
	import com.neopets.games.inhouse.advervideo.game.SimpleXML;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;
	import com.neopets.games.inhouse.advervideo.GameDocument;
	import virtualworlds.lang.TranslationData;
	
	import flash.display.*;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 *  @NOTE: The GameEngine is going to do it own process first, then once it is done, it will trigger
	 *  this class through the initChild() Function.
	 * 
	 *	@NOTE: This extends GameEngine so you have access to most of the GameEngine Functions.
	 *  	>The GameEngine has the SoundManager
	 * 		>The GameEngine has the Loader with has loaded all the external Files
	 * 		>The GameEngine is the way you communicate to the NP9 GameEngine
	 * 
	 * 	@NOTE: This object extends EventDispatcher not a DisplayObject.
	 * 		>So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 *		>A dedicated container is created for the game object accessible thru PCGameEngine.instance.gameScreen; This container however, does not extend ViewContainer class, but just the simple Sprite class
	 *
	 *	@NOTE: This subclass provides additional support for many features required for sponsored projects such as
	 *		>Additional menu buttons - view trailer, about, visit website etc
	 *		>Added checking for cases to stop compiler from complaining if certain objects are not required and not present.
	 *		>Provides wrapping functions for GameEngine functions - ie. Sound, translation, gamingsystem calls are essentially still using standard neopet library functions, they are just routed thru this class
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  5 Sept 2009
	 */	
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class PCGameEngine extends GameEngine {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private const VERSION:String = "1.4";
		
		private const NC_WWW_ID:uint = 16451;		// the neocontent id for client website (click tracker) ; Destination clickback id: 15858
		
		private const ABOUT_BTN:String = "aboutButton";
		private const VIEWTRAILER_BTN:String = "viewTrailerButton";
		private const VISITWEBSITE_BTN:String = "visitWebsiteButton";
		private const GAME_TITLE_MC:String = "mcTransLogo";
		
		private const MENU_PLAY_GAME_VAR:String = "FGS_MAIN_MENU_START_GAME";
		private const MENU_VIEW_INSTRUCTIONS_VAR:String = "FGS_MAIN_MENU_VIEW_INSTRUCTIONS";
		private const MENU_ABOUT_VAR:String = "FGS_MAIN_MENU_ABOUT";
		private const MENU_VIEW_TRAILER_VAR:String = "FGS_MAIN_MENU_VIEW_TRAILER";
		private const MENU_VISIT_WEBSITE_VAR:String = "FGS_MAIN_MENU_VISIT_WEBSITE";
		private const MENU_GO_BACK_VAR:String = "FGS_OTHER_MENU_GO_BACK";
		private const MENU_END_GAME_VAR:String = "FGS_GAME_MENU_END_GAME";
		private const MENU_COPYRIGHT_VAR:String = "IDS_COPYRIGHT_TXT";
		private const MENU_TITLE_NAME_VAR:String = "IDS_TITLE_NAME";
		private const MENU_RESTART_GAME_VAR:String = "FGS_GAME_OVER_MENU_RESTART_GAME";
		private const MENU_SEND_SCORE_VAR:String = "FGS_GAME_OVER_MENU_SEND_SCORE";
		private const MENU_HIBAND_VAR:String = "IDS_TRAILER_HIBAND_TXT";
		private const MENU_LOBAND_VAR:String = "IDS_TRAILER_LOBAND_TXT";
		
		private const MENU_INTRO:int = 0;
		private const MENU_INSTRUCTIONS:int = 1;
		private const MENU_ABOUT:int = 2;
		private const MENU_VIEWTRAILER:int = 3;
		private const MENU_GAME:int = 4;
		private const MENU_GAMEOVER:int = 5;
		
		public static const MENU_ABOUT_SCR:String = "mAboutScreen";
		public static const MENU_VIEWTRAILER_SCR:String = "mViewTrailerScreen";
		
		public static const NEOCONTENT_URL_NOREDIRECT:String = "http://www.neopets.com/process_click.phtml?noredirect=1&item_id=";
		public static const NEOCONTENT_URL:String = "http://www.neopets.com/process_click.phtml?item_id=";
		
		public static const IMAGES_TEST_SERVER:String = "http://images50.neopets.com/";
		public static const IMAGES_LIVE_SERVER:String = "http://images.neopets.com/";
		
		public static const ON_LOCAL:int = 0;
		public static const ON_DEV:int = 1;
		public static const ON_WEBDEV:int = 2;
		public static const ON_LIVE:int = 3;

		public static const MOUSECLICK_SOUNDCLASSNAME:String = "MouseClick";
		public static const BGM_LIST:Array = []; // this bgm should not play during the game
		public static const GAME_BGM_LIST:Array = []; // this bgm should play during the game
		
		public static const VIDEO_PLAYER_NAME:String = "neopetsPlayer";
		public static const VIDEO_WIDTH:int = 500;
		public static const VIDEO_HEIGHT:int = 375;
		public static const PLAYER_LOADER_SWF:String = "http://media.mtvnservices.com/player/loader/";
		public static const CONFIG_URL:String = "http://media.mtvnservices.com/player/config.jhtml";
		//public static const VIDEO_ID:String = "mgid:cms:item:nick.com:692268"; //player needs content to load up when its created.
		public static const VIDEO_ID:String = "mgid:cms:item:nick.com:692941"; //player needs content to load up when its created.
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mQuitBtn:NeopetsButton;
		protected var mSendScoreBtn:NeopetsButton;
		
		private var mAboutScreen:*;
		private var mViewTrailerScreen:*;
		
		private var _game:Game;
		private static var _instance:PCGameEngine;
		private static var _stage:Object;
		private var _gameXML:SimpleXML;
		
		private var _evar:Array;
		
		private var _bgm_status:Boolean;
		private var _sfx_status:Boolean;
		
		private var _menulist:Array;
				
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var NO_SOUND:Boolean = true; // placed here specially to remove all sounds for g1270
		
		public var console:Console;
						
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PCGameEngine():void {
			super();
			if (_instance) {
				throw new Error("[PCGameEngine] Another instance is still running, please use PCGameEngine.instance.");
			} else {
				_instance = this;
				_evar = [];
				_menulist = [];
				console = new Console("GAME" + GameDocument.GAME_ID.toString());
				_bgm_status = true;
				_sfx_status = true;
			}
			trace("\n[PCGameEngine] v" + VERSION + " started\n");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		* @Note: Returns the singleton instance for this object
		* @return		PCGameEngine			myself
		*/  
		public static function get instance():PCGameEngine {
			return _instance;
		}
		
		/**
		* @Note: Returns the singleton instance for this object
		* @return		Game			the game object
		*/  
		public function get game():Game {
			return _game;
		}
		
		/**
		* @Note: Returns the display container for placing all game elements
		* @return		GamePlayScreen			The game displaycontainer to be used. (classes.pc.gui.GamePlayScreen)
		*/  
		public function get gameScreen():GamePlayScreen {
			return mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR);
		}
		
		/**
		* @Note: Sets the encrypted value of the score
		* @param		p_val		Number			The score value to be set to
		*/  
		public function set score(p_val:Number):void {
			ScoreManager.instance.changeScoreTo(p_val);
		}
		
		/**
		* @Note: Returns the saved encrypted value of the score
		* @return		Number			The score value returned
		*/  
		public function get score():Number {
			return ScoreManager.instance.getValue();
		}
		
		/**
		* @Note: Returns the Stage/_root of the game
		*/  
		public static function get STAGE():Object {
			return _stage;
		}
		
		/**
		* @Note: True if the game is offline (ie, not on any server, but on local hdd)
		* @return		Number			The score value returned
		*/  
		public static function get isOffline():Boolean {
			return GameDocument.instance.bOffline;
		}
		
		/**
		* @Note: The current url of the game
		*/  
		public static function get MYURL():String {
			return MenuManager.instance.menusDisplayObj.loaderInfo.loaderURL;
		}

		/**
		* @Note: True if the game is on live server
		*/  
		public static function get isOnLive():Boolean {
			var sVars:Array = MYURL.split("/");
			for (var i:int = 0; i < sVars.length; i ++) {
				switch (sVars[i]) {
					case "images.neopets.com": return true;
					case "www.neopets.com": return true;
				}
			}
			return false;
		}
		
		/**
		* @Note: Returns the current server you are on
		*/  
		public static function get onlineStatus():int {
			var sVars:Array = MYURL.split("/");
			for (var i:int = 0; i < sVars.length; i ++) {
				switch (sVars[i]) {
					case "images.neopets.com":
					case "www.neopets.com": return ON_LIVE;
					case "webdev.neopets.com": return ON_WEBDEV;
					case "dev.neopets.com": return ON_DEV;
				}
			}
			return ON_LOCAL;			
		}
		
		/**
		* @Note: Returns the appropriate swf server domain based on offline/live status
		*/  
		public static function get SWF_SERVER():String {
			if (!isOffline) {
				if (isOnLive) {
					return IMAGES_LIVE_SERVER;
				} else {
					return IMAGES_TEST_SERVER;
				}
			}
			return "./";
		}
		
		public static function get TRANSLATION_SERVER():String {			
			if (!isOffline) {
				if (isOnLive) {
					return "http://www.neopets.com/";
				} else {
					return "http://webdev.neopets.com/";
				}
			}
			return "http://www.neopets.com/";
		}

		/**
		* @Note: Returns the status of BGM playback. True if it's playing
		*/  
		public function get BGM_STATUS():Boolean {
			return _bgm_status;
		}
		
		/**
		* @Note: Returns the status of SFX playback. True if it's playing
		*/  
		public function get SFX_STATUS():Boolean {
			return _sfx_status;
		}
		
		/**
		* @Note: Returns the current language used for the game
		*/  
		public function get LANG():String {
			return mGamingSystem.getFlashParam("sLang").toUpperCase();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public override function init( pShellRoot : MovieClip, pLocalPathway : String, pTranslationData : TranslationData = null ):void {			
			super.init(pShellRoot, pLocalPathway, pTranslationData);
			getStage(pShellRoot);
		}
		
		
		/**
		 * @Note: Opens a URL in a new browser window
		 * @param		p_url			String		URL to open
		 * @param		p_window	String		The window name to open in. default opens in a new window
		 */
		public static function openLink(p_url:String, p_window:String = "_blank"):void {
			var req:URLRequest = new URLRequest(p_url);
			try {
				navigateToURL(req, p_window);
			} catch (e:Error) {
			}
		}
		
		/**
		 * @Note: Opens a URL using Neocontent id
		 * @param		p_id			uint		The neocontent id of the link to open
		 */
		public static function openNCLink(p_id:uint):void {
			if (p_id > 0) openLink(NEOCONTENT_URL + p_id.toString());
		}
		
		/**
		 * @Note: Sends a "ping" to the Neocontent item
		 * @param		p_id			uint		The id of the neocontent item
		 */
		public static function sendNCTracker(p_id:uint):void {
			if (!isNaN(p_id)) {
				var req:URLRequest = new URLRequest(NEOCONTENT_URL_NOREDIRECT + p_id.toString());
				var lv:URLLoader = new URLLoader();
				lv.addEventListener(Event.COMPLETE, ontriggerNeoContentTrackerComplete, false, 0, true);
				try {
					lv.load(req);
				} catch (e:Error) {}
			}
		}
		
		/**
		 * @Note: Forces the game to end and go to game over screen
		 */
		public function forceQuitGame():void {
			quitGame();
			mMenuManager.menuNavigation(MenuManager.MENU_GAMEOVER_SCR); 
		}
		
		/**
		 * @Note: Forces the game to go send score
		 */
		public function goSendScore():void {
			quitGame();
			mMenuManager.menuNavigation(MenuManager.MENU_GAMEOVER_SCR); // changed to game over screen
			var tGameOverScreen:GameoverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as GameoverScreen;
			tGameOverScreen.toggleInterfaceButtons(false);
			tGameOverScreen.simulateSendScoreButtonClick();
		}
		
		/**
		 * Forces the system to send score and return to intro immediately. Black score meter box will not be shown
		 */
		public function forceSendScoreAndBackToIntro():void {
			mGamingSystem.sendScore(ScoreManager.instance.getValue());
			goIntro();
		}
		
		/**
		 * @Note: Forces the game to go to the intro screen
		 */
		public function goIntro():void {
			quitGame();
			mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR); // switch to intro screen
		}
		
		/**
		 * @Note: Sends a game start tag to gaming system
		 *		>Currently, GameEngine automatically sends a start tag when Play Game button is clicked. So there really isn't a need to run this.
		 */
		public function sendStartGameTag():void {
 			mGamingSystem.sendTag(mRootMC.START_GAME_MSG);
		}
		
		/**
		 * @Note: Sends a game end tag to gaming system
		 */
		public function sendEndGameTag():void {
 			mGamingSystem.sendTag(mRootMC.END_GAME_MSG);
		}
		
		/**
		 * @Note: Saves a value using NP9_Evar
		 * @param		p_id		String		The identifier for the value
		 * @param		p_val		Number		Value to be saved
		 */
		public function setEvar(p_id:String, p_val:Number = 0):void {
			if (p_id != "") {
				if (!_evar[p_id]) _evar[p_id] = new NP9_Evar(0);
				_evar[p_id].changeTo(p_val);
			}
		}
		
		/**
		 * @Note: Retrieves a saved NP9_Evar value; return 0 if nothing found
		 * @param		p_id		String		The identifier for the value
		 * @return		Number					Value saved
		 */
		public function getEvar(p_id:String):Number {
			if ((p_id != "") && (_evar[p_id])) return _evar[p_id].show();
			return 0;
		}
		
		/**
		 * @Note: Retrieves external flashvars parameters
		 * @param		p_paramname		String		The name of the flashvar
		 * @return		String									Value of the flashvar
		 */
		public function getExtParam(p_paramname:String):String {
			var res:String = "";
			try {
				res = mGamingSystem.getFlashParam(p_paramname);
			} catch (e:Error) {
				try {
					res = this.loaderInfo.parameters[p_paramname];
				} catch (e:Error) {
					res = "";
				}
			}
			return res;
		}
		
		/**
		 * @Note: Sets focus on Stage object
		*/
		public function setFocusOnStage():void {
			if (_stage) _stage.stage.focus = _stage;
		}
		
		/**
		 * @Note: Plays a sound using SoundManager
		 * @param		p_sndname		String		The classname of the sound
		 * @param		p_loop				Boolean		To loop this sound infinitely
		 * @param		p_start				uint			Starting point of the sound
		 * @param		p_loop				p_loops		How many times to play this sound
		 * @param		p_loop				p_vol			Volume of this sound (range from 0 - 1)
		 */
		public function playSound(p_sndname:String, p_loop:Boolean = false, p_start:uint = 0, p_loops:int = 0, p_vol:Number = 1):void {
			if (NO_SOUND) return;
			var bgm:Boolean = isBGM(p_sndname);
			if ((bgm) && (_bgm_status)) {
				mSoundManager.soundPlay(p_sndname, p_loop, p_start, p_loops, p_vol);
			} else if ((!bgm) && (_sfx_status)) {
				mSoundManager.soundPlay(p_sndname, p_loop, p_start, p_loops, p_vol);
			}
		}
		
		public function stopSound(p_sndname:String):void {
			if (p_sndname != "") mSoundManager.stopSound(p_sndname);
		}
		
		public function soundBtnToggle():Boolean {
			trace("soundBtnToggle");
			toggleSound();
			toggleMusic();
			playSound(MOUSECLICK_SOUNDCLASSNAME);
			return !mSoundManager.soundOverRide;
		}
		
		public function toggleSFX():Boolean {
			trace("toggleSFX");
			toggleSoundEffects();
			playSound(MOUSECLICK_SOUNDCLASSNAME);
			//return !mSoundManager.soundOverRide;
			return SFX_STATUS;
		}
		
		public function toggleBGM():Boolean {
			toggleMusic();
			playSound(MOUSECLICK_SOUNDCLASSNAME);
			return BGM_STATUS;
		}
		
		/**
		 * @Note: Starts the Game with a custom map
		 * @param		p_custom		String		The string data for the map
		 * @param		p_name			String		The name of the map
		 */
		 public function startCustomGame(p_custom:String = "", p_name:String = ""):void {
			 if ((p_custom != "") && (p_name != "")) {
			 	trace("\n[PCGameEngine] START GAME!!!")
			 	mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
				//_game = new Game(p_custom, p_name);
				_game = new Game();
				gameScreen.game_layer = _game;
			 } else {
				 startGame();
			 }
		 }

		 public static function callJS(p_func:String, ... args):void {
			if (ExternalInterface.available) {
				instance.console.echo("Sending ExternalInterface: " + p_func + " args: " + args) ;
				try {
					ExternalInterface.call(p_func, args);
				} catch (e:Error) {
					instance.console.echo("ExternalInterface Error: " + e.message);
				}
			} else {
				instance.console.echo("ExternalInterface not available");
			}
		}
		
		public static function loadImageTracker(p_url:String):void {
			var tmploader:Loader = new Loader();
			var tmprequest:URLRequest = new URLRequest(p_url);
			tmploader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaderComplete);
			tmploader.load(tmprequest);
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public static function onPlaylistComplete(evt:Event):void {
			instance.game.videoFinished();
			instance.gameScreen.showWheel();
			instance.gameScreen.setMessageByTranslationId("IDS_VIDEO_DONE_PLAYING");
		}
		
		protected function onGameXMLLoaded(evt:Event):void {
			 _gameXML.removeEventListener(SimpleXML.XML_LOADED, onGameXMLLoaded);
			 
			var welcomeStr:String = "hmm";
			mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).hideButtons();
			if (_gameXML.xmlObj.attribute('success') == 0) {
				mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).setMessage(unescape(_gameXML.xmlObj.attribute('text')).replace(/\+/g, " "));
			} else {
				if (_gameXML.xmlObj.descendants("currentPlaysPerDay") < _gameXML.xmlObj.descendants("maxPlaysPerDay")) {
					mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).setPlayMessage(int(_gameXML.xmlObj.descendants("currentPlaysPerDay")), int(_gameXML.xmlObj.descendants("maxPlaysPerDay")));
				} else {
					mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).setPlayMessage(int(_gameXML.xmlObj.descendants("currentPlaysPerDay")), int(_gameXML.xmlObj.descendants("maxPlaysPerDay")), false);
				}
			}
		  }
		  
		  protected function onSpinComplete(e:Event):void {
			  trace("SPIN DONE");
			// finds the url we need to load that awards the user their points
			var loadUrl:String = _gameXML.xmlObj.contentManagementSystem.contents.content.urls.url.(@title == "process_video_reward").text();
			if (loadUrl) {
				var loader:URLLoader = new URLLoader();
				loader.load(new URLRequest(loadUrl));
			}
			gameScreen.finishSpin();
		  }
		  
		/**
		 * @Note: For Neocontent tracker sending response.
		 */
		private static function ontriggerNeoContentTrackerComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, ontriggerNeoContentTrackerComplete);
		}
		
		private static function imageLoaderComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoaderComplete);
			instance.console.echo("Pixel tracker loaded");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Obtains the Stage object
		*/
		private function getStage(p_do:DisplayObject = null):void {
			if (!_stage) {
				if (p_do) {
					_stage = p_do;
				} else {
					_stage = mMenuManager.menusDisplayObj;
				}
				if (_stage.stage) {
					while (_stage.stage.root != _stage) _stage = _stage.stage.root;
				}
				//KeyPoll.instance.init(_stage as DisplayObject);
			}
		}
		
		/**
		 * @Note: This is called by GameEngine once:
		 * 		>All soundFiles are loaded, 
		 * 		>Congfig file is ready,
		 * 		>All external assets are loaded and can be in this ApplicationDomain (Depends on the Config.xml)
		 * @Note: This is the start of your Games Setup
		 */
		  protected override function initChild():void {
			  trace("\n[PCGameEngine] Initiated");
			  startGameSetup();
		  }
		  
		  /**
		 * @Note: This is going to pull objects out of the externalLibrary
		 * 		> Since the ExternalAssets are loaded into the Parent Application Domain, 
		 * 		> you can just access an item in the library.
		 */
		  protected override function startGameSetup():void {
			  trace("[PCGameEngine] Setting up");
			  gameSetupDone();  
		  }
		  
		  /**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  *		> ReOrders the ViewContainers
		  * 	> Adds the GameDemo View Container to the GameEngines ViewContainer
		  * 	> Tells the GameEngine it is ready
		  * */
		  protected function gameSetupDone():void {
			// grab the gameXML url from the flash vars
			trace("[PCGameEngine] Setup Done");
			completedSetup();  
		  }
		  
		  protected function loadGameData():void {
			  // grab the gameXML url from the flash vars
			var gameXMLURL:String; //mGamingSystem.getFlashParam('gameXMLScriptURL_str');
			var fVars:LoaderInfo = LoaderInfo( _stage.loaderInfo );
			trace("GameStr"+fVars.parameters.gameXMLScriptURL_str );
			if (fVars.parameters.gameXMLScriptURL_str != null && fVars.parameters.gameXMLScriptURL_str != 'undefined') {
				gameXMLURL = fVars.parameters.gameXMLScriptURL_str;
			} else {
				gameXMLURL = "http://www.neopets.com/games/videofeed/process_video_nofeed.phtml?id=";
				//gameXMLURL = "http://localhost/game_test.xml";
			}
			gameXMLURL += "692268&flashRand=" + Math.floor(Math.random() * 100000000000);// jsut needs some kind of number tacked on so it will grant neopoints
			// load the xml object
			trace(gameXMLURL);
			_gameXML = new SimpleXML(gameXMLURL);
			_gameXML.addEventListener(SimpleXML.XML_LOADED, onGameXMLLoaded, false, 0, true);
		  }
		  
		 //--------------------------------------
		//  OVERRIDE PROTECTED INSTANCE METHODS (FROM THE GAME ENGINE)
		//--------------------------------------
		
		 /**
		 * @Menu Navigation can trigger Events if Needed
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 */		  
		 protected override function onMenuNavigationEvent (evt:CustomEvent):void {
			// trace("event triggered - " + evt.oData.MENU);
		 	switch (evt.oData.MENU) {
				
				case MenuManager.MENU_INTRO_SCR: // the intro screen
					playMusic();
					getStage();
					//playSound("IntroBgm");
					score = 0; // automatically reset the score
					loadGameData();
					menuInFocus(MENU_INTRO);
					break;
					
				case MenuManager.MENU_INSTRUCT_SCR: // instructions screen
					menuInFocus(MENU_INSTRUCTIONS);
					break;
					
				case MENU_ABOUT_SCR:
					menuInFocus(MENU_ABOUT);
					break;
					
				case MENU_VIEWTRAILER_SCR:
					menuInFocus(MENU_VIEWTRAILER);
					break;
					
				case MenuManager.MENU_GAME_SCR: // game screen - game start tag is sent from  com.neopets.projects.gameEngine.gui.MenuManager.onInterfaceButtonPressed()
					stopMusic();
					menuInFocus(MENU_GAME);
					break;
					
		 		case MenuManager.MENU_GAMEOVER_SCR:	// game over screen
					playMusic();
					menuInFocus(MENU_GAMEOVER);
			 		break;
		 	}
			console.init(mMenuManager.menusDisplayObj);
			setFocusOnStage();
		 }
		 
		/**
		 * @Note: Handles Standard Translation for Menus
		 * 
		 * @Note: Overriding original function in GameEngine to provide fault tolerence and text translation
		 */
		protected override function setupMenus():void {

			var tIntroScreen:OpeningScreen = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:GameOverScreen = GameOverScreen(mMenuManager.createMenu("mcGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen:InstructionScreen = InstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR));	
			
			//Intro Screen
			if (tIntroScreen.startGameButton) {
				//mTranslationManager.setTextField(tIntroScreen.startGameButton.label_txt, NPTextData.menuText("FGS_MAIN_MENU_START_GAME"));
				tIntroScreen.startGameButton.setText(NPTextData.menuText(MENU_PLAY_GAME_VAR));
			}
			if (tIntroScreen.instructionsButton) {
				tIntroScreen.instructionsButton.setText(NPTextData.menuText(MENU_VIEW_INSTRUCTIONS_VAR));
			}
			if (tIntroScreen.txtFld_copyright) {
				mTranslationManager.setTextField(tIntroScreen.txtFld_copyright, NPTextData.getTranslationOf(MENU_COPYRIGHT_VAR));
			}
			if (tIntroScreen.txtFld_title) {
				mTranslationManager.setTextField(tIntroScreen.txtFld_title, NPTextData.getTranslationOf(MENU_TITLE_NAME_VAR));
			}
			
			//Instruction Screen
			if (tInstructionScreen.returnBtn) {
				tInstructionScreen.returnBtn.setText(NPTextData.menuText(MENU_GO_BACK_VAR));
			}
			if (tInstructionScreen[GAME_TITLE_MC]) {
				tInstructionScreen[GAME_TITLE_MC].gotoAndStop(LANG);
			}
			
			//In Game Screen
			if (tGameScreen.quitGameButton) {
				tGameScreen.quitGameButton.setText(NPTextData.menuText(MENU_END_GAME_VAR));
			}
			if (tGameScreen[GAME_TITLE_MC]) {
				tGameScreen[GAME_TITLE_MC].gotoAndStop(LANG);
			}
			
			//Game Over Screen
			if (tGameOverScreen.playAgainBtn) {
				tGameOverScreen.playAgainBtn.setText(NPTextData.menuText(MENU_RESTART_GAME_VAR));
			}
			if (tGameOverScreen.reportScoreBtn) {
				tGameOverScreen.reportScoreBtn.setText(NPTextData.menuText(MENU_SEND_SCORE_VAR));
			}
			if (tGameOverScreen.visitWebsiteButton) {
				tGameOverScreen.visitWebsiteButton.setText(NPTextData.menuText(MENU_VISIT_WEBSITE_VAR));
			}
			if (tGameOverScreen[GAME_TITLE_MC]) {
				tGameOverScreen[GAME_TITLE_MC].gotoAndStop(LANG);
			}
			
			extendMenus();
		}
		
		 /**
		 * @Additional functions and procedures to add to current menus (does not override current functions)
		 */		  
		 protected override function extendMenus():void {
			 // handle extra buttons often used by sponsored games
			 // Intro Screen
			var tIntroScreen:IntroScreen = mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR);
			if (tIntroScreen.aboutButton) {
				tIntroScreen.aboutButton.setText(NPTextData.menuText(MENU_ABOUT_VAR));
			}
			if (tIntroScreen.viewTrailerButton) {
				tIntroScreen.viewTrailerButton.setText(NPTextData.menuText(MENU_VIEW_TRAILER_VAR));
			}
			if (tIntroScreen.visitWebsiteButton) {
				tIntroScreen.visitWebsiteButton.setText(NPTextData.menuText(MENU_VISIT_WEBSITE_VAR));
			}
			
			// create possible menus screens used in sponsored games
			try {
				mAboutScreen = mMenuManager.createMenu("mcAboutScreen", MENU_ABOUT_SCR) as AboutScreen;
			} catch(e:Error) {}
		 	try {
				mViewTrailerScreen = mMenuManager.createMenu("mcViewTrailerScreen", MENU_VIEWTRAILER_SCR) as ViewTrailerScreen;
			} catch(e:Error) {}
			
 			if (mAboutScreen) {
				if (mAboutScreen.returnBtn) mAboutScreen.returnBtn.setText(NPTextData.menuText(MENU_GO_BACK_VAR));
				if (mAboutScreen[GAME_TITLE_MC]) mAboutScreen[GAME_TITLE_MC].gotoAndStop(LANG);
			}
			
			if (mViewTrailerScreen) {
				if (mViewTrailerScreen.returnBtn) mViewTrailerScreen.returnBtn.setText(NPTextData.menuText(MENU_GO_BACK_VAR));
				if (mViewTrailerScreen.hibandBtn) mViewTrailerScreen.hibandBtn.setText(NPTextData.menuText(MENU_HIBAND_VAR));
				if (mViewTrailerScreen.lobandBtn) mViewTrailerScreen.lobandBtn.setText(NPTextData.menuText(MENU_LOBAND_VAR));
				if (mViewTrailerScreen[GAME_TITLE_MC]) mViewTrailerScreen[GAME_TITLE_MC].gotoAndStop(LANG);
			}
			_menulist[MENU_INTRO] = mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR) as IntroScreen;
			_menulist[MENU_INSTRUCTIONS] = mMenuManager.getMenuScreen(MenuManager.MENU_INSTRUCT_SCR) as ViewInstructionsScreen;
			_menulist[MENU_ABOUT] = mMenuManager.getMenuScreen(MENU_ABOUT_SCR) as AboutScreen;
			_menulist[MENU_VIEWTRAILER] = mMenuManager.getMenuScreen(MENU_VIEWTRAILER_SCR) as ViewTrailerScreen;
			_menulist[MENU_GAME] = mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR) as GamePlayScreen;
			_menulist[MENU_GAMEOVER] = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as GameoverScreen;
		 }
		 
		 /**
		 * @Additional button functions. Specifically used for sponsored games
		 * @param		pBtnName		String 		The Name of the Menu button
		 */
		 protected override function extraMenuButtons(pBtnName:String):void {
			 switch (pBtnName) {
				 case ABOUT_BTN:
					aboutGame();
				 	break;
				 case VIEWTRAILER_BTN:
					viewTrailer();
				 	break;
				 case VISITWEBSITE_BTN:
					visitWebsite();
				 	break;
			}
			playSound(MOUSECLICK_SOUNDCLASSNAME);
		 }
		  
		  /**
		 * @NOTE: This to reset basic elements for a New Game
		 */
		 protected override  function restartGame():void {
		 	ScoreManager.instance.changeScoreTo(0);
		 	mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		 }
		
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 */
		 protected override function startGame():void {
		 	trace("\n[PCGameEngine] START GAME!!!");
			if (!_game) {
				_game = new Game();
				gameScreen.game_layer = _game;
				gameScreen.addChild(gameScreen.game_layer);
			}
		 	mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
			// grab all the wheel values
			var wheelVals = _gameXML.xmlObj.descendants("wheelValue");
			// add values to wheel on the game screen
			trace ('gamewheel' + gameScreen.wheel);
			for each(var wheelVal:String in wheelVals.text()) {
				gameScreen.wheel.addWheelValue(wheelVal);
			}

			// puts wheel back into position
			gameScreen.wheel.reset();
			gameScreen.wheel.addEventListener(Wheel.SPIN_COMPLETE, onSpinComplete, false, 0, true); 
		}
		
		  /**
		 * @Note: Quit for your Game from the In Game Screen; 
		 * @ Called from com.neopets.projects.gameEngine.common.GameEngine.onMenuButtonEvent();
		 */		 
		 protected override function quitGame():void {
		 	trace("\n[PCGameEngine] GAME END!!!")
			
			if (_game) {
				_game.destructor();
			//	_game = null;
			}
			sendEndGameTag();
		 }
		 
		  /**
		 * @Note: Calls the about section
		 */
		 protected function aboutGame():void {
			mMenuManager.menuNavigation(MENU_ABOUT_SCR);
		 }
		 
		  /**
		 * @Note: Calls the view trailer screen
		 */
		 protected function viewTrailer():void {
			mMenuManager.menuNavigation(MENU_VIEWTRAILER_SCR);
		 }
		 
		  /**
		 * @Note: Calls the visit website link
		 */
		 protected function visitWebsite():void {
			 openNCLink(NC_WWW_ID);
		 }
		 
		   /**
		 * @Note: Need to Turn off / On  the Background Track
		 */
		 protected override function toggleMusic():void {
			_bgm_status = !_bgm_status;
			if (BGM_LIST.length > 0) {
				for (var i:int = 0; i < BGM_LIST.length; i ++) {
			 		if (_bgm_status) {
				 		mSoundManager.soundPlay(BGM_LIST[i], true);
				 	} else {
				 		mSoundManager.stopSound(BGM_LIST[i]);
				 	}
				}
			}
		 }
		 
		 protected function toggleSoundEffects():void {
			 _sfx_status = !_sfx_status;
		 }
		 
		 protected function playMusic():void {
			 if (_bgm_status) {
				for (var i:int = 0; i < BGM_LIST.length; i ++) {
					if (!mSoundManager.checkSoundState(BGM_LIST[i])) mSoundManager.soundPlay(BGM_LIST[i], true);
				} 
			 }
		 }
		 
		 protected function stopMusic():void {
			for (var i:int = 0; i < BGM_LIST.length; i ++) {
				if (BGM_LIST[i] != "") mSoundManager.stopSound(BGM_LIST[i]);
			} 
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 */
		 protected override function toggleSound():void {
			//mSoundManager.soundOverRide = !mSoundManager.soundOverRide;
			//playMusic();
			toggleSoundEffects();
		 }
		 
		 /**
		 * @Note: Checks if a sound is in the bgm list
		 * @param		p_name		String	name to be checked
		 * @return		Boolean					True if this is a BGM
		 */
		 private function isBGM(p_name:String):Boolean {
			 var i:int = 0;
			 while (i < BGM_LIST.length) {
				 if (p_name == BGM_LIST[i]) return true;
				 i ++;
			 }
			 i = 0;
			 while (i < GAME_BGM_LIST.length) {
				 if (p_name == GAME_BGM_LIST[i]) return true;
				 i ++;
			 }
			 return false;
		 }
		 
		 /**
		 * @Note: Tells a menu that it's in focus
		 * @param		p_id		int		ID of the menu
		 */
		 private function menuInFocus(p_id:int):void {
			for (var m:int = 0; m < _menulist.length; m ++) {
				(m == p_id)? _menulist[m].inFocus(): _menulist[m].outFocus();
			}
		 }
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			console.destructor();
			for (var m:int = 0; m < _menulist.length; m ++) {
				_menulist[m] = null;
			}
			_menulist.length = 0;
			_menulist = null;
		}
	}
}