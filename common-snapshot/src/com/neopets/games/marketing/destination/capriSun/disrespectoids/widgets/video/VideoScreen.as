/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.video
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.video.VideoLink;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.display.IconLoader
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.video.VideoManager;
	import com.neopets.util.servers.NeopetsAmfManager;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class VideoScreen extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const VIDEO_STARTED:String = "video_started";
		public static const VIDEO_DONE:String = "video_done";
		public static const VIDEO_STOPPED:String = "video_stopped";
		public static const VIDEO_PAUSED:String = "video_paused";
		// control events
		public static const PAUSE_VIDEO:String = "pause_video_request";
		public static const RESUME_VIDEO:String = "resume_video_request";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _playerID:int = -1;
		protected var _videoPlayer:MovieClip;
		protected var _videoArea:DisplayObject;
		protected var _currentVideo:VideoLink;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoScreen():void {
			super();
			// check for components
			_videoArea = getChildByName("video_area_mc");
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up the video player
			createVideoPlayer();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(VideoLink.VIDEO_REQUESTED,onVideoRequest);
				_sharedDispatcher.removeEventListener(DestinationView.LOAD_PAGE_REQUEST,onPageLoad);
				_sharedDispatcher.removeEventListener(PAUSE_VIDEO,onPauseVideoRequest);
				_sharedDispatcher.removeEventListener(RESUME_VIDEO,onResumeVideoRequest);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(VideoLink.VIDEO_REQUESTED,onVideoRequest);
				_sharedDispatcher.addEventListener(DestinationView.LOAD_PAGE_REQUEST,onPageLoad);
				_sharedDispatcher.addEventListener(PAUSE_VIDEO,onPauseVideoRequest);
				_sharedDispatcher.addEventListener(RESUME_VIDEO,onResumeVideoRequest);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
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
				// set up listeners
				vids.addEventListener(VideoManager.VIDEO_DONE,onVideoDone);
				vids.addEventListener(VideoManager.VIDEO_STOP,onVideoStopped);
				// initialize the player
				if(_videoPlayer != null) {
					vids.playerParameters(_playerID,false);
					addChild(_videoPlayer);
					// check if there's a loading area
					if(_videoArea != null) {
						_videoPlayer.x = _videoArea.x;
						_videoPlayer.y = _videoArea.y;
					}
				}
			}
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Stop the video when the page changes.
		
		protected function onPageLoad(ev:Event) {
			var vids:VideoManager = VideoManager.instance;
			vids.getPlayerInstance(_playerID).stopVideo();
		}
		
		// If we get a resume video request, tell the manager to handle it.
		
		protected function onResumeVideoRequest(ev:Event) {
			var vids:VideoManager = VideoManager.instance;
			vids.getPlayerInstance(_playerID).playVideo();
			broadcast(VIDEO_STARTED);
		}
		
		// If we get a stop video request, tell the manager to handle it.
		
		protected function onPauseVideoRequest(ev:Event) {
			var vids:VideoManager = VideoManager.instance;
			vids.getPlayerInstance(_playerID).pauseVideo();
			broadcast(VIDEO_PAUSED);
		}
		
		// When the video is done, let php know.
		
		protected function onVideoDone(ev:Event) {
			// send out tracking
			if(_currentVideo != null) {
				broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,_currentVideo.neocontentID);
				broadcast(DestinationView.ADLINK_REQUEST,"Caprisun2010 Webisode" + _currentVideo.IDNumber);
			}
			broadcast(DestinationView.SHOP_AWARD_REQUEST,"4");
			// send out activity alert
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("CapriSun2010Service.recordActivity",responder,"act10");
			// let listeners know the video finished
			broadcast(VIDEO_DONE);
		}
		
		// When the video is stopped, let listeners know.
		
		protected function onVideoStopped(ev:Event) {
			broadcast(VIDEO_STOPPED);
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordResult(msg:Object):void {
			trace("onRecordResult: " + msg);
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordFault(msg:Object):void {
			trace("onRecordFault: " + msg);
		}
		
		// When a video is requested, start playing it.
		
		protected function onVideoRequest(ev:BroadcastEvent) {
			var link:VideoLink = ev.sender as VideoLink;
			if(link == null) return;
			// store new video
			_currentVideo = link;
			// show video
			if(_videoPlayer != null) {
				var vid_path:String = link.videoURL;
				if(vid_path != null) {
					var vids:VideoManager = VideoManager.instance;
					vids.loadAndPlay(_playerID,vid_path,link.videoWidth,link.videoHeight);
					broadcast(VIDEO_STARTED);
				}
			}
		}

	}
	
}