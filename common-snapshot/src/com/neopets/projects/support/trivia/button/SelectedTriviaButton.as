/* AS3
	Copyright 2008
*/

package com.neopets.projects.support.trivia.button
{
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.sound.SoundManagerOld;
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
	 
	public class SelectedTriviaButton extends NeopetsButton
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
		
		public function SelectedTriviaButton()
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
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		protected  function onUp(evt:MouseEvent):void 
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
				checkSoundPlayBack(evt);
				gotoAndStop("on");
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
				
				checkSoundPlayBack(evt);
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
				checkSoundPlayBack(evt);
				gotoAndStop("down");
			}
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
	}
	
}
