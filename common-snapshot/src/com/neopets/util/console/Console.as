/* AS3
	Copyright 2009
*/

package com.neopets.util.console {
	
	/**
	 *	Provides an onscreen output for data and tracing for games.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 14 Oct 2009
	*/	
	
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.input.KeyManager;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.system.System;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class Console extends MultitonEventDispatcher {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const VERSION:String = "v1.10";
		public static const DEFAULT_IDENTIFIER:String = "Console";
		
		private const TRIGGER_KEY:uint = 96; // ~ key
		private const LINE_HEIGHT:Number = 12; // The height of each line
		private const MONITOR_X:int = 220;
		
		private const INFO_STRING:String = "<p align='left'><font face='verdana' size='10' color='#FFFF00'><b>FPS: <font color='#FFFFFF'>%0</font> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Mem: <font color='#FFFFFF'>%1 Kb</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Global Mouse X:<font color='#FFFFFF'>%mouseX</font> Y:<font color='#FFFFFF'>%mouseY</font></b><br />%CommonInfo</font></p>";
		private const USER_TXT:String = "User Info: <font color='#FFFFFF'>%UserName </font>[<font color='#FFFFFF'>%Name</font>] %IsAdmin (HiScore: <font color='#FFFFFF'>%HiScore</font>)<br />";
		private const GAMEID_TXT:String = "Game ID: <font color='#FFFFFF'>%GameID</font> [<font color='#FFFFFF'>%File</font>]<br />";
		private const GAMESYSTEMVERSION_TXT:String = "GamingSystem: <font color='#FFFFFF'>%GameSystemVer</font><br />";
		private const PRELOADERVERSION_TXT:String = "Preloader: <font color='#FFFFFF'>%PreloaderVer</font><br />";
		private const BASEURL_TXT:String = "BaseURL: <font color='#FFFFFF'>%BaseURL</font><br />";
		private const IMAGEHOST_TXT:String = "Image Host: <font color='#FFFFFF'>%ImageHost</font><br />";
		private const GAMELANG_TXT:String = "Language: <font color='#FFFFFF'>%Lang</font><br />";
		private const HIBAND_TXT:String = "HiBand Vid: [<font color='#FFFFFF'>%ncid</font>] <font color='#FFFFFF'>%HiBand</font><br />";
		private const LOBAND_TXT:String = "LoBand Vid: [<font color='#FFFFFF'>%ncid</font>] <font color='#FFFFFF'>%LoBand</font><br />";
		private const DIMENSIONS_TXT:String = "Size: <font color='#FFFFFF'>%width x %height</font><br />";
		private const ECHO_STRING:String = "<font face='verdana' size='10' color='#00FF00'>%0</font>";
		private const MONITOR_STRING:String = "<font face='verdana' size='10' color='#FF9900'>%0: <font color='#FFFFFF'>%1</font></font>";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _myroot:Object;
		private var _myparent:Sprite;
		private var _console_active:Boolean;
		private var _func:Function;
		private var _sectimer:Timer;
		private var _max_v:int;
		
		private var _fpscount:int;
		private var _fps:int;
		private var _echo_buffer:String;
		
		private var _common_info:String;
		private var _info_text:String;
		
		private var _mon_array:Array;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		// on stage
		public static var _container:Sprite;
		public static var _info_txt:TextField;
		public static var _echo_txt:TextField;
		
		public var echo:Function;
		public var monitor:Function;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Console(key:String = DEFAULT_IDENTIFIER):void {
			multitonKey = key;
			super(key);
			_console_active = false;
			_echo_buffer = "";
			_func = idleFunction;
			echo = idleFunction;
			monitor = idleFunction;
			_mon_array = [];
			_fps = 0;
			trace("[Console] " + VERSION + " Created...");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Initialization
		*/ 				
		public function init(p_parent:Sprite):void {
			if (!_myparent) {
				_myparent = p_parent;
				_myroot = _myparent.stage;
				//_np9de = NP9_DocumentExtension(_myparent.parent.parent);
				if (!isOnLive()) {
					drawConsole(_myroot.stageWidth, _myroot.stageHeight);
					echo = echoFunction;
					_sectimer = new Timer(1000, 1);
				
					_sectimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
					_myroot.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
					_container.addEventListener(Event.ENTER_FRAME, efFunction);
					
					createGeneralInfo();
					updateInfo();
					
					announceEvent("Console started");
				}
			}
		}
		
		/**
		 * @Note: Used to announce custom events with the console
		 * @param		p_event			String 		The name of the event to be announced
		 * @param		p_data			Object 		Any extra data to be passed on
		*/ 				
		public function announceEvent(p_event:String, p_data:Object = null):void {
			if (!p_data) {
				p_data = {multitonKey: multitonKey};
			} else {
				p_data.multitonKey = multitonKey;
			}
			echo("[Event:" + p_data.multitonKey + "] " + p_event);
			dispatchEvent(new CustomEvent(p_data, p_event));
		}
		
		/**
		 * @Note: Creates a monitoring panel for variables
		 * @param		p_description		String 		A descriptive name for the variable being monitored
		*/ 				
		public function createMonitor(p_description:String):void {
			if (_container) { // checks if console is created and active
				if (monitorExists(p_description) < 0) {
					if (_max_v > 15) {
						var i:int = 0, txt:String = MONITOR_STRING;
						while (_mon_array[i]) i ++;
						_mon_array[i] = {txt:new TextField(), descript:p_description}
						txt = replaceToken(txt, "%0", _mon_array[i].descript);
						_mon_array[i].str = txt;
						txt = replaceToken(txt, "%1", "No Data");
						_mon_array[i].txt.htmlText = txt;
						_mon_array[i].txt.autoSize = "left";
						_mon_array[i].txt.mouseEnabled = false;
						_container.addChild(_mon_array[i].txt);
						_mon_array[i].txt.y = 158 + (i * LINE_HEIGHT);
						_echo_txt.y = _mon_array[i].txt.y + (2 * LINE_HEIGHT);
						_max_v = int((_echo_txt.height - _echo_txt.y) / LINE_HEIGHT);
					}
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Keypress event for ~ key
		*/ 				
		private function onKeyDownHandler(e:KeyboardEvent):void {
			if (e.charCode == TRIGGER_KEY) {
				(_console_active)? turnOff(): turnOn();
				_console_active = !_console_active;
			}
		}
		
		/**
		 * @Note: Event frame event
		*/ 				
		private function efFunction(e:Event):void {
			_func();
		}
		
		/**
		 * @Note: Timer event. Used for fps counting
		*/ 				
		private function timerHandler(e:TimerEvent):void {
			//updateInfo();
			_fps = _fpscount;
			_fpscount = 0;
			if (_console_active) _sectimer.start();
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Do nothing
		*/ 				
		private function idleFunction(... args):void {}
		
		/**
		 * @Note: Displays a message on the console
		 * @param		str			* 		Any object. This will be converted to a string output using toString() method
		*/ 				
		private function echoFunction(str:*):void {
			_echo_buffer += str.toString() + "<br />";
			var arr:Array = _echo_buffer.split("<br />"), txt:String = ECHO_STRING;
			if (arr.length > _max_v) _echo_buffer = arr.splice(arr.length - (_max_v + 1), (_max_v + 1)).join("<br />");
			txt = replaceToken(txt, "%0", _echo_buffer);
			_echo_txt.htmlText = txt;
		}
		
		/**
		 * @Note: Looks for a particular monitoring object.
		 * @param		p_description		String 		A name given to the variable; This name has to be unique
		 * @return		int										Returns >-1 if found; -1 if object does not exist
		*/ 				
		private function monitorExists(p_description:String):int {
			for (var i:int = 0; i < _mon_array.length; i ++) {
				if (_mon_array[i]) {
					if (_mon_array[i].descript == p_description) return i;
				}
			}
			return -1;
		}
		
		/**
		 * @Note: Monitors a particular variable and display its value realtime
		 * @param		p_description		String 		A name given to the variable; This name has to be unique
		 * @param		p_var					*		 		The actual variable to monitor
		*/ 				
		private function monitorFunction(p_description:String, p_var:*):void {
			var i:int = monitorExists(p_description);
			if (i > -1) {
				_mon_array[i].txt.htmlText = replaceToken(_mon_array[i].str, "%1", p_var.toString());
			}			
		}
		
		/**
		 * @Note: Displays the console
		*/ 				
		private function turnOn():void {
			_fpscount = 0;
			_func = frameFunction;
			_sectimer.start();
			monitor = monitorFunction;
			_myparent.addChild(_container);
		}
		
		/**
		 * @Note: Hides the console
		*/ 				
		private function turnOff():void {
			_myparent.removeChild(_container);
			_sectimer.stop();
			_func = idleFunction;
			monitor = idleFunction;
		}
		
		/**
		 * @Note: Renders the text boxes for the console
		*/ 				
		private function drawConsole(p_width:int, p_height:int):void {
			_container = new Sprite();
			var bmdata:BitmapData = new BitmapData(p_width, p_height, true, 0x80000000);
			var bg:Bitmap = new Bitmap(bmdata);
			_container.addChild(bg);
			_container.mouseEnabled = false;
			_container.tabEnabled = false;
			
			_info_txt = new TextField();
			_info_txt.embedFonts = false;
			_info_txt.multiline = true;
			_info_txt.border = false;
			_info_txt.width = p_width;
			_info_txt.height = p_height;
			_info_txt.name = "info_txt";
			_info_txt.mouseEnabled = false;
			_container.addChild(_info_txt);
			
			_echo_txt = new TextField();
			_echo_txt.embedFonts = false;
			_echo_txt.multiline = true;
			_echo_txt.border = false;
			_echo_txt.width = p_width;
			_echo_txt.height = p_height;
			_echo_txt.name = "echo_txt";
			_echo_txt.mouseEnabled = false;
			_container.addChild(_echo_txt);
			_echo_txt.y = 170;
			_max_v = int((p_height - _echo_txt.y) / LINE_HEIGHT);
		}
		
		/**
		 * @Note: The enterframe function
		*/ 				
		private function frameFunction():void {
			_fpscount ++;
			updateInfo();
		}
		
		/**
		 * @Note: Writes the fps, memory usage data on the console
		*/ 				
		private function updateInfo():void {
			var str:String = _info_text;
			str = replaceToken(str, "%0", _fps.toString());
			str = replaceToken(str, "%1", int(System.totalMemory / 1024).toString());
			var pt:Point = _container.localToGlobal(new Point(_container.mouseX, _container.mouseY));
			str = replaceToken(str, "%mouseX", pt.x.toString());
			str = replaceToken(str, "%mouseY", pt.y.toString());
			_info_txt.htmlText = str;
		}
		
		/**
		 * @Note: Replaces a particular text in a string
		 * @param		poriginal			String 		The text to be worked on
		 * @param		preplace				String 		The text to be replaced on poriginal
		 * @param		ptext					String 		The replacing text
		 * @return		String								The final text with the replaced string
		 */ 				
		private function replaceToken(poriginal:String, preplace:String, ptext:String):String {
			return poriginal.split(preplace).join(ptext);
		}
		
		/**
		 * @Note: Creates the general information text for games
		*/ 				
		private function createGeneralInfo():void {
			// common display information
			var tmpstr:String;
			_common_info = "<br />";
			tmpstr = replaceToken(GAMEID_TXT, "%GameID", getExtParam("itemID"));
			tmpstr = replaceToken(tmpstr, "%File", getExtParam("g"));
			_common_info += tmpstr;
			tmpstr = replaceToken(USER_TXT, "%UserName", getExtParam("username"));
			tmpstr = replaceToken(tmpstr, "%Name", getExtParam("name"));
			if (getExtParam("isAdmin") == "1") {
				tmpstr = replaceToken(tmpstr, "%IsAdmin", " is Admin");
			} else {
				tmpstr = replaceToken(tmpstr, "%IsAdmin", "");
			}
			tmpstr = replaceToken(tmpstr, "%HiScore", getExtParam("hiscore"));
			_common_info += tmpstr;
			_common_info += replaceToken(GAMESYSTEMVERSION_TXT, "%GameSystemVer", getExtParam("include_movie"));
			_common_info += replaceToken(PRELOADERVERSION_TXT, "%PreloaderVer", getExtParam("p"));
			_common_info += replaceToken(BASEURL_TXT, "%BaseURL", getExtParam("baseurl"));
			_common_info += replaceToken(IMAGEHOST_TXT, "%ImageHost", getExtParam("image_host"));
			tmpstr = replaceToken(GAMELANG_TXT, "%Lang", getExtParam("lang"));
			_common_info += tmpstr;
			tmpstr = replaceToken(HIBAND_TXT, "%HiBand", getExtParam("highTrailer1URL_str"));
			tmpstr = replaceToken(tmpstr, "%ncid", getExtParam("highTrailer1NeocontentID_str"));
			_common_info += tmpstr;
			tmpstr = replaceToken(LOBAND_TXT, "%LoBand", getExtParam("lowTrailer1URL_str"));
			tmpstr = replaceToken(tmpstr, "%ncid", getExtParam("lowTrailer1NeocontentID_str"));
			_common_info += tmpstr;
			tmpstr = replaceToken(DIMENSIONS_TXT, "%width", getExtParam("gamew"));
			tmpstr = replaceToken(tmpstr, "%height", getExtParam("gameh"));
			_common_info += tmpstr;
			_info_text = replaceToken(INFO_STRING, "%CommonInfo", _common_info);
		}
		
		/**
		 * @Note: Obtains an input from flashvars
		 * @param		p_param		String		Name of the flashvar to be loaded
		 * @return		String							Value of the flashvar. returns "" if nothing detected
		*/ 		
		private function getExtParam(p_param:String):String {
			var str:String = "";
			try {
				str = _myroot.loaderInfo.parameters[p_param];
			} catch(e:Error) {
				str = "NA";
			}
			if (!str) str = "NA";
			return str;
		}
		
		/**
		 * @Note: Obtains the host url containing the swf; Called by isOnLive()
		 * @return		String	The URL
		 */ 				
		private function baseURL():String {
			var sVars:Array = _myroot.loaderInfo.loaderURL.split("/");
			for (var i:int = 0; i < sVars.length; i ++) {
				switch (sVars[i]) {
					case "file:": return "Local - Offline";
					case "images.neopets.com":
					case "www.neopets.com":
					case "images50.neopets.com": 
					case "dev.neopets.com": 
								return sVars[i];
				}
			}
			return _myroot.loaderInfo.loaderURL;
		}
		
		/**
		* @Note: True if the game is on live server
		*/  
		private function isOnLive():Boolean {
			switch (baseURL()) {
				case "images.neopets.com": return true;
				case "www.neopets.com": return true;
			}
			return false;
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			_mon_array.length = 0;
			_mon_array = null;
			_sectimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			_container.removeEventListener(Event.ENTER_FRAME, efFunction);
			_myroot.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}
	}
}