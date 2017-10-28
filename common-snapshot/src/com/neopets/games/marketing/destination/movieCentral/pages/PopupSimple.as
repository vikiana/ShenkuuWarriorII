/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieCentral.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.SupportFunctions
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupSimple extends AbsMovieCentralPage
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public const CLOSE_BUTTON:String = "close_button_pushed";
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mBackground:MovieClip
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupSimple(pMessage:String = null):void
		{
			super();
			setupPage ()
			setupMessage(pMessage)
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function updateText(pMessage:String = null, pWidth = 300)
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
			addImage("PopUpGeneric", "background");
			mBackground  = MovieClip(getChildByName("background"))
			mBackground.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			mBackground.myText.htmlText = pMessage
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		
		private function closePopup(evt:MouseEvent = null):void
		{
			dispatchEvent(new Event (CLOSE_BUTTON))
			mBackground.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN, closePopup)
			mBackground = null;
			cleanup();
		}
	}
	
}