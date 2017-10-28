/**
 *	This site link subclass show different text depending on the user's country code.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.nav
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import com.neopets.util.flashvars.FlashVarManager;
	
	public class CCSiteLink extends SiteLink
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _CCText:Object;
		protected var _defaultCC:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CCSiteLink():void {
			super();
			_CCText = new Object();
			_defaultCC = "us";
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to add a new country code message.
		
		public function addCCText(cc:String,str:String):void {
			if(cc == null || str == null) return;
			_CCText[cc] = str;
		}
		
		// Use this function to retrieve the proper country code text based on flash var settings.
		
		public function getTextFromFlashVars():String {
			FlashVarManager.instance.initVars(root);
			var cc:Object = FlashVarManager.instance.getVar("cc");
			if(cc != null && cc in _CCText) return _CCText[cc];
			else {
				if(_defaultCC != null && _defaultCC in _CCText) return _CCText[_defaultCC];
			}
			return "";
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}