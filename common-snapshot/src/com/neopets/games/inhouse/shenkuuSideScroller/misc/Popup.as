/**
 *	Class for all the popups of this game
 *	In essence this class assumes a movie clip in a library has all the components
 *	The movie clip in the library will have one popup with multiple MCs in side:
 *	counter, message board and report
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  09.15.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.misc
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;
	import com.neopets.games.inhouse.shenkuuSideScroller.translation.G1149Text;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;

	
	
	
	
	public class Popup extends EventDispatcher
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		public static const COUNTER:String = "counter_text_box"; //used to get the counter TF
		public static const MESSAGE:String = "message_board"; 	 //used to get the message mc
		public static const REPORT:String  = "report_board"; 	 //used to get the report mc
		
		public static const POPUP_ACTIVITY:String = "user_interacted_with_pupup";
		public static const GAME_END_YES:String   = "game_end_yes_clicked";
		public static const GAME_END_NO:String    = "game_end_no_clicked";
		public static const GAME_CONTINUE:String  = "game_report_continue_clicked";
		
		
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private static var mReturnedInstance:Popup; //singleton instance
		private var mImage:MovieClip;		//main popup MC pulled from library
		private var mCounter:TextField;		//couner TF within mImage
		private var mMssgBoard:MovieClip;	//message MC within mImage
		private var mReportBoard:MovieClip;	//report MC within mImaeg	
		protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;
		
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function Popup(pPrivCl : PrivateClass):void
		{			
		}
		
		
		
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		/**
		 *	Singleton Pattern
		 **/
		public static function get instance( ):Popup
		{
			if( Popup.mReturnedInstance == null ) 
			{
				Popup.mReturnedInstance = new Popup( new PrivateClass( ) );
			}
			return Popup.mReturnedInstance;
		}
		
		
		
		/**
		 *	Get the popup image, it should be called only after init has been called
		 **/
		public static function get image():MovieClip
		{
			return Popup.instance.mImage;
		}
		
		
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	sets the image of the popup
		 *	@PRAAM		pImage		MovieClip		popup instance, from library or ext.art asses 
		 **/
		public static function init(pImage:MovieClip  = null):void
		{
			Popup.instance.mImage = pImage;
			Popup.instance.mCounter = Popup.image.countDown;
			Popup.instance.mMssgBoard  = Popup.image.messageBoard;
			Popup.instance.mReportBoard = Popup.image.reportBoard;
		}
		
		/**
		 *	make popup invisible
		 **/
		public static function hide():void
		{
			Popup.image.visible = false; 
		}		
		
		
		/**
		 *	show one of the sub popups within "popup" image that contains all sub popups
		 *	@PARAM		pPopup		String		one of the constants to get the specific popup 
		 *	@PARAM		pBg			String		background you want to show (preBuilt in MC, only for report)
		 *	@PARAM		pMssg		Number			Type of message to show
		 **/
		public static function showPopup(pPopup:String, pBg:String = null, pMssg:Number = -1):void
		{
			Popup.instance.showPopup(pPopup, pBg, pMssg);
		}
		
		
		
		
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		/**
		 *	show one of the sub popups within "popup" image that contains all sub popups
		 *	@PARAM		pPopup		String		one of the constants to get the specific popup 
		 *	@PARAM		pBg			String		background you want to show (preBuilt in MC, only for report)
		 *	@PARAM		pMssg		Number			Type of message to show
		 **/
		protected function showPopup(pPopup:String, pBg:String = null, pMssg:Number = -1):void
		{
			Popup.image.visible = true;
			hideChildren()
			
			switch (pPopup)
			{
				case COUNTER: //make counter visible
					mCounter.visible = true;
					break;
				
				
				case MESSAGE: //make message visble and add listener to "yes", "no" buttons
					TranslationManager.instance.setTextField(mMssgBoard.messageText, mTranslationData.IDS_CONFIRM_QUIT);
					mMssgBoard.visible = true;
					if (!mMssgBoard.yesButton.hasEventListener(MouseEvent.MOUSE_DOWN))
					{
						mMssgBoard.yesButton.addEventListener(MouseEvent.MOUSE_DOWN, onYesClick,false, 0, true);
					}
					if (!mMssgBoard.noButton.hasEventListener(MouseEvent.MOUSE_DOWN))
					{
						mMssgBoard.noButton.addEventListener(MouseEvent.MOUSE_DOWN, onNoClick,false, 0, true);
					}
					break;
					
					
				case REPORT: //make report visible and add listener to "continue" button 
					mReportBoard.visible = true;
					if (pBg != null)
					{
						mImage[pBg].visible = true;
					}
					switch (pMssg)
					{
						case 0:
							TranslationManager.instance.setTextField(mReportBoard.messageText, mTranslationData.IDS_LEVEL_FAIL);
							break;
						case 1:
							TranslationManager.instance.setTextField(mReportBoard.messageText, mTranslationData.IDS_LEVEL_1_PASS);
							break;
						case 2:
							TranslationManager.instance.setTextField(mReportBoard.messageText, mTranslationData.IDS_LEVEL_2_PASS);
							break;
						case 3:
							TranslationManager.instance.setTextField(mReportBoard.messageText, mTranslationData.IDS_LEVEL_3_PASS);
							break;
					}
					TranslationManager.instance.setTextField(mReportBoard.scoreText, mTranslationData.IDS_REPORT_SCORE);
					mReportBoard.numberText.text = GameData.score.toString();
					if (!mReportBoard.continueButton.hasEventListener(MouseEvent.MOUSE_DOWN))
					mReportBoard.continueButton.addEventListener(MouseEvent.MOUSE_DOWN,onContinueClick, false, 0, true);
					break;
			}
			mImage.bg.visible = true //make genric bg always visible
		}
		
		
		
		
		
		/**
		 *	hide all children (sub popups) of popup image
		 **/
		protected function hideChildren():void
		{
			var children:int = mImage.numChildren;
			for (var i:int = 0; i < children; i++)
			{
				mImage.getChildAt(i).visible = false;
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		
		/**
		 *	when "yes" btn is clicked from message mc, make popup invisible and dispatch  yes evt
		 **/
		protected function onYesClick(e:MouseEvent = null):void
		{
			Popup.image.visible = false;
			mMssgBoard.yesButton.removeEventListener(MouseEvent.MOUSE_DOWN, onYesClick);
			mMssgBoard.noButton.removeEventListener(MouseEvent.MOUSE_DOWN, onNoClick);
			dispatchEvent (new CustomEvent( {TYPE:GAME_END_YES}, POPUP_ACTIVITY));
			
		}
		
		
		/**
		 *	when "no" btn is clicked from message mc, make popup invisible and dispatch  no evt
		 **/
		protected function onNoClick(e:MouseEvent = null):void
		{
			Popup.image.visible = false;
			mMssgBoard.yesButton.removeEventListener(MouseEvent.MOUSE_DOWN, onYesClick);
			mMssgBoard.noButton.removeEventListener(MouseEvent.MOUSE_DOWN, onNoClick);
			dispatchEvent (new CustomEvent( {TYPE:GAME_END_NO}, POPUP_ACTIVITY));
			
		}
		
		
		/**
		 *	when "continue" btn is clicked from report, make popup invisible and dispatch cont evt
		 **/
		protected function onContinueClick(e:MouseEvent = null):void
		{
			Popup.image.visible = false;
			mReportBoard.continueButton.addEventListener(MouseEvent.MOUSE_DOWN, onContinueClick);
			dispatchEvent (new CustomEvent( {TYPE:GAME_CONTINUE}, POPUP_ACTIVITY));
		}
	}
	
}


class PrivateClass
{
	public function PrivateClass( )
	{
	}

} 