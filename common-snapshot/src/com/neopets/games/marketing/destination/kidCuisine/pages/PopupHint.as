/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.SupportFunctions
	import com.neopets.projects.destination.destinationV2.NeoTracker
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupHint extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var mNickURL:String;
		var mNickClickID:int;
		var mDoubleClickURL:String		// third party tracking URL/id
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupHint(pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			super();
			x =  px
			y =  py
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
		}
		
		public function hide():void
		{
			visible = false 
		}
		
		public function get textBox():MovieClip
		{
			return MovieClip(getChildByName("textBox"))
		}
		
		public function updateText(pMessage:String = null, pWidth = 300)
		{
			var textBox:MovieClip = getChildByName("textBox") as MovieClip;
			textBox.myText.text = pMessage;
			textBox.myText.width = pWidth;
			textBox.myText.autoSize = "left";
			textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;
		}
		
		
		/**
		 *	If xml passes nick url, make the "goto nick.btn" visible and set the url
		 *	@PARAM		pOn			Boolean		set true if button should show
		 *	@PARAM		pURL		String		will be passed down from xml
		 **/
		public function nickBtnOn(pOn:Boolean, pURL:String = null, pClickID:int = 0, pDoubleClickID:String = null):void
		{
			var nickbtn:MovieClip = getChildByName("nickButton") as MovieClip
			var loginNick:MovieClip = MovieClip (MovieClip(getChildByName("background")).loginNick)
			nickbtn.visible = pOn
			loginNick.visible = pOn
			mNickURL = pURL
			mNickClickID = pClickID
			mDoubleClickURL = pDoubleClickID
		}
				
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("HintBox", "background", x, y);
			addTextButton("KidGenericButton", "closeButton", "Close", x + 118, y -20);
			addImageButton("NickButton", "nickButton", x - 210, y - 20);
			//
			var btn:MovieClip = getChildByName("closeButton") as MovieClip
			btn.scaleX = btn.scaleY = .6
			btn.addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			//
			var nickbtn:MovieClip = getChildByName("nickButton") as MovieClip
			nickbtn.scaleX = nickbtn.scaleY = .6
			nickbtn.addEventListener(MouseEvent.MOUSE_DOWN, gotoNickPage, false, 0, true)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			addTextBox("KidHintTextBox", "textBox", pMessage, x - 95 , y - 80);
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		private function gotoNickPage(evt:MouseEvent):void
		{
			trace ("my click ID", mNickClickID)
			NeoTracker.triggerTrackURL(mDoubleClickURL)
			NeoTracker.sendTrackerID(mNickClickID);
			if (mNickURL != null)
			{
				var url:URLRequest = new URLRequest (mNickURL)
				try {            
					navigateToURL(url, "_self")
				}
				catch (e:Error) {
					// handle error here
				}
			}
			
		}
		
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