/* AS3
	Copyright 2008
*/

package com.neopets.projects.gameEngine.gui.buttons
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
	 
	public class SelectedButton extends NeopetsButton
	{

		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const SELECTED:String = "selected";
		public const NOT_SELECTED:String = "notSelected";
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		
		protected var mState:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SelectedButton()
		{
			super();
			mState = "";
		}
		
		public function setSelected ():void{
			gotoAndStop("selected");	
			mState = SELECTED;
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected override function rollOverHandler():void {
				if (mState != SELECTED)
					{
						gotoAndStop("on");		
					}
					else
					{
						gotoAndStop("selected");	
					}	
		}
		
		protected override function rollOutHandler():void {
				if (mState != SELECTED)
				{
					gotoAndStop("off");		
				}
				else
				{
					gotoAndStop("selected");	
				}
		}
		
		protected override function mouseDownHandler():void {
				if (mState != SELECTED)
				{
					gotoAndStop("down");
				}
		}
		
		protected override function mouseUpHandler():void {
					if (mState != SELECTED)
					{
						gotoAndStop("selected");		
						mState = SELECTED;
						
					}
					else
					{
						gotoAndStop("off");	
						mState = NOT_SELECTED;
					}	
		}
		
		
	}
	
}
