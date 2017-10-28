/* AS3
	Copyright 2008
*/

package com.neopets.projects.support.trivia.button
{
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	
	
	/**
	 *	This is for Simple Control of a Button with a Little More Extras
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Clive Henrick
	 *	@since  1.30.2009
	 */
	 
	public class RadioSelectedButton extends NeopetsButton
	{

		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		
		protected var mState:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function RadioSelectedButton()
		{
			super();
			addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
			mState = "";
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get state():String
		{
			return mState;
		}
		
		
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public override function reset():void
		{
			gotoAndStop(1);
			mState = "notSelected";
		}
		
		public function setState(pString:String):void
		{
			mState = pString;
			gotoAndStop("selected");	
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		protected override function onUp(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
					if (mState != "selected")
					{
						gotoAndStop("off");		
					}
					else
					{
						gotoAndStop("selected");	
					}	
				
			}
				
		}
		
		protected override function onRollOver(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				
				
				if (mState != "selected")
				{
					gotoAndStop("on");		
				}
				else
				{
					gotoAndStop("onSelected");	
				}
				
			}
		}
		
		
		
		protected override function onRollOut(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				if (mState != "selected")
				{
					gotoAndStop("off");		
				}
				else
				{
					gotoAndStop("selected");	
				}
				
				
			}
			
		}
		
		protected override function onDown(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				if (mState != "selected")
				{
					mState = "selected";
				}
				else
				{
					mState = "notSelected";
					
				}
				
				gotoAndStop("down");
			}
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
	}
	
}
