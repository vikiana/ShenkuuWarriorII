
/* AS3
	Copyright 2009
*/
package  com.neopets.games.inhouse.G1156.displayObjects
{
	import caurina.transitions.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.26.2009
	 */
	 
	public class Rocks extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const EVENT_END:String = "RockIsDone";
		public const ROCK_DEFAULT_TIME:int = 250;
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mTimer:Timer;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Rocks():void
		{
			super();
			mTimer = new Timer(ROCK_DEFAULT_TIME,1);
			mTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onStartFade, false, 0, true);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is an example
		 * @param		pCMD			String 		This is an Example of a Passed parameter
		 * @param		pBuyHowMuch		uint 		This is an Example of a Passed parameter
		 */
		 
		public function start():void
		{
			mTimer.start();		
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onStartFade(evt:TimerEvent):void
		{

			Tweener.addTween(
           		this, 
           		{
           			alpha:0,
           			time:.5,
           			onComplete:onSendMessage
           		}
           	);  				
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function onSendMessage():void
		{
			this.dispatchEvent(new Event(EVENT_END));	
			mTimer.stop();
			mTimer = null;
		}
	}
	
}
