package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.getTimer;

	/**
	 * Game Loader Control class
	 * @author Ollie B.
	 * @since 01/02/08
	 */
	public class NP9_Loader_Control {
		private var objRoot:Object;
		private var objStage:Stage;
		
		private var bDEBUG_LOAD_LOCAL:Boolean;
		
		private static var _INIT:uint                = 1;
		private static var _LOAD_GS:uint             = 2;
		private static var _WAIT_FOR_GS:uint         = 3;
		private static var _LOAD_TRANS:uint          = 4;
		private static var _WAIT_FOR_TRANS:uint      = 5;
		private static var _LOADPRELOADER:uint       = 6;
		private static var _WAITFORPRELOADER:uint    = 7;
		private static var _LOADGAME:uint            = 8;
		private static var _WAITFORGAME:uint         = 9;
		private static var _STARTGAME:uint         	 = 10;
		private static var _DONE:uint                = 0;
		
		private var uiLoadState:uint;
		
		// REALLY NEEDED ???
		private var bLoadInProgress:Boolean;
		private var bOffline:Boolean;
		private var _NP9_bGameLoaded:Boolean;
		// REALLY NEEDED ???
		
		private var bTRACE:Boolean;
		private var objTracer:NP9_Tracer;
		
		private var _NP9_GAME_DATA:NP9_Game_Data;
		
		private var aParams:Array;
		
		// loader objects and flags
		private var objLoaderGS:Loader;
		private var bGSLoaded:Boolean;
		private var mcGS:MovieClip;
		
		private var objLoaderPre:Loader;
		private var bPreloaderLoaded:Boolean;
		private var mcPreloader:Object;
		private var aPreloaderText:Object;
		
		private var objLoaderGame:Loader;
		private var bGameLoaded:Boolean;
		private var mcGame:Object;
		private var nStartGameLoad:Number;
		
		// !for development only!
		private var sLocalPath:String;
		private var mLoaderVersion:String = "v9";
		
		/**
		 * @Constructor
		 * Passes in all default parameters for a Neopets Game
		 * @param	p_objRoot	This is the stage of the swf
		 */
		public function NP9_Loader_Control( p_objRoot:Object ) {
			
			// overwritten with BIOS setting
			bTRACE = true;
			
			// tracer object
			
			
			objTracer = new NP9_Tracer( this, bTRACE );
			objTracer.out( "Instance NP9_LoaderControl GameEngine is Created>!" + mLoaderVersion, true );
			objTracer.out( "Instance created!", true );
			
			objRoot = p_objRoot;
			objStage = objRoot.stage;
			
			// if set to true, all content is loaded from local bin folder
			bDEBUG_LOAD_LOCAL =  false;
			
			uiLoadState     = _INIT;
			bLoadInProgress = true;
			
			bOffline = false;
			
			_NP9_bGameLoaded = false;
			
			bGSLoaded = false;
			bPreloaderLoaded = false;
			bGameLoaded = false;

			aPreloaderText = new Object();
			nStartGameLoad = 0;
			
			_NP9_GAME_DATA = new NP9_Game_Data();
			
			// DEBUG
			//_NP9_GAME_DATA.sImageHost = "http://images50.neopets.com";
			//_NP9_GAME_DATA.sBaseURL   = "dev.neopets.com";
			
			sLocalPath = "G:\\Multimedia\\projects\\internal\\com\\neopets\\applications\\large_applications\\multimedia_gaming_system\\mgs1\\FLASH9";
			
			aParams = new Array();
			// ---------------------------------------------------------------------------
			// List of parameters passed into the Loader
			// aVars[ _NP8_GAME_DATA varname, passed var name ]
			// ---------------------------------------------------------------------------
			aParams.push( ["sFilename",       "g" ]             ); // game filename
			aParams.push( ["sPreloader",      "p" ]             ); // preloader filename
			aParams.push( ["sQuality",        "q" ]             ); // flash movie quality
			aParams.push( ["iFramerate",      "f" ]             ); // game framerate
			aParams.push( ["iVersion",        "v" ]             ); // game version
			aParams.push( ["iGameID",         "id" ]            ); // game id
			aParams.push( ["iNPRatio",        "n" ]             ); // neopoint ratio
			aParams.push( ["iNPCap",          "c" ]             ); // neopoint cap
			aParams.push( ["sUsername",       "username" ]      ); // neopets username
			aParams.push( ["sName",           "name" ]          ); // user's name
			aParams.push( ["iAge13",          "age" ]           ); // user age >= 13 flag
			aParams.push( ["iNsm",            "nsm" ]           ); // neostatus multiple
			aParams.push( ["iNsid",           "nsid" ]          ); // neostatus id
			aParams.push( ["sNcReferer",      "nc_referer" ]    ); // referring sponsor
			aParams.push( ["sLang",           "lang" ]          ); // language
			aParams.push( ["sHash",           "sh" ]            ); // session hash (for encryption)
			aParams.push( ["sSK",             "sk" ]            ); // session key (for encryption)
			aParams.push( ["iCalibration",    "calibration" ]   ); // added cheat test value - not used
			aParams.push( ["sBaseURL",        "baseurl" ]       ); // game server origin
			aParams.push( ["iTypeID",         "typeID" ]        ); // game type id
			aParams.push( ["iItemID",         "itemID" ]        ); // item id
			aParams.push( ["iScorePosts",     "sp" ]            ); // max score posts
			aParams.push( ["iVerifiedAct",    "va" ]            ); // account verified flag
			aParams.push( ["iHiscore",        "hiscore" ]       ); // user's highest score
			aParams.push( ["sDestination",    "destination" ]   ); // destination in case of login thru scoring meter
			aParams.push( ["iChallenge",      "chall" ]         ); // challenge active flag
			aParams.push( ["sPSurl",          "psurl" ]         ); // alternate POST SCORE URL
			aParams.push( ["iTracking",       "t" ]             ); // tracking flag
			aParams.push( ["iMultiple",       "multiple" ]      ); // tracking multiple
			aParams.push( ["iIsMember",       "member" ]        ); // neopets member flag
			aParams.push( ["iIsAdmin",        "isAdmin" ]       ); // admin account flag
			aParams.push( ["iIsSponsor",      "isSponsor" ]     ); // sponsor account flag
			aParams.push( ["iPlaysAllowed",   "ms" ]            ); // remaining plays for user
			aParams.push( ["iDailyChallenge", "dc" ]            ); // daily challenge flag
			aParams.push( ["iDictVersion",    "dict_ver" ]      ); // currect dictionary version
			aParams.push( ["sImageHost",      "image_host" ]    ); // image host
			aParams.push( ["sIncludeMovie",   "include_movie" ] ); // current include movie version
			aParams.push( ["iIE",          "internetexplorer" ] ); // IE?
			aParams.push( ["iChallengeCard",  "ccard" ]         ); // challenge card (scoring meter) flag
			aParams.push( ["iGameWidth",      "gamew" ]         ); // game width
			aParams.push( ["iGameHeight",     "gameh" ]         ); // game height
			aParams.push( ["sSpLogoURL",      "sp_logo_url" ]   ); // sponsored preloader client logo
			aParams.push( ["iSpTrackID",      "sp_track_id" ]   ); // sponsored preloader tracking id
			aParams.push( ["sSpAdURL",        "sp_ad_url" ]     ); // sponsored preloader ad tracking url
			aParams.push( ["sSpClickUrl",     "sp_logo_click_url" ]  ); // sponsored preloader click url
			aParams.push( ["iSpLogoTrackID",   "sp_logo_track_id" ]   ); // sponsored preloader click tracking id
			aParams.push( ["iDdNcChallenge",	"ddNcChallenge"] ); // used for testing prize awards on dev
			aParams.push( ["iUseCustomMsg",		"useCustomMsg"] ); // are we using a custom message on the send score screen?
			aParams.push( ["iForceScore",		"forceScore"] ); // used for testing prize awards on dev
		}

		/**
		 * Called if the game is launched offline
		 * @param	p_sEnvironment		if offline, this input should be "OFFLINE"
		 */
		public function setEnvironment( p_sEnvironment:String ):void {
			
			if ( p_sEnvironment.toUpperCase() == "OFFLINE" ) {
				objTracer.out( "Offline Mode Detected!", true );
				bOffline = true;
			}
		}

		/**
		 * Called if the game is launched offline, and transfers all parameters in NP9_BIOS to NP9_Game_Data
		 * @param	p_objBIOS		The NP9_BIOS object in the swf
		 * @see NP9_BIOS
		 * @see NP9_Game_Data
		 */
		public function setOfflineBiosParams( p_objBIOS:Object ):void {
			
			trace ("setOfflineBiosParams > ", p_objBIOS);
			
			_NP9_GAME_DATA.bOffline = true;
			
			_NP9_GAME_DATA.iGameID    = p_objBIOS.game_id;
			_NP9_GAME_DATA.sLang      = p_objBIOS.game_lang;
			_NP9_GAME_DATA.sImageHost = "http://" + p_objBIOS.game_server;
			_NP9_GAME_DATA.sBaseURL   = p_objBIOS.script_server;
			
			var tW:int = p_objBIOS.width != 0 ? p_objBIOS.width : p_objBIOS.iBIOSWidth;
			var tH:int =  p_objBIOS.height != 0 ?  p_objBIOS.height :  p_objBIOS.iBIOSHeight;
			
			_NP9_GAME_DATA.iBIOSWidth  = tW;
			_NP9_GAME_DATA.iBIOSHeight = tH;
			
			/** 
			 * //HAVING ISSUES WITH MCBIOS WHEN ITS NOT STARTING ON THE STAGE
			_NP9_GAME_DATA.iGameWidth  = p_objBIOS.width;
			_NP9_GAME_DATA.iGameHeight = p_objBIOS.height;
			**/
			trace ("BIOS W:"+tW, "BIOS H"+tH);
			setBiosParams( p_objBIOS );

			bTRACE = p_objBIOS.debug;
			
			objTracer.setDebug( bTRACE );
		}
		
		/**
		 * Main function which is polled each enterframe to track current stage of initialization.
		 * @return	True if the game is still loading
		 * @see com.neopets.projects.np9.gameEngine.NP9_DocumentExtension#main()
		 */
		public function main():Boolean {
			//trace ("uiLoadState: "+uiLoadState);
			switch ( uiLoadState ) {
				
				case _INIT:
					initGameData();
					// set preloader framerate
					setLoaderFramerate(18);
					uiLoadState = _LOAD_GS;
					break;
					
				case _LOAD_GS:
					loadGamingSystem();
					uiLoadState = _WAIT_FOR_GS;
					break;
					
				case _WAIT_FOR_GS:
					// Gaming System loaded?
					if ( bGSLoaded )  {
						setGamingSystem();
						uiLoadState = _LOAD_TRANS;
					}
					break;
					
				case _LOAD_TRANS:
					// load translated text
					mcGS.callTranslation();
					uiLoadState = _WAIT_FOR_TRANS;
					break;
					
				case _WAIT_FOR_TRANS:
					if ( mcGS.translationComplete() ) {
						// offline?
						if ( bOffline ) {
							objRoot.setGamingSystem( mcGS );
							uiLoadState = _STARTGAME;
						} else {
							uiLoadState = _LOADPRELOADER;
						}
					}
					break;
					
				case _LOADPRELOADER:
					loadPreloader();
					uiLoadState = _WAITFORPRELOADER;
					break;
					
				case _WAITFORPRELOADER:
					if ( bPreloaderLoaded )  {
						setPreloader();
						setPreloaderText();
						// Preloader links
						//added by Viv - July09: should move this to preloader class, such as
						//mcPreloader.addTextLinkListener ()
						mcPreloader.addEventListener(TextEvent.LINK, TextLinkHandler, false, 0, true);
						//
						uiLoadState = _LOADGAME;
					}
					break;
					
				case _LOADGAME:
					loadGame();
					nStartGameLoad = getTimer();
					uiLoadState = _WAITFORGAME;
					break;
					
				case _WAITFORGAME:
					if ( bGameLoaded )  {
						if ( mcPreloader.startGame() ) {
							setGame();
							swapGSAndGame();
							uiLoadState = _STARTGAME;
						}
					}
					break;
					
				case _STARTGAME:
					// set game framerate
					setLoaderFramerate( _NP9_GAME_DATA.iFramerate );
					//
					if ( bOffline ) {
						objRoot.play();
						
						/**
						 * NEW WAY WILL NEED TO CHANGE THE PRELOADER ON THE SITE
						 */
						 
						objRoot.dispatchEvent(new Event("NP9_PRELOADER_tellingGametoStart"));
						
					} else {
						// Preloader links
						mcPreloader.removeEventListener(TextEvent.LINK, TextLinkHandler);
						mcGame.play();
						
						/**
						 * NEW WAY WILL NEED TO CHANGE THE PRELOADER ON THE SITE
						 */
						
						mcGame.dispatchEvent(new Event("NP9_PRELOADER_tellingGametoStart"));
					}
					uiLoadState = _DONE;					
					break;
					
				case _DONE:
					// we're done - this
					bLoadInProgress = false;
					break;
			}
			
			return ( bLoadInProgress );
		}
		
		/**
		 * Read parameters from flashvars and populate NP9_Game_Data
		 * @see NP9_Game_Data
		 */
		private function initGameData():void {
					
			var tf:String = "";
			
			var paramObj:Object = objRoot.loaderInfo.parameters;
			
			// loop through passed parameters
			for (var keyStr:String in paramObj) {
				
				var valueStr:String = String(paramObj[keyStr]);
				tf += keyStr + ": ";
				
				var bFound:Boolean = false;
				for ( var i:uint=0; i<aParams.length; i++ ) {
					
					if ( aParams[i][1] == keyStr ) {
						bFound = true;
						_NP9_GAME_DATA.setVar( aParams[i][0], valueStr );
						tf += _NP9_GAME_DATA[ aParams[i][0] ] + "\n";
						break;
					}
				}
				
				if ( !bFound ) {
					_NP9_GAME_DATA.setAddVar( keyStr, valueStr );
					tf += _NP9_GAME_DATA.objAddVars[ keyStr ] + " (NEW VAR)\n";
				}
			}
			
			//objRoot.txtDebug.text += tf;
			
			// -------------------------------------------------------------------------------
			// Set Game and Script Server Locations
			// -------------------------------------------------------------------------------
			_NP9_GAME_DATA.FG_GAME_BASE   = _NP9_GAME_DATA.sImageHost + String.fromCharCode(47);
			_NP9_GAME_DATA.FG_SCRIPT_BASE = "http://" + _NP9_GAME_DATA.sBaseURL + String.fromCharCode(47);
			
			objTracer.out( "_NP9_GAME_DATA.FG_GAME_BASE: "+_NP9_GAME_DATA.FG_GAME_BASE, false );
			objTracer.out( "_NP9_GAME_DATA.FG_SCRIPT_BASE: "+_NP9_GAME_DATA.FG_SCRIPT_BASE, false );
			
			_NP9_GAME_DATA.objTransLevel = objRoot;
			
			_NP9_GAME_DATA.tLoaded        = getTimer(); // log game start
			_NP9_GAME_DATA.iAvgFramerate  = _NP9_GAME_DATA.iFramerate
			
			_NP9_GAME_DATA.iGameMaxW = flash.system.Capabilities.screenResolutionX;
			//changed by Viviana - July 2009 - from:
			//_NP9_GAME_DATA.iGameMaxW = flash.system.Capabilities.screenResolutionY;
			//to:
			_NP9_GAME_DATA.iGameMaxH = flash.system.Capabilities.screenResolutionY
		}
		
		/**
		 * Sets the framerate of the loader animation
		 * @param	iFR	new framerate
		 */
		private function setLoaderFramerate( iFR:int=18 ):void {
			
			if ( !_NP9_GAME_DATA.bOffline ) {
				objStage.frameRate = iFR;
			}
		}
		
		/**
		 * Proceed to load the GamingSystem
		 */
		private function loadGamingSystem():void {

			var sGSURL:String;
			if ( bDEBUG_LOAD_LOCAL ) {
				sGSURL = sLocalPath + "\\Gaming_System\\np9_gaming_system_v15.swf";
				//sGSURL = sLocalPath + "\\Gaming_System\\np9_gaming_system_v5.swf";
				
				trace("loading: " + sGSURL );
			} else {
				sGSURL = _NP9_GAME_DATA.FG_GAME_BASE + _NP9_GAME_DATA.sIncludeMovie;
			}
			
			objTracer.out( "loading: "+sGSURL, false );
			
			objLoaderGS = new Loader();
			var urlReq:URLRequest = new URLRequest( sGSURL );
			
			objLoaderGS.load( urlReq );
			objLoaderGS.contentLoaderInfo.addEventListener(Event.COMPLETE, GSLoaded, false, 0, true);
		}
		// -------------------------------------------------------------------------------
		private function GSLoaded(event:Event):void {
			bGSLoaded = true;
			objLoaderGS.contentLoaderInfo.removeEventListener(Event.COMPLETE, GSLoaded);
		}
		
		/**
		 * Sets the GamingSystem's position and size
		 */
		private function setGamingSystem():void
		{
			// get GS class reference
			
						
			mcGS = MovieClip( objLoaderGS.contentLoaderInfo.content ); 
			objRoot.addChild(objLoaderGS);
			mcGS.init( _NP9_GAME_DATA, bTRACE );
			
			trace("GAMINGSYSTEM WIDTH = " + mcGS.width);
			
			// set GS dimensions and position
			//mcGS.x = -500;
			//mcGS.y = -500;
			
			// hide scoring meter
			//mcGS.visible = false;
		}
		
		/**
		 * Loads the preloader animation
		 */
		private function loadPreloader():void {
			
			var sPreloaderURL:String = "";
			
			if ( bDEBUG_LOAD_LOCAL ) {
				sPreloaderURL = sLocalPath + "\\Preloader\\Older\\np9_preloader_hauntedwoods_v2.swf";
				//sPreloaderURL = "np9_preloader_hauntedwoods_v1.swf";
			} else {
				sPreloaderURL = _NP9_GAME_DATA.FG_GAME_BASE;
				sPreloaderURL += "games/preloaders/" + _NP9_GAME_DATA.sPreloader + ".swf";
			}
			
			objTracer.out( "loading: "+sPreloaderURL, false );
			
			objLoaderPre = new Loader();
			var urlReq:URLRequest = new URLRequest( sPreloaderURL );
			
			objLoaderPre.load( urlReq );
			objLoaderPre.contentLoaderInfo.addEventListener(Event.COMPLETE, preloaderLoaded, false, 0, true);
		}
		// -------------------------------------------------------------------------------
		private function preloaderLoaded(event:Event):void {
			bPreloaderLoaded = true;
			objLoaderPre.contentLoaderInfo.removeEventListener(Event.COMPLETE, preloaderLoaded);
		}

		/**
		 * Sets preloader's position and size
		 */
		private function setPreloader():void
		{
			// get preloader class reference			
			mcPreloader = MovieClip( objLoaderPre.contentLoaderInfo.content ); 
			mcPreloader.initTextFields( mcGS.isWesternLang() );
			
			if("sLang" in mcPreloader) mcPreloader.sLang = _NP9_GAME_DATA.sLang;
			
			// new dynamic preloader setting
			//if ( (_NP9_GAME_DATA.sSpLogoURL != "") || (_NP9_GAME_DATA.iSpTrackID != -1) || (_NP9_GAME_DATA.sSpAdURL != "") || (_NP9_GAME_DATA.sSpClickUrl != "") ) {
			if("initLogoTracking" in mcPreloader) {
				if("setSpLogoClickUrl" in mcPreloader) {
					mcPreloader.initLogoTracking( _NP9_GAME_DATA.iGameWidth,
												  _NP9_GAME_DATA.iGameHeight,
												  _NP9_GAME_DATA.sSpLogoURL,
												  _NP9_GAME_DATA.iSpTrackID,
												  _NP9_GAME_DATA.sSpAdURL,
												  _NP9_GAME_DATA.sSpClickUrl,
												  _NP9_GAME_DATA.iSpLogoTrackID);
				} else {
					mcPreloader.initLogoTracking( _NP9_GAME_DATA.iGameWidth,
												  _NP9_GAME_DATA.iGameHeight,
												  _NP9_GAME_DATA.sSpLogoURL,
												  _NP9_GAME_DATA.iSpTrackID,
												  _NP9_GAME_DATA.sSpAdURL);
				}
			}
			
			// set preloader dimensions and position
			objTracer.out( "mcPreloader.width: "+mcPreloader.width+" -> "+_NP9_GAME_DATA.iGameWidth, false );
			objTracer.out( "mcPreloader.height: "+mcPreloader.height+" -> "+_NP9_GAME_DATA.iGameHeight, false );
			mcPreloader.width  = _NP9_GAME_DATA.iGameWidth;
			mcPreloader.height = _NP9_GAME_DATA.iGameHeight;
			mcPreloader.x = 0;
			mcPreloader.y = 0;
			
			mcPreloader.gotoAndStop(2);
			
			if( "setLang" in mcPreloader ){
				mcPreloader.setLang( mcGS.getFlashParam( "sLang" ) );
			}
			
			mcPreloader.addAnimation();
			
			objRoot.addChild(objLoaderPre);
			
			//race("objRoot.width: "+objRoot.width);
			//objRoot.width = 640;
			//objRoot.height = 480;
		}

		/**
		 * Sets all text in the preloader
		 */
		private function setPreloaderText():void
		{
			// preloader legal text
			var curDate:Date = new Date();
			var sLegal:String = "<p align='center'>® & © " + String( curDate.getFullYear() ) + " Neopets, Inc.<br>All Rights Reserved</p>"; //<font size='40'></font>
			mcPreloader.setLegalText( sLegal );
			
			// headline
			var sHeader:String = mcGS.getTranslation("IDS_PRELOADER_LOADING_GAME");
			var sNew:String = sHeader.replace("face = 'jokerman_fnt' ","");
			mcPreloader.setHeaderText( sNew );
			
			aPreloaderText.playgame    = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_PLAYGAME") );
			aPreloaderText.login       = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_LOGIN") );
			aPreloaderText.signup      = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_SIGNUP") );
			aPreloaderText.plugin      = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_PLUGIN") );
			aPreloaderText.loaded      = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_LOADED") );
			aPreloaderText.percent     = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_PERCENT") );
			aPreloaderText.elapsed     = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_ELAPSED") );
			aPreloaderText.secs        = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_SEC") );
			aPreloaderText.estimate    = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_ESTIMATED") );
			aPreloaderText.rate        = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_RATE") );
			aPreloaderText.kps         = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_KPS") );
			aPreloaderText.notloggedin = formatPreloaderTextStrings( mcGS.getTranslation("IDS_PRELOADER_NOTLOGGEDIN") );
			
			// user logged in?
			if ( _NP9_GAME_DATA.sUsername.toUpperCase() == "GUEST_USER_ACCOUNT" ) {
				mcPreloader.setData( false, false );
			}
		}

		/**
		 * Clear contents of the textfields in the preloader
		 * @param	p_sStr	contents retrieved from the preloader's textfield
		 * @return				new contents of the formatted string
		 */
		private function formatPreloaderTextStrings( p_sStr:String ):String {
			
			p_sStr = p_sStr.replace( "face = 'customFSS_fnt' ", "" );
			p_sStr = p_sStr.replace( "_root.", "" );
			p_sStr = p_sStr.replace( "asfunction", "event" );
			p_sStr = p_sStr.replace( "HTMLClick,1", "playGame" );
			p_sStr = p_sStr.replace( "HTMLClick,2", "signUp" );
			p_sStr = p_sStr.replace( "HTMLClick,3", "login" );
			
			return ( p_sStr );
		}
		
		/**
		 * Proceeds to load the actual game
		 */
		private function loadGame():void
		{
			var sGameURL:String = "";
			
			
			if ( bDEBUG_LOAD_LOCAL ) {
				sGameURL = sLocalPath + "\\Gaming_System\\g928_v1_13743.swf";
				//sGameURL = "g928_v1_13743.swf";
			} else {
				sGameURL = _NP9_GAME_DATA.FG_GAME_BASE;
				sGameURL += "games/" + _NP9_GAME_DATA.sFilename + ".swf";
			}
			
			objTracer.out( "loading: "+sGameURL, false );
			
			objLoaderGame = new Loader();
			var urlReq:URLRequest = new URLRequest( sGameURL );
			
			trace("NP9_LoaderControl is Loading>",sGameURL);
			
			objLoaderGame.load( urlReq );
			objLoaderGame.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, gameLoadingProgress, false, 0, true);
			objLoaderGame.contentLoaderInfo.addEventListener(Event.COMPLETE, gameLoaded, false, 0, true);
		}
		
		/**
		 * Displays game loading progress in the preloader
		 * @param	event
		 */
		private function gameLoadingProgress( event:ProgressEvent ):void {

			var sText:String = "<p align='center'><br><br>";
			
			var nPercent:Number = 0;
			if ( (event.bytesLoaded > 0) && (event.bytesTotal > 0) ) {
				if ( event.bytesLoaded >= event.bytesTotal ) nPercent = 100;
				else nPercent = int((event.bytesLoaded * 100) / event.bytesTotal);
			}
			
			var nTm1:Number = ( getTimer() - nStartGameLoad ); // / 1000;
			var nKps:Number = 0;
			var nTm2:Number = 0;
			if ( nTm1 > 0 ) {
				nKps = ( (event.bytesLoaded/1000) / (nTm1/1000) ); // / 100) / 10;
				if ( nKps > 0 ) {
					nTm2 = ( event.bytesTotal / nKps); // / 1000;
				}
			}
			/*
			trace("nTm1: "+nTm1+" ms");
			trace("event.bytesLoaded: "+event.bytesLoaded)
			trace("event.bytesTotal: "+event.bytesTotal)
			trace("nKps: "+nKps);
			trace("nTm2: "+nTm2);
			*/
			
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(Capabilities.version);
			var sPluginVersion:String = "";
			if (result != null) {
				sPluginVersion = String(result[2]);
			}
			
			sText += aPreloaderText.plugin + " " + sPluginVersion;
			sText += "<br>" + aPreloaderText.loaded + " " + String(nPercent) + aPreloaderText.percent;
			if ( mcPreloader.isLoggedIn() ) {
				sText += "<br>" + aPreloaderText.elapsed + " " + String(Math.round(nTm1/1000)) + " " + aPreloaderText.secs; //time_elapsed
				sText += "<br>" + aPreloaderText.estimate + " " + String(Math.round(nTm2/1000)) + " " + aPreloaderText.secs; //time_estimated
				sText += "<br>" + aPreloaderText.rate + " " + String(int(nKps)) + " " + aPreloaderText.kps; //kps
			}
			else {
				sText += "<br><br>" + aPreloaderText.notloggedin;
				sText += "<br><font color='#FF0000'>" + aPreloaderText.playgame + "</font>";
				sText += "<br><font color='#FF0000'>" + aPreloaderText.login + "</font>";
				sText += "<br><font color='#FF0000'>" + aPreloaderText.signup + "</font>";
			}
			sText += "</p>";
			
			mcPreloader.showLoadingProcess( sText, int(nPercent) );
		}
		
		/**
		 * Sets html links in the preloader texts
		 * @param	e	TextEvent
		 */
		private function TextLinkHandler( e:TextEvent ):void {
		
			var t_sEvent:String = e.text.toUpperCase();
			
			switch ( t_sEvent ) {
				case "LOGIN":
					trace("login clicked");
					mcGS.showLogin();
					break;
				case "SIGNUP":
					trace("signup clicked");
					mcGS.showSignup();
					break;
				case "PLAYGAME":
					trace("playgame clicked");
					mcPreloader.setStart( true );
					break;
			}
		}
		
		/**
		 * Triggered when the game is loaded, and sets bGameLoaded flag to true. This listener is automatically removed when done
		 * @param	event
		 */
		private function gameLoaded(event:Event):void {
			bGameLoaded = true;
			objLoaderGame.contentLoaderInfo.removeEventListener(Event.COMPLETE, gameLoaded);
		}

		/**
		 * Sets position and size of the game
		 */
		private function setGame():void
		{
			// get game class reference			
			mcGame = MovieClip( objLoaderGame.contentLoaderInfo.content ); 
			
			objTracer.out( "_NP9_GAME_DATA.iGameWidth: "+_NP9_GAME_DATA.iGameWidth, false );
			objTracer.out( "_NP9_GAME_DATA.iGameHeight: "+_NP9_GAME_DATA.iGameHeight, false );
			trace ("mcGame.width", mcGame.width);
			trace ("mcGame.height", mcGame.height);
			
			//please comment out the following two lines when compiling this for Flash 10
			mcGame.width  = _NP9_GAME_DATA.iGameWidth;
			mcGame.height = _NP9_GAME_DATA.iGameHeight;
			
			mcGame.x = 0;
			mcGame.y = 0;
			
			mcGame.setGamingSystem( mcGS );
			setBiosParams( mcGame.getBIOS() );
			
			objRoot.removeChild(objLoaderPre);
			objRoot.addChild(objLoaderGame);
		}
		
		/**
		 * Swaps depth of the GamingSystem and Game object
		 */
		private function swapGSAndGame():void {
		
			objRoot.swapChildren( objLoaderGame, objLoaderGS );
		}
		
		 /**
		  * Loads info from the BIOS positioning and size into NP9_Game_Data. Note that there is a problem when the BIOS is not on the stage, some values will not be correct (such as positions).
		  * @param	p_objBIOS		The NP9_BIOS object in the game swf.
		  * @see NP9_BIOS
		  * @see NP9_Game_Data
		  */
		private function setBiosParams( p_objBIOS:Object ):void {
			
			if (p_objBIOS == null)
			{ 
				trace("mcBIOS is NULL . CAUSE AND ERROR IN LOADER_CONTROLL!!!"); 
				return;
			}
			
			_NP9_GAME_DATA.bMeterVisible = p_objBIOS.metervisible;
			_NP9_GAME_DATA.iMeterX = p_objBIOS.meterX;
			_NP9_GAME_DATA.iMeterY = p_objBIOS.meterY;
			
			//IF the value == Null undefeined or 0 (FOR BACKWARD COMP)
			var tW:int = p_objBIOS.width != 0 ? p_objBIOS.width : p_objBIOS.iBIOSWidth;
			var tH:int =  p_objBIOS.height != 0 ?  p_objBIOS.height :  p_objBIOS.iBIOSHeight;
			
			_NP9_GAME_DATA.iBIOSWidth  = tW;
			_NP9_GAME_DATA.iBIOSHeight = tH;
			
			/**
			_NP9_GAME_DATA.iBIOSWidth  = p_objBIOS.width;
			_NP9_GAME_DATA.iBIOSHeight = p_objBIOS.height;
			 * **/
		}
	}
}
