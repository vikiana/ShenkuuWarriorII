
package com.neopets.games.marketing.destination.CapriSun2011.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.CapriSun2011.CapriSun2011Constants;
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.projects.destination.AbstractPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.users.abelee.utils.SupportFunctions;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.video.VideoManager;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	
	/**
	 *	Video popup
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0 
	 *	@author Viviana Baldarelli / Clive Henrick
	 *	@since  5.17.10
	 **/
	
	public class CapriSun2011VideoPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//Onstage
		public var respect_btn:MovieClip;
		public var nick_btn:MovieClip; 
		public var playMovieBtn:MovieClip;
		public var playMovieTwoBtn:MovieClip;
		public var playMovieThreeBtn:MovieClip;
		public var playMovieFourBtn:MovieClip;
		public var videoBackBtn:MovieClip;
		
		// Declare Vid controls - is this necessary?
		//public var playbutton:Class;
		public var pausebutton:Class;
		public var stopbutton:Class;
		public var rewindbutton:Class;
		public var mutebutton:Class;
		public var unmutebutton:Class;
		
		
		// Video Player
		private var vM:VideoManager;
		private var vPlayerID:int;
		
		private var mVideoPlayerX:Number = 400;
		private var mVideoPlayerY:Number = 260;
		
		private var _controls:Boolean = false;
		// Video controls
		// Instantiate Video control buttons
		// playButton:Class = ApplicationDomain.currentDomain.getDefinition (playbutton) as Class;
		
		
		
		

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CapriSun2011VideoPage(pName:String=null, pView:Object=null, pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			super(pName, pView);
			setupListeners();
			setupPage();
			
		
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function init(pName:String = null):void
		{
			this.name = pName;	
		}
		
		public function show(path:String, W:Number, H:Number):void
		{
			if (!_controls){
				setUpControls();
				_controls = true;
			}
			//var baseurl:String;
			//baseurl  = Parameters.imageURL;
			var videoPath:String;
			vM.getPlayerInstance(vPlayerID).visible = true; 
			vM.loadAndPlay(vPlayerID, path, W, H);
			//sendActivityService(CapriSun2011Constants.ACTIVITY_LINK_VIDEO);
		}
		
		
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected function sendActivityService(pID:int):void
		{
			if (Parameters.loggedIn)
			{
				Parameters.connection.call("CapriSunService.ActivityService", null , Parameters.userName,pID);	
			}
		}
		
		protected override function setupPage():void
		{
			//videoplayer
			vM = VideoManager.instance;
			vPlayerID = vM.createVideoPlayer();
			
			vM.addEventListener(VideoManager.VIDEO_DONE, hide, false,0,true);
			vM.addEventListener(VideoManager.VIDEO_READY, readyHandler);
			vM.addEventListener(VideoManager.VIDEO_START, startHandler);
			vM.addEventListener(VideoManager.VIDEO_PLAY, playHandler);
			vM.addEventListener(VideoManager.VIDEO_STOP, stopHandler);
			vM.addEventListener(VideoManager.VIDEO_PAUSE, pauseHandler);
			vM.addEventListener(VideoManager.VIDEO_MUTE, muteHandler);
			vM.addEventListener(VideoManager.VIDEO_UNMUTE, unmuteHandler);
			vM.addEventListener(VideoManager.VIDEO_DESTROYED, destroyedHandler);
			
			vM.playerParameters(vPlayerID, true);
		
			
			// Location
			vM.getPlayerInstance(vPlayerID).x = mVideoPlayerX; 
			vM.getPlayerInstance(vPlayerID).y = mVideoPlayerY;  
			addChild (vM.getPlayerInstance(vPlayerID));

			playMovieBtn.addEventListener(MouseEvent.CLICK, playMovie,false,0,true);
			playMovieTwoBtn.addEventListener(MouseEvent.CLICK, playMovieTwo,false,0,true);
			
			playMovieThreeBtn.addEventListener(MouseEvent.CLICK, playMovieThree,false,0,true);
			playMovieFourBtn.addEventListener(MouseEvent.CLICK, playMovieFour,false,0,true);
		}
		
		private function setUpControls():void {
			// Instantiate VideoPlayer controls
			var playbutton:Class = LibraryLoader.getLibrarySymbol("playbutton");
			var pausebutton:Class = LibraryLoader.getLibrarySymbol("pausebutton");
			var stopbutton:Class = LibraryLoader.getLibrarySymbol("stopbutton");
			var rewindbutton:Class = LibraryLoader.getLibrarySymbol("rewindbutton");
			var mutebutton:Class = LibraryLoader.getLibrarySymbol("mutebutton");
			var unmutebutton:Class = LibraryLoader.getLibrarySymbol("unmutebutton");
			//Controls - not showing up yet 
			// The registration point of the buttons was changed in the library so the controls would be higher
			vM.playerButtons(vPlayerID, playbutton, pausebutton, stopbutton, rewindbutton, mutebutton, unmutebutton);
		}
		
		
		protected function setupListeners():void
		{
			// Links
			respect_btn.addEventListener(MouseEvent.CLICK,goToCapriSite,false,0,true);
			nick_btn.addEventListener(MouseEvent.CLICK,goToNickSite,false,0,true);
		}
		
		/**
		 * 
		 * Navigation. This is a simplified navigation in wich only the opages on top of the selected page will be hidden. This makes it useful for both pages and popups.
		 * 
		 * @param pName      name of the page to navigate to
		 * 
		 * */
		protected function gotoPage(pName:String):void {
			var currentPage:Sprite = Parameters.view.getChildByName(pName);
			///show the page
			currentPage.visible = true;
			
			if (currentPage != null)
			{
				currentPage.dispatchEvent(new Event(AltadorAlleyDestinationControl.PAGE_DISPLAY));	
			}
			
			//hide everything on top
			var currentIndex:int = Sprite(Parameters.view).getChildIndex(currentPage);
			for (var i:int = 0; i< Sprite(Parameters.view).numChildren; i++){
				if (i > currentIndex){
					Sprite(Parameters.view).getChildAt(i).visible = false;
				}
			}
		}
		
		protected function goToCapriSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.respectthepouch.com");
			navigateToURL(request);
			ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Video to respectthepouch.com')");	
			
		}
		
		protected function goToNickSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://ads.nick.com/sponsors/2011/caprisun/truth-or-dare/");
			navigateToURL(request);
			ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Video to nick.com')");
			
		}
		
		// Used in destination control - back button
		public function hide(evt:Event = null):void
		{
			vM.getPlayerInstance(vPlayerID).visible = false; 
			vM.getPlayerInstance(vPlayerID).stopVideo();
			
		}
		
		// Video Methods
		private function readyHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS READY!!!");
		}
		
		private function startHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS STARTED!!!");
		}
		
		private function playHandler(e:CustomEvent):void {
			trace("VIDEO ID " + e.oData.ID + " IS PLAYING!!!");
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
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 * Play the Movie
		 */
		
		protected function playMovie(evt:MouseEvent):void
		{
			show(CapriSun2011Constants.CAPRISUN_VIDEO1,380,260); // 480 x 360 is original size, but it looked pixelated. Widescreen?
			ExternalInterface.call("window.top.sendReportingCall('Video 1 View','CapriSun2011')");
		}
		
		protected function playMovieTwo(evt:MouseEvent):void
		{
			show(CapriSun2011Constants.CAPRISUN_VIDEO2,380,260);
			ExternalInterface.call("window.top.sendReportingCall('Video 2 View','CapriSun2011')");
		}
		
		protected function playMovieThree(evt:MouseEvent):void
		{
			show(CapriSun2011Constants.CAPRISUN_VIDEO3,400,225);
			ExternalInterface.call("window.top.sendReportingCall('Video 3 View','CapriSun2011')");
		}
		
		protected function playMovieFour(evt:MouseEvent):void
		{
			show(CapriSun2011Constants.CAPRISUN_VIDEO4,400,225);
			ExternalInterface.call("window.top.sendReportingCall('Video 4 View','CapriSun2011')");
		}
		
		protected function playMovieFive(evt:MouseEvent):void
		{
			//show(CapriSun2011Constants.CAPRISUN_VIDEO5,480,270);	
			ExternalInterface.call("window.top.sendReportingCall('Video 5 View','CapriSun2011')");
		}
		
		protected function playMovieSix(evt:MouseEvent):void
		{
			//show(CapriSun2011Constants.CAPRISUN_VIDEO6,480,270);
			ExternalInterface.call("window.top.sendReportingCall('Video 6 View','CapriSun2011')");
		}
		
		
		
	}
	
}
