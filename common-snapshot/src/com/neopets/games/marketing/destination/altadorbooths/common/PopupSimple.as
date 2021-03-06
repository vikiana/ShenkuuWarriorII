/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.altadorbooths.common
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import caurina.transitions.Tweener;
	
	import com.neopets.users.abelee.utils.SupportFunctions;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupSimple extends AbstractPageCustom
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public const CLOSE_BUTTON:String = "close_button_pushed";
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var xPos:Number;
		protected var yPos:Number;
		private var mAutoClose:Boolean;
		private var mTextBoxSize:int;	//1 big (title), 2 mid, 3 small

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupSimple(pMessage:String = null, px:Number = 0, py:Number = 0, pTextSize:int = 2, pAutoClose:Boolean= false):void
		{
			super();
			xPos = px
			yPos = py
			mAutoClose = pAutoClose
			mTextBoxSize = pTextSize
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
			addImage("Popup", "background", xPos, yPos);
			if (mAutoClose)
			{
				
				alpha = 0
				//scaleX = 0
				scaleY = 0
				
				Tweener.addTween(this, {alpha:1, scaleY:1, time:.5, transition:"easeInElastic"});
				Tweener.addTween(this, {alpha:0, scaleY:0, time:.5, delay:1.5, onComplete:cleanMeUp,  transition:"easeOutElastic"});
				
				
			}
			else
			{
				addTextButton("Text_button", "closeButton", "Close", xPos + 290, yPos + 400);
				SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
				var btn:MovieClip = getChildByName("closeButton") as MovieClip
				btn.scaleX = btn.scaleY = .6
			}
		}
		
		
		protected override function addBackButton():void {
			//no back button
		}
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			switch  (mTextBoxSize)
			{
				case 1:
					addTextBox("LATitleTextBox", "textBox", pMessage, xPos + 350 , yPos + 150);
					break;
					
				case 2:
					addTextBox("LAGenericTextBox", "textBox", pMessage, xPos + 50 , yPos + 50);
					break;
				
				case 3:
					addTextBox("LASmallTextBox", "textBox", pMessage, xPos + 40 , yPos + 30);
					break;
			}
		}
		
		private function cleanMeUp():void
		{
			clearVars()
			cleanup()
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function closePopup(evt:MouseEvent = null):void
		{
			dispatchEvent(new Event (CLOSE_BUTTON))
			SupportFunctions.getChildAsMovieClip(this, "closeButton").removeEventListener(MouseEvent.MOUSE_DOWN, closePopup)
			clearVars()
			cleanup();
		}
		
		private function clearVars():void
		{
			xPos = undefined;
			yPos = undefined;
			mAutoClose = undefined;
		}
	}
	
}