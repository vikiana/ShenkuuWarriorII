/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieTest.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.MouseEvent;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPageWithBtnState;
	import com.neopets.users.abelee.utils.SupportFunctions
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupSimple extends AbstractPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var xPos:Number
		var yPos:Number
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupSimple(pMessage:String = null, px:Number = 0, py:Number = 0):void
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
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("GenericMessageBoard", "background", xPos, yPos);
			addTextButton("GenericButton", "closeButton", "Close", xPos + 240, yPos + 80);
			SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			addTextBox("GenericTextBox", "textBox", pMessage, xPos + 10 , yPos + 10);
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function closePopup(evt:MouseEvent):void
		{
			SupportFunctions.getChildAsMovieClip(this, "closeButton").removeEventListener(MouseEvent.MOUSE_DOWN, closePopup)
			cleanup();
		}
	}
	
}