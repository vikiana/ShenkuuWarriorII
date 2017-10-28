/**
 *	BEHIND THE SCENE PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli
 *	@since  09.16.2009
 */
package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	
	import flash.external.ExternalInterface;
	
	
	public class BTSPage extends AbstractPageCustom 
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mVideoArray:Array = ["video1","video3", "video4"]
		private var mVideoNameArray:Array = ["main", "what you could win", "commercial"]
		
		private var _videoID:int = 0;
		private var mVideoPopup:VideoPopup;
		
		
		private var _trophy3Found:Boolean = false;
		private var _trophy5Found:Boolean = false;
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BTSPage(pName:String = null, pView:Object = null, pUserName:String = null, pID:String = null):void
		{
			super(pName, pView);
			setupPage();
			runJavaScript2("Behind-the-Scenes");
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			//get classes
			addImageButton("CraftServices_button", "csButton", 189, 270)
			addImageButton("Frame_button", "frameButton", 640, 170);
			addImage("Video_mc", "video", 195, 153);
			addImageButton("VoteSign_button", "signButton", 630, 408);
			//dated conditional
			var mc:MovieClip;
			mc = this.getChildByName("signButton") as MovieClip;
			mc.init ("11/15/2009", "12/02/2009", "12/18/2009");
			//
			setupVideoGallery();
			
			createVideoPopup();
			
		}
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function createVideoPopup ():void {
			//video popup
			mVideoPopup = new VideoPopup("videoPopup", mView, "");
			addChild(mVideoPopup)
			mVideoPopup.hide();
		}
		
		
		private function createAboutPopup():void
		{
			var popup:PopupAbout = new PopupAbout ("", 93, 46, 0);
			//popup.updateText(mWelcomeTxt, 200)
			addChild (popup)
		}
		
		
				
		private function setupVideoGallery():void {
			var trailerButtonArray:Array = createVideoArray ()
			var arrowButtonArray:Array = createArrowButtonArray()
			
			var buttonMenu: ViewManager_v3 = new ViewManager_v3(trailerButtonArray, arrowButtonArray, 1, 0)
			buttonMenu.x = 204;
			buttonMenu.y = 162;
			addChild(buttonMenu)
		
		}
		
			private function createVideoArray():Array
		{
			var videoArray:Array = new Array ();
			for (var i:String in mVideoArray)
			{
				var videoClass:Class = getClass(mVideoArray[i]);
				var video:MovieClip = new videoClass ();
				video.name = mVideoArray[i];
				videoArray.push(video);
			}
			
			return videoArray
		}
		
		private function createArrowButtonArray():Array
		{
			var leftClass:Class = getClass("LeftArrow");
			var left:MovieClip = new leftClass ();
			left.gotoAndStop("out")
			left.name = "left arrow"
		
			var rightClass:Class = getClass("RightArrow") as Class
			var right:MovieClip = new rightClass ();
			right.gotoAndStop("out")
			right.name = "right arrow"
			
			return [left, right]
		}
		
		
		private function videoPopup (videoID:int):void {
			if (!_trophy3Found){
				//var mData:Object = {tName:"t3"};
				var tName:String = "t3"
				mView.updateDatabaseWithTrophy(tName)
				//mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
				_trophy3Found = true;
			}
			mVideoPopup.show(videoID);
			MovieClip(mVideoPopup.getChildByName("closeButton")).btnText.text = "Back";
		}
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		override protected function handleObjClick(e:CustomEvent):void
		{
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "csButton":
					//Doubleclick tracking
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/clk;218469495;15177704;t?http://www.neopets.com/sponsors/lunchables/feed-a-pet.phtml")
					//Neocontent tracking
					NeoTracker.instance.trackNeoContentID(15089);
					if (!_trophy5Found){
						//var mData:Object = {tName:"t5"};
						var tName:String = "t5"
						mView.updateDatabaseWithTrophy(tName)
						//mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy5Found = true;
					}
					break;
					
				case "frameButton":
					createAboutPopup ();
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211011;15177704;m?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=games")
					//NeoTracker.sendTrackerID(14523);
					break;
				
				case "videoButton":
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218473703;sz=1x1");
					break;
					
				case "signButton":
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/clk;218470410;15177704;y?http://www.nick.com/nicktropolis/game/index.jhtml?nav2=room.262981&do=launch");
					//Link to Nicktropolis
					NeoTracker.processClickURL(15094);
					break;	
						
				case "enter_button":
					//Link to Lunchables.com microsite (same as the logo in Trophy Room. TODO: use a unique Neocontent link )
					NeoTracker.processClickURL(15038);
				break;
				
				//VIDEOS
				case "video1":
					videoPopup (1);
					break;
				case "video2":
					videoPopup (2);
					break;
				case "video3":
					videoPopup (3);
					break;
				case "video4":
					videoPopup (4);
					break;
			}
		}
		
		
		//Omniture
		private function runJavaScript2(scriptID:String):void
		{

			trace (this+" run javascript"+scriptID);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("sendReportingCall", scriptID,"Lunchables");
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JaraScript")
				}
			}
		}
	}
	}
