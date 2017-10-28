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
	 
	public class PopUpBoxImproved extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const EVENT_LAUNCH_POPUP:String = "LaunchThePopup";
		
		public const DELAY_TIME:int = 6000;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected  var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mDelayTimer:Timer;
		
		
		public var txtMessage:TextField; 				// On Stage
		public var txtTimeMessage:TextField;		//On Stage
	
		public var txtBonusMessage:TextField;   	//On Stage
		
		public var overallBonus:TextField;
		public var levelBonus:TextField;
		public var timeBonus:TextField;
		public var txtTime:TextField;
		public var timeBonus2:TextField;
		public var levelScore2:TextField;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function PopUpBoxImproved():void{
			setupVars();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * This will Setup this Menu
		 * @param		evt.oData.timeMsg					String 					The Time Bonus Message
		 * @param		evt.oData.time						int 						The Time Left at the End of a round
		 * @param		evt.oData.levelBonus				int 						The Bonus
		 * @param		evt.oData.overallBonus			int 						OverAll Bonus
		 * @param		evt.oData.timeBonus				int 						OverAll Bonus
		 * 
		 * 
		 * @param		evt.oData.bonusMessage		String		The Bonus Message Text
		 */
		
		 	
		protected function launchPopup(evt:CustomEvent):void
		{
			var tTranslationManager:TranslationManager = TranslationManager.instance;
		 	var tTransData:TranslationData = tTranslationManager.translationData;
		 	
		 	//TIME BONUS
		 	tTranslationManager.setTextField(txtTimeMessage, tTransData.IDS_MSG_LEVEL_SCORE);
		 	tTranslationManager.setTextField(txtMessage, tTransData.IDS_MSG_TIME_BONUS);
		 	tTranslationManager.setTextField(txtBonusMessage, tTransData.IDS_MSG_TOTAL);
		 	
			txtTime.text = String (evt.oData.time);
			
			timeBonus2.text = String(evt.oData.timeBonus);
			this.timeBonus.text = String(evt.oData.timeBonus);
			
			levelScore2.text = String(evt.oData.levelBonus);
			this.levelBonus.text = String(evt.oData.levelBonus);
			
			this.overallBonus.text = String(evt.oData.overallBonus);
			
			
			
			this.visible = true;	
			
			mDelayTimer.reset();
			mDelayTimer.start();
		}
		
		protected function onDelayTimer (evt:TimerEvent):void
		{
			mDelayTimer.stop();
			
			var tNextLevel:int = GameCore.mCurrentGameLevel + 1;
			GameCore.mCurrentGameLevel = tNextLevel;
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({level:tNextLevel}, GameEvents.GAMECOREDISPLAY_STARTNEXTLEVEL));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
				mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
				mSharedEventDispatcher.addEventListener(GameEvents.ACTIVATE_POPUP_MENU, launchPopup, false, 0, true);
				mDelayTimer = new Timer( DELAY_TIME,1);
				mDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onDelayTimer, false,0,true);
		}
	}
	
}
