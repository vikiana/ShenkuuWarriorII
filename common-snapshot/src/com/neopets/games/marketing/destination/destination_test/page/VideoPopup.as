/* AS3
	Copyright 2009
*/

package com.neopets.games.marketing.destination.destination_test.page
{
	
	/**
	 *	Base document class example for VideoManager
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  8.05.2009
	 *	Modified by Abraham Lee
	 */	
	 
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.video.VideoManager;


	public class VideoPopup extends PageDestinationBase2 
	{
		
		public var vm:VideoManager; //actual video player
		public var vid:int;
		public var vid2:int;
		
		/**
		 *	@Constructor
		 */

		 public function VideoPopup():void 
		 {
			 setupPage ()
		 }
		 
		 override protected function setupPage():void
		 {
			//stop();

			vm = VideoManager.instance;
			vid = vm.createVideoPlayer();

			
			// You can choose NOT to touch BasicVideoPlayer class if you wish to.
			vm.getPlayerInstance(vid).x = 385;
			vm.getPlayerInstance(vid).y = 250;

			vm.addEventListener(VideoManager.VIDEO_READY, readyHandler);
			vm.addEventListener(VideoManager.VIDEO_START, startHandler);
			vm.addEventListener(VideoManager.VIDEO_PLAY, playHandler);
			vm.addEventListener(VideoManager.VIDEO_DONE, doneHandler);
			vm.addEventListener(VideoManager.VIDEO_STOP, stopHandler);
			vm.addEventListener(VideoManager.VIDEO_PAUSE, pauseHandler);
			vm.addEventListener(VideoManager.VIDEO_MUTE, muteHandler);
			vm.addEventListener(VideoManager.VIDEO_UNMUTE, unmuteHandler);
			vm.addEventListener(VideoManager.VIDEO_DESTROYED, destroyedHandler);


			vm.playerParameters(vid, true);
			var plb:Class = getDefinitionByName("playbutton") as Class
			var pab:Class = getDefinitionByName("pausebutton") as Class
			var stb:Class = getDefinitionByName("stopbutton") as Class
			var reb:Class = getDefinitionByName("rewindbutton") as Class
			var mub:Class = getDefinitionByName("mutebutton") as Class
			var unb:Class = getDefinitionByName("unmutebutton") as Class
			
			
			vm.playerButtons(vid, plb, pab, stb, reb, mub, unb);
			vm.loadAndPlay(vid, "http://images.neopets.com/sponsors/trailers/clonewars_high_v1.flv", 480, 204);
			
			addImage("MC_videoPopup", "videoPopupBg", 0, 0);
			addChild(vm.getPlayerInstance(vid));
			placeTextButton("MC_navButton", "back", "Back", 400, 420, 0, "out")
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function readyHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS READY!!!");
		}
		
		private function startHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS STARTED!!!");
		}
		
		private function playHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS PLAYING!!!");
		}
		
		private function doneHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS DONE PLAYING!!!");
			
			if (e.oData.ID == 1) { // makes 2nd video loop
				vm.getPlayerInstance(vid2).playVideo();
			}
		}
		
		private function stopHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS STOPPED!!!");
		}
		
		private function pauseHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS PAUSED!!!");
		}
		
		private function muteHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS MUTED!!!");
		}
		
		private function unmuteHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS UNMUTED!!!");
		}
		
		private function destroyedHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS DESTROYED!!!");
		}
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			switch (e.oData.DATA.parent.name)
			{
				case "back":
					trace ("back button")
					vm.clearAll();
					cleanup();
					this.parent.removeChild(this)
					break;
			}
		}
	}
}