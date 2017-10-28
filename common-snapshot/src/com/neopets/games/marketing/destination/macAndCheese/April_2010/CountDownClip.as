/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	
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
	public class CountDownClip extends MovieClip 
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
		public function CountDownClip():void{
			super();
			stop();
			FlashVarManager.dispatcher.addEventListener(FlashVarManager.ON_INIT,onFlashVarInit);
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
		
		protected function onFlashVarInit(ev:Event) {
			var days:Number = Number(FlashVarManager.getVar(TeaserClip.DAYS_LEFT));
			if(!isNaN(days)) {
				var frame_num:Number = Math.max(totalFrames-days+1,1);
				gotoAndStop(frame_num);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
