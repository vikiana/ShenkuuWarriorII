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
	import flash.events.Event;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.SupportFunctions
	import caurina.transitions.Tweener;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupSimple extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public const CLOSE_BUTTON:String = "close_button_pushed";
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var xPos:Number;
		private var yPos:Number;
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
			addImage("PopUp", "background", xPos, yPos);
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
				addTextButton("KidGenericButton", "closeButton", "Close", xPos + 485, yPos + 275);
				SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
				var btn:MovieClip = getChildByName("closeButton") as MovieClip
				btn.scaleX = btn.scaleY = .6
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setupMessage(pMessage:String):void
		{
			switch  (mTextBoxSize)
			{
				case 1:
					addTextBox("KidTitleTextBox", "textBox", pMessage, xPos + 350 , yPos + 150);
					break;
					
				case 2:
					addTextBox("KidGenericTextBox", "textBox", pMessage, xPos + 50 , yPos + 50);
					break;
				
				case 3:
					addTextBox("KidSmallTextBox", "textBox", pMessage, xPos + 40 , yPos + 30);
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