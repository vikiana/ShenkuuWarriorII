/**
 *	BADGES POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli
 *	@since  09.16.2009
 */
package com.neopets.games.marketing.destination.lunchablesAwards
{
	public class PopupBadges extends PopupSimple
	{
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function PopupBadges(pMessage:String = null, px:Number = 0, py:Number = 0, pTextSize:int = 2, pAutoClose:Boolean= false)
		{
			super(pMessage, px, py, pTextSize, pAutoClose);
			setupPageContent();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupPageContent ():void {
			addImageButton("Badge1_button", "BTSBadge", 249, 172);
			addImageButton("Badge2_button", "TrophyBadge", 523, 176);
			//addTextButton("Text_button", "cancleBtn", "Cancel", 200, 300);
		}
		
	}
}