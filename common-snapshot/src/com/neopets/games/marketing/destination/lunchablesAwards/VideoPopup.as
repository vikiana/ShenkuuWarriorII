/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 **/

package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.users.abelee.utils.SupportFunctions;
	import com.neopets.util.video.VideoManager;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class VideoPopup extends AbstractPageCustom
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var xPos:Number
		private var yPos:Number
		
		//var mVideoPlayer:BasicVideoPlayer;
		private var vM:VideoManager;
		private var vPlayerID:int;
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoPopup(pName:String=null, pView:Object=null, pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			super(pName, pView);
			xPos = px
			yPos = py
			setupPage ()
			setupMessage(pMessage)
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function show(videoID:int):void
		{
			var baseurl:String;
			var videoPath:String;
			if (mView.control.imageHost){
				baseurl = "http://"+mView.control.imageHost+"/sponsors/lunchables/destination/assets/";
			} else {
				baseurl = "http://images50.neopets.com/sponsors/lunchables/destination/assets/";
			}
			visible = true;
			switch(videoID){
				case 1:
					videoPath = "main_high_v1.flv";
				break;
				case 2:
					videoPath = "vote_high_v1.flv";
				break;
				case 3:
					videoPath = "win_high_v1.flv";
				break;
				case 4:
					videoPath = "commercial_high_v1.flv";
				break;
			}
			trace("Loading and playing video: "+baseurl+videoPath);
			vM.loadAndPlay(vPlayerID, baseurl+videoPath);
			//Neocontent tracking
			NeoTracker.instance.trackNeoContentID(15223);
		}
		
		public function hide():void
		{
			visible = false 
			vM.getPlayerInstance(vPlayerID).stopVideo();
		}
		
		public function get textBox():MovieClip
		{
			return MovieClip(getChildByName("textBox"))
		}
		
		/*public function updateText(pMessage:String = null, pWidth = 450)
		{
			var textBox:MovieClip = getChildByName("textBox") as MovieClip;
			textBox.myText.text = pMessage;
			textBox.myText.width = pWidth;
			textBox.myText.autoSize = "left";
			//textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;
		}*/
				
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			//faded background
			var screen:Shape = new Shape ();
			screen.graphics.beginFill(0x000000, 0.7);
			screen.graphics.drawRect(0, 0, 780, 530);
			screen.graphics.endFill();
			addChild (screen);
			
			addTextButton("Text_button", "closeButton", "Cancel", xPos + 322, yPos + 410);
			SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			var btn:MovieClip = getChildByName("closeButton") as MovieClip
			
			//Phase 2 - video component
			//mVideoPlayer = new BasicVideoPlayer ();
			//addChild (mVideoPlayer);
			//mVideoPlayer.loadAndPlay("http://images.neopets.com/sponsors/trailers/kc_campfire-hotdog_high_v1.flv");
			vM = VideoManager.instance;
			vPlayerID = VideoManager.instance.createVideoPlayer();
			
			vM.playerParameters(vPlayerID, false);
			
			vM.getPlayerInstance(vPlayerID).x = screen.width/2//-vM.getPlayerInstance(vPlayerID).width/2;
			vM.getPlayerInstance(vPlayerID).y = screen.height/2//-vM.getPlayerInstance(vPlayerID).height/2; 
			
			vM.playerParameters(vPlayerID, false);
			addChild (vM.getPlayerInstance(vPlayerID));
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			addTextBox("LAGenericTextBox", "textBox", pMessage, xPos + 50, yPos + 130 );
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function closePopup(evt:MouseEvent):void
		{
			hide();
		}
		
		private function closePopup2(evt:MouseEvent):void
		{
			SupportFunctions.getChildAsMovieClip(this, "closeButton").removeEventListener(MouseEvent.MOUSE_DOWN, closePopup)
			cleanup();
		}
	}
	
}