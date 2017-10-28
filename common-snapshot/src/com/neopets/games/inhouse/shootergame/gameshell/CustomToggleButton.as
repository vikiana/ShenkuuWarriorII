package com.neopets.games.inhouse.shootergame.gameshell
{
	
	
	import flash.events.MouseEvent;
	
	/**
	 *	This is for a toggle button
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Viviana Baldarelli
	 *	@since  6.11.2009
	 */
	public class CustomToggleButton extends CustomButton
	{
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var isOff:Boolean;
		
		
		/**
		 *	@Constructor
		 */
		public function CustomToggleButton()
		{
			super();
			isOff = false;
			addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
		}
		
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		
		protected function onUp(evt:MouseEvent):void 
		{
			if (!isOff){
				gotoAndStop("off");
				isOff = true;
			} else {
				gotoAndStop("up");
				isOff = false;
			}
		}
		
		override protected function onRollOut(evt:MouseEvent):void 
		{
			if(!isOff){
				gotoAndStop("up");	
			}
		}
		
		override protected function onRollOver(evt:MouseEvent):void 
		{	
			if (!isOff){
				gotoAndStop("over");
			}
		}
		
		override protected function onDown(evt:MouseEvent):void 
		{
			if (!isOff){
				gotoAndStop("down");
			}
			playButtonSnd();
		}
	}
}