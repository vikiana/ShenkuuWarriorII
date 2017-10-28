
/* AS3
	Copyright 2008
*/
package com.neopets.projects.gameEngine.gui
{
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *	This is an Absolute Class for Basic Menu Functions. You should not Insatiate this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern NP9 Game Engine
	 * 
	 *	@author Clive Henrick
	 *	@since 7.07.2009
	 */
	 
	public class AbsMenu extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const BUTTON_PRESSED:String = "MenuButtonPressed";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var mID:String;
		
		protected var mButtonLock:Boolean;
		protected var mParentMenuID:String;
		
		protected var mButtonArray:Array;
		//protected var mButtonArray:Vector.<NeopetsButton>; // Vector not supported by Flash Player 9
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function AbsMenu():void{
			mButtonLock = false;
			mButtonArray = new Array();
			//mButtonArray = new Vector.<NeopetsButton>(); // Vector not supported by Flash Player 9
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set menuButtonLock(pFlag:Boolean):void
		{
			mButtonLock = pFlag;	
			

			var tCount:int = mButtonArray.length;
				
			for (var i:int = 0; i < tCount; i++)
			{
				NeopetsButton(mButtonArray[i]).lockOut = mButtonLock;
			}

		}
		
		public function get menuButtonLock():Boolean
		{
			return mButtonLock;
		}
		
		public function set parentMenuID(pParentID:String):void
		{
			mParentMenuID = pParentID;
		}
		
		public function get parentMenuID():String
		{
			return mParentMenuID;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: When a Btn of the Stage is Clicked. Sends it up to the InterfaceManager.
		 */
		 
		protected function MouseClicked(evt:Event):void
		{
			
			if (!mButtonLock)
			{
				this.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_PRESSED));	
			}
			else
			{
				trace ("ButtonLock is Active for Menu: " + mID);
			}
			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
