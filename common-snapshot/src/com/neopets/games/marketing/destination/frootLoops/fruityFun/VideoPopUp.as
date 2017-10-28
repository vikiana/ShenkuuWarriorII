/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import com.neopets.util.video.VideoManager;
	import com.neopets.util.events.EventFunctions;
	
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.BasicPopUp;
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.VideoData;
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.LandingPage;
	
	public class VideoPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _playerID:int = -1;
		protected var _videoPlayer:MovieClip;
		protected var _highVideo:VideoData;
		protected var _lowVideo:VideoData;
		// components
		protected var _highButton:DisplayObject;
		protected var _lowButton:DisplayObject;
		protected var _videoArea:DisplayObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoPopUp():void {
			super();
			// set up linkage to parent
			useParentDispatcher(MovieClip);
			// set defaults
			_highVideo = new VideoData("http://images.neopets.com/sponsors/trailers/2010/frootloops_koi_high_v1.flv",320,240);
			_lowVideo = new VideoData("http://images.neopets.com/sponsors/trailers/2010/frootloops_koi_low_v1.flv",240,180);
			// get components
			highButton = getChildByName("high_btn");
			lowButton = getChildByName("low_btn");
			_videoArea = getChildByName("video_area_mc");
			// set up the video player
			createVideoPlayer();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get highButton():DisplayObject { return _highButton; }
		
		public function set highButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_highButton,dobj,MouseEvent.CLICK,onHighBandwidth);
			// store new component
			_highButton = dobj;
		}
		
		public function get lowButton():DisplayObject { return _lowButton; }
		
		public function set lowButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_lowButton,dobj,MouseEvent.CLICK,onLowBandWidth);
			// store new component
			_lowButton = dobj;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// stop the video when the pop up closes
		
		override public function close():void {
			if(visible) {
				// stop video
				var vids:VideoManager = VideoManager.instance;
				vids.getPlayerInstance(_playerID).stopVideo();
				// hide pop up
				visible = false;
				broadcast(POPUP_CLOSED);
			}
		}
		
		// show the video when the pop up opens.
		
		override public function open():void {
			if(!visible) {
				visible = true;
				broadcast(POPUP_OPENED);
				gotoBandwidth();
			}
		}
		
		// Use this function to play a video from it's data object.
		
		public function playVideo(info:VideoData):void {
			// hide video buttons
			if(_highButton != null) _highButton.visible = false;
			if(_lowButton != null) _lowButton.visible = false;
			// play the video
			if(_videoPlayer != null && info != null) {
				_videoPlayer.visible = true;
				var vids:VideoManager = VideoManager.instance;
				vids.loadAndPlay(_playerID,info.URL,info.width,info.height);
			}
			// call tracking
			broadcast(LandingPage.SEND_NEOCONTENT,16141);
		}
		
		// Use this function to go to the "select bandwidth" screen.
		
		public function gotoBandwidth():void {
			// show buttons
			if(_highButton != null) _highButton.visible = true;
			if(_lowButton != null) _lowButton.visible = true;
			// turn off video player
			if(_videoPlayer != null) {
				// stop video
				var vids:VideoManager = VideoManager.instance;
				vids.getPlayerInstance(_playerID).stopVideo();
				// hide video player
				_videoPlayer.visible = false;
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
				// set up listeners
				vids.addEventListener(VideoManager.VIDEO_START,onVideoStart);
				vids.addEventListener(VideoManager.VIDEO_DONE,onVideoDone);
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
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// send out tracking when the video starts
		
		protected function onVideoStart(ev:Event) {
			//omniture, google tracking
			if (ExternalInterface.available) {
				ExternalInterface.call("window.top.sendReportingCall","Community Hub Video","KellogsFruitLoops2010");
				trace("calling Community Hub Video");
			} else trace("ExternalInterfaceCall Not Available");
		}
		
		// when the video finishes, go back to "select bandwidth" screen
		
		protected function onVideoDone(ev:Event) {
			// award team points
			broadcast(LandingPage.AWARD_POINTS,{activity:"video",score:250});
			// return to "select bandwidth" screen
			gotoBandwidth();
		}
		
		// Video Button Listeners
		
		protected function onHighBandwidth(ev:Event) { playVideo(_highVideo); }
		
		protected function onLowBandWidth(ev:Event) { playVideo(_lowVideo); }
		
	}
	
}