/* AS3
Copyright 2009
*/

package com.neopets.games.marketing.destination.CapriSun2011.subElements
{
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	
	public class SixFlags2010Popup extends MovieClip
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLOSE_BTN_EVENT:String = "closeBtnClicked";
		public static const LOGIN_BTN_EVENT:String = "UserNeeds to Login";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var close_btn:HiButton; //Onstage
		public var login_btn:HiButton; //Onstage
		public var textField:TextField; //OnStage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SixFlags2010Popup()
		{
			super();
			close_btn.addEventListener(MouseEvent.CLICK, closePopUp, false, 0, true);
			//login_btn.addEventListener(MouseEvent.CLICK, loginButtonClicked, false, 0, true);
			//login_btn.visible = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function closePopUp(evt:Event):void
		{
			this.dispatchEvent(new Event(SixFlags2010Popup.CLOSE_BTN_EVENT));	
		}
		
		protected function loginButtonClicked (evt:Event):void
		{
			dispatchEvent(new Event(SixFlags2010Popup.LOGIN_BTN_EVENT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
}

