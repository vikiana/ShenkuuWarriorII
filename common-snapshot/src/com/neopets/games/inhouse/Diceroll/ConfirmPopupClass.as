package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
	
	
	
	public class ConfirmPopupClass extends GenericScreenClass {
		
		public var btn_confirmYes: SimpleButton; //on stage
		public var btn_confirmNo: SimpleButton; //on stage
		
		public var txt_btn_yes: TextField; //on stage
		public var txt_btn_no: TextField; //on stage
		public var txt_confirm_roll: TextField; //on stage
		
		
		public function ConfirmPopupClass() {			
			super();						
		}
		
		public function init() {
			//trace("init ConfirmPopup");
			btn_confirmYes.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);			
			btn_confirmNo.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			
			tManager.setTextField(txt_btn_yes, tData.IDS_BTN_YES);			
			tManager.setTextField(txt_btn_no, tData.IDS_BTN_NO);			
			txt_btn_yes.mouseEnabled = false;
			txt_btn_no.mouseEnabled = false;
			tManager.setTextField(txt_confirm_roll, tData.IDS_CONFIRM_ROLL);			
		}
		
	
	
	
	
	}
}

