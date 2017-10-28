/* AS3
Copyright 2010
*/

package com.neopets.games.marketing.destination.sixFlags2010.subElements
{
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.games.marketing.destination.sixFlags2010.text.TextSixFlags2010;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  5.18.2010
	 */
	
	public class SixFlags2010SouvenirPopup extends MovieClip
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLOSE_BTN_EVENT:String = "closeBtnClicked";
		public static const LOGIN_BTN_EVENT:String = "UserNeeds to Login";
		public static const BUY_BTN_EVENT:String = "UserWantsToBuy";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var close_btn:HiButton; //Onstage
		public var login_btn:HiButton; //Onstage
		public var buy_btn:HiButton; //Onstage
		public var textField:TextField; //OnStage
		public var no_btn:HiButton;
		public var yes_btn:HiButton;
		
		protected var mSouvenirItem:SixFlags2010SouvenirItem;
		
		private var _adLink:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SixFlags2010SouvenirPopup()
		{
			
			close_btn.buttonMode = true; 
			login_btn.buttonMode = true;
			buy_btn.buttonMode = true;
			no_btn.buttonMode = true;
			yes_btn.buttonMode = true;
			
			close_btn.addEventListener(MouseEvent.CLICK, closePopUp, false, 0, true);
			login_btn.addEventListener(MouseEvent.CLICK, loginButtonClicked, false, 0, true);
			login_btn.visible = false;
			buy_btn.addEventListener(MouseEvent.CLICK, buyClicked, false, 0, true);
			no_btn.addEventListener(MouseEvent.CLICK, noClicked, false, 0, true);
			yes_btn.addEventListener(MouseEvent.CLICK, userBuysItem, false, 0, true);
			no_btn.visible = false;
			yes_btn.visible = false;
			
			
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get souvenirItem():SixFlags2010SouvenirItem
		{
			return mSouvenirItem;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function updateMessage(pSouvenir:SixFlags2010SouvenirItem, pEnough:Boolean):void
		{
			no_btn.visible = false;
			yes_btn.visible = false;
			mSouvenirItem = pSouvenir;
			
			var tResultStr:String;
			
			if (Parameters.loggedIn)
			{
				if (pEnough) // User Has enough to Buy the Item
				{
					tResultStr = mSouvenirItem._text + "<BR>" + String(mSouvenirItem._price) + TextSixFlags2010.SOUVENIR_CLICKTOBUY;
					buy_btn.visible = true;
				}
				else // User Does Not have enough to Buy the Item
				{	
					buy_btn.visible = false;
					tResultStr = mSouvenirItem._text + "<BR>" + String(mSouvenirItem._price) + TextSixFlags2010.SOUVENIR_CANTBUY;
					
				}
			}
			else
			{
				tResultStr = mSouvenirItem._text + "<BR>" + String(mSouvenirItem._price) + " Flags<BR> Click below to log in now to buy item";	
				login_btn.visible = true;
				buy_btn.visible = false;
			}
			
			textField.htmlText = tResultStr;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		protected function closePopUp(evt:Event):void
		{
			this.dispatchEvent(new Event(SixFlags2010SouvenirPopup.CLOSE_BTN_EVENT));	
		}
		
		protected function loginButtonClicked (evt:Event):void
		{
			dispatchEvent(new Event(SixFlags2010SouvenirPopup.LOGIN_BTN_EVENT));
		}
		
		protected function buyClicked (evt:Event):void
		{
			//Change the Prompt to Make Sure
			var tResultStr:String;
			
			tResultStr = "Are you sure you want to buy " + mSouvenirItem._text + " for " + String(mSouvenirItem._price) + " Flags";	
			login_btn.visible = false;
			buy_btn.visible = false;
			no_btn.visible = true;
			yes_btn.visible = true;
			textField.htmlText = tResultStr;
			_adLink = mSouvenirItem.adLink;
		}
		
		
		protected function userBuysItem(evt:MouseEvent):void
		{
			var tResultStr:String;
			
			no_btn.visible = false;
			yes_btn.visible = false;
			
			//tResultStr = TextSixFlags2010.SOUVENIR_CONGRATS1+"<a href='http://www.neopets.com/objects.phtml?type=inventory'>here</a>"+TextSixFlags2010.SOUVENIR_CONGRATS2;	
			tResultStr = "<a href='http://www.neopets.com/objects.phtml?type=inventory'>"+TextSixFlags2010.SOUVENIR_CONGRATS+"</a>";
			textField.htmlText = tResultStr;
			
			TrackingProxy.sendADLinkCall(_adLink);
			
			dispatchEvent(new Event(SixFlags2010SouvenirPopup.BUY_BTN_EVENT));
		}
		
		protected function noClicked(evt:Event):void
		{
			this.dispatchEvent(new Event(SixFlags2010SouvenirPopup.CLOSE_BTN_EVENT));	
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
}

