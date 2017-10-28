/* AS3
Copyright 2008
*/


package com.neopets.games.marketing.destination.sixFlags2010.button
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 *	This is for Simple Control of a Button with a Little More Extras
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Clive Henrick
	 *	@since  5.12.2010
	 */
	
	public class Button extends MovieClip
	{
		protected var mLockout:Boolean;
		
		public function Button()
		{
			addEventListener(MouseEvent.MOUSE_OVER,onRollOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,onRollOut,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
			buttonMode = true;
			
			mLockout = false;
			reset();
			
		}
		
		/**
		 *@Note Resets the Button to the first frame 
		 */
		
		public function reset():void
		{
			gotoAndStop(1);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onRollOver(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				rollOverHandler();
			}
		}
		
		protected function onRollOut(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				rollOutHandler();
			}
		}
		
		protected function onDown(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				mouseDownHandler();
			}
		}
		
		protected  function onUp(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				mouseUpHandler();
			}
			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function rollOverHandler():void 
		{
			gotoAndStop("on");
		}
		
		protected function rollOutHandler():void 
		{
			gotoAndStop("off");	
		}
		
		protected function mouseDownHandler():void
		{
			gotoAndStop("down");
		}
		
		protected function mouseUpHandler():void 
		{
			
		}
	}
}