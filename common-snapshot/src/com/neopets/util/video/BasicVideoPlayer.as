/* AS3
	Copyright 2009
*/

package com.neopets.util.video {
	
	/**
	 *	An extremely basic videoplayer.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  8.05.2009
	 */	
	 
	 import flash.display.Sprite;
	 import flash.display.MovieClip;
	 import flash.display.InteractiveObject;
	 
	 import flash.media.Video;
	 import flash.media.SoundTransform;
	 
	 import flash.events.Event;
	 import flash.events.EventDispatcher;
	 import flash.events.NetStatusEvent;
	 import flash.events.SecurityErrorEvent;
	 import flash.events.AsyncErrorEvent;
	 import flash.events.IOErrorEvent;
	 import flash.events.MouseEvent;
	 
	 import flash.net.NetConnection;
	 import flash.net.NetStream;
	 
	 import flash.text.TextField;
	 import flash.text.TextFieldAutoSize;
	 	 
	 public class BasicVideoPlayer extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const VIDEO_READY:String = "Video.Ready";						// triggered when this video player is ready for playing
		public static const VIDEO_START:String = "Video.Start";						// triggered when a video starts to play - from calling Video.play();
		public static const VIDEO_PLAY:String = "Video.Play";							// triggered when a video starts to play - from clicking BTN_PLAY
		public static const VIDEO_DONE:String = "Video.Done";						// triggered when a video automatically stops playing for its entirety
		public static const VIDEO_STOP:String = "Video.Stop";							// triggered when a video stops playing, regardless of forced (stop button) or auto (finished)
		public static const VIDEO_PAUSE:String = "Video.Pause";						// triggered when a video is paused
		public static const VIDEO_MUTE:String = "Video.Mute";							// triggered when video sound is muted
		public static const VIDEO_UNMUTE:String = "Video.Unmute";					// triggered when video sound is unmuted
		public static const VIDEO_DESTROYED:String = "Video.Destroyed";		// triggered when this video player is destroyed and not functional
		
		private const GAP_BETWEEN_BUTTONS:int = 6;									// gap between each videoplayer button in pixels
		private const IDLE_TIME:int = 5;														// the idle time in seconds before buttons autohide
		
		private const INFO_TXT:String = "<p align='left'><font face='_sans' size='10' color='%3'>Loading... %0%\nLoaded %1Kb\nTotal %2Kb</font></p>";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _func:Function;
		private var _playcheckfunc:Function;
		private var _loadingfunc:Function;
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _soundtransform:SoundTransform;
		private var _ispaused:Boolean;
		
		private var _btn_align_y:int = 0;
		private var _btn_assigned:Boolean;
		private var _idle_counter:int;
		private var _idleframes:int;
		
		private var _video:Video;
		private var _infotext:TextField;
		private var _controllayer:Sprite;

		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		// Video parameters
		public var VIDEO_URL:String;										// location of the video
		public var VIDEO_WIDTH:int;										// width of the video
		public var VIDEO_HEIGHT:int;										// height of the video
		public var VIDEO_DURATION:Number;							// duration of the video - obtained from MetaData
		public var VIDEO_DURATION2:Number;							// duration of the video - obtained after playing thru the flv
		public var VIDEO_FPS:Number;										// framerate of the video
		public var VIDEO_TIMESTART:Number;							// video starts from this timestamp (in seconds)
		public var VIDEO_TIMEEND:Number;								// video ends at this timestamp (in seconds)
		public var VIDEO_INFO_TEXTCOLOR:String = "#FFFFFF";	// textcolor of the info text that appears when a video is loading
		
		// ########## Assign these values before init() is called
		// Buttons for videoplayer
		public var BTN_PLAY:InteractiveObject;
		public var BTN_STOP:InteractiveObject;
		public var BTN_PAUSE:InteractiveObject;
		public var BTN_REWIND:InteractiveObject;
		public var BTN_MUTE:InteractiveObject;
		public var BTN_UNMUTE:InteractiveObject;
		
		// These values should be set before init() is called.
		public var ID:int;															// unique id to identify an instance of this video player
		public var USE_BUTTONS:Boolean = false; 						// true if playback controls are to be used. false - no playback controls
		public var ARRANGE_BUTTONS:Boolean = true; 				// if true, buttons will be auto arranged to the bottom of the clip
		public var AUTO_FADE:Boolean = true; 							// if true, player controls will auto fade after IDLE_TIME seconds
		public var SHOW_INFO:Boolean = true; 							// shows the loading info if true
		public var SILENT:Boolean = false;								// if true, video will play without sound
		// ########## End
		
		public var DISPATCHER:EventDispatcher; 						// add your listeners to this
				
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function BasicVideoPlayer():void {
			VIDEO_URL = "";
			ID = -1;
			_btn_assigned = false;
			_func = idleFunction;
			_playcheckfunc = idleFunction;
			_loadingfunc = idleFunction;
			DISPATCHER = new EventDispatcher();
			_infotext = new TextField();
			_infotext.mouseEnabled = false;
			_infotext.selectable = false;
			_infotext.autoSize = TextFieldAutoSize.LEFT;
			_infotext.htmlText = "";
			_ispaused = false;
			_controllayer = new Sprite();
			addEventListener(Event.ENTER_FRAME, efFunction);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			// sets up connection, stream and video objects
			if (!_connection) {
				_connection = new NetConnection();
				_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
   	        _connection.connect(null);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Loads the video this player is playing and plays it;
		 * @param		p_url			String 		Location of the flv file to be played
		 * @param		p_width		int 			width of the flv
		 * @param		p_height	int 			height of the flv
		 * @param		p_start		Number 		Start time boundary of the video (ignored if 0) 
		 			Note that if you use this feature, the accuracy of the video seeking will be restricted by the keyframes present in the video. 
					This problem was observed in g1143 where a large video file is used and timestamps were marked for the game engine to jump to for various trivia questions. 
					The keyframes in the video did not allow flash video player to jump to specified timestamps accurately.
		 * @param		p_end		Number 		End time boundary of the video (ignored if 0)
		 */ 		
		public function loadAndPlay(p_url:String, p_width:int = 320, p_height:int= 240, p_start:Number = 0, p_end:Number = 0):void {
			if (p_url != "") {
				_ispaused = false;
				VIDEO_URL = p_url;
				VIDEO_WIDTH = p_width;
				VIDEO_HEIGHT = p_height;
				VIDEO_DURATION2 = 0;
				VIDEO_TIMESTART = p_start;
				VIDEO_TIMEEND = p_end;
				_infotext.htmlText = "";
				if ((_connection) && (_stream) && (_video)) _func = checkInit; // if all components are created, proceed with play
			}
		}
		
		/**
		 * @Note: Called by _stream when metadata from the FLV comes in.
		 * @param		p_info		Object 		The object that holds all the data
		 */ 				 
		public function onMetaDataFunc(p_info:Object):void {
			VIDEO_DURATION = p_info.duration;
			VIDEO_FPS = p_info.framerate;
			//trace("MetaData - duration:" + VIDEO_DURATION + " fps: " + VIDEO_FPS);
		}
		
		public function onCuePointFunc(p_obj:Object):void {}
		
		/**
		 * @Note: Close all connections made for playing the current video. Init will have to be called again to play a video
		 */ 				 
		public function cleanUp():void {
			if (_stream) {
				unmuteVideo();
				_stream.close();
				_connection.close();
				/*_stream.client.onMetaData = null;
				_stream.client.onCuePoint = null;
				_stream.client = null;*/
				_soundtransform = null;
				_video.clear();
				if (USE_BUTTONS) {
					BTN_PLAY.visible = BTN_PAUSE.visible = BTN_STOP.visible = BTN_REWIND.visible = BTN_MUTE.visible = BTN_UNMUTE.visible = false;
				}
			}
		}
		
		/**
		 * @Note: Adds a button to the controllayer displaycontainer. This is optional. Used when the button isn't already on the stage and needs a place for display.
		 * @param			p_button		InteractiveObject		The button to be inserted.
		 */ 				 
		public function insertButton(p_button:InteractiveObject):void {
			_controllayer.addChild(p_button);
		}
		
		/**
		 * @Note: Plays the current streamed video
		 */ 				 
		public function playVideo():void {
			if (VIDEO_URL != "") {
				(_ispaused)? _stream.resume(): _stream.play(VIDEO_URL);
				if (SILENT) {
					muteVideo();
				}/* else {
					if (!_ispaused) unmuteVideo();
				}*/
				_ispaused = false;
				if (VIDEO_TIMEEND > 0) _playcheckfunc = checkStopTime;
				announceEvent(VIDEO_PLAY);
			}
		}
		
		/**
		 * @Note: Rewinds the current streamed video back to the beginning
		 */ 				 
		public function rewindVideo():void {
			(VIDEO_TIMESTART > 0)? seekVideo(VIDEO_TIMESTART): seekVideo(0);
		}
		
		/**
		 * @Note: Pauses the current streamed video
		 */ 				 
		public function pauseVideo():void {
			if (VIDEO_URL != "") {
				_stream.pause();
				_ispaused = true;
				announceEvent(VIDEO_PAUSE);
			}
		}
		
		/**
		 * @Note: Stops the current streamed video
		 */ 				 
		public function stopVideo():void {
			if (VIDEO_URL != "") {
				_playcheckfunc = idleFunction;
				(VIDEO_TIMESTART > 0)? seekVideo(VIDEO_TIMESTART): seekVideo(0);
				_stream.pause();
				_ispaused = false;
				announceEvent(VIDEO_STOP);
			}
		}
		
		/**
		 * @Note: Turns off sound
		 */ 				 
		public function muteVideo():void {
			soundVolume(0);
			announceEvent(VIDEO_MUTE);
		}
		
		/**
		 * @Note: Turns on sound
		 */ 				 
		public function unmuteVideo():void {
			soundVolume(1);
			announceEvent(VIDEO_UNMUTE);
		}
		
		/**
		 * @Note: Goes to a point in the video
		 * @param		p_start		Number 		Start time boundary of the video (ignored if 0)
		 */ 				 
		public function seekVideo(p_start:Number):void {
			_stream.seek(p_start);
		}
		
		/**
		 * @Note: Replays a video
		 */ 				 
		public function restartVideo():void {
			playVideo();
			rewindVideo();
		}
		
		
		public function clearScreen():void {
			_video.clear();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: When this object is removed from the stage, automatically destroy itself
		 */ 		
		private function removedHandler(e:Event):void {
			destructor();
		}
		
		/**
		 * @Note: Enterframe event handler
		 */ 		
		private function efFunction(e:Event):void {
			_loadingfunc();
			_func();
			_playcheckfunc();
		}
		
		/**
		 * @Note: Event called when a video connection attempt is made
		 */ 		
		private function netStatusHandler(e:NetStatusEvent):void {
			switch (e.info.code) {
				case "NetConnection.Connect.Success": // video is found. Proceed to play
					connectStream();
					break;
					
				case "NetStream.Play.StreamNotFound": // no file found at location
					trace("Video URL invalid: " + VIDEO_URL);
					break;
					
				case "NetStream.Play.Start": // video starts playing
					//trace("NetStream - video starts");
					announceEvent(VIDEO_START);
					if (BTN_PLAY) BTN_PLAY.visible = false;
					if (BTN_PAUSE) BTN_PAUSE.visible = true;
					break;
					
				case "NetStream.Play.Stop": // video stops
					//trace("NetStream - video done playing");
					if (VIDEO_DURATION2 == 0) VIDEO_DURATION2 = _stream.time; // obtain the actual video duration
					trace ("VIDEO_DURATION2: "+VIDEO_DURATION2, _stream.time, _stream.bufferTime);
					//Viv: temp fix to avoid stop being called too early. TODO investigate in a more elegant and universal solution
					if (_stream.time > 5){
						stopHandler(null);
						announceEvent(VIDEO_DONE);
						rewindVideo();
					} else {
					  trace ("oops");
					}
					
					break;
					
				case "NetConnection.Connect.Closed": // the netconnection is closed.
					//trace("NetConnection - close Successful");
					break;
				case "NetStream.Play.Failed":
					trace("playing the video failed");
					break;
			}
		}
		
		/**
		 * @Note: Security event for video connection
		 */ 		
		private function securityErrorHandler(e:SecurityErrorEvent):void {trace("SecurityErrorEvent: " + e);}

		/**
		 * @Note: Synchronous error event for video connection; Do Nothing
		 */ 		
		private function asyncErrorHandler(e:AsyncErrorEvent):void {}
		
		/**
		 * @Note: Button handler for PLAY
		 */ 		
		private function playHandler(e:MouseEvent):void {
			if ((VIDEO_URL != "") && (BTN_PLAY.alpha > 0)) {
				playVideo();
				if (BTN_PLAY) BTN_PLAY.visible = false;
				if (BTN_PAUSE) BTN_PAUSE.visible = true;
			} else {
				mouseMoveHandler(null);
			}
		}

		/**
		 * @Note: Button handler for STOP
		 */ 		
		private function stopHandler(e:MouseEvent):void {
			if (VIDEO_URL != "") {
				stopVideo();
				trace("stop handler");
				if ((USE_BUTTONS) && (BTN_STOP.alpha > 0)) {
					if (BTN_PLAY) BTN_PLAY.visible = true;
					if (BTN_PAUSE) BTN_PAUSE.visible = false;
				}
			} else {
				trace("stop handler2");
				mouseMoveHandler(null);
			}
		}

		/**
		 * @Note: Button handler for PAUSE
		 */ 		
		private function pauseHandler(e:MouseEvent):void {
			if (VIDEO_URL != "") {
				pauseVideo();
				if ((USE_BUTTONS) && (BTN_PAUSE.alpha > 0)) {
					if (BTN_PLAY) BTN_PLAY.visible = true;
					if (BTN_PAUSE) BTN_PAUSE.visible = false;
				}
			} else {
				mouseMoveHandler(null);
			}
		}

		/**
		 * @Note: Button handler for REWIND
		 */ 		
		private function rewindHandler(e:MouseEvent):void {
			if (BTN_REWIND.alpha > 0) {
				rewindVideo();
			} else {
				mouseMoveHandler(null);
			}
		}

		/**
		 * @Note: Button handler for MUTE
		 */ 		
		private function muteHandler(e:MouseEvent):void {
			if (BTN_MUTE.alpha > 0) {
				muteVideo();
				if (BTN_MUTE) BTN_MUTE.visible = false;
				if (BTN_UNMUTE) BTN_UNMUTE.visible = true;
			} else {
				mouseMoveHandler(null);
			}
		}

		/**
		 * @Note: Button handler for UNMUTE
		 */ 		
		private function unmuteHandler(e:MouseEvent):void {
			if (BTN_UNMUTE.alpha > 0) {
				unmuteVideo();
				if (BTN_MUTE) BTN_MUTE.visible = true;
				if (BTN_UNMUTE) BTN_UNMUTE.visible = false;
			} else {
				mouseMoveHandler(null);
			}
		}
		
		/**
		 * @Note: When the mouse moves
		 */ 		
		private function mouseMoveHandler(e:MouseEvent):void {
			if ((AUTO_FADE) && (_func != checkInit)) _func = checkIdle;
			_idle_counter = 1;
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Do nothing
		 */ 		
		private function idleFunction():void {}
		
		/**
		 * @Note: Check for how long the mouse has been idle
		 */ 		
		private function checkIdle():void {
			_idle_counter = (_idle_counter + 1) % _idleframes;
			if (_idle_counter == 0) {
				_func = fadeOutButtons;
			} else {
				fadeInButtons();
			}
		}
		
		/**
		 * @Note: Checks that all displayobjects are initialized.
		 */ 		
		private function checkInit():void {
			for (var c:int = 0; c < numChildren; c ++) if (!getChildAt(c)) return;
			_idle_counter = 1;
			_idleframes = _video.loaderInfo.frameRate * IDLE_TIME;
			((USE_BUTTONS) && (AUTO_FADE))? _func = checkIdle: _func = idleFunction;
			announceEvent(VIDEO_READY);
			_video.x = -VIDEO_WIDTH / 2;
			_video.y = -VIDEO_HEIGHT / 2;
			_video.width = VIDEO_WIDTH;
			_video.height = VIDEO_HEIGHT;
			//trace("VIDEO_URL " + VIDEO_URL);
			_infotext.x = _video.x;
			_infotext.y = _video.y;
			if (VIDEO_URL != "") {
				playVideo();
				rewindVideo();
				_infotext.htmlText = "";
				if (SHOW_INFO) _loadingfunc = loadingFunction;
			}
			if (USE_BUTTONS) {
				_btn_align_y = int((_video.height / 2) + (BTN_PLAY.height / 2) + GAP_BETWEEN_BUTTONS);
				try {
					assignButtonControls();
				} catch (e:Error) {}
			}
		}
		
		/**
		 * @Note: When a connection is establised, stream is created and attached to the video object for playing; Called from netStatusHandler();
		 */ 		
		private function connectStream():void {
			if (!_stream) {
	            _stream = new NetStream(_connection);
				_stream.client = {};
				_stream.client.onMetaData = onMetaDataFunc;
				_stream.client.onCuePoint = onCuePointFunc;
	            _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
    	        _stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				//_stream.bufferTime = 10;
			}
			if (!_video) {
	            _video = new Video();
    	        _video.attachNetStream(_stream);
				addChild(_infotext);
	            addChild(_video);
				addChild(_controllayer);
			}
			if (VIDEO_URL != "") _func = checkInit; // proceed to play if there is a video to play
		}
		
		/**
		 * @Note: Assign button event handlers to the video player buttons
		 */ 		
		private function assignButtonControls():void {
			if (!_btn_assigned) {
				BTN_PLAY.addEventListener(MouseEvent.MOUSE_DOWN, playHandler);
				BTN_STOP.addEventListener(MouseEvent.MOUSE_DOWN, stopHandler);
				BTN_PAUSE.addEventListener(MouseEvent.MOUSE_DOWN, pauseHandler);
				BTN_REWIND.addEventListener(MouseEvent.MOUSE_DOWN, rewindHandler);
				BTN_MUTE.addEventListener(MouseEvent.MOUSE_DOWN, muteHandler);
				BTN_UNMUTE.addEventListener(MouseEvent.MOUSE_DOWN, unmuteHandler);
			
				BTN_PLAY.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_STOP.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_PAUSE.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_REWIND.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_MUTE.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_UNMUTE.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				_btn_assigned = true;
			}

			// aligning the buttons
			if (ARRANGE_BUTTONS) {
				BTN_PLAY.y = _btn_align_y;
				BTN_PAUSE.y = _btn_align_y;
				BTN_STOP.y = _btn_align_y;
				BTN_REWIND.y = _btn_align_y;
				BTN_MUTE.y = _btn_align_y;
				BTN_UNMUTE.y = _btn_align_y;
				
				BTN_STOP.x = -(BTN_STOP.width / 2) - (GAP_BETWEEN_BUTTONS / 2);
				BTN_REWIND.x = (GAP_BETWEEN_BUTTONS / 2) + (BTN_REWIND.width / 2);
				BTN_PLAY.x = BTN_STOP.x - (BTN_STOP.width / 2) - GAP_BETWEEN_BUTTONS - (BTN_PLAY.width / 2);
				BTN_PAUSE.x = BTN_PLAY.x;
				BTN_MUTE.x = BTN_REWIND.x + (BTN_REWIND.width / 2) + GAP_BETWEEN_BUTTONS + (BTN_MUTE.width / 2);
				BTN_UNMUTE.x = BTN_MUTE.x;
			}
			// done
			
			BTN_PLAY.alpha = BTN_PAUSE.alpha = BTN_STOP.alpha = BTN_REWIND.alpha = BTN_MUTE.alpha = BTN_UNMUTE.alpha = 0;
			BTN_PLAY.visible = false;
			BTN_PAUSE.visible = true;
			
			if (_stream.soundTransform.volume <=0){
				BTN_UNMUTE.visible = true;
				BTN_MUTE.visible = false;
			} else {
				BTN_UNMUTE.visible = false;
				BTN_MUTE.visible = true;
			}
			
			BTN_STOP.visible = true;
			BTN_REWIND.visible = true;
		}
		
		/**
		 * @Note: Remove button event handlers from the video player buttons
		 */ 		
		private function removeButtonControls():void {
			if (_btn_assigned) {
				BTN_PLAY.removeEventListener(MouseEvent.MOUSE_DOWN, playHandler);
				BTN_STOP.removeEventListener(MouseEvent.MOUSE_DOWN, stopHandler);
				BTN_PAUSE.removeEventListener(MouseEvent.MOUSE_DOWN, pauseHandler);
				BTN_REWIND.removeEventListener(MouseEvent.MOUSE_DOWN, rewindHandler);
				BTN_MUTE.removeEventListener(MouseEvent.MOUSE_DOWN, muteHandler);
				BTN_UNMUTE.removeEventListener(MouseEvent.MOUSE_DOWN, unmuteHandler);
				
				BTN_PLAY.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_STOP.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_PAUSE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_REWIND.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_MUTE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				BTN_UNMUTE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				_btn_assigned = false;
			}
		}
		
		/**
		 * @Note: Player control buttons fade in upon activity
		 */ 		
		private function fadeInButtons():void {
			if ((USE_BUTTONS) && (BTN_PLAY.alpha < 1)) {
				BTN_PLAY.alpha += 0.2;
				BTN_STOP.alpha = BTN_PAUSE.alpha = BTN_REWIND.alpha = BTN_MUTE.alpha = BTN_UNMUTE.alpha = BTN_PLAY.alpha;
			}
		}
		
		/**
		 * @Note: Player control buttons fade out when idle
		 */ 		
		private function fadeOutButtons():void {
			if ((USE_BUTTONS) && (BTN_PLAY.alpha > 0)) {
				BTN_PLAY.alpha -= 0.1;
				BTN_STOP.alpha = BTN_PAUSE.alpha = BTN_REWIND.alpha = BTN_MUTE.alpha = BTN_UNMUTE.alpha = BTN_PLAY.alpha;
			} else {
				_func = idleFunction;
			}
		}
		
		/**
		 * @Note: Changes the sound volume of the NetStream
		 * @param		p_vol		Number 		Volume desired. Range: 0 (silent) -> 1 (full volume)
		 */ 		
		private function soundVolume(p_vol:Number):void {
			_soundtransform = _stream.soundTransform;
			_soundtransform.volume = p_vol;
			_stream.soundTransform = _soundtransform;
		}
		
		/**
		 * @Note: Dispatches an event using DISPATCHER
		 * @param		p_event			String 		The event to be dispatched
		 */ 		
		protected function announceEvent(p_event:String):void {
			DISPATCHER.dispatchEvent(new Event(p_event));
			//trace("### [BasicVideoPlayer] Announce Event: " + p_event);
		}
		
		/**
		 * @Note: Replaces a particular text in a string to another text
		 * @param		poriginal		String 		The string where the to-be-replaced string resides.
		 * @param		preplace			String 		The text to be replaced
		 * @param		ptext				String 		The new text to replace preplace
		 * @return		String			The new string
		 */ 		
		private function replaceToken(poriginal:String, preplace:String, ptext:String):String {
			var res:String = "";
			var strlength:int = poriginal.length;
			var rlength:int = preplace.length;
			var lastp:int = strlength - rlength;
			var i:int = 0;
			var lastbreak:int = 0;
			if ((poriginal != null) && (poriginal.length > 0)) {
				while (i <= lastp) {
					if (poriginal.substr(i, rlength) == preplace) { // match
						res += poriginal.substr(lastbreak, i - lastbreak) + ptext;
						i += rlength;
						lastbreak = i;
					} else { // not a match
						i ++
					}
				}
				res += poriginal.substr(lastbreak, strlength - lastbreak);
			} else {res = ptext;} // return the ptext string if poriginal is non-existent
			return res;
		}

		/**
		 * @Note: Checks if a predetermined endtime has been reached. If reached, stop video and fire VIDEO_DONE event.
		 */ 		
		private function checkStopTime():void {
			if (_stream.time >= VIDEO_TIMEEND) {
				announceEvent(VIDEO_DONE);
				stopHandler(null);
				//rewindVideo();
			}
		}
		
		/**
		 * @Note: Provides feedback for percentage amount video has loaded.
		 */ 		
		private function loadingFunction():void {
			var loadval:Number = 0, str = INFO_TXT;
			if (_stream) {
				if (_stream.bytesTotal > 0) {
					loadval = _stream.bytesLoaded / _stream.bytesTotal;
					str = replaceToken(str, "%0", int(loadval * 100).toString());
					str = replaceToken(str, "%1", int(_stream.bytesLoaded / 1024).toString());
					str = replaceToken(str, "%2", int(_stream.bytesTotal / 1024).toString());
					str = replaceToken(str, "%3", VIDEO_INFO_TEXTCOLOR);
					_infotext.htmlText = str;
					if (loadval == 1) {
						_infotext.htmlText = "";
						_loadingfunc = idleFunction;
					}
				}
			} else {
				_loadingfunc = idleFunction;
			}
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			//trace("Basic Video Player destroyed");
			announceEvent(VIDEO_DESTROYED);
			ID = -1;
			try {
				removeButtonControls();
			} catch (e:Error) {}
			BTN_PLAY = null;
			BTN_STOP = null;
			BTN_PAUSE = null;
			BTN_REWIND = null;
			BTN_MUTE = null;
			BTN_UNMUTE = null;
			
			if (_stream) {
				removeChild(_video);
				removeChild(_infotext);
	            _stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
    	        _stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_stream.close();
				_connection.close();
				_stream.client.onMetaData = null;
				_stream.client.onCuePoint = null;
				_stream.client = null;
			}
			while (_controllayer.numChildren > 0) {
				_controllayer.removeChild(_controllayer.getChildAt(0));
			}
			removeChild(_controllayer);
			_controllayer = null;
			_infotext = null;
			_soundtransform = null;
			_stream = null;
			_connection = null;
			_video = null;
			DISPATCHER = null;
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			removeEventListener(Event.ENTER_FRAME, efFunction);
			_func = null;
		}
	}
}