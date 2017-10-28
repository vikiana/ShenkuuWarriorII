package com.neopets.projects.np9.system
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.util.flashvars.FlashVarsFinder;
	
	/**
	 *	This class acts as a swf wrapper for the prize pop up used by the np9 gaming system.
	 *  The swf uses flash vars loaded in by the page to properly mimic the gaming system's
	 *  prize messaging.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern ?
	 * 
	 *	@author David Cary
	 *	@since  9.25.2009
	 */
	public class NP9_Prize_Window extends MovieClip 
	{
		
		//--------------------------------------
		//  CLASS CONSTANTS
		//--------------------------------------
		public static const TEST_GAME_ID:int = 17; // unused game id # for minimal translation data
		public static const TRANSLATION_LOADING:String = "...";
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _prizePane:NP9_Prize_Pop_Up;
		protected var translator:NP9_Translator;
		// flash var values
		protected var backURL:String; // may be replaced if back-url format has a fixed pattern
		protected var gameID:int;
		protected var prizeMessageID:int;
		protected var scoreMessageID:int;
		protected var score:Number;
		protected var highScore:Number;
		protected var neopoints:String;
		protected var numPlays:int;
		protected var baseURL:String;
		protected var language:String;
		// translation strings
		protected var backLabel:String;
		
		/**
		 * @Constructor
		 * Obtains the prize movieclip and latches onto the translation object
		 */
		public function NP9_Prize_Window():void{
			prizePane = this["prize_mc"];
			translator = new NP9_Translator(true);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		/**
		 * @return	The prize window
		 */
		public function get prizePane():NP9_Prize_Pop_Up { return _prizePane; }
		
		
		/**
		 * Assigns the prize window to the object to control
		 */
		public function set prizePane(pane:NP9_Prize_Pop_Up):void {
			// clear previous listener
			if(_prizePane != null) {
				_prizePane.removeEventListener(NP9_Prize_Pop_Up.MESSAGE_RECEIVED,onMessageReceived);
				_prizePane.removeEventListener(NP9_Prize_Pop_Up.MESSAGE_FAULT,onMessageReceived);
			}
			// add new pane
			_prizePane = pane;
			if(_prizePane != null) {
				_prizePane.addEventListener(NP9_Prize_Pop_Up.MESSAGE_RECEIVED,onMessageReceived);
				_prizePane.addEventListener(NP9_Prize_Pop_Up.MESSAGE_FAULT,onMessageReceived);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * This function tries to find all the flashvar values used by this window.
		 * @see com.neopets.util.flashvars.FlashVarsFinder
		 */
		public function getFlashVars():void {
			backURL = FlashVarsFinder.findVar(root,"back_url");
			gameID = int(Number(FlashVarsFinder.findVar(root,"game_id")));
			prizeMessageID = int(Number(FlashVarsFinder.findVar(root,"prize_msg_id")));
			scoreMessageID = int(Number(FlashVarsFinder.findVar(root,"score_msg_id")));
			score = Number(FlashVarsFinder.findVar(root,"score"));
			highScore = Number(FlashVarsFinder.findVar(root,"hi_score"));
			neopoints = FlashVarsFinder.findVar(root,"np");
			numPlays = int(Number(FlashVarsFinder.findVar(root,"plays")));
			baseURL = FlashVarsFinder.findVar(root,"base_url");
			language = FlashVarsFinder.findVar(root,"lang");
		}
		
		/**
		 * This function sets up the pop up using our loaded values.
		 */
		public function loadMessage():void {
			if(_prizePane != null) {
				// clear previous message
				_prizePane.contentPane.clearItems();
				// set language
				_prizePane.language = language;
				// show pending message
				_prizePane.addText(translator.getTranslation("IDS_SM_pending"));
				_prizePane.gatewayURL = baseURL + "amfphp/gateway.php";
				_prizePane.loadMessage(gameID,score,prizeMessageID,numPlays);
			}
		}
		
		/**
		 * This function supplies default values for offline testing.
		 */
		public function setDefaults():void {
			if(backURL == null) backURL = "http://www.neopets.com/index.phtml";
			if(backLabel == null) backLabel = "Back to Site";
			if(baseURL == null) baseURL = "http://www.neopets.com/";
			if(language == null) language = "en";
			if(scoreMessageID == 0) scoreMessageID = 1;
			if(neopoints == null) neopoints = "0";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * This function is called when the window is added to the stage.
		 */
		public function onAddedToStage(ev:Event):void {
			if(ev.target == this) {
				getFlashVars();
				setDefaults(); // used for offline testing
				// make sure translation is set up
				if(translator.translationComplete()) {
					loadMessage();
				} else {
					if(_prizePane != null) {
						_prizePane.addText(TRANSLATION_LOADING);
					}
					translator.init(baseURL,TEST_GAME_ID,language);
					translator.callTranslation();
					addEventListener(Event.ENTER_FRAME,waitForTranslation);
				}
			}
		}
		
		/**
		 * This function is called each frame until the translator is done getting set up.
		 */
		public function waitForTranslation(ev:Event):void {
			if(translator.translationComplete()) {
				backLabel = translator.getTranslation("FGS_GAME_OVER_MENU_RESTART_GAME");
				loadMessage();
				removeEventListener(Event.ENTER_FRAME,waitForTranslation);
			}
		}
		
		/**
		 * This function is called as soon the amfphp response comes in.
		 */
		public function onMessageReceived(ev:Event):void {
			if(_prizePane != null) {
				// clear previous message
				_prizePane.contentPane.clearItems();
				// add point total text
				showPointsText(score,neopoints);
				// add in basic score results messaging
				_prizePane.addText(getMsgResult(scoreMessageID,String(neopoints)));
				// add the back button
				if(backURL != null) {
					var link_vars:Array;
					link_vars = [backLabel,backURL,"_self"];
					//link_vars = ["<a href='"+backURL+"' target='_self'>"+backLabel+"</a>"];trace(link_vars);
					_prizePane.addLinks([link_vars]);
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Use this to add the score-np line to the text block.
		 * This function is based on it's counterpart in NP9_Scoring_Meter.
		 * @param	p_nScore	Score obtained
		 * @param	p_nNP		NP given to the player
		 */		
		protected function showPointsText( p_nScore:Number, p_nNP:String ):void {
			var t_sStr:String = translator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += translator.getTranslation("IDS_SM_score") + " " + String( p_nScore );
			t_sStr += "   " + translator.getTranslation("IDS_SM_npscore") + " " + String( p_nNP );
			t_sStr += translator.getTranslation("IDS_SM_TAG_CLOSE");
			_prizePane.addText(t_sStr);
		}
		
		/**
		 * Use this to get the basic score results text.
		 * This function is based on it's counterpart in NP9_Scoring_Meter.
		 * @param	msgID			ID of the message to display
		 * @param	sNewNP			String text to display upon success
		 * @return
		 */		
		protected function getMsgResult( msgID:Number, sNewNP:String ):String {

			var t_sResult:String = translator.getTranslation("IDS_SM_TAG2_OPEN");
			
			switch ( msgID )
			{
				case 1:
					t_sResult += translator.getTranslation("IDS_SM_success") + " " + sNewNP;
					break;
					
				case 2:
					t_sResult += translator.getTranslation("IDS_SM_bonus") + " " + sNewNP;
					break;
					
				case 3:
					t_sResult += translator.getTranslation("IDS_SM_ERR_MAXPLAYS");
					break;
					
				case 4:
					t_sResult += translator.getTranslation("IDS_SM_ERR_ZEROSCORE");
					break;
					
				case 5:
					t_sResult += "<font size='14' color='#ff0000'>D'oh...<br>Can't send score in<br>Offline Mode!</font>";
					//translator.getTranslation("IDS_SM_ERR_UNKNOWN");
					break;
					
				case 6:
					t_sResult += translator.getTranslation("IDS_SM_ERR_INVALID");
					break;
					
				case 7:
					t_sResult += translator.getTranslation("IDS_SM_ERR_TIMEOUT");
					break;
					
				case 8:
					t_sResult += translator.getTranslation("IDS_SM_ERR_NOLOGIN");
					break;
					
				case 9:
					t_sResult += translator.getTranslation("IDS_SM_ERR_CHALLENGE");
					break;
					
				case 10:
					t_sResult += translator.getTranslation("IDS_SM_ERR_COOKIE");
					break;
					
				case 11:
					t_sResult += translator.getTranslation("IDS_SM_ERR_NOCHALL");
					break;
					
				case 12:
					t_sResult += translator.getTranslation("IDS_SM_ERR_CHALLSLOW");
					break;
					
				case 13:
					t_sResult += translator.getTranslation("IDS_SM_ERR_DC_COMP");
					break;
					
				case 14:
					t_sResult += translator.getTranslation("IDS_SM_ERR_DC_TIME");
					break;
					
				case 15:
					t_sResult += translator.getTranslation("IDS_SM_ERR_REVIEW");
					break;
					
				case 16:
					t_sResult += translator.getTranslation("IDS_SM_ERR_QUICK_SESSION");
					break;
					
				case 17:
					t_sResult += translator.getTranslation("IDS_SM_ERR_MISSING_HASH");
					break;
					
				case 18:
					t_sResult += translator.getTranslation("IDS_SM_ERR_WC_TOO_LOW");
					break;
					
				case 19:
					t_sResult += translator.getTranslation("IDS_SM_DD_SUCCESS");
					break;
					
				case 20:
					t_sResult += translator.getTranslation("IDS_SM_DD_NOSUCCESS");
					break;
				case 21:
					t_sResult += translator.getTranslation("IDS_SM_AC_MAX_SCORE");
				break;
			}
			
			var t_sCloseTag:String = "</font>";
			
			t_sResult += t_sCloseTag;
			
			// add hiscore and plays if no error occurred
			var t_sStr:String;
			if ( msgID < 3 ) {
				t_sStr = "<br>" + translator.getTranslation("IDS_SM_hiscore") + " " + String(highScore);
				t_sStr += t_sCloseTag;
				t_sStr += "<br>" + translator.getTranslation("IDS_SM_plays") + " " + String(numPlays);
				t_sStr += t_sCloseTag;
				t_sResult += t_sStr;
			}
			
			t_sResult += translator.getTranslation("IDS_SM_TAG_CLOSE");
			
			return t_sResult;
		}
		
	}
	
}