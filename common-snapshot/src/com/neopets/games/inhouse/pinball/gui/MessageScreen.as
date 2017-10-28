
/* AS3
	Copyright 2009
*/
package com.neopets.games.inhouse.pinball.gui
{
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;


	
	/**
	 *	This is for the Message Screen
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern gameEngine, PinBall, Ape
	 * 
	 *	@author Clive Henrick
	 *	@since  6.17.2009
	 */
	 
	public class MessageScreen extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const STARTX:Number = 325;
		public const STARTY:Number = 275;
		public const FAIDOUTMSG:String = "MessageScreenCompletedFaidOut";
		
		private const TIMEDELAY:Number = 4000;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mTimer:Timer;
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		public var textBox:TextField;			//This is on Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MessageScreen()
		{
			super();
			mTimer = new Timer(TIMEDELAY);
			mTimer.addEventListener(TimerEvent.TIMER,timeDone,false,0,true);
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function startMessage():void
		{
			visible  = true;	
			mTimer.start();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function timeDone(evt:TimerEvent):void
		{
			visible = false;
			mTimer.stop();
			mTimer.reset();
			dispatchEvent(new Event(FAIDOUTMSG));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	
	}
	
}
