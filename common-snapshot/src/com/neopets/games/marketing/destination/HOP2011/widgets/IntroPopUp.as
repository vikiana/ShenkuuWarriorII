/**
 *	This class handle most of the text messages within a given container.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.CustomEvent;
	
	public class IntroPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const INTRO_REQUEST:String = "IntroPopUp_requested";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var closeButton:SimpleButton;
		public var mainField:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function IntroPopUp():void {
			super();
			// set up broadcaster listeners
			addParentListener(MovieClip,INTRO_REQUEST,onPopUpRequest);
			// set up children
			if(closeButton != null) closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
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

	}

	
}