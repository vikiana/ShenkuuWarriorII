/* AS3
	Copyright 2009
*/

package {
	
	/**
	 *	Base document class example for VideoManager
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  8.05.2009
	 */	
	 
	import flash.display.MovieClip;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.video.VideoManager;
	//import com.neopets.util.video.BasicVideoPlayer;

		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		

	public class Doc extends MovieClip {
		
		public var vm:VideoManager;
		public var vid:int;
		public var vid2:int;
		
		/**
		 *	@Constructor
		 */

		 public function Doc():void {
			stop();

			vm = VideoManager.instance;
			vid = vm.createVideoPlayer();
			vid2 = vm.createVideoPlayer();
			
			/*
			var vp:BasicVideoPlayer = vm.getPlayerInstance(vid);
			var vp2:BasicVideoPlayer = vm.getPlayerInstance(vid2);
			vp.x = 170;
			vp.y = 120;
			vp2.x = 470;
			vp2.y = 320;
			*/
			
			// You can choose NOT to touch BasicVideoPlayer class if you wish to.
			vm.getPlayerInstance(vid).x = 170;
			vm.getPlayerInstance(vid).y = 120;
			vm.getPlayerInstance(vid2).x = 470;
			vm.getPlayerInstance(vid2).y = 320;

			vm.addEventListener(VideoManager.VIDEO_READY, readyHandler);
			vm.addEventListener(VideoManager.VIDEO_START, startHandler);
			vm.addEventListener(VideoManager.VIDEO_PLAY, playHandler);
			vm.addEventListener(VideoManager.VIDEO_DONE, doneHandler);
			vm.addEventListener(VideoManager.VIDEO_STOP, stopHandler);
			vm.addEventListener(VideoManager.VIDEO_PAUSE, pauseHandler);
			vm.addEventListener(VideoManager.VIDEO_MUTE, muteHandler);
			vm.addEventListener(VideoManager.VIDEO_UNMUTE, unmuteHandler);
			vm.addEventListener(VideoManager.VIDEO_DESTROYED, destroyedHandler);

			//trace(vid + " - " + vp);
			//trace(vid2 + " - " + vp2);

			vm.playerParameters(vid, true);
			vm.playerButtons(vid, playbutton, pausebutton, stopbutton, rewindbutton, mutebutton, unmutebutton);
			vm.loadAndPlay(vid, "http://images.neopets.com/games/g1143_videos/how_to_enter_01_08.flv", 320, 184);
			
			vm.playerParameters(vid2, true);
			vm.playerButtons(vid2, playbutton, pausebutton, stopbutton, rewindbutton, mutebutton, unmutebutton);
			vm.loadAndPlay(vid2, "http://images.neopets.com/games/g1143_videos/how_to_enter_09_18.flv", 320, 184);

			//addChild(vp);
			//addChild(vp2);
			
			addChild(vm.getPlayerInstance(vid));
			addChild(vm.getPlayerInstance(vid2));
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
	}
}