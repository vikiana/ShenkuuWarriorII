package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
	import virtualworlds.lang.TranslationManager;
	
	
	public class ErrorPopupClass extends GenericScreenClass {
		
		
		public var txt_error_msg: TextField; //on stage
		public var str_error: String = "";
		
		
		public function ErrorPopupClass() {			
			super();						
		}
		
		public function init() {
			trace("init ErrorPopup");							
		}
		
		public function setErrorMsg(p_str:String=""):void {
			if (p_str.length > 1) {				
				str_error = p_str;
			} else {
				str_error = tData.IDS_ERROR_MSG
			}			
			tManager.setTextField(txt_error_msg, str_error);			
			
		}
		
	
	
	
	
	}
}

