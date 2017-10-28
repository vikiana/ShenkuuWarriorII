/**
 *	This class handles the first page users should see on entering the destination.
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
	import flash.display.SimpleButton;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import com.neopets.util.sound.SoundManager;
	
	public class MessagePopUp extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static const CLOSE_SOUND:String = "Magic_PersonalShieldForm2";
		// protected variables
		protected var _closeButton:InteractiveObject;
		// public variables
		public var closeSound:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MessagePopUp():void {
			closeButton = this["close_btn"];
			// set up sounds
			if(closeSound == null) {
				closeSound = CLOSE_SOUND;
				var sounds:SoundManager = SoundManager.instance;
				if(!sounds.checkSoundObj(CLOSE_SOUND)) {
					sounds.loadSound(CLOSE_SOUND,sounds.TYPE_SND_INTERNAL);
				}
			}
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get closeButton():InteractiveObject { return _closeButton; }
		
		public function set closeButton(btn:InteractiveObject) {
			// clear previous button
			if(_closeButton != null) {
				_closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			}
			// set new button
			_closeButton = btn;
			if(_closeButton != null) {
				_closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
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
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**	
		 *	This function tries to close the pop up.
		 *	@PARAM		ev		Optional: event which triggered the close request
		 **/
		
		public function onCloseRequest(ev:Event=null):void {
			visible = false;
			if(closeSound != null) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(closeSound);
			}
		}

	}
	
}