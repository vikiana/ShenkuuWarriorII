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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.video.VideoScreen;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	
	public class VideoButton extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _clickCommand:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoButton():void {
			super();
			buttonMode = true;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up local listeners
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(VideoScreen.VIDEO_STARTED,onVideoStarted);
				_sharedDispatcher.removeEventListener(VideoScreen.VIDEO_DONE,onVideoStopped);
				_sharedDispatcher.removeEventListener(VideoScreen.VIDEO_STOPPED,onVideoStopped);
				_sharedDispatcher.removeEventListener(VideoScreen.VIDEO_PAUSED,onVideoStopped);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(VideoScreen.VIDEO_STARTED,onVideoStarted);
				_sharedDispatcher.addEventListener(VideoScreen.VIDEO_DONE,onVideoStopped);
				_sharedDispatcher.addEventListener(VideoScreen.VIDEO_STOPPED,onVideoStopped);
				_sharedDispatcher.addEventListener(VideoScreen.VIDEO_PAUSED,onVideoStopped);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When we're clicked on, broadcast our click command.
		
		protected function onClick(ev:Event) {
			if(_clickCommand != null) broadcast(_clickCommand);
		}
		
		// When the video starts, switch to "stop" mode.
		
		protected function onVideoStarted(ev:Event) {
			gotoAndPlay("pause");
			_clickCommand = VideoScreen.PAUSE_VIDEO;
		}
		
		// When the video stops, switch to "play" mode.
		
		protected function onVideoStopped(ev:Event) {
			gotoAndPlay("play");
			_clickCommand = VideoScreen.RESUME_VIDEO;
		}

	}

	
}