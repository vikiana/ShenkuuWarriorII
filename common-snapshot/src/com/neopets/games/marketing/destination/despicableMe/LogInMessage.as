
/* AS3
	Copyright 2008
*/
package com.neopets.games.marketing.destination.despicableMe
{
	
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.projects.destination.destinationV3.Parameters;
	
	import virtualworlds.lang.TranslationManager;
	
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
		public static const LOG_IN_VAR:String = "loginURL";
		public static const DEFAULT_LOG_IN:String = "/loginpage.phtml";
		public static const SIGN_UP_VAR:String = "signupURL";
		public static const DEFAULT_SIGN_UP:String = "/reg/";
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		protected var _messageID:String;
		protected var _message:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LogInMessage(id:String=null) {
			messageID = id;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get messageID():String { return _messageID; }
		
		public function set messageID(id:String) {
			_messageID = id;
			// start with translated "please log in" text
			_message = getTranslationOf(id);
			// add login link
			var fvm:FlashVarManager = FlashVarManager.instance;
			var base_url:String = Parameters.baseURL;
			if(base_url == null) base_url = "http://dev.neopets.com";
			fvm.setDefault(LOG_IN_VAR,DEFAULT_LOG_IN);
			var path:String = fvm.getVar(LOG_IN_VAR) as String;
			_message += "<br/><a href='" + base_url + path + "'><u>" + getTranslationOf("IDS_LOG_IN") + "</u></a>";
			// add sign up link
			fvm.setDefault(SIGN_UP_VAR,DEFAULT_SIGN_UP);
			path = fvm.getVar(SIGN_UP_VAR) as String;
			_message += "<a href='" + base_url + path + "'><u>" + getTranslationOf("IDS_SIGN_UP") + "</u></a>";
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// This function lets us check for translations even if the translation manage hasn't been initialized.
		
		public function getTranslationOf(id:String) {
			var translator:TranslationManager = TranslationManager.instance;
			if(translator.translationData != null) return translator.getTranslationOf(id);
			else return id;
		}
		
		public function toString():String {
			return _message;
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
	}
}
