
package com.neopets.games.marketing.destination.sixFlags2010.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.sixFlags2010.SixFlagsConstants;
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.projects.destination.AbstractPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.users.abelee.utils.SupportFunctions;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.video.VideoManager;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *	Video popup
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0 
	 *	@author Viviana Baldarelli / Clive Henrick
	 *	@since  5.17.10
	 **/
	
	public class SixFlags2010VideoPage extends AbstractPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var xPos:Number
		private var yPos:Number
		
		//var mVideoPlayer:BasicVideoPlayer;
		private var vM:VideoManager;
		private var vPlayerID:int;
		
		private const startX:Number = 360.00;
		private const startY:Number = 249.70;
		
		private var mVideoPlayerX:Number = 30;
		private var mVideoPlayerY:Number = -35;
		
		public var videoclose_btn:MovieClip; //Onstage
		public var watchNow_btn:HiButton; //Onstage
		public var watchNow2_btn:HiButton; //Onstage
		public var leftPoster:MovieClip; //Onstage
		public var rightPoster:MovieClip; //Onstage
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SixFlags2010VideoPage(pName:String=null, pView:Object=null, pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			super(pName, pView);
			
			this.x = startX;
			this.y = startY;
			
			setupPage();
			
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function show(path:String, W:Number, H:Number):void
		{
			var baseurl:String;
			var videoPath:String;
			baseurl  = Parameters.imageURL;
			vM.getPlayerInstance(vPlayerID).visible = true; 
			vM.loadAndPlay(vPlayerID, path, W, H);
			sendActivityService(SixFlagsConstants.ACTIVITY_LINK_VIDEO);
		}
		
		public function hide(evt:Event = null):void
		{
			vM.getPlayerInstance(vPlayerID).visible = false; 
			vM.getPlayerInstance(vPlayerID).stopVideo();
			watchNow_btn.visible = true;
			watchNow2_btn.visible = true;
		}
		
		public function init(pName:String = null):void
		{
			this.name = pName;	
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected function sendActivityService(pID:int):void
		{
			if (Parameters.loggedIn)
			{
				Parameters.connection.call("SixFlagsService.ActivityService", null , Parameters.userName,pID);	
			}
		}
		
		protected override function setupPage():void
		{
			watchNow_btn.setTitleText("Video 1");
			watchNow2_btn.setTitleText("Video 2");
			watchNow2_btn.addEventListener(MouseEvent.CLICK, playMovie2,false,0,true);
			watchNow2_btn.mouseEnabled = true;
			watchNow_btn.addEventListener(MouseEvent.CLICK, playMovie,false,0,true);
			watchNow_btn.mouseEnabled = true;
			//faded background
			/**
			var screen:Shape = new Shape ();
			screen.graphics.beginFill(0x000000, 0.7);
			screen.graphics.drawRect(0, 0, 810, 744);
			screen.graphics.endFill();
			addChild (screen);
			*/
			//videoplayer
			vM = VideoManager.instance;
			vPlayerID = VideoManager.instance.createVideoPlayer();
			vM.addEventListener(VideoManager.VIDEO_DONE, hide, false,0,true);
			vM.playerParameters(vPlayerID, false, false);
			
			vM.getPlayerInstance(vPlayerID).x = mVideoPlayerX; //screen.width/2;//-vM.getPlayerInstance(vPlayerID).width/2;
			vM.getPlayerInstance(vPlayerID).y = mVideoPlayerY; //screen.height/2;//-vM.getPlayerInstance(vPlayerID).height/2; 
			
			addChild (vM.getPlayerInstance(vPlayerID));
			videoclose_btn.mouseEnabled = true;
			videoclose_btn.buttonMode = true;
			leftPoster.mouseEnabled = true;
			leftPoster.buttonMode = true;
			rightPoster.mouseEnabled = true;
			rightPoster.buttonMode = true;
			leftPoster.addEventListener(MouseEvent.CLICK,onPosterClick,false,0,true);
			rightPoster.addEventListener(MouseEvent.CLICK,onPosterClick,false,0,true);
			
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
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
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		/**
		 * Poster is Clicked
		 */
		
		protected function onPosterClick(evt:Event):void
		{
			switch (evt.target.name)
			{
				case "leftPoster":
					hide();
					gotoPage("info");
					break;
				case "rightPoster":
					hide();
					gotoPage("flags");
					break;
			}
		}
		/**
		 * Play the Movie
		 */
		
		protected function playMovie(evt:MouseEvent):void
		{
			show(SixFlagsConstants.SIXFLAGS_VIDEO1_HIGH,480,270);	
			watchNow_btn.visible = false;
			watchNow2_btn.visible = false;
			NeoTracker.instance.trackNeoContentID(16359)
			TrackingProxy.sendADLinkCall('SixFlags2010 - Video Watch Now');
		}
		
		protected function playMovie2(evt:MouseEvent):void
		{
			show(SixFlagsConstants.SIXFLAGS_VIDEO2_HIGH,480,270);	
			watchNow_btn.visible = false;
			watchNow2_btn.visible = false;
			NeoTracker.instance.trackNeoContentID(16359)
			TrackingProxy.sendADLinkCall('SixFlags2010 - Video Watch Now');
		}
	
	}
	
}