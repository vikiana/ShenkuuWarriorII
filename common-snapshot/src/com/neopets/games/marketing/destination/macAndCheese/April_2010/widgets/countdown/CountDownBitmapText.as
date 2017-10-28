/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets.countdown
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	import com.neopets.util.text.BitmapText;
	
	/**
	 *	This class handle the teaser swf.  It mostly just sets up flash var defaults.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	public class CountDownBitmapText extends BitmapText 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CountDownBitmapText():void{
			super();
			// check the target flash var
			var fvar:Object = FlashVarManager.getVar(CountDownDisplay.DAYS_LEFT);
			if(fvar == null) {
				FlashVarManager.dispatcher.addEventListener(FlashVarManager.ON_INIT,onFlashVarInit);
			} else timeLeft = Number(fvar);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get timeLeft():Number {
			var fvar:Object = FlashVarManager.getVar(CountDownDisplay.DAYS_LEFT);
			if(fvar == null) return 0;
			else return Number(fvar);
		}
		
		public function set timeLeft(val:Number) {
			if(isNaN(val)) return;
			translatedText = String(val);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onFlashVarInit(ev:Event=null) {
			timeLeft = Number(FlashVarManager.getVar(CountDownDisplay.DAYS_LEFT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
