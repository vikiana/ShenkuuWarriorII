/* AS3
Copyright 2010
*/

package com.neopets.games.marketing.destination.CapriSun2011.subElements
{
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	import com.neopets.projects.destination.destinationV3.Parameters;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  5.18.2010
	 */
	
	public class SixFlags2010SouvenirInstructionPop extends MovieClip
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLOSE_BTN_EVENT:String = "closeBtnClicked";
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var close_btn:HiButton; //Onstage

		public var textField:TextField; //OnStage
	
		
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SixFlags2010SouvenirInstructionPop()
		{
			close_btn.addEventListener(MouseEvent.CLICK, closePopUp, false, 0, true);
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
		
		
		
		protected function closePopUp(evt:Event):void
		{
			this.dispatchEvent(new Event(SixFlags2010SouvenirInstructionPop.CLOSE_BTN_EVENT));	
		}
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
}

