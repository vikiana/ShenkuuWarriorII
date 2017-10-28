/* AS3
	Copyright 2009
*/

package com.neopets.util.video {
	
	/**
	 *	A Specialized View Trailer player for Neopets games.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 21 Sept 2009
	*/	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.neopets.util.events.CustomEvent;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class NPTrailerPlayer extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const VIDEO_DONE_PLAYING:String = "NPTrailerPlayer.VideoDonePlaying"; // this is fired when a video is done playing. regardless of bandwidth preference
		public static const HIVIDEO_DONE_PLAYING:String = "NPTrailerPlayer.HiVideoDonePlaying"; // this is fired when hi bandwidth video is done playing. - fires with VIDEO_DONE_PLAYING - so listen for either one whichever you need
		public static const LOVIDEO_DONE_PLAYING:String = "NPTrailerPlayer.LoVideoDonePlaying"; // this is fired when lo bandwidth video is done playing. - fires with VIDEO_DONE_PLAYING - so listen for either one whichever you need
		public static const IMAGES_TEST_SERVER:String = "http://images50.neopets.com/";
		public static const IMAGES_LIVE_SERVER:String = "http://images.neopets.com/";
		
		public static const NEOCONTENT_URL_NOREDIRECT:String = "http://www.neopets.com/process_click.phtml?noredirect=1&item_id=";
		
		private const DEFAULT_HI_VIDEO:String = "sponsors/trailers/comingSoon_high.flv";
		private const DEFAULT_LO_VIDEO:String = "sponsors/trailers/comingSoon_low.flv";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _vm:VideoManager;
		private var _vid:int;
		
		private var _loband_url:String;
		private var _hiband_url:String;
		
		private var _hiband_id:String = "";
		private var _loband_id:String = "";
		
		private var _hiband_width:uint;
		private var _hiband_height:uint;
		private var _loband_width:uint;
		private var _loband_height:uint;
		
		private var _lastplayedhiband:Boolean; // true - hiband, false - loband
		
		private var _dispatcher:EventDispatcher;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NPTrailerPlayer():void {
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler); // this is only done once
			mouseEnabled = tabEnabled = false;
			
			_dispatcher = new EventDispatcher();
			_vm = VideoManager.instance;
			_vid = _vm.createVideoPlayer();
			_vm.playerParameters(_vid);
			_vm.getPlayerInstance(_vid).visible = false;
			addChild(_vm.getPlayerInstance(_vid));
			_vm.getPlayerInstance(_vid).x = 0;
			_vm.getPlayerInstance(_vid).y = 0;
			
			_vm.addEventListener(VideoManager.VIDEO_DONE, videoDoneHandler);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Note: Returns the video id of the player instance being used here
		*/ 		
		public function get myVideoID():int {
			return _vid;
		}
		
		/**
		 * @Note: Returns the player instance
		*/ 		
		public function get videoPlayerInstance():BasicVideoPlayer {
			return _vm.getPlayerInstance(_vid);
		}
		
		/**
		 * @Note: Returns the event dispatcher
		*/ 		
		public function get dispatcher():EventDispatcher {
			return _dispatcher;
		}
		
		/**
		* @Note: True if the game is on live server
		*/  
		public function get isOnLive():Boolean {
			var sVars:Array = loaderInfo.loaderURL.split("/");
			for (var i:int = 0; i < sVars.length; i ++) {
				switch (sVars[i]) {
					case "images.neopets.com": return true;
					case "www.neopets.com": return true;
					case "file:": return true;
				}
			}
			return false;
		}
		
		/**
		* @Note: Returns the appropriate swf server domain based on offline/live status
		*/  
		public function get SWF_SERVER():String {
			if (isOnLive) {
				return IMAGES_LIVE_SERVER;
			}
			return IMAGES_TEST_SERVER;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Assigns the classnames of the control buttons for the player
		 * @param		p_play			Class 		Class name of the play button
		 * @param		p_pause			Class 		Class name of the pause button
		 * @param		p_stop			Class 		Class name of the stop button
		 * @param		p_rewind		Class 		Class name of the rewind button
		 * @param		p_mute			Class 		Class name of the mute button
		 * @param		p_unmute		Class 		Class name of the unmute button
		*/ 		
		public function playerButtons(p_play:Class = null, p_pause:Class = null, p_stop:Class = null, p_rewind:Class = null, p_mute:Class = null, p_unmute:Class = null):void {
			_vm.playerButtons(_vid, p_play, p_pause, p_stop, p_rewind, p_mute, p_unmute);
		}
		
		/**
		 * @Note: Loads and plays the low bandwidth video
		 * @param		p_url			String 		Forces the player to load this video
		*/ 		
		public function playLoBandVideo(p_url:String = ""):void {
			_vm.getPlayerInstance(_vid).visible = true;
			if (p_url == "") {
				_vm.loadAndPlay(_vid, _loband_url, _loband_width, _loband_height);
			} else {
				_vm.loadAndPlay(_vid, p_url, _loband_width, _loband_height);
			}
			sendNCTracker(_loband_id);
			_lastplayedhiband = false;
		}
		
		/**
		 * @Note: Loads and plays the high bandwidth video
		 * @param		p_url			String 		Forces the player to load this video
		*/ 		
		public function playHiBandVideo(p_url:String = ""):void {
			_vm.getPlayerInstance(_vid).visible = true;
			if (p_url == "") {
				_vm.loadAndPlay(_vid, _hiband_url, _hiband_width, _hiband_height);
			} else {
				_vm.loadAndPlay(_vid, p_url, _hiband_width, _hiband_height);
			}
			sendNCTracker(_hiband_id);
			_lastplayedhiband = true;
		}
		
		/**
		 * @Note: Unloads and clears the video
		*/ 		
		public function terminateVideo():void {
			_vm.getPlayerInstance(_vid).stopVideo();
			_vm.getPlayerInstance(_vid).visible = false;
			_vm.getPlayerInstance(_vid).cleanUp();
		}
		
		/**
		 * @Note: Sends a "ping" to the Neocontent item
		 * @param		p_id			String		The id of the neocontent item
		*/
		public function sendNCTracker(p_id:String):void {
			if (p_id != "") {
				var req:URLRequest = new URLRequest(NEOCONTENT_URL_NOREDIRECT + p_id);
				var lv:URLLoader = new URLLoader();
				lv.addEventListener(Event.COMPLETE, ontriggerNeoContentTrackerComplete, false, 0, true);
				try {
					lv.load(req);
				} catch (e:Error) {}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Attempts to get flashvars once this videoplayer is added to the stage
		*/ 		
		private function addToStageHandler(e:Event):void {
			getParameters();
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler); // remove this listener
		}
		
		/**
		 * @Note: For Neocontent tracker sending response.
		 */
		private function ontriggerNeoContentTrackerComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, ontriggerNeoContentTrackerComplete);
		}
		
		/**
		 * @Note: When a video is done playing 
		*/ 		
		private function videoDoneHandler(e:CustomEvent):void {
			if (e.oData.ID == _vid) {
				terminateVideo();
				_dispatcher.dispatchEvent(new Event(VIDEO_DONE_PLAYING));
				if (_lastplayedhiband) {
					_dispatcher.dispatchEvent(new Event(HIVIDEO_DONE_PLAYING));
				} else {
					_dispatcher.dispatchEvent(new Event(LOVIDEO_DONE_PLAYING));
				}
			}
		}
		

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Obtains an input from flashvars
		 * @param		p_param		String		Name of the flashvar to be loaded
		 * @return		String							Value of the flashvar. returns "" if nothing detected
		*/ 		
		protected function getExtParam(p_param:String):String {
			var str:String = "";
			try {
				str = this.stage.loaderInfo.parameters[p_param];
			} catch(e:Error) {
				str = "";
			}
			if (!str) str = "";
			return str;
		}
		
		/**
		 * @Note: Tries to get input from flashvars, if none, use default values
		*/ 		
		protected function getParameters():void {
			var b:Boolean = isOnLive;
			_loband_url = getExtParam("lowTrailer1URL_str");
			_hiband_url = getExtParam("highTrailer1URL_str");
			
			_loband_id = getExtParam("lowTrailer1NeocontentID_str");
			_hiband_id = getExtParam("highTrailer1NeocontentID_str");
			
			_loband_width = uint(getExtParam("lowTrailer1Width_str"));
			_loband_height = uint(getExtParam("lowTrailer1Height_str"));
			_hiband_width = uint(getExtParam("highTrailer1Width_str"));
			_hiband_height = uint(getExtParam("highTrailer1Height_str"));
			
			// assign default values if input is not found
			if (_hiband_url == "") _hiband_url = SWF_SERVER + DEFAULT_HI_VIDEO;
			if (_loband_url == "") _loband_url = SWF_SERVER + DEFAULT_LO_VIDEO;
			
			if (_loband_width <= 0) _loband_width = 160;
			if (_loband_height <= 0) _loband_height = 120;
			if (_hiband_width <= 0) _hiband_width = 320;
			if (_hiband_height <= 0) _hiband_height = 240;
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			_vm.removeEventListener(VideoManager.VIDEO_DONE, videoDoneHandler);
			
			_vm.destroyVideoPlayer(_vid);
			_vm = null;
			_dispatcher = null;
		}
	}
}