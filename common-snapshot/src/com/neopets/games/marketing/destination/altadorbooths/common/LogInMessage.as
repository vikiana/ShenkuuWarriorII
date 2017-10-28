
/* AS3
	Copyright 2008
*/
package com.neopets.games.marketing.destination.altadorbooths.common
{
	
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.projects.destination.destinationV3.Parameters;
	
	/**
	 *	This class provides the "must be logged in to.." message.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick
	 *	@since  04.14.2010
	 */
	 
	public class LogInMessage extends Object
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		public static const MSG_TEMPLATE:String = "You must be logged in to %a!";
		public static const LOG_IN_VAR:String = "loginURL";
		public static const DEFAULT_LOG_IN:String = "/loginpage.phtml";
		public static const SIGN_UP_VAR:String = "signupURL";
		public static const DEFAULT_SIGN_UP:String = "/reg/";
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		protected var _activity:String;
		protected var _message:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LogInMessage(act:String="...") {
			activity = act;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get activity():String { return _activity; }
		
		public function set activity(act:String) {
			_activity = act;
			// load template
			_message = MSG_TEMPLATE;
			// insert activity
			_message = _message.replace("%a",_activity);
			// add login link
			var fvm:FlashVarManager = FlashVarManager.instance;
			var base_url:String = Parameters.baseURL;
			if(base_url == null) base_url = "http://dev.neopets.com";
			fvm.setDefault(LOG_IN_VAR,DEFAULT_LOG_IN);
			var path:String = fvm.getVar(LOG_IN_VAR) as String;
			_message += "<br/><br/><a href='" + base_url + path + "'><u>Log In</u></a>";
			// add sign up link
			fvm.setDefault(SIGN_UP_VAR,DEFAULT_SIGN_UP);
			path = fvm.getVar(SIGN_UP_VAR) as String;
			_message += "<br/><a href='" + base_url + path + "'><u>Sign Up</u></a>";
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function toString():String {
			return _message;
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
	}
}
