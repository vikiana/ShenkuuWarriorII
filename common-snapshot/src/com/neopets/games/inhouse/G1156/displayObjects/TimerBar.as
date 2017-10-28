/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.G1156.displayObjects 
{
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 *	This is for the Timer Bar
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.24.2009
	 */
	 
	public class TimerBar extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const START_TIME:int = 60;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected  var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mTime:int;
		
		public var timerFld:TextField; 	// On Stage
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TimerBar():void{
			super();
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function reset():void
		{
			timerFld.text = String(START_TIME);
			mTime = START_TIME;	
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onUpdateTimer(evt:Event):void
		{
			mTime--;
			timerFld.text = String(mTime);
			
			if (0 >= mTime)
			{
				mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.GAME_TIMEOUT_EVENT));	
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			mSharedEventDispatcher.addEventListener( GameEvents.GAME_SLOW_TIMER_EVENT, onUpdateTimer, false,0,true);
			timerFld.text = String(START_TIME);
			mTime = START_TIME;
			
		}
	}
	
}
