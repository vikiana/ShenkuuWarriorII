/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.neopets.util.events.EventFunctions;
	
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.BasicPopUp;
	
	public class LogInPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var signUpURL:String;
		// components
		protected var _signUpButton:DisplayObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LogInPopUp():void {
			super();
			signUpURL = "http://www.neopets.com/signup/index.phtml?";
			// get components
			signUpButton = getChildByName("signUp_btn");
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get signUpButton():DisplayObject { return _signUpButton; }
		
		public function set signUpButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_signUpButton,dobj,MouseEvent.CLICK,onSignUpClick);
			// store new component
			_signUpButton = dobj;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onSignUpClick(ev:Event) {
			var req:URLRequest = new URLRequest(signUpURL);
			navigateToURL(req);
		}
		
	}
	
}