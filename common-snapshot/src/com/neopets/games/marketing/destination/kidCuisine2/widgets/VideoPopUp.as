/**
 *	This pop-up shows the destination's video trailer.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.08.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.EventHub;
	import com.neopets.games.marketing.destination.kidCuisine2.utils.RelayedEvent;
	import com.neopets.games.marketing.destination.kidCuisine2.pages.TrainingPage;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.video.VideoManager;
	
	public class VideoPopUp extends MessagePopUp
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const POPUP_ID:String = "VideoPlayer_PopUp";
		public static const NEOCONTENT_ID:int = 15613;
		public static const TRACKING_SCRIPT:String = "Training Room Krazy Combos - Video Views";
		// protected variables
		protected var musicStopped:Boolean;
		protected var _playerID:int = -1;
		protected var _videoPlayer:MovieClip;
		// video parameters
		public var highVideoURL:String = "http://images.neopets.com/sponsors/trailers/kc_krazycombos_high_v1.flv";
		public var highVideoWidth:int = 480;
		public var highVideoHeight:int = 360;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoPopUp():void {
			super();
			musicStopped = false;
			// hide the pop-up
			visible = false;
			// set up the video player
			createVideoPlayer();
			// set up listeners
			EventHub.addEventListener(PopUpCallButton.POPUP_REQUESTED,onPopUpRequest);
			// clear close sound
			closeSound = null;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	Takes the pop up off screen.
		 **/
		
		public function hide():void {
			visible = false;
			if(musicStopped) {
				// turn music on
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(TrainingPage.ROOM_MUSIC,true);
				sounds.changeSoundVolume(TrainingPage.ROOM_MUSIC,1);
				musicStopped = false;
			}
			// stop video
			if(_videoPlayer != null) _videoPlayer.stopVideo();
		}
		
		/**	
		 *	Moves the pop up on screen.
		 **/
		
		public function show():void {
			visible = true;
			// turn music off
			var sounds:SoundManager = SoundManager.instance;
			sounds.stopSound(TrainingPage.ROOM_MUSIC);
			sounds.changeSoundVolume(TrainingPage.ROOM_MUSIC,0);
			musicStopped = true;
			// run tracking
			NeoTracker.instance.trackNeoContentID(NEOCONTENT_ID);
			runJavaScript(TRACKING_SCRIPT);
			// show video
			if(_videoPlayer != null) {
				var vids:VideoManager = VideoManager.instance;
				vids.loadAndPlay(_playerID,highVideoURL,highVideoWidth,highVideoHeight);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**	
		 *	Adds the video player to this pop up.
		 **/
		 
		protected function createVideoPlayer():void {
			if(_videoPlayer == null) {
				// ask the video manager for a player
				var vids:VideoManager = VideoManager.instance;
				_playerID = vids.createVideoPlayer();
				_videoPlayer = vids.getPlayerInstance(_playerID);
				// initialize the player
				if(_videoPlayer != null) {
					vids.playerParameters(_playerID,false);
					addChild(_videoPlayer);
					// check if there's a loading area
					var area:MovieClip = getChildByName("video_area_mc") as MovieClip;
					if(area != null) {
						var origin:Point = new Point(area.x,area.y);
						origin = localToGlobal(origin);
						_videoPlayer.x = origin.x;
						_videoPlayer.y = origin.y;
					}
				}
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**	
		 *	This function tries to close the pop up.
		 *	@PARAM		ev		Optional: event which triggered the close request
		 **/
		
		override public function onCloseRequest(ev:Event=null):void {
			hide();
			if(closeSound != null) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(closeSound);
			}
		}
		
		/**	
		 *	This function is triggered when a pop-up request is dispatched.
		 *	@PARAM		ev		Optional: event which triggered the request
		 **/
		
		public function onPopUpRequest(ev:RelayedEvent) {
			var caller:Object = ev.source;
			if("popUpID" in caller) {
				if(caller.popUpID == POPUP_ID) show();
				else hide();
			}
		}
		
	}
	
}