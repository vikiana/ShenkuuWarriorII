/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 **/

package com.neopets.games.marketing.destination.kidCuisine.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.users.abelee.utils.SupportFunctions;
	import com.neopets.util.video.VideoManager;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class VideoPopup extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var xPos:Number
		var yPos:Number
		
		//var mVideoPlayer:BasicVideoPlayer;
		var vM:VideoManager;
		var vPlayerID:int;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoPopup(pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			super();
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
		public function show():void
		{
			visible = true
			//Phase III
			vM.loadAndPlay(vPlayerID, "http://images.neopets.com/sponsors/trailers/kc_planet51_high_v1.flv ");
			//Phase  II "http://images.neopets.com/sponsors/trailers/kc_campfire-hotdog_high_v1.flv");
			//Send Neocontent tracker ID
			NeoTracker.sendTrackerID(14989);
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
		
		public function updateText(pMessage:String = null, pWidth = 450)
		{
			var textBox:MovieClip = getChildByName("textBox") as MovieClip;
			textBox.myText.text = pMessage;
			textBox.myText.width = pWidth;
			textBox.myText.autoSize = "left";
			//textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;
		}
				
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("PopUp", "background", xPos, yPos);
			//faded background
			/*var screen:Shape = new Shape ();
			screen.graphics.beginFill(0x000000, 0.7);
			screen.graphics.drawRect(0, 0, 780, 530);
			screen.graphics.endFill();
			addChild (screen);*/
			
			addTextButton("KidGenericButton", "closeButton", "Cancel", xPos + 400, yPos + 220);
			SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			var btn:MovieClip = getChildByName("closeButton") as MovieClip
			btn.scaleX = btn.scaleY = .6
			
			//Phase 2 - video component
			//mVideoPlayer = new BasicVideoPlayer ();
			//addChild (mVideoPlayer);
			//mVideoPlayer.loadAndPlay("http://images.neopets.com/sponsors/trailers/kc_campfire-hotdog_high_v1.flv");
			vM = VideoManager.instance;
			vPlayerID = VideoManager.instance.createVideoPlayer();
			
			vM.getPlayerInstance(vPlayerID).x = 240;
			vM.getPlayerInstance(vPlayerID).y = 270; 
			
			vM.playerParameters(vPlayerID, false);
			addChild (vM.getPlayerInstance(vPlayerID));
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			addTextBox("KidGenericTextBox", "textBox", pMessage, xPos + 50, yPos + 130 );
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