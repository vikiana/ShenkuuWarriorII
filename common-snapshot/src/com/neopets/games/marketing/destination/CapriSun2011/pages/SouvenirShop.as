

/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/Viviana Baldarelli / Clive Henrick
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.CapriSun2011.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationControl;
	import com.neopets.games.marketing.destination.CapriSun2011.CapriSun2011Constants;
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SixFlags2010SouvenirInstructionPop;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SixFlags2010SouvenirItem;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SixFlags2010SouvenirPopup;
	import com.neopets.games.marketing.destination.CapriSun2011.text.TextSixFlags2010;
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
	
	public class SouvenirShop extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//icons All are on Stage
		
		public var InstructionBtn:MovieClip;
		public var souvenirExitBtn:MovieClip;
		public var flagMeter:MovieClip;
		public var txtFieldFlags:TextField;
		
		private const setupX:Number = 387.10;
		private const setupY:Number = 269.65;
		
		public static const LIBRARYID:String = "souvenirShop";
		
		public var messagePopUp:SixFlags2010SouvenirPopup;
		public var instructionPopUp:SixFlags2010SouvenirInstructionPop;
		
		protected var iconArray:Array;
		protected var playersFlags:Number;
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SouvenirShop (pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			this.x = setupX;
			this.y = setupY;
			iconArray = [];
			
			getAmfFlags();
			getICONSfromPHP();
			setupItems();
			addEventListener(AltadorAlleyDestinationControl.PAGE_DISPLAY,onShown);
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
		
		
		protected function positionIcon(pSouvenir:SixFlags2010SouvenirItem):void
		{
			var tX:Number;
			var tY:Number;
			
			switch (pSouvenir._location)
			{
				case 1:
					tX = -221;
					tY = -170;
					break;
				case 2:
					tX = -129;
					tY = -170;
					break;
				case 3:
					tX = -36;
					tY = -170;
					break;
				case 4:
					tX = 80;
					tY = -90;
					break;
				case 5:
					tX = 173;
					tY = -90;
					break;
				case 6:
					tX = 265;
					tY = -90;
					break;
				case 7:
					tX = -194;
					tY = 6.5;
					break;
				case 8:
					tX = -101;
					tY = 6.5;
					break;
				case 9:
					tX = -9;
					tY = 6.5;
					break;
				case 10:
					tX = 72;
					tY = 112;
					break;
				case 11:
					tX = 165;
					tY = 112;
					break;
				case 12:
					tX = 257;
					tY = 112;
					break;	
			}
			
			pSouvenir.x = tX;
			pSouvenir.y = tY;
			
			pSouvenir.buttonMode = true;
			
		}
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
				var tClass:Class = LibraryLoader.getLibrarySymbol("Message_souvenir");
				messagePopUp = new tClass();	
			}
			
			messagePopUp.x = -184.55;
			messagePopUp.y = -152.70;
			
			addChildAt(messagePopUp,numChildren-1);
			
			messagePopUp.visible = false;
			
			messagePopUp.addEventListener(SixFlags2010SouvenirPopup.CLOSE_BTN_EVENT, closeMessageWindow, false, 0, true);
			messagePopUp.addEventListener(SixFlags2010SouvenirPopup.LOGIN_BTN_EVENT, onLoginRequest, false, 0, true);
			messagePopUp.addEventListener(SixFlags2010SouvenirPopup.BUY_BTN_EVENT, onBuyRequest, false, 0, true);
			
		}
		
		/** 
		 * GET THE LIST OF ICONS FROM AMFPHP
		 */
		protected function getICONSfromPHP():void
		{
			var responder:Responder = new Responder(createIcons, createIconsError);
			Parameters.connection.call("SixFlagsService.StoreDisplayService", responder);	
		}
		
		/**
		 * See if there is enough Flags
		 */
		
		protected function checkEnoughFlags(pSouvenirObj:SixFlags2010SouvenirItem):Boolean
		{
			var tResult:Boolean;
			
			if (playersFlags - pSouvenirObj._price >= 0)
			{
				return true;	
			}
			else
			{
				return false;	
			}
		}
		
		protected function updateFlagsTxt(pFlags:int):void
		{
			txtFieldFlags.htmlText = String(pFlags) + " Flags";
		}
		
		protected function getAmfFlags():void
		{
			var responder:Responder = new Responder(getFlags, getFlagsError);
			Parameters.connection.call("SixFlagsService.StoreFlagsService", responder,Parameters.userName);	
			
		}
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 * Everytime this page is shown
		 */
		
		protected function onShown(evt:Event):void
		{
			if (!Parameters.loggedIn)
			{
				messagePopUp.textField.htmlText = TextSixFlags2010.SOUVENIR_LOGGEDOUT;
				messagePopUp.visible = true;
				messagePopUp.buy_btn.visible = false;
				messagePopUp.login_btn.visible = true;
				setChildIndex(messagePopUp,numChildren-1);
			}
			getAmfFlags();
		}
		
		/**
		 * Finds out how Many Flags the User Has
		 */
		
		protected function getFlags(msg:Object):void
		{
			playersFlags = msg.flags_available;
			updateFlagsTxt(playersFlags);
		}
		
		protected function getFlagsError(msg:Object):void
		{
			trace("getFlagsError: ", msg.toString());
		}
		
		protected function createIconsError(msg:Object):void
		{
			trace("createIconsError: ", msg.toString());
		}
		
		/**
		 * ICONS INFO is returned from PHP
		 */
		protected function createIcons(msg:Object):void
		{
			//Will Return a Array of Arrays (of Icon Info)
			 
			//FAKE RESPONSE for testing
			//msg.result = [[1,1,75,SixFlagsConstants.SOUVENIR_ICON_DUMMY1,"Rollercoaster Design Book"],[14575,2,5000,SixFlagsConstants.SOUVENIR_ICON_DUMMY2,"Faerie Petpet Paint Brush"],[38495,3,500,SixFlagsConstants.SOUVENIR_ICON_DUMMY3,"Gaint Bubble Blower"],[22395,4,100,SixFlagsConstants.SOUVENIR_ICON_DUMMY4,"Punchbag Bob Plushie"]];
			var libPath:String ="";
			
			//Parameters.onlineMode ? libPath = Parameters.imageURL+ "/" + SixFlagsConstants.IMG_PATH_BASE : libPath = SixFlagsConstants.IMG_PATH_BASE;
			
			if (msg.result.valueOf() != 0)
			{
				if (msg.result is Array) // Better be
				{
					var tNumberOfIcons:int = msg.result.length;
					var souvenirNo:int;
					for (var i:int = 0; i < tNumberOfIcons; i++)
					{
						var tSouvenir:SixFlags2010SouvenirItem = new SixFlags2010SouvenirItem(); //LibraryLoader.getLibrarySymbol("Message_popupBox"); ;
						souvenirNo = i+1;
						tSouvenir.init(msg.result[i][0],msg.result[i][1],msg.result[i][2],libPath + msg.result[i][3],msg.result[i][4], "SixFlags2010 - Item "+souvenirNo+" purchased");
						tSouvenir.addEventListener(MouseEvent.CLICK, onIconPopUp, false,0,true);
						addChild(tSouvenir);
						positionIcon(tSouvenir);
						iconArray.push(positionIcon);
					}
				}
			}
		}
		
		
		/**
		 * Handles the Icon Clicks to cause the PopUpBox to appear
		 */
		
		protected function onIconPopUp(evt:MouseEvent):void
		{
			var tSouvenir:SixFlags2010SouvenirItem = evt.currentTarget as SixFlags2010SouvenirItem;
			
			if (tSouvenir._price == 0)
			{
				return;
			}
			
			setChildIndex(messagePopUp, numChildren-1);
			
			messagePopUp.updateMessage(tSouvenir,checkEnoughFlags(tSouvenir));
			
			messagePopUp.visible = true;
			
		}
		
		protected function onLoginRequest(evt:Event):void
		{
			var tURLREQUEST:URLRequest = new URLRequest(Parameters.baseURL + CapriSun2011Constants.LOG_PATH_BASE);
			navigateToURL(tURLREQUEST,"_self");
			messagePopUp.login_btn.visible = false;
			closeMessageWindow();
		}
		
		
		
		protected function closeMessageWindow(evt:Event = null):void
		{
			messagePopUp.visible = false;	
		}
		
		protected function closeInstructionWindow(evt:Event = null):void
		{
			instructionPopUp.visible = false;	
		}
		
		protected function launchInstructions(evt:Event = null):void
		{
			if (instructionPopUp == null)
			{
				var tClass:Class = LibraryLoader.getLibrarySymbol("popup_souvenirInstructions");
				instructionPopUp = new tClass();	
		
				instructionPopUp.x = -187.55;
				instructionPopUp.y = -137.70;
				addChildAt(instructionPopUp,numChildren-1);
				
			
				instructionPopUp.addEventListener(SixFlags2010SouvenirPopup.CLOSE_BTN_EVENT, closeInstructionWindow, false, 0, true);
			}
			
		setChildIndex(instructionPopUp,numChildren-1);
		instructionPopUp.visible = true;
	
		}
		
		protected function onBuyRequest(evt:Event):void
		{
			var responder:Responder = new Responder(onBuyRequestReturn, onBuyRequestError);
			Parameters.connection.call("SixFlagsService.StorePurchaseService", responder,Parameters.userName,messagePopUp.souvenirItem._id );
		}
		
		protected function onBuyRequestError(msg:Object):void
		{
			trace("onBuyRequestError: ", msg.toString());
		}
		
		protected function onBuyRequestReturn(msg:Object):void
		{
			getAmfFlags();
			trace("Item was successful Bought: ", msg.toString());
		}
		
		protected override function handleObjClick(e:CustomEvent):void
		{
			if (this.visible == true)
			{

				trace ("FROM Souvenir PAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)			
				
				switch (e.oData.DATA.parent.name)
				{
					case "InstructionBtn":
						launchInstructions();
					break;
				}
			}
		}
	}
	
}