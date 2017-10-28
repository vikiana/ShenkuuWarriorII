
/* AS3
	Copyright 2009
*/
package  com.neopets.games.inhouse.G1156.displayObjects
{
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This is for the PopUp Box
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  3.04.2009
	 */
	 
	public class EndMessageBox extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const EVENT_LAUNCH_MSGBOX:String = "LaunchTheEndBox";
		public const EVENT_CLOSE_MSGBOX:String = "CloseTheEndBox";
		
		public const DELAY_TIME:int = 6000;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected  var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mDelayTimer:Timer;
		
		public var roxtonLose:MovieClip; 				//On Stage
		public var roxtonWin:MovieClip;				//On Stage
		public var txtEndMessage:TextField; 				// On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function EndMessageBox():void
		{
			setupVars();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * This will Setup this Menu
		 * @param		evt.oData.message					String 					The Basic Message
		 */
		 
		 	
		protected function launchPopup(evt:CustomEvent):void
		{
			var tTranslationManager:TranslationManager = TranslationManager.instance;
		 	var tTransData:TranslationData = tTranslationManager.translationData;
		 	
		 	if (evt.oData.message == "LOSE")
		 	{
		 		tTranslationManager.setTextField(txtEndMessage, tTransData.IDS_MSG_GAMEOVER);
		 		roxtonLose.visible = true;
		 		roxtonWin.visible = false;
		 	}
		 	else
		 	{
		 		roxtonWin.visible = true;
		 		roxtonLose.visible = false;
		 		tTranslationManager.setTextField(txtEndMessage, tTransData.IDS_MSG_YouWin);		
		 	}
	
			this.visible = true;	
			
			mDelayTimer.reset();
			mDelayTimer.start();
		}
		
		protected function onDelayTimer (evt:TimerEvent):void
		{
			mDelayTimer.stop();
			
			this.dispatchEvent(new Event(EVENT_CLOSE_MSGBOX));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
				roxtonLose.visible = false;
				roxtonWin.visible = false;
				addEventListener(EVENT_LAUNCH_MSGBOX, launchPopup, false, 0, true);
				mDelayTimer = new Timer( DELAY_TIME,1);
				mDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onDelayTimer, false,0,true);
		}
	}
	
}
