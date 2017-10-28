/* AS3
	Copyright 2009
*/

package com.neopets.util.video {
	
	
	/**
	 *	Video Player Manager for Neopets. Singleton design.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  8.11.2009
	 */	
	 
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.events.CustomEvent;
	
	public class VideoManager extends EventDispatcher {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private static const _instance:VideoManager = new VideoManager(SingletonEnforcer);
		
		// Events
		public static const VIDEO_READY:String = "Video.Ready";						// triggered when this video player is ready for playing
		public static const VIDEO_START:String = "Video.Start";						// triggered when a video starts to play - from calling Video.play();
		public static const VIDEO_PLAY:String = "Video.Play";							// triggered when a video starts to play - from clicking BTN_PLAY
		public static const VIDEO_DONE:String = "Video.Done";						// triggered when a video automatically stops playing for its entirety
		public static const VIDEO_STOP:String = "Video.Stop";							// triggered when a video stops playing, regardless of forced (stop button) or auto (finished)
		public static const VIDEO_PAUSE:String = "Video.Pause";						// triggered when a video is paused
		public static const VIDEO_MUTE:String = "Video.Mute";							// triggered when video sound is muted
		public static const VIDEO_UNMUTE:String = "Video.Unmute";					// triggered when video sound is unmuted
		public static const VIDEO_DESTROYED:String = "Video.Destroyed";		// triggered when this video player is destroyed and not functional
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _vplist:Array;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function VideoManager(singletonEnforcer:Class = null):void {
			if(singletonEnforcer != SingletonEnforcer) {
				throw new Error("[VideoManager] Invalid Singleton access. Use VideoManager.instance.");
			} else {
				initiate();
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Note: Returns an instance of this
		 */ 		
		public static function get instance():VideoManager {
			return _instance;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Creates a new instance of the video player
		 * @return		int				An id identifying the videoplayer
		 */ 		
		public function createVideoPlayer():int {
			var i:int = 0;
			while (_vplist[i]) i ++;
			_vplist[i] = new BasicVideoPlayer();
			_vplist[i].ID = i;
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_READY, videoReadyHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_START, videoStartHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_PLAY, videoPlayHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_DONE, videoDoneHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_STOP, videoStopHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_PAUSE, videoPauseHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_MUTE, videoMuteHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_UNMUTE, videoUnmuteHandler);
			_vplist[i].DISPATCHER.addEventListener(BasicVideoPlayer.VIDEO_DESTROYED, videoDestroyedHandler);
			return i;
		}
		
		/**
		 * @Note: Destroys a video player instance
		 * @param		p_id			int 		The unique id that identifies the video player instance. (obtainable from BasicVideoPlayer._id)
		 */ 		
		public function destroyVideoPlayer(p_id:int):void {
			if ((_vplist[p_id]) && (_vplist[p_id].ID == p_id)) {
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_READY, videoReadyHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_START, videoStartHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_PLAY, videoPlayHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_DONE, videoDoneHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_STOP, videoStopHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_PAUSE, videoPauseHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_MUTE, videoMuteHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_UNMUTE, videoUnmuteHandler);
				_vplist[p_id].DISPATCHER.removeEventListener(BasicVideoPlayer.VIDEO_DESTROYED, videoDestroyedHandler);
				_vplist[p_id].destructor();
				_vplist[p_id] = null;
			}
		}
		
		/**
		 * @Note: Returns the player instance identified by id
		 * @return		BasicVideoPlayer			The videoplayer instance identified by id
		 */ 		
		public function getPlayerInstance(p_id:int):BasicVideoPlayer {
			if (p_id >= _vplist.length) return null;
			return _vplist[p_id];
		}
		
		/**
		 * @Note: Loads the video a specified videoplayer and start playing
		 * @param		p_id			int 			ID of the videoplayer
		 * @param		p_url			String 		Location of the flv file to be played
		 * @param		p_width		int 			width of the flv
		 * @param		p_height	int 			height of the flv
		 * @param		p_start		Number 		Start time boundary of the video (ignored if 0) - See comments on BasicVideoPlayer.loadAndPlay()
		 * @param		p_end		Number 		End time boundary of the video (ignored if 0)
		 */ 		
		public function loadAndPlay(p_id:int, p_url:String, p_width:int = 320, p_height:int = 240, p_start:Number = 0, p_end:Number = 0):void {
			if ((p_id > -1) && (_vplist[p_id])) _vplist[p_id].loadAndPlay(p_url, p_width, p_height, p_start, p_end);
		}
		
		/**
		 * @Note: Passes parameters to a specific videoplayer. This should be done before any video is played on the videoplayer
		 * @param		p_id							int 			ID of the videoplayer
		 * @param		p_usebuttons				Boolean			If false, videoplayer will not have any control buttons
		 * @param		p_showinfo					Boolean			When true, shows loading info text on the videoplayer
		 * @param		p_silent						Boolean			When true, video plays without any sound
		 * @param		p_arrangebuttons		Boolean			When true, videoplayer controls will auto vertical arrange based on each button's reference point
		 * @param		p_autofade					Boolean			When true, videoplayer controls will auto fade out when idle
		 * @param		p_infocolor					String			Color of the info text appearing on the videoplayer during loading. eg. "#FFFFFF"
		 */ 		
		public function playerParameters(p_id:int, p_usebuttons:Boolean = true, p_showinfo:Boolean = true, p_silent:Boolean = false, p_arrangebuttons:Boolean = true, p_autofade:Boolean = true, p_infocolor:String = "#FFFFFF"):void {
			if ((p_id > -1) && (_vplist[p_id])) {
				_vplist[p_id].USE_BUTTONS = p_usebuttons;
				_vplist[p_id].SHOW_INFO = p_showinfo;
				_vplist[p_id].SILENT = p_silent;
				_vplist[p_id].ARRANGE_BUTTONS = p_arrangebuttons;
				_vplist[p_id].AUTO_FADE = p_autofade;
				_vplist[p_id].VIDEO_INFO_TEXTCOLOR = p_infocolor;
			}
		}
		
		/**
		 * @Note: Assigns classes of the buttons used for a specified videoplayer. Buttons will be auto instantiated and added into the videoplayer instance
		 * @param		p_id					int 				ID of the videoplayer
		 * @param		p_play				Class				Class name of the play button (superclass: SimpleButton)
		 * @param		p_pause				Class				Class name of the pause button (superclass: SimpleButton)
		 * @param		p_stop				Class				Class name of the stop button (superclass: SimpleButton)
		 * @param		p_rewind			Class				Class name of the rewind button (superclass: SimpleButton)
		 * @param		p_mute				Class				Class name of the mute button (superclass: SimpleButton)
		 * @param		p_unmute			Class				Class name of the unmute button (superclass: SimpleButton)
		 */ 		
		public function playerButtons(p_id:int, p_play:Class, p_pause:Class, p_stop:Class, p_rewind:Class, p_mute:Class, p_unmute:Class):void {
			if ((p_id > -1) && (_vplist[p_id])) {
				if (!p_play || !p_pause || !p_stop || !p_rewind || !p_mute || !p_unmute) _vplist[p_id].USE_BUTTONS = false; // do not use controls if even one is missing.
				if (_vplist[p_id].USE_BUTTONS) {
					var playbtn:* = new p_play();
					var pausebtn:* = new p_pause();
					var stopbtn:* = new p_stop();
					var rewindbtn:* = new p_rewind();
					var mutebtn:* = new p_mute();
					var unmutebtn:* = new p_unmute();
					_vplist[p_id].BTN_PLAY = playbtn as InteractiveObject;
					_vplist[p_id].BTN_PAUSE = pausebtn as InteractiveObject;
					_vplist[p_id].BTN_STOP = stopbtn as InteractiveObject;
					_vplist[p_id].BTN_REWIND = rewindbtn as InteractiveObject;
					_vplist[p_id].BTN_MUTE = mutebtn as InteractiveObject;
					_vplist[p_id].BTN_UNMUTE = unmutebtn as InteractiveObject;
					_vplist[p_id].insertButton(playbtn);
					_vplist[p_id].insertButton(pausebtn);
					_vplist[p_id].insertButton(stopbtn);
					_vplist[p_id].insertButton(rewindbtn);
					_vplist[p_id].insertButton(mutebtn);
					_vplist[p_id].insertButton(unmutebtn);
				}
			}
		}
		
		/**
		 * @Note: Destroys all instances of videoplayer
		 */ 		
		public function clearAll():void {
			for (var i:int = 0; i < _vplist.length; i ++) destroyVideoPlayer(i);
			_vplist.length = 0;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function videoReadyHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_READY);
		}

		protected function videoStartHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_START);
		}

		protected function videoPlayHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_PLAY);
		}

		protected function videoDoneHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_DONE);
		}

		protected function videoStopHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_STOP);
		}

		protected function videoPauseHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_PAUSE);
		}

		protected function videoMuteHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_MUTE);
		}

		protected function videoUnmuteHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			announceEvent(vid, VIDEO_UNMUTE);
		}

		protected function videoDestroyedHandler(e:Event):void {
			var vid:int = findDispatcherOwner(e.target as EventDispatcher);
			destroyVideoPlayer(vid);
			announceEvent(vid, VIDEO_DESTROYED);
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Announces an event for listeners
		 * @param		p_id			int				The videoplayer this event is originating from
		 * @param		p_event		String		The event to be sent
		 */ 		
		protected function announceEvent(p_id:int, p_event:String):void {
			dispatchEvent(new CustomEvent({ID:p_id}, p_event));
		}
		
		/**
		 * @Note: Class initiation. Run once only.
		 */
		protected function initiate():void {
			_vplist = [];
		}
		
		/**
		 * @Note: Looks for the videoplayer an event dispatcher belongs to, and returns its ID
		 * @param		p_ed			EventDispatcher 		The EventDispatcher in question. Used by video player event handlers
		 * @return		int				ID value of the videoplayer. -1 if not found
		 */
		private function findDispatcherOwner(p_ed:EventDispatcher):int {
			var i:int = 0;
			while (i < _vplist.length) {
				if ((_vplist[i]) && (_vplist[i].DISPATCHER == p_ed)) return i;
				i ++;
			}
			return -1;
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			clearAll();
			_vplist = null;
		}
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}




