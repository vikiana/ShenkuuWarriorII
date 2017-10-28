/**
 *	This class handles sending out ECards.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	
	public class WelcomePopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const RECORD_ID:String = "Capri_Sun_Disrespectoids_Destination_Record";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var loadRecord:SharedObject;
		public var _headerField:TextField;
		public var _mainField:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function WelcomePopUp():void {
			super();
			// check flash var manager
			var fvm:FlashVarManager = FlashVarManager.instance;
			fvm.setDefault(DestinationView.ALWAYS_WELCOME,false);
			if(fvm.initialized) checkWelcome();
			else fvm.addEventListener(Event.INIT,checkWelcome);
			// set up components
			headerField = getChildByName("header_txt") as TextField
			mainField = getChildByName("main_txt") as TextField;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get headerField():TextField { return _headerField; }
		
		public function set headerField(txt:TextField) {
			_headerField = txt;
			setTranslation(_headerField,"IDS_WELCOME_HEADER");
		}
		
		public function get mainField():TextField { return _mainField; }
		
		public function set mainField(txt:TextField) {
			_mainField = txt;
			setTranslation(_mainField,"IDS_WELCOME_TEXT");
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
		
		public function checkWelcome(ev:Event=null) {
			var fvm:FlashVarManager = FlashVarManager.instance;
			if(fvm.getVar(DestinationView.ALWAYS_WELCOME)) {
				visible = true;
			} else {
				// check if this swf has been loaded previously
				loadRecord = SharedObject.getLocal(RECORD_ID);
				if(loadRecord != null) {
					var info:Object = loadRecord.data;
					visible = !("last_load" in info);
					info.last_load = new Date();
				}
			} // end of flash var check
		}

	}
	
}