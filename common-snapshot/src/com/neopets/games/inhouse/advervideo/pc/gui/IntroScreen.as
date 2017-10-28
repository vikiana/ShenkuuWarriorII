/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.neopets.games.inhouse.advervideo.pc.PCGameEngine;
	import com.neopets.games.inhouse.advervideo.pc.GameUtilities;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;

	/**
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  7.20.2009
	 */	
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		
	 
	 public class IntroScreen extends OpeningScreen {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _func:Function;
		private var _cd:int;
		private var _lastpos:int;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var startGameButton2:CustomButton;
		
		public var aboutButton:NeopetsButton; 			//On Stage
		public var viewTrailerButton:NeopetsButton;	//On Stage
		public var visitWebsiteButton:NeopetsButton;	//On Stage
		//public var visitWebsiteButton2:NeopetsButton;	//On Stage
		
		public var msg_txt:TextField;
		
		public var mcAcara:MovieClip;
		public var mctv:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function IntroScreen():void {
			super();
			setupExtendedVars();
			
			//setSuccessMessage(0, 5);
			_lastpos = 0;
			_func = idleFunction;
			addEventListener(Event.ENTER_FRAME, efFunction);
			hideButtons();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function inFocus():void {
			trace("@ Intro menu");
			restartIntroAnim();
		}
		
		public function outFocus():void {
			_func = idleFunction;
			hideButtons();
		}
		
		/**
		 * Sets the message on the light blue bar
		 * @param	p_str
		 */
		public function setMessage(p_str:String = ""):void {
			NPTextData.pushCustomText(this, "msg_txt", p_str);
		}
		
		public function setPlayMessage(pCurrPlays:int, pMaxPlays:int, canPlay:Boolean = true):void {
			var str:String;
			if (canPlay) {
				str = NPTextData.getTranslationOf("IDS_WELCOME_PLAY_ALLOWED");
				showButtons();
			} else {
				str = NPTextData.getTranslationOf("IDS_WELCOME_NO_PLAY_ALLOWED");
				hideButtons();
			}
			str = NPTextData.replaceToken(str, "%current", pCurrPlays.toString());
			str = NPTextData.replaceToken(str, "%maximum", pMaxPlays.toString());
			setMessage(str);
		}
		
		/**
		 * Display login success message
		 * @param	p_view
		 * @param	p_total
		 */
		public function setSuccessMessage(p_view:int, p_total:int):void {
			var str:String = NPTextData.getTranslationOf("IDS_INTRO_MSG");
			str = NPTextData.replaceToken(str, "%0", p_view.toString());
			str = NPTextData.replaceToken(str, "%1", p_total.toString());
			setMessage(str);
			showButtons();
		}
		
		/**
		 * Displays message for not logged in players. Hides buttons
		 * @param	p_str
		 */
		public function setFailMessage(p_str:String):void {
			setMessage(p_str);
			hideButtons();
		}
		
		public function hideButtons():void {
			startGameButton2.visible = false;
			instructionsButton.visible = false;
			aboutButton.visible = false;
			viewTrailerButton.visible = false;
			visitWebsiteButton.visible = false;
		}
		
		public function showButtons():void {
			startGameButton2.visible = true;
			instructionsButton.visible = true;			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		private function startGame(e:MouseEvent):void {
			PCGameEngine.instance.startCustomGame();
			PCGameEngine.instance.playSound("MouseClick");
		}
		
		private function efFunction(e:Event):void {
			_func();
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		private function idleFunction():void {
			
		}
		
		/**
		 * @Note: Setups Extended Variables
		 */ 
		private function setupExtendedVars():void {
			if (startGameButton2) {
				startGameButton2.setText(NPTextData.menuText("IDS_NEW_PLAYGAME_TXT"));
				startGameButton2.addEventListener(MouseEvent.MOUSE_UP, startGame);
				startGameButton2.tabEnabled = false;				
			}
			/*if (visitWebsiteButton2) {
				visitWebsiteButton2.setText(NPTextData.getTranslationOf("IDS_MENU_WEBSITE2"));
				//NPTextData.pushCustomText(visitWebsiteButton2, "label_txt", NPTextData.asMenuButtonText(NPTextData.getTranslationOf("IDS_MENU_WEBSITE2")));
				
				visitWebsiteButton2.addEventListener(MouseEvent.MOUSE_UP, destinationHandler, false, 0, true);
				visitWebsiteButton2.tabEnabled = false;
			}*/
			
			startGameButton.tabEnabled = false;
			instructionsButton.tabEnabled = false;
			musicToggleBtn.tabEnabled = false;
			soundToggleBtn.tabEnabled = false;
		}
		
		private function restartIntroAnim():void {
			mctv.gotoAndStop("fixed");
			mcAcara.gotoAndStop("fixed");
			_cd = 60;
			_func = introAnim;
		}
		
		private function introAnim():void {
			if (_cd > 0) {
				_cd --;
			} else {
				_cd = 30;
				var p:int = GameUtilities.instance.randRange(1, 4);
				while (p == _lastpos) {
					p = GameUtilities.instance.randRange(1, 4);
				}
				_lastpos = p;
				mcAcara.gotoAndStop("pos" + _lastpos.toString());
				if (mctv.currentFrame == mctv.totalFrames) mctv.gotoAndPlay("broken");
			}
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}