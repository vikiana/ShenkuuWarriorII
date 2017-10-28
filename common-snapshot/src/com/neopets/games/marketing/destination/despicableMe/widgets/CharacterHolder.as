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
	import flash.events.Event;
	
	import com.neopets.util.flashvars.FlashVarManager;
	
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	
	public class CharacterHolder extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CharacterHolder():void {
			super();
			// check flash var manager
			var fvm:FlashVarManager = FlashVarManager.instance;
			fvm.setDefault(DestinationView.NUM_CHARACTERS,2);
			if(fvm.initialized) onFlashVarInit();
			else fvm.addEventListener(Event.INIT,onFlashVarInit);
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
		
		public function onFlashVarInit(ev:Event=null) {
			var fvm:FlashVarManager = FlashVarManager.instance;
			var num_char:int = int(fvm.getVar(DestinationView.NUM_CHARACTERS));
			gotoAndStop(num_char);
		}

	}
	
}