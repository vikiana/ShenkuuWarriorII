
/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/ Viviana Baldarelli / Clive Henrick
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.sixFlags2010.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.sixFlags2010.SixFlagsConstants;
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.FlagsOfFrenzyCountdown;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.FlagsOfFrenzyGame;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SharedLinksSixFlags2010;
	import com.neopets.games.marketing.destination.sixFlags2010.subElements.SixFlags2010Popup;
	import com.neopets.games.marketing.destination.sixFlags2010.text.TextSixFlags2010;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.loading.LibraryLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	public class FlagsOfFrenzy extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//icons All are on Stage
		
		//SixFlags 2010
	
		public var InstructionBtn:MovieClip;
		public var flagsOfFrenzyBack:MovieClip;
		public var goBtn:HiButton;
		
		public var messagePopUp:SixFlags2010Popup;
		
		public var MainGameArea:FlagsOfFrenzyGame;
		
		private const setupX:Number = 381.80;
		private const setupY:Number = 272.75;
		
		public static const LIBRARYID:String = "FlagsOfFrenzyScreen";
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FlagsOfFrenzy (pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			this.x = setupX;
			this.y = setupY;
			
			setupItems();
			goBtn.addEventListener(MouseEvent.CLICK, startGame,false,0,true);
			flagsOfFrenzyBack.addEventListener(MouseEvent.CLICK, returnButtonClicked,false,0,true);
			MainGameArea.addEventListener(FlagsOfFrenzyGame.GAME_OVER, onScoreReported, false,0,true);
			InstructionBtn.addEventListener(MouseEvent.CLICK,launchInstructions, false,0,true);
			
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function init(pName:String = null):void
		{
			this.name = pName;	
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 * Sets up the Stage Elements
		 */
		
		protected function setupItems():void
		{
			if (messagePopUp == null)
			{
				var tClass:Class = LibraryLoader.getLibrarySymbol("Message_popupBox");
				messagePopUp = new tClass();	
			}
			
			messagePopUp.x = -184.55;
			messagePopUp.y = -152.70;
			
			addChildAt(messagePopUp,numChildren-1);
			
			messagePopUp.visible = false;
			
			messagePopUp.addEventListener(SixFlags2010Popup.CLOSE_BTN_EVENT, closeMessageWindow, false, 0, true);
			messagePopUp.addEventListener(SixFlags2010Popup.LOGIN_BTN_EVENT, onLoginRequest, false, 0, true);
			
		}
		
		protected function launchMessageBox(pMsg:String):void
		{
			//AMFPHP MESSAGE SOMETIMES
			
			messagePopUp.textField.htmlText = pMsg;
			messagePopUp.visible = true;
		}
		
		protected function checkForAmountPlayed():void
		{
			trace("Sending the FrenzyLogin with:", Parameters.userName);
			var responder:Responder = new Responder(sixFlagsStartReturn, sixFlagsStartError);
			Parameters.connection.call("SixFlagsService.FrenzyStartService", responder,Parameters.userName );
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function sixFlagsStartReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("sixFlagsStartReturn result:",result);
			
			switch (result)
			{
				case 0: //Game Played for the day
					launchMessageBox(TextSixFlags2010.FLAGS_FRENZY_ALREADY_PLAYED);
					messagePopUp.login_btn.visible = false;	
				break;
				case 1: // Go for it
					MainGameArea.allowPrizeAward = false;
					MainGameArea.startGame();
					
				break;
				case 2: // Go for it and allow for a icon prize
					MainGameArea.allowPrizeAward = true;
					MainGameArea.startGame();	
				break;
			}
			
		}
		
		protected function sixFlagsStartError(msg:Object):void
		{
			trace("sixFlagsStartError: ", msg.toString());
		}
		
		/**
		 * WILL NEED TO MODIFY TO SHOW THE AWARD WHEN I GET THE UNDERSTANDING FROM PHP
		 */
		
		protected function amfPHPreturnScorePrize(pFlag:Boolean, pArray = null):void
		{
			//Launch POPUP with AMFPHP provide TEXT and URL for ICON
			messagePopUp.visible = true;
			messagePopUp.login_btn.visible = false;
			//Array[2] = "http://images50.neopets.com/items/foo_cheese_popcorn.gif";
			
			if (!pFlag)
			{
				messagePopUp.textField.htmlText = "Congrats! You've grabbed " + String(MainGameArea.score) + " Neopoints!";	
			}
			else
			{
				messagePopUp.textField.htmlText = "Congrats! You've grabbed " + String(MainGameArea.score) + " Neopoints<BR> AND a " + pArray[1] + "<br><a href='http://www.neopets.com/objects.phtml?type=inventory'>"+TextSixFlags2010.FLAGS_FRENZY_CHECKINVENTORY+"</a>";		
			}
			
			MainGameArea.timerBox.textField.htmlText = "30";
		}
		
		protected function onLoginRequest(evt:Event):void
		{
			var tURLREQUEST:URLRequest = new URLRequest(Parameters.baseURL + SixFlagsConstants.LOG_PATH_BASE);
			navigateToURL(tURLREQUEST,"_self");	
			
			messagePopUp.login_btn.visible = false;
			closeMessageWindow();
		}
		
		
		
		protected function closeMessageWindow(evt:Event = null):void
		{
			messagePopUp.visible = false;	
		}
		
		protected function launchInstructions(evt:Event):void
		{
			messagePopUp.textField.htmlText = TextSixFlags2010.FLAGS_FRENZY_INTRO;  
			messagePopUp.visible = true;
			messagePopUp.login_btn.visible = false;
		}
		
		/**
		 * Game is Over, Check with PHP for the End Score
		 */
		
		protected function onScoreReported(evt:Event):void
		{
			trace("TotalScore: ",MainGameArea.score, "AllowPrize:",MainGameArea.prizeAwardFlag, " UserName:",Parameters.userName);
			var responder:Responder = new Responder(frenzyScoreReturn, frenzyScoreError);
			//
			Parameters.connection.call("SixFlagsService.FrenzyEndService", responder, Parameters.userName,MainGameArea.score,MainGameArea.prizeAwardFlag);
			//Parameters.connection.call("SixFlagsService.FrenzyEndService", responder, Parameters.userName,MainGameArea.score,true);
			
		}
		
		protected function frenzyScoreReturn(msg:Object):void
		{
			if (msg.result is Array)
			{
				if (msg.result[0] == 0) // Bad result from PHP
				{
					amfPHPreturnScorePrize(false);	
				}
				else
				{
					amfPHPreturnScorePrize(true,msg.result);	
				}
			}
			//(itemID, item name, link_to_image
			trace("frenzyScoreReturn:", msg.toString());
			//Looking for the Prize array from PHP
			
			
		}
		
		protected function frenzyScoreError(msg:Object):void
		{
			trace("frenzyScoreError: ", msg.toString());
		}
		
		/**
		Starts the Game
		*/
		
		protected function startGame(evt:Event):void
		{
			if (Parameters.loggedIn)
			{
				checkForAmountPlayed();	
			}
			else
			{
				launchMessageBox(TextSixFlags2010.FLAGS_FRENZY_NOTLOGGEDIN);
				messagePopUp.login_btn.visible = true;
			}
				
		}
		
		/**
		 Ends the Game
		 */
		
		protected function returnButtonClicked(evt:Event):void
		{
			MainGameArea.endGame();
		}
	}
	
}