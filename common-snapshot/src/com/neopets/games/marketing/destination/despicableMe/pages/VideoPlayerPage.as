/* AS3
	Copyright 2009
*/

package com.neopets.games.marketing.destination.despicableMe.pages {
	
	/**
	 *	Base document class example for VideoManager
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Koh Peng Chuan
	 *	@since  8.05.2009
	 */	
	 
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.video.VideoManager;
	import flash.external.ExternalInterface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	//import com.neopets.util.video.BasicVideoPlayer;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;

		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		

	public class VideoPlayerPage extends AbsPageWithBtnState {
		public var vm:VideoManager;
		public var vid:int;
		protected var delegate:AmfDelegate;
		//public var vid2:int;
		
		/**
		 *	@Constructor
		 */

		 public function VideoPlayerPage (pName:String = null, pView:Object = null):void {
		
			trace('----------VideoPlayerPage Constructor--------------');
			//Standare Destination code
			super(pName, pView);
			setupPage();
			// check if this swf has been loaded previously
			// get flash var data
			FlashVarManager.instance.initVars(root);

			
			// stop(); doesn't work within destination code - video plays automatically
			vm = VideoManager.instance;
			vid = vm.createVideoPlayer();
			
			
			// You can choose NOT to touch BasicVideoPlayer class if you wish to.
			vm.getPlayerInstance(vid).x = 250;
			vm.getPlayerInstance(vid).y = 140;
			
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
			vm.playerButtons(vid, playbutton, pausebutton, stopbutton, rewindbutton, mutebutton, unmutebutton);
			// use flash var settings to find appropriate movie url
			var vid_url:String = "http://images.neopets.com/sponsors/trailers/2010/despicable_me_";
			var lang:Object = FlashVarManager.instance.getVar("lang");
			if(lang != null && lang != "en") vid_url += lang + "_high_v1.flv";
			else vid_url += "high_v2.flv";
			vm.loadAndPlay(vid, vid_url, 320, 184);
			// tracking for when user goes to video page
			var req_event:CustomEvent = new CustomEvent(16262,DestinationView.NEOCONTENT_TRACKING_REQUEST); 
			dispatchEvent(req_event);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Video Trailer','DespicableMe2010')");
				ExternalInterface.call("window.top.urchinTracker('DespicableMe2010/VideoTrailer')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}

			
			
			
			
			
			addChild(vm.getPlayerInstance(vid));
			//addChild(vm.getPlayerInstance(vid2));
			
			//vm.getPlayerInstance(vid).playVideo();
			
			// 5/2010 - shut off the video player if back button is pressed on video page
			this.addEventListener(DestinationView.LOAD_PAGE_REQUEST, stopVideo );
			
			// dispatch tracking when shown by preloader
			this.addEventListener(DestinationView.SHOW,onShown);
			
			logo_mc.addEventListener(MouseEvent.CLICK, goToSite);
			logo_mc.buttonMode = true;
			
			logo_mc.addEventListener(MouseEvent.CLICK, logoTracking);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void {
			// set up amf delegate for quest notifications
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
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
				//vm.getPlayerInstance(vid2).playVideo();
			}
			
			// Trigger neocontent link
			var ids:Object = {au:16647,fr:16648,de:16649,nl:16650,nz:16651,es:16652,uk:16653,us:16262};
			var target_id:Object = DestinationView.getEntryByCC(ids);
			var req_event:CustomEvent = new CustomEvent(target_id,DestinationView.NEOCONTENT_LINK_REQUEST);
			dispatchEvent(req_event);
			
			// let php know we've taken a step to completing a task
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("DespicableMe2010Service.recordActivity",responder,"video");
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
		
		private function stopVideo(e:Event):void
		{
			trace('stopVideo');
			//vm.clearAll(); // removes player completely
			vm.getPlayerInstance(vid).stopVideo();
			
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
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			trace("----------onShown-----------------");
			vm.getPlayerInstance(vid).playVideo(); // plays the video again if user returns to the video page 
			var req_event:CustomEvent = new CustomEvent(16262,DestinationView.NEOCONTENT_TRACKING_REQUEST); 
			dispatchEvent(req_event);
			
			// dispatch tracking requests
			//var req_event:CustomEvent = new CustomEvent("GameArea",DestinationView.REPORTING_REQUEST);
			//dispatchEvent(req_event);
			//req_event = new CustomEvent("gameArea",DestinationView.URCHIN_REQUEST);
			//dispatchEvent(req_event);
			//req_event = new CustomEvent(16126,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			//dispatchEvent(req_event);
		}
		
		private function goToSite(e:Event):void 
		{
			// direct url version
			var req:URLRequest = new URLRequest("http://www.neopets.com/sponsors/despicableme/redir.phtml?dest=web");
			navigateToURL(req);
			
			// neocontent version
			//var req_event:CustomEvent = new CustomEvent(16261,DestinationView.NEOCONTENT_LINK_REQUEST);
			//dispatchEvent(req_event);
			
		}
		
		private function logoTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224987827;15177704;u?http://www.despicable.me/";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Destination Video Gallery to Despicable.Me Microsite')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
		}
		
	}
}