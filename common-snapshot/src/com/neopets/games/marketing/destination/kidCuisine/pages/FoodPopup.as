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
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.SupportFunctions
	//import com.neopets.util.events.CustomEvent;
	
	
	public class FoodPopup extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var xPos:Number
		var yPos:Number
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FoodPopup(pMessage:String = null, px:Number = 0, py:Number = 0):void
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
		}
		
		public function hide():void
		{
			visible = false 
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
			textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;
		}
				
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("PopUp", "background", xPos, yPos);
			addTextButton("KidGenericButton", "closeButton", "Cancel", xPos + 450, yPos + 250);
			addTextButton("KidGenericButton", "feedButton", "Feed", xPos + 250, yPos + 250);
			SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			var btn:MovieClip = getChildByName("closeButton") as MovieClip
			btn.scaleX = btn.scaleY = .6
			var btn2:MovieClip = getChildByName("feedButton") as MovieClip
			btn2.scaleX = btn2.scaleY = .6
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