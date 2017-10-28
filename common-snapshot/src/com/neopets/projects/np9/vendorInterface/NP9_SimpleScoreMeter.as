

/* AS3
	Copyright 2008
*/
package com.neopets.projects.np9.vendorInterface
{
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	/**
	 *	This is a simplefied version of the Score Meter for Vendors to Test With
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern NP9_VendorShell
	 * 
	 *	@author Clive Henrick
	 *	@since  7.01.2009
	 */
	 
	public class NP9_SimpleScoreMeter extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const RESTARTBTN_CLICKED:String = "TheRestartGameBtnClicked";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var mMessageTextField:TextField; 	//On the Stage
		public var mReturnButton:NeopetsButton; // On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NP9_SimpleScoreMeter():void
		{
			super();
			mReturnButton.addEventListener(MouseEvent.MOUSE_UP, dispatchRestart);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: DISPLAY SCORE SCRIPT RESULT
		 * @param		msgID				 	Number		The User ID
		 * @param		p_nScore				Number		The Score
		 */
		 
		public function showMsg( msgID:Number, p_nScore:Number):void
		{
			mReturnButton.label_txt.htmlText = "Restart Game";
			mMessageTextField.text = "Dummy Score Result: " + 	p_nScore + " USERID:" + msgID;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: The restart Btn has been clicked
		 */
		 
		private function dispatchRestart(evt:Event):void
		{
			this.dispatchEvent(new Event(RESTARTBTN_CLICKED));	
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
