
/* AS3
	Copyright 2009
*/
package com.neopets.games.inhouse.pinball.gui
{
	import com.neopets.games.inhouse.pinball.objects.button.SelectedButton;
	import com.neopets.games.inhouse.pinball.objects.button.TextEfxButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	
	/**
	 *	This is for the IntroScreen
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern gameEngine, PinBall, Ape
	 * 
	 *	@author David Cary, Clive Henrick
	 *	@since  6.17.2009
	 */
	 
	public class IntroScene extends GameScene
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		public var startBtn:TextEfxButton;		//This is on Stage
		public var goInstructionsBtn:TextEfxButton;		//This is on Stage
		public var soundsBtn:SelectedButton; //This is on Stage
		public var musicBtn:SelectedButton; //This is on Stage
		public var innerLogo:MovieClip; // The translated Logo
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function IntroScene()
		{
			super();
			startBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			goInstructionsBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			soundsBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			musicBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		public function setTranlationLogo(pLang:String):void
		{
			innerLogo.visible = true;
			innerLogo.gotoAndStop(pLang);	
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: When a Btn of the Stage is Clicked
		 */
		 
		private function MouseClicked(evt:Event):void
		{
			this.dispatchEvent(new CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_EVENT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	
	}
	
}
