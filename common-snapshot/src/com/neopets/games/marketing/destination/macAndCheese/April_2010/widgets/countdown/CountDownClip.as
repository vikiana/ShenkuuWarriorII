/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets.countdown
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
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
	public class CountDownClip extends CountDownDisplay 
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
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function set timeLeft(val:Number) {
			if(isNaN(val)) return;
			var frame_num:Number = Math.max(totalFrames-val+1,1);
			gotoAndStop(frame_num);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
