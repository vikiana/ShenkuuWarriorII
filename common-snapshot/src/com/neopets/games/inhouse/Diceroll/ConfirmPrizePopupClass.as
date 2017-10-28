package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
	
	
	
	public class ConfirmPrizePopupClass extends GenericScreenClass {
		
		public var btn_confirmPrizeYes: SimpleButton; //on stage
		public var btn_confirmPrizeNo: SimpleButton; //on stage
		
		public var txt_btn_yes: TextField; //on stage
		public var txt_btn_no: TextField; //on stage
		public var txt_confirm_prize: TextField; //on stage
		
		public var dData: Object;
		
		
		public function ConfirmPrizePopupClass() {			
			super();						
			dData = DiceData.instance;
		}
		
		public function init() {
			//trace("init ConfirmPopup");
			btn_confirmPrizeYes.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);			
			btn_confirmPrizeNo.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			
			tManager.setTextField(txt_btn_yes, tData.IDS_BTN_YES);			
			tManager.setTextField(txt_btn_no, tData.IDS_BTN_NO);			
			txt_btn_yes.mouseEnabled = false;
			txt_btn_no.mouseEnabled = false;
			var str_confirm:String = "";
			if (dData.tier < 5) {				
				str_confirm = tData.IDS_CONFIRM_PRIZE1.replace("%1",dData.prize1name);
				tManager.setTextField(txt_confirm_prize, str_confirm);			
			} else if (dData.tier==5) {
				str_confirm = tData.IDS_CONFIRM_PRIZEB.replace("%1",dData.prize1name);
				tManager.setTextField(txt_confirm_prize, str_confirm);			
			} else if (dData.tier==6) {
				str_confirm = tData.IDS_CONFIRM_PRIZE2.replace("%1",dData.prize1name);
				str_confirm = str_confirm.replace("%2",dData.prize2name);
				tManager.setTextField(txt_confirm_prize, str_confirm);			
			}
		}
		
	
	
	
	
	}
}

