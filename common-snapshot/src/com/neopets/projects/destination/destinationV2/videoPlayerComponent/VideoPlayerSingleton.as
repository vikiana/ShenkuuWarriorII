/**
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.projects.destination.destinationV2.videoPlayerComponent
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.videoPlayerComponent.VideoPlayerShell
	
	public class VideoPlayerSingleton extends Sprite {
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const PLAY_VIDEO:String = "play_video"
		public static const VIDEO_VIEWED:String = "user_viewed_video_to_the_end"
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private static var mReturnedInstance : VideoPlayerSingleton;
		private var mVideoPlaying:Boolean;
		protected var vShell:VideoPlayerShell;
		
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function VideoPlayerSingleton(pPrivCl : PrivateClass ):void
		{
			mVideoPlaying = false
		}
	
	
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		public static function get instance( ):VideoPlayerSingleton
		{
			if( VideoPlayerSingleton.mReturnedInstance == null ) 
			{
				VideoPlayerSingleton.mReturnedInstance = new VideoPlayerSingleton( new PrivateClass( ) );
			}
			else
			{
				trace( "Instance of VideoPlayerSingleton already exists" );
			}
			return VideoPlayerSingleton.mReturnedInstance;
		}

		
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function setVideoParam(pRoot:Object, pVideoPlayerClass:String, pSourceURLHigh:String, pSourceURLLow:String = null, px:Number = 0, py:Number = 0, pClickID:int = 0, pWidth:Number = 30, pHeight:Number = 40):void
		{
			trace ("//////////////////////setup param")
			if (mVideoPlaying) stopAndClearVideo();
			setupVideoPlayer (pRoot, pVideoPlayerClass, pSourceURLHigh, pSourceURLLow, px, py, pClickID, pWidth, pHeight);
		}
		
		
		public function addBackground(pBgName:String):void
		{
			vShell.addBackground(pBgName);
			//vShell.addBackground("TrailerBackground");
			
		}
		
		public function addBackButton(pButtonClass:String, px:Number, py:Number):void
		{
			//vShell.addBackBtn(pbutton, "closeMovie", "Back", px, py);
			vShell.addBackBtn(pButtonClass, "closeMovie", "Back", px, py);
			var backBtn:MovieClip = vShell.getChildByName("closeMovie") as MovieClip
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBackPressed, false, 0, true)
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupVideoPlayer(pRoot:Object, pVideoPlayerClass:String, pSourceURLHigh:String, pSourceURLLow:String = null, px:Number = 0, py:Number = 0, pClickID:int = 0,pWidth:Number = 320, pHeight:Number = 240):void
		{
			vShell = new VideoPlayerShell (
										   pRoot, 
										   pVideoPlayerClass, 
										   pSourceURLHigh, 
										   pSourceURLLow, 
										   px, 
										   py, 
										   pClickID,
										   0,
										   true,
										   true,
										   pWidth,
										   pHeight
										   )
			vShell.name = "video Shell";
			vShell.x = 0;
			vShell.y = 0;
			addChild(vShell)
			vShell.addEventListener(vShell.VIDEO_STOPPED, videoStopHandler, false, 0 , true)
			mVideoPlaying = true
		}
		
		
		
		//removes the video player
		private function stopAndClearVideo():void
		{
			vShell.removeEventListener(vShell.VIDEO_STOPPED, videoStopHandler);
			if (vShell.getChildByName("closeMovie") != null)
			{
				var backBtn:MovieClip = vShell.getChildByName("closeMovie") as MovieClip
				backBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBackPressed)
			}
			vShell.cleanup();
			removeChild(vShell)
			mVideoPlaying = false
		}
		
		//----------------------------------------
		//	EVENT LISTENER
		//----------------------------------------
		
		//when back button is pressed, stop and clear teh video
		private function onBackPressed(evt:MouseEvent):void
		{
			stopAndClearVideo()
		}
		
		//this method is called if user watched the video to the end.
		private function videoStopHandler(evt:Event = null):void
		{
			trace ("videoViewed")
			stopAndClearVideo()
			dispatchEvent(new Event (VIDEO_VIEWED))
		}
		
	}
}


//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} 