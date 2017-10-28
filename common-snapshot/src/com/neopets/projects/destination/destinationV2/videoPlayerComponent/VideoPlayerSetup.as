/**
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.projects.destination.videoPlayerComponent
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
	import com.neopets.projects.destination.videoPlayerComponent.VideoPlayerShell
	
	public class VideoPlayerSetup extends Sprite {
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public const PLAY_VIDEO:String = "play_video"
		public const VIDEO_VIEWED:String = "user_viewed_video_to_the_end"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var vShell:VideoPlayerShell;
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function VideoPlayerSetup(pRoot:Object, pVideoPlayerClass:String, pSourceURLHigh:String, pSourceURLLow:String = null, px:Number = 0, py:Number = 0, pClickID:int = 0):void
		{
			setupVideoPlayer (pRoot, pVideoPlayerClass, pSourceURLHigh, pSourceURLLow, px, py, pClickID)
		}
	
	
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function addBackground(pBgName:String):void
		{
			vShell.addBackground(pBgName);
			vShell.addEventListener(vShell.VIDEO_STOPPED, videoStopHandler, false, 0 , true)
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
		
		private function setupVideoPlayer(pRoot:Object, pVideoPlayerClass:String, pSourceURLHigh:String, pSourceURLLow:String = null, px:Number = 0, py:Number = 0, pClickID:int = 0):void
		{
			vShell = new VideoPlayerShell (pRoot, 
										   pVideoPlayerClass, 
										   pSourceURLHigh, 
										   pSourceURLLow, 
										   px, 
										   py, 
										   pClickID
										   )
			vShell.name = "video Shell";
			vShell.x = 0;
			vShell.y = 0;
			addChild(vShell)
		}
		
		
		
		//removes the video player
		private function stopAndClearVideo():void
		{
			vShell.removeEventListener(vShell.VIDEO_STOPPED, videoStopHandler);
			var backBtn:MovieClip = vShell.getChildByName("closeMovie") as MovieClip
			backBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBackPressed)
			removeChild(vShell)
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
			stopAndClearVideo()
			dispatchEvent(new Event (VIDEO_VIEWED))
		}
		
	}
}
		