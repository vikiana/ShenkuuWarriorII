
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
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.video.VideoManager;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	
	/**
	 *	Video popup
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0 
	 *	@author Viviana Baldarelli / Clive Henrick
	 *	@since  5.17.10
	 **/
	
	public class CapriSun2011ArcadePage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var xPos:Number
		private var yPos:Number
		
		
		//var mVideoPlayer:BasicVideoPlayer;
		private var vM:VideoManager;
		private var vPlayerID:int;
		
		private const startX:Number = 0;
		private const startY:Number = 0;
		
		// ?
		private var mVideoPlayerX:Number = -20;
		private var mVideoPlayerY:Number = 45;
		
		public var gameOneBtn:MovieClip;
		public var gameTwoBtn:MovieClip;
		
		// not launching yet - btn area/hit is guided out inside Arcade 3 movieclip
		//public var gameThreeBtn:MovieClip; 
		
		
		//public var arcadeLinkBtn:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CapriSun2011ArcadePage(pName:String=null, pView:Object=null, pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			
			trace("-- Arcade Constructor--");
			super(pName, pView);
			
			this.x = startX;
			this.y = startY;
			
			
			setupListeners();
			
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
			
			
		}
		
		protected function setupListeners():void
		{
			// Links
			//arcadeLinkBtn.addEventListener(MouseEvent.CLICK,goToCapriSite,false,0,true);
			gameOneBtn.addEventListener(MouseEvent.CLICK,goToGameOne,false,0,true);
			gameTwoBtn.addEventListener(MouseEvent.CLICK,goToGameTwo,false,0,true);
			//gameThreeBtn.addEventListener(MouseEvent.CLICK,goToGameThree,false,0,true);		
		}
		
		
		/*
		protected function goToCapriSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.respectthepouch.com");
			navigateToURL(request);
		}
		*/
		
		protected function goToGameOne(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.neopets.com/games/play.phtml?game_id=1290");
			navigateToURL(request);
		ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Arcade to Peggy Game')");

		}
		
		protected function goToGameTwo(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.neopets.com/games/play.phtml?game_id=1299");
			navigateToURL(request);
			ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination Arcade to Don Game')");

		}
		
		protected function goToGameThree(e:MouseEvent):void
		{
			// game won't launch until later - disable for now
			//var request:URLRequest = new URLRequest("http://www.neopets.com/games/play.phtml?game_id=1212");
			//navigateToURL(request);
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
			
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		
	
	}
	
}