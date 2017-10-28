/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets.countdown
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	
	/**
	 *	This is the abstract base class used by objects that show the user the number of days 
	 *  remaining until something happens.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	public class CountDownDisplay extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const DAYS_LEFT:String = "daysLeft";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CountDownDisplay():void{
			super();
			// check the target flash var
			var fvar:Object = FlashVarManager.getVar(DAYS_LEFT);
			if(fvar == null) {
				FlashVarManager.dispatcher.addEventListener(FlashVarManager.ON_INIT,onFlashVarInit);
			} else timeLeft = Number(fvar);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get timeLeft():Number {
			var fvar:Object = FlashVarManager.getVar(DAYS_LEFT);
			if(fvar == null) return 0;
			else return Number(fvar);
		}
		
		public function set timeLeft(val:Number) {
			// dummy function.  put display update code here
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onFlashVarInit(ev:Event=null) {
			timeLeft = Number(FlashVarManager.getVar(DAYS_LEFT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
