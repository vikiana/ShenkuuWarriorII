/**
 *	GIFT BAGS STAND POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli
 *	@since  09.16.2009
 */
package com.neopets.games.marketing.destination.lunchablesAwards
{
	import flash.display.MovieClip;

	
	public class PopupGiftsStand extends PopupSimple
	{
		
		//this is the var to establish if the user can get a gift or not. Using a non-descriptive var name to avoid cheating.
		public var miononno:Boolean;
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function PopupGiftsStand(pMessage:String = null, px:Number = 0, py:Number = 0, pTextSize:int = 2, pAutoClose:Boolean= false, eligibleForGift:Boolean=true)
		{
			super(pMessage, px, py, pTextSize, pAutoClose);
			miononno = eligibleForGift;
			setupPageContent();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupPageContent ():void {
			
			addImage("Giftbag_mc", "giftbag", 412, 252);
			mc = getChildByName("giftbag") as MovieClip;
			mc.scaleX = mc.scaleY = 0.6;
			addImage ("GiftBag_inventorymessage", "message2", 222, 390);

			var mc:MovieClip
			var message:String
			if (miononno){
				//Set message after AMFPHP call
				message = "Click on a gift category image to choose your swag bag";
				addTextBox("LAGenericTextBox", "message1", message, 150, 50, 500, 50);

			} else {
				//Set message after AMFPHP call
				mc = getChildByName("message2") as MovieClip;
				mc.gotoAndStop(2);
				message = "You have already picked up your swag bag!";
				addTextBox("LAGenericTextBox", "message1", message, 150, 50, 500, 50);
			}
		}
		
	
		
		
		
		
	}
}