/**
 *	Video page, handles video player
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.marketing.destination.sixFlags
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	//import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPage
	import com.neopets.projects.destination.VideoPlayerShell
	import abelee.resource.easyCall.QuickFunctions;
	import com.neopets.util.events.CustomEvent;
	
	
	
	
	public class VideoPage extends AbstractPage {
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public const PLAY_VIDEO:String = "play_video"
		public const VIDEO_VIEWED:String = "user_viewed_video_to_the_end"
		
		private var mVideoURL1:String="http://images.neopets.com/sponsors/trailers/sixflags/kiddiereel_high_v1.flv";
		private var mVideoURL2:String="http://images.neopets.com/sponsors/trailers/sixflags/tornado_high_v1.flv";
		private var mCurrentVideoURL:String;
		private var mRootTimeLine:Object;
		private var mNeoContentID:int;	//Highquality trailer
		
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function VideoPage(pRootTimeLine:Object) {
			mRootTimeLine = pRootTimeLine
			trace ("create Video page")
			super()
			setupVideoPage()
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true)
			addEventListener(PLAY_VIDEO, onPlayVideo, false, 0, true)
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//set up the look and feel of the page
		private function setupVideoPage():void
		{
			addBackground("VideoBackground", "VideoBackground", 390, 265);			
			placeImageButton("Btn_Video_Park", "video1", 570, 22.6)
			placeImageButton("Btn_Video_Water", "video2", 506, 169, -16)
			addBackground("VideoForeground", "VideoForeground", 0, 0);
			placeImageButton("Btn_back", "goBack", 80, 470, 0, "out")
		}
		
		
		// create a video player: 
		//1 set background, 2 set the videoPlayerShell(video player), 3 place back button
		private function setupVideoPlayer():void
		{
			var vShell:VideoPlayerShell = new VideoPlayerShell (mRootTimeLine, "VideoPlayer", mCurrentVideoURL, null, 370, 200, mNeoContentID)
			vShell.name = "video Shell";
			vShell.addBackground("TrailerBackground");
			vShell.addBackBtn("Btn_Generic", "closeMovie", "Back", 320, 400);
			vShell.x = 0;
			vShell.y = 0;
			addChild(vShell)
			vShell.addEventListener("videoStopped", videoStopHandler, false, 0 , true)
			var backBtn:MovieClip = vShell.getChildByName("closeMovie") as MovieClip
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBackPressed, false, 0, true)			
		}
		
		//removes the video player
		private function stopAndClearVideo():void
		{
			var vShell:VideoPlayerShell = getChildByName("video Shell") as VideoPlayerShell
			vShell.removeEventListener("videoStopped", videoStopHandler);
			var backBtn:MovieClip = vShell.getChildByName("closeMovie") as MovieClip
			backBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBackPressed)
			removeChild(vShell)
		}
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		//when back button is pressed, stop and clear teh video
		private function onBackPressed(evt:MouseEvent):void
		{
			stopAndClearVideo()
		}
		
		//this method is called if user watched the video to the end.
		private function videoStopHandler(evt:Event = null):void
		{
			stopAndClearVideo()
			dispatchEvent(new Event (VIDEO_VIEWED))
		}
		
		
		
		private function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("over")
			}
		}
		
		private function handleMouseOut(evt:MouseEvent):void
		{
			
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
			}
		}
		
		//play appropriate video based on use's choice
		private function onPlayVideo(evt:CustomEvent):void
		{
			switch (evt.oData.VIDEO)
			{
				case "video1":
					mCurrentVideoURL = mVideoURL1;
					mNeoContentID = evt.oData.NEOCONTENT_ID;
					break;
					
				case "video2":
					mCurrentVideoURL = mVideoURL2;
					mNeoContentID = evt.oData.NEOCONTENT_ID;
					break;
			}
			setupVideoPlayer()
		}
	}
}
		