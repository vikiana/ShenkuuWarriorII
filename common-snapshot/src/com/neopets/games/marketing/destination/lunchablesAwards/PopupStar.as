/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli/ original code by Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import caurina.transitions.Tweener;
	
	import com.neopets.users.abelee.utils.SupportFunctions;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupStar extends AbstractPageCustom
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
		public function PopupStar(pMessage:String = null, px:Number = 0, py:Number = 0, pTextSize:int = 2, pAutoClose:Boolean= false):void
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
		override public function updateText(pMessage:String = null, pWidth:Number = 300):void
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
			addImage("StarPopup", "background", xPos, yPos);
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
				addTextButton("Close_button", "closeButton", "Close", 333, 356);
				SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
				//var btn:MovieClip = getChildByName("closeButton") as MovieClip
				//btn.scaleX = btn.scaleY = .6
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
					addTextBox("LASmallTextBox", "textBox", pMessage, 270 , 199, 800, 50, TextFieldAutoSize.CENTER);
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