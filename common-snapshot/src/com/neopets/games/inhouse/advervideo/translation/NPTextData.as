/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.advervideo.translation
{
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.advervideo.game.*;
	
	/**
	 *	This is a List of All the Text that needs to be Translated by the System
	 *	You can see this File Online http://www.neopets.com/transcontent/flash/game_13000.txt
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Translation System
	 * 
	 *	@author Koh Peng Chuan
	 *	@since  8.25.2009
	 */
	 
	dynamic public class NPTextData extends TranslationData 
	{
		
		
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		/*
		public static const FGS_MAIN_MENU_START_GAME:String = "Start Game";
		public static const FGS_MAIN_MENU_VIEW_INSTRUCTIONS:String = "View Instructions";
		public static const FGS_MAIN_MENU_VISIT_WEBSITE:String = "Visit Website";
		public static const FGS_MAIN_MENU_VIEW_TRAILER:String = "View Trailer";
		public static const FGS_MAIN_MENU_TURN_MUSIC_OFF:String = "Music Off";
		public static const FGS_MAIN_MENU_TURN_SOUND_OFF:String = "Sounds Off";
		public static const FGS_MAIN_MENU_TURN_MUSIC_ON:String = "Music On";
		public static const FGS_MAIN_MENU_TURN_SOUND_ON:String = "Sounds On";
		public static const FGS_OTHER_MENU_GO_BACK:String = "Go Back";
		public static const FGS_OTHER_MENU_HIGH_BANDWIDTH:String = "High Bandwidth";
		public static const FGS_OTHER_MENU_LOW_BANDWIDTH:String = "Low Bandwidth";
		public static const FGS_OTHER_MENU_MORE:String = "More";
		public static const FGS_GAME_MENU_END_GAME:String = "End Game";
		public static const FGS_GAME_OVER_MENU_RESTART_GAME:String = "Restart Game";
		public static const FGS_GAME_OVER_MENU_SEND_SCORE :String = "Send Score";
		public static const IDS_FGS_PRESS_ANY_KEY:String ="Press Any Key To Continue";
		*/
		public var IDS_MENU_WRAPPER:String = "<p align='center'><font size='24'><b><i>%0</i></b></font></p>";
		public var FGS_MAIN_MENU_ABOUT:String = "About";
		public var IDS_NEW_PLAYGAME_TXT:String = "Watch a Video<br />and Earn Neopoints";
		public var IDS_INTRO_MSG:String = "<p align='center'><font size='18'><b><i>WELCOME TO ADVER-VIDEO!<br />YOU HAVE VIEWED %0 OF %1 VIDEOS TODAY!</i></b></font></p>"
			
		//TITLES
		public var IDS_TITLE_NAME:String = "<p align='center'><font size='36'></font></p>";
		
		//MISC
		public var IDS_COPYRIGHT_TXT:String = "<p align='right'><font size='10'><b></b></font></p>";
		
		// trailer
		public var IDS_TRAILER_TITLE_TXT:String = "<p align='center'><font size='50'><b>TRAILER</b></font></p>";
		public var IDS_TRAILER_HIBAND_TXT:String = "High Bandwidth";
		public var IDS_TRAILER_LOBAND_TXT:String = "Low Bandwidth";
		
		// GameOver
		public var GAMEOVER_YOURSCORE_TXT:String = "<p align='center'><font size='60'>Your Score</font></p>";
		public var GAMEOVER_YOURSCORE_VAL:String = "<p align='center'><font size='60'>%0</font></p>";
		
		// About
		public var IDS_ABOUT_TITLE_TXT:String = "<p align='center'><font size='50'><b>ABOUT</b></font></p>";
		public var IDS_ABOUT_CONTENT_TXT:String = "<p align='left'><font size='20'></font></p>";
		
		// Instructions
		public var IDS_INSTRUCTIONS_TITLE_TXT:String = "<p align='center'><font size='40'><b>INSTRUCTIONS</b></font></p>";
		public var IDS_INSTRUCTIONS_CONTENT_TXT:String = "<p align='center'><font size='20'>Have you ever wished that you could earn Neopoints just by watching TV?  Well, now you can! An Acara named Samo is getting the video feed ready for you.  So just sitback, relax, and enjoy the fun video!  When it's over, you'll get to spin the wheel to earn your Neopoints prize*!</font></p>";
		
		// ported content
		public var IDS_ERROR_LOADING_ERRORCODE:String =  "<P ALIGN=\"CENTER\"><FONT SIZE=\"22\">Error Code: %error_code. Please try again later!</FONT></P>";
		public var IDS_WELCOME_PLAY_ALLOWED:String  	=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"22\">Welcome to Adver-Video!<BR> You have viewed %current of %maximum videos today.</FONT></P>";
		public var IDS_WELCOME_NO_PLAY_ALLOWED:String  =  "<P ALIGN=\"CENTER\"><FONT SIZE=\"22\">You have already viewed %current of %maximum videos today.<BR>Please come back tomorrow.</FONT></P>";
		    
		public var IDS_START_GAME:String     			=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Watch a Video\n and Earn Neopoints</FONT></P>";
		public var IDS_VIEW_INSTRUCTIONS:String  		=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">View Instructions</FONT></P>";
		
		public var IDS_START_PLAYING:String    			=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Start the Video</FONT></P>";
		public var IDS_VIDEO_DONE_PLAYING:String		=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Spin the wheel to earn your Neopoints prize!</FONT></P>";
		public var IDS_SPIN_WHEEL:String     			=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Spin the Wheel and Earn NP!</FONT></P>";
		public var YOU_WON_NEOPOINTS_FROM:String  		=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Congratulations, You Earned %neopoints Neopoints!</FONT></P>";
		public var IDS_RETURN_TO_MAIN_MENU:String  		=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Return to Main Menu</FONT></P>";
		public var IDS_VIDEO_LOADED:String   			=  "<P ALIGN=\"CENTER\"><FONT SIZE=\"20\">Enjoy this fun video! When it's over, you'll get to spin a wheel to earn your Neopoints prize!</FONT></P>";
		public var IDS_NP:String						=  "NP";
		public var IDS_RESUME_VIDEO_STR:String			=  "<P ALIGN='CENTER'><FONT SIZE='20'>Resume Video</FONT></P>";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private static var _instance:NPTextData;
		private static var _spritetimer:Sprite;
		private static var _func:Function;
		private static var _waitlist:Array;
		
		private static var _tmanager:TranslationManager;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NPTextData():void{
			super();
			if (_instance) {
				throw new Error("[NPTextData] Invalid Singleton access. Use NPTextData.instance.");
			} else {
				_instance = this;
				_spritetimer = new Sprite();
				_waitlist = [];
				_func = idleFunction;
				_spritetimer.addEventListener(Event.ENTER_FRAME, efFunction);
				_tmanager = TranslationManager.instance;
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():NPTextData {
			return _instance;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function efFunction(e:Event):void {
			_func();
		}
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Do nothing
		 */ 				
		private static function idleFunction():void {}
		
		/**
		 * @Note: Processes all unprocessed textfields; when all textfields are processed, stop the check and clear the waitlist array
		 */ 				
		private static function waitListProcess():void {
			trace("processing");
			var noprocess:Boolean = true;
			for (var i:int = 0; i < _waitlist.length; i ++) {
				if (_waitlist[i]) {
					noprocess = false;
					if (_waitlist[i].tf) {
						setText(_waitlist[i].tf, _waitlist[i].txt);
						_waitlist[i] = null;
					}
				}
			}
			if (noprocess) {
				_func = idleFunction;
				_waitlist.length = 0;
			}
		}
		
		/**
		 * @Note: Adds a texfield and its contents to a waitlist for processing
		 * @param		p_tf				TextField 							The textfield
		 * @param		p_text			String 								The text content of the textfield
		 */ 				
		private static function pushToWaitList(p_tf:TextField, p_text:String):void {
			trace("using wait list: " + p_tf + " - " + p_text);
			var i:int = 0;
			while ((i < _waitlist.length) && (_waitlist[i])) i ++;
			_waitlist[i] = {tf:p_tf, txt:p_text};
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		/**
		 * @Note: Replaces a particular text in a string
		 * @param		poriginal			String 		The text to be worked on
		 * @param		preplace				String 		The text to be replaced on poriginal
		 * @param		ptext					String 		The replacing text
		 * @return		String								The final text with the replaced string
		 */ 				
		public static function replaceToken(poriginal:String, preplace:String, ptext:String):String {
			return poriginal.split(preplace).join(ptext);
		}
		
		/**
		 * @Note: Replaces a particular text in a string; Better version than replaceToken - but slower
		 * @param		poriginal			String 		The text to be worked on
		 * @param		preplace				String 		The text to be replaced on poriginal
		 * @param		ptext					String 		The replacing text
		 * @return		String								The final text with the replaced string
		 */ 				
		public static function replaceText(poriginal:String, preplace:String, ptext:String):String { // finds <preplace> in <poriginal> and change it to <ptext>
			var res:String = "", strlength:int = poriginal.length, rlength:int = preplace.length, lastp:int = strlength - rlength, i:int = 0, lastbreak:int = 0;
			if ((poriginal != null) && (poriginal.length > 0)) {
				while (i <= lastp) {
					if (poriginal.substr(i, rlength) == preplace) { // match
						res += poriginal.substr(lastbreak, i - lastbreak) + ptext;
						i += rlength;
						lastbreak = i;
					} else { // not a match
						i ++
					}
				}
				res += poriginal.substr(lastbreak, strlength - lastbreak);
			} else {res = ptext;} // return the ptext string if poriginal is non-existent
			return res;
		}

		/**
		 * @Note: Produces a string output for menu buttons
		 * @param		p_string			String 		The text to be wrapped
		 * @return		String							The final text with all html formatting tags added
		 */ 				
		public static function asMenuButtonText(p_string:String):String {
			return replaceToken(getTranslationOf("IDS_MENU_WRAPPER"), "%0", p_string);
		}
		
		/**
		 * @Note: Produces a string output for menu buttons out of string variables
		 * @param		p_textname			String 		The variable name of the text to be wrapped
		 * @return		String									The final text with all html formatting tags added
		 */ 				
		public static function menuText(p_textname:String):String {
			return asMenuButtonText(getTranslationOf(p_textname));
		}
		
		/**
		 * @Note: Adds text to a textfield
		 * @param		p_obj				DisplayObjectContainer 		The parent container of the textfield
		 * @param		p_tf				String 								The name of the textfield
		 * @param		p_text			String 								The text content of the textfield
		 */ 				
		public static function pushCustomText(p_obj:DisplayObjectContainer, p_tf:String, p_text:String):void {
			if (p_obj) {
				setText(p_obj[p_tf], p_text);
			} else {
				trace("[NPTextData] Warning: " + p_tf + " parent container not intialized yet or does not exist.");
			}
		}
		
		/**
		 * @Note: Adds text to a textfield, pushes it to a waitlist for autoprocessing if the textfield is not immediately available
		 * @param		p_tf				TextField 							The textfield
		 * @param		p_text			String 								The text content of the textfield
		 */ 				
		public static function setText(p_tf:TextField, p_text:String):void {
			if (p_tf) {
				p_tf.x = int(p_tf.x);
				p_tf.y = int(p_tf.y);
				p_tf.mouseEnabled = false;
				//p_tf.htmlText = p_text;
				_tmanager.setTextField(p_tf, p_text);
			} else {
				pushToWaitList(p_tf, p_text);
				_func = waitListProcess;
			}
		}
		
		/**
		 * @Note: Returns the translation text denoted by p_textname. Will return this textname if nothing is found
		 * @param		p_textname		String				The name of the text variable
		 * @return		String 										The text content of the variable
		 */ 				
		public static function getTranslationOf(p_textname:String):String {
			var str:String = _tmanager.getTranslationOf(p_textname);
			if (str == p_textname) {
				if (NPTextData[p_textname]) {
					str = NPTextData[p_textname];
				} else {
					str = "<p align='center'><font size='10'>" + p_textname + "</font></p>";
				}
			}
			return str;
		}
		
		
		
		
		
		
		public static function updateViewTrailerText(p_mc:DisplayObjectContainer):void {
			pushCustomText(p_mc["hibandBtn"], "label_txt", menuText("IDS_TRAILER_HIBAND_TXT"));
			pushCustomText(p_mc["lobandBtn"], "label_txt", menuText("IDS_TRAILER_LOBAND_TXT"));
			pushCustomText(p_mc, "trailer_title_txt", getTranslationOf("IDS_TRAILER_TITLE_TXT"));
		}
		
	}
	
}
