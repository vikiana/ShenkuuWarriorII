/**
 *	This class handles sending out ECards.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import com.neopets.util.flashvars.FlashVarManager;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	
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
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
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
			var is_welcome:Boolean = Boolean(Number(fvm.getVar(DestinationView.ALWAYS_WELCOME)));
			trace("Show Welcome:"+is_welcome);
			if(is_welcome) {
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