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
	import flash.display.SimpleButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PopupAbout extends AbstractPageCustom
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
		public var enter_button:MovieClip;

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupAbout(pMessage:String = null, px:Number = 0, py:Number = 0, pTextSize:int = 2, pAutoClose:Boolean= false):void
		{
			super();
			xPos = px
			yPos = py
			mAutoClose = pAutoClose
			mTextBoxSize = pTextSize
			setupPage ()
			
			trace ("testing", this, this.hasOwnProperty("enter_button"))
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
		
		//enter_button.addEventListener(MouseEvent.CLICK, "onClickEnterBtn");
		
		public function onClickEnterBtn(evt:MouseEvent):void
		{
			NeoTracker.processClickURL(15038);
			//trace("MR. LEE");		
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			//trace ("add about popup")
			addImage("AboutPopup", "background", xPos, yPos);
			//var about_mc:MovieClip = MovieClip(getChildByName("background"))
			
			//about_mc.enter_button.addEvenListener(MouseEvent.CLICK, "onClickEnterBtn");
			//about_mc.enter_button.alpha = .3
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
				addTextButton("Close_button", "closeButton", "", 325, 450);
				SupportFunctions.getChildAsMovieClip(this, "closeButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
				
				
				//trace ("test", about_mc, about_mc.hasOwnProperty("enter_button")); 
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
			trace ("nothing is tracing")
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