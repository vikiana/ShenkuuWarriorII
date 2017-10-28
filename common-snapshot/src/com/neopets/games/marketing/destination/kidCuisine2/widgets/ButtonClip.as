/**
 *	This class lets a movieclip mimic the mouse-over behaviour of a button.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import com.neopets.util.sound.SoundManager;
	
	public class ButtonClip extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const CLICK_SOUND:String = "Menu_Click12";
		public static const OFF_FRAME:String = "off";
		public static const OVER_FRAME:String = "over";
		// public variables
		public var clickSound:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ButtonClip():void {
			// set up sounds
			if(clickSound == null) {
				clickSound = CLICK_SOUND;
				var sounds:SoundManager = SoundManager.instance;
				if(!sounds.checkSoundObj(CLICK_SOUND)) {
					sounds.loadSound(CLICK_SOUND,sounds.TYPE_SND_INTERNAL);
				}
			}
			// set up listeners
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	This functions plays our click sound.
		 **/
		
		protected function playClick() {
			if(clickSound != null) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(clickSound);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		public function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				try
				{ 
					ExternalInterface.call("sendADLinkCall", scriptID) ;
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
				}
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		protected function onMouseOut(ev:Event) {
			gotoAndPlay(OFF_FRAME);
		}
		
		/**	
		 *	This functions triggers the mouse-over animation.
		 **/
		
		protected function onMouseOver(ev:Event) {
			gotoAndPlay(OVER_FRAME);
		}
		
		/**	
		 *	This functions is triggered when the user clicks on the button.
		 **/
		
		protected function onClick(ev:MouseEvent) {
			playClick();
		}
		
	}
	
}